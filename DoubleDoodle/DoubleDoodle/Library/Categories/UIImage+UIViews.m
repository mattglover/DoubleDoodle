//
//  UIImage+UIViews.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "UIImage+UIViews.h"

@implementation UIImage (UIViews)

+ (UIImage *)imageWithView:(UIView *)view {

  CGFloat scale = [UIScreen mainScreen].scale;
  
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, scale);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return img;
}

@end
