//
//  WTShiftViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 8/26/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftViewController.h"
#import "WTShiftDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewWillAppear:(BOOL)animated {
    // Don't display navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Display the current location
    locationLabel.text = [NSString stringWithFormat:LOCATION_LABEL_STRING, dataModel.currentLocation];
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
