//
//  AppDelegate.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

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
    
    storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyBoard instantiateControllerWithIdentifier:@"ViewController"];
    popover = [[NSPopover alloc] init];
    [popover setDelegate:self];
    popover.contentViewController = viewController;
    
    ViewController *vc = [[ViewController alloc] init];
    [vc setIP:[self getIPWithNSHost]];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskRightMouseDown handler:^(NSEvent *event){
        [self togglePopover:self];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent *event){
        [self togglePopover:self];
    }];
}

- (void)popoverDidShow:(NSNotification *)notification {
    
//    [gucci setIP];
}

- (NSString *)getIPWithNSHost {
    NSArray *addresses = [[NSHost currentHost] addresses];
    NSString *stringAddress;
    
//    NSLog(@"%@", addresses);
    
    for (NSString *anAddress in addresses) {
        if (![anAddress hasPrefix:@"127"] && [[anAddress componentsSeparatedByString:@"."] count] == 4) {
            stringAddress = anAddress;
            break;
        } else {
            stringAddress = @"IPv4 address not available" ;
        }
    }
    
    return stringAddress;
}

- (void)togglePopover:(id)sender {
    if (popover.isShown) {
        [popover close];
    } else {
        [popover showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSRectEdgeMinY];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
