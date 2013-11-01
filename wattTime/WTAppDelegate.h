//
//  WTAppDelegate.h
//  wattTime
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDataModel.h"

@interface WTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WTDataModel *dataModel;

- (NSURL *)applicationDocumentsDirectory;

@end
