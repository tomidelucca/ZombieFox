//
// AAPLEnemyFactory.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemyFactory.h"

@implementation AAPLEnemyFactory

+ (AAPLEnemy *)mummyWithLife:(CGFloat)life andStrength:(CGFloat)strength
{
    AAPLCharacterConfiguration* configuration = [AAPLEnemyFactory mummyConfigurationWithLife];
    configuration.maxLife = life;
    configuration.strength = strength;
	AAPLEnemy *enemy = [[AAPLEnemy alloc] initWithConfiguration:configuration];
	enemy.node.scale = SCNVector3Make(0.65f, 0.65f, 0.65f);
	return enemy;
}

+ (AAPLCharacterConfiguration *)mummyConfigurationWithLife
{
	AAPLCharacterConfiguration *configuration = [AAPLCharacterConfiguration new];
	configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/mummy.dae"];
	configuration.walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"];
    configuration.maxVelocity = 0.6f;
	return configuration;
}

@end
