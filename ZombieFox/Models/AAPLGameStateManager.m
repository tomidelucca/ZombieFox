//
//  AAPLGameStateManager.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/21/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLGameStateManager.h"

@implementation AAPLGameStateManager

+ (id)sharedManager
{
    static AAPLGameStateManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end
