//
//  WTTabBarController.h
//  wattTime
//
//  Created by Colin McCormick on 8/29/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTabBarController : UITabBarController

@property (strong, nonatomic) NSArray *allLocations;
@property (strong, nonatomic) NSString *currentLocation;

@end
