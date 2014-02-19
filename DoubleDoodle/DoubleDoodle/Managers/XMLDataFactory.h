//
//  XMLDataFactory.h
//  DoubleDoodle
//
//  Created by Matt Glover on 19/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XMLDataOption) {
  XMLDataOptionDefault,
  XMLDataOptionAlternative
};

@interface XMLDataFactory : NSObject

+ (XMLDataFactory *)defaultFactory;

- (NSData *)xmlDataWithXMLDataOption:(XMLDataOption)option;

@end
