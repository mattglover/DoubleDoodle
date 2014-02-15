//
//  DDDDoodleViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleViewController.h"
#import "DDDDoodleView.h"

@interface DDDDoodleViewController ()

@property (nonatomic, strong) DDDDoodleView *doodleView;

@end

@implementation DDDDoodleViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
  NSLog(@"Should use designated initializer initWithXML:");
  return [self initWithXML:@""];
}

// Designated Initializer
- (id)initWithXML:(NSString *)xml {
  if (self = [super init]) {
    
  }
  return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  NSLog(@"%s", __FUNCTION__);
}


@end
