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

typedef NS_ENUM (NSUInteger, TransitionType) {
  TransitionTypeCircle,
  TransitionTypeSideBySide,
  TransitionTypeFromSideBySide
};

@interface DDDDoodleContainerViewController () <DDDDoodleViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) NSString *xml;

@property (nonatomic, strong) DDDDoodleViewController *firstDoodleViewController;
@property (nonatomic, strong) DDDDoodleViewController *secondDoodleViewController;

@property (nonatomic, strong) UIBarButtonItem *savePhotoButton;

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
  
  self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
  
  [self setupChildDoodleViewControllers];
  [self setupTransitionButtons];
  [self presentSavePhotoButtonAnimated:NO];
}

#pragma mark - Setup
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

- (void)setupTransitionButtons {
  UIBarButtonItem *swapViewsButton  = [[UIBarButtonItem alloc] initWithTitle:@"Sw" style:UIBarButtonItemStyleBordered target:self action:@selector(swapViews:)];
  UIBarButtonItem *sideBySideButton = [[UIBarButtonItem alloc] initWithTitle:@"Sd" style:UIBarButtonItemStyleBordered target:self action:@selector(sideBySideViews:)];
  [self.navigationItem setLeftBarButtonItems:@[ swapViewsButton, sideBySideButton]];
}

#pragma mark - Save Photo Bar Button Item
- (void)presentSavePhotoButtonAnimated:(BOOL)animated {
  if (!self.savePhotoButton) {
    self.savePhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(savePhotoButtonTapped:)];
  }
  [self.navigationItem setRightBarButtonItem:self.savePhotoButton animated:animated];
}

- (void)removeSavePhotoButtonAnimated:(BOOL)animated {
  [self.navigationItem setRightBarButtonItem:nil animated:animated];
}

#pragma mark - UIBarButtonItem Listeners
- (void)swapViews:(UIBarButtonItem *)sender {
  self.transitionInProgress = YES;
  
  DDDDoodleView *toBackView = [self frontMostDoodleViewController] == self.firstDoodleViewController ? self.firstDoodleViewController.doodleView : self.secondDoodleViewController.doodleView;
  DDDDoodleView *toFrontView = [self frontMostDoodleViewController] == self.firstDoodleViewController ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
  
  [self performTransition:TransitionTypeCircle
                frontView:toFrontView
                 backView:toBackView
                 animated:YES
               completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

- (void)sideBySideViews:(UIBarButtonItem *)sender {
  self.transitionInProgress = YES;
  
  [self removeSavePhotoButtonAnimated:YES];
  
  [self performTransition:TransitionTypeSideBySide
                frontView:nil
                 backView:nil
                 animated:YES
               completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

- (void)savePhotoButtonTapped:(UIBarButtonItem *)sender {
  
  [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save to Camera Roll" otherButtonTitles:nil] showInView:self.view];
}

#pragma mark - DDDDoodleViewControllerDelegate
- (void)didSelectDoodleViewController:(DDDDoodleViewController *)controller {
  self.transitionInProgress = YES;
  
  // User has tapped on a DoodleView
  // If we are currently displaying sideBySide then dispatch - TransitionTypeFromSideBySide
  if ([self isCurrentlySideBySideView]) {
    DDDDoodleView *toBackView = (controller == self.firstDoodleViewController) ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
    [self performTransition:TransitionTypeFromSideBySide
                  frontView:controller.doodleView
                   backView:toBackView animated:YES
                 completion:^(BOOL finished) {
      [self presentSavePhotoButtonAnimated:YES];
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
            [SVProgressHUD showSuccessWithStatus:@"Image Saved"];
          } else {
            [SVProgressHUD showErrorWithStatus:@"Error saving Image"];
          }
        });
      }];
    });
  } else {
    NSLog(@"Action Sheet - Cancel");
  }
}

#pragma mark - Transition Dispatcher
- (void)performTransition:(TransitionType)transition
                frontView:(DDDDoodleView *)frontView
                 backView:(DDDDoodleView *)backView
                 animated:(BOOL)animated
               completion:(void(^)(BOOL finished))completion {
  
  switch (transition) {
    case TransitionTypeCircle:
      [self performTransitionCarouselToBackView:backView
                                    toFrontView:frontView
                                       animated:animated
                                     completion:completion];
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
  }
}

#pragma mark - Private Helper - Front Most ViewController
- (DDDDoodleViewController *)frontMostDoodleViewController {
  
  DDDDoodleViewController *frontMostDoodleViewController;
  if (![self isCurrentlySideBySideView]) {
    frontMostDoodleViewController = [self.firstDoodleViewController isDoodleViewTransformed] ? self.secondDoodleViewController : self.firstDoodleViewController;
  }
  
  return frontMostDoodleViewController;
}

#pragma mark - Private Helper - Currently Displaying Side by Side
- (BOOL)isCurrentlySideBySideView {
  return [self.firstDoodleViewController isDoodleViewTransformed] && [self.secondDoodleViewController isDoodleViewTransformed];
}

@end
