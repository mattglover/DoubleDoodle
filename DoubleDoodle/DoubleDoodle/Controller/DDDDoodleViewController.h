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
@interface DDDDoodleViewController : UIViewController

@property (nonatomic, assign) id<DDDDoodleViewControllerDelegate> delegate;
@property (nonatomic, strong) DDDDoodleView *doodleView;

- (id)initWithXML:(NSString *)xml withDelegate:(id<DDDDoodleViewControllerDelegate>)delegate;

// Useful for deciding if Doodle View is not the currently editable DoodleView
- (BOOL)isDoodleViewTransformed;

@end
