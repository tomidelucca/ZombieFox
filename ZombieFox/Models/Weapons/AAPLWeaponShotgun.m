//
// AAPLWeaponShotgun.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeaponShotgun.h"
#import "AAPLWeaponPrivate.h"
#import "AAPLEnemy.h"
#import "AAPLPlayer.h"

@implementation AAPLWeaponShotgun

- (instancetype)init
{
	self = [super initWithDamage:5.0f];
	if (self) {
		self.name = @"Shotgun";
		SCNScene *scene = [SCNScene sceneNamed:@"game.scnassets/shotgun.dae"];
		SCNNode *node = [SCNNode node];
		for (SCNNode *n in scene.rootNode.childNodes) {
			[node addChildNode:n];
		}
		self.node = node;
		self.node.scale = SCNVector3Make(0.05f, 0.05f, 0.05f);
		self.node.eulerAngles = SCNVector3Make(0.0f, M_PI_2, 0.0f);
		self.node.position = SCNVector3Make(-0.08f, 0.25f, 0.14f);
	}
	return self;
}

- (void)pullTheTrigger
{
	if (!self.holder) {
		return;
	}

	NSDictionary *options = @{SCNPhysicsTestSearchModeKey : SCNPhysicsTestSearchModeClosest,
		                      SCNPhysicsTestCollisionBitMaskKey : @(AAPLBitmaskEnemy)};

	SCNVector3 holder = [self.holder positionForWeaponHolder:self];
	CGFloat angle = [self.holder angleForWeaponHolder:self];

	SCNVector3 next = SCNVector3Make(holder.x + 100 * sin(angle), 0.0f, holder.z + 100 * cos(angle));

	NSArray *results = [[AAPLGameStateManager sharedManager].mainScene.physicsWorld rayTestWithSegmentFromPoint:holder
	                                                                                                    toPoint:next
	                                                                                                    options:options];

	for (SCNHitTestResult *result in results) {
		AAPLEnemy *enemy = [AAPLEnemy enemyForNode:result.node];
		[enemy takeLife:self.damage];
	}
}

@end
