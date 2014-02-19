//
//  TwoColorTwinPanelView.m
//  RotatingImageButton
//
//  Created by Matt Glover on 17/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "TwoColorTwinPanelView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kPanelRectInset = 10.0f; // allows for smaller disc whilst maintain a larger hitspot for view

@interface TwoColorTwinPanelView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation TwoColorTwinPanelView

- (id)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame firstColor:[UIColor blackColor] secondColor:[UIColor whiteColor]];
}

- (id)initWithFrame:(CGRect)frame firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor {
  if (self = [super initWithFrame:frame]) {
    [self initTwinPanelLayerWithFirstColor:firstColor secondColor:secondColor];
    [self setupGestureRecogniser];
  }
  return self;
}

#pragma mark - Setup
- (void)initTwinPanelLayerWithFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor {
  
  _gradientLayer = [CAGradientLayer layer];
  _gradientLayer.bounds = CGRectInset(self.bounds, kPanelRectInset, kPanelRectInset);
  _gradientLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
  _gradientLayer.colors = @[ (id)firstColor.CGColor, (id)firstColor.CGColor, (id)secondColor.CGColor, (id)secondColor.CGColor ];
  _gradientLayer.locations = @[ @(0.0), @(0.5), @(0.5), @(1.0) ];
  _gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
  _gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
  
  [self.layer addSublayer:_gradientLayer];
}

#pragma mark - UI Update
- (void)updateWithFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor {
  self.gradientLayer.colors = @[ (id)firstColor.CGColor, (id)firstColor.CGColor, (id)secondColor.CGColor, (id)secondColor.CGColor ];
}

#pragma mark - Gesture Recogniser
- (void)setupGestureRecogniser {
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
  [self addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)sender {
  if ([self.delegate respondsToSelector:@selector(didSelectTwoColorTwinPanelView:)]) {
    [self.delegate didSelectTwoColorTwinPanelView:self];
  }
}

@end
