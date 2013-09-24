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

- (IBAction)backButtonWasTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Original methods

- (void)viewDidLoad
{
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
    // Update startTime, stopTime and respective labels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_STRING];
    [startTimeButton setTitle:[formatter stringFromDate:dataModel.startTime] forState:UIControlStateNormal];
    [stopTimeButton setTitle:[formatter stringFromDate:dataModel.endTime] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    durationLabel = nil;
    [super viewDidUnload];
}
@end
