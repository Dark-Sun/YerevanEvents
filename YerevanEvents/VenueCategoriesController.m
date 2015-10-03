//
//  VenuesController.m
//  
//
//  Created by Andriy Lukashchuk on 9/4/15.
//
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "VenueCategoriesController.h"
#import "VenueCategoriesTableViewCell.h"
#import "VenuesController.h"
#import "EventsController.h"
#import "RegistrationController.h"
#import "Sync.h"

@interface VenueCategoriesController () {
    NSArray *data;
    NSNumber *selectedRow;
    
    __weak IBOutlet UITableView *tableView;
   
    __weak IBOutlet UIButton *categoriesButton;
    __weak IBOutlet UIButton *todayButton;
    __weak IBOutlet UIButton *upcomingButton;
}
- (IBAction)todayButtonPressed:(id)sender;
- (IBAction)upcomingButtonPressed:(id)sender;

@end

@implementation VenueCategoriesController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:@"registrationSegue" sender:self];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    self.navigationItem.titleView = imageView;

    
    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIColor *activeButtonColor = [UIColor colorWithRed:0.89 green:0 blue:0 alpha:1]; /*#e30000*/
    UIColor *buttonColor       = [UIColor colorWithRed:0.824 green:0 blue:0.004 alpha:1]; /*#d20001*/

    categoriesButton.backgroundColor = activeButtonColor;
    categoriesButton.tintColor       = [UIColor whiteColor];
    
    todayButton.backgroundColor = buttonColor;
    todayButton.tintColor       = [UIColor whiteColor];
    
    upcomingButton.backgroundColor = buttonColor;
    upcomingButton.tintColor       = [UIColor whiteColor];


    data = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
    data = [VenueCategory all];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *first = [defaults stringForKey:@"first_launch"];
    NSLog(@"%hhd", [first isEqualToString:@"false"]);
    if (![first isEqualToString:@"false"]) {
        [defaults setObject:@"false" forKey:@"first_launch"];
        [Sync synchronizeData: ^(bool response) {
            data = [VenueCategory all];
            [Sync synchronizeUserCategories:^(bool id) {}];
            [tableView reloadData];
        }];
    }
    
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
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    if (indexPath.row % 2) {
        identifier = @"venueCategoryCell1";
    } else {
        identifier = @"venueCategoryCell2";
    }
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:identifier
                                            forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[VenueCategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", baseApiUrl,
                          [[data objectAtIndex:indexPath.row]
                                   valueForKey:@"thumb_image_url"] ];
    
    UIImageView *image = (UIImageView*) [cell viewWithTag:100];
    
    [image setContentMode:UIViewContentModeScaleAspectFit];

    [image sd_setImageWithURL:[NSURL URLWithString: imageUrl]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [[data objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    NSRange firstLetter = NSMakeRange(0, 1);
    [text setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]}
                  range:firstLetter];
    
    UILabel *textLabel = (UILabel*) [cell viewWithTag:200];
    textLabel.attributedText = text;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath {
    return @"firstSegue";
}

- (IBAction)todayButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showEvents" sender:@"today"];

}

- (IBAction)upcomingButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showEvents" sender:@"upcoming"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue!");
    if([segue.identifier isEqual:@"venuesOfCategory"]) {
        VenuesController *vcToPushTo = (VenuesController*)segue.destinationViewController;
        NSInteger selectedRowIndex = [[tableView indexPathForSelectedRow] row];
        vcToPushTo.categoryId = [[data objectAtIndex: selectedRowIndex] valueForKey: @"id" ];
    } else if ([segue.identifier isEqual:@"showEvents"] && [sender isEqualToString:@"today"]) {
        NSLog(@"Today!");
        EventsController  *vcToPushTo = (EventsController*)segue.destinationViewController;
                NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDate *date = [NSDate date];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                         fromDate:date];
        NSDate *today = [cal dateFromComponents:comps];
        [comps setDay:2];
        NSDate *tomorrow = [cal dateFromComponents:comps];

        vcToPushTo.fromTime = today;
        vcToPushTo.toTime   = tomorrow;
    } else if ([segue.identifier isEqual:@"showEvents"] && [sender isEqualToString:@"upcoming"]) {
        NSLog(@"Upcoming!");
        EventsController *vcToPushTo = (EventsController*)segue.destinationViewController;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDate *date = [NSDate date];
        NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                         fromDate:date];
        [comps setDay:2];
        NSDate *tomorrow = [cal dateFromComponents:comps];
        [comps setDay:10000];
        NSDate *future = [cal dateFromComponents:comps];
        
        vcToPushTo.fromTime = tomorrow;
        vcToPushTo.toTime   = future;
    }

}
//
//-(NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath {
//    return @"leftMenu";
//}

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
