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

@interface AAPLGameViewController() {
    
    // Game states
    BOOL _gameIsComplete;
    
    // Sounds
    SCNAudioSource *_collectPearlSound;
    SCNAudioSource *_collectFlowerSound;
    SCNAudioPlayer *_flameThrowerSound;
    SCNAudioSource *_victoryMusic;
    
    // Particles
    SCNParticleSystem *_confettiParticleSystem;
    SCNParticleSystem *_collectFlowerParticleSystem;
    
    NSUInteger _collectedPearlsCount;
    NSUInteger _collectedFlowersCount;
    
    // Collisions
    CGFloat _maxPenetrationDistance;
    SCNVector3 _replacementPosition;
    BOOL _replacementPositionIsValid;
    
    // For automatic camera animation
    SCNNode *_currentGround;
    SCNNode *_mainGround;
    NSMapTable<SCNNode *, NSValue *> *_groundToCameraPosition;
    
    // Game controls
    GCControllerDirectionPad *_controllerDPad;
    vector_float2 _controllerDirection;
    NSUInteger _holdingTrigger;
    CGPoint _lastMousePosition;
}

@property (strong, nonatomic) SCNNode* ground;
@property (strong, nonatomic) AAPLPlayer* player;
@property (strong, nonatomic) NSMutableArray<AAPLEnemy*>* enemies;

@end

@interface AAPLGameViewController (GameControls) <AAPLKeyboardAndMouseEventsDelegate>

- (void)setupGameControllers;
@property(nonatomic, readonly) vector_float2 controllerDirection;

@end
