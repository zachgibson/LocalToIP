//
//  ViewController.h
//  LocalToIP
//
//  Created by Zach Gibson on 10/9/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

- (void)setIP:NSString;
@property (weak) IBOutlet NSComboBox *portComboBox;

@property (weak) IBOutlet NSTextField *textFieldValue;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *textFieldLabel;
@property (weak) IBOutlet NSButton *button;

@end

