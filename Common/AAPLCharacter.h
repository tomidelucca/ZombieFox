/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    This class manages the main character, including its animations, sounds and direction.
 */

@import Foundation;

#import <SceneKit/SceneKit.h>

#import "AAPLGameViewController.h"

typedef NS_ENUM (NSUInteger, AAPLGroundType) {
	AAPLGroundTypeGrass,
	AAPLGroundTypeCount
};

@interface AAPLCharacter : NSObject

@property (nonatomic, readonly) SCNNode *node;
@property (nonatomic) CGFloat walkSpeed;

- (instancetype)initWithCharacterScene:(SCNScene *)scene;
- (void)setupWalkAnimationWithScene:(SCNScene *)scene;

- (void)walkInDirection:(vector_float3)direction time:(NSTimeInterval)time scene:(SCNScene *)scene;
- (void)rotateByAngle:(CGFloat)angle;

@end
