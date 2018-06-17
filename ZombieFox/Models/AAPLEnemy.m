//
// AAPLEnemy.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemy.h"

@implementation AAPLEnemy

- (instancetype)init
{
    self = [super initWithCharacterScene:[SCNScene sceneNamed:@"game.scnassets/mummy.dae"]];
    if (self) {
        [self setupWalkAnimationWithScene:[SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"]];
    }
    return self;
}

@end
