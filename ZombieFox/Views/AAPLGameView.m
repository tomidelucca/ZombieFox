/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    The view displaying the game scene, including the 2D overlay.
 */

@import SpriteKit;

#import "AAPLGameView.h"

@interface AAPLGameView()
@property (strong, nonatomic) SKSpriteNode* overlayNode;
@property (strong, nonatomic) SKLabelNode* waveLabel;
@property (strong, nonatomic) SKLabelNode* lifeLabel;
@property (strong, nonatomic) SKSpriteNode* lifeBar;
@end

@implementation AAPLGameView

#pragma mark - 2D Overlay

- (void)viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
	[self setup2DOverlay];
    self.debugOptions = SCNDebugOptionShowPhysicsShapes | SCNDebugOptionShowPhysicsFields;
}

- (void)setup2DOverlay
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
