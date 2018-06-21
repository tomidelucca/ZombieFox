//
// AAPLWeaponConfiguration.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "AAPLGameState.h"

static NSString *const AAPLWeaponTypeShotgun = @"shotgun";
static NSString *const AAPLWeaponTypeGrenade = @"grenade";
static NSString *const AAPLWeaponTypeFlameThrower = @"flamethrower";

@class AAPLPlayer;

@interface AAPLWeaponConfiguration : NSObject
@property (strong, nonatomic) AAPLGameState* gameState;
@property (weak, nonatomic) SCNScene *scene;
@property (nonatomic) CGFloat damage;
@property (strong, nonatomic) NSString *type;
@end
