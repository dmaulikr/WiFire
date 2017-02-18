//
//  DeviceDetailViewController.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *flameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"West Wing - 14th Hall";
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"datadummy" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        // Parse the string into JSON
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"Temperature:%@",[[jsonObject objectForKey:@"temp"] stringValue]];
    
    if([[jsonObject objectForKey:@"flame"] boolValue]){
        self.flameLabel.text = @"Flame: Warning.  Flame Danger";
    } else{
        self.flameLabel.text = @"Flame: Safe!";
    }
    if([[jsonObject objectForKey:@"gas"] boolValue]){
        self.gasLabel.text = @"Gas: Warning.  Gas Danger!";
    } else{
        self.gasLabel.text = @"Gas: Safe!";
    }

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
