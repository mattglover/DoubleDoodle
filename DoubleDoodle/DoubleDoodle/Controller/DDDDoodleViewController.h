//
//  DDDDoodleViewController.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDDoodleViewController;
@protocol DDDDoodleViewControllerDelegate<NSObject>
- (void)didSelectDoodleViewController:(DDDDoodleViewController *)controller;
@end

@class DDDDoodleView;
@class DDDDoodleViewConfig;
@interface DDDDoodleViewController : UIViewController

@property (nonatomic, weak) id<DDDDoodleViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) DDDDoodleView *doodleView;

// Designated Initializer
- (id)initWithDoodleViewConfiguration:(DDDDoodleViewConfig *)configuration delegate:(id<DDDDoodleViewControllerDelegate>)delegate;

// Update the UI with new DDDDoodleViewConfig configuration
- (void)updateWithDoodleViewConfiguration:(DDDDoodleViewConfig *)configuration;

// Useful for deciding if Doodle View is not currently editable
- (BOOL)isDoodleViewEditable;

// Useful to visually represent as a color, this Controller's doodleView
- (UIColor *)representativeDoodleViewColor;

@end
