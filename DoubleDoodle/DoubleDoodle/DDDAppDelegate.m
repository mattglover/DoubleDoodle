//
//  DDDAppDelegate.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDAppDelegate.h"
#import "DDDDoodleViewController.h"

@implementation DDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  
  DDDDoodleViewController *doodleViewController = [[DDDDoodleViewController alloc] initWithXML:@""];
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:doodleViewController];
  [self.window setRootViewController:navigationController];
  
  [self.window makeKeyAndVisible];
  return YES;
}

@end
