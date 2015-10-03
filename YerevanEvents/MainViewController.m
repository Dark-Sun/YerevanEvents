//
//  MainViewController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "MainViewController.h"
#import "VenuesController.h"

@interface MainViewController () {
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return @"allVenuesSegue";
            break;
        case 2:
            return @"allEventsSegue";
            break;
        case 3:
            return @"allVenuesSegue";
            break;
        case 4:
            return @"allEventsSegue";
            break;
        case 5:
            return @"nearbyVenuesSegue";
            break;

        default:
            return @"firstSegue";
            break;
    }
}

- (void)configureLeftMenuButton:(UIButton *)button {
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
}

#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"allVenuesSegue"] && favoriteVenues) {
//        NSLog(@"favorite venues");
//        favoriteVenues = false;
//        VenuesController *vcToPushTo = (VenuesController*)segue.destinationViewController;
//        vcToPushTo.onlyFavorites = true;
//    }
//}


@end
