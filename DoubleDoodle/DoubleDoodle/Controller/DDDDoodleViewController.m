//
//  DDDDoodleViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleViewController.h"
#import "DDDDoodleView.h"
#import "DDDDoodleViewConfig.h"

static CGFloat const kDoodleViewFrameInsetX = 10.0f;
static CGFloat const kDoodleViewFrameInsetY = 70.0f;
static CGFloat const kDoodleViewOriginPositionY = 20.0f + 44.0f + 10.0f;
static CGFloat const kDoodleViewLineWidth = 4.0f;

@interface DDDDoodleViewController ()<DDDDoodleViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign, getter = isDoodleViewEnabled) BOOL doodleViewEnabled;

@end

@implementation DDDDoodleViewController

#pragma mark - Initializers
- (id)initWithDoodleViewConfiguration:(DDDDoodleViewConfig *)configuration delegate:(id<DDDDoodleViewControllerDelegate>)delegate {
  if (self = [super init]) {
    _delegate = delegate;
    [self initDoodleViewWithBackgroundColor:configuration.backgroundColor lineStrokeColor:configuration.foregroundColor];
  }
  return self;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"%s", __FUNCTION__);
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - Setup
- (void)initDoodleViewWithBackgroundColor:(UIColor *)backgroundColor lineStrokeColor:(UIColor *)lineStrokeColor {
  
  _doodleView = [[DDDDoodleView alloc] initWithFrame:[self doodleViewFrame]];
  [_doodleView setDelegate:self];
  [_doodleView setBackgroundColor:backgroundColor];
  [_doodleView setLineColor:lineStrokeColor];
  [_doodleView setLineWidth:kDoodleViewLineWidth];
  
  [self configureGestureRecognisersForDoodleView:_doodleView];
  
  [self.view addSubview:_doodleView];
}

- (void)configureGestureRecognisersForDoodleView:(DDDDoodleView *)doodleView {
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doodleViewTapped:)];
  UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doodleViewSwipeUp:)];
  [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
  [swipeUpGesture setDelegate:self];
  
  [doodleView addGestureRecognizer:tapGesture];
  [doodleView addGestureRecognizer:swipeUpGesture];
}

#pragma mark - Update UI
- (void)updateWithDoodleViewConfiguration:(DDDDoodleViewConfig *)configuration {
  self.doodleView.backgroundColor = configuration.backgroundColor;
  self.doodleView.lineColor = configuration.foregroundColor;
}

#pragma mark - DDDDoodleView Delegate
- (BOOL)canDrawOnDoodleView:(DDDDoodleView *)doodleView {
  return [self isDoodleViewEditable];
}

#pragma mark - Transform Helper
- (BOOL)isDoodleViewEditable {
  return CGAffineTransformIsIdentity(self.doodleView.transform);
}

#pragma mark - Tap Gesture Recogniser
- (void)doodleViewTapped:(UIGestureRecognizer *)sender {
  if ([self.delegate respondsToSelector:@selector(didSelectDoodleViewController:)]) {
    [self.delegate didSelectDoodleViewController:self];
  }
}

- (void)doodleViewSwipeUp:(UISwipeGestureRecognizer *)gesture {
  if(gesture.state == UIGestureRecognizerStateRecognized && [self canClearDoodleView]) {
    [self presentConfirmClearAlert];
  }
}

- (void)presentConfirmClearAlert {
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm Clear", nil)
                              message:nil
                             delegate:self
                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                    otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil]
   show];
}

#pragma mark - UIGestureRecogniser Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return ([self isDoodleViewEditable]) ? NO : YES;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self.doodleView clear];
  }
}

- (UIColor *)representativeDoodleViewColor {
  return self.doodleView.backgroundColor;
}

#pragma mark - Private Helper Methods - Frame/Rect
- (CGRect)doodleViewFrame {
  CGRect entireViewBounds = self.view.bounds;
  CGRect doodleViewFrame = CGRectInset(entireViewBounds, kDoodleViewFrameInsetX, kDoodleViewFrameInsetY);
  doodleViewFrame.origin.y = kDoodleViewOriginPositionY;
  
  return doodleViewFrame;
}

// Can only clear if Doodle View is not in editable state
- (BOOL)canClearDoodleView {
  return ![self isDoodleViewEditable];
}

@end
