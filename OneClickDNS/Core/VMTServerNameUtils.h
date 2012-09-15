//
//  VMTServerNameUtils.h
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMTShellWrapper.h"

@interface VMTServerNameUtils : NSObject

+ (BOOL) usingNameserver;
+ (BOOL) hasBackup;

+ (void) applyNameserver;
+ (void) restoreNameserver;

@end
