//
//  RegistrationController.m
//  YerevanEvents
//
//  Created by Andriy Lukashchuk on 10/2/15.
//  Copyright © 2015 Codegemz. All rights reserved.
//

#import "UserCategory.h"
#import "RegistrationController.h"
#import "User.h"
#import <TSMessage.h>
#import <TSMessageView.h>
#import <MBProgressHUD.h>

@interface RegistrationController () {
    NSMutableArray *switches;
    NSArray *categories;
}

@property (weak, nonatomic) IBOutlet UIView *categoriesContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoriesContainerHeight;
- (IBAction)skipButtonTapped:(id)sender;
- (IBAction)registerButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *email;
@property (weak, nonatomic) IBOutlet UIView *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation RegistrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switches = [[NSMutableArray alloc] init];
    
    categories = [UserCategory all];
    int index = 0;
    for(int i=0; i < categories.count + 1; i++) {
        UISwitch *uiswitch = [[UISwitch alloc] initWithFrame:CGRectMake(251, index*35, 49, 31)];
        if (index == 0) {
            [uiswitch addTarget:self action:@selector(allSwitchTapped:) forControlEvents:UIControlEventTouchUpInside];
        } else {
           [uiswitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        [switches addObject:uiswitch];
        
        UILabel  *label    = [[UILabel alloc] initWithFrame:CGRectMake(4, index*35, 251, 31)];
        label.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
        label.font      = [UIFont systemFontOfSize:14.0f];
        
        if (index == 0) {
            label.text = @"All";
        } else {
            label.text = [categories[i-1] valueForKey:@"name"];
        }
        
        [self.categoriesContainer addSubview:uiswitch];
        [self.categoriesContainer addSubview:label];
        index += 1;
    }
    self.categoriesContainerHeight.constant = categories.count * 35 + 35;
}

- (void) allSwitchTapped: (id) sender {
    UISwitch *uiswitch = (UISwitch*) sender;
    for (int i=1; i < switches.count; i++) {
        UISwitch* currentSwitch = switches[i];
        [currentSwitch setOn:uiswitch.on animated:TRUE];
    }
}

- (void) switchTapped: (id) sender {
    
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

- (IBAction)skipButtonTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)registerButtonTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *onCategories = [[NSMutableDictionary alloc] init];
    for(int i=0; i < categories.count ; i++) {
        UISwitch *uiswitch = (UISwitch*) switches[i+1];
        if (uiswitch.on) {
            NSString *categoryId = [[categories[i] valueForKey:@"id"] stringValue];
            [onCategories setValue: categoryId forKey:@"category_id"];
        }
    }
    
    NSString *emailString    = [(UITextField*) self.email text];
    NSString *nameString     = [(UITextField*) self.name text];
    NSString *phoneString    = [(UITextField*) self.phone text];
    NSString *passwordString = [(UITextField*) self.password text];

    [User signUpWithEmail:emailString
                     name:nameString
                    phone:phoneString
                 password:passwordString
               categories:onCategories
                   result: ^(bool response) {
                       if (response) {
                           [TSMessage showNotificationWithTitle:@"Success"
                                                       subtitle:@"Registered successfully"
                                                           type:TSMessageNotificationTypeSuccess];
                           NSLog(@"register!");
                           
                       } else {
                           [TSMessage showNotificationWithTitle:@"Network error"
                                                       subtitle:@"Couldn't connect to the server"
                                                           type:TSMessageNotificationTypeError];
                           NSLog(@"register fail");
                       }
                       [MBProgressHUD hideHUDForView:self animated:YES];

                   }
     ];
}
@end
