//
//  DeviceTableViewCell.h
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
+ (CGFloat)cellHeight;
@end
