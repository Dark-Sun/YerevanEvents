//
//  Venue.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "Venue.h"

@implementation Venue

+ (void) createFromJson: (NSArray*) json {
    for (NSDictionary* category in json) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = app.managedObjectContext;
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Venue"
                                                                inManagedObjectContext: context];
        [object setValue:category[@"id"] forKey:@"id"];
        [object setValue:category[@"name"] forKey:@"name"];
        [object setValue:category[@"fb_page"] forKey:@"fb_page"];
        if (category[@"longitude"] != [NSNull null]) [object setValue:category[@"longitude"] forKey:@"longitude"];
         if (category[@"latitude"] != [NSNull null])[object setValue:category[@"latitude"] forKey:@"latitude"];
        [object setValue:category[@"phone"] forKey:@"phone"];
        [object setValue:category[@"address"] forKey:@"address"];
        [object setValue:category[@"original_photo_url"] forKey:@"original_photo_url"];
        [object setValue:category[@"thumb_photo_url"] forKey:@"thumb_photo_url"];
        [object setValue:category[@"venue_category_id"][@"id"] forKey:@"venue_category_id"];
        [object setValue:category[@"description"] forKey:@"desc"];

        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
    
}

+ (NSArray*) all {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Venue"];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

+ (NSArray*) onlyFavorites {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Venue"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %i", TRUE];
    [request setPredicate:predicate];

    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

+ (NSArray*) byCategoryId: (NSNumber*) categoryId {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Venue"];
//    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venue_category_id == %i", [categoryId integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
    
}

+ (Venue*) byId: (NSNumber*) id_ {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Venue"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", [id_ integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results[0];

}

+ (bool) toogleFavoriteById: (NSNumber*) id_ {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Venue"];
    //    NSLog(@"ppp %@", categoryId);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %i", [id_ integerValue] ];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    Venue *venue = results[0];
    if ([[venue valueForKey:@"favorite"] boolValue]) {
        [venue setValue:[NSNumber numberWithBool:NO] forKey:@"favorite"];
    } else {
        [venue setValue:[NSNumber numberWithBool:YES] forKey:@"favorite"];
    }
    
    if (![context save:&error]) {
        return false;
    } else {
        return true;
    }
}

@end
