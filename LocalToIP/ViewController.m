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
@property (weak) IBOutlet NSTextField *textFieldLabel;
@property (weak) IBOutlet NSButton *button;
@property (weak) NSString *selectedPort;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *ipAddrWithColon = [NSString stringWithFormat:@"%@", ipAddr];
    [self.textFieldLabel setStringValue:ipAddrWithColon];
    [self.portComboBox setDelegate:self];
}

- (void)viewDidAppear {
    [self.portComboBox removeAllItems];
    NSArray *savedPorts = [[NSUserDefaults standardUserDefaults] objectForKey:@"ports"];
    
    NSLog(@"%@", savedPorts);
    
    if (savedPorts) {
        [self.portComboBox addItemsWithObjectValues:savedPorts];
    }
}

- (void)setIP:(NSString *)ip {
    ipAddr = ip;
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

- (IBAction)onRefreshIPButtonPress:(NSButton *)sender {
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    ipAddr = [appDelegate getIPAddress];
    
    [self.textFieldLabel setStringValue:[appDelegate getIPAddress]];
}

- (IBAction)onSettingsButtonPress:(NSButton *)sender {
    NSStoryboard *storyBoard;
    storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *viewController;
    viewController = [storyBoard instantiateControllerWithIdentifier:@"SettingsViewController"];
 
    [viewController presentViewControllerAsModalWindow:viewController];
}

@end
