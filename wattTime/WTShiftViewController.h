//
//  WTShiftViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDataModel.h"
#import "WTGraphViewController.h"
#import "WTShiftDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WTShiftViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *activityOneLabel;
    __weak IBOutlet UILabel *activityTwoLabel;
    __weak IBOutlet UILabel *activityThreeLabel;
    __weak IBOutlet UILabel *activityFourLabel;
    __weak IBOutlet UIButton *setCustomLabel;
}

@end
