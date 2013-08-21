//
//  WTStripChart.h
//  wattTime
//
//  Created by Colin McCormick on 8/20/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTStripChart : UIView

@property (strong, nonatomic) NSArray *chartPoints;

-(NSArray *)makeYTickLabelArray;

@end
