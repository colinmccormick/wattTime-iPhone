//
//  WTLocationViewController.m
//  wattTime v0.3
//
//  Created by Colin McCormick on 9/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTLocationViewController.h"

@implementation WTLocationViewController

#pragma mark - My methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataModel.locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stateCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"stateCell"];
    }
    NSDictionary *stateDictionary = [dataModel.locationArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [stateDictionary objectForKey:@"ISO"];
    cell.detailTextLabel.text = [stateDictionary objectForKey:@"Name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stateDictionary = [dataModel.locationArray objectAtIndex:indexPath.row];
    NSString *stateName = [stateDictionary objectForKey:@"Name"];
    [dataModel updateLocation:stateName];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Find pointer to the data model
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Set initial selected row in table view
    NSArray *nameArray = [dataModel.locationArray valueForKey:@"Name"];
    NSInteger startRow = [nameArray indexOfObject:dataModel.currentLocation];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:startRow inSection:0];
    [stateTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:dataModel.currentLocation forKey:@"defaultLocation"];
    [defaults synchronize];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
