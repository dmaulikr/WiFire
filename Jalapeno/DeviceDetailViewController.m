//
//  DeviceDetailViewController.m
//  Jalapeno
//
//  Created by Michael Lee on 2/17/17.
//  Copyright © 2017 Jalapeno. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Jalapeno-Swift.h"
#import <ChameleonFramework/Chameleon.h>

@import Charts;

@interface DeviceDetailViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *flameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@property (strong, nonatomic) IBOutlet PieChartView *circleChart;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPieChartView:self.circleChart];
    self.circleChart.delegate = self;
    [self.circleChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

    NSMutableArray *colors = [[NSMutableArray alloc]init];
    [colors addObject:[UIColor flatMintColor]];
    [colors addObject:[UIColor flatBlueColor]];
    [colors addObject:[UIColor flatPlumColor]];
    [colors addObject:[UIColor flatGrayColor]];

    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"yo"]];
    }
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Secure"];
    dataSet.sliceSpace = 2.0;
    dataSet.colors = colors;
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    self.circleChart.data = data;
    [self.circleChart highlightValues:nil];

    
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
- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = NO;
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Secure"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
}


@end
