//
//  WTFlipsideViewController.m
//  wattTime v0.1
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTFlipsideViewController.h"

@implementation WTFlipsideViewController

@synthesize delegate = _delegate;
@synthesize pickerView = _pickerView;
@synthesize locationLabel = _locationLabel;
@synthesize locationArray = _locationArray;
@synthesize currentLocation = _currentLocation;

#pragma mark - General

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Label

-(void)updateLocation:(NSString *)location {
    self.currentLocation = location;
    self.locationLabel.text = location;
}

#pragma mark - Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.locationArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *stateDictionary = [self.locationArray objectAtIndex:row];
    return [stateDictionary objectForKey:@"Name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *stateDictionary = [self.locationArray objectAtIndex:row];
    [self updateLocation:[stateDictionary objectForKey:@"Name"]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Now that all views are loaded, update the location label text
    self.locationLabel.text = self.currentLocation;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set initial selected row in picker wheel based on currentLocation
    NSArray *nameArray = [self.locationArray valueForKey:@"Name"];
    NSInteger startRow = [nameArray indexOfObject:self.currentLocation];
    [self.pickerView selectRow:startRow inComponent:0 animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
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

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    // Update location for main view controller
    [self.delegate updateLocation:self.currentLocation];
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
