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
#import "AAPLItemFactory.h"
#import "AAPLEnemyFactory.h"

@interface AAPLGameViewController () <AAPLCharacterDelegate>
@property (strong, nonatomic) AAPLItem *item;
@end

@implementation AAPLGameViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupScene];
}

#pragma mark - Setup Scene

- (void)setupScene
{
	self.gameView.scene = [SCNScene sceneNamed:@"game.scnassets/level.scn"];
	self.gameView.playing = YES;
	self.gameView.loops = YES;

	[self setupGame];
	[self setupCamera];
	[self setupGround];
	[self setupGameControllers];
	[self setupDelegates];
}

- (void)setupDelegates
{
	self.gameView.scene.physicsWorld.contactDelegate = self;
	self.gameView.delegate = self;
}

- (void)setupGame
{
	self.maxPenetrationDistance = 0.0f;

	self.player = [AAPLPlayer new];
	self.player.node.position = SCNVector3Make(1.0f, 0.0f, 1.0f);
	self.player.delegate = self;
	[self.gameView.scene.rootNode addChildNode:self.player.node];

	self.enemies = [NSMutableArray new];
	self.items = [NSMutableArray new];

	AAPLItem *item = [AAPLItemFactory damageForCharacter:30.0f];
	item.node.position = SCNVector3Make(0.0f, 0.0f, 0.0f);
	[self.gameView.scene.rootNode addChildNode:item.node];
	[self.items addObject:item];

	AAPLEnemy *enemy = [AAPLEnemyFactory mummyWithLife:30.0f andStrength:10.0f];
	enemy.node.position = SCNVector3Make(0.0f, 0.0f, 1.0f);
	[self.gameView.scene.rootNode addChildNode:enemy.node];
	[self.enemies addObject:enemy];
}

- (void)setupCamera
{
	SCNCamera *camera = [SCNCamera camera];
	SCNNode *cameraNode = [SCNNode new];
	cameraNode.camera = camera;
	cameraNode.position = SCNVector3Make(0.0f, 1.0f, -2.0f);
	cameraNode.rotation = SCNVector4Make(0.0f, 1.0f, 0.0f, M_PI);
	self.gameView.pointOfView = cameraNode;
	[self.player.node addChildNode:cameraNode];
}

- (void)setupGround
{
	SCNMaterial *groundMaterial = [SCNMaterial new];
	groundMaterial.diffuse.contents = [NSImage imageNamed:@"grass_normal"];
	groundMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0);
	groundMaterial.diffuse.wrapS = SCNWrapModeRepeat;
	groundMaterial.diffuse.wrapT = SCNWrapModeRepeat;
	groundMaterial.specular.contents = [NSImage imageNamed:@"grass_specular"];
	groundMaterial.specular.contentsTransform = SCNMatrix4MakeScale(32, 32, 0);
	groundMaterial.specular.wrapS = SCNWrapModeRepeat;
	groundMaterial.specular.wrapT = SCNWrapModeRepeat;

	SCNFloor *floor = [SCNFloor floor];
	floor.reflectivity = 0.0f;
	floor.firstMaterial = groundMaterial;

	self.ground = [SCNNode nodeWithGeometry:floor];
	[self.gameView.scene.rootNode addChildNode:self.ground];
}

#pragma mark - SCNSceneRendererDelegate Conformance (Game Loop)

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
	self.replacementPositionIsValid = NO;
	self.maxPenetrationDistance = 0;

	SCNScene *scene = self.gameView.scene;

	[self.player walkInDirection:[self playerDirection]
	                        time:time
	                       scene:scene];

	[self.player rotateByAngle:[self characterAngleVelocity]];
}

#pragma mark - Moving the Character

- (vector_float3)playerDirection
{
	vector_float2 controllerDirection = self.controllerDirection;
	vector_float3 direction = {0.0f, 0.0f, controllerDirection.y};

	SCNVector3 p1 = [self.player.node convertPosition:SCNVector3Make(direction.x, direction.y, direction.z) toNode:nil];
	SCNVector3 p0 = [self.player.node convertPosition:SCNVector3Zero toNode:nil];
	return (vector_float3) {p1.x - p0.x, 0.0, p1.z - p0.z};
}

- (CGFloat)characterAngleVelocity
{
	return self.controllerDirection.x;
}

#pragma mark - Game view

- (AAPLGameView *)gameView
{
	return (AAPLGameView *)self.view;
}

#pragma mark - SCNPhysicsContactDelegate Conformance

- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact
{
	if (contact.nodeB.categoryBitMask == AAPLBitmaskCollectable) {
		AAPLItem *item = [AAPLItem itemForNode:contact.nodeB];
		[item runActionWithPlayer:self.player];
		[item.node removeFromParentNode];
		[self.items removeObject:item];
	}
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact
{
	if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskEnemy) {
		[self characterNode:contact.nodeA hitWall:contact.nodeB withContact:contact];
	}
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didSimulatePhysicsAtTime:(NSTimeInterval)time
{
	if (self.replacementPositionIsValid) {
		self.player.node.position = self.replacementPosition;
	}
}

- (void)characterNode:(SCNNode *)characterNode hitWall:(SCNNode *)wall withContact:(SCNPhysicsContact *)contact
{
	if (characterNode.parentNode != self.player.node) {
		return;
	}

	if (self.maxPenetrationDistance > contact.penetrationDistance) {
		return;
	}

	self.maxPenetrationDistance = contact.penetrationDistance;

	vector_float3 characterPosition = SCNVector3ToFloat3(self.player.node.position);
	vector_float3 positionOffset = SCNVector3ToFloat3(contact.contactNormal) * contact.penetrationDistance;
	positionOffset.y = 0;
	characterPosition += positionOffset;

	self.replacementPosition = SCNVector3FromFloat3(characterPosition);
	self.replacementPositionIsValid = YES;
}

#pragma mark - AAPLCharacterDelegate Conformance

- (void)player:(AAPLCharacter *)character lifeDidChange:(CGFloat)newLife
{
	if (character == self.player) {
		[self.gameView setLife:newLife / character.maxLife];
	}
}

@end
