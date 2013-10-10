//
//  WTAppDelegate.m
//  wattTime v0.4
//
//  Created by Colin McCormick on 7/2/13.
//  Copyright (c) 2013 wattTime. All rights reserved.
//

#import "WTAppDelegate.h"

@implementation WTAppDelegate

@synthesize window = _window;

#pragma mark - My methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create dataModel object
    self.dataModel = [[WTDataModel alloc] init];
    // Set Navigation Bar appearance
    UIColor *navBarColor = [UIColor colorWithRed:0.529 green:0.843 blue:0.976 alpha:1.0];
    UIFont *navBarFont = [UIFont fontWithName:@"MarkerFelt-Thin" size:25];
    UIColor *navBarTitleColor = [UIColor colorWithRed:0.380 green:0.667 blue:0.231 alpha:1.0];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:navBarFont forKey:UITextAttributeFont];
    [titleBarAttributes setValue:navBarTitleColor forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    [[UINavigationBar appearance] setBackgroundColor:navBarColor];
    
    UIColor *tabBarColor = [UIColor colorWithRed:0.529 green:0.843 blue:0.976 alpha:1.0];
    [[UITabBar appearance] setBackgroundColor:tabBarColor];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
