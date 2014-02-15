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

@interface DDDDoodleViewController ()

@property (nonatomic, strong) DDDDoodleView *doodleView;

@end

@implementation DDDDoodleViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
  NSLog(@"Should use designated initializer initWithXML:");
  return [self initWithXML:@""];
}

// Designated Initializer
- (id)initWithXML:(NSString *)xml {
  if (self = [super init]) {
  
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
  
  [self setupBackground];
  
  UIColor *backgroundColor = [UIColor blackColor];
  UIColor *lineStrokeColor = [UIColor whiteColor];
  [self setupDoodleViewWithBackgroundColor:backgroundColor lineStrokeColor:lineStrokeColor];
}

#pragma mark - Setup
- (void)setupBackground {
  self.view.backgroundColor = [UIColor yellowColor];
}

- (void)setupDoodleViewWithBackgroundColor:(UIColor *)backgroundColor lineStrokeColor:(UIColor *)lineStrokeColor {

  self.doodleView = [[DDDDoodleView alloc] initWithFrame:[self doodleViewFrame]];
  [self.doodleView setBackgroundColor:backgroundColor];
  [self.doodleView setLineColor:lineStrokeColor];
  
  [self.view addSubview:self.doodleView];
}

#pragma mark - Private Helper Methods - Frame/Rect
- (CGRect)doodleViewFrame {
  CGRect entireViewBounds = self.view.bounds;
  CGRect doodleViewFrame = CGRectInset(entireViewBounds, kDoodleViewFrameInsetX, kDoodleViewFrameInsetY);
  doodleViewFrame.origin.y = kDoodleViewOriginPositionY;
  
  return doodleViewFrame;
}

@end
