//
//  DDDDoodleContainerViewController.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleContainerViewController.h"
#import "DDDDoodleViewController.h"

@interface DDDDoodleContainerViewController ()

@property (nonatomic, copy) NSString *xml;
@property (nonatomic, strong) NSMutableArray *doodleViewController;

@end

@implementation DDDDoodleContainerViewController

#pragma mark - Initializers
// Should use designated initializer | initWithXML: |
- (id)init {
    NSLog(@"Should use designated initializer initWithXML:");
    return [self initWithXML:@""];
}

// Designated Initializer
- (id)initWithXML:(NSString *)xml {
    if (self = [super init]) {
        _xml = xml;
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
