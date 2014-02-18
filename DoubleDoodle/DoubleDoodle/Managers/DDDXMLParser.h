//
//  DDDXMLParser.h
//  DoubleDoodle
//
//  Created by Matt Glover on 18/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDXMLParser : NSObject

- (NSArray *)doodleViewConfigurationsWithXML:(NSData *)xmlData;

@end
