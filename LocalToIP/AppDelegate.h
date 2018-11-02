//
//  AppDelegate.h
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate> {
    NSStatusItem *statusItem;
    NSPopover *popover;
    NSString *ipAddress;
}

- (NSString *)getIPAddress;
- (void)togglePopover:(id)sender;

@end

