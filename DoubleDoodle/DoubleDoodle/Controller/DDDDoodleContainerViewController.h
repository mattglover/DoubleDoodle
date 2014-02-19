//
//  DDDDoodleContainerViewController.h
//  DoubleDoodle
//
//  Created by Matt Glover on 15/02/2014.
//  Copyright (c) 2014 Duchy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDDoodleContainerViewController : UIViewController

// Designated Initializer
- (id)initWithXMLData:(NSData *)xmlData;

// Update the UI and Child ViewControllers with new DDDDoodleViewConfig configuration
- (void)updateWithXMLData:(NSData *)xmlData;

@end
