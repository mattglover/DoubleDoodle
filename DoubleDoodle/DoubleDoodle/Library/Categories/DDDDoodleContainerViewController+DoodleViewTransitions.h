//
//  DDDDoodleContainerViewController+DoodleViewTransitions.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleContainerViewController.h"

typedef NS_ENUM(NSInteger, DoodleViewAnimationDirection) {
  DoodleViewAnimationDirectionNoneSpecified,
  DoodleViewAnimationDirectionClockwise,
  DoodleViewAnimationDirectionAntiClockwise
};

@interface DDDDoodleContainerViewController (DoodleViewTransitions)

- (void)performTransitionCarouselToBackView:(UIView *)toBackView toFrontView:(UIView *)toFrontView animated:(BOOL)animated direction:(DoodleViewAnimationDirection)animationDirection completion:(void(^)(BOOL finished))completion;
- (void)performTransitionSideBySideLeftView:(UIView *)leftView rightView:(UIView *)rightView animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)performTransitionFromSideBySideWithToFrontView:(UIView *)toFrontView  toBackView:(UIView *)toBackView animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

@end
