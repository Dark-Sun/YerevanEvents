//
//  Sync.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/15/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <AFURLRequestSerialization.h>

@interface Sync : NSObject

+ (AFHTTPRequestOperation*) synchronizeData: (void (^)(bool id)) completion;
+ (AFHTTPRequestOperation*) synchronizeUserCategories: (void (^)(bool id)) completion;
+ (void) parseJson: (NSData*) data;

@end
