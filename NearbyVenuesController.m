//
//  NearbyVenuesController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/29/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "NearbyVenuesController.h"
#import "Venue.h"
#import "VenueViewController.h"

@interface NearbyVenuesController () {
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    CLLocation        *coordinates;
}
@end

@implementation NearbyVenuesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter  = 5;
    
    [locationManager startUpdatingLocation];
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    self.navigationItem.titleView = imageView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 40.1533904
                                                            longitude: 44.4885671
                                                                 zoom: 13.0];
    mapView_.myLocationEnabled = YES;
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
//                                        longitude:mapView_.myLocation.coordinate.longitude
//                                              zoom:11.0];
//   
    mapView_ = [GMSMapView mapWithFrame: CGRectZero
                                 camera: camera];
    mapView_.delegate = self;
    
    self.view = mapView_;
    
    NSArray *venues = [Venue all];
    
    for (id venue in venues) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[venue valueForKey:@"latitude"]  doubleValue],
                                                    [[venue valueForKey:@"longitude"] doubleValue]);
        marker.title = [venue valueForKey:@"name"];
        marker.userData = [venue valueForKey:@"id"];
        marker.map = mapView_;
    }
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self performSegueWithIdentifier: @"showVenueSegue" sender: marker];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != nil) coordinates = newLocation;
    [locationManager stopUpdatingLocation];
    [mapView_ animateToLocation:coordinates.coordinate];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVenueSegue"]) {
        VenueViewController *vcToPushTo = (VenueViewController*) segue.destinationViewController;
        NSNumber *id_ = [NSNumber numberWithInt: [[(GMSMarker*) sender userData] integerValue]];
        vcToPushTo.categoryId = id_;
    }
 
}

@end
