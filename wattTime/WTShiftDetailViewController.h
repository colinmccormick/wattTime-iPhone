//
//  WTShiftDetailViewController.h
//  wattTime
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ACTIVITY_STRING @"The best time to %@ is:"
#define CO2_SAVINGS_STRING @"Starting then will save %0.1f pounds of CO2!"

@interface WTShiftDetailViewController : UIViewController {
    __weak IBOutlet UILabel *activityLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *savingsLabel;
}

@property NSDictionary *activity;

- (NSDate *)calculateBestTime;
- (NSNumber *)calculateCarbonSavings:(NSDate *)forStartTime;

@end
