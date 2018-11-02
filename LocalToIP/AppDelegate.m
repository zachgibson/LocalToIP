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
    NSString *source = @"do shell script \"ipconfig getifaddr en0\"";
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    NSDictionary *dict = nil;
    NSAppleEventDescriptor *descriptor = [script executeAndReturnError:&dict];
    
    return [descriptor stringValue];
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
