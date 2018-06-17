//
// AAPLEnemy.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemy.h"

@implementation AAPLEnemy

- (instancetype)init
{
    self = [super initWithConfiguration:[AAPLEnemy mummyConfiguration]];
    if (self) {
        [self setupCollisions];
    }
    return self;
}

#pragma mark - Configuration

+ (AAPLCharacterConfiguration*)mummyConfiguration
{
    AAPLCharacterConfiguration* configuration = [AAPLCharacterConfiguration new];
    configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/mummy.dae"];
    configuration.walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/mummy_walk.dae"];
    configuration.maxLife = 30.0f;
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
    collisionNode.position = SCNVector3Make(0.0, collisionCapsuleHeight * 0.5, 0.0);
    collisionNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic
                                                                shape:[SCNPhysicsShape shapeWithGeometry:
                                                                       [SCNCapsule capsuleWithCapRadius:collisionCapsuleRadius
                                                                                                 height:collisionCapsuleHeight]
                                                                                                 options:nil]];
    [self.node addChildNode:collisionNode];
    
    collisionNode.categoryBitMask = AAPLBitmaskEnemy;
    collisionNode.physicsBody.collisionBitMask = AAPLBitmaskPlayer;
}

@end

