//
//  AAPLWeaponShotgun.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
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
        self.name = @"WaterGun";
    }
    return self;
}

- (void)pullTheTrigger
{
    NSDictionary *options = @{ SCNPhysicsTestSearchModeKey : SCNPhysicsTestSearchModeClosest,
                               SCNPhysicsTestCollisionBitMaskKey : @(AAPLBitmaskEnemy) };
    
    SCNVector3 next = SCNVector3Make(self.player.node.position.x + 100 * sin(self.player.node.eulerAngles.y), 0.0f, self.player.node.position.z + 100 * cos(self.player.node.eulerAngles.y));
    
    NSArray *results = [self.scene.physicsWorld rayTestWithSegmentFromPoint:self.player.node.position
                                                                             toPoint:next
                                                                             options:options];
    
    for (SCNHitTestResult* result in results) {
        AAPLEnemy* enemy = [AAPLEnemy enemyForNode:result.node];
        [enemy takeLife:self.damage];
    }
}

/*
 - (void)shoot
 {
 NSDictionary *options = @{ SCNPhysicsTestSearchModeKey : SCNPhysicsTestSearchModeClosest,
 SCNPhysicsTestCollisionBitMaskKey : @(AAPLBitmaskEnemy) };
 
 SCNVector3 next = SCNVector3Make(self.player.node.position.x + 100 * sin(self.player.node.eulerAngles.y), 0.0f, self.player.node.position.z + 100 * cos(self.player.node.eulerAngles.y));
 
 NSArray *results = [self.gameView.scene.physicsWorld rayTestWithSegmentFromPoint:self.player.node.position
 toPoint:next
 options:options];
 
 for (SCNHitTestResult* result in results) {
 AAPLEnemy* enemy = [AAPLEnemy enemyForNode:result.node];
 [self.player hurtCharacter:enemy];
 }
 
 }
 */

@end
