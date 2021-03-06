//
//  WTDataModel.h
//  wattTime
//
//  Created by Colin McCormick on 9/5/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://watttime.com/"
#define TODAY_REQUEST @"today?st="
#define PERCENT_GREEN_KEY @"percent_green"
#define LOCAL_TIME_KEY @"local_time"
#define JSON_DATE_FORMAT @"yyyy-MM-dd HH:mm"
#define GREENEST_SUBRANGE_REQUEST @"greenest_subrange/?st="
#define TIME_RANGE_HOURS @"time_range_hours="
#define USAGE_HOURS @"usage_hours="
#define RECOMMENDED_START @"recommended_local_start"

#define PERCENT_GREEN_LABEL_STRING @"%0.1f%% green"
#define LOCATION_LABEL_STRING @"You're in %@"
#define ACTIVITY_STRING @"%@"
#define DURATION_STRING @"%@ hours long"
#define DATE_FORMAT_STRING @"hh:mma"
#define JSON_DATE_FORMAT_STRING @"YYYY-MM-DD HH:mm"
#define END_TIME_STRING @"END TIME:"
#define TIME_WARNING_STRING @"The end time must be later than the start time."
#define CA_WARNING_STRING @"Shift only works in California.  Change your location to use it."
#define SHIFT_END_STRING @"end at %@"
#define LIST_CLEAN_STRING @"clean"
#define LINE_BREAK @"\n"

@interface WTDataModel : NSObject

@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSMutableArray *activityArray;
@property (strong, nonatomic) NSDictionary *currentActivity;
@property (strong, nonatomic) NSDate *endTime;

- (id)init;
- (void)updateLocation:(NSString *)location;
- (NSArray *)generateArrayOfIntervalData;
- (NSDictionary *)generateShiftRecommendation;

@end
