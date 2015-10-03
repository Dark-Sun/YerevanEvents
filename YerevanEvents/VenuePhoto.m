//
//  VenuePhoto.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/30/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "VenuePhoto.h"

@implementation VenuePhoto

+ (void) createFromJson: (NSArray*) json {
    for (NSDictionary* category in json) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = app.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"VenuePhoto"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@", category[@"id"]]];
        [request setFetchLimit:1];
        NSError *error;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        
        NSManagedObject *object;
        
        if (count == 0) {
            object = [NSEntityDescription insertNewObjectForEntityForName:@"VenuePhoto"
                                                   inManagedObjectContext: context];
        } else if (count == 0) {
            // TODO: update
            //            NSArray *results = [context executeFetchRequest:request error:&error][0];
            //            object = [results objectAtIndex:0];
        }
        
        [object setValue:category[@"id"] forKey:@"id"];
        [object setValue:category[@"venue_id"][@"id"] forKey:@"venue_id"];
        [object setValue:category[@"photo_url"] forKey:@"photo_url"];
        [object setValue:category[@"thumb_url"] forKey:@"thumb_url"];
        
        if (![context save:&error]) NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        
        
        
    }
    
}

+ (NSArray*) byVenueId: (NSNumber*) id_ {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"VenuePhoto"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_id == %i", [id_ integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
    
}

@end
