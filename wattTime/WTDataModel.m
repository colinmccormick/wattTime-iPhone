//
//  WTDataModel.m
//  wattTime
//
//  Created by Colin McCormick on 9/5/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTDataModel.h"

@implementation WTDataModel

@synthesize locationArray = _locationArray;
@synthesize currentLocation = _currentLocation;
@synthesize activityArray = _activityArray;
@synthesize currentActivity = _currentActivity;
@synthesize endTime = _endTime;

#pragma mark - My methods

// Initialize the data model with locationArray, currentLocation, activityArray, and currentActivity
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
        
        // Load activity array.  Modify if custom activity is set.
        NSString *activityPlistPath = [bundle pathForResource:@"Activities" ofType:@"plist"];
        NSMutableArray *activityArray = [NSMutableArray arrayWithContentsOfFile:activityPlistPath];
        NSDictionary *customActivity = [defaults dictionaryForKey:@"customActivity"];
        if (customActivity) {
            NSArray *activityNames = [activityArray valueForKey:@"Name"];
            NSUInteger customIndex = [activityNames indexOfObject:@"custom"];
            [activityArray replaceObjectAtIndex:customIndex withObject:customActivity];
        }
        self.activityArray = activityArray;
        
        // Initialize currentActivity to first entry of activity array
        self.currentActivity = [self.activityArray objectAtIndex:0];
        
        return self;
    } else {
        return nil;
    }
}

// Update current location , default time zone, endTime
- (void)updateLocation:(NSString *)location {
    self.currentLocation = location;
    NSArray *locationNames = [self.locationArray valueForKey:@"Name"];
    NSArray *locationTimeZones = [self.locationArray valueForKey:@"Time zone"];
    NSString *timeZoneName = [locationTimeZones objectAtIndex:[locationNames indexOfObject:location]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [NSTimeZone setDefaultTimeZone:timeZone];
    NSDate *now = [NSDate date];
    NSInteger twentyFourHours = 24 * 3600;
    NSDate *endOfActivityTimeRange = [now dateByAddingTimeInterval:twentyFourHours];
    [self setEndTime:endOfActivityTimeRange];
}

// Fetch today's green percent data for current location
- (NSArray *)generateArrayOfIntervalData {
    
    // Form URL request from abbreviation for current state location
    NSArray *nameArray = [self.locationArray valueForKey:@"Name"];
    NSArray *abbreviationArray = [self.locationArray valueForKey:@"Abbreviation"];
    NSString *stateAbbreviation = [abbreviationArray objectAtIndex:[nameArray indexOfObject:self.currentLocation]];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", BASE_URL, TODAY_REQUEST, stateAbbreviation];
    
    // Download data using URL request (THIS IS THE NETWORK CALL)
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];

    // Parse JSON data
    NSError *error = nil;
    NSArray *arrayOfIntervalData = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) {
        NSLog(@"JSON parse error %@", error);
    }
    return arrayOfIntervalData;
}

// Query wattTime server on best time over next timeRangeHours hours to use electricity for usageHours
- (NSDictionary *)generateShiftRecommendation {
    
    // Form URL request from state, timeRangeHours and usageHours
    NSArray *nameArray = [self.locationArray valueForKey:@"Name"];
    NSArray *abbreviationArray = [self.locationArray valueForKey:@"Abbreviation"];
    NSString *stateAbbreviation = [abbreviationArray objectAtIndex:[nameArray indexOfObject:self.currentLocation]];
    NSTimeInterval timeRangeSeconds = [self.endTime timeIntervalSinceDate:[NSDate date]];
    double secondsInAnHour = 3600;
    NSInteger timeRangeHours = timeRangeSeconds / secondsInAnHour;
    NSInteger usageHours = [[self.currentActivity objectForKey:@"Length"] integerValue];
    NSString *urlStart = [NSString stringWithFormat:@"%@%@%@", BASE_URL, GREENEST_SUBRANGE_REQUEST, stateAbbreviation];
    NSString *urlTimeRange = [NSString stringWithFormat:@"&%@%d", TIME_RANGE_HOURS, timeRangeHours];
    NSString *urlUsageHours = [NSString stringWithFormat:@"&%@%d", USAGE_HOURS, usageHours];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", urlStart, urlTimeRange, urlUsageHours];
    
    // Download data using URL request (THIS IS THE NETWORK CALL)
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Parse JSON data
    NSError *error = nil;
    NSDictionary *dictionaryOfShiftRecommendation = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) {
        NSLog(@"JSON parse error %@", error);
    }
    return dictionaryOfShiftRecommendation;
}

@end
