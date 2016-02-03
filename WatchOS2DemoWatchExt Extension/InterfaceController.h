//
//  InterfaceController.h
//  WatchOS2DemoWatchExt Extension
//
//  Created by Suraj Mirajkar on 03/02/16.
//  Copyright © 2016 Suraj Mirajkar. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController {
    NSString *strGender;
    NSString *strAgeGroup;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblGender;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lblAgeGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnSendMessage;

- (IBAction)sendMessageToWatch;

@end
