//
//  SidebarController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "SidebarController.h"
#import "VenuesController.h"
#import "EventsController.h"

@interface SidebarController () {
    NSArray *labels;
    NSArray *images;
    bool favoriteVenues;
    bool favoriteEvents;

}
@end

@implementation SidebarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1]; /*#f7f7f7*/
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);

    labels = @[@"Home", @"All venues", @"All events", @"Favorite venues", @"Favorite events", @"Nearby venues", @"Notifications", @"Settings", @"About us"];
    images = @[@"upcoming_events", @"upcoming_events", @"upcoming_events", @"favorite_venues", @"favorite_events", @"nearby_venues", @"notifications", @"settings", @"about_us"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = UITableViewCell.alloc.init;
    if (cell != nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"sidebarCell" forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1]; /*#f7f7f7*/
    
    cell.textLabel.text = labels[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed: images[indexPath.row]];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        favoriteVenues = true;
    } else if (indexPath.row == 4) {
        favoriteEvents = true;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"allVenuesSegue"] && favoriteVenues) {
        NSLog(@"favorite venues");
        favoriteVenues = FALSE;
        UINavigationController *vcToPushTo = (UINavigationController*)segue.destinationViewController;
        VenuesController *cont = (VenuesController*) vcToPushTo.topViewController;
        [cont setOnlyFavorites:TRUE];
    } else if ([segue.identifier isEqualToString:@"allEventsSegue"] && favoriteEvents) {
        NSLog(@"favorite venues");
        favoriteEvents = FALSE;
        UINavigationController *vcToPushTo = (UINavigationController*)segue.destinationViewController;
        EventsController *cont = (EventsController*) vcToPushTo.topViewController;
        [cont setOnlyFavorites:TRUE];
    }
}


// Sidebar


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
