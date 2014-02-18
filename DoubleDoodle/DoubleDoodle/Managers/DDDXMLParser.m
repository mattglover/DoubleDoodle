//
//  DDDXMLParser.m
//  DoubleDoodle
//
//  Created by Matt Glover on 18/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import "DDDXMLParser.h"
#import "DDDDoodleViewConfig.h"
#import "UIColor+Hex.h"

static NSString * const kXMLElementNameDoodleView = @"doodleview";
static NSString * const kXMLAttributeNameBackgroundColor = @"background_color";
static NSString * const kXMLAttributeNameForegroundColor = @"foreground_color";

@interface DDDXMLParser ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *doodleViewConfigurations;
@end

@implementation DDDXMLParser

- (NSArray *)doodleViewConfigurationsWithXML:(NSData *)xmlData {

  [self resetDoodleViewConfigurations];
  
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
  parser.delegate = self;
  [parser parse];
  
  return self.doodleViewConfigurations;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
  
  if ([elementName isEqualToString:kXMLElementNameDoodleView]) {
    
    UIColor *backgroundColor = [UIColor colorFromHexString:attributeDict[kXMLAttributeNameBackgroundColor]];
    UIColor *foregroundColor = [UIColor colorFromHexString:attributeDict[kXMLAttributeNameForegroundColor]];
    
    DDDDoodleViewConfig *doodleViewConfiguration = [[DDDDoodleViewConfig alloc] init];
    doodleViewConfiguration.backgroundColor = backgroundColor;
    doodleViewConfiguration.foregroundColor = foregroundColor;
    
    [self.doodleViewConfigurations addObject:doodleViewConfiguration];
  }
}

#pragma mark - DoodleViewConfigurations Reset
- (void)resetDoodleViewConfigurations {
  // Lazy Load
  if (!self.doodleViewConfigurations) {
    self.doodleViewConfigurations = [NSMutableArray array];
  }
  
  [self.doodleViewConfigurations removeAllObjects];
}

@end
