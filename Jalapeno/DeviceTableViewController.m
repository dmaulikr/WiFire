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

@interface DeviceTableViewController ()

@end


@implementation DeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sensor Groups";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    if(indexPath.row == 0){
        cell.deviceNameLabel.text = @"West Wing A7 - 14th Hall";
        cell.statusLabel.text = safeStatus;
        cell.statusMessageLabel.text = @"All sensor readings normal.";
        cell.statusBarView.backgroundColor = [UIColor colorWithRed:0.180 green:0.698 blue:0.529 alpha:1.00];
    } else if (indexPath.row == 1){
        cell.deviceNameLabel.text = @"East Wing B6 - 2nd Hall";
        cell.statusLabel.text = warningStatus;
        cell.statusMessageLabel.text = @"Elevated temperature detected.";
        cell.statusBarView.backgroundColor = [UIColor colorWithRed:0.96 green:0.63 blue:0.17 alpha:1.00];
    } else{
        cell.deviceNameLabel.text = @"1st Floor Utility - 4th Hall";
        cell.statusLabel.text = dangerStatus;
        cell.statusMessageLabel.text = @"Gas leak detected!";
        cell.statusBarView.backgroundColor = [UIColor colorWithRed:0.87 green:0.27 blue:0.18 alpha:1.00];
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
