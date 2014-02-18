//
//  DDDDoodleViewController.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDDoodleViewController;
@protocol DDDDoodleViewControllerDelegate <NSObject>
- (void)didSelectDoodleViewController:(DDDDoodleViewController *)controller;
@end

@class DDDDoodleView;
@class DDDDoodleViewConfig;
@interface DDDDoodleViewController : UIViewController

@property (nonatomic, assign) id<DDDDoodleViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) DDDDoodleView *doodleView;

// Designated Initializer
- (id)initWithDoodleViewConfiguration:(DDDDoodleViewConfig *)configuration delegate:(id<DDDDoodleViewControllerDelegate>)delegate;

// Useful for deciding if Doodle View is not currently editable
- (BOOL)isDoodleViewEditable;

// Useful Identifier to visually represent this Controller's doodleView
- (UIColor *)representativeDoodleViewColor;

@end
