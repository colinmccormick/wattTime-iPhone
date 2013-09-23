//
//  WTDataModel.h
//  wattTime v0.4
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
#define RECOMMENDED_START @"recommended_start"

@interface WTDataModel : NSObject

@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSArray *activityArray;
@property (strong, nonatomic) NSDictionary *currentActivity;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

- (id)init;
- (void)updateLocation:(NSString *)location;
- (NSArray *)generateArrayOfIntervalData;
- (NSDictionary *)generateShiftRecommendation;

@end
