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
static NSUInteger const AAPLCharacterStepsCount = 11;

@interface AAPLCharacter ()
@property (strong, nonatomic) CAAnimation *walkAnimation;
@property (nonatomic) NSTimeInterval previousUpdateTime;
@property (nonatomic) AAPLGroundType groundType;
@property (strong, nonatomic) SCNNode *node;
@property (nonatomic) BOOL isWalking;
@end

@implementation AAPLCharacter
{
	SCNAudioSource *_steps[AAPLCharacterStepsCount][AAPLGroundTypeCount];
}

#pragma mark - Initialization

- (instancetype)initWithCharacterScene:(SCNScene *)scene
{
	self = [super init];
	if (self) {
		[self setupNodeWithScene:scene];
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
	self.walkSpeed = 1.0f;
	[self loadEmbeddedAnimations];
	[self loadSounds];
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
	CGFloat characterSpeed = deltaTime * AAPLCharacterSpeedFactor * 0.84;
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
	self.walkAnimation.animationEvents = @[[SCNAnimationEvent animationEventWithKeyTime:0.1 block: ^(CAAnimation *animation, id animatedObject, BOOL playingBackward) {[self playFootStep];
	}],
	                                       [SCNAnimationEvent animationEventWithKeyTime:0.6 block: ^(CAAnimation *animation, id animatedObject, BOOL playingBackward) {[self playFootStep];
										   }]];
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

	// remove current walk animation if any.
	BOOL wasWalking = self.isWalking;
	if (wasWalking) {
		self.walking = NO;
	}

	self.walkAnimation.speed = AAPLCharacterSpeedFactor * self.walkSpeed;

	// restore walk animation if needed.
	if (wasWalking) {
		self.walking = YES;
	}
}

- (void)loadEmbeddedAnimations
{
	SCNNode *characterTopLevelNode = self.node.childNodes[0];
	[characterTopLevelNode enumerateChildNodesUsingBlock: ^(SCNNode *child, BOOL *stop) {
	    for (NSString *key in child.animationKeys) {               // for every animation key
	        CAAnimation *animation = [child animationForKey:key]; // get the animation
	        animation.usesSceneTimeBase = NO;                     // make it system time based
	        animation.repeatCount = FLT_MAX;                      // make it repeat forever
	        [child addAnimation:animation forKey:key];            // animations are copied upon addition, so we have to replace the previous animation
		}
	}];
}

#pragma mark - Dealing with sound

- (void)loadSounds
{
	for (NSUInteger i = 0; i < AAPLCharacterStepsCount; i++) {
		_steps[i][AAPLGroundTypeGrass] = [SCNAudioSource audioSourceNamed:[NSString stringWithFormat:@"game.scnassets/sounds/Step_grass_0%d.mp3", (uint32_t)i]];
		_steps[i][AAPLGroundTypeGrass].volume = 0.5;
		[_steps[i][AAPLGroundTypeGrass] load];
	}
}

- (void)playFootStep
{
	// Play a random step sound.
	NSInteger stepSoundIndex = arc4random_uniform(AAPLCharacterStepsCount);
	[self.node runAction:[SCNAction playAudioSource:_steps[stepSoundIndex][self.groundType] waitForCompletion:NO]];
}

@end
