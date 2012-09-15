//
//  VMTShellWrapper.h
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMTShellWrapper : NSObject {
    AuthorizationRef authRef_;
}

+ (NSString *) executeCommand: (NSString *)cmd withArgs: (NSString *) args, ...NS_REQUIRES_NIL_TERMINATION;

+ (int) sudoCommand: (const char *)cmd withArgs: (const char *) args, ... NS_REQUIRES_NIL_TERMINATION;

/*
+ (NSString *) executeCommand:(NSString *)cmd inSudoMode:(BOOL) sudo withArgs:(NSString *)args, ...;
*/
@end
