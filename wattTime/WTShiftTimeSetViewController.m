//
//  WTShiftTimeSetViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/22/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftTimeSetViewController.h"

@implementation WTShiftTimeSetViewController

@synthesize instructionLabelString = _instructionLabelString;

- (IBAction)okayButtonWasTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSDate *timeSelected = [datePicker date];
    if ([self.instructionLabelString isEqualToString:START_TIME_STRING]) {
        dataModel.startTime = timeSelected;
    } else {
        dataModel.endTime = timeSelected;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    instructionLabel.text = self.instructionLabelString;
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    // Make okay button round
    [okayButton.layer setBorderWidth:1];
    [okayButton.layer setCornerRadius:10];
    [okayButton setClipsToBounds:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if ([self.instructionLabelString isEqualToString:START_TIME_STRING]) {
        [datePicker setDate:dataModel.startTime];
    } else {
        [datePicker setDate:dataModel.endTime];
    }
}

@end
