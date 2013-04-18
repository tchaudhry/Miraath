//
//  IOPAppDelegate.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPAppDelegate.h"
#import "CenterViewController.h"
#import "SlideOutMenuContainerViewController.h"
#import "IOPMenuTableViewController.h"

@implementation IOPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    IOPMenuTableViewController *menuTableViewController = [[IOPMenuTableViewController alloc] init];
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuTableViewController];
    
    CenterViewController *centerViewController = [[CenterViewController alloc] init];
    //UINavigationController *centerNavigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    
    SlideOutMenuContainerViewController *slideOutMenuContainerViewController = [[SlideOutMenuContainerViewController alloc] initWithMenuViewController:menuNavigationController andCenterViewController:centerViewController];
	
	slideOutMenuContainerViewController.containerDelegate = centerViewController;
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.window.rootViewController = slideOutMenuContainerViewController;
    [self.window makeKeyAndVisible];
	//[self.window.rootViewController presentViewController:centerNavigationController animated:NO completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
