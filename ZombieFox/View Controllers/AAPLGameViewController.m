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
#import "AAPLWeaponFactory.h"

@interface AAPLGameViewController () <AAPLCharacterDelegate, AAPLPlayerDelegate>
@property (strong, nonatomic) AAPLItem *item;
@property (nonatomic) NSTimeInterval pastTime;
@property (nonatomic) NSUInteger wave;
@end

@implementation AAPLGameViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupScene];
}

- (void)viewDidAppear
{
	[super viewDidAppear];

	self.wave = 1;

	AAPLWeaponConfiguration *config = [[AAPLWeaponConfiguration alloc] init];
	config.scene = self.gameView.scene;
	config.damage = 5.0f;
	config.type = AAPLWeaponTypeShotgun;

	AAPLWeapon *weapon = [AAPLWeaponFactory weaponWithConfiguration:config];
	self.player.weapon = weapon;
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
	self.gameView.showsStatistics = YES;
}

- (void)setupGame
{
	self.player = [AAPLPlayer new];
	self.player.node.position = SCNVector3Make(0.0f, 0.0f, 1.0f);
	self.player.delegate = self;
	self.player.playerDelegate = self;
	[self.gameView.scene.rootNode addChildNode:self.player.node];

	self.enemies = [NSMutableArray new];
	self.items = [NSMutableArray new];

	AAPLItem *item = [AAPLItemFactory speedItemWithSpeed:2.0f forInterval:5.0f];
	item.node.position = SCNVector3Make(0.0f, 0.0f, 0.0f);
	[self.gameView.scene.rootNode addChildNode:item.node];
	[self.items addObject:item];

	AAPLEnemy *enemy = [AAPLEnemyFactory mummyWithLife:30.0f andStrength:0.5f];
	enemy.node.position = SCNVector3Make(0.0f, 0.0f, 3.0f);
	enemy.delegate = self;
	[self.gameView.scene.rootNode addChildNode:enemy.node];
	[self.enemies addObject:enemy];

	enemy = [AAPLEnemyFactory mummyWithLife:30.0f andStrength:0.5f];
	enemy.node.position = SCNVector3Make(0.0f, 0.0f, -3.0f);
	enemy.delegate = self;
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
	if (!self.pastTime) {
		self.pastTime = time;
		return;
	}

	if (self.player.replacementPositionIsValid) {
		self.player.replacementPositionIsValid = NO;
		self.player.maxPenetrationDistance = 0;
	}

	for (AAPLEnemy *enemy in self.enemies) {
		if (enemy.replacementPositionIsValid) {
			enemy.replacementPositionIsValid = NO;
			enemy.maxPenetrationDistance = 0;
		}
	}

	SCNScene *scene = self.gameView.scene;

	[self.player walkInDirection:[self playerDirection]
	                        time:time - self.pastTime
	                       scene:scene];

	[self.player rotateByAngle:[self characterAngleVelocity]];

	for (AAPLEnemy *enemy in self.enemies) {
		[enemy seek:self.player withTime:time - self.pastTime];
	}

	if (self.holdingTrigger) {
		[self.player shoot];
		self.holdingTrigger = NO;
	}

	self.pastTime = time;
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
	if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskCollectable) {
		AAPLItem *item = [AAPLItem itemForNode:contact.nodeB];
		[item runActionWithPlayer:self.player];
		[item.node removeFromParentNode];
		[self.items removeObject:item];
	}
}

- (void)physicsWorld:(SCNPhysicsWorld *)world didUpdateContact:(SCNPhysicsContact *)contact
{
	if (contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskEnemy &&
	    contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskPlayer) {
		AAPLEnemy *enemy = [AAPLEnemy enemyForNode:contact.nodeB];
		[enemy hurtCharacter:self.player];
	}

	AAPLCharacter *character = [AAPLCharacter characterForNode:contact.nodeA];

	[self character:character hitWall:contact.nodeB withContact:contact];
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didSimulatePhysicsAtTime:(NSTimeInterval)time
{
	if (self.player.replacementPositionIsValid) {
		self.player.node.position = self.player.replacementPosition;
	}

	for (AAPLEnemy *enemy in self.enemies) {
		if (enemy.replacementPositionIsValid) {
			enemy.node.position = enemy.replacementPosition;
		}
	}
}

- (void)character:(AAPLCharacter *)character hitWall:(SCNNode *)wall withContact:(SCNPhysicsContact *)contact
{
	if (character.maxPenetrationDistance > contact.penetrationDistance) {
		return;
	}

	character.maxPenetrationDistance = contact.penetrationDistance;

	vector_float3 characterPosition = SCNVector3ToFloat3(character.node.position);
	vector_float3 positionOffset = SCNVector3ToFloat3(contact.contactNormal) * contact.penetrationDistance;
	positionOffset.y = 0;
	characterPosition += positionOffset;

	character.replacementPosition = SCNVector3FromFloat3(characterPosition);
	character.replacementPositionIsValid = YES;
}

#pragma mark - AAPLCharacterDelegate Conformance

- (void)character:(AAPLCharacter *)character lifeDidChange:(CGFloat)newLife
{
	if (character == self.player) {
		[self.gameView setLife:newLife / character.maxLife];
	} else {
		if (newLife == 0) {
			[character.node removeFromParentNode];
			[self.enemies removeObject:(AAPLEnemy *)character];
			AAPLItem *item = [AAPLItemFactory randomItemForScene:self.gameView.scene];
			item.node.position = character.node.position;
			[self.items addObject:item];
			[self.gameView.scene.rootNode addChildNode:item.node];
		}
	}
}

- (void)character:(AAPLCharacter *)character invulnerabilityDidChange:(BOOL)invulnerable
{
	if (character == self.player) {
		self.gameView.invulnerable = invulnerable;
	}
}

- (void)player:(AAPLPlayer *)player selectedWeaponDidChange:(AAPLWeapon *)newWeapon
{
	[self.gameView setWeapon:newWeapon.name];
}

#pragma mark - Setters and getters

- (void)setWave:(NSUInteger)wave
{
	_wave = wave;

	[self.gameView setWave:wave];
}

@end
