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

- (instancetype)initWithConfiguration:(AAPLWeaponConfiguration *)configuration
{
	self = [super initWithConfiguration:configuration];
	if (self) {
		self.name = @"Shotgun";
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

	NSArray *results = [self.scene.physicsWorld rayTestWithSegmentFromPoint:holder
	                                                                toPoint:next
	                                                                options:options];

	for (SCNHitTestResult *result in results) {
		AAPLEnemy *enemy = [AAPLEnemy enemyForNode:result.node];
		[enemy takeLife:self.damage];
	}
}

@end
