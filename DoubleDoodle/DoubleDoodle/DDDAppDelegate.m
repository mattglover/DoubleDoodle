//
//  DDDAppDelegate.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDAppDelegate.h"
#import "DDDDoodleContainerViewController.h"
#import "XMLDataFactory.h"

@implementation DDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // Load default xml data
  NSData *xmlData = [[XMLDataFactory defaultFactory] xmlDataWithXMLDataOption:XMLDataOptionDefault];
  DDDDoodleContainerViewController *doodleContainerViewController = [[DDDDoodleContainerViewController alloc] initWithXMLData:xmlData];
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:doodleContainerViewController];
  navigationController.navigationBar.tintColor = [UIColor blackColor];
  
  [self.window setRootViewController:navigationController];
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
