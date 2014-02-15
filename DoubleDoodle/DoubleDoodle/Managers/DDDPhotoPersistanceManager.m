//
//  DDDPhotoPersistanceManager.m
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDPhotoPersistanceManager.h"

@interface DDDPhotoPersistanceManager ()

@property (nonatomic, copy) PhotoPersistanceManagerCompletionBlock savePhotoCompletionBlock;
@end

@implementation DDDPhotoPersistanceManager

+ (DDDPhotoPersistanceManager *)sharedManager {
  static DDDPhotoPersistanceManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[DDDPhotoPersistanceManager alloc] init];
  });
  
  return _sharedManager;
}

- (void)saveImageToCameraRoll:(UIImage *)image completion:(PhotoPersistanceManagerCompletionBlock)completion {
  if (completion) {
    self.savePhotoCompletionBlock = completion;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  } else {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
  }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  if (error) {
    self.savePhotoCompletionBlock(NO, error);
  } else {
    self.savePhotoCompletionBlock(YES, nil);
  };
  
  self.savePhotoCompletionBlock = nil;
}

@end
