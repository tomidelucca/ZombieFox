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

	SCNNode *grenade = [SCNNode node];

	for (SCNNode *node in scene.rootNode.childNodes) {
		[grenade addChildNode:node];
	}

	SCNVector3 position = [self.holder positionForWeaponHolder:self];
	CGFloat angle = [self.holder angleForWeaponHolder:self];

	grenade.position = position;
	grenade.scale = SCNVector3Make(0.5f, 0.5f, 0.5f);
	grenade.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic
	                                             shape:[SCNPhysicsShape shapeWithGeometry:[SCNSphere sphereWithRadius:0.05f] options:nil]];
	grenade.physicsBody.mass = 1.0f;
	grenade.physicsBody.affectedByGravity = YES;
	grenade.physicsBody.allowsResting = YES;
	grenade.physicsBody.angularDamping = 1.0f;
	grenade.physicsBody.friction = 1.0f;
	[grenade.physicsBody applyForce:SCNVector3Make(1.5f * sin(angle), 5.0f, 1.5 * cos(angle)) impulse:YES];

	[[AAPLGameStateManager sharedManager].mainScene.rootNode addChildNode:grenade];

	SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
	SCNNode *explosion = [SCNNode node];

	__weak typeof(self)weakSelf = self;
	id explosionWait = [SCNAction waitForDuration:2.5f];
	id inflictDamage = [SCNAction runBlock: ^(SCNNode *node) {
	    SCNVector3 gPos = grenade.position;
	    [grenade removeFromParentNode];
	    NSArray <AAPLEnemy *> *enemies = [[AAPLGameStateManager sharedManager].enemies copy];
	    for (AAPLEnemy *enemy in enemies) {
	        SCNVector3 ePos = enemy.node.position;
	        if ((pow(gPos.x - ePos.x, 2) + pow(gPos.z - ePos.z, 2)) < 1.0f) {
	            [enemy takeLife:weakSelf.damage];
			}
		}
	}];
	id showParticles = [SCNAction runBlock: ^(SCNNode *node) {
	    explosion.position = grenade.presentationNode.position;
	    [explosion addParticleSystem:particleSystem];
	    [[AAPLGameStateManager sharedManager].mainScene.rootNode addChildNode:explosion];
	}];
	id waitForParticles = [SCNAction waitForDuration:1.0f];
	id removeParticles = [SCNAction runBlock: ^(SCNNode *node) {
	    [explosion removeAllParticleSystems];
	    [explosion removeFromParentNode];
	}];

	SCNAction *explodeGrenade = [SCNAction sequence:@[explosionWait, inflictDamage, showParticles, waitForParticles, removeParticles]];

	[[AAPLGameStateManager sharedManager].mainScene.rootNode runAction:explodeGrenade];
}

@end
