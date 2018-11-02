//
//  SettingsViewController.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/30/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

NSMutableArray *portsArray;

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.segmentedControl setEnabled:NO forSegment:1];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    if ([self.tableView selectedRow] == -1) {
        [self.segmentedControl setEnabled:NO forSegment:1];
    } else {
        [self.segmentedControl setEnabled:YES forSegment:1];
    }
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
    NSData *ports = [NSKeyedArchiver archivedDataWithRootObject:portsArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:ports forKey:@"ports"];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = [obj object];
    [portsArray replaceObjectAtIndex:[portsArray count] - 1 withObject:[textField stringValue]];
}

- (IBAction)segmentedControlClicked:(NSSegmentedControl *)sender {
    NSString *lastObjectValue = [NSString stringWithFormat:@"%@", [portsArray lastObject]];
    long objectCharacterCount = [lastObjectValue length];
    
    if ([sender selectedSegment] == 0 && objectCharacterCount != 0) {
        [self addTableRow];
    }
    
    if ([sender selectedSegment] == 1) {
        [self removeTableRow];
    }
}

- (void)addTableRow {
    long nextIndex = [portsArray count];
    
    [portsArray addObject:@""];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:nextIndex] withAnimation:NSTableViewAnimationEffectFade];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:NO];
    [self.tableView editColumn:0 row:nextIndex withEvent:nil select:YES];
}

- (void)removeTableRow {
    long selectedIndex = [self.tableView selectedRow];
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedIndex] withAnimation:NSTableViewAnimationEffectFade];
    [portsArray removeObjectAtIndex:selectedIndex];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [portsArray count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"Port" owner:self];
    result.textField.stringValue = [portsArray objectAtIndex:row];
    
    return result;
}


@end
