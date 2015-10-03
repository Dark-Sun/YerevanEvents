//
//  User.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 10/2/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User*) get;
+ (void) signUpWithEmail: (NSString*)     email
                    name: (NSString*)     name
                   phone: (NSString*)     phone
                password: (NSString*)     password
              categories: (NSDictionary*)      categories
                  result: (void (^)(bool id)) block;

+ (void) signInWithEmail: (NSString*)     email
                password: (NSString*)     password
                  result: (void (^)(bool id)) block;;
+ (void) signOut;

@end
