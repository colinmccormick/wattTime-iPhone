//
//  WTStripChart.m
//  wattTime
//
//  Created by Colin McCormick on 8/20/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTStripChart.h"

@implementation WTStripChart

@synthesize chartPoints = _chartPoints;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialize
    }
    return self;
}

// Implement drawing of view
- (void)drawRect:(CGRect)rect
{
    // Get context and shift+rotate coordinates to lower-left origin
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myBounds = [self bounds];
    CGContextTranslateCTM(context, 0, myBounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // Set scaling factors
    CGFloat xLeftBound = 0.1;
    CGFloat xRightBound = 0.05;
    CGFloat yBottomBound = 0.1;
    CGFloat yTopBound = 0.1;
    
    CGFloat tickFontSize = 8;
    CGFloat xTickHeight = 3;
    CGFloat yTickWidth = 3;
    CGFloat xTickLabelHorizontalOffset = 12;
    CGFloat xTickLabelVerticalOffset = 0.5 * yBottomBound * myBounds.size.height + 0.5 * tickFontSize;
    CGFloat yTickLabelHorizontalOffset = 0.5 *xLeftBound * myBounds.size.width + 0.5 * tickFontSize;
    CGFloat yTickLabelVerticalOffset = tickFontSize/2;
    
    // Calculate axis points and lengths
    CGFloat xLeft = xLeftBound * myBounds.size.width;
    CGFloat xRight = (1-xRightBound) * myBounds.size.width;
    CGFloat xLength = xRight - xLeft;
    CGFloat yBottom = yBottomBound * myBounds.size.height;
    CGFloat yTop = (1-yTopBound) * myBounds.size.height;
    CGFloat yLength = yTop - yBottom;
 
    // Set up tick label arrays
    NSArray *xTickLabels = [NSArray arrayWithObjects:@"12AM", @"3AM", @"6AM", @"9AM", @"12PM", @"3PM", @"6PM", @"9PM", @"12AM", nil];
    NSUInteger numberOfXTickLabels = [xTickLabels count];
    CGFloat xTickSpacing = xLength/(numberOfXTickLabels - 1);

    //NSArray *yTickLabels = [NSArray arrayWithObjects:@"0%", @"5%", @"10%", @"15%", @"20%", @"25%", @"30%", nil];
    NSArray *yTickLabels = [self makeYTickLabelArray];
    NSUInteger numberOfYTickLabels = [yTickLabels count];
    CGFloat yTickSpacing = yLength/(numberOfYTickLabels - 1);
    
    // Draw axes
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xLeft, yBottom);
    CGContextAddLineToPoint(context, xLeft, yTop);
    CGContextMoveToPoint(context, xLeft, yBottom);
    CGContextAddLineToPoint(context, xRight, yBottom);
  
    CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw ticks
    CGContextSelectFont(context, "Arial", tickFontSize, kCGEncodingMacRoman);
    
    CGFloat xTickHorizontalLocation = xLeft;
    for (NSString *xTickLabel in xTickLabels) {
        CGContextMoveToPoint(context, xTickHorizontalLocation, yBottom + xTickHeight/2);
        CGContextAddLineToPoint(context, xTickHorizontalLocation, yBottom - xTickHeight/2);
        CGFloat xTickLabelHorizontalLocation = xTickHorizontalLocation - xTickLabelHorizontalOffset;
        CGFloat xTickLabelVerticalLocation = yBottom - xTickLabelVerticalOffset;
        CGContextShowTextAtPoint(context, xTickLabelHorizontalLocation, xTickLabelVerticalLocation, [xTickLabel UTF8String], [xTickLabel length]);
        xTickHorizontalLocation += xTickSpacing;
    };
    
    CGFloat yTickVerticalLocation = yBottom;
    for (NSString *yTickLabel in yTickLabels) {
        CGContextMoveToPoint(context, xLeft - yTickWidth/2, yTickVerticalLocation);
        CGContextAddLineToPoint(context, xLeft + yTickWidth/2, yTickVerticalLocation);
        CGFloat yTickLabelHorizontalLocation = xLeft - yTickLabelHorizontalOffset;
        CGFloat yTickLabelVerticalLocation = yTickVerticalLocation - yTickLabelVerticalOffset;
        CGContextShowTextAtPoint(context, yTickLabelHorizontalLocation, yTickLabelVerticalLocation, [yTickLabel UTF8String], [yTickLabel length]);
        yTickVerticalLocation += yTickSpacing;
    }
    
    CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw points
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
        
    CGFloat radius = 5.0;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *maxYValueNumber = [numberFormatter numberFromString:[yTickLabels lastObject]];
    CGFloat maxYValue = 100 * [maxYValueNumber doubleValue];
    
    for (NSDictionary *point in self.chartPoints) {
        
        NSDate *date = [dateFormatter dateFromString:[point objectForKey:@"date"]];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSNumber *hour = [NSNumber numberWithInt:[components hour]];
        NSNumber *minute = [NSNumber numberWithInt:[components minute]];
        CGFloat xPosition = xLeft + xLength * (([hour doubleValue] / 24) + ([minute doubleValue] / (60 * 24)));
        
        NSNumber *percent = [point objectForKey:@"percent"];
        CGFloat yPostion = yBottom + yLength * ([percent doubleValue] / maxYValue);
        
        CGRect rect = CGRectMake(xPosition, yPostion, radius, radius);
        CGContextAddEllipseInRect(context, rect);
    }
    
    CGContextSetLineWidth(context, 1);
    CGContextDrawPath(context, kCGPathStroke);
}

-(NSArray *)makeYTickLabelArray {
    NSArray *labelArray = [NSArray arrayWithObjects:@"0%", @"20%", @"40%", @"60%", @"80%", @"100%", nil];
    if ([self.chartPoints count] == 0) {
        // No data
        return labelArray;
    } else {
        NSArray *percentValues = [self.chartPoints valueForKey:@"percent"];
        NSNumber *highestValue = [percentValues valueForKeyPath:@"@max.self"];
        if (([highestValue doubleValue] > 100) || ([highestValue doubleValue] < 0)) {
            // Data are corrupted
            return labelArray;
        }  else if ([highestValue doubleValue] < 5) {
            return [NSArray arrayWithObjects:@"0%", @"1%", @"2%", @"3%", @"4%", @"5%", nil];
        } else if ([highestValue doubleValue] < 10) {
            return [NSArray arrayWithObjects:@"0%", @"2%", @"4%", @"6%", @"8%", @"10%", nil];
        } else if ([highestValue doubleValue] < 20) {
            return [NSArray arrayWithObjects:@"0%", @"4%", @"8%", @"12%", @"16%", @"20%", nil];
        } else if ([highestValue doubleValue] < 25) {
            return [NSArray arrayWithObjects:@"0%", @"5%", @"10%", @"15%", @"20%", @"25%", nil];
        } else if ([highestValue doubleValue] < 50) {
            return [NSArray arrayWithObjects:@"0%", @"10%", @"20%", @"30%", @"40%", @"50%", nil];
        } else if ([highestValue doubleValue] < 75) {
            return [NSArray arrayWithObjects:@"0%", @"15%", @"30%", @"45%", @"60%", @"75%", nil];
        } else {
            return labelArray;
        }
    }
}

@end
