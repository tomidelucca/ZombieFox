//
//  AAPLEnemyFactory.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/17/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemyFactory.h"

@implementation AAPLEnemyFactory

+ (AAPLEnemy*)mummyWithLife:(CGFloat)life andStrength:(CGFloat)strength
{
    AAPLEnemy* enemy = [[AAPLEnemy alloc] initWithConfiguration:[AAPLEnemyFactory mummyConfiguration]];
    return enemy;
}

+ (AAPLCharacterConfiguration*)mummyConfiguration
{
    AAPLCharacterConfiguration* configuration = [AAPLCharacterConfiguration new];
    configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/mummy.dae"];
    configuration.walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"];
    configuration.maxLife = 30.0f;
    return configuration;
}

@end
