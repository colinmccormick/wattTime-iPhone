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
    CGFloat xLeftPadding = 0.1;
    CGFloat xRightPadding = 0.05;
    CGFloat yBottomPadding = 0.1;
    CGFloat yTopPadding = 0.1;
    
    CGFloat tickFontSize = 10;
    CGFloat xTickHeight = 3;
    CGFloat yTickWidth = 3;
    CGFloat xTickLabelHorizontalOffset = 12;
    CGFloat xTickLabelVerticalOffset = 0.5 * yBottomPadding * myBounds.size.height + 0.5 * tickFontSize;
    CGFloat yTickLabelHorizontalOffset = 0.5 * xLeftPadding * myBounds.size.width + 1.0 * tickFontSize;
    CGFloat yTickLabelVerticalOffset = tickFontSize/2;
    
    // Calculate axis points and lengths
    CGFloat xLeftEdge = xLeftPadding * myBounds.size.width;
    CGFloat xRightEdge = (1-xRightPadding) * myBounds.size.width;
    CGFloat xAxisLength = xRightEdge - xLeftEdge;
    CGFloat yBottomEdge = yBottomPadding * myBounds.size.height;
    CGFloat yTopEdge = (1-yTopPadding) * myBounds.size.height;
    CGFloat yAxisLength = yTopEdge - yBottomEdge;
 
    // Set up tick label arrays
    NSArray *xTickLabels = [NSArray arrayWithObjects:@"12AM", @"3AM", @"6AM", @"9AM", @"12PM", @"3PM", @"6PM", @"9PM", @"12AM", nil];
    NSUInteger numberOfXTickLabels = [xTickLabels count];
    CGFloat xTickSpacing = xAxisLength/(numberOfXTickLabels - 1);

    //NSArray *yTickLabels = [NSArray arrayWithObjects:@"0%", @"5%", @"10%", @"15%", @"20%", @"25%", @"30%", nil];
    NSArray *yTickLabels = [self makeYTickLabelArray];
    NSUInteger numberOfYTickLabels = [yTickLabels count];
    CGFloat yTickSpacing = yAxisLength/(numberOfYTickLabels - 1);
    
    // Draw axes
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xLeftEdge, yBottomEdge);
    CGContextAddLineToPoint(context, xLeftEdge, yTopEdge);
    CGContextMoveToPoint(context, xLeftEdge, yBottomEdge);
    CGContextAddLineToPoint(context, xRightEdge, yBottomEdge);
  
    CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw ticks
    CGContextSelectFont(context, "Arial", tickFontSize, kCGEncodingMacRoman);
    
    CGFloat xTickHorizontalLocation = xLeftEdge;
    for (NSString *xTickLabel in xTickLabels) {
        CGContextMoveToPoint(context, xTickHorizontalLocation, yBottomEdge + xTickHeight/2);
        CGContextAddLineToPoint(context, xTickHorizontalLocation, yBottomEdge - xTickHeight/2);
        CGFloat xTickLabelHorizontalLocation = xTickHorizontalLocation - xTickLabelHorizontalOffset;
        CGFloat xTickLabelVerticalLocation = yBottomEdge - xTickLabelVerticalOffset;
        CGContextShowTextAtPoint(context, xTickLabelHorizontalLocation, xTickLabelVerticalLocation, [xTickLabel UTF8String], [xTickLabel length]);
        xTickHorizontalLocation += xTickSpacing;
    };
    
    CGFloat yTickVerticalLocation = yBottomEdge;
    for (NSString *yTickLabel in yTickLabels) {
        CGContextMoveToPoint(context, xLeftEdge - yTickWidth/2, yTickVerticalLocation);
        CGContextAddLineToPoint(context, xLeftEdge + yTickWidth/2, yTickVerticalLocation);
        CGFloat yTickLabelHorizontalLocation = xLeftEdge - yTickLabelHorizontalOffset;
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
        CGFloat xPosition = xLeftEdge + xAxisLength * (([hour doubleValue] / 24) + ([minute doubleValue] / (60 * 24)));
        
        NSNumber *percent = [point objectForKey:@"percent"];
        CGFloat yPostion = yBottomEdge + yAxisLength * ([percent doubleValue] / maxYValue);
        
        CGRect rect = CGRectMake(xPosition, yPostion, radius, radius);
        CGContextAddEllipseInRect(context, rect);
    }
    
    CGContextSetLineWidth(context, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw current time line
    // Need to implement this
    
}

-(NSArray *)makeYTickLabelArray {
    
    // Specify number of ticks, not including 0% at origin
    int numberOfTicks = 4;
    
    NSArray *labelArray = [NSArray arrayWithObjects:@"0%", @"25%", @"50%", @"75%", @"100%", nil];
    if ([self.chartPoints count] == 0) {
        // No data
        return labelArray;
    } else {
        NSArray *percentValues = [self.chartPoints valueForKey:@"percent"];
        NSNumber *highestValue = [percentValues valueForKeyPath:@"@max.self"];
        if (([highestValue doubleValue] > 100) || ([highestValue doubleValue] < 0)) {
            // Data are corrupted
            return labelArray;
        } else {
            int labelIncrement = ceil([highestValue doubleValue]/numberOfTicks);
            NSMutableArray *newLabelArray = [NSMutableArray array];
            for (int n = 0; n <= numberOfTicks; n++) {
                NSString *label = [NSString stringWithFormat:@"%d%%", n * labelIncrement];
                [newLabelArray addObject:label];
            }
            return newLabelArray;
        }
    }
}

@end
