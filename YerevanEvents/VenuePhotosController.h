//
//  VenuePhotosController.h
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/30/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface VenuePhotosController : UIViewController <MWPhotoBrowserDelegate>

@property NSMutableArray *photos;
@end
