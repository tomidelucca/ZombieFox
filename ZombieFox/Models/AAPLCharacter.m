/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    This class manages the main character, including its animations, sounds and direction.
 */

@import SceneKit;

#import "AAPLCharacter.h"
#import "SCNScene+LoadAnimation.h"

static CGFloat const AAPLCharacterSpeedFactor = 1.538;

@interface AAPLCharacter ()
@property (strong, nonatomic) CAAnimation *walkAnimation;
@property (nonatomic) NSTimeInterval previousUpdateTime;
@property (nonatomic) AAPLGroundType groundType;
@property (strong, nonatomic) SCNNode *node;
@property (nonatomic) CGFloat walkSpeed;
@property (nonatomic) BOOL isWalking;

@property (nonatomic) CGFloat maxLife;
@property (nonatomic) CGFloat life;
@property (nonatomic) CGFloat strength;
@property (nonatomic) BOOL invulnerable;
@end

@implementation AAPLCharacter

#pragma mark - Initialization

- (instancetype)initWithConfiguration:(AAPLCharacterConfiguration*)configuration
{
    self = [super init];
    if (self) {
        self.maxLife = configuration.maxLife;
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
    self.walkSpeed = 1.0f;
}

#pragma mark - Controlling the character

- (void)rotateByAngle:(CGFloat)angle
{
	[self.node runAction:[SCNAction rotateByX:0.0f y:(angle * M_PI / 80) z:0.0f duration:0.1f]];
}

- (void)walkInDirection:(vector_float3)direction time:(NSTimeInterval)time scene:(SCNScene *)scene
{
	if (self.previousUpdateTime == 0.0) {
		self.previousUpdateTime = time;
	}

	NSTimeInterval deltaTime = MIN(time - self.previousUpdateTime, 1.0 / 60.0);
	CGFloat characterSpeed = deltaTime * AAPLCharacterSpeedFactor * 0.84 * self.walkSpeed;
	self.previousUpdateTime = time;

	if (direction.x != 0.0 || direction.z != 0.0) {
		vector_float3 position = SCNVector3ToFloat3(self.node.position);
		self.node.position = SCNVector3FromFloat3(position + direction * characterSpeed);
		self.walking = YES;
	} else {
		self.walking = NO;
	}
}

#pragma mark - Animating the character

- (void)setupWalkAnimationWithScene:(SCNScene *)scene
{
	self.walkAnimation = [scene loadAnimation];
	self.walkAnimation.usesSceneTimeBase = NO;
	self.walkAnimation.fadeInDuration = 0.3;
	self.walkAnimation.fadeOutDuration = 0.3;
	self.walkAnimation.repeatCount = FLT_MAX;
	self.walkAnimation.speed = AAPLCharacterSpeedFactor;
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

	self.walkAnimation.speed = AAPLCharacterSpeedFactor * self.walkSpeed;

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

- (void)takeLife:(CGFloat)points
{
    self.life -= points;
    
    if (self.life < 0) {
        // DEAD DO SOMETHING
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
    
    __weak typeof(self) weakSelf = self;
    
    id wait = [SCNAction waitForDuration:interval];
    id run = [SCNAction runBlock:^(SCNNode* node) {
        weakSelf.walkSpeed -= boost;
    }];
    
    [self.node runAction:[SCNAction sequence:@[wait, run]]];
}

- (void)invulnerableForInterval:(NSTimeInterval)interval
{
    self.invulnerable = YES;
    [NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block:^(NSTimer* timer) {
        self.invulnerable = NO;
    }];
}

@end
