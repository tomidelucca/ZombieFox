/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

 */

@import simd;
@import SceneKit;
@import GameController;

#import "AAPLGameViewController.h"
#import "AAPLPlayer.h"
#import "AAPLEnemy.h"
#import "AAPLItem.h"

@interface AAPLGameViewController ()
@property (strong, nonatomic) SCNNode *ground;
@property (nonatomic) vector_float2 controllerDirection;
@property (nonatomic) BOOL holdingTrigger;
@property (nonatomic) BOOL playing;

- (void)setupGame;
@end

@interface AAPLGameViewController (GameControls) <AAPLKeyboardAndMouseEventsDelegate>
- (void)setupGameControllers;
@property (nonatomic, readonly) vector_float2 controllerDirection;
@end
