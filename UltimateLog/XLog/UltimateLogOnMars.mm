//
//  TestClass.m
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

#import "UltimateLogOnMars.h"
#import "appender.h"
#import "xlogger.h"
#import "xloggerbase.h"
#import <sys/xattr.h>

@implementation UltimateLogOnMars

// 封装了初始化 Xlogger 方法
// initialize Xlogger
-(void)initXloggerFilterLevel: (int)level path: (NSString*)path prefix: (const char*)prefix{
    
    
    // set do not backup for logpath
    const char* attrName = "io.jinkey";
    u_int8_t attrValue = 1;
    setxattr([path UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    // init xlog
    xlogger_SetLevel((TLogLevel)level);
    appender_set_console_log(false);
    appender_open(kAppednerAsync, [path UTF8String], prefix, "");
    
}

// 封装了关闭 Xlogger 方法
// deinitialize Xlogger
-(void)deinitXlogger {
    appender_close();
}


// 利用微信提供的 LogUtil.h 封装了打印日志的方法
// print log using LogUtil.h provided by Wechat
-(void) log: (int) level tag: (const char*)tag content: (NSString*)content{
    
    NSString* levelDescription = @"";
    
    switch (level) {
        case 1:
            LOG_DEBUG(tag, content);
            levelDescription = @"Debug";
            break;
        case 2:
            LOG_INFO(tag, content);
            levelDescription = @"Info";
            break;
        case 3:
            LOG_WARNING(tag, content);
            levelDescription = @"Warn";
            break;
        case 4:
            LOG_ERROR(tag, content);
            levelDescription = @"Error";
            break;
        default:
            break;
    }
}

- (void)flush{
    appender_flush_sync();
}

@end


