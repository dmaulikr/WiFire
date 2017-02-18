//
//  DeviceDetailViewController.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DeviceDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *flameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"West Wing - 14th Hall";
    NSLog(@"Reached here");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://130.245.183.173:80/" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        self.temperatureLabel.text = [NSString stringWithFormat:@"Temperature:%@",[[responseObject objectForKey:@"temp"] stringValue]];
        
        if([[responseObject objectForKey:@"flame"] boolValue]){
            self.flameLabel.text = @"Flame: Warning.  Flame Danger";
        } else{
            self.flameLabel.text = @"Flame: Safe!";
        }
        if([[responseObject objectForKey:@"gas"] boolValue]){
            self.gasLabel.text = @"Gas: Warning.  Gas Danger!";
        } else{
            self.gasLabel.text = @"Gas: Safe!";
        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Do any additional setup after loading the view.
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

@end
