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
@property (strong, nonatomic) AAPLPlayer *player;
@property (strong, nonatomic) NSMutableArray <AAPLEnemy *> *enemies;
@property (strong, nonatomic) NSMutableArray <AAPLItem *> *items;
@property (nonatomic) vector_float2 controllerDirection;
@property (nonatomic) BOOL holdingTrigger;
@property (nonatomic) CGFloat maxPenetrationDistance;
@property (nonatomic) SCNVector3 replacementPosition;
@property (nonatomic) BOOL replacementPositionIsValid;
@end

@interface AAPLGameViewController (GameControls) <AAPLKeyboardAndMouseEventsDelegate>
- (void)setupGameControllers;
@property (nonatomic, readonly) vector_float2 controllerDirection;
@end
