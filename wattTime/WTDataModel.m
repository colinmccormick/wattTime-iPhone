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

#pragma mark - My methods

// Initialize the data model with locationArray and currentLocation
- (id)init {

    if (self = [super init]) {
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
