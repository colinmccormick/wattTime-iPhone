//
//  WTShiftResultViewController.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 9/23/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTShiftResultViewController.h"

@implementation WTShiftResultViewController

- (IBAction)backButtonWasTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Display
- (void)displayRecommendedStartTime {
    
    // Set up spinner to display while waiting for download
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160,180);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Send download request (use second thread to avoid blocking main thread)
    dispatch_queue_t fetch_queue = dispatch_queue_create("JSON Fetch", NULL);
    dispatch_async(fetch_queue, ^{
    
        // Get recommended time
        NSDictionary *dictionaryOfRecommendedTime = [dataModel generateShiftRecommendation];
        
        // Put back on the main thread to use UIKit
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (dictionaryOfRecommendedTime) {
    
                // Update best time label
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:JSON_DATE_FORMAT];
                NSString *bestTimeStringJSON = [dictionaryOfRecommendedTime objectForKey:RECOMMENDED_START];
                NSDate *bestTime = [formatter dateFromString:bestTimeStringJSON];
                if (bestTime) {
                    [formatter setDateFormat:DATE_FORMAT_STRING];
                    NSString *bestTimeStringLabel = [formatter stringFromDate:bestTime];
                    shiftResultLabel.text = bestTimeStringLabel;
                } else {
                    shiftResultLabel.text = @"N/A";
                }
            } else {
                shiftResultLabel.text = @"N/A";
            }
            [spinner stopAnimating];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Find pointer to dataModel
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    
    // Display
    [self displayRecommendedStartTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
