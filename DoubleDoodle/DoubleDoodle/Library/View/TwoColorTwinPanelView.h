//
//  TwoColorTwinPanelView.h
//  RotatingImageButton
//
//  Created by Matt Glover on 17/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwoColorTwinPanelView;
@protocol TwoColorTwinPanelViewDelegate<NSObject>
- (void)didSelectTwoColorTwinPanelView:(TwoColorTwinPanelView *)view;
@end

@interface TwoColorTwinPanelView : UIView

@property (nonatomic, weak) id<TwoColorTwinPanelViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;
- (void)updateWithFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

@end
