//
//  AppDelegate.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    
    NSImage *icon = [NSImage imageNamed:@"qr"];
    icon.template = YES;
    
    statusItem.button.image = icon;
    statusItem.button.action = @selector(togglePopover:);
    
    NSStoryboard *storyBoard;
    storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *viewController;
    viewController = [storyBoard instantiateControllerWithIdentifier:@"ViewController"];
    popover = [[NSPopover alloc] init];
    popover.behavior = NSPopoverBehaviorTransient;
    [popover setDelegate:self];
    popover.contentViewController = viewController;
    
    ViewController *vc = [[ViewController alloc] init];
    ipAddress = self.getIPAddress;
    [vc setIP:ipAddress];
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    return address;
}

- (void)togglePopover:(id)sender {
    if (popover.isShown) {
        [popover close];
    } else {
        [popover showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSRectEdgeMinY];
        [NSRunningApplication.currentApplication activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    }
}


@end
