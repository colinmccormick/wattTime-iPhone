//
//  WTLocationViewController.h
//  wattTime v0.3
//
//  Created by Colin McCormick on 9/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTLocationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UILabel *locationLabel;
    __weak WTDataModel *dataModel;
}

@end
