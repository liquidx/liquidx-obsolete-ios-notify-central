//
//  NCWebViewController.h
//  NotifyCentral
//
//  Created by Alastair Tse on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NCNotificationController;

@interface NCWebViewController : UIViewController <UIWebViewDelegate> {
  UIWebView *webView_;
  NCNotificationController *notificationController_;
  UIActivityIndicatorView *spinner_; // weak
}
@property (nonatomic, retain) NCNotificationController *notificationController;

- (void)reload;
@end
