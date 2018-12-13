//
//  ViewController.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "ViewController.h"
#import <ZXQRCodeEncoder.h>
#import <ZXEncodeHints.h>
#import <ZXDataMatrixSymbolInfo.h>
#import <ZXDataMatrixWriter.h>
#import <ZXMultiFormatWriter.h>
#import <ZXImage.h>
#import "AppDelegate.h"

NSString *ipAddr;

@interface ViewController ()

@property (weak) IBOutlet NSComboBox *protocolComboBox;
@property (weak) IBOutlet NSComboBox *portComboBox;
@property (weak) IBOutlet NSComboBox *pathComboBox;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *ipAddressTextField;
@property (weak) IBOutlet NSButton *button;
@property (weak) NSString *selectedPort;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setIpAddressStringValue];
    [self.portComboBox setDelegate:self];
}

- (void)viewDidAppear {
    [self.portComboBox removeAllItems];
    NSArray *savedPorts = [[NSUserDefaults standardUserDefaults] objectForKey:@"ports"];
    
    if (savedPorts) {
        [self.portComboBox addItemsWithObjectValues:savedPorts];
    }
}

- (void)setIpAddressStringValue {
    [self.ipAddressTextField setStringValue:ipAddr];
}

- (void)setIP:(NSString *)ip {
    ipAddr = ip;
}

- (void)refreshIP {
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    [self setIP:[appDelegate getIPAddress]];
    [self setIpAddressStringValue];
}

- (void)quitApp {
    [NSApp terminate:self];
}

- (IBAction)buttonClick:(NSButton *)sender {
    NSString *protocol = [self.protocolComboBox stringValue];
    NSString *port = [self.portComboBox stringValue];
    NSString *path = [self.pathComboBox stringValue];
    NSString *fullAddr = [NSString stringWithFormat:@"%@://%@:%@/%@", protocol, ipAddr, port, path];

    NSError *error = nil;
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.encoding = NSUTF8StringEncoding;
    hints.dataMatrixShape = ZXDataMatrixSymbolShapeHintForceSquare;
    
    ZXBitMatrix *result = [writer encode:fullAddr
                                  format:kBarcodeFormatQRCode
                                   width:1220
                                  height:1220
                                   hints:hints
                                   error:&error];
    
    if (result) {
        NSImage *qr = [[NSImage alloc] initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage] size:CGSizeMake(610, 610)];
        self.imageView.image = qr;
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"%@", errorMessage);
    }
}

- (IBAction)onAirDropPress:(NSButton *)sender {
    NSString *protocol = [self.protocolComboBox stringValue];
    NSString *port = [self.portComboBox stringValue];
    NSString *path = [self.pathComboBox stringValue];
    NSString *fullAddr = [NSString stringWithFormat:@"%@://%@:%@/%@", protocol, ipAddr, port, path];
    NSURL *url = [NSURL URLWithString:fullAddr];
    
    NSSharingService *service = [NSSharingService sharingServiceNamed:NSSharingServiceNameSendViaAirDrop];
    NSArray *shareItems = [NSArray arrayWithObjects:url, nil];
    [service performWithItems:shareItems];
}

- (IBAction)onSettingsButtonPress:(NSButton *)sender {
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *itemAbout = [[NSMenuItem alloc] initWithTitle:@"About" action:nil keyEquivalent:@""];
    NSMenuItem *itemFAQ = [[NSMenuItem alloc] initWithTitle:@"FAQ" action:nil keyEquivalent:@""];
    NSMenuItem *itemRefreshIP = [[NSMenuItem alloc] initWithTitle:@"Refresh IP Address" action:@selector(refreshIP) keyEquivalent:@"r"];
    NSMenuItem *itemSettings = [[NSMenuItem alloc] initWithTitle:@"Settings" action:@selector(openSettings) keyEquivalent:@"s"];
    NSMenuItem *itemQuit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitApp) keyEquivalent:@"q"];
    [menu addItem:itemAbout];
    [menu addItem:itemFAQ];
    [menu insertItem:[NSMenuItem separatorItem] atIndex:2];
    [menu addItem:itemRefreshIP];
    [menu addItem:itemSettings];
    [menu insertItem:[NSMenuItem separatorItem] atIndex:5];
    [menu addItem:itemQuit];
    [menu popUpMenuPositioningItem:itemAbout atLocation:NSPointFromCGPoint(CGPointMake(sender.frame.origin.x, sender.frame.origin.y - (sender.frame.size.height / 2))) inView:self.view];
}

- (void)openSettings {
    NSStoryboard *storyBoard;
    storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *viewController;
    viewController = [storyBoard instantiateControllerWithIdentifier:@"SettingsViewController"];

    [viewController presentViewControllerAsModalWindow:viewController];
}

@end
