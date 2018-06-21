//
// AAPLWeaponFlameThrower.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeaponFlameThrower.h"
#import "AAPLWeaponPrivate.h"
#import "AAPLCollisionMasks.h"

@interface AAPLWeaponFlameThrower ()
@property (weak, nonatomic) SCNNode *ft;
@end

@implementation AAPLWeaponFlameThrower

- (instancetype)init
{
	self = [super initWithDamage:0.7f];
	if (self) {
		self.name = @"Flamethrower";
	}
	return self;
}

- (void)pullTheTrigger
{
	if (!self.holder) {
		return;
	}

	[self releaseTheTrigger];

	SCNNode *holder = [self.holder holderNodeForWeapon:self];

	SCNNode *ft = [SCNNode node];
	ft.name = @"ft";
	ft.position = SCNVector3Make(0.0f, 0.1f, 1.2f);
	ft.eulerAngles = SCNVector3Make(-M_PI_2, 0.0f, 0.0f);

	SCNNode *fireNode = [SCNNode node];
	fireNode.name = @"fireNode";
	fireNode.position = SCNVector3Make(0.0f, 1.2f, 0.0f);

	SCNParticleSystem *fire = [SCNParticleSystem particleSystemNamed:@"flamethrower.scnp" inDirectory:nil];

	[fireNode addParticleSystem:fire];
	[ft addChildNode:fireNode];

	ft.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic
	                                        shape:[SCNPhysicsShape shapeWithGeometry:[SCNCone coneWithTopRadius:0.0f bottomRadius:0.5f height:2.0f] options:nil]];
	ft.physicsBody.categoryBitMask = AAPLBitmaskFire;
	ft.physicsBody.collisionBitMask = AAPLBitmaskEnemy;
	ft.physicsBody.contactTestBitMask = AAPLBitmaskEnemy;

	[holder addChildNode:ft];

	self.ft = ft;
}

- (void)releaseTheTrigger
{
	if (!self.ft) {
		return;
	}

	for (SCNNode *node in self.ft.childNodes) {
		[node removeAllParticleSystems];
		[node removeFromParentNode];
	}

	[self.ft removeAllParticleSystems];
	[self.ft removeFromParentNode];
	self.ft = nil;
}

@end
