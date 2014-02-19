//
//  DDDDoodleViewConfig.m
//  DoubleDoodle
//
//  Created by Matt Glover on 18/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleViewConfig.h"

@implementation DDDDoodleViewConfig

- (BOOL)isValidConfiguration {
  return (self.backgroundColor && self.foregroundColor) ? YES : NO;
}

@end
