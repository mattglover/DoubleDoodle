//
//  RotatingDiscView.m
//  RotatingDiscView
//
//  Created by Matt Glover on 17/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "RotatingTwoColorDiscView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const k180Degress = (180 * M_PI / 180);
static NSString * const kTranformKeyPath = @"transform.rotation";
static CGFloat const kDiskRectInsetDelta = 10.0f; // allows for smaller disc whilst maintain a larger hitspot for view

@interface RotatingTwoColorDiscView ()
@property (nonatomic, strong) CALayer *rotatingLayer;
@property (nonatomic, assign, getter = isAnimating) BOOL animating;
@property (nonatomic, copy) RotatingDiscViewCompletionBlock animationCompletionBlock;
@end

@implementation RotatingTwoColorDiscView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initRotatingLayer];
    [self setupGestureRecogniser];
  }
  return self;
}

#pragma mark - Setup
- (void)initRotatingLayer {
  
  _rotatingLayer = [CALayer layer];
  _rotatingLayer.bounds = self.bounds;
  _rotatingLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
  _rotatingLayer.masksToBounds = NO;
  
  CAGradientLayer *dualColorDisc = [self blackWhiteDisc];
  [_rotatingLayer addSublayer:dualColorDisc];
  
  [self.layer addSublayer:_rotatingLayer];
}

- (CAGradientLayer *)blackWhiteDisc {
  
  CALayer *discMask = [self discMask];
  
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.bounds = discMask.bounds;
  gradient.position = discMask.position;
  gradient.colors = @[ (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor ];
  gradient.locations = @[ @(0.0), @(0.5), @(0.5), @(1.0) ];
  gradient.startPoint = CGPointMake(0.0f, 0.0f);
  gradient.endPoint = CGPointMake(1.0f, 1.0f);
  gradient.mask = discMask;
  
  return gradient;
}

- (CALayer *)discMask {
  CGFloat diameter = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
  CGRect discRect = CGRectInset(self.bounds, kDiskRectInsetDelta, kDiskRectInsetDelta);
  
  CAShapeLayer *discMask = [CAShapeLayer layer];
  discMask.bounds = discRect;
  discMask.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
  discMask.path = [UIBezierPath bezierPathWithRoundedRect:discRect cornerRadius:diameter/2].CGPath;
  
  return discMask;
}

- (void)setupGestureRecogniser {
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
  [self addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)sender {
  if ([self.delegate respondsToSelector:@selector(didSelectRotatingDiscView:)]) {
    [self.delegate didSelectRotatingDiscView:self];
  }
}

#pragma mark - Animation
- (void)animateWithDuration:(NSTimeInterval)duration
                  direction:(RotatingDiscViewDirection)direction
              withCompleton:(RotatingDiscViewCompletionBlock)completion {
  
  if (!self.isAnimating) {
    
    self.animationCompletionBlock = completion;
    self.animating = YES;
    
    NSInteger directionModifier = direction == RotatingDiscViewDirectionClockwise ? 1.0 : -1.0;
    
    NSNumber *startingTransform = [self.rotatingLayer valueForKeyPath:kTranformKeyPath];
    
    CATransform3D newTransform = CATransform3DRotate(self.rotatingLayer.transform, k180Degress, 0.0, 0.0, 1.0);
    self.rotatingLayer.transform = newTransform;
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:kTranformKeyPath];
    rotation.duration  = duration;
    rotation.fromValue = startingTransform;
    rotation.byValue   = @(k180Degress * directionModifier);
    rotation.delegate  = self;
    
    [self.rotatingLayer addAnimation:rotation forKey:nil];
  }
}

#pragma mark - CABasicAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  
  self.animating = !flag;
  
  if (self.animationCompletionBlock) {
    self.animationCompletionBlock(flag);
  }
  self.animationCompletionBlock = nil;
}

@end
