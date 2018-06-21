/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    The view displaying the game scene, including the 2D overlay.
 */

@import SpriteKit;

#import "AAPLGameView.h"

@interface AAPLGameView ()
@property (strong, nonatomic) SKSpriteNode *overlayNode;
@property (strong, nonatomic) SKLabelNode *waveLabel;
@property (strong, nonatomic) SKLabelNode *lifeLabel;
@property (strong, nonatomic) SKSpriteNode *lifeBar;
@property (strong, nonatomic) SKLabelNode *weaponLabel;
@property (strong, nonatomic) SKSpriteNode *dimScreen;
@end

@implementation AAPLGameView

#pragma mark - 2D Overlay

- (void)viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
	[self setupOverlay];

	// self.debugOptions = SCNDebugOptionShowPhysicsShapes;
}

- (void)setupOverlay
{
	CGFloat w = self.bounds.size.width;
	CGFloat h = self.bounds.size.height;

	self.overlayNode = [[SKSpriteNode alloc] init];

	SKScene *skScene = [SKScene sceneWithSize:CGSizeMake(w, h)];
	skScene.anchorPoint = CGPointMake(0.0f, 0.0f);
	[skScene addChild:self.overlayNode];

	self.overlayNode.position = CGPointMake(0.0f, 0.0f);
	self.overlayNode.anchorPoint = CGPointMake(0.0f, 0.0f);

	self.lifeBar = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(200.0f, 20.0f)];
	self.lifeBar.position = CGPointMake(10.0f, h - 30.0f);
	self.lifeBar.anchorPoint = CGPointMake(0.0f, 0.0f);
	[self.overlayNode addChild:self.lifeBar];

	self.lifeLabel = [[SKLabelNode alloc] initWithFontNamed:@"Impact"];
	self.lifeLabel.text = @"100";
	self.lifeLabel.fontSize = 26.0f;
	self.lifeLabel.position = CGPointMake(220.0f, h - 20.0f);
	self.lifeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	self.lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
	[self.overlayNode addChild:self.lifeLabel];

	self.waveLabel = [[SKLabelNode alloc] initWithFontNamed:@"Impact"];
	self.waveLabel.text = @"Wave 1";
	self.waveLabel.fontSize = 26.0f;
	self.waveLabel.position = CGPointMake(w - 10.0f, h - 20.0f);
	self.waveLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	self.waveLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
	[self.overlayNode addChild:self.waveLabel];

	self.weaponLabel = [[SKLabelNode alloc] initWithFontNamed:@"Impact"];
	self.weaponLabel.text = @"Shotgun";
	self.weaponLabel.fontSize = 26.0f;
	self.weaponLabel.position = CGPointMake(10.0f, 20.0f);
	self.weaponLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
	self.weaponLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
	[self.overlayNode addChild:self.weaponLabel];

	self.overlaySKScene = skScene;
	skScene.userInteractionEnabled = NO;
}

- (void)setInvulnerable:(BOOL)invulnerable
{
	_invulnerable = invulnerable;

	if (invulnerable) {
		self.lifeBar.color = [NSColor cyanColor];
	} else {
		self.life = self.life;
	}
}

- (void)setLife:(CGFloat)life
{
	_life = life;
	self.lifeLabel.text = [NSString stringWithFormat:@"%.0f", life * 100.0f];
	self.lifeBar.xScale = life;

	if (life <= 0.2f) {
		self.lifeBar.color = [NSColor redColor];
	} else {
		self.lifeBar.color = [NSColor greenColor];
	}
}

- (void)setWave:(NSUInteger)wave
{
	_wave = wave;
	self.waveLabel.text = [NSString stringWithFormat:@"Wave %ld", wave];
}

- (void)setWeapon:(NSString *)weapon
{
	_weapon = weapon;
	self.weaponLabel.text = weapon;
}

- (void)setGameOverScreenVisible:(BOOL)visible
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if (visible) {
		    CGFloat w = self.bounds.size.width;
		    CGFloat h = self.bounds.size.height;
		    self.dimScreen = [SKSpriteNode spriteNodeWithColor:[[SKColor blackColor] colorWithAlphaComponent:0.4f] size:CGSizeMake(w, h)];
		    self.dimScreen.position = CGPointMake(0.0f, 0.0f);
		    self.dimScreen.anchorPoint = CGPointMake(0.0f, 0.0f);
		    SKLabelNode *deadMessage = [[SKLabelNode alloc] initWithFontNamed:@"Impact"];
		    deadMessage.text = [NSString stringWithFormat:@"You've reached wave %ld, but died. Click to restart the game.", self.wave];
		    deadMessage.fontSize = 26.0f;
		    deadMessage.position = CGPointMake(w / 2, h / 2);
		    deadMessage.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
		    deadMessage.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
		    [self.dimScreen addChild:deadMessage];
		    [self.overlayNode addChild:self.dimScreen];
		} else {
		    [self.dimScreen removeFromParent];
		    self.dimScreen = nil;
		}
	});
}

#pragma mark - Mouse and Keyboard Events

- (void)mouseDown:(NSEvent *)theEvent
{
	if (!_eventsDelegate || [_eventsDelegate mouseDown:self event:theEvent] == NO) {
		[super mouseDown:theEvent];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	if (!_eventsDelegate || [_eventsDelegate mouseDragged:self event:theEvent] == NO) {
		[super mouseDragged:theEvent];
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	if (!_eventsDelegate || [_eventsDelegate mouseUp:self event:theEvent] == NO) {
		[super mouseUp:theEvent];
	}
}

- (void)keyDown:(NSEvent *)theEvent
{
	if (!_eventsDelegate || [_eventsDelegate keyDown:self event:theEvent] == NO) {
		[super keyDown:theEvent];
	}
}

- (void)keyUp:(NSEvent *)theEvent
{
	if (!_eventsDelegate || [_eventsDelegate keyUp:self event:theEvent] == NO) {
		[super keyUp:theEvent];
	}
}

@end
