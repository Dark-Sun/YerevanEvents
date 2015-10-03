//
//  VenueCategoriesTableViewCell.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 9/22/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "VenueCategoriesTableViewCell.h"

@implementation VenueCategoriesTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"!!!!");
//    self.imageView.bounds = CGRectMake(6,20,40,40);
    self.imageView.frame = CGRectMake(8,15,40,40);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 60;
    self.textLabel.frame = tmpFrame;
    
}

@end
