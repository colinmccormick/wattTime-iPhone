//
//  WTShiftDetailViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/11/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftDetailViewController.h"

@implementation WTShiftDetailViewController

#pragma mark - My methods

- (IBAction)tellMeButtonWasTapped:(id)sender {
    // Check that end time is after start time
    // Shift only works in CA, so check we're there
    if ([dataModel.startTime earlierDate:dataModel.endTime] == dataModel.endTime) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"The end time must be later than the start time." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else if (![dataModel.currentLocation isEqualToString:@"California"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:CA_WARNING_STRING delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        [self performSegueWithIdentifier:@"showShiftResultView" sender:self];
    }
}

// Set delegate and instruction string for time-setting view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:START_TIME_SEGUE_NAME]) {
        WTShiftTimeSetViewController *view = [segue destinationViewController];
        view.instructionLabelString = START_TIME_STRING;
    } else if ([[segue identifier] isEqualToString:END_TIME_SEGUE_NAME]) {
        WTShiftTimeSetViewController *view = [segue destinationViewController];
        view.instructionLabelString = END_TIME_STRING;
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
    // Update startTime, stopTime and respective labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STRING];
    [startTimeButton setTitle:[formatter stringFromDate:dataModel.startTime] forState:UIControlStateNormal];
    [stopTimeButton setTitle:[formatter stringFromDate:dataModel.endTime] forState:UIControlStateNormal];
    // Round the buttons
    [startTimeButton.layer setCornerRadius:10.0];
    [startTimeButton.layer setMasksToBounds:YES];
    [startTimeButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [startTimeButton.layer setBorderWidth:1.0];
    [stopTimeButton.layer setCornerRadius:10.0];
    [stopTimeButton.layer setMasksToBounds:YES];
    [stopTimeButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [stopTimeButton.layer setBorderWidth:1.0];
    [tellMeButton.layer setCornerRadius:10.0];
    [tellMeButton.layer setMasksToBounds:YES];
    [tellMeButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [tellMeButton.layer setBorderWidth:1.0];
}

@end
