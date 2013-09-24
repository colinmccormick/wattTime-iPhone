//
//  WTShiftTimeSetViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/22/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftTimeSetViewController.h"

@interface WTShiftTimeSetViewController ()

@end

@implementation WTShiftTimeSetViewController

@synthesize instructionLabelString = _instructionLabelString;

- (IBAction)backButtonWasTapped:(id)sender {
    
    NSDate *timeSelected = [datePicker date];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Your date is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if ([self.instructionLabelString isEqualToString:START_TIME_STRING]) {
        if ([timeSelected laterDate:dataModel.endTime] == timeSelected) {
            // Start time is after end time; warn user
            [alert setMessage:@"The start time must be before the end time."];
            [alert show];
        } else {
            dataModel.startTime = timeSelected;
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ([self.instructionLabelString isEqualToString:END_TIME_STRING]) {
        if ([timeSelected earlierDate:dataModel.startTime] == timeSelected) {
            // End time is before start time; warn user
            [alert setMessage:@"The end time must be after the start time."];
            [alert show];
        } else {
            dataModel.endTime = timeSelected;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    instructionLabel.text = self.instructionLabelString;

    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if ([self.instructionLabelString isEqualToString:START_TIME_STRING]) {
        [datePicker setDate:dataModel.startTime];
    } else {
        [datePicker setDate:dataModel.endTime];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
