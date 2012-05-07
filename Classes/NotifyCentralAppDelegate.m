//
//  NotifyCentralAppDelegate.m
//  NotifyCentral
//
//  Created by Alastair Tse on 4/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NotifyCentralAppDelegate.h"
#import "NCWebViewController.h"
#import "NCNotificationController.h"

@interface NotifyCentralAppDelegate ()
@end

@implementation NotifyCentralAppDelegate


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

  NSDictionary *notification =
      [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if ([notification objectForKey:@"url"]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[notification objectForKey:@"url"]]];
  }
  
  CGRect appFrame = [[UIScreen mainScreen] bounds];
  appFrame.origin = CGPointZero;
  window_ = [[UIWindow alloc] initWithFrame:appFrame];
  
  navController_ = [[UINavigationController alloc] init];
  webViewController_ = [[NCWebViewController alloc] init];
  notificationController_ = [[NCNotificationController alloc] init];
  [webViewController_ setNotificationController:notificationController_];
  [navController_ pushViewController:webViewController_ animated:NO];
  [window_ addSubview:[navController_ view]];
  [window_ makeKeyAndVisible];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [notificationController_ release];
  [webViewController_ release];
	[navController_ release];
	[window_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark Register

- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [notificationController_ registerDeviceWithToken:deviceToken];
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [notificationController_ registerDeviceDidFail:error];
}

#pragma mark -
#pragma mark Push Notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  NSLog(@"didReceiveNotification: %@", userInfo);
}

#pragma mark -
#pragma mark Background

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"Entering Background");
}  

- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"Enter Foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"Become Active");
}

- (void)applicationWillResignActive:(UIApplication *)application {
  NSLog(@"Resign Active");
}




@end

