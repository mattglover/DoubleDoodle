//
//  XMLDataFactory.m
//  DoubleDoodle
//
//  Created by Matt Glover on 19/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "XMLDataFactory.h"

static NSString * const kDefaultXMLFilename = @"doodleconfig_blackwhite";
static NSString * const kAlternativeXMLFilename = @"doodleconfig_redblue";
static NSString * const kXMLFileType = @"xml";

@implementation XMLDataFactory

+ (XMLDataFactory *)defaultFactory {
  static XMLDataFactory *_sharedFactory = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedFactory = [[XMLDataFactory alloc] init];
  });
  
  return _sharedFactory;
}

- (NSData *)xmlDataWithXMLDataOption:(XMLDataOption)option {
  
  NSString *xmlFilePath;

  switch (option) {
    case XMLDataOptionDefault:
      xmlFilePath = [[NSBundle mainBundle] pathForResource:kDefaultXMLFilename ofType:kXMLFileType];
      break;
      
    case XMLDataOptionAlternative:
      xmlFilePath = [[NSBundle mainBundle] pathForResource:kAlternativeXMLFilename ofType:kXMLFileType];
      break;
  }
  
  NSData *xmlData = xmlFilePath ? [NSData dataWithContentsOfFile:xmlFilePath] : [NSData data];
  return xmlData;
}

@end
