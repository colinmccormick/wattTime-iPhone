//
//  WTShiftDetailViewController.m
//  wattTime
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftDetailViewController.h"

@implementation WTShiftDetailViewController

#pragma mark - My methods

- (IBAction)tellMeButtonWasTapped:(id)sender {

    // Update data model endTime
    NSDate *timeSelected = [datePicker date];
    dataModel.endTime = timeSelected;

    // Check that end time is after start time, and that we're in CA
    if ([[NSDate date] earlierDate:dataModel.endTime] == dataModel.endTime) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:TIME_WARNING_STRING delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else if (![dataModel.currentLocation isEqualToString:@"California"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:CA_WARNING_STRING delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        [self performSegueWithIdentifier:@"showShiftResultView" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    // Update image
    NSString *imageName = [dataModel.currentActivity objectForKey:@"Image"];
    UIImage *image = [UIImage imageNamed:imageName];
    [activityImage setImage:image];
    // Update labels showing activity description and time
    activityLabel.text = [NSString stringWithFormat:ACTIVITY_STRING, [dataModel.currentActivity objectForKey:@"Description"]];
    durationLabel.text = [NSString stringWithFormat:DURATION_STRING, [dataModel.currentActivity objectForKey:@"Length"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [datePicker setDate:dataModel.endTime];
    [datePicker setMinimumDate:[NSDate date]];
}

@end
