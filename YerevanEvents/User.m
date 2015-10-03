//
//  User.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 10/2/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "User.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"
#import <AFNetworking.h>
#import <AFURLRequestSerialization.h>


@implementation User

+ (User*) get {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = app.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return results[0];
}

+ (void) signUpWithEmail: (NSString*)     email
                    name: (NSString*)     name
                   phone: (NSString*)     phone
                password: (NSString*)     password
              categories: (NSDictionary*)      categories
                  result: (void (^)(bool id)) block {
    NSString *string = [NSString stringWithFormat:@"%@%@", apiUrl, @"/users"];
//    NSURL *url = [NSURL URLWithString:string];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"email": email,
                             @"password": password,
                             @"phone": phone,
                             @"name": name,
                             @"user_categories_attributes": categories};
    [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(TRUE);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(FALSE);
        NSLog(@"Error: %@", error);
    }];
}

+ (void) signInWithEmail: (NSString*)     email
                password: (NSString*)     password
                  result: (void (^)(bool id)) block {
    
}
+ (void) signOut {
    
}

@end
