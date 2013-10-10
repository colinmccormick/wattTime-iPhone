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
        [self setClockTime:[NSDate date]];
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

- (void)drawRect:(CGRect)rect {
    // Get context.  Remember origin is upper-left corner; y increases downwards.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Adjust to square if frame is rectangular
    CGRect myBounds = [self bounds];
    CGFloat clockSize = myBounds.size.width;
    if (myBounds.size.width != myBounds.size.height) {
        clockSize = (myBounds.size.width < myBounds.size.height) ? myBounds.size.width : myBounds.size.height;
    }
    
    // Set scaling factors
    CGFloat fillFactor = 0.9; // Fraction of frame filled by clock
    CGFloat clockRadius = 0.5 * clockSize * fillFactor; // Radius of clock
    CGFloat tickLength = 0.1 * clockRadius;  // Length of clock tick marks
    CGFloat hourHandLength = 0.5 * clockRadius;
    CGFloat hourHandExtension = 0.3;  // Fractional extension of hour hand on other side of center
    CGFloat minuteHandLength = 0.8 * clockRadius;
    CGFloat minuteHandExtension = 0.3; // Fractional extension of minute hand on other side of center
    CGFloat hourHandWidth = 0.08 * clockRadius;
    CGFloat minuteHandWidth = 0.03 * clockRadius;
    CGFloat tickWidth = 0.02 * clockRadius;
    CGFloat circleWidth = 0.02 * clockRadius;
    
    // Determine font sizes
    NSNumber *fontFraction = [NSNumber numberWithDouble:0.2 * clockRadius];
    NSInteger numberFontSize = [fontFraction integerValue];   // Number font size
    NSInteger periodFontSize = numberFontSize;  // Font size of AM/PM indicator
    
    // Make clock circle
    CGFloat xCenter = myBounds.size.width/2;
    CGFloat yCenter = myBounds.size.height/2;
    CGFloat xPosition = xCenter - clockRadius;
    CGFloat yPosition = yCenter - clockRadius;
    CGRect clockFrameRect = CGRectMake(xPosition, yPosition, 2 * clockRadius, 2 * clockRadius);
    CGContextAddEllipseInRect(context, clockFrameRect);
    CGContextSetLineWidth(context, circleWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw ticks and numbers
    CGFloat outerRadius = clockRadius;
    CGFloat innerRadius = outerRadius - tickLength;
    CGFloat numberRadius = innerRadius - 0.75 * numberFontSize;
    UIFont *numberFont = [UIFont fontWithName:@"Helvetica" size:numberFontSize];
    NSDictionary *numberAttributes = [NSDictionary dictionaryWithObjectsAndKeys:numberFont, NSFontAttributeName, nil];
    for (int count = 1; count <= 12; count++) {
        CGFloat angleInRadians = 0.1667 * M_PI * count;
        CGFloat sineTickAngle = sin(angleInRadians);
        CGFloat cosineTickAngle = cos(angleInRadians);
        CGFloat xInnerTick = xCenter + innerRadius * sineTickAngle;
        CGFloat yInnerTick = yCenter - innerRadius * cosineTickAngle;
        CGFloat xOuterTick = xCenter + outerRadius * sineTickAngle;
        CGFloat yOuterTick = yCenter - outerRadius * cosineTickAngle;
        CGFloat xNumberLocation = xCenter + numberRadius * sineTickAngle - 0.25 * numberFontSize;
        CGFloat yNumberLocation = yCenter - numberRadius * cosineTickAngle - 0.5 * numberFontSize;
        CGContextMoveToPoint(context, xInnerTick, yInnerTick);
        CGContextAddLineToPoint(context, xOuterTick, yOuterTick);
        NSString *numberString = [[NSNumber numberWithInt:count] stringValue];
        CGPoint numberPoint = CGPointMake(xNumberLocation, yNumberLocation);
        [numberString drawAtPoint:numberPoint withAttributes:numberAttributes];
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
    CGFloat sineHourAngle = sin(hourAngle);
    CGFloat cosineHourAngle = cos(hourAngle);
    CGFloat sineMinuteAngle = sin(minuteAngle);
    CGFloat cosineMinuteAngle = cos(minuteAngle);
    CGFloat xHourLongTip = xCenter + hourHandLength * sineHourAngle;
    CGFloat xHourShortTip = xCenter - hourHandExtension * hourHandLength * sineHourAngle;
    CGFloat yHourLongTip = yCenter - hourHandLength * cosineHourAngle;
    CGFloat yHourShortTip = yCenter + hourHandExtension * hourHandLength * cosineHourAngle;
    CGFloat xMinuteLongTip = xCenter + minuteHandLength * sineMinuteAngle;
    CGFloat xMinuteShortTip = xCenter - minuteHandExtension * minuteHandLength * sineMinuteAngle;
    CGFloat yMinuteLongTip = yCenter - minuteHandLength * cosineMinuteAngle;
    CGFloat yMinuteShortTip = yCenter + minuteHandExtension * minuteHandLength * cosineMinuteAngle;
    CGContextMoveToPoint(context, xHourShortTip, yHourShortTip);
    CGContextAddLineToPoint(context, xHourLongTip, yHourLongTip);
    CGContextSetLineWidth(context, hourHandWidth);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextMoveToPoint(context, xMinuteShortTip, yMinuteShortTip);
    CGContextAddLineToPoint(context, xMinuteLongTip, yMinuteLongTip);
    CGContextSetLineWidth(context, minuteHandWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    // Add period indicator label (AM/PM)
    CGRect periodRect = CGRectMake(xCenter + 0.3 * clockRadius, yCenter - 0.1 * clockRadius, 0.35 * clockRadius, 0.25 * clockRadius);
    CGContextAddRect(context, periodRect);
    CGContextSetLineWidth(context, circleWidth);
    CGContextDrawPath(context, kCGPathStroke);
    UIFont *periodFont = [UIFont fontWithName:@"Helvetica" size:periodFontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *periodAttributes = [NSDictionary dictionaryWithObjectsAndKeys:periodFont, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSString *periodString = ([theHour intValue] < 12) ? @"AM" : @"PM";
    [periodString drawInRect:periodRect withAttributes:periodAttributes];
}

@end
