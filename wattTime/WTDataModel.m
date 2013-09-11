//
//  WTDataModel.m
//  wattTime v0.3
//
//  Created by Colin McCormick on 9/5/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTDataModel.h"

@implementation WTDataModel

@synthesize locationArray = _locationArray;
@synthesize currentLocation = _currentLocation;
@synthesize activityArray = _activityArray;

#pragma mark - My methods

// Initialize the data model with locationArray, currentLocation and activityArray
- (id)init {

    if (self = [super init]) {
        // Load state array
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *statePlistPath = [bundle pathForResource:@"States" ofType:@"plist"];
        NSArray *stateArray = [[NSArray alloc] initWithContentsOfFile:statePlistPath];
        self.locationArray = stateArray;

        // Initialize location to user defaults or first entry of state array if no default
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *defaultLocation = [defaults stringForKey:@"defaultLocation"];
        if (defaultLocation) {
            [self updateLocation:defaultLocation];
        } else {
            [self updateLocation:[[self.locationArray objectAtIndex:0] objectForKey:@"Name"]];
        }
        
        // Load activity array
        NSString *activityPlistPath = [bundle pathForResource:@"Activities" ofType:@"plist"];
        NSArray *activityArray = [[NSArray alloc] initWithContentsOfFile:activityPlistPath];
        self.activityArray = activityArray;
        
        return self;
    } else {
        return nil;
    }
}

// Update current location and the default time zone
- (void)updateLocation:(NSString *)location {
    self.currentLocation = location;
    NSArray *locationNames = [self.locationArray valueForKey:@"Name"];
    NSArray *locationTimeZones = [self.locationArray valueForKey:@"Time zone"];
    NSString *timeZoneName = [locationTimeZones objectAtIndex:[locationNames indexOfObject:location]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [NSTimeZone setDefaultTimeZone:timeZone];
}

// Fetch data for current location in JSON format from WattTime server and parse to array
- (NSArray *)generateArrayOfIntervalData {
    
    // Form URL request from abbreviation for current state location
    NSArray *nameArray = [self.locationArray valueForKey:@"Name"];
    NSArray *abbreviationArray = [self.locationArray valueForKey:@"Abbreviation"];
    NSString *stateAbbreviation = [abbreviationArray objectAtIndex:[nameArray indexOfObject:self.currentLocation]];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", BASE_URL, TODAY_REQUEST, stateAbbreviation];
    
    // Download data using URL request
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];

    // Parse JSON data
    NSError *error = nil;
    NSArray *arrayOfIntervalData = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;

    if (error) {
        NSLog(@"JSON parse error %@", error);
    }
    
    return arrayOfIntervalData;
}

@end
