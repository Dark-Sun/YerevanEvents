//
//  VenueCategory.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/5/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "VenueCategory.h"
#import <RestKit/RestKit.h>

@implementation VenueCategory

- (void) get: (NSString*) json {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VenueCategory class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"name":   @"name"
                                                  }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping        
                                                                     method:RKRequestMethodAny
                                                                     pathPattern:nil
                                                                     keyPath:nil
                                                                     statusCodes:nil
                                                ];
    NSURL *url = [NSURL URLWithString:@"http://146.185.168.46:3001/api/v1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"The public timeline Tweets: %@", [result array]);
    } failure:nil];
    [operation start];
}

@end
