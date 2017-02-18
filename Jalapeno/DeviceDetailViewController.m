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
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *flameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@property (strong, nonatomic) IBOutlet PieChartView *chartView;
@property (strong, nonatomic) IBOutlet LineChartView *lineChart;
@property (strong, nonatomic) LineChartDataSet *lineChartDataLive;
@property (nonatomic) double counter;

@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPieChartView:self.chartView];
    [self setupLineChartView:self.lineChart];
    self.lineChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Temperature"];
    [self configureSet:self.lineChartDataLive];
    self.counter = 0;
    [self appendCurrentResponseData:nil];

    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self selector:@selector(appendCurrentResponseData:) userInfo:nil repeats:YES];


    
}

- (void)setupChartView{
    self.lineChart.delegate = self;
    self.lineChart.chartDescription.enabled = NO;
    self.lineChart.drawGridBackgroundEnabled = NO;
    self.lineChart.drawBordersEnabled = NO;
    self.lineChart.dragEnabled = YES;
    [self.lineChart setScaleEnabled:YES];
    self.lineChart.pinchZoomEnabled = NO;
}

- (void)appendCurrentResponseData:(NSTimer *)timer{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://130.245.183.173" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        ChartDataEntry *newEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:[[responseObject objectForKey:@"temp"]integerValue]];
        [self.lineChartDataLive addEntry:newEntry];
        [self updateChart];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    self.counter = self.counter + 1;

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
    LineChartData *data = [[LineChartData alloc]initWithDataSet:self.lineChartDataLive];
    self.lineChart.data = data;
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
- (void)setupLineChartView:(LineChartView *)lineChartView{
    
}
- (LineChartData *)generateLineData
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
//    for (int index = 0; index < ITEM_COUNT; index++)
//    {
//        [entries addObject:[[ChartDataEntry alloc] initWithX:index + 0.5 y:(arc4random_uniform(15) + 5)]];
//    }
//    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Temperature"];
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
    
    [d addDataSet:set];
    
    return d;
}


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
