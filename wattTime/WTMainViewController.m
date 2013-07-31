//
//  WTMainViewController.m
//  wattTime v0.1
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTMainViewController.h"

@implementation WTMainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize currentLocation = _currentLocation;
@synthesize locationArray = _locationArray;

#pragma mark - My methods

// Run when user taps update button; fetch data from server and update display
- (IBAction)updateButtonWasTapped:(id)sender {
    [self fetchDataAndUpdateDisplay];
}

// Fetch data from wattTime server, parse, and update display
- (void)fetchDataAndUpdateDisplay {
    
    // Set up spinner to display while waiting for download
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160,240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Send download request (use second thread to avoid blocking main thread) 
    dispatch_queue_t fetch_queue = dispatch_queue_create("JSON Fetch", NULL);
    dispatch_async(fetch_queue, ^{
        
        // Form URL request from abbreviation for current state location
        NSArray *nameArray = [self.locationArray valueForKey:@"Name"];
        NSArray *abbreviationArray = [self.locationArray valueForKey:@"Abbreviation"];
        NSString *stateAbbreviation = [abbreviationArray objectAtIndex:[nameArray indexOfObject:self.currentLocation]];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", BASE_URL, TODAY_REQUEST, stateAbbreviation];

        // Download data using URL request
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];

        // Parse JSON
        NSError *error = nil;
        NSArray *result = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
       
        // Put back on the main thread to use UIKit
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Extract element of JSON array corresponding to the current hour (in default time zone)
            if (result) {            
                NSDate *date = [NSDate date];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
                NSInteger theHour = [components hour];
                NSNumber *percentGreen = [[result objectAtIndex:theHour] valueForKey:PERCENT_GREEN_KEY];
                percentGreenLabel.text = [NSString stringWithFormat:@"%0.1f", [percentGreen floatValue]];
            } else {
                NSLog(@"JSON parse error %@", error);
                percentGreenLabel.text = @"N/A";
            }
            [spinner stopAnimating];
        });
        
    });
    dispatch_release(fetch_queue);
}

// Update currentLocation, the location label, and the default time zone
- (void)updateLocation:(NSString *)location {
    self.currentLocation = location;
    locationLabel.text = location;
    NSArray *locationNames = [self.locationArray valueForKey:@"Name"];
    NSArray *locationTimeZones = [self.locationArray valueForKey:@"Time zone"];
    NSString *timeZoneName = [locationTimeZones objectAtIndex:[locationNames indexOfObject:location]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [NSTimeZone setDefaultTimeZone:timeZone];
}

// Update the time.  Update only every 5 seconds to reduce cost.
- (void)updateTimer {
    [updateTimer invalidate];
    updateTimer = nil;
    currentDate = [NSDate date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    timeLabel.text = [timeFormatter stringFromDate:currentDate];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load state array
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"States" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.locationArray = array;    
    
    // Initialize location to user defaults or first entry of state array if no default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultLocation = [defaults stringForKey:@"defaultLocation"];
    if (defaultLocation) {
        [self updateLocation:defaultLocation];
    } else {
        [self updateLocation:[[self.locationArray objectAtIndex:0] objectForKey:@"Name"]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    updateButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Start timer
    [self updateTimer]; 
    
    // Update the display
    [self fetchDataAndUpdateDisplay];   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    // Save location to user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.currentLocation forKey:@"defaultLocation"];
    [defaults synchronize];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(WTFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }        
        // Set current location and state array in flip side view
        [[segue destinationViewController] setCurrentLocation:self.currentLocation];
        [[segue destinationViewController] setLocationArray:self.locationArray];
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
