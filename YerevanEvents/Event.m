//
//  Event.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/24/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (void) createFromJson: (NSArray*) json {
    for (NSDictionary* category in json) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = app.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"VenueCategory"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@", category[@"id"]]];
        [request setFetchLimit:1];
        NSError *error;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        
        NSManagedObject *object;
        
        if (count == 0) {
            object = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                   inManagedObjectContext: context];
        } else if (count == 0) {
            // TODO: update
            //            NSArray *results = [context executeFetchRequest:request error:&error][0];
            //            object = [results objectAtIndex:0];
        }
        
        [object setValue:category[@"id"] forKey:@"id"];
        [object setValue:category[@"venue_id"][@"id"] forKey:@"venue_id"];
        [object setValue:category[@"name"] forKey:@"name"];
        [object setValue:category[@"original_photo_url"] forKey:@"original_photo_url"];
        [object setValue:category[@"thumb_photo_url"]    forKey:@"thumb_photo_url"];
        if ([category[@"description"] class] != NSNull.class) [object setValue:category[@"description"]    forKey:@"desc"];

        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSDate *time = [dateformat dateFromString: category[@"time"]];
        [object setValue:time forKey:@"time"];

        if (![context save:&error]) NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        
        
        
    }
    
}


+ (NSArray*) all {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"time" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time >= %@", today];
    [request setPredicate:predicate];

    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

+ (Event*) byId: (NSNumber*) id_ {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", [id_ integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results[0];
    
}

+ (NSArray*) byVenueId: (NSNumber*) venueId {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_id == %i", [venueId integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
    
}

+ (NSArray*) fromTime: (NSDate*) fromTime toTime: (NSDate*) toTime {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"time" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time >= %@ AND time <= %@", fromTime, toTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

+ (bool) toogleFavoriteById: (NSNumber*) id_ {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", [id_ integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    Event *event = results[0];
    if ([[event valueForKey:@"favorite"] boolValue]) {
        [event setValue:[NSNumber numberWithBool:NO] forKey:@"favorite"];
    } else {
        [event setValue:[NSNumber numberWithBool:YES] forKey:@"favorite"];
    }
    
    if (![context save:&error]) {
        return false;
    } else {
        return true;
    }
}

+ (NSArray*) onlyFavorites {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %i", TRUE];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}


@end
