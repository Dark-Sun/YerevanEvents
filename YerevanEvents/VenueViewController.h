//
//  VenueViewController.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/23/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"


@interface VenueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate>

@property  NSNumber       *categoryId;
@property  NSMutableArray *photos;
@property  NSMutableArray *thumbs;

- (void) openPhone: (NSString*) number;

@end
