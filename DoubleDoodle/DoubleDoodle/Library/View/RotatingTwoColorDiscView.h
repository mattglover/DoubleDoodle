//
//  RotatingDiscView.h
//  RotatingDiscView
//
//  Created by Matt Glover on 17/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RotatingDiscViewDirection) {
  RotatingDiscViewDirectionClockwise,
  RotatingDiscViewDirectionAntiClockwise
};

typedef void (^RotatingDiscViewCompletionBlock) (BOOL finished);

@class RotatingTwoColorDiscView;
@protocol RotatingTwoColorDiscViewDelegate <NSObject>
- (void)didSelectRotatingDiscView:(RotatingTwoColorDiscView *)view;
@end

@interface RotatingTwoColorDiscView : UIView

@property (nonatomic, weak) id<RotatingTwoColorDiscViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;
- (void)updateWithFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

- (void)animateWithDuration:(NSTimeInterval)duration direction:(RotatingDiscViewDirection)direction withCompleton:(RotatingDiscViewCompletionBlock)completion;

@end
