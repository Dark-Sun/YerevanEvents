//
//  VenueViewController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/23/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "Venue.h"
#import "VenueViewController.h"
#import "EventsController.h"
#import "Config.h"
#import "VenueLocationController.h"
#import "VenuePhoto.h"

@interface VenueViewController () {
    NSArray *labels;
    NSArray *icons;
    Venue   *venue;
    __weak IBOutlet UITextView *description;
}

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0,0,3,44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"nav_bg.png"];
    self.navigationItem.titleView = imageView;

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    venue = [Venue byId:_categoryId];
    NSLog(@"%@", [venue valueForKey:@"original_photo_url"]);
    
    description.scrollEnabled = FALSE;
    description.text = [venue valueForKey:@"desc"];
    description.scrollEnabled = TRUE;

    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", baseApiUrl, [venue valueForKey:@"original_photo_url"]];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
             
    [self.image sd_setImageWithURL: imageUrl
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    labels = @[@"Add to favorite venues", @"Events", @"Gallery", @"Address", @"Phone number", @"Facebook"];
    icons = @[@"add_to_fav", @"events", @"gallery", @"address", @"phone", @"fb"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdntifier;
    switch (indexPath.row) {
        case 0: reuseIdntifier = @"addToFav"; break;
        case 1: reuseIdntifier = @"events"; break;
        case 2: reuseIdntifier = @"gallery"; break;
        case 3: reuseIdntifier = @"address"; break;
        case 4: reuseIdntifier = @"phone"; break;
        case 5: reuseIdntifier = @"facebook"; break;
        default: reuseIdntifier = @"venueCell"; break;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdntifier forIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]; /*#f2f2f2*/
    }
    
    UILabel *label = (UILabel*) [cell viewWithTag:200];
    UIImageView *image = (UIImageView*) [cell viewWithTag:100];
    
    if (indexPath.row == 0) {
        // Add to fav
        if ([[venue valueForKey:@"favorite"] boolValue]) {
            label.text = @"Remove from favorite venuess";
            image.image = [UIImage imageNamed:@"remove_from_fav.png"];

        } else {
            label.text = @"Add to favorite venues";
            image.image = [UIImage imageNamed:[icons objectAtIndex:0]];

        }
        return cell;
    }
    
    
    
    label.text = [labels objectAtIndex:indexPath.row];
    
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
   
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: [self addToFav];
            break;
        case 2: [self openGallerey];
            break;
        case 4: [self openPhone:[venue valueForKey: @"phone" ]];
            break;
        case 5: [self openUrl:[venue valueForKey:@"fb_page"]];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"events"]) {
        EventsController *vcToPushTo = (EventsController*)segue.destinationViewController;
        vcToPushTo.venueId = self.categoryId;
    } else if ([segue.identifier isEqualToString:@"openLocation"]) {
        VenueLocationController *vcToPushTo = (VenueLocationController*) segue.destinationViewController;
        
        CLLocation *location = [[CLLocation alloc]
                                initWithLatitude: [[venue valueForKey:@"latitude"] doubleValue]
                                longitude: [[venue valueForKey:@"longitude"] doubleValue]];
        
        vcToPushTo.coordinates = location;
        

        vcToPushTo.venueName    = [venue valueForKey:@"name"];
        vcToPushTo.venueAddress = [venue valueForKey:@"address"];
    }
}

- (void) openPhone: (NSString*) number {
    NSURL *phoneUrl = [NSURL URLWithString: [NSString stringWithFormat:@"telprompt:%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone:"
                                                           message:number
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
    }
}

- (void) openUrl: (NSString*) url {
    if (url.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No facebook page provided"
                                                        message: nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else if ([url rangeOfString:@"http://"].location == NSNotFound || [url rangeOfString:@"https://"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    NSURL *fbUrl = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:fbUrl]) {
        [[UIApplication sharedApplication] openURL:fbUrl];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook:"
                                                        message:url
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) addToFav {
    NSLog(@"add to fav");
    if ([Venue toogleFavoriteById: [venue valueForKey:@"id"]]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }

}


- (void) openGallerey {
    NSArray *fetchedPhotos = [VenuePhoto byVenueId:[venue valueForKey:@"Id"]];
    
    self.thumbs = [NSMutableArray array];
    self.photos = [NSMutableArray array];
    
    for (NSDictionary *photo in fetchedPhotos) {
        NSString *photoUrl = [photo valueForKey:@"photo_url"];
        NSString *thumbUrl = [photo valueForKey:@"thumb_url"];
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photoUrl]]];
        [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:thumbUrl]]];
    }
    
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = YES; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    
    // Present
//    [self.navigationController pushViewController:browser animated:YES];
    [self.navigationController pushViewController:browser animated:FALSE];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];
}

// Gallerey delegates
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    return [self.thumbs objectAtIndex:index];
}

@end
