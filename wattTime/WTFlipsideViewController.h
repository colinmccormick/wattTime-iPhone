//
//  WTFlipsideViewController.h
//  wattTime v0.1
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTFlipsideViewController;

@protocol WTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(WTFlipsideViewController *)controller;
- (void)updateLocation:(NSString *)location;
@end

@interface WTFlipsideViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *pickerView;
    NSArray *locationArray;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSString *currentLocation;

@property (weak, nonatomic) IBOutlet id <WTFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

- (void)updateLocation:(NSString *)location;

@end
