//
//  EventsController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/24/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "EventsController.h"
#import "Event.h"
#import "EventController.h"
#import "VenueLocationController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Venue.h"


@interface EventsController () {
    NSArray *data;
}

@end

@implementation EventsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    
    self.navigationItem.titleView = imageView;
    
    if (self.venueId) {
        NSLog(@"by id!");
        data = [Event byVenueId:_venueId];
    } else if (self.fromTime && self.toTime) {
        data = [Event fromTime:self.fromTime toTime:self.toTime];
        
    } else if (self.onlyFavorites) {
        data = [Event onlyFavorites];
    } else {
        data = [Event all];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([data count] == 0) {
        return 1;
    } else {
        return [data count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([data count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text  = @"No events";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"eventsTableCell" forIndexPath:indexPath];
    // 100 - image, 101 - time label, 103 - event name

    
    UIImageView *image = (UIImageView*) [cell viewWithTag:100];
    [image setContentMode:UIViewContentModeScaleAspectFill];
    
     NSString *imageUrl = [NSString stringWithFormat:@"%@%@", baseApiUrl, [[data objectAtIndex:indexPath.row] valueForKey:@"original_photo_url"]];

    [image sd_setImageWithURL:[NSURL URLWithString: imageUrl]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UILabel *time = (UILabel*) [cell viewWithTag:101];
//    time.text = [;
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd, yyyy HH:MM"];
    NSString *date = [dateformater stringFromDate: [[data objectAtIndex:indexPath.row] valueForKey:@"time"]];
    time.text = date;
    
    UILabel *name = (UILabel*) [cell viewWithTag:103];
    name.text = [[data objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if(cell.subviews.count > 0 && cell.subviews[0].subviews.count > 2) {
        //        UIButton *addToFav = (UIButton*) cell.subviews[0].subviews[2];
        UIButton *addToFav = (UIButton*) [cell viewWithTag:300];
        if ([[[data objectAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
            [addToFav setImage:[UIImage imageNamed:@"remove_from_fav.png"] forState:UIControlStateNormal];
            [addToFav setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        } else {
            [addToFav setImage:[UIImage imageNamed:@"event_add_to_fav.png"] forState:UIControlStateNormal];
            [addToFav setTitle:@"Add to favorites" forState:UIControlStateNormal];
        }
        addToFav.tag = indexPath.row;
        [addToFav addTarget:self action:@selector(addToFavTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"eventSegue"]) {
        EventController *vcToPushTo = (EventController*)segue.destinationViewController;
        NSInteger selectedRowIndex = [[self.tableView indexPathForSelectedRow] row];
        vcToPushTo.eventID = [[data objectAtIndex: selectedRowIndex] valueForKey: @"id"];
    } else if([segue.identifier isEqual:@"eventLocationSegue"]) {
        NSInteger selectedRowIndex = [[self.tableView indexPathForSelectedRow] row];
        NSNumber *venueId = [[data objectAtIndex: selectedRowIndex] valueForKey: @"venue_id"];
        Venue *venue = [Venue byId:venueId];
        VenueLocationController *vcToPushTo = (VenueLocationController*)segue.destinationViewController;
        vcToPushTo.venueAddress = [venue valueForKey:@"address"];
        vcToPushTo.venueName = [venue valueForKey:@"name"];
        vcToPushTo.coordinates = [[CLLocation alloc] initWithLatitude:[[venue valueForKey:@"latitude"] doubleValue]
                                                            longitude:[[venue valueForKey:@"longitude"] doubleValue]];
    }
}

- (void) addToFavTapped: (id) sender {
    NSLog(@"tap!!");
    UIButton *button = (UIButton*) sender;
    NSInteger tag = button.tag;
    NSNumber *id_ = [[data objectAtIndex:tag] valueForKey:@"id"];
    Event *event = [data objectAtIndex:tag];
    [Event toogleFavoriteById: id_];
    if ([[[data objectAtIndex:tag] valueForKey:@"favorite"] boolValue]) {
        [button setImage:[UIImage imageNamed:@"event_add_to_fav.png"] forState:UIControlStateNormal];
        [button setTitle:@"Add to favorites" forState:UIControlStateNormal];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        NSDate *time = [[event valueForKey:@"time"] dateByAddingTimeInterval:-5400*4];
        NSLog(@"time - %@", time);
        localNotification.fireDate = time;
        NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
        [dateformater setDateFormat:@"HH:mm"];
        NSString *dateString = [dateformater stringFromDate: [event valueForKey:@"time"]];
        localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@",
                                       [event valueForKey:@"name"],
                                       dateString ];
        localNotification.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        localNotification.userInfo = @{@"name" : [event valueForKey:@"name"]};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
        [button setImage:[UIImage imageNamed:@"remove_from_fav.png"] forState:UIControlStateNormal];
        [button setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *name=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"name"]];
            if ([name isEqualToString:[event valueForKey:@"name"]])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    button.tag = 300;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
