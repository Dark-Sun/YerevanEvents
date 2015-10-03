//
//  UserCategory.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 10/2/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "UserCategory.h"

@implementation UserCategory

+ (void) createFromJson: (NSArray*) json {
    for (NSDictionary* category in json) {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* context = app.managedObjectContext;
        
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"UserCategory"
                     inManagedObjectContext: context];
        
        [object setValue:category[@"id"] forKey:@"id"];
        [object setValue:category[@"name"] forKey:@"name"];
        [object setValue:category[@"name_arm"] forKey:@"name_arm"];
        [object setValue:category[@"name_ru"] forKey:@"name_ru"];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
    
}

+ (NSArray*) all {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UserCategory"];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results;
}

@end
