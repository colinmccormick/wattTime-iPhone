//
//  WTMainViewController.h
//  wattTime v0.1
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WTFlipsideViewController.h"
#import "WTStripChart.h"

#define BASE_URL @"http://watttime.com/"
#define TODAY_REQUEST @"today?st="
#define PERCENT_GREEN_KEY @"percent_green"
#define LOCAL_TIME_KEY @"local_time"
#define TIME_LABEL_STRING @"At %@ in"
#define PERCENT_GREEN_LABEL_STRING @"the grid is %0.1f%% green."

@interface WTMainViewController : UIViewController <WTFlipsideViewControllerDelegate, UIPopoverControllerDelegate> {

    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *percentGreenLabel; 
    __weak IBOutlet UIButton *updateButton;
    __weak IBOutlet UIButton *whereButton;
    __weak IBOutlet WTStripChart *stripChart;
    
    NSDate *currentDate;
    NSTimer *updateTimer;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSArray *locationArray;

- (IBAction)updateButtonWasTapped:(id)sender;
- (void)updateLocation:(NSString *)location;
- (void)fetchDataAndUpdateDisplay;

- (NSDictionary *)getCurrentIntervalDataFromJSONArray:(NSArray *)arrayOfJSONData;
- (void)loadDataFromJSONArrayIntoChart:(NSArray *)arrayOfJSONData;

@end
