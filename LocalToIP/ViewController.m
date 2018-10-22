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

NSString *ipAddr;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSError *error = nil;
//    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter new];
//    ZXEncodeHints *hints = [ZXEncodeHints hints];
//    hints.encoding = NSUTF8StringEncoding;
//    hints.dataMatrixShape = ZXDataMatrixSymbolShapeHintForceSquare;
//    
//    ZXBitMatrix *result = [writer encode:@"spotify:track:1qlgw9MTX3xLaM8YH2OyAv"
//                                  format:kBarcodeFormatQRCode
//                                   width:1220
//                                  height:1220
//                                   hints:hints
//                                   error:&error];
//    
//    if (result) {
//        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
//        NSImage *qr = [[NSImage alloc] initWithCGImage:image size:CGSizeMake(610, 610)];
//        self.imageView.image = qr;
//    } else {
//        NSString *errorMessage = [error localizedDescription];
//        NSLog(@"%@", errorMessage);
//    }
    
    NSString *ipAddrWithSlash = [NSString stringWithFormat:@"%@:", ipAddr];
    [self.textFieldLabel setStringValue:ipAddrWithSlash];
    [self.portComboBox setDelegate:self];
    
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
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter new];
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
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            NSImage *qr = [[NSImage alloc] initWithCGImage:image size:CGSizeMake(610, 610)];
            self.imageView.image = qr;
        } else {
            NSString *errorMessage = [error localizedDescription];
            NSLog(@"%@", errorMessage);
        }
    } else {
        NSLog(@"no port detected");
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
