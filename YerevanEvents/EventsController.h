//
//  EventsController.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/24/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property NSNumber *venueId;
@property NSDate   *fromTime;
@property NSDate   *toTime;
@property BOOL     onlyFavorites;

@end
