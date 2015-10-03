//
//  VenueLocationController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/30/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "VenueLocationController.h"

@interface VenueLocationController () {
    GMSMapView *mapView_;
}

@end

@implementation VenueLocationController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    self.navigationItem.titleView = imageView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.coordinates.coordinate.latitude
                                                            longitude: self.coordinates.coordinate.longitude
                                                                 zoom: 13.0];

    mapView_ = [GMSMapView mapWithFrame: CGRectZero
                                 camera: camera];
    mapView_.delegate = self;
    
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = self.coordinates.coordinate;
    marker.title    = self.venueName;
    marker.snippet  = self.venueAddress;
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
