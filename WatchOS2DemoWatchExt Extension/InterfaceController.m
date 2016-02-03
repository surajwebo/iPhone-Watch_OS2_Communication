//
//  InterfaceController.m
//  WatchOS2DemoWatchExt Extension
//
//  Created by Suraj Mirajkar on 03/02/16.
//  Copyright © 2016 Suraj Mirajkar. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController() <WCSessionDelegate> {
    
}

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    strGender = @"Gender";
    strAgeGroup = @"Age Group";
    
    [self initializeiPhoneConnectivity];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)initializeiPhoneConnectivity {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

/** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
    NSLog(@"Application Context received on Watch: %@",applicationContext);
    if ([applicationContext objectForKey:@"Gender"] != nil && [applicationContext objectForKey:@"AgeGroup"] != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            // As Watch does not provide a getter method for WKInterfaceLabel we have to set it to an NSString and then use it to update and get values as and when required
            strGender = [applicationContext objectForKey:@"Gender"];
            strAgeGroup = [applicationContext objectForKey:@"AgeGroup"];
            self.lblGender.text = strGender;
            self.lblAgeGroup.text = strAgeGroup;
        });
    }
}

- (IBAction)sendMessageToWatch {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        if (session.isReachable) {
            NSDictionary *applicationDict;
            if ([strGender isEqualToString:@"Gender"] && [strAgeGroup isEqualToString:@"Age Group"]) {
                applicationDict = [[NSDictionary alloc] initWithObjects:@[@"The Gender and Age Group details not provided by iPhone"] forKeys:@[@"DataReceivedByWatch"]];
            } else if ([strGender isEqualToString:@"Gender"]) {
                applicationDict = [[NSDictionary alloc] initWithObjects:@[@"The Gender details not provided by iPhone"] forKeys:@[@"DataReceivedByWatch"]];
            } else if ([strAgeGroup isEqualToString:@"Age Group"]) {
                applicationDict = [[NSDictionary alloc] initWithObjects:@[@"The Age Group details not provided by iPhone"] forKeys:@[@"DataReceivedByWatch"]];
            } else {
                NSString *strMessage = [NSString stringWithFormat:@"The Gender: %@ and Age Group: %@ received by Watch",strGender, strAgeGroup];
                applicationDict = [[NSDictionary alloc] initWithObjects:@[strMessage] forKeys:@[@"DataReceivedByWatch"]];
            }
            [session updateApplicationContext:applicationDict error:nil];
        }
    }
}
@end



