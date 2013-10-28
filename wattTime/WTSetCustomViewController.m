//
//  WTSetCustomViewController.m
//  wattTime
//
//  Created by Colin McCormick on 10/7/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "WTSetCustomViewController.h"

@implementation WTSetCustomViewController

- (IBAction)okayButtonWasTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stepperValueChanged:(id)sender {
    NSNumber *activityLength = [NSNumber numberWithDouble:lengthStepper.value];
    NSString *activityLabel = [NSString stringWithFormat:@"%@ hours", activityLength];
    lengthLabel.text = activityLabel;
    [[dataModel.activityArray lastObject] setValue:activityLength forKey:@"Length"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[dataModel.activityArray lastObject] setValue:descriptionTextField.text forKey:@"Description"];
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewWillAppear:(BOOL)animated {
    // Load custom activity
    NSNumber *activityLength = [[dataModel.activityArray lastObject] valueForKey:@"Length"];
    NSString *activityLabel = [NSString stringWithFormat:@"%@ hours", activityLength];
    lengthLabel.text = activityLabel;
    descriptionTextField.text = [[dataModel.activityArray lastObject] valueForKey:@"Description"];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    NSDictionary *customActivity = [dataModel.activityArray lastObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:customActivity forKey:@"customActivity"];
    [defaults synchronize];
}

@end
