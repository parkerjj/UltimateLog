//
//  ViewController.m
//  LoggerDemo
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

#import "ViewController.h"
@import UltimateLog;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [UltimateLog setupWithPrefix:@"TestApp" filterLevel:FilterLevelVerbose encryptSeed:nil];
    
    ULog.v(@"TAG", @"This is Message of VERBOSE");
    ULog.d(@"TAG", @"This is Message of DEBUG");
    ULog.i(@"TAG", @"This is Message of INFO");
    ULog.w(@"TAG", @"This is Message of WARNING");
    ULog.e(@"TAG", @"This is Message of ERROR");
    
    ULog.v(@"TAG", @"Congratulation! You stepped on edge of the crash.");
    [NSArray arrayWithArray:(NSArray*)[NSNumber numberWithBool:YES]];
    
}


@end
