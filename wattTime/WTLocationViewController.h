//
//  WTLocationViewController.h
//  wattTime v0.3
//
//  Created by Colin McCormick on 9/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

@interface WTLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    __weak WTDataModel *dataModel;
    __weak IBOutlet UITableView *stateTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
