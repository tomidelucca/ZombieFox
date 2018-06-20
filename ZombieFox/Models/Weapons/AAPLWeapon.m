//
//  AAPLWeapon.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeapon.h"
#import "AAPLWeaponPrivate.h"

@implementation AAPLWeapon

- (instancetype)initWithConfiguration:(AAPLWeaponConfiguration*)configuration
{
    self = [super init];
    if (self) {
        self.scene = configuration.scene;
        self.player = configuration.player;
        self.damage = configuration.damage;
    }
    return self;
}

- (void)pullTheTrigger
{
    
}

@end
