//
//  WTMainViewController.h
//  wattTime v0.3
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTAppDelegate.h"
#import "WTStripChart.h"

#define TIME_LABEL_STRING @"At %@ in"
#define PERCENT_GREEN_LABEL_STRING @"the grid is %0.1f%% green."

@interface WTMainViewController : UIViewController {

    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *percentGreenLabel; 
    __weak IBOutlet WTStripChart *stripChart;
    __weak WTDataModel *dataModel;
    
    NSDate *currentDate;
    NSTimer *updateTimer;
}

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *stripChartTapGestureRecognizer;

- (void)updateTimer;
- (void)updateDisplay;
- (void)loadIntervalDataIntoChart:(NSArray *)arrayOfIntervalData;
- (NSDictionary *)getCurrentIntervalData:(NSArray *)arrayOfIntervalData;
- (IBAction)stripChartWasTapped:(id)sender;
@end
