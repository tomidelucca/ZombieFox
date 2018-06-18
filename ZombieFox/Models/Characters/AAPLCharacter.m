/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    This class manages the main character, including its animations, sounds and direction.
 */

@import SceneKit;

#import "AAPLCharacter.h"
#import "SCNScene+LoadAnimation.h"

@interface AAPLCharacter ()
@property (strong, nonatomic) CAAnimation *walkAnimation;
@property (nonatomic) NSTimeInterval previousUpdateTime;
@property (strong, nonatomic) SCNNode *node;
@property (nonatomic) CGFloat walkSpeed;
@property (nonatomic) BOOL isWalking;
@property (nonatomic) vector_float3 velocity;

@property (nonatomic) CGFloat maxLife;
@property (nonatomic) CGFloat life;
@property (nonatomic) BOOL invulnerable;
@end

@implementation AAPLCharacter

#pragma mark - Initialization

- (instancetype)initWithConfiguration:(AAPLCharacterConfiguration *)configuration
{
	self = [super init];
	if (self) {
		self.maxLife = configuration.maxLife;
		self.life = configuration.maxLife;
		self.walkSpeed = configuration.maxVelocity;
		_strength = configuration.strength;
		self.velocity = (vector_float3) {0.0f, 0.0f, 0.0f};
		[self setupNodeWithScene:configuration.characterScene];
		if (configuration.walkAnimationScene) {
			[self setupWalkAnimationWithScene:configuration.walkAnimationScene];
		}
		[self configureCharacter];
	}
	return self;
}

#pragma mark - Setup character

- (void)setupNodeWithScene:(SCNScene *)scene
{
	self.node = [SCNNode node];
	SCNScene *characterScene = scene;
	SCNNode *characterTopLevelNode = characterScene.rootNode.childNodes[0];
	[self.node addChildNode:characterTopLevelNode];
}

- (void)configureCharacter
{
	[self loadEmbeddedAnimations];
}

#pragma mark - Controlling the character

- (void)rotateByAngle:(CGFloat)angle
{
	[self.node runAction:[SCNAction rotateByX:0.0f y:(angle * M_PI / 80) z:0.0f duration:0.1f]];
}

- (void)walkInDirection:(vector_float3)direction time:(NSTimeInterval)time scene:(SCNScene *)scene
{
	NSTimeInterval deltaTime = MIN(time, 1.0 / 60.0);
	CGFloat characterSpeed = deltaTime * self.walkSpeed;

	if (direction.x != 0.0 || direction.z != 0.0) {
		vector_float3 position = SCNVector3ToFloat3(self.node.position);
		self.node.position = SCNVector3FromFloat3(position + direction * characterSpeed);
		self.walking = YES;
	} else {
		self.walking = NO;
	}
}

- (void)seek:(AAPLCharacter *)character withTime:(NSTimeInterval)time
{
	NSTimeInterval deltaTime = MIN(time, 1.0 / 60.0);

	vector_float3 t = SCNVector3ToFloat3(character.node.position);
	vector_float3 p = SCNVector3ToFloat3(self.node.position);

	CGFloat distance = vector_distance(t, p);

	vector_float3 desiredVelocity = vector_normalize(t - p) * self.walkSpeed * deltaTime;

	if (distance <= 1) {
		desiredVelocity *= distance;
	}

	vector_float3 steering = desiredVelocity - self.velocity;

	self.velocity = self.velocity + steering;

	self.node.position = SCNVector3Make(p.x + self.velocity.x, p.y + self.velocity.y, p.z + self.velocity.z);

	CGFloat angle = atan2(self.velocity.x, self.velocity.z);

	[self.node runAction:[SCNAction rotateToX:0.0f y:angle z:0.0f duration:0.1f]];
}

#pragma mark - Animating the character

- (void)setupWalkAnimationWithScene:(SCNScene *)scene
{
	self.walkAnimation = [scene loadAnimation];
	self.walkAnimation.usesSceneTimeBase = NO;
	self.walkAnimation.fadeInDuration = 0.3;
	self.walkAnimation.fadeOutDuration = 0.3;
	self.walkAnimation.repeatCount = FLT_MAX;
}

- (void)setWalking:(BOOL)walking
{
	if (self.isWalking != walking) {
		self.isWalking = walking;

		// Update node animation.
		if (self.isWalking) {
			[self.node addAnimation:self.walkAnimation forKey:@"walk"];
		} else {
			[self.node removeAnimationForKey:@"walk" fadeOutDuration:0.2];
		}
	}
}

- (void)setWalkSpeed:(CGFloat)walkSpeed
{
	_walkSpeed = walkSpeed;

	BOOL wasWalking = self.isWalking;
	if (wasWalking) {
		self.walking = NO;
	}

	self.walkAnimation.speed = self.walkSpeed;

	if (wasWalking) {
		self.walking = YES;
	}
}

- (void)loadEmbeddedAnimations
{
	SCNNode *characterTopLevelNode = self.node.childNodes[0];
	[characterTopLevelNode enumerateChildNodesUsingBlock: ^(SCNNode *child, BOOL *stop) {
	    for (NSString *key in child.animationKeys) {
	        CAAnimation *animation = [child animationForKey:key];
	        animation.usesSceneTimeBase = NO;
	        animation.repeatCount = FLT_MAX;
	        [child addAnimation:animation forKey:key];
		}
	}];
}

#pragma mark - Boosters

- (void)setLife:(CGFloat)life
{
	if (life > self.maxLife && life < 0) {
		return;
	}

	_life = life;
	[self.delegate player:self lifeDidChange:life];
}

- (void)takeLife:(CGFloat)points
{
	self.life -= points;

	if (self.life < 0) {
		self.life = 0;
	}
}

- (void)giveLife:(CGFloat)points
{
	self.life += points;

	if (self.life > self.maxLife) {
		self.life = self.maxLife;
	}
}

- (void)speedMultiplier:(CGFloat)multiplier forInterval:(NSTimeInterval)interval
{
	CGFloat boost = (self.walkSpeed * multiplier);
	self.walkSpeed += boost;

	__weak typeof(self)weakSelf = self;

	id wait = [SCNAction waitForDuration:interval];
	id run = [SCNAction runBlock: ^(SCNNode *node) {
	    weakSelf.walkSpeed -= boost;
	}];

	[self.node runAction:[SCNAction sequence:@[wait, run]]];
}

- (void)invulnerableForInterval:(NSTimeInterval)interval
{
	self.invulnerable = YES;
	[NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block: ^(NSTimer *timer) {
	    self.invulnerable = NO;
	}];
}

@end
