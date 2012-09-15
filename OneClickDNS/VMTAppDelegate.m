//
//  VMTAppDelegate.m
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import "VMTAppDelegate.h"

@implementation VMTAppDelegate

- (void) awakeFromNib {
    // Init status bar item
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Easy DNS"];
    [statusItem setHighlightMode:YES];
    [statusMenu setDelegate:self];
    [statusMenu setAutoenablesItems:NO];
    
    [self updateDNSStatusDisplay];
}

- (IBAction)toggleDNS:(id)sender {
    if ([VMTServerNameUtils usingNameserver]) {
        [VMTServerNameUtils restoreNameserver];
    } else {
        [VMTServerNameUtils applyNameserver];
    }
    
    [self updateDNSStatusDisplay];
}

- (IBAction)exit:(id)sender {
    [NSApp terminate:self];
}

#pragma mark -
#pragma mark MenuBar delegate
- (void) menuWillOpen:(NSMenu *)menu {
    [self updateDNSStatusDisplay];
}

#pragma mark -
#pragma mark Wrapper Methods

- (void) updateDNSStatusDisplay {
    [toggleDNSItem setTitle:[self titleForToggleButton]];
    [toggleDNSItem setEnabled: [self toggleButtonEnabled]];
}

- (NSString *) titleForToggleButton {
    if ([VMTServerNameUtils usingNameserver]) {
        return @"Restore DNS";
    } else {
        return @"Switch to LDS";
    }
}

- (BOOL) toggleButtonEnabled {
    if ([VMTServerNameUtils usingNameserver] && ![VMTServerNameUtils hasBackup]) {
        return NO;
    }
    
    return YES;
}

@end
