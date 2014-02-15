//
//  DDDDoodleViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleViewController.h"
#import "DDDDoodleView.h"

static CGFloat const kDoodleViewInsetX = 10.0f;
static CGFloat const kDoodleViewInsetY = 40.0f;
static CGFloat const kDoodleViewOriginPositionY = 10.0f;

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
  
  UIColor *backgroundColor = [UIColor blackColor];
  UIColor *lineStrokeColor = [UIColor whiteColor];
  [self setupDoodleViewWithBackgroundColor:backgroundColor lineStrokeColor:lineStrokeColor];
}

#pragma mark - Setup
- (void)setupDoodleViewWithBackgroundColor:(UIColor *)backgroundColor lineStrokeColor:(UIColor *)lineStrokeColor {
 
  CGRect entireViewBounds = self.view.bounds;
  CGRect doodleViewFrame = CGRectInset(entireViewBounds, kDoodleViewInsetX, kDoodleViewInsetY);
  doodleViewFrame.origin.y = kDoodleViewOriginPositionY;
  self.doodleView = [[DDDDoodleView alloc] initWithFrame:doodleViewFrame];
  
  [self.view addSubview:self.doodleView];
}


@end
