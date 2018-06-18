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

@protocol AAPLCharacterDelegate
- (void)player:(AAPLCharacter *)character lifeDidChange:(CGFloat)newLife;
@end

@interface AAPLCharacter : NSObject

@property (nonatomic, readonly) SCNNode *node;
@property (nonatomic, readonly) CGFloat maxLife;
@property (nonatomic, readonly) CGFloat life;
@property (nonatomic, readonly) CGFloat strength;

@property (nonatomic, weak) id <AAPLCharacterDelegate> delegate;

- (instancetype)initWithConfiguration:(AAPLCharacterConfiguration *)configuration;

- (void)walkInDirection:(vector_float3)direction time:(NSTimeInterval)time scene:(SCNScene *)scene;
- (void)rotateByAngle:(CGFloat)angle;

- (void)takeLife:(CGFloat)points;
- (void)giveLife:(CGFloat)points;

- (void)speedMultiplier:(CGFloat)multiplier forInterval:(NSTimeInterval)interval;

- (void)invulnerableForInterval:(NSTimeInterval)interval;

- (void)seek:(AAPLCharacter*)character withTime:(NSTimeInterval)time;
@end
