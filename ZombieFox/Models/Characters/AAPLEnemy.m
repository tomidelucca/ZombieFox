//
// AAPLEnemy.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemy.h"
#import "AAPLNodeManager.h"

@implementation AAPLEnemy

- (instancetype)initWithConfiguration:(AAPLCharacterConfiguration *)configuration
{
	self = [super initWithConfiguration:configuration];
	if (self) {
		[self setupCollisions];
	}
	return self;
}

- (void)setupCollisions
{
	SCNVector3 min, max;
	[self.node getBoundingBoxMin:&min max:&max];
	CGFloat collisionCapsuleRadius = (max.x - min.x) * 0.4;
	CGFloat collisionCapsuleHeight = (max.y - min.y);

	SCNNode *collisionNode = [SCNNode node];
	collisionNode.name = @"enemy_collider";
	collisionNode.position = SCNVector3Make(0.0, collisionCapsuleHeight * 0.5, 0.0);
	collisionNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic
	                                                   shape:[SCNPhysicsShape shapeWithGeometry:
	                                                          [SCNCapsule capsuleWithCapRadius:collisionCapsuleRadius
	                                                                                    height:collisionCapsuleHeight]
	                                                                                    options:nil]];
	[self.node addChildNode:collisionNode];

	collisionNode.physicsBody.categoryBitMask = AAPLBitmaskEnemy;

	collisionNode.physicsBody.mass = 1.0f;
	collisionNode.physicsBody.restitution = 0.2f;

	[[AAPLNodeManager sharedManager] associateNode:collisionNode withModel:self];
	[[AAPLNodeManager sharedManager] associateNode:self.node withModel:self];
}

- (void)hurtCharacter:(AAPLCharacter *)character
{
	[character takeLife:self.strength];
}

+ (AAPLEnemy *)enemyForNode:(SCNNode *)node
{
	NSObject *model = [[AAPLNodeManager sharedManager] modelForAssociatedNode:node];

	if ([model isKindOfClass:[AAPLEnemy class]]) {
		return (AAPLEnemy *)model;
	}

	return nil;
}

@end
