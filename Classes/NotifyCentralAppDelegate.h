//
//  NotifyCentralAppDelegate.h
//  NotifyCentral
//
//  Created by Alastair Tse on 4/18/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCWebViewController;
@class NCNotificationController;

@interface NotifyCentralAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window_;
  UINavigationController *navController_;
  NCNotificationController *notificationController_;
  NCWebViewController *webViewController_;
}

@end

