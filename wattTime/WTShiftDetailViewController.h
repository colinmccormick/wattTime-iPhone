//
//  WTShiftDetailViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShiftViewController.h"
#import "WTShiftTimeSetViewController.h"

@interface WTShiftDetailViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UILabel *activityLabel;
    __weak IBOutlet UILabel *durationLabel;
    __weak IBOutlet UIButton *startTimeButton;
    __weak IBOutlet UIButton *stopTimeButton;
    __weak IBOutlet UIImageView *activityImage;
}

- (IBAction)backButtonWasTapped:(id)sender;

@end
