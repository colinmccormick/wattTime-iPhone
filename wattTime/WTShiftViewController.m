//
//  WTShiftViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftViewController.h"

@implementation WTShiftViewController

#pragma mark - My methods

// Figure out which button was tapped, set dataModel.currentActivity, and call segue
- (IBAction)activityButtonWasTapped:(id)sender {
    NSString *activityName = [sender currentTitle];
    NSArray *activityNameList = [dataModel.activityArray valueForKey:@"Name"];
    NSDictionary *activityDictionary = [dataModel.activityArray objectAtIndex:[activityNameList indexOfObject:activityName]];
    dataModel.currentActivity = activityDictionary;
    [self performSegueWithIdentifier:@"showShiftDetailView" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    // Set activity labels from activity array
    NSArray *activityNames = [dataModel.activityArray valueForKey:@"Description"];
    [activityOneLabel setText:[activityNames objectAtIndex:0]];
    [activityTwoLabel setText:[activityNames objectAtIndex:1]];
    [activityThreeLabel setText:[activityNames objectAtIndex:2]];
    [activityFourLabel setText:[activityNames objectAtIndex:3]];
}

- (void)viewWillAppear:(BOOL)animated {
    // Display the current location
    locationLabel.text = [NSString stringWithFormat:LOCATION_LABEL_STRING, dataModel.currentLocation];
    // Update custom button
    NSArray *activityNames = [dataModel.activityArray valueForKey:@"Description"];
    [activityFourLabel setText:[activityNames objectAtIndex:3]];
}

@end
