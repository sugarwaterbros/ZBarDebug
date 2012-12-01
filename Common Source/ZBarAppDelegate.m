//
//  ZBarAppDelegate.m
//  ZBarDebug
//
//  Created by Sugarwater Brothers on 12/11/30.
//  Copyright (c) 2012 Sugarwater Brothers. All rights reserved.
//

#import "ZBarAppDelegate.h"
#import "ZBarViewController.h"
#import "ZBarSDK.h"

@implementation ZBarAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	/* store in ZBarApp.xib as Main Interface of TARGET */
	[self.window makeKeyAndVisible];

	/* ZBar: force view class to load so it may be referenced directly from NIB */
	[ZBarReaderView class];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
}

- (void)applicationWillTerminate:(UIApplication*)application
{
}

@end
