//
//  Venue.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface Venue : NSObject

+ (void) createFromJson: (NSArray*) json;
+ (NSArray*) all;
+ (NSArray*) onlyFavorites;
+ (NSArray*) byCategoryId: (NSNumber*) categoryId;
+ (Venue*) byId: (NSNumber*) id_;
+ (bool) toogleFavoriteById: (NSNumber*) id_;

@end
