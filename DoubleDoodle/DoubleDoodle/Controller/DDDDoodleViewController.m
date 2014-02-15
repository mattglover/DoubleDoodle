//
//  DDDDoodleViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleViewController.h"
#import "DDDDoodleView.h"

static CGFloat const kDoodleViewFrameInsetX = 10.0f;
static CGFloat const kDoodleViewFrameInsetY = 70.0f;
static CGFloat const kDoodleViewOriginPositionY = 20.0f + 44.0f + 10.0f;
static CGFloat const kDoodleViewLineWidth = 4.0f;

@interface DDDDoodleViewController () <DDDDoodleViewDelegate>

@property (nonatomic, copy) NSString *xml;
@property (nonatomic, assign, getter = isDoodleViewEnabled) BOOL doodleViewEnabled;

@end

@implementation DDDDoodleViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
  NSLog(@"Should use designated initializer initWithXML:");
  return [self initWithXML:@"" withDelegate:nil];
}

// Designated Initializer
- (id)initWithXML:(NSString *)xml withDelegate:(id<DDDDoodleViewControllerDelegate>)delegate {
  if (self = [super init]) {
    _xml = xml;
    _delegate = delegate;
    
    [self setupBackground];
    
    UIColor *backgroundColor = [self.xml isEqualToString:@""] ? [UIColor blackColor] :[UIColor whiteColor];
    UIColor *lineStrokeColor = [self.xml isEqualToString:@""] ? [UIColor whiteColor] :[UIColor blackColor];
    [self initDoodleViewWithBackgroundColor:backgroundColor lineStrokeColor:lineStrokeColor];
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
- (void)setupBackground {
  self.view.backgroundColor = [UIColor clearColor];
}

- (void)initDoodleViewWithBackgroundColor:(UIColor *)backgroundColor lineStrokeColor:(UIColor *)lineStrokeColor {

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doodleViewTapped:)];
  
  _doodleView = [[DDDDoodleView alloc] initWithFrame:[self doodleViewFrame]];
  [_doodleView setDelegate:self];
  [_doodleView setBackgroundColor:backgroundColor];
  [_doodleView setLineColor:lineStrokeColor];
  [_doodleView setLineWidth:kDoodleViewLineWidth];
  [_doodleView addGestureRecognizer:tapGesture];
  
  [self.view addSubview:_doodleView];
}

#pragma mark - DDDDoodleView Delegate
- (BOOL)canDrawOnDoodleView:(DDDDoodleView *)doodleView {
  return ![self isDoodleViewTransformed];
}

#pragma mark - Transform Helper
- (BOOL)isDoodleViewTransformed {
  return !CGAffineTransformIsIdentity(self.doodleView.transform);
}

#pragma mark - Tap Gesture Recogniser Listener
- (void)doodleViewTapped:(UIGestureRecognizer *)sender {
  if ([self.delegate respondsToSelector:@selector(didSelectDoodleViewController:)]) {
    [self.delegate didSelectDoodleViewController:self];
  }
}

#pragma mark - Private Helper Methods - Frame/Rect
- (CGRect)doodleViewFrame {
  CGRect entireViewBounds = self.view.bounds;
  CGRect doodleViewFrame = CGRectInset(entireViewBounds, kDoodleViewFrameInsetX, kDoodleViewFrameInsetY);
  doodleViewFrame.origin.y = kDoodleViewOriginPositionY;
  
  return doodleViewFrame;
}

@end
