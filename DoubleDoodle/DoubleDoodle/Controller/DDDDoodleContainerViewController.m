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

typedef NS_ENUM (NSUInteger, TransitionType) {
  TransitionTypeCircle,
  TransitionTypeSideBySide,
  TransitionTypeFromSideBySide
};

@interface DDDDoodleContainerViewController () <DDDDoodleViewControllerDelegate>

@property (nonatomic, copy) NSString *xml;

@property (nonatomic, strong) DDDDoodleViewController *firstDoodleViewController;
@property (nonatomic, strong) DDDDoodleViewController *secondDoodleViewController;

@property (nonatomic, assign) BOOL transitionInProgress;

@end

@implementation DDDDoodleContainerViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
  NSLog(@"Should use designated initializer initWithXML:");
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
  
  self.view.backgroundColor = [UIColor redColor];
  
  [self setupChildDoodleViewControllers];
  [self setupTransitionButtons];
  [self setupSavePhotoButton];
}

#pragma mark - Setup
- (void)setupChildDoodleViewControllers {
  
  self.firstDoodleViewController = [[DDDDoodleViewController alloc] initWithXML:@"" withDelegate:self];
  self.secondDoodleViewController= [[DDDDoodleViewController alloc] initWithXML:@"x" withDelegate:self];
  
  // Adding to Child View Controllers
  [self.firstDoodleViewController willMoveToParentViewController:self];
  [self.secondDoodleViewController willMoveToParentViewController:self];
  
  [self addChildViewController:self.firstDoodleViewController];
  [self addChildViewController:self.secondDoodleViewController];
  
  // Apply a transform to the views
  [self performTransition:TransitionTypeCircle frontView:self.firstDoodleViewController.doodleView backView:self.secondDoodleViewController.doodleView animated:NO completion:^(BOOL finished) {
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

- (void)setupSavePhotoButton {
  UIBarButtonItem *savePhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(savePhoto:)];
  [self.navigationItem setRightBarButtonItem:savePhotoButton];
}

#pragma mark - UIBarButtonItem Listeners
- (void)swapViews:(UIBarButtonItem *)sender {
  self.transitionInProgress = YES;
  
  DDDDoodleView *toBackView = [self.firstDoodleViewController isDoodleViewTransformed] ? self.firstDoodleViewController.doodleView : self.secondDoodleViewController.doodleView;
  DDDDoodleView *toFrontView = [self.firstDoodleViewController isDoodleViewTransformed]  ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
  
  [self performTransition:TransitionTypeCircle frontView:toFrontView backView:toBackView animated:YES completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

- (void)sideBySideViews:(UIBarButtonItem *)sender {
  self.transitionInProgress = YES;
  
  [self performTransition:TransitionTypeSideBySide frontView:nil backView:nil animated:YES completion:^(BOOL finished) {
    self.transitionInProgress = NO;
  }];
}

- (void)savePhoto:(UIBarButtonItem *)sender {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    UIImage *image = [UIImage imageWithView:self.firstDoodleViewController.doodleView];
    
    [[DDDPhotoPersistanceManager sharedManager] saveImageToCameraRoll:image completion:^(BOOL success, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
          NSLog(@"Image Saved Successfully");
        } else {
          NSLog(@"%@", error);
        }
      });
    }];
  });
}

#pragma mark - DDDDoodleViewControllerDelegate
- (void)didSelectDoodleViewController:(DDDDoodleViewController *)controller {
  self.transitionInProgress = YES;
  
  if ([self isCurrentlySideBySideView]) {
    DDDDoodleView *toBackView = (controller == self.firstDoodleViewController) ? self.secondDoodleViewController.doodleView : self.firstDoodleViewController.doodleView;
    [self performTransition:TransitionTypeFromSideBySide frontView:controller.doodleView backView:toBackView animated:YES completion:^(BOOL finished) {
      self.transitionInProgress = NO;
    }];
  }
}

- (BOOL)isCurrentlySideBySideView {
  return [self.firstDoodleViewController isDoodleViewTransformed] && [self.secondDoodleViewController isDoodleViewTransformed];
}

#pragma mark - Transition Dispatcher
- (void)performTransition:(TransitionType)transition frontView:(DDDDoodleView *)frontView backView:(DDDDoodleView *)backView animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
  
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

- (DDDDoodleViewController *)frontMostDoodleViewController {
  
  DDDDoodleViewController *frontMostDoodleViewController;
  if (![self isCurrentlySideBySideView]) {
    frontMostDoodleViewController = [self.firstDoodleViewController isDoodleViewTransformed] ? self.secondDoodleViewController : self.firstDoodleViewController;
  }
  
  return frontMostDoodleViewController;
}

@end
