//
//  DDDSmoothLineView.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "SmoothLineView.h"

@class DDDDoodleView;
@protocol DDDDoodleViewDelegate<NSObject>
- (BOOL)canDrawOnDoodleView:(DDDDoodleView *)doodleView;
@end

@interface DDDDoodleView : SmoothLineView

@property (nonatomic, weak) id<DDDDoodleViewDelegate>delegate;

@end
