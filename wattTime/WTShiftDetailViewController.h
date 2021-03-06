//
//  WTShiftDetailViewController.h
//  wattTime
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShiftViewController.h"

@interface WTShiftDetailViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UILabel *activityLabel;
    __weak IBOutlet UILabel *durationLabel;
    __weak IBOutlet UIButton *tellMeButton;
    __weak IBOutlet UIImageView *activityImage;
    __weak IBOutlet UIDatePicker *datePicker;
}

@end
