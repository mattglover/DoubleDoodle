//
//  DDDDoodleContainerViewController+DoodleViewTransitions.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleContainerViewController+DoodleViewTransitions.h"

static NSTimeInterval const kDefaultAnimationDuration = 0.4f;
static CGFloat        const kTransformScale           = 0.5f;
static CGFloat        const kToBackViewAlpha          = 0.5f;
static CGFloat        const kInterDoodleViewSpacing   = 6.0f;

static NSTimeInterval const kFromSideBySideDepressAnimationDuration = 0.1f;
static NSTimeInterval const kFromSideBySideDepressScale             = 0.95f;

@implementation DDDDoodleContainerViewController (DoodleViewTransitions)

- (void)performTransitionCarouselToBackView:(UIView *)toBackView
                                toFrontView:(UIView *)toFrontView
                                   animated:(BOOL)animated
                                 completion:(void(^)(BOOL finished))completion {
  
  [UIView animateWithDuration:[self animationDuration:animated]
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [toBackView setTransform:CGAffineTransformMakeTranslation(-CGRectGetWidth(toBackView.bounds)/2,
                                                                               0)];
                     [toFrontView setTransform:CGAffineTransformMakeTranslation(CGRectGetWidth(toFrontView.bounds)/2,
                                                                                0)];
                     toFrontView.alpha = 1.0;
                     
                   } completion:^(BOOL finished) {
                     
                     [self.view bringSubviewToFront:toFrontView];
                     
                     [UIView animateWithDuration:[self animationDuration:animated]
                                           delay:0.0f
                                         options:UIViewAnimationOptionCurveEaseOut
                                      animations:^{
                                        CGAffineTransform toBackViewTransform = CGAffineTransformIdentity;
                                        [toBackView setTransform:CGAffineTransformScale(toBackViewTransform, kTransformScale, kTransformScale)];
                                        toBackView.alpha = kToBackViewAlpha;
                                        
                                        [toFrontView setTransform:CGAffineTransformIdentity];
                                      }
                                      completion:^(BOOL finished) {
                                        if (completion) {
                                          completion(finished);
                                        }
                                      }];
                   }];
}

- (void)performTransitionSideBySideLeftView:(UIView *)leftView
                                  rightView:(UIView *)rightView
                                   animated:(BOOL)animated
                                 completion:(void(^)(BOOL finished))completion {
  
  [UIView animateWithDuration:[self animationDuration:animated]
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     
                     CGAffineTransform leftTransform = CGAffineTransformIdentity;
                     CGAffineTransform rightTransform = CGAffineTransformIdentity;
                     
                     leftTransform  = CGAffineTransformScale(leftTransform, kTransformScale, kTransformScale);
                     rightTransform = CGAffineTransformScale(rightTransform, kTransformScale, kTransformScale);
                     
                     leftTransform  = CGAffineTransformTranslate(leftTransform, -CGRectGetWidth(leftView.bounds)/2 - kInterDoodleViewSpacing, 0);
                     rightTransform = CGAffineTransformTranslate(rightTransform, CGRectGetWidth(rightView.bounds)/2 + kInterDoodleViewSpacing, 0);
                     
                     [leftView setTransform:leftTransform];
                     [rightView setTransform:rightTransform];
                     
                     leftView.alpha  = 1.0;
                     rightView.alpha = 1.0;
                     
                   } completion:^(BOOL finished) {
                     if (completion) {
                       completion(finished);
                     }
                   }];
}

- (void)performTransitionFromSideBySideWithToFrontView:(UIView *)toFrontView
                                     toBackView:(UIView *)toBackView
                                       animated:(BOOL)animated
                                     completion:(void(^)(BOOL finished))completion {
  
  [UIView animateWithDuration:kFromSideBySideDepressAnimationDuration
                   animations:^{
                     CGAffineTransform transform = toFrontView.transform;
                     [toFrontView setTransform:CGAffineTransformScale(transform, kFromSideBySideDepressScale, kFromSideBySideDepressScale)];
                   } completion:^(BOOL finished) {
                     
                     [UIView animateWithDuration:[self animationDuration:animated]
                                           delay:0.0f
                                         options:UIViewAnimationOptionCurveEaseIn
                                      animations:^{
                                        
                                        [self.view bringSubviewToFront:toFrontView];
                                        
                                        [toFrontView setTransform:CGAffineTransformIdentity];
                                        
                                        CGAffineTransform toBackViewTransform = CGAffineTransformIdentity;
                                        [toBackView setTransform:CGAffineTransformScale(toBackViewTransform, kTransformScale, kTransformScale)];
                                        toBackView.alpha = kToBackViewAlpha;
                                        
                                      } completion:^(BOOL finished) {
                                        if (completion) {
                                          completion(finished);
                                        }
                                      }];
                   }];
}

#pragma mark - Private Helper - Animation Duration
- (NSTimeInterval)animationDuration:(BOOL)animated {
  return animated ? kDefaultAnimationDuration : 0.0f;
}

@end
