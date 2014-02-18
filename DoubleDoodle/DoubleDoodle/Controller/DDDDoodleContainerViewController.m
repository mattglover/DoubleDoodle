//
//  DDDDoodleContainerViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleContainerViewController.h"
#import "DDDDoodleViewController.h"
#import "DDDDoodleView.h"
#import "DDDDoodleContainerViewController+DoodleViewTransitions.h"
#import "UIImage+UIViews.h"
#import "DDDPhotoPersistanceManager.h"
#import "SVProgressHUD.h"
#import "RotatingTwoColorDiscView.h"
#import "TwoColorTwinPanelView.h"

typedef NS_ENUM (NSUInteger, TransitionType) {
  TransitionTypeCircle,
  TransitionTypeSideBySide,
  TransitionTypeFromSideBySide
};

@interface DDDDoodleContainerViewController () <DDDDoodleViewControllerDelegate, RotatingTwoColorDiscViewDelegate, TwoColorTwinPanelViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) NSString *xml;

@property (nonatomic, strong) DDDDoodleViewController *firstDoodleViewController;
@property (nonatomic, strong) DDDDoodleViewController *secondDoodleViewController;

@property (nonatomic, strong) RotatingTwoColorDiscView *swapViewsButton;
@property (nonatomic, strong) TwoColorTwinPanelView *sideBySidePanelViewButton;
@property (nonatomic, strong) UIBarButtonItem *saveDoodleImageButton;

@property (nonatomic, assign) BOOL transitionInProgress;

@end

@implementation DDDDoodleContainerViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
  return [self initWithXML:@""];
}

// Designated Initializer
- (id)initWithXML:(NSString *)xml {
  if (self = [super init]) {
    _xml = xml;
  }
  return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = NSLocalizedString(@"Double Doodle", nil);
  self.view.tintColor = [UIColor blackColor];
  
  [self setupBackground];
  [self setupChildDoodleViewControllers];
  
  [self setupSwapViewsButton];
  [self setupSideBySideViewsButton];
  [self setupSaveDoodleImageButton];
  
  [self presentSaveDoodleImageButtonAnimated:NO];
}

#pragma mark - Setup
- (void)setupBackground {
  self.view.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1.0];
}

- (void)setupChildDoodleViewControllers {
  
  self.firstDoodleViewController = [[DDDDoodleViewController alloc] initWithXML:@"" withDelegate:self];
  self.secondDoodleViewController= [[DDDDoodleViewController alloc] initWithXML:@"x" withDelegate:self];
  
  // Adding Child View Controllers
  [self.firstDoodleViewController willMoveToParentViewController:self];
  [self.secondDoodleViewController willMoveToParentViewController:self];
  
  [self addChildViewController:self.firstDoodleViewController];
  [self addChildViewController:self.secondDoodleViewController];
  
  // Setup initial view - i.e. Apply a transform to the views (send backView to the back)
  [self performTransition:TransitionTypeCircle
                frontView:self.firstDoodleViewController.doodleView
                 backView:self.secondDoodleViewController.doodleView
                 animated:NO
               completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
  
  // Add them in reverse order so First View Controller is on top of second
  [self.view addSubview:self.secondDoodleViewController.doodleView];
  [self.view addSubview:self.firstDoodleViewController.doodleView];
  
  [self.firstDoodleViewController didMoveToParentViewController:self];
  [self.secondDoodleViewController didMoveToParentViewController:self];
}

- (void)setupSwapViewsButton {
  self.swapViewsButton = [[RotatingTwoColorDiscView alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(self.view.frame) - 60, 50, 50) firstColor:[UIColor blackColor] secondColor:[UIColor whiteColor]];
  self.swapViewsButton.delegate = self;
  [self.view addSubview:self.swapViewsButton];
}

- (void)setupSideBySideViewsButton {
  self.sideBySidePanelViewButton = [[TwoColorTwinPanelView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 100, CGRectGetHeight(self.view.frame) - 60, 70, 50) firstColor:[UIColor blackColor] secondColor:[UIColor whiteColor]];
  [self.sideBySidePanelViewButton setDelegate:self];
  [self.view addSubview:self.sideBySidePanelViewButton];
}

- (void)setupSaveDoodleImageButton {
  if (!self.saveDoodleImageButton) {
    self.saveDoodleImageButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                         target:self
                                                                         action:@selector(saveDoodleImageButtonTapped:)];
  }
}

#pragma mark - Save DoodleImage Bar Button Item
- (void)presentSaveDoodleImageButtonAnimated:(BOOL)animated {
  [self.navigationItem setRightBarButtonItem:self.saveDoodleImageButton animated:animated];
}

- (void)removeSaveDoodleImageButtonAnimated:(BOOL)animated {
  [self.navigationItem setRightBarButtonItem:nil animated:animated];
}

#pragma mark - Swap View
- (void)swapViews:(RotatingTwoColorDiscView *)discView {
  
  [self presentSaveDoodleImageButtonAnimated:YES];
  
  DDDDoodleView *toBackView = [self frontMostDoodleViewController] == self.firstDoodleViewController ? self.firstDoodleViewController.doodleView : self.secondDoodleViewController.doodleView;
  DDDDoodleView *toFrontView = [self frontMostDoodleViewController] == self.firstDoodleViewController ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
  
  RotatingDiscViewDirection direction = [self frontMostDoodleViewController] == self.firstDoodleViewController ? RotatingDiscViewDirectionAntiClockwise : RotatingDiscViewDirectionClockwise;
  [discView animateWithDuration:DDDDoodleContainerViewControllerDefaultAnimationDuration
                      direction:direction
                  withCompleton:nil];
  
  [self performTransition:TransitionTypeCircle
                frontView:toFrontView
                 backView:toBackView
                 animated:YES
               completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

#pragma mark - TwoColorTwinPanelView Delegate
- (void)sideBySideViewsTapped:(TwoColorTwinPanelView *)sender {
  
  [self removeSaveDoodleImageButtonAnimated:YES];
  
  [self performTransition:TransitionTypeSideBySide
                frontView:nil
                 backView:nil
                 animated:YES
               completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

#pragma mark - Bar Button Item Interactions
- (void)saveDoodleImageButtonTapped:(UIBarButtonItem *)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                 destructiveButtonTitle:NSLocalizedString(@"Save to Camera Roll", nil)
                      otherButtonTitles:nil];
  [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - RotatingDiscView Delegate
- (void)didSelectRotatingDiscView:(RotatingTwoColorDiscView *)view {
  if([self canRespondToUserButtonTaps]) {
     [self swapViews:view];
  }
}

#pragma mark - TwoColorTwinPanelView Delegate
- (void)didSelectTwoColorTwinPanelView:(TwoColorTwinPanelView *)view {
  if([self canRespondToUserButtonTaps]) {
    [self sideBySideViewsTapped:view];
  }
}

#pragma mark - DDDDoodleViewController Delegate
- (void)didSelectDoodleViewController:(DDDDoodleViewController *)controller {
  
  // User has tapped on a DoodleView
  // If we are currently displaying sideBySide then dispatch - TransitionTypeFromSideBySide
  if ([self isCurrentlySideBySide]) {
    DDDDoodleView *toBackView = (controller == self.firstDoodleViewController) ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
    
    [self performTransition:TransitionTypeFromSideBySide
                  frontView:controller.doodleView
                   backView:toBackView
                   animated:YES
                 completion:^(BOOL finished) {
                   
      [self presentSaveDoodleImageButtonAnimated:YES];
      self.transitionInProgress = NO;
    }];
  }
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (buttonIndex == 0) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      
      UIImage *image = [UIImage imageWithView:[self frontMostDoodleViewController].doodleView];
      
      [[DDDPhotoPersistanceManager sharedManager] saveImageToCameraRoll:image completion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (success) {
            [self handleSaveImageSuccess];
          } else {
            [self handleSaveImageError:error];
          }
        });
      }];
    });
  }
}

- (void)handleSaveImageSuccess {
  [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Image Saved", nil)];
}

- (void)handleSaveImageError:(NSError *)error {
  NSString *errorMessage = (error.code == -3310) ? NSLocalizedString(@"Save Image Error - No Permission", nil) : NSLocalizedString(@"Save Image Error - Unknown", nil) ;
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                              message:errorMessage
                             delegate:nil
                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                    otherButtonTitles:nil]
   show];
}

#pragma mark - Transition Dispatcher
// All DoodleView Transitions for this Container View Controller go through this Method
- (void)performTransition:(TransitionType)transition
                frontView:(DDDDoodleView *)frontView
                 backView:(DDDDoodleView *)backView
                 animated:(BOOL)animated
               completion:(void(^)(BOOL finished))completion {
  
  self.transitionInProgress = YES;
  
  switch (transition) {
    case TransitionTypeCircle: {
      DoodleViewAnimationDirection direction = (frontView == self.firstDoodleViewController.doodleView) ? DoodleViewAnimationDirectionAntiClockwise: DoodleViewAnimationDirectionClockwise;
      [self performTransitionCarouselToBackView:backView
                                    toFrontView:frontView
                                       animated:animated
                                      direction:direction
                                     completion:completion];
    }
      break;
      
    case TransitionTypeSideBySide:
      [self performTransitionSideBySideLeftView:self.firstDoodleViewController.doodleView
                                      rightView:self.secondDoodleViewController.doodleView
                                       animated:animated
                                     completion:completion];
      break;
      
    case TransitionTypeFromSideBySide:
      [self performTransitionFromSideBySideWithToFrontView:frontView
                                                toBackView:backView
                                                  animated:YES
                                                completion:completion];
      break;
      
      default:
        self.transitionInProgress = NO;
      break;
  }
}

#pragma mark - Private Helper - Front Most ViewController
- (DDDDoodleViewController *)frontMostDoodleViewController {
  
  DDDDoodleViewController *frontMostDoodleViewController;
  if (![self isCurrentlySideBySide]) {
    frontMostDoodleViewController = [self.firstDoodleViewController isDoodleViewEditable] ? self.firstDoodleViewController : self.secondDoodleViewController;
  }
  
  return frontMostDoodleViewController;
}

#pragma mark - Private Helper - Currently Displaying Side by Side
- (BOOL)isCurrentlySideBySide {
  return ![self.firstDoodleViewController isDoodleViewEditable] && ![self.secondDoodleViewController isDoodleViewEditable];
}

#pragma mark - Private Helper - Can Respond User Button Taps
- (BOOL)canRespondToUserButtonTaps {
  return !self.transitionInProgress && ![self isCurrentlySideBySide];
}

@end
