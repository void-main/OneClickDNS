//
//  VMTAppDelegate.h
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Core/VMTServerNameUtils.h"

@interface VMTAppDelegate : NSObject<NSMenuDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    
    IBOutlet NSMenuItem *toggleDNSItem;
}

- (IBAction)toggleDNS:(id)sender;
- (IBAction)exit:(id)sender;

@end
