//
//  LoginViewController.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "LoginViewController.h"
#import "DeviceTableViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.spinner.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginTapped:(id)sender {
        //Put in dummy login validation
    
    if([self.usernameField.text isEqualToString:@"demo"] && [self.passwordField.text isEqualToString:@"password"]){
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
        [NSThread sleepForTimeInterval:1.0f];
        [self.spinner stopAnimating];
        self.spinner.hidden = YES;
        DeviceTableViewController *infoVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"DeviceTableViewController"];
        [self presentViewController:infoVC animated:true completion:nil];
    } else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message: @"Username or password was incorrect" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
