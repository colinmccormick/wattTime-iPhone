//
//  WTCustomActivityViewController.h
//  wattTime
//
//  Created by Colin McCormick on 10/7/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTCustomActivityViewController : UIViewController {
    __weak WTDataModel *dataModel;
    __weak NSDictionary *customActivity;
}

@end
