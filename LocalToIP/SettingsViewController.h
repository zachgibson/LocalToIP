//
//  SettingsViewController.h
//  LocalToIP
//
//  Created by Zach Gibson on 10/30/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsViewController : NSViewController<NSTextFieldDelegate, NSTableViewDelegate>

@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet NSTableView *tableView;

@end
