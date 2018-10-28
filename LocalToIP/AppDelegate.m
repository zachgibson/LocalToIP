//
//  AppDelegate.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "IPAddress.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
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
    ipAddress = [[IPAddress interfaceIP4Addresses] allKeys][0];
    [vc setIP:ipAddress];
    
//    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskRightMouseDown handler:^(NSEvent *event){
//        [self togglePopover:self];
//    }];
//
//    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent *event){
//        [self togglePopover:self];
//    }];
}

- (void)togglePopover:(id)sender {
    if (popover.isShown) {
        [popover close];
    } else {
        [popover showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSRectEdgeMinY];
    }
}


@end
