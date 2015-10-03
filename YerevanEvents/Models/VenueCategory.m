//
//  VenueCategory.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/5/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "VenueCategory.h"

@implementation VenueCategory

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
            object = [NSEntityDescription insertNewObjectForEntityForName:@"VenueCategory"
                                                                    inManagedObjectContext: context];
            NSLog(@"New category");
        } else if (count == 0) {
            // TODO: update
//            NSArray *results = [context executeFetchRequest:request error:&error][0];
//            object = [results objectAtIndex:0];
        }
        
        [object setValue:category[@"id"] forKey:@"id"];
        [object setValue:category[@"name"] forKey:@"name"];
        [object setValue:category[@"original_image_url"] forKey:@"original_image_url"];
        [object setValue:category[@"thumb_image_url"]    forKey:@"thumb_image_url"];
        [object setValue:category[@"position"]           forKey:@"position"];

        if (![context save:&error]) NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        
        
        
    }

}

+ (NSArray*) all {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"VenueCategory"];
    
    NSError *error = nil;
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"position" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

@end
