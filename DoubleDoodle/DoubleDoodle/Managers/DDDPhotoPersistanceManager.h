//
//  DDDPhotoPersistanceManager.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PhotoPersistanceManagerCompletionBlock) (BOOL success, NSError *error);

@interface DDDPhotoPersistanceManager : NSObject

+ (DDDPhotoPersistanceManager *)sharedManager;

- (void)saveImageToCameraRoll:(UIImage *)image completion:(PhotoPersistanceManagerCompletionBlock)completion;

@end
