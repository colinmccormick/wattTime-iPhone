//
//  WTLocationViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/7/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTLocationViewController.h"

@implementation WTLocationViewController

#pragma mark - My methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [dataModel.locationArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[dataModel.locationArray objectAtIndex:row] objectForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *stateDictionary = [dataModel.locationArray objectAtIndex:row];
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
    NSArray *locationNames = [dataModel.locationArray valueForKey:@"Name"];
    NSString *currentLocation = dataModel.currentLocation;
    NSInteger index = [locationNames indexOfObject:currentLocation];
    [locationPicker selectRow:index inComponent:0 animated:YES];
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
