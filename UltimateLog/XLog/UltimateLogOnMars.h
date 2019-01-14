//
//  TestClass.h
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

#include <stdio.h>
#import <Foundation/Foundation.h>
#import "LogUtil.h"

typedef NS_ENUM(NSUInteger, XloggerType) {
    all = kLevelAll,
    verbose = kLevelVerbose,
    debug = kLevelDebug,
    info = kLevelInfo,
    warning = kLevelWarn,
    error = kLevelError,
    fatal = kLevelFatal,
    none = kLevelNone
    
};

@interface UltimateLogOnMars: NSObject

-(void)initXloggerFilterLevel: (XloggerType)level path: (NSString*)path prefix: (const char*)prefix;
- (void)deinitXlogger;

- (void)log: (XloggerType) level tag: (const char*)tag content: (NSString*)content;
- (void)flush;

@end
