//
//  NCNotificationController.h
//  NotifyCentral
//
//  Created by Alastair Tse on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNCNotificationDeviceDidRegister;

@class NCRegisterRequest;

@interface NCNotificationController : NSObject <UIAlertViewDelegate> {
  NSData *deviceToken_;
  NCRegisterRequest *registerRequest_;
}

- (void)registerDevice;
- (void)registerDeviceWithToken:(NSData *)token;
- (void)registerDeviceDidFail:(NSError *)error;
@end
