//
// AAPLPlayer.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLPlayer.h"

#import "AAPLNodeManager.h"
#import "SCNScene+LoadAnimation.h"

static NSString *const AAPLPlayerAnimationKeyWalk = @"walk";

@interface AAPLPlayer () <AAPLWeaponHolder>
@property (nonatomic, strong) NSMutableDictionary <NSString *, CAAnimation *> *animations;
@end

@implementation AAPLPlayer

- (instancetype)init
{
	self = [super initWithConfiguration:[AAPLPlayer playerConfiguration]];
	if (self) {
		[self setupCollisions];
		[self loadAnimations];
	}
	return self;
}

#pragma mark - Configuration

+ (AAPLCharacterConfiguration *)playerConfiguration
{
	AAPLCharacterConfiguration *configuration = [AAPLCharacterConfiguration new];
	configuration.characterScene = [SCNScene sceneNamed:@"game.scnassets/panda.scn"];
	configuration.maxLife = 100.0f;
	configuration.maxVelocity = 1.5f;
	configuration.strength = 10.0f;
	return configuration;
}

- (void)setupCollisions
{
	SCNVector3 min, max;
	[self.node getBoundingBoxMin:&min max:&max];
	CGFloat collisionCapsuleRadius = (max.x - min.x) * 0.4;
	CGFloat collisionCapsuleHeight = (max.y - min.y);

	SCNNode *collisionNode = [SCNNode node];
	collisionNode.name = @"player_collider";
	collisionNode.position = SCNVector3Make(0.0, collisionCapsuleHeight * 0.50, 0.0);
	collisionNode.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeKinematic
	                                                   shape:[SCNPhysicsShape shapeWithGeometry:
	                                                          [SCNCapsule capsuleWithCapRadius:collisionCapsuleRadius
	                                                                                    height:collisionCapsuleHeight]
	                                                                                    options:nil]];
	collisionNode.physicsBody.categoryBitMask = AAPLBitmaskPlayer;
	collisionNode.physicsBody.collisionBitMask = AAPLBitmaskCollectable | AAPLBitmaskEnemy;
	collisionNode.physicsBody.contactTestBitMask = AAPLBitmaskCollectable | AAPLBitmaskEnemy;

	collisionNode.physicsBody.mass = 1.0f;
	collisionNode.physicsBody.restitution = 0.0f;

	[self.node addChildNode:collisionNode];

	[[AAPLNodeManager sharedManager] associateNode:collisionNode withModel:self];
	[[AAPLNodeManager sharedManager] associateNode:self.node withModel:self];
}

- (void)loadAnimations
{
	SCNScene *walkAnimationScene = [SCNScene sceneNamed:@"game.scnassets/walk.scn"];
	CAAnimation *walkAnimation = [walkAnimationScene loadAnimation];
	walkAnimation.usesSceneTimeBase = NO;
	walkAnimation.fadeInDuration = 0.3;
	walkAnimation.fadeOutDuration = 0.3;
	walkAnimation.repeatCount = FLT_MAX;

	[self.animations setObject:walkAnimation forKey:AAPLPlayerAnimationKeyWalk];
}

#pragma mark - Public methods

+ (AAPLPlayer *)playerForNode:(SCNNode *)node
{
	NSObject *model = [[AAPLNodeManager sharedManager] modelForAssociatedNode:node];

	if ([model isKindOfClass:[AAPLPlayer class]]) {
		return (AAPLPlayer *)model;
	}

	return nil;
}

- (void)shoot
{
	[self.weapon pullTheTrigger];
}

- (void)letGo
{
    [self.weapon releaseTheTrigger];
}

- (void)hurtCharacter:(AAPLCharacter *)character
{
    [character takeLife:self.weapon.damage];
}

#pragma mark - AAPLWeaponHolder

- (SCNVector3)positionForWeaponHolder:(AAPLWeapon *)weapon
{
	return self.node.position;
}

- (CGFloat)angleForWeaponHolder:(AAPLWeapon *)weapon
{
	return self.node.eulerAngles.y;
}

- (SCNNode*)holderNodeForWeapon:(AAPLWeapon *)weapon
{
    return self.node;
}

#pragma mark - Setters and getters

- (NSMutableDictionary *)animations
{
	if (_animations == nil) {
		_animations = [NSMutableDictionary new];
	}

	return _animations;
}

- (void)setWeapon:(AAPLWeapon *)weapon
{
	if (_weapon) {
		[_weapon.node removeFromParentNode];
		_weapon = nil;
	}

	_weapon = weapon;
	_weapon.holder = self;
	[self.node addChildNode:weapon.node];

	if ([self.playerDelegate respondsToSelector:@selector(player:selectedWeaponDidChange:)]) {
		[self.playerDelegate player:self selectedWeaponDidChange:weapon];
	}
}

- (void)setPace:(CGFloat)pace
{
	[super setPace:pace];

	BOOL wasWalking = self.isWalking;

	if (wasWalking) {
		self.isWalking = NO;
	}

	self.animations[AAPLPlayerAnimationKeyWalk].speed = pace;

	if (wasWalking) {
		self.isWalking = YES;
	}
}

- (void)setIsWalking:(BOOL)isWalking
{
	if (self.isWalking == isWalking) {
		return;
	}

	[super setIsWalking:isWalking];

	if (isWalking) {
		[self.node addAnimation:self.animations[AAPLPlayerAnimationKeyWalk] forKey:AAPLPlayerAnimationKeyWalk];
	} else {
		[self.node removeAnimationForKey:AAPLPlayerAnimationKeyWalk fadeOutDuration:0.2];
	}
}

@end
