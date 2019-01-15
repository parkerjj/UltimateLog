//
//  MarsWapper.m
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

#import "MarsWapper.h"
#import "UltimateLogOnMars.h"

@interface MarsWapper (){
    UltimateLogOnMars *_mars;
}

@end

@implementation MarsWapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mars = [[UltimateLogOnMars alloc] init];
    }
    return self;
}

-(void)initXloggerFilterLevel: (int)level path: (NSString*)path prefix: (const char*)prefix{
    [_mars initXloggerFilterLevel:level path:path prefix:prefix];
}
- (void)deinitXlogger{
    [_mars deinitXlogger];
}

- (void)log: (int) level tag: (const char*)tag content: (NSString*)content{
    [_mars log:level tag:tag content:content];
}

- (void)flush{
    [_mars flush];
}

@end
