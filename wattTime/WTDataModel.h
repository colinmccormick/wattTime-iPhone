//
//  WTDataModel.h
//  wattTime
//
//  Created by Colin McCormick on 9/5/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://watttime.com/"
#define TODAY_REQUEST @"today?st="
#define PERCENT_GREEN_KEY @"percent_green"
#define LOCAL_TIME_KEY @"local_time"

@interface WTDataModel : NSObject

@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSString *currentLocation;

- (id)init;
- (void)updateLocation:(NSString *)location;
- (NSArray *)generateArrayOfIntervalData;

@end
