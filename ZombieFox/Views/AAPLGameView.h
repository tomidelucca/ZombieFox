/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    The view displaying the game scene, including the 2D overlay.
 */

@import simd;
@import SceneKit;

@protocol AAPLKeyboardAndMouseEventsDelegate <NSObject>
@required
- (BOOL)mouseDown:(NSView *)view event:(NSEvent *)event;
- (BOOL)mouseDragged:(NSView *)view event:(NSEvent *)event;
- (BOOL)mouseUp:(NSView *)view event:(NSEvent *)event;
- (BOOL)keyDown:(NSView *)view event:(NSEvent *)event;
- (BOOL)keyUp:(NSView *)view event:(NSEvent *)event;
@end

@interface AAPLGameView : SCNView

@property (nonatomic) CGFloat life;
@property (nonatomic) NSUInteger wave;
@property (nonatomic) BOOL invulnerable;
@property (nonatomic, strong) NSString *weapon;

@property (nonatomic, weak) id <AAPLKeyboardAndMouseEventsDelegate> eventsDelegate;

- (void)setGameOverScreenVisible:(BOOL)visible;

@end
