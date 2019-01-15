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


@interface UltimateLogOnMars: NSObject

-(void)initXloggerFilterLevel: (int)level path: (NSString*)path prefix: (const char*)prefix;
- (void)deinitXlogger;

- (void)log: (int) level tag: (const char*)tag content: (NSString*)content;
- (void)flush;

@end
