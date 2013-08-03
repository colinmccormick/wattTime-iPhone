//
//  WTMainViewController.h
//  wattTime v0.1
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTFlipsideViewController.h"

#define BASE_URL @"https://watttime.herokuapp.com/"
#define TODAY_REQUEST @"today?st="
#define PERCENT_GREEN_KEY @"percent_green"

@interface WTMainViewController : UIViewController <WTFlipsideViewControllerDelegate, UIPopoverControllerDelegate> {

    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *percentGreenLabel;
    __weak IBOutlet UILabel *futurePercentGreenLabel;
    __weak IBOutlet UILabel *futureTimeLabel;
 
    __weak IBOutlet UIButton *updateButton;
    
    NSDate *currentDate;
    NSTimer *updateTimer;
}
    
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSArray *locationArray;

- (IBAction)updateButtonWasTapped:(id)sender;
- (void)updateLocation:(NSString *)location;
- (void)fetchDataAndUpdateDisplay;

@end
