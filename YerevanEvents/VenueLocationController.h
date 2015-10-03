//
//  VenueLocationController.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/30/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

@import GoogleMaps;
#import <UIKit/UIKit.h>

@interface VenueLocationController : UIViewController <GMSMapViewDelegate>

@property CLLocation *coordinates;
@property NSString   *venueName;
@property NSString   *venueAddress;

@end
