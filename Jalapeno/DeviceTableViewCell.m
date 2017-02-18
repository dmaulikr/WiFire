//
//  DeviceTableViewCell.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

+ (CGFloat)cellHeight{
    return 80;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
