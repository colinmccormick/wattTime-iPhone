//
//  WTShiftResultViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/23/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIClock.h"
#import "WTShiftDetailViewController.h"

@interface WTShiftResultViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UILabel *shiftResultLabel;
    __weak IBOutlet UIClock *shiftResultClock;
}

- (IBAction)backButtonWasTapped:(id)sender;
- (void)displayRecommendedStartTime;

@end
