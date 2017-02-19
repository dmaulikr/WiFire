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
@property (weak, nonatomic) IBOutlet UILabel *liveNoiseLabel;

@property (strong, nonatomic) IBOutlet PieChartView *chartView;
@property (strong, nonatomic) IBOutlet LineChartView *tempLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *flameLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *gasLiveChart;
@property (strong, nonatomic) IBOutlet LineChartView *noiseLiveChart;

@property (strong, nonatomic) LineChartDataSet *tempChartDataLive;
@property (strong, nonatomic) LineChartDataSet *flameChartDataLive;
@property (strong, nonatomic) LineChartDataSet *gasChartDataLive;
@property (strong, nonatomic) LineChartDataSet *noiseChartDataLive;

@property (nonatomic) double counter;

@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Hall 17";
    [self setupPieChartView:self.chartView];
    [self setupLineChartView:self.tempLiveChart];
    [self setupLineChartView:self.flameLiveChart];
    [self setupLineChartView:self.gasLiveChart];
    [self setupLineChartView:self.noiseLiveChart];


    self.tempChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Temperature"];
    self.flameChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Flame"];
    self.gasChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Gas"];
    self.noiseChartDataLive = [[LineChartDataSet alloc] initWithValues:nil label:@"Noise"];

    [self configureSet:self.tempChartDataLive];
    [self configureSet:self.flameChartDataLive];
    [self configureSet:self.gasChartDataLive];
    [self configureSet:self.noiseChartDataLive];


    self.counter = 0;
    [self addHistoricalData];
    [self appendCurrentResponseData:nil];

    [NSTimer scheduledTimerWithTimeInterval:5.f
                                     target:self selector:@selector(appendCurrentResponseData:) userInfo:nil repeats:YES];

}

- (void)addHistoricalData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://130.245.183.173/api/history" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        for (NSDictionary *dict in responseObject){
            NSInteger tempValue = [[dict objectForKey:@"temp"]integerValue];
            NSInteger flameValue = [[dict objectForKey:@"flame"]integerValue];
            NSInteger gasValue = [[dict objectForKey:@"gas"]integerValue];
            NSInteger noiseValue = [[dict objectForKey:@"sound"]integerValue];
            
            ChartDataEntry *newTempEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:tempValue];
            ChartDataEntry *newFlameEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:flameValue];
            ChartDataEntry *newGasEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:gasValue];
            ChartDataEntry *newNoiseEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:noiseValue];

            
            [self.tempChartDataLive addEntry:newTempEntry];
            [self.flameChartDataLive addEntry:newFlameEntry];
            [self.gasChartDataLive addEntry:newGasEntry];
            [self.noiseChartDataLive addEntry:newNoiseEntry];

            self.counter = self.counter + 1;
        }
        
        
        [self updateChart];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)setupLineChartView:(LineChartView *)chart{
    chart.delegate = self;
    chart.chartDescription.enabled = NO;
    chart.drawGridBackgroundEnabled = NO;
    chart.drawBordersEnabled = NO;
    chart.dragEnabled = YES;
    [chart setScaleEnabled:YES];
    chart.pinchZoomEnabled = NO;
    chart.xAxis.enabled = YES;
    chart.xAxis.granularity = 5;
    chart.chartDescription.enabled = NO;
    chart.rightAxis.enabled = NO;
    chart.leftAxis.drawGridLinesEnabled = NO;
    chart.legend.enabled = NO;
    [chart.leftAxis setLabelTextColor:[UIColor whiteColor]];
    [chart.xAxis setLabelTextColor:[UIColor flatWhiteColorDark]];
}

- (void)appendCurrentResponseData:(NSTimer *)timer{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"http://130.245.183.173" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSInteger tempValue = [[responseObject objectForKey:@"temp"]integerValue];
        NSInteger flameValue = [[responseObject objectForKey:@"flame"]integerValue];
        NSInteger gasValue = [[responseObject objectForKey:@"gas"]integerValue];
        NSInteger noiseValue = [[responseObject objectForKey:@"sound"]integerValue];

        NSString *status = [responseObject objectForKey:@"level"];
        
        if([status isEqualToString:@"warning"]){
            [self updatePieChart:@[[UIColor flatYellowColorDark], [UIColor flatMintColor], [UIColor flatMintColor], [UIColor flatMintColor]] isSecure:NO];
        }
        else if ([status isEqualToString:@"danger"]){
            [self updatePieChart:@[[UIColor flatMintColor],[UIColor flatWatermelonColor],[UIColor flatMintColor],[UIColor flatMintColor]] isSecure:NO];
        } else{
            [self updatePieChart:@[[UIColor flatMintColor],[UIColor flatMintColor],[UIColor flatMintColor],[UIColor flatMintColor]] isSecure:YES];
        }
        
        ChartDataEntry *newTempEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:tempValue];
        ChartDataEntry *newFlameEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:flameValue];
        ChartDataEntry *newGasEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:gasValue];
        ChartDataEntry *newNoiseEntry = [[ChartDataEntry alloc] initWithX:self.counter * 5 y:noiseValue];

        
        [self.tempChartDataLive addEntry:newTempEntry];
        [self.flameChartDataLive addEntry:newFlameEntry];
        [self.gasChartDataLive addEntry:newGasEntry];
        [self.noiseChartDataLive addEntry:newNoiseEntry];

        
        [self updateChart];
        self.liveTemperatureLabel.text = [NSString stringWithFormat:@"%ld\u00B0F", (long)tempValue];
        self.liveFlameLabel.text = [NSString stringWithFormat:@"%ldu", (long)flameValue];
        self.liveGasLabel.text = [NSString stringWithFormat:@"%ldlv", (long)gasValue];
        self.liveNoiseLabel.text = [NSString stringWithFormat:@"%lddB", (long)noiseValue];


        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    self.counter = self.counter + 1;
    if (self.counter > 15){
        [self.tempChartDataLive removeFirst];
        [self.gasChartDataLive removeFirst];
        [self.flameChartDataLive removeFirst];
        [self.noiseChartDataLive removeFirst];
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
    LineChartData *noiseData = [[LineChartData alloc]initWithDataSet:self.noiseChartDataLive];

    self.tempLiveChart.data = tempData;
    self.flameLiveChart.data = flameData;
    self.gasLiveChart.data = gasData;
    self.noiseLiveChart.data = noiseData;


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
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:20.f],
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
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Temp"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Flame"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Gas"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Noise"]];

    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Secure"];
    dataSet.sliceSpace = 2.0;
    dataSet.colors = colors;
    dataSet.drawValuesEnabled = NO;

        //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    
    chartView.data = data;
    [chartView highlightValues:nil];
    
}

- (void)updatePieChart:(NSArray *)array isSecure:(BOOL)secure{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Temp"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Flame"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Gas"]];
    [values addObject:[[PieChartDataEntry alloc] initWithValue: 25 label:@"Noise"]];
    
    NSString *centerMessage = @"";
    if(secure){
        centerMessage = @"Secure";
    } else{
        centerMessage = @"Warning";
    }
        
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Secure"];
    dataSet.sliceSpace = 2.0;
    dataSet.colors = array;
    dataSet.drawValuesEnabled = NO;
    
        //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:centerMessage];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:20.f],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSForegroundColorAttributeName : [UIColor whiteColor]
                                } range:NSMakeRange(0, centerText.length)];
    
    self.chartView.centerAttributedText = centerText;
    
    self.chartView.data = data;
}




@end
