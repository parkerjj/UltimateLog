//
//  MarsWapper.h
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MarsWapper : NSObject

-(void)initXloggerFilterLevel: (NSUInteger)level path: (NSString*)path prefix: (const char*)prefix;
- (void)deinitXlogger;

- (void)log: (NSUInteger) level tag: (const char*)tag content: (NSString*)content;
- (void)flush;
@end

