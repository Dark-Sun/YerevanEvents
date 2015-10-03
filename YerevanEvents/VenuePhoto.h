//
//  VenuePhoto.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/30/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"

@interface VenuePhoto : NSObject

+ (void) createFromJson: (NSArray*) json;
+ (NSArray*) byVenueId: (NSNumber*) id_;

@end
