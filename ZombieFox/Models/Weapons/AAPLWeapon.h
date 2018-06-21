//
// AAPLWeapon.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@class AAPLWeapon;

@protocol AAPLWeaponHolder <NSObject>
- (SCNVector3)positionForWeaponHolder:(AAPLWeapon *)weapon;
- (CGFloat)angleForWeaponHolder:(AAPLWeapon *)weapon;
- (SCNNode *)holderNodeForWeapon:(AAPLWeapon *)weapon;
@end

@interface AAPLWeapon : NSObject
@property (strong, nonatomic, readonly) SCNNode *node;
@property (strong, nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) CGFloat damage;
@property (weak, nonatomic) id <AAPLWeaponHolder> holder;

- (instancetype)initWithDamage:(CGFloat)damage;
- (void)pullTheTrigger;
- (void)releaseTheTrigger;
@end
