//
//  UIClock.m
//  wattTime
//
//  Created by Colin McCormick on 10/3/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "UIClock.h"

@implementation UIClock

@synthesize clockTime = _clockTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setClockTime:[NSDate date]];
    }
    return self;
}

- (void)setClockTime:(NSDate *)clockTime {
    _clockTime = clockTime;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Get context and shift+rotate coordinates to lower-left origin
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myBounds = [self bounds];
    CGContextTranslateCTM(context, 0, myBounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // Adjust to square if frame is not
    CGFloat clockSize = myBounds.size.width;
    if (myBounds.size.width != myBounds.size.height) {
        clockSize = (myBounds.size.width < myBounds.size.height) ? myBounds.size.width : myBounds.size.height;
    }
    
    // Set scaling factors
    CGFloat fillFactor = 0.9; // Fraction of frame filled by clock
    CGFloat clockRadius = 0.5 * clockSize * fillFactor; // Radius of clock
    CGFloat tickLength = 0.1 * clockRadius;  // Length of clock tick marks
    CGFloat numberSize = 0.2 * clockRadius;  // Size of clock numbers
    CGFloat hourHandLength = 0.5 * clockRadius;
    CGFloat minuteHandLength = 0.6 * clockRadius;
    CGFloat hourHandWidth = 0.08 * clockRadius;
    CGFloat minuteHandWidth = 0.04 * clockRadius;
    CGFloat tickWidth = 0.02 * clockRadius;
    CGFloat circleWidth = 0.02 * clockRadius;
    
    // Make clock circle
    CGFloat xCenter = myBounds.size.width/2;
    CGFloat yCenter = myBounds.size.height/2;
    CGFloat xPosition = xCenter - clockRadius;
    CGFloat yPosition = yCenter - clockRadius;
    CGRect myRect = CGRectMake(xPosition, yPosition, 2 * clockRadius, 2 * clockRadius);
    CGContextAddEllipseInRect(context, myRect);
    CGContextSetLineWidth(context, circleWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw ticks
    CGFloat outerRadius = clockRadius;
    CGFloat innerRadius = outerRadius - tickLength;
    CGFloat numberRadius = innerRadius - 0.75 * numberSize;
    CGContextSelectFont(context, "Arial", numberSize, kCGEncodingMacRoman);
    for (int count = 1; count <= 12; count++) {
        CGFloat angleInRadians = 0.1667 * M_PI * count;
        CGFloat sineOfAngle = sin(angleInRadians);
        CGFloat cosineOfAngle = cos(angleInRadians);
        CGFloat xInnerTick = xCenter + innerRadius * sineOfAngle;
        CGFloat yInnerTick = yCenter + innerRadius * cosineOfAngle;
        CGFloat xOuterTick = xCenter + outerRadius * sineOfAngle;
        CGFloat yOuterTick = yCenter + outerRadius * cosineOfAngle;
        CGFloat xNumberLocation = xCenter + numberRadius * sineOfAngle - 0.25 * numberSize;
        CGFloat yNumberLocation = yCenter + numberRadius * cosineOfAngle - 0.25 * numberSize;
        CGContextMoveToPoint(context, xInnerTick, yInnerTick);
        CGContextAddLineToPoint(context, xOuterTick, yOuterTick);
        NSString *numberString = [[NSNumber numberWithInt:count] stringValue];
        CGContextShowTextAtPoint(context, xNumberLocation, yNumberLocation, [numberString UTF8String], [numberString length]);
    }
    CGContextSetLineWidth(context, tickWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw hour and minute hands
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:self.clockTime];
    NSNumber *theHour = [NSNumber numberWithInteger:[components hour]];
    NSNumber *theMinute = [NSNumber numberWithInteger:[components minute]];
    CGFloat hourAngle = 2 * M_PI * 0.0833 * [theHour intValue] + 2 * M_PI * 0.0833 * 0.0167 * [theMinute intValue];
    CGFloat minuteAngle = 2 * M_PI * 0.0167 * [theMinute intValue];
    CGFloat xHourTip = xCenter + hourHandLength * sin(hourAngle);
    CGFloat yHourTip = yCenter + hourHandLength * cos(hourAngle);
    CGFloat xMinuteTip = xCenter + minuteHandLength * sin(minuteAngle);
    CGFloat yMinuteTip = yCenter + minuteHandLength * cos(minuteAngle);
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xHourTip, yHourTip);
    CGContextSetLineWidth(context, hourHandWidth);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xMinuteTip, yMinuteTip);
    CGContextSetLineWidth(context, minuteHandWidth);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
