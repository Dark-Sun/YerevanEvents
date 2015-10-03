//
//  VenuesControllerTableViewController.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenuesController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property NSNumber *categoryId;
@property BOOL     onlyFavorites;
@end