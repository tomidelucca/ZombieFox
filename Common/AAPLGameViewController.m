/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This class manages most of the game logic.
*/

@import SpriteKit;
@import QuartzCore;
@import AVFoundation;

#import "AAPLGameViewControllerPrivate.h"

@implementation AAPLGameViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameView.scene = [SCNScene sceneNamed:@"game.scnassets/level.scn"];
    
    self.gameView.playing = YES;
    self.gameView.loops = YES;
    
    self.player = [AAPLPlayer new];
    self.player.node.position = SCNVector3Make(1.0f, 0.0f, 1.0f);
    [self.gameView.scene.rootNode addChildNode:self.player.node];
    
    SCNCamera* camera = [SCNCamera camera];
    SCNNode* cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0.0f, 1.0f, -2.0f);
    cameraNode.rotation = SCNVector4Make(0.0f, 1.0f, 0.0f, M_PI);
    self.gameView.pointOfView = cameraNode;
    [self.player.node addChildNode:cameraNode];
    
    SCNMaterial* groundMaterial = [SCNMaterial new];
    groundMaterial.diffuse.contents = [NSImage imageNamed:@"grass_normal"];
    groundMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0);
    groundMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    groundMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    groundMaterial.specular.contents = [NSImage imageNamed:@"grass_specular"];
    groundMaterial.specular.contentsTransform = SCNMatrix4MakeScale(32, 32, 0);
    groundMaterial.specular.wrapS = SCNWrapModeRepeat;
    groundMaterial.specular.wrapT = SCNWrapModeRepeat;
    
    SCNFloor* floor = [SCNFloor floor];
    floor.reflectivity = 0.0f;
    floor.firstMaterial = groundMaterial;
    
    SCNBox* box = [SCNBox boxWithWidth:1.0f height:1.0f length:1.0f chamferRadius:0.0f];
    box.firstMaterial.diffuse.contents = [NSColor redColor];
    SCNNode* boxNode = [SCNNode nodeWithGeometry:box];
    boxNode.position = SCNVector3Make(0.0f, 0.0f, 0.0f);
    [self.gameView.scene.rootNode addChildNode:boxNode];
    
    self.ground = [SCNNode nodeWithGeometry:floor];
    [self.gameView.scene.rootNode addChildNode:self.ground];
    
    self.enemies = [NSMutableArray new];
    
    self.gameView.scene.physicsWorld.contactDelegate = self;
    self.gameView.delegate = self;

    [self setupGameControllers];
}

#pragma mark - Moving the Character

- (vector_float3)characterDirection {
    vector_float2 controllerDirection = self.controllerDirection;
    vector_float3 direction = {controllerDirection.x, 0.0f, controllerDirection.y};
    
    SCNNode *pov = self.gameView.pointOfView;
    if (pov) {
        SCNVector3 p1 = [self.player.node convertPosition:SCNVector3Make(direction.x, direction.y, direction.z) toNode:nil];
        SCNVector3 p0 = [self.player.node convertPosition:SCNVector3Zero toNode:nil];
        direction = (vector_float3){p1.x - p0.x, 0.0, p1.z - p0.z};
    }
    
    return direction;
}

#pragma mark - SCNSceneRendererDelegate Conformance (Game Loop)

// SceneKit calls this method exactly once per frame, so long as the SCNView object (or other SCNSceneRenderer object) displaying the scene is not paused.
// Implement this method to add game logic to the rendering loop. Any changes you make to the scene graph during this method are immediately reflected in the displayed scene.

- (AAPLGroundType)groundTypeFromMaterial:(SCNMaterial *)material {
    return 0;
}

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    // Reset some states every frame
    _replacementPositionIsValid = NO;
    _maxPenetrationDistance = 0;
    
    SCNScene *scene = self.gameView.scene;
    vector_float3 direction = self.characterDirection;
    
    [self.player walkInDirection:direction
                           time:time
                          scene:scene];
    
    // Adjust the volume of the enemy based on the distance with the character.
    float distanceToClosestEnemy = FLT_MAX;
    /*vector_float3 characterPosition = SCNVector3ToFloat3(self.player.node.position);
    for (SCNNode *enemy in _enemies) {
        //distance to enemy
        SCNMatrix4 enemyTransform = enemy.worldTransform;
        vector_float3 enemyPosition = (vector_float3){enemyTransform.m41, enemyTransform.m42, enemyTransform.m43};
        float distance = vector_distance(characterPosition, enemyPosition);
        distanceToClosestEnemy = MIN(distanceToClosestEnemy, distance);
    }*/
    
    // Adjust sounds volumes based on distance with the enemy.
    if (!_gameIsComplete) {
        AVAudioMixerNode *mixer = (AVAudioMixerNode *)_flameThrowerSound.audioNode;
        mixer.volume = 0.3 * MAX(0, MIN(1, 1 - ((distanceToClosestEnemy - 1.2) / 1.6)));
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didSimulatePhysicsAtTime:(NSTimeInterval)time {
    // If we hit a wall, position needs to be adjusted
    if (_replacementPositionIsValid) {
        self.player.node.position = _replacementPosition;
    }
}
    
#pragma mark - SCNPhysicsContactDelegate Conformance

// To receive contact messages, you set the contactDelegate property of an SCNPhysicsWorld object.
// SceneKit calls your delegate methods when a contact begins, when information about the contact changes, and when the contact ends.

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {
    if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
        [self characterNode:contact.nodeB hitWall:contact.nodeA withContact:contact];
    }
    if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
        [self characterNode:contact.nodeA hitWall:contact.nodeB withContact:contact];
    }
    if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskCollectable) {
        [self collectPearl:contact.nodeA];
    }
    if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollectable) {
        [self collectPearl:contact.nodeB];
    }
    if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskSuperCollectable) {
        [self collectFlower:contact.nodeA];
    }
    if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskSuperCollectable) {
        [self collectFlower:contact.nodeB];
    }
    if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskEnemy) {
        [self.player catchFire];
    }
    if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskEnemy) {
        [self.player catchFire];
    }
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact {
    if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
        [self characterNode:contact.nodeB hitWall:contact.nodeA withContact:contact];
    }
    if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollision) {
        [self characterNode:contact.nodeA hitWall:contact.nodeB withContact:contact];
    }
}

- (void)characterNode:(SCNNode *)characterNode hitWall:(SCNNode *)wall withContact:(SCNPhysicsContact *)contact {
    if (characterNode.parentNode != self.player.node) {
        return;
    }
    
    if (_maxPenetrationDistance > contact.penetrationDistance) {
        return;
    }
    
    _maxPenetrationDistance = contact.penetrationDistance;
    
    vector_float3 characterPosition = SCNVector3ToFloat3(self.player.node.position);
    vector_float3 positionOffset = SCNVector3ToFloat3(contact.contactNormal) * contact.penetrationDistance;
    positionOffset.y = 0;
    characterPosition += positionOffset;
    
    _replacementPosition = SCNVector3FromFloat3(characterPosition);
    _replacementPositionIsValid = YES;
}

#pragma mark - Scene Setup

- (void)setupSounds {
    // Get an arbitrary node to attach the sounds to.
    SCNNode *node = self.gameView.scene.rootNode;
    
    SCNAudioSource *musicSource = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/music.m4a"];
    musicSource.loops = YES;
    musicSource.volume = 0.25;
    musicSource.positional = NO;
    musicSource.shouldStream = YES;
    [node addAudioPlayer:[SCNAudioPlayer audioPlayerWithSource:musicSource]];
    
    SCNAudioSource *windSource = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/wind.m4a"];
    windSource.loops = YES;
    windSource.volume = 0.3;
    windSource.positional = NO;
    windSource.shouldStream = YES;
    [node addAudioPlayer:[SCNAudioPlayer audioPlayerWithSource:windSource]];
    
    SCNAudioSource *flameThrowerSource = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/flamethrower.mp3"];
    flameThrowerSource.loops = YES;
    flameThrowerSource.volume = 0;
    flameThrowerSource.positional = NO;
    _flameThrowerSound = [SCNAudioPlayer audioPlayerWithSource:flameThrowerSource];
    [node addAudioPlayer:_flameThrowerSound];
    
    _collectPearlSound = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/collect1.mp3"];
    _collectPearlSound.volume = 0.5;
    [_collectPearlSound load];
    
    _collectFlowerSound = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/collect2.mp3"];
    [_collectFlowerSound load];
    
    _victoryMusic = [SCNAudioSource audioSourceNamed:@"game.scnassets/sounds/Music_victory.mp3"];
    _victoryMusic.volume = 0.5;
}

#pragma mark - Collecting Items

- (void)removeNode:(SCNNode *)node soundToPlay:(SCNAudioSource *)sound {
    SCNNode *parentNode = node.parentNode;
    if (parentNode) {
        SCNNode *soundEmitter = [SCNNode node];
        soundEmitter.position = node.position;
        [parentNode addChildNode:soundEmitter];
        
        [soundEmitter runAction:[SCNAction sequence:@[[SCNAction playAudioSource:sound waitForCompletion:YES],
                                                      [SCNAction removeFromParentNode]]]];
        
        [node removeFromParentNode];
    }
}

- (void)collectPearl:(SCNNode *)pearlNode {
    if (pearlNode.parentNode != nil) {
        [self removeNode:pearlNode soundToPlay:_collectPearlSound];
        self.gameView.collectedPearlsCount = ++_collectedPearlsCount;
    }
}

- (NSUInteger)collectedFlowersCount {
    return _collectedFlowersCount;
}

- (void)setCollectedFlowersCount:(NSUInteger)collectedFlowersCount {
    _collectedFlowersCount = collectedFlowersCount;
    
    self.gameView.collectedFlowersCount = _collectedFlowersCount;
    if (_collectedFlowersCount == 3) {
        [self showEndScreen];
    }
}

- (void)collectFlower:(SCNNode *)flowerNode {
    if (flowerNode.parentNode != nil) {
        // Emit particles.
        SCNMatrix4 particleSystemPosition = flowerNode.worldTransform;
        particleSystemPosition.m42 += 0.1;
        [self.gameView.scene addParticleSystem:_collectFlowerParticleSystem withTransform:particleSystemPosition];
        
        // Remove the flower from the scene.
        [self removeNode:flowerNode soundToPlay:_collectFlowerSound];
        self.collectedFlowersCount++;
    }
}

#pragma mark - Congratulating the Player

- (void)showEndScreen {
    _gameIsComplete = YES;
    
    // Add confettis
    SCNMatrix4 particleSystemPosition = SCNMatrix4MakeTranslation(0.0, 8.0, 0.0);
    [self.gameView.scene addParticleSystem:_confettiParticleSystem withTransform:particleSystemPosition];
    
    // Stop the music.
    [self.gameView.scene.rootNode removeAllAudioPlayers];
    
    // Play the congrat sound.
    [self.gameView.scene.rootNode addAudioPlayer:[SCNAudioPlayer audioPlayerWithSource:_victoryMusic]];
    
    [self.gameView showEndScreen];
}

#pragma mark - Game view

- (AAPLGameView *)gameView {
    return (AAPLGameView *)self.view;
}

@end
