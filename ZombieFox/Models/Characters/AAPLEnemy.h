//
// AAPLEnemy.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLCharacter.h"

@interface AAPLEnemy : AAPLCharacter
+ (AAPLEnemy *)enemyForNode:(SCNNode *)node;
@end
