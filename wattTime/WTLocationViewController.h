//
//  WTLocationViewController.h
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTLocationViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UIPickerView *locationPicker;
}

@end
