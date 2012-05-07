//
//  NCNotificationController.m
//  NotifyCentral
//
//  Created by Alastair Tse on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationController.h"
#import "GTMBase64.h"
#import "GDataHTTPFetcher.h"

NSString * const kNCNotificationDeviceDidRegister = @"kNCNotificationDeviceDidRegister";
NSString * const kNCPrefDidRegisterDevice = @"kNCPrefDidRegisterDevice";
NSString * const kNCNotificationRegisterURL = @"http://liqx.appspot.com/notify/device/register";

@interface NCNotificationController ()
- (void)enableDeviceNotifications;
@end

@implementation NCNotificationController

- (id)init {
  self = [super init];
  if (self) {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:kNCPrefDidRegisterDevice]) {
      [self enableDeviceNotifications];
    }
  }
  return self;
}  

- (void)dealloc {
  [deviceToken_ release];
  [super dealloc];
}

- (void)registerDevice {
  [self enableDeviceNotifications];
//  if (deviceToken_) {
//    [self registerDeviceWithToken:deviceToken_];
//  }
}

- (void)enableDeviceNotifications {
  UIRemoteNotificationType notifications =
    UIRemoteNotificationTypeAlert |
    UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeSound;
  [[UIApplication sharedApplication]
      registerForRemoteNotificationTypes:notifications];
}

- (void)registerDeviceWithToken:(NSData *)token {
  NSString *deviceTokenEncoded =
      [GTMBase64 stringByWebSafeEncodingData:token padded:NO];
  NSString *deviceName =
      [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *urlString =
      [NSString stringWithFormat:@"%@?token=%@&name=%@&ts=%lld",
                                 kNCNotificationRegisterURL,
                                 deviceTokenEncoded,
                                 deviceName,
                                 (long long)[[NSDate date] timeIntervalSinceReferenceDate]];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
  [fetcher setCookieStorageMethod:kGDataHTTPFetcherCookieStorageMethodSystemDefault];
  [fetcher beginFetchWithDelegate:self
                didFinishSelector:@selector(registerRequest:finishedWithData:)
                  didFailSelector:@selector(registerRequest:failedWithError:)];
  
  // Remember registration state.
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setBool:YES forKey:kNCPrefDidRegisterDevice];
  [prefs synchronize];
  if (token != deviceToken_) {
    [deviceToken_ release];
    deviceToken_ = [token retain];
  }
}

- (void)registerRequest:(GDataHTTPFetcher *)fetcher
       finishedWithData:(NSData *)retrievedData {
  NSNotification *notification =
      [NSNotification notificationWithName:kNCNotificationDeviceDidRegister
                                    object:self];
  [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                             postingStyle:NSPostWhenIdle];
  NSLog(@"Registered Device.");
}

- (void)registerRequest:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error registering for notifications"
                                                  message:[error localizedDescription]
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}


- (void)registerDeviceDidFail:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error registering for notifications"
                                                  message:[error localizedDescription]
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}


@end
