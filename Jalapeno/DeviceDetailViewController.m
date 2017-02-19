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

@import Charts;
@import ChameleonFramework;

@interface DeviceDetailViewController () <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *liveTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveFlameLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveGasLabel;

@property (strong, nonatomic) IBOutlet PieChartView *chartView;
@property (strong, nonatomic) IBOutlet LineChartView *tempLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *flameLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *gasLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *noiseLiveChart;

@property (strong, nonatomic) LineChartDataSet *tempChartDataLive;
@property (strong, nonatomic) LineChartDataSet *flameChartDataLive;
@property (strong, nonatomic) LineChartDataSet *gasChartDataLive;

@property (nonatomic) double counter;

@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPieChartView:self.chartView];
    [self setupLineChartView:self.tempLiveChart];
    [self setupLineChartView:self.flameLiveChart];
    [self setupLineChartView:self.gasLiveChart];

    self.tempChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Temperature"];
    self.flameChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Temperature"];
    self.gasChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Temperature"];
    [self configureSet:self.tempChartDataLive];
    [self configureSet:self.flameChartDataLive];
    [self configureSet:self.gasChartDataLive];

    self.counter = 0;
    [self appendCurrentResponseData:nil];

    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self selector:@selector(appendCurrentResponseData:) userInfo:nil repeats:YES];

}

- (void)setupLineChartView:(LineChartView *)chart{
    chart.delegate = self;
    chart.chartDescription.enabled = NO;
    chart.drawGridBackgroundEnabled = NO;
    chart.drawBordersEnabled = NO;
    chart.dragEnabled = YES;
    [chart setScaleEnabled:YES];
    chart.pinchZoomEnabled = NO;
    chart.xAxis.enabled = NO;
    chart.chartDescription.enabled = NO;
    chart.rightAxis.enabled = NO;
    chart.leftAxis.drawGridLinesEnabled = NO;
    chart.legend.enabled = NO;
    [chart.leftAxis setLabelTextColor:[UIColor whiteColor]];
}

- (void)appendCurrentResponseData:(NSTimer *)timer{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://130.245.183.173" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSInteger tempValue = [[responseObject objectForKey:@"temp"]integerValue];
        NSInteger flameValue = [[responseObject objectForKey:@"flame"]integerValue];
        NSInteger gasValue = [[responseObject objectForKey:@"gas"]integerValue];
        
        ChartDataEntry *newTempEntry = [[ChartDataEntry alloc] initWithX:self.counter * 2 y:tempValue];
        ChartDataEntry *newFlameEntry = [[ChartDataEntry alloc] initWithX:self.counter * 2 y:flameValue];
        ChartDataEntry *newGasEntry = [[ChartDataEntry alloc] initWithX:self.counter * 2 y:gasValue];
        
        [self.tempChartDataLive addEntry:newTempEntry];
        [self.flameChartDataLive addEntry:newFlameEntry];
        [self.gasChartDataLive addEntry:newGasEntry];
        
        [self updateChart];
        self.liveTemperatureLabel.text = [NSString stringWithFormat:@"%ld\u00B0C", (long)tempValue];
        self.liveFlameLabel.text = [NSString stringWithFormat:@"%ld", (long)flameValue];
        self.liveGasLabel.text = [NSString stringWithFormat:@"%ld", (long)gasValue];

        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    self.counter = self.counter + 1;
    if (self.counter > 20){
        [self.tempChartDataLive removeFirst];
        [self.gasChartDataLive removeFirst];
        [self.flameChartDataLive removeFirst];

    }
}

- (void)configureSet:(LineChartDataSet *)set{
    [set setColor:[UIColor flatMintColor]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor flatMintColor]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.fillColor = [UIColor flatMintColor];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor flatMintColor];
    set.axisDependency = AxisDependencyLeft;
}


- (void)updateChart{
    LineChartData *tempData = [[LineChartData alloc]initWithDataSet:self.tempChartDataLive];
    LineChartData *flameData = [[LineChartData alloc]initWithDataSet:self.flameChartDataLive];
    LineChartData *gasData = [[LineChartData alloc]initWithDataSet:self.gasChartDataLive];
    self.tempLiveChart.data = tempData;
    self.flameLiveChart.data = flameData;
    self.gasLiveChart.data = gasData;

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
    
    chartView.delegate = self;
    [chartView.legend setEnabled:NO];
    [chartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    
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
    
    
    chartView.data = data;
    [chartView highlightValues:nil];
    
}


@end
