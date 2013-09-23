//
//  WTShiftViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMainViewController.h"

#define LOCATION_LABEL_STRING @"You're in %@"
#define ACTIVITY_STRING @"%@"
#define DURATION_STRING @"%@ hours"
#define DATE_FORMAT_STRING @"MMM dd hh:mm a"
#define JSON_DATE_FORMAT_STRING @"YYYY-MM-DD HH:mm"
#define START_TIME_SEGUE_NAME @"showShiftStartTimeSetView"
#define END_TIME_SEGUE_NAME @"showShiftEndTimeSetView"
#define START_TIME_STRING @"START TIME:"
#define END_TIME_STRING @"END TIME:"

@interface WTShiftViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UILabel *locationLabel;
}

@end
