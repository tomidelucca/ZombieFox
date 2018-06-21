/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information

    Abstract:
    Handles keyboard (OS X), touch (iOS) and controller (iOS, tvOS) input for controlling the game.
 */

#import "AAPLGameViewControllerPrivate.h"

@implementation AAPLGameViewController (GameControls)

#pragma mark -  Game Controller Events

- (void)setupGameControllers
{
	self.gameView.eventsDelegate = self;
}

#pragma mark - Mouse and Keyboard Events

- (BOOL)mouseDown:(NSView *)view event:(NSEvent *)event
{
	return YES;
}

- (BOOL)mouseDragged:(NSView *)view event:(NSEvent *)event
{
	return YES;
}

- (BOOL)mouseUp:(NSView *)view event:(NSEvent *)theEvent
{
	if (!self.playing) {
		[self setupGame];
	}

	return YES;
}

- (BOOL)keyDown:(NSView *)view event:(NSEvent *)theEvent
{
	BOOL success = NO;

	if (theEvent.keyCode == 49) { // Spacebar
		if (!theEvent.isARepeat) {
			self.holdingTrigger = YES;
			success = YES;
		}
	}

	switch (theEvent.keyCode) {
		case 126: { // Up
			if (!theEvent.isARepeat) {
				self.controllerDirection += (vector_float2) {0, 1};
				return YES;
			}
		}

		case 125: { // Down
			return YES;
		}

		case 123: { // Left
			if (!theEvent.isARepeat) {
				self.controllerDirection += (vector_float2) {1, 0};
			}
			return YES;
		}

		case 124: // Right
			if (!theEvent.isARepeat) {
				self.controllerDirection += (vector_float2) {-1, 0};
			}
			return YES;
	}

	return success;
}

- (BOOL)keyUp:(NSView *)view event:(NSEvent *)theEvent
{
	BOOL success = NO;

	if (theEvent.keyCode == 49) { // Spacebar
        self.holdingTrigger = NO;
		success = YES;
	}

	switch (theEvent.keyCode) {
		case 126: { // Up
			if (!theEvent.isARepeat) {
				self.controllerDirection -= (vector_float2) {0, 1};
			}
			return YES;
		}

		case 125: { // Down
			return YES;
		}

		case 123: { // Left
			if (!theEvent.isARepeat) {
				self.controllerDirection -= (vector_float2) {1, 0};
			}
			return YES;
		}

		case 124: // Right
			if (!theEvent.isARepeat) {
				self.controllerDirection -= (vector_float2) {-1, 0};
			}
			return YES;
	}

	return success;
}

@end
