//
//  UserCategory.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 10/2/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"

@interface UserCategory : NSObject

+ (void) createFromJson: (NSArray*) json;
+ (NSArray*) all;
@end
