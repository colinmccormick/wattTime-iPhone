//
//  WTShiftDetailViewController.m
//  wattTime
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "WTShiftDetailViewController.h"

@implementation WTShiftDetailViewController

@synthesize activity = _activity;

#pragma mark - My methods

// Calculate best time to do activity
- (NSDate *)calculateBestTime {
    return [NSDate date];
}

// Calculate carbon saved (projected) for starting activity at startTime
- (NSNumber *)calculateCarbonSavings:(NSDate *)forStartTime {
    return [NSNumber numberWithDouble:5.0];
}

#pragma mark - Original methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Update label showing activity
    activityLabel.numberOfLines = 0;
    activityLabel.text = [NSString stringWithFormat:ACTIVITY_STRING, [self.activity objectForKey:@"YourDescription"]];
    // Update label showing best time
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *bestTime = [self calculateBestTime];
    timeLabel.text = [timeFormatter stringFromDate:bestTime];
    // Update label showing carbon savings
    NSNumber *poundsOfCO2Saved = [self calculateCarbonSavings:bestTime];
    savingsLabel.numberOfLines = 0;
    savingsLabel.text = [NSString stringWithFormat:CO2_SAVINGS_STRING, [poundsOfCO2Saved doubleValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    timeLabel = nil;
    savingsLabel = nil;
    [super viewDidUnload];
}
@end
