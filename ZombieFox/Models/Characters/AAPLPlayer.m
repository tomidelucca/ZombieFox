//
// AAPLPlayer.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLPlayer.h"
#import "AAPLNodeManager.h"

@implementation AAPLPlayer

- (instancetype)init
{
	self = [super initWithConfiguration:[AAPLPlayer playerConfiguration]];
	if (self) {
		[self setupCollisions];
	}
	return self;
}

#pragma mark - Configuration

+ (AAPLCharacterConfiguration*)playerConfiguration
{
    AAPLCharacterConfiguration* configuration = [AAPLCharacterConfiguration new];
    configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/panda.scn"];
    configuration.walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/walk.scn"];
    configuration.maxLife = 80.0f;
    return configuration;
}

- (void)setupCollisions
{
	SCNVector3 min, max;
	[self.node getBoundingBoxMin:&min max:&max];
	CGFloat collisionCapsuleRadius = (max.x - min.x) * 0.4;
	CGFloat collisionCapsuleHeight = (max.y - min.y);

	SCNNode *collisionNode = [SCNNode node];
	collisionNode.name = @"collider";
	collisionNode.position = SCNVector3Make(0.0, collisionCapsuleHeight * 0.50, 0.0);
    collisionNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic
                                                       shape:[SCNPhysicsShape shapeWithGeometry:
                                                              [SCNCapsule capsuleWithCapRadius:collisionCapsuleRadius
                                                                                        height:collisionCapsuleHeight]
                                                                                        options:nil]];
    collisionNode.physicsBody.categoryBitMask = AAPLBitmaskPlayer;
    collisionNode.physicsBody.collisionBitMask = AAPLBitmaskCollectable;
    collisionNode.physicsBody.contactTestBitMask = AAPLBitmaskCollectable;
    
	[self.node addChildNode:collisionNode];
    
    [[AAPLNodeManager sharedManager] associateNode:collisionNode withModel:self];
    [[AAPLNodeManager sharedManager] associateNode:self.node withModel:self];
}

+ (AAPLPlayer*)playerForNode:(SCNNode*)node
{
    NSObject* model = [[AAPLNodeManager sharedManager] modelForAssociatedNode:node];
    
    if ([model isKindOfClass:[AAPLPlayer class]]) {
        return (AAPLPlayer*)model;
    }
    
    return nil;
}

@end
