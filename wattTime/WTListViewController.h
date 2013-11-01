//
//  WTListViewController.h
//  wattTime
//
//  Created by Colin McCormick on 10/29/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    __weak WTDataModel *dataModel;
    __strong NSDateFormatter *dateFormatterJSON;
    __strong NSDateFormatter *dateFormatterDisplay;
    __strong NSNumberFormatter *numberFormatter;
    __strong UIColor *lowRenewablesColor;
    __strong UIColor *mediumRenewablesColor;
    __strong UIColor *highRenewablesColor;
}

@property (nonatomic, strong) NSArray *arrayOfIntervalData;

- (void)updateIntervalData;

@end
