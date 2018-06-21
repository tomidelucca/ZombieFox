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
#import "AAPLGameStateManager.h"

@interface AAPLGameViewController () <AAPLCharacterDelegate, AAPLPlayerDelegate>
@property (strong, nonatomic) AAPLItem *item;
@property (nonatomic) NSTimeInterval pastTime;
@property (nonatomic) NSUInteger wave;
@property (nonatomic) BOOL wasHoldingTrigger;
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
	[self setupGame];
}

#pragma mark - Setup Scene

- (void)setupGame
{
	[self resetGame];
	[self setupCamera];
	[self setupGround];
	[self setupGameControllers];
	[self setupDelegates];
}

- (void)setupScene
{
	self.gameView.scene = [SCNScene sceneNamed:@"game.scnassets/level.scn"];
	[AAPLGameStateManager sharedManager].mainScene = self.gameView.scene;
	self.gameView.playing = YES;
	self.gameView.loops = YES;
}

- (void)setupDelegates
{
	self.gameView.scene.physicsWorld.contactDelegate = self;
	self.gameView.delegate = self;
}

- (void)resetGame
{
	for (SCNNode *node in self.gameView.scene.rootNode.childNodes) {
		[node removeFromParentNode];
	}

	self.playing = YES;

	self.wave = 1;
	self.pastTime = 0.0f;

	[AAPLGameStateManager sharedManager].player = [AAPLPlayer new];
	self.player.node.position = SCNVector3Make(0.0f, 0.0f, 0.0f);
	self.player.delegate = self;
	self.player.playerDelegate = self;
	[self.gameView.scene.rootNode addChildNode:self.player.node];

	AAPLWeapon *weapon = [AAPLWeaponFactory randomWeapon];
	self.player.weapon = weapon;

	[AAPLGameStateManager sharedManager].enemies = [NSMutableArray new];
	[AAPLGameStateManager sharedManager].items = [NSMutableArray new];

	[self createEnemyWave];

	[self resetOverlay];
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

	SCNNode *collider = [SCNNode node];
	collider.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeStatic
	                                              shape:[SCNPhysicsShape shapeWithGeometry:[SCNBox boxWithWidth:1000.0f
	                                                                                                     height:1.0f
	                                                                                                     length:1000.0f
	                                                                                              chamferRadius:0.0f]
	                                                                               options:nil]];
	collider.physicsBody.allowsResting = YES;
	collider.physicsBody.friction = 10.0f;
	collider.position = SCNVector3Make(0.0f, -0.5f, 0.0f);

	[self.ground addChildNode:collider];

	[self.gameView.scene.rootNode addChildNode:self.ground];
}

- (void)createEnemyWave
{
	NSUInteger numberOfEnemies = self.wave * 3;
	CGFloat enemyLife = 25.0f + (self.wave - 1) * 5;
	SCNVector3 playerPosition = self.player.node.position;

	for (int i = 0; i < numberOfEnemies; i++) {
		CGFloat xPosition = ((((float)rand() / RAND_MAX) * 5.0f) + 3.0f) * pow(-1, arc4random_uniform(2));
		CGFloat zPosition = ((((float)rand() / RAND_MAX) * 5.0f) + 3.0f) * pow(-1, arc4random_uniform(2));
		SCNVector3 enemyPosition = SCNVector3Make(playerPosition.x + xPosition, 0.0f, playerPosition.z + zPosition);
		AAPLEnemy *enemy = [AAPLEnemyFactory mummyWithLife:enemyLife andStrength:0.5f];
		enemy.node.position = enemyPosition;
		enemy.delegate = self;
		[self.gameView.scene.rootNode addChildNode:enemy.node];
		[self.enemies addObject:enemy];
	}
}

#pragma mark - SCNSceneRendererDelegate Conformance (Game Loop)

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
	if (!self.pastTime) {
		self.pastTime = time;
		return;
	}

	if (!self.playing) {
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

	if (self.holdingTrigger == YES && self.wasHoldingTrigger == NO) {
		[self.player shoot];
	}

	if (self.holdingTrigger == NO && self.wasHoldingTrigger == YES) {
		[self.player letGo];
	}

	self.wasHoldingTrigger = self.holdingTrigger;

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

	if (contact.nodeA.physicsBody.categoryBitMask == AAPLBitmaskEnemy &&
	    contact.nodeB.physicsBody.categoryBitMask == AAPLBitmaskFire) {
		AAPLEnemy *enemy = [AAPLEnemy enemyForNode:contact.nodeA];
		[self.player hurtCharacter:enemy];
	}

	AAPLCharacter *character = [AAPLCharacter characterForNode:contact.nodeA];
	AAPLCharacter *characterB = [AAPLCharacter characterForNode:contact.nodeB];

	if (characterB) {
		[self character:character hitWall:contact.nodeB withContact:contact];
	}
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
	@synchronized(self) {
		if (!self.playing) {
			return;
		}
		if (character == self.player) {
			[self.gameView setLife:newLife / character.maxLife];
			if (newLife == 0) {
				[self cleanGame];
			}
		} else {
			if (newLife == 0) {
				[self enemyWasKilled:(AAPLEnemy *)character];
			}
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

#pragma mark - Private

- (void)enemyWasKilled:(AAPLEnemy *)enemy
{
	if (self.enemies.count == 0) {
		return;
	}

	[enemy.node removeFromParentNode];
	[self.enemies removeObject:enemy];

	if (self.enemies.count % 2 == 0) {
		[self dropRandomItemAtPositon:enemy.node.position];
	}

	if (self.enemies.count == 0) {
		[self prepareNextWave];
	}
}

- (void)prepareNextWave
{
	self.wave++;

	__weak typeof(self)weakSelf = self;
	id wait = [SCNAction waitForDuration:2.0f];
	id run = [SCNAction runBlock: ^(SCNNode *node) {
	    [weakSelf createEnemyWave];
	}];

	[self.gameView.scene.rootNode runAction:[SCNAction sequence:@[wait, run]]];
}

- (void)dropRandomItemAtPositon:(SCNVector3)position
{
	AAPLItem *item = [AAPLItemFactory randomItemForScene:self.gameView.scene];
	item.node.position = position;
	[self.items addObject:item];
	[self.gameView.scene.rootNode addChildNode:item.node];
}

- (void)resetOverlay
{
	[self.gameView setGameOverScreenVisible:NO];
	[self.gameView setLife:1.0f];
	[self.gameView setWave:self.wave];
	[self.gameView setInvulnerable:NO];
	[self.gameView setWeapon:self.player.weapon.name];
}

- (void)cleanGame
{
	self.playing = NO;

	for (SCNNode *node in self.gameView.scene.rootNode.childNodes) {
		[node removeFromParentNode];
	}

	[self setupGround];
	[self.gameView setGameOverScreenVisible:YES];
}

#pragma mark - Setters and getters

- (AAPLPlayer *)player
{
	return [AAPLGameStateManager sharedManager].player;
}

- (NSMutableArray <AAPLEnemy *> *)enemies
{
	return [AAPLGameStateManager sharedManager].enemies;
}

- (NSMutableArray <AAPLItem *> *)items
{
	return [AAPLGameStateManager sharedManager].items;
}

- (void)setWave:(NSUInteger)wave
{
	_wave = wave;

	[self.gameView setWave:wave];
}

@end
