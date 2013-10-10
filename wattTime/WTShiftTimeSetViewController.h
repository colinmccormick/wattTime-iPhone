//
//  WTShiftTimeSetViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/22/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTShiftDetailViewController.h"

@interface WTShiftTimeSetViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UILabel *instructionLabel;
}

@property (weak, nonatomic) NSString *instructionLabelString;

@end
