//
// AAPLPlayer.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLPlayer.h"

@implementation AAPLPlayer

- (instancetype)init
{
	self = [super initWithCharacterScene:[SCNScene sceneNamed:@"game.scnassets/panda.scn"]];
	if (self) {
		[self setupWalkAnimationWithScene:[SCNScene sceneNamed:@"game.scnassets/walk.scn"]];
		[self configureCollisions];
	}
	return self;
}

#pragma mark - Configuration

- (void)configureCollisions
{
	SCNVector3 min, max;
	[self.node getBoundingBoxMin:&min max:&max];
	CGFloat collisionCapsuleRadius = (max.x - min.x) * 0.4;
	CGFloat collisionCapsuleHeight = (max.y - min.y);

	SCNNode *characterCollisionNode = [SCNNode node];
	characterCollisionNode.name = @"collider";
	characterCollisionNode.position = SCNVector3Make(0.0, collisionCapsuleHeight * 0.51, 0.0);// a bit too high to not hit the floor
	characterCollisionNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic shape:[SCNPhysicsShape shapeWithGeometry:[SCNCapsule capsuleWithCapRadius:collisionCapsuleRadius height:collisionCapsuleHeight] options:nil]];
	characterCollisionNode.physicsBody.contactTestBitMask = AAPLBitmaskSuperCollectable | AAPLBitmaskCollectable | AAPLBitmaskCollision | AAPLBitmaskEnemy;
	[self.node addChildNode:characterCollisionNode];
}

#pragma mark - SCNPhysicsContactDelegate Conformance

// To receive contact messages, you set the contactDelegate property of an SCNPhysicsWorld object.
// SceneKit calls your delegate methods when a contact begins, when information about the contact changes, and when the contact ends.

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact
{
	if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
		[self characterNode:contact.nodeB hitWall:contact.nodeA withContact:contact];
	}
	if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
		[self characterNode:contact.nodeA hitWall:contact.nodeB withContact:contact];
	}
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact
{
	if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
		[self characterNode:contact.nodeB hitWall:contact.nodeA withContact:contact];
	}
	if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
		[self characterNode:contact.nodeA hitWall:contact.nodeB withContact:contact];
	}
}

- (void)characterNode:(SCNNode *)characterNode hitWall:(SCNNode *)wall withContact:(SCNPhysicsContact *)contact
{
	/*if (characterNode.parentNode != self.player.node) {
	    return;
	   }

	   if (_maxPenetrationDistance > contact.penetrationDistance) {
	    return;
	   }

	   _maxPenetrationDistance = contact.penetrationDistance;

	   vector_float3 characterPosition = SCNVector3ToFloat3(self.player.node.position);
	   vector_float3 positionOffset = SCNVector3ToFloat3(contact.contactNormal) * contact.penetrationDistance;
	   positionOffset.y = 0;
	   characterPosition += positionOffset;

	   _replacementPosition = SCNVector3FromFloat3(characterPosition);
	   _replacementPositionIsValid = YES;
	 */
}

@end
