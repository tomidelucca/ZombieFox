//
// AAPLWeapon.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "AAPLWeaponConfiguration.h"

@class AAPLWeapon;

@protocol AAPLWeaponHolder <NSObject>
- (SCNVector3)positionForWeaponHolder:(AAPLWeapon *)weapon;
- (CGFloat)angleForWeaponHolder:(AAPLWeapon *)weapon;
@end

@interface AAPLWeapon : NSObject
@property (strong, nonatomic, readonly) SCNNode *node;
@property (strong, nonatomic, readonly) NSString *name;
@property (weak, nonatomic) id <AAPLWeaponHolder> holder;

- (instancetype)initWithConfiguration:(AAPLWeaponConfiguration *)configuration;
- (void)pullTheTrigger;
@end
