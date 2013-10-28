//
//  WTButton.m
//  wattTime
//
//  Created by Colin McCormick on 10/27/13.
//  Copyright (c) 2013 Novodox. All rights reserved.
//

#import "WTButton.h"

@implementation WTButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set button properties here
        [self.layer setCornerRadius:10.0];
        [self.layer setBorderWidth:1.0];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Set button properties here
        [self.layer setCornerRadius:10.0];
        [self.layer setBorderWidth:1.0];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
