//
//  WTGraphViewController.m
//  wattTime 0.4
//
//  Created by Colin McCormick on 9/24/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTGraphViewController.h"

@implementation WTGraphViewController

#pragma mark - My methods

// Strip chart was tapped.  Update display.
- (IBAction)stripChartWasTapped:(id)sender {
    [self updateDisplay];
}

// Update the time.  Update only every 5 seconds to reduce cost.
- (void)updateTimer {
    [updateTimer invalidate];
    updateTimer = nil;
    currentDate = [NSDate date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *theCurrentHour = [timeFormatter stringFromDate:currentDate];
    timeLabel.text = theCurrentHour;
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

// Update display using data from dataModel
- (void)updateDisplay {
    
    // Set up spinner to display while waiting for download
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160,180);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Send download request (use second thread to avoid blocking main thread)
    dispatch_queue_t fetch_queue = dispatch_queue_create("JSON Fetch", NULL);
    dispatch_async(fetch_queue, ^{
        
        NSArray *arrayOfIntervalData = [dataModel generateArrayOfIntervalData];
        
        // Put back on the main thread to use UIKit
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (arrayOfIntervalData) {
                
                // Display interval data on strip chart
                [self loadIntervalDataIntoChart:arrayOfIntervalData];
                
                // Extract element of interval array corresponding to the current time (in the app time zone)
                NSDictionary *currentInterval = [self getCurrentIntervalData:arrayOfIntervalData];
                NSNumber *percentGreen = [currentInterval valueForKey:PERCENT_GREEN_KEY];
                percentGreenLabel.text = [NSString stringWithFormat:PERCENT_GREEN_LABEL_STRING, [percentGreen floatValue]];
            } else {
                percentGreenLabel.text = @"N/A";
            }
            [spinner stopAnimating];
        });
    });
}

// Extract correct data element from interval array for current time (varies by ISO/RTO)
- (NSDictionary *)getCurrentIntervalData:(NSArray *)arrayOfIntervalData {
    
    // Set up date formatter to match JSON date strings
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:JSON_DATE_FORMAT];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    // Search entries of interval array
    NSDate *currentTime = [NSDate date];
    NSArray *arrayOfLocalTimes = [arrayOfIntervalData valueForKey:LOCAL_TIME_KEY];
    for (NSString *aTimeString in arrayOfLocalTimes) {
        NSDate *intervalTime = [formatter dateFromString:aTimeString];
        if ([currentTime earlierDate:intervalTime] == currentTime) {
            // intervalTime is the first interval after currentTime, so we want previous entry
            NSUInteger index = [arrayOfLocalTimes indexOfObject:aTimeString];
            // Unless this is the first element in the array
            index = (index == 0) ? 0 : index - 1;
            return [arrayOfIntervalData objectAtIndex:index];
        }
    }
    // We ran through the entire arrayOfIntervalData, so we want the last entry
    return [arrayOfIntervalData lastObject];
}

// Put points from interval data into strip chart property for display
- (void)loadIntervalDataIntoChart:(NSArray *)arrayOfIntervalData {
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in arrayOfIntervalData) {
        NSDictionary *newDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:LOCAL_TIME_KEY], @"date", [dictionary objectForKey:PERCENT_GREEN_KEY], @"percent", nil];
        // Special case for California (don't display forecast)
        NSNumber *forecastCode = [dictionary objectForKey:@"forecast_code"];
        if (forecastCode != nil) {
            if ([forecastCode intValue] == 1) {
                break;
            }
        }
        [arrayOfPoints addObject:newDictionary];
    }
    stripChart.chartPoints = arrayOfPoints;
    [stripChart setNeedsDisplay];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Find pointer to the data model
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Start timer, update display, update location
    [self updateTimer];
    [self updateDisplay];
    locationLabel.text = dataModel.currentLocation;
}

@end
