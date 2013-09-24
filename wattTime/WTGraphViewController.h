//
//  WTGraphViewController.h
//  wattTime 0.4
//
//  Created by Colin McCormick on 9/24/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"
#import "WTStripChart.h"

@interface WTGraphViewController : UIViewController {
    
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
