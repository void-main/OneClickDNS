//
//  VMTServerNameUtils.m
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import "VMTServerNameUtils.h"

@implementation VMTServerNameUtils

+ (BOOL) usingNameserver {
    NSString *result = [VMTShellWrapper executeCommand:@"/usr/bin/grep" withArgs:@"219.217.227.82", @"/etc/resolv.conf", nil];
    return [result length] != 0;
}

+ (BOOL) hasBackup {
    NSString *result = [VMTShellWrapper executeCommand:@"/bin/cat" withArgs:[@"~/resolv.conf.backup" stringByStandardizingPath], nil];
    return [result rangeOfString:@"No such file"].location == NSNotFound;
}

+ (void) applyNameserver {
    // backup first
    [VMTShellWrapper executeCommand:@"/bin/cp" withArgs:@"/etc/resolv.conf", [@"~/resolv.conf.backup" stringByStandardizingPath], nil];
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"sample_resolv" ofType:@"conf"];
    [VMTShellWrapper sudoCommand:"/bin/cp" withArgs:[templatePath UTF8String], "/etc/resolv.conf", nil];
}

+ (void) restoreNameserver {
    [VMTShellWrapper sudoCommand:"/bin/cp" withArgs:[[@"~/resolv.conf.backup" stringByStandardizingPath] UTF8String], "/etc/resolv.conf", nil];
}

@end
