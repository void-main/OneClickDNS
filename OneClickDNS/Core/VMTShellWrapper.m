//
//  VMTShellWrapper.m
//  OneClickDNS
//
//  Created by Sun Peng on 9/15/12.
//  Copyright (c) 2012 Void Main. All rights reserved.
//

#import "VMTShellWrapper.h"

@implementation VMTShellWrapper

+ (NSString *) executeCommand: (NSString *)cmd withArgs: (NSString *) cmdArgs, ... {
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:cmd];
    
    // parsing variable arguments
    NSMutableArray *resultArgs = [NSMutableArray arrayWithCapacity:100];
    va_list argumentList;
    if (cmdArgs)
    {
        va_start(argumentList, cmdArgs);
        for (NSString *aCmdArg = cmdArgs; aCmdArg != nil; aCmdArg = va_arg(argumentList, NSString*))
        {
            [resultArgs addObject:aCmdArg];
        }
        va_end(argumentList);
    }
    
    [task setArguments:resultArgs];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task setStandardError:pipe];
    [task setStandardInput:[NSPipe pipe]];
    
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    
    [task waitUntilExit];
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

+ (int) sudoCommand: (const char *)cmd withArgs: (const char *) cmdArgs, ... {
    OSStatus myStatus;
    AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
    AuthorizationRef myAuthorizationRef;
    
    myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
    if (myStatus != errAuthorizationSuccess) {
        return myStatus;
    }

    {
        AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights myRights = {1, &myItems};
        
        myFlags = kAuthorizationFlagDefaults |kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |
            kAuthorizationFlagExtendRights;
        myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
    }
    
    if (myStatus == errAuthorizationSuccess)                          
    {
        const char *myArguments[100];
        va_list argumentList;
        int argCount = 0;
        if (cmdArgs)
        {
            va_start(argumentList, cmdArgs);
            for (const char *aCmdArg = cmdArgs; aCmdArg != NULL; aCmdArg = va_arg(argumentList, const char *))
            {
                myArguments[argCount] = aCmdArg;
                argCount += 1;
            }
            va_end(argumentList);
            
            myArguments[argCount] = NULL;
        }
        
        FILE *myCommunicationsPipe = NULL;
        myFlags = kAuthorizationFlagDefaults;
        myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, cmd, myFlags, myArguments, &myCommunicationsPipe);
    }

    AuthorizationFree (myAuthorizationRef, kAuthorizationFlagDefaults);
    return myStatus;
}

/*
+ (NSString *) executeCommand:(NSString *)cmd inSudoMode:(BOOL) sudo withArgs:(NSString *)cmdArgs, ... {
    if (!sudo) {
        return [VMTShellWrapper executeCommand:cmd withArgs:cmdArgs, nil];
    } else {
        return [NSString stringWithFormat:@"%d", [VMTShellWrapper sudoCommand:cmd withArgs:cmdArgs, nil]];
    }
}
*/
@end
