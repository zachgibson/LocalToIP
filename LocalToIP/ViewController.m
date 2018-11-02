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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *ipAddrWithColon = [NSString stringWithFormat:@"%@:", ipAddr];
    [self.textFieldLabel setStringValue:ipAddrWithColon];
    [self.portComboBox setDelegate:self];
    
    NSUserDefaults *defaults;
    NSArray *ports = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"ports"]];
    NSLog(@"%@", ports);
    [self.portComboBox addItemsWithObjectValues:ports];
    
    if ([[self.portComboBox stringValue] length] == 0) {
        [self.button setEnabled:NO];
    } else {
        [self.button setEnabled:YES];
    }
}

- (void)setIP:(NSString *)ip {
    ipAddr = ip;
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSComboBox *comboBox = [notification object];
    
    if ([[comboBox stringValue] length] != 0) {
        [self.button setEnabled:YES];
    } else {
        [self.button setEnabled:NO];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    [self.button setEnabled:YES];
}

- (IBAction)buttonClick:(NSButton *)sender {
    NSString *port = [self.portComboBox stringValue];
    NSString *path = [self.pathComboBox stringValue];
    NSString *fullAddr = [NSString stringWithFormat:@"http://%@:%@/%@", ipAddr, port, path];

    if ([port length] != 0) {
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
    } else {
        NSLog(@"no port detected");
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
