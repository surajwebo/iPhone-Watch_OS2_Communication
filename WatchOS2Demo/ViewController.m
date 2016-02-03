//
//  ViewController.m
//  WatchOS2Demo
//
//  Created by Suraj Mirajkar on 03/02/16.
//  Copyright © 2016 Suraj Mirajkar. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController () <WCSessionDelegate> {
    __weak IBOutlet UISegmentedControl *segmentedCtrlGender;
    __weak IBOutlet UISegmentedControl *segmentedCtrlAgeGroup;
    __weak IBOutlet UIButton *btnSendMessage;
}

- (IBAction)sendMessageToPairedDevice:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeWatchConnectivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessageToPairedDevice:(id)sender {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        if (session.isPaired && session.isReachable) {
            NSString *selectedGender = [segmentedCtrlGender titleForSegmentAtIndex:segmentedCtrlGender.selectedSegmentIndex];
            NSString *selectedAgeGroup = [segmentedCtrlAgeGroup titleForSegmentAtIndex:segmentedCtrlAgeGroup.selectedSegmentIndex];
            NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjects:@[selectedGender, selectedAgeGroup] forKeys:@[@"Gender", @"AgeGroup"]];
            [session updateApplicationContext:applicationDict error:nil];
        }
    }
}

- (void)initializeWatchConnectivity {
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

/** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext {
    NSLog(@"Application Context received on iPhone: %@",applicationContext);
    if ([applicationContext objectForKey:@"DataReceivedByWatch"] != nil) {
        NSString *messageFromWatch = [applicationContext objectForKey:@"DataReceivedByWatch"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [[[UIAlertView alloc] initWithTitle:@"Message From Watch" message:messageFromWatch delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        });
    }
}

@end
