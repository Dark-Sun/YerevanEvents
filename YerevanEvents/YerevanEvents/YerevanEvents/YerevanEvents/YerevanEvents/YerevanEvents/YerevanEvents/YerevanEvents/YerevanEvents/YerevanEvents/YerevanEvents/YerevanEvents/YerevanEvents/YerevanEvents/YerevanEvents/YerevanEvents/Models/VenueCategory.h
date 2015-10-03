//
//  VenueCategory.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/5/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueCategory : NSObject

@property (nonatomic, copy) NSNumber *name;

- (void) get: (NSString*) json;

@end
