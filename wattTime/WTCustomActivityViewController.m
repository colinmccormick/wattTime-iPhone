//
//  WTCustomActivityViewController.m
//  wattTime
//
//  Created by Colin McCormick on 10/7/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "WTCustomActivityViewController.h"

@implementation WTCustomActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDictionary *customActivityDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"custom", @"Name", @"Custom", @"Description", 1, @"Length", @"WTCustomButton.png", @"Image" , nil];
        customActivity = customActivityDictionary;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDictionary *customActivityDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"custom", @"Name", @"Custom", @"Description", 1, @"Length", @"WTCustomButton.png", @"Image" , nil];
        customActivity = customActivityDictionary;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Find pointer to the data model
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:customActivity forKey:@"customActivity"];
    [defaults synchronize];
}

@end
