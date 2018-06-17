//
//  AAPLItemFactory.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/17/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLItemFactory.h"

@implementation AAPLItemFactory

+ (AAPLItem*)healthItemWithLife:(CGFloat)life
{
    AAPLItem* item = [[AAPLItem alloc] initWithAction:^(AAPLPlayer* player) {
        [player giveLife:life];
    }];
    
    [item setItemColor:[NSColor greenColor]];
    
    return item;
}

+ (AAPLItem*)speedItemWithSpeed:(CGFloat)speed forInterval:(NSTimeInterval)interval
{
    AAPLItem* item = [[AAPLItem alloc] initWithAction:^(AAPLPlayer* player) {
        [player speedMultiplier:speed forInterval:interval];
    }];
    
    [item setItemColor:[NSColor redColor]];
    
    return item;
}

+ (AAPLItem*)shieldForInterval:(CGFloat)interval
{
    AAPLItem* item = [[AAPLItem alloc] initWithAction:^(AAPLPlayer* player) {
        [player invulnerableForInterval:interval];
    }];
    
    [item setItemColor:[NSColor cyanColor]];
    
    return item;
}

+ (AAPLItem*)damageForCharacter:(CGFloat)damage
{
    AAPLItem* item = [[AAPLItem alloc] initWithAction:^(AAPLPlayer* player) {
        [player takeLife:damage];
    }];
    
    [item setItemColor:[NSColor purpleColor]];
    
    return item;
}

@end
