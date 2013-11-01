//
//  WTSetCustomViewController.h
//  wattTime
//
//  Created by Colin McCormick on 10/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTSetCustomViewController : UIViewController <UITextFieldDelegate> {
    __weak IBOutlet UITextField *descriptionTextField;
    __weak IBOutlet UILabel *lengthLabel;
    __weak IBOutlet UIStepper *lengthStepper;
    __weak WTDataModel *dataModel;
}

@end
