//
//  DDDDoodleViewConfig.h
//  DoubleDoodle
//
//  Created by Matt Glover on 18/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDDoodleViewConfig : NSObject

- (BOOL)isValidConfiguration;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *foregroundColor;

@end
