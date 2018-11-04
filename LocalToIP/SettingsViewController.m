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
    // Then setup properties on the cellView based on the column.
    cellView.textField.stringValue = self.tableContents[row];
    return cellView;
}

- (IBAction)segmentedControl:(NSSegmentedControl *)sender {
    if ([sender selectedSegment] == 0) {
        [self addTableRow];
    }

    if ([sender selectedSegment] == 1) {
//        [self removeTableRow];
    }
}

- (void)addTableRow {
    [self.tableContents addObject:@""];
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.tableContents.count - 1] withAnimation:NSTableViewAnimationEffectFade];
    [self.tableView editColumn:0 row:self.tableContents.count - 1 withEvent:nil select:YES];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = [obj object];
    NSString *textFieldString = [textField stringValue];
    [self.tableContents replaceObjectAtIndex:self.tableContents.count - 1 withObject:textFieldString];

    [[NSUserDefaults standardUserDefaults] setObject:self.tableContents forKey:@"ports"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSLog(@"%@", self.tableContents);
    if ([self.tableView selectedRow] == -1) {
        [self.segmentedControl setEnabled:NO forSegment:1];
    } else {
        [self.segmentedControl setEnabled:YES forSegment:1];
    }
}

//
//
//- (void)controlTextDidEndEditing:(NSNotification *)obj {
//    NSTextField *textField = [obj object];
//    [self.ports replaceObjectAtIndex:[self.ports count] - 1 withObject:[textField stringValue]];
//}
//
//- (IBAction)segmentedControlClicked:(NSSegmentedControl *)sender {
////    NSString *lastObjectValue = [NSString stringWithFormat:@"%@", [self.ports lastObject]];
////    long objectCharacterCount = [lastObjectValue length];
//
//    if ([sender selectedSegment] == 0) {
//        [self addTableRow];
//    }
//
//    if ([sender selectedSegment] == 1) {
//        [self removeTableRow];
//    }
//}
//
//- (void)addTableRow {
//    [_tableView setObjectValue:@"gucci"];
////    long nextIndex = [self.ports count];
////
////    [self.ports addObject:@""];
////    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:nextIndex] withAnimation:NSTableViewAnimationEffectFade];
////    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:nextIndex] byExtendingSelection:YES];
////    [self.tableView editColumn:0 row:0 withEvent:nil select:YES];
//}
//
//- (void)removeTableRow {
//    long selectedIndex = [self.tableView selectedRow];
//    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedIndex] withAnimation:NSTableViewAnimationEffectFade];
//    [self.ports removeObjectAtIndex:selectedIndex];
//}
//
//- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSTableCellView *result = [tableView makeViewWithIdentifier:@"Port" owner:self];
//    result.textField.stringValue = [self.ports objectAtIndex:row];
//
//    return result;
//}
//
//

@end
