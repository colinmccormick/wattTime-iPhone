//
//  WTStripChart.h
//  wattTime v0.3
//
//  Created by Colin McCormick on 8/20/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DATE_FORMAT @"yyyy-MM-dd HH:mm"

@interface WTStripChart : UIView

@property (strong, nonatomic) NSArray *chartPoints;

- (NSArray *)makeYTickLabelArray;

@end
