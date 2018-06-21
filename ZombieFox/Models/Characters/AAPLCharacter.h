/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    This class manages the main character, including its animations, sounds and direction.
 */

@import Foundation;

#import <SceneKit/SceneKit.h>

#import "AAPLCharacterConfiguration.h"
#import "AAPLCollisionMasks.h"

@class AAPLCharacter;

@protocol AAPLCharacterDelegate <NSObject>
- (void)character:(AAPLCharacter *)character lifeDidChange:(CGFloat)newLife;
- (void)character:(AAPLCharacter *)character invulnerabilityDidChange:(BOOL)invulnerable;
@end

@interface AAPLCharacter : NSObject
@property (nonatomic, weak) id <AAPLCharacterDelegate> delegate;
@property (nonatomic, readonly) SCNNode *node;
@property (nonatomic, readonly) CGFloat maxLife;
@property (nonatomic, readonly) CGFloat life;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic) CGFloat pace;
@property (nonatomic) BOOL isWalking;
@property (nonatomic) CGFloat maxPenetrationDistance;
@property (nonatomic) SCNVector3 replacementPosition;
@property (nonatomic) BOOL replacementPositionIsValid;

- (instancetype)initWithConfiguration:(AAPLCharacterConfiguration *)configuration;
+ (AAPLCharacter *)characterForNode:(SCNNode *)node;

- (void)walkInDirection:(vector_float3)direction time:(NSTimeInterval)time scene:(SCNScene *)scene;
- (void)rotateByAngle:(CGFloat)angle;

- (void)takeLife:(CGFloat)points;
- (void)giveLife:(CGFloat)points;

- (void)speedMultiplier:(CGFloat)multiplier forInterval:(NSTimeInterval)interval;

- (void)invulnerableForInterval:(NSTimeInterval)interval;

- (void)seek:(AAPLCharacter *)character withTime:(NSTimeInterval)time;

- (void)hurtCharacter:(AAPLCharacter *)character;
@end
