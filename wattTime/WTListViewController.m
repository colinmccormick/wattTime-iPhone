//
//  WTListViewController.m
//  wattTime
//
//  Created by Colin McCormick on 10/29/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTListViewController.h"

@implementation WTListViewController

@synthesize arrayOfIntervalData = _arrayOfIntervalData;

// Update display using data from dataModel.  Only use data from now forward
- (void)updateIntervalData {
    // Set up spinner to display while waiting for download
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160,180);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    // Send download request (use second thread to avoid blocking main thread)
    dispatch_queue_t fetch_queue = dispatch_queue_create("JSON Fetch", NULL);
    dispatch_async(fetch_queue, ^{
        // THIS IS THE NETWORK CALL
        NSArray *arrayOfIntervalData = [dataModel generateArrayOfIntervalData];
        // Put back on the main thread to use UIKit (in the setter for arrayOfIntervalData)
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arrayOfIntervalData) {
                // Trim entries in array before current hour
                NSDate *date = [NSDate date];
                NSCalendar *gregorian = [NSCalendar currentCalendar];
                NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:date];
                NSUInteger hour = [components hour];
                NSRange arrayRange = NSMakeRange(hour, [arrayOfIntervalData count] - hour);
                NSArray *trimmedArrayOfIntervalData = [arrayOfIntervalData subarrayWithRange:arrayRange];
                [self setArrayOfIntervalData:trimmedArrayOfIntervalData];
                [self.tableView reloadData];
            }
            [spinner stopAnimating];
        });
    });
}

- (void)refresh {
    [self updateIntervalData];
    [self.refreshControl endRefreshing];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialize dataFormatterJSON and dateFormatterDisplay
        NSDateFormatter *formatterOne = [[NSDateFormatter alloc] init];
        [formatterOne setDateFormat:DATE_FORMAT_STRING];
        [formatterOne setAMSymbol:@"am"];
        [formatterOne setPMSymbol:@"pm"];
        dateFormatterDisplay = formatterOne;
        NSDateFormatter *formatterTwo = [[NSDateFormatter alloc] init];
        [formatterTwo setDateFormat:JSON_DATE_FORMAT];
        dateFormatterJSON = formatterTwo;
        NSNumberFormatter *formatterThree = [[NSNumberFormatter alloc] init];
        [formatterThree setMaximumFractionDigits:1];
        [formatterThree setNumberStyle:NSNumberFormatterDecimalStyle];
        numberFormatter = formatterThree;
        // Set up color constants
        lowRenewablesColor = [UIColor colorWithRed:0.878 green:0.376 blue:0.392 alpha:1.0];
        mediumRenewablesColor = [UIColor colorWithRed:0.992 green:0.706 blue:0.557 alpha:1.0];
        highRenewablesColor = [UIColor colorWithRed:0.671 green:0.898 blue:0.529 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Find pointer to the data model
    WTAppDelegate *appDelegate = (WTAppDelegate *)[[UIApplication sharedApplication] delegate];
    dataModel = appDelegate.dataModel;
    // Set up pull-to-refresh for list
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    // Set up tableView styles (other settings done in storyboard)
    self.tableView.separatorColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateIntervalData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfIntervalData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set time label
    NSDictionary *intervalDictionary = [self.arrayOfIntervalData objectAtIndex:indexPath.row];
    NSDate *intervalTime = [dateFormatterJSON dateFromString:[intervalDictionary objectForKey:LOCAL_TIME_KEY]];
    NSString *intervalTimeDisplay = [dateFormatterDisplay stringFromDate:intervalTime];
    cell.textLabel.text = intervalTimeDisplay;
    
    // Set percentage green label
    NSNumber *renewablesPercentage = [intervalDictionary objectForKey:PERCENT_GREEN_KEY];
    NSString *renewablesPercentageString = [numberFormatter stringFromNumber:renewablesPercentage];
    NSString *labelString = [NSString stringWithFormat:@"%@%@%@%@", renewablesPercentageString, @"%", LINE_BREAK, LIST_CLEAN_STRING];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = labelString;
    
    // Set color.  This should eventually come from the API data, not hard-coded here
    if ([renewablesPercentage doubleValue] <= 2) {
        cell.backgroundColor = lowRenewablesColor;
    } else if ([renewablesPercentage doubleValue] <= 5) {
        cell.backgroundColor = mediumRenewablesColor;
    } else {
        cell.backgroundColor = highRenewablesColor;
    }
    return cell;
}

@end
