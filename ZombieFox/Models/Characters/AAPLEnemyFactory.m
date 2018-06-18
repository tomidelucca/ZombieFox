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
    AAPLEnemy* enemy = [[AAPLEnemy alloc] initWithConfiguration:[AAPLEnemyFactory mummyConfigurationWithLife:life]];
    enemy.node.scale = SCNVector3Make(0.75f, 0.75f, 0.75f);
    return enemy;
}

+ (AAPLCharacterConfiguration*)mummyConfigurationWithLife:(CGFloat)life
{
    AAPLCharacterConfiguration* configuration = [AAPLCharacterConfiguration new];
    configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/mummy.dae"];
    configuration.walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"];
    configuration.maxLife = life;
    return configuration;
}

@end
