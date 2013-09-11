//
//  WTShiftViewController.m
//  wattTime v0.3
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftViewController.h"
#import "WTShiftDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTShiftViewController

#pragma mark - My methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataModel.activityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"activityCell"];
    }
    NSDictionary *activityDictionary = [dataModel.activityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [activityDictionary objectForKey:@"MyDescription"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ hours", [activityDictionary objectForKey:@"Length"]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showActivityDetail"]) {
        NSIndexPath *indexPath = [activityTableView indexPathForSelectedRow];
        NSDictionary *activityDictionary = [dataModel.activityArray objectAtIndex:indexPath.row];
        WTShiftDetailViewController *destinationVC = [segue destinationViewController];
        destinationVC.activity = activityDictionary;
    }
}

#pragma mark - Original methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    locationLabel.text = [NSString stringWithFormat:LOCATION_LABEL_STRING, dataModel.currentLocation];
    
    // Round corners on table view
    activityTableView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    locationLabel = nil;
    [super viewDidUnload];
}
@end
