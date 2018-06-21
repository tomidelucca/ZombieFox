//
// AAPLEnemyFactory.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemyFactory.h"
#import "SCNScene+LoadAnimation.h"

@implementation AAPLEnemyFactory

+ (AAPLEnemy *)mummyWithLife:(CGFloat)life andStrength:(CGFloat)strength andSpeed:(CGFloat)speed
{
	AAPLCharacterConfiguration *configuration = [AAPLEnemyFactory mummyConfigurationWithLife];
	configuration.maxLife = life;
	configuration.strength = strength;
	configuration.maxVelocity = speed;

	AAPLEnemy *enemy = [[AAPLEnemy alloc] initWithConfiguration:configuration];
	enemy.node.scale = SCNVector3Make(0.65f, 0.65f, 0.65f);

	SCNScene *walkAnimation = [SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"];
	[walkAnimation loadAnimationsToNode:enemy.node withSpeed:configuration.maxVelocity * 5];

	return enemy;
}

+ (AAPLCharacterConfiguration *)mummyConfigurationWithLife
{
	AAPLCharacterConfiguration *configuration = [AAPLCharacterConfiguration new];
	configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/mummy.dae"];
	return configuration;
}

@end
