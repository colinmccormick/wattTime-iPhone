//
//  WTShiftViewController.h
//  wattTime v0.3
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMainViewController.h"

#define LOCATION_LABEL_STRING @"You're in %@"

@interface WTShiftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UITableView *activityTableView;
    __weak IBOutlet UILabel *locationLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
