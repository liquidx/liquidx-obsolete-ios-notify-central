    //
//  NCWebViewController.m
//  NotifyCentral
//
//  Created by Alastair Tse on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NCWebViewController.h"
#import "NCNotificationController.h"

static NSString * const kRegisterScheme = @"notify-register";

@interface NCWebViewController ()
- (void)registerForNotifications;
@end


@implementation NCWebViewController
@synthesize notificationController = notificationController_;
- (void)loadView {
  webView_ = [[UIWebView alloc] init];
  [self reload];
  [webView_ setDelegate:self];
  [self setView:webView_];
  [self registerForNotifications];
  
  UIBarButtonItem *button =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                    target:self
                                                    action:@selector(reload)];
  self.navigationItem.leftBarButtonItem = button;
  [button release];
  
  spinner_ = [[UIActivityIndicatorView alloc]
                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  UIBarButtonItem *spinnerButton =
      [[UIBarButtonItem alloc] initWithCustomView:spinner_];
  self.navigationItem.rightBarButtonItem = spinnerButton;
  [spinnerButton release];
  [spinner_ release];
  
  [self setTitle:@"Notifier"];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [notificationController_ release];
  [webView_ release];
  [super dealloc];
}

#pragma mark -

- (void)reload {
#if TARGET_IPHONE_SIMULATOR
  NSURL *url = [NSURL URLWithString:@"http://localhost:8084/notify/"];
#else  
  NSURL *url = [NSURL URLWithString:@"http://liqx.appspot.com/notify/"];
#endif
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [webView_ loadRequest:request];  
}

#pragma mark Events

- (void)registerForNotifications {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(deviceDidRegister:)
             name:kNCNotificationDeviceDidRegister
           object:nil];
}

- (void)deviceDidRegister:(NSNotification *)notification {
  //[self reload];
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)navigationType {

  NSURL *url = [request URL];
  if ([[url scheme] isEqual:@"http"] || [[url scheme] isEqual:@"https"]) {
    return YES;
  }
  if ([[url scheme] isEqual:kRegisterScheme]) {
    [notificationController_ registerDevice];
  } else {
    [[UIApplication sharedApplication] openURL:url];
  }
  return NO;
}  

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [spinner_ startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [spinner_ stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"Error: %@", error);
  if ([error code] == NSURLErrorCancelled) {
    // ignored.
    return;
  }
  NSString *url = [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:url
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:@"Not my fault."
                                            otherButtonTitles:nil];
  [alertView show];
  [alertView autorelease];
}
@end
