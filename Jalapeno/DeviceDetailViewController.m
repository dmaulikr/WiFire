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
    [self.circleChart.legend setEnabled:NO];
    [self.circleChart animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

    NSMutableArray *colors = [[NSMutableArray alloc]init];
    [colors addObject:[UIColor flatMintColor]];
 
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"yo"]];
    }
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Secure"];
    dataSet.sliceSpace = 2.0;
    dataSet.colors = colors;
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
        //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    
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
    chartView.holeRadiusPercent = 0.68;
    chartView.transparentCircleRadiusPercent = 0.71;
    chartView.chartDescription.enabled = NO;
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"Secure"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:24.f],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName : [UIColor whiteColor]
                                } range:NSMakeRange(0, centerText.length)];
    
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.holeColor = nil;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
}


@end
