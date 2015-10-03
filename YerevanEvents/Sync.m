//
//  Sync.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/15/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "Sync.h"
#import "Config.h"
#import "VenueCategory.h"
#import "Venue.h"
#import "Event.h"
#import "VenuePhoto.h"
#import "UserCategory.h"

@implementation Sync

+ (AFHTTPRequestOperation*) synchronizeData: (void (^)(bool id)) completion {
    NSString *string = [NSString stringWithFormat:@"%@%@", apiUrl, @"/venue_categories"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseJson: responseObject];
        completion(true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync equest failed: %@", error.localizedDescription);
    }];
    [operation start];
    return operation;
}

+ (AFHTTPRequestOperation*) synchronizeUserCategories: (void (^)(bool id)) completion {
    NSString *string = [NSString stringWithFormat:@"%@%@", apiUrl, @"/user_categories"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UserCategory createFromJson: responseObject];
        completion(true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync equest failed: %@", error.localizedDescription);
    }];
    [operation start];
    return operation;
}

+ (void) parseJson:(NSDictionary *) json {
    NSEnumerator *enumerator = [json keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        if ([key isEqualToString:@"venue_categories"]) {
            [VenueCategory createFromJson:json[key]];
        } else if ([key isEqualToString:@"venues"]){
            [Venue createFromJson:json[key]];
        } else if ([key isEqualToString:@"events"]){
            [Event createFromJson:json[key]];
        }  else if ([key isEqualToString:@"venue_photos"]){
            [VenuePhoto createFromJson:json[key]];
        }
    }
    
}


@end
