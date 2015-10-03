//
//  VenuesControllerTableViewController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "VenuesController.h"
#import "VenueViewController.h"
#import "Venue.h"
#import "Sync.h"
#import "Config.h"

@interface VenuesController () {
    NSArray *data;
}

@end

@implementation VenuesController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    self.navigationItem.titleView = imageView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}

- (void) viewWillAppear:(BOOL)animated {
    
    if (self.categoryId) {
        data = [Venue byCategoryId: self.categoryId];
        
    } else if (self.onlyFavorites) {
        data = [Venue onlyFavorites];
    } else {
        data = [Venue all];
    }
    
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    
    if([data count] ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"No venues";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    NSString *reuseIdentifier;
    
    if (indexPath.row % 2) {
        reuseIdentifier = @"venuesTableCell1";
    } else {
        reuseIdentifier = @"venuesTableCell2";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", baseApiUrl, [[data objectAtIndex:indexPath.row] valueForKey:@"thumb_photo_url"]];
    
    
    
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:100];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString: imageUrl]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:  [[data objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    NSRange firstLetter = NSMakeRange(0, 1);
    [text setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],
                          NSForegroundColorAttributeName: [UIColor redColor]}
                  range:firstLetter];
    
    UILabel *label = (UILabel*) [cell viewWithTag:200];
    label.attributedText = text;
    
    if(cell.subviews.count > 0 && cell.subviews[0].subviews.count > 2) {
//        UIButton *addToFav = (UIButton*) cell.subviews[0].subviews[2];
        UIButton *addToFav = (UIButton*) [cell viewWithTag:300];
        if ([[[data objectAtIndex:indexPath.row] valueForKey:@"favorite"] boolValue]) {
            addToFav.imageView.image = [UIImage imageNamed:@"remove_from_fav.png"];
        } else {
            addToFav.imageView.image = [UIImage imageNamed:@"add_to_fav.png"];

        }
        addToFav.tag = indexPath.row;
        [addToFav addTarget:self action:@selector(addToFavTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"venueSegue"]) {
        VenueViewController *vcToPushTo = (VenueViewController*) segue.destinationViewController;
        NSInteger selectedRowIndex = [[self.tableView indexPathForSelectedRow] row];
        NSNumber *id_ = [NSNumber numberWithInt: [[[data objectAtIndex: selectedRowIndex] valueForKey: @"id"] integerValue]];
        vcToPushTo.categoryId = id_;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void) addToFavTapped: (id) sender {
    UIButton *button = (UIButton*) sender;
    NSInteger tag = button.tag;
    NSNumber *id_ = [[data objectAtIndex:tag] valueForKey:@"id"];
    [Venue toogleFavoriteById: id_];
    if ([[[data objectAtIndex:tag] valueForKey:@"favorite"] boolValue]) {
        button.imageView.image = [UIImage imageNamed:@"add_to_fav.png"];
    } else {
        button.imageView.image = [UIImage imageNamed:@"remove_from_fav.png"];
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
