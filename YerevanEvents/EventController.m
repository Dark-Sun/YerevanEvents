//
//  EventController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/24/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "EventController.h"
#import "Event.h"
#import "Venue.h"
#import "VenueLocationController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface EventController () {
    Event *event;
}
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (weak, nonatomic) IBOutlet UITextView *desc;
- (IBAction)addToFavTapped:(id)sender;

@end

@implementation EventController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"id: %@", _eventID);
    event = [Event byId:_eventID];

    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",
                          baseApiUrl, [event valueForKey:@"original_photo_url"]];
    
    [[self image] sd_setImageWithURL:[NSURL URLWithString: imageUrl]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"MMM dd, yyyy HH:mm"];
//    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *date = [dateformater stringFromDate: [event valueForKey:@"time"]];
    
    [[self date] setText: date];
    NSLog(@"%@", [event valueForKey:@"time"]);
    NSLog(@"%@", date);
    NSLog(@"desc!!! %@", [event valueForKey:@"desc"]);
    [[self desc] setText:[event valueForKey:@"desc"]];
    
    self.favoritesButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to

    if ([[event valueForKey:@"favorite"] boolValue]) {
        [self.favoritesButton setTitle:@"Remove from favorites" forState:UIControlStateNormal];
        [self.favoritesButton setImage:[UIImage imageNamed:@"remove_from_fav.png"] forState:UIControlStateNormal];
    } else {
        [self.favoritesButton setTitle:@"Add to favorites" forState:UIControlStateNormal];
        [self.favoritesButton setImage:[UIImage imageNamed:@"event_add_to_fav"] forState:UIControlStateNormal];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"eventLocationSegue"]) {
        NSNumber *venueId = [event valueForKey: @"venue_id"];
        Venue *venue = [Venue byId:venueId];
        VenueLocationController *vcToPushTo = (VenueLocationController*)segue.destinationViewController;
        vcToPushTo.venueAddress = [venue valueForKey:@"address"];
        vcToPushTo.venueName = [venue valueForKey:@"name"];
        vcToPushTo.coordinates = [[CLLocation alloc] initWithLatitude:[[venue valueForKey:@"latitude"] doubleValue]
                                                            longitude:[[venue valueForKey:@"longitude"] doubleValue]];
    }
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

- (IBAction)addToFavTapped:(id)sender {
    [Event toogleFavoriteById: [event valueForKey: @"id"]];
    if ([[event valueForKey:@"favorite"] boolValue]) {
        [UIView animateWithDuration:100 animations:^(void) {
            [self.favoritesButton setTitle:@"Remove from favorites" forState:UIControlStateNormal];
            [self.favoritesButton setImage:[UIImage imageNamed:@"remove_from_fav.png"] forState:UIControlStateNormal];
        }];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        NSDate *time = [[event valueForKey:@"time"] dateByAddingTimeInterval:-5400*4];
        NSLog(@"time - %@", time);
        localNotification.fireDate = time;
        NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
        [dateformater setDateFormat:@"HH:mm"];
        //    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        NSString *dateString = [dateformater stringFromDate: [event valueForKey:@"time"]];
        localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@",
                                       [event valueForKey:@"name"],
                                       dateString ];
        localNotification.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        localNotification.userInfo = @{@"name" : [event valueForKey:@"name"]};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
        [UIView animateWithDuration:100 animations:^(void) {
            [self.favoritesButton setTitle:@"Add to favorites" forState:UIControlStateNormal];
            [self.favoritesButton setImage:[UIImage imageNamed:@"event_add_to_fav"] forState:UIControlStateNormal];
        }];
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
}
@end
