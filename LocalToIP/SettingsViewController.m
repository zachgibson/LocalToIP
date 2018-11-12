//
//  SettingsViewController.m
//  LocalToIP
//
//  Created by Zach Gibson on 10/30/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (strong) NSMutableArray *tableContents;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;

@end

@implementation SettingsViewController

bool lastRowIsEmpty = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableContents = [NSMutableArray array];
    
    NSArray *savedPorts = [[NSUserDefaults standardUserDefaults] objectForKey:@"ports"];
    [self.tableContents addObjectsFromArray:savedPorts];
    [self.tableView reloadData];
    
    [self.segmentedControl setEnabled:NO forSegment:1];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.tableContents.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    cellView.textField.stringValue = self.tableContents[row];
    return cellView;
}

- (IBAction)segmentedControl:(NSSegmentedControl *)sender {
    if ([sender selectedSegment] == 0) {
        [self addTableRow];
    }

    if ([sender selectedSegment] == 1) {
        [self removeTableRow];
    }
}

- (void)addTableRow {
    [self.segmentedControl setEnabled:NO forSegment:0];
    [self.segmentedControl setEnabled:YES forSegment:1];
    
    if (!lastRowIsEmpty) {
        [self.tableContents addObject:@""];
        [self.tableView deselectAll:self];
        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableContents.count - 1] withAnimation:NSTableViewAnimationEffectFade];
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.tableContents.count - 1] byExtendingSelection:NO];
        [self.tableView editColumn:0 row:self.tableContents.count - 1 withEvent:nil select:YES];
    } else {
        [self.tableView editColumn:0 row:self.tableView.numberOfRows - 1 withEvent:nil select:YES];
    }
    
    lastRowIsEmpty = YES;
}

- (void)removeTableRow {
    [self.segmentedControl setEnabled:YES forSegment:0];
    [self.segmentedControl setEnabled:NO forSegment:1];
    
    [self.tableContents removeObjectAtIndex:self.tableView.selectedRow];
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableView.selectedRow] withAnimation:NSTableViewAnimationEffectFade];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.tableContents forKey:@"ports"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    lastRowIsEmpty = NO;
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    [self.segmentedControl setEnabled:YES forSegment:0];
    [self.segmentedControl setEnabled:NO forSegment:1];
    
    if (self.tableContents.count > 0) {
        NSTextField *textField = [obj object];
        NSString *textFieldString = [textField stringValue];
        [self.tableContents replaceObjectAtIndex:self.tableContents.count - 1 withObject:textFieldString];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.tableContents forKey:@"ports"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([textFieldString isEqualToString:@""]) {
            lastRowIsEmpty = YES;
        } else {
            lastRowIsEmpty = NO;
        }
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    if (self.tableView.selectedRow != -1) {
        [self.segmentedControl setEnabled:YES forSegment:1];
    }
}

@end
