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
    
    NSString *ipAddrWithSlash = [NSString stringWithFormat:@"%@:", ipAddr];
    [self.textFieldLabel setStringValue:ipAddrWithSlash];
}

- (void)setIP:(NSString *)ip {
    NSLog(@"%@", ip);
    
    ipAddr = ip;
}

- (IBAction)buttonClick:(NSButton *)sender {
    NSString *port = [self.textFieldValue stringValue];
    NSString *fullAddr = [NSString stringWithFormat:@"http://%@:%@/", ipAddr, port];
    NSLog(@"%@", fullAddr);
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter new];
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.encoding = NSUTF8StringEncoding;
    hints.dataMatrixShape = ZXDataMatrixSymbolShapeHintForceSquare;
    
    ZXBitMatrix *result = [writer encode:fullAddr
                                  format:kBarcodeFormatQRCode
                                   width:300
                                  height:300
                                   hints:hints
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        NSImage *qr = [[NSImage alloc] initWithCGImage:image size:CGSizeMake(300, 300)];
        self.imageView.image = qr;
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"%@", errorMessage);
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
