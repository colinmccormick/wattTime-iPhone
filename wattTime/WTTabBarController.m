//
//  WTTabBarController.m
//  wattTime
//
//  Created by Colin McCormick on 8/29/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTTabBarController.h"

@interface WTTabBarController ()

@end

@implementation WTTabBarController

@synthesize allLocations = _allLocations;
@synthesize currentLocation = _currentLocation;

#pragma mark - My methods

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
	// Do any additional setup after loading the view.
    
    // Load state array
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"States" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.allLocations = array;
    
    // Initialize location to user defaults or first entry of state array if no default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultLocation = [defaults stringForKey:@"defaultLocation"];
    if (defaultLocation) {
        self.currentLocation = defaultLocation;
    } else {
        self.currentLocation = [[self.allLocations objectAtIndex:0] objectForKey:@"Name"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
