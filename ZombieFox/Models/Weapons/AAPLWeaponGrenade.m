//
// AAPLWeaponGrenade.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeaponGrenade.h"
#import "AAPLWeaponPrivate.h"

@implementation AAPLWeaponGrenade

- (instancetype)init
{
	self = [super initWithDamage:8.0f];
	if (self) {
		self.name = @"Grenade";
		if (!self.damage) {
			self.damage = 8.0f;
		}
	}
	return self;
}

- (void)pullTheTrigger
{
	if (!self.holder) {
		return;
	}

	SCNScene *scene = [SCNScene sceneNamed:@"game.scnassets/granade.dae"];

	SCNNode *n = [SCNNode node];

	for (SCNNode *node in scene.rootNode.childNodes) {
		[n addChildNode:node];
	}

	SCNVector3 position = [self.holder positionForWeaponHolder:self];
	CGFloat angle = [self.holder angleForWeaponHolder:self];

	n.position = position;
	n.scale = SCNVector3Make(0.5f, 0.5f, 0.5f);
	n.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic
	                                       shape:[SCNPhysicsShape shapeWithGeometry:[SCNSphere sphereWithRadius:0.05f] options:nil]];
	n.physicsBody.mass = 1.0f;
	n.physicsBody.affectedByGravity = YES;
	n.physicsBody.allowsResting = YES;
	n.physicsBody.angularDamping = 1.0f;
	n.physicsBody.friction = 1.0f;
	[n.physicsBody applyForce:SCNVector3Make(1.5f * sin(angle), 5.0f, 1.5 * cos(angle)) impulse:YES];

	[[AAPLGameStateManager sharedManager].mainScene.rootNode addChildNode:n];

	__weak typeof(self)weakSelf = self;
	id wait = [SCNAction waitForDuration:2.5f];
	id run = [SCNAction runBlock: ^(SCNNode *node) {
	    [n removeFromParentNode];
	    SCNVector3 gPos = n.position;
	    NSArray <AAPLEnemy *> *enemies = [[AAPLGameStateManager sharedManager].enemies copy];
	    for (AAPLEnemy *enemy in enemies) {
	        SCNVector3 ePos = enemy.node.position;
	        if ((pow(gPos.x - ePos.x, 2) + pow(gPos.z - ePos.z, 2)) < 1.0f) {
	            [enemy takeLife:weakSelf.damage];
			}
		}
	}];

	[[AAPLGameStateManager sharedManager].mainScene.rootNode runAction:[SCNAction sequence:@[wait, run]]];
}

@end
