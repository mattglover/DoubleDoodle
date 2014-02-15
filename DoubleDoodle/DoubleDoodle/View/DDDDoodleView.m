//
//  DDDSmoothLineView.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDDoodleView.h"

@implementation DDDDoodleView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([self.delegate respondsToSelector:@selector(canDrawOnDoodleView:)] && [self.delegate canDrawOnDoodleView:self]) {
    [super touchesBegan:touches withEvent:event];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([self.delegate respondsToSelector:@selector(canDrawOnDoodleView:)] && [self.delegate canDrawOnDoodleView:self]) {
    [super touchesMoved:touches withEvent:event];
  }
}

@end
