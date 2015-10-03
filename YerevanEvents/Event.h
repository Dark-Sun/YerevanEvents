//
//  Event.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/24/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"

@interface Event : NSObject

+ (void) createFromJson: (NSArray*) json;
+ (NSArray*) all;
+ (Event*) byId: (NSNumber*) id_;
+ (NSArray*) byVenueId: (NSNumber*) venueId;
+ (NSArray*) fromTime: (NSDate*) fromTime toTime: (NSDate*) toTime;
+ (bool) toogleFavoriteById: (NSNumber*) id_ ;
+ (NSArray*) onlyFavorites;

@end
