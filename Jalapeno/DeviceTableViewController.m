//
//  DeviceTableViewController.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "DeviceTableViewController.h"
#import "DeviceDetailViewController.h"
#import "DeviceTableViewCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Jalapeno-Swift.h"

@import ChameleonFramework;

@interface DeviceTableViewController ()

@end


@implementation DeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.title = @"Sensor Groups";

    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor flatNavyBlueColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
    cell.backgroundColor = [UIColor flatNavyBlueColor];
    if(indexPath.row == 0){
        cell.deviceNameLabel.text = @"West Wing A7 - 14th Hall";
        cell.statusLabel.text = safeStatus;
        cell.statusLabel.textColor = [UIColor flatMintColor];
        cell.statusMessageLabel.text = @"All sensor readings normal.";
        cell.statusBarView.backgroundColor = [UIColor flatMintColor];
    } else if (indexPath.row == 1){
        cell.deviceNameLabel.text = @"East Wing B6 - 2nd Hall";
        cell.statusLabel.text = warningStatus;
        cell.statusLabel.textColor = [UIColor flatYellowColorDark];
        cell.statusMessageLabel.text = @"Elevated temperature detected.";
        cell.statusBarView.backgroundColor = [UIColor flatYellowColorDark];
    } else{
        cell.deviceNameLabel.text = @"1st Floor Utility - 4th Hall";
        cell.statusLabel.text = dangerStatus;
        cell.statusLabel.textColor = [UIColor flatWatermelonColor];
        cell.statusMessageLabel.text = @"Gas leak detected!";
        cell.statusBarView.backgroundColor = [UIColor flatWatermelonColor];
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDetailViewController *infoVC = [GetAppDelegate.storyboard instantiateViewControllerWithIdentifier:@"DeviceDetailViewController"];
    [self.navigationController pushViewController:infoVC animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DeviceTableViewCell cellHeight];
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
