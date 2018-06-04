/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles keyboard (OS X), touch (iOS) and controller (iOS, tvOS) input for controlling the game.
*/

#import "AAPLGameViewControllerPrivate.h"

static CGFloat const AAPLControllerAcceleration = 1.0 / 10.0;
static CGFloat const AAPLControllerDirectionLimit = 1.0;

@implementation AAPLGameViewController (GameControls)
    
#pragma mark - Controller orientation

- (vector_float2)controllerDirection {
    // Poll when using a game controller
    if (_controllerDPad) {
        if (_controllerDPad.xAxis.value == 0.0 && _controllerDPad.yAxis.value == 0.0) {
            _controllerDirection = (vector_float2){0.0, 0.0};
        } else {
            _controllerDirection = vector_clamp(_controllerDirection + (vector_float2){_controllerDPad.xAxis.value, -_controllerDPad.yAxis.value} * AAPLControllerAcceleration, -AAPLControllerDirectionLimit, AAPLControllerDirectionLimit);
        }
    }
    
    return _controllerDirection;
}

#pragma mark -  Game Controller Events

- (void)setupGameControllers {
    self.gameView.eventsDelegate = self;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleControllerDidConnectNotification:) name:GCControllerDidConnectNotification object:nil];
}

- (void)handleControllerDidConnectNotification:(NSNotification *)notification {
    GCController *gameController = notification.object;
    [self registerCharacterMovementEvents:gameController];
}

- (void)registerCharacterMovementEvents:(GCController *)gameController {
    
    // An analog movement handler for D-pads and thumbsticks.
    __weak typeof(self) weakSelf = self;
    GCControllerDirectionPadValueChangedHandler movementHandler = ^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
        typeof(self) strongSelf = weakSelf;
        strongSelf->_controllerDPad = dpad;
    };
    
    // Gamepad D-pad
    GCGamepad *gamepad = gameController.gamepad;
    gamepad.dpad.valueChangedHandler = movementHandler;
    
    // Extended gamepad left thumbstick
    GCExtendedGamepad *extendedGamepad = gameController.extendedGamepad;
    extendedGamepad.leftThumbstick.valueChangedHandler = movementHandler;
}

#pragma mark - Mouse and Keyboard Events

- (BOOL)mouseDown:(NSView *)view event:(NSEvent *)theEvent {
    // Remember last mouse position for dragging.
    _lastMousePosition = [self.view convertPoint:theEvent.locationInWindow fromView:nil];
    return YES;
}

- (BOOL)mouseDragged:(NSView *)view event:(NSEvent *)theEvent {
    CGPoint mousePosition = [self.view convertPoint:theEvent.locationInWindow fromView:nil];
    [self panCamera:CGPointMake(mousePosition.x - _lastMousePosition.x, mousePosition.y - _lastMousePosition.y)];
    _lastMousePosition = mousePosition;
    
    return YES;
}

- (BOOL)mouseUp:(NSView *)view event:(NSEvent *)theEvent {
    return YES;
}

- (BOOL)keyDown:(NSView *)view event:(NSEvent *)theEvent {
    
    BOOL success = NO;
    
    if (theEvent.keyCode == 49) { // Spacebar
        if (!theEvent.isARepeat) {
            _holdingTrigger = 1;
            success = YES;
        }
    }
    
    switch (theEvent.keyCode) {
        case 126: // Up
            if (!theEvent.isARepeat) {
                _controllerDirection += (vector_float2){ 0, -1};
            }
            return YES;
        case 125: // Down
            if (!theEvent.isARepeat) {
                _controllerDirection += (vector_float2){ 0,  1};
            }
            return YES;
        case 123: // Left
            if (!theEvent.isARepeat) {
                _controllerDirection += (vector_float2){-1,  0};
            }
            return YES;
        case 124: // Right
            if (!theEvent.isARepeat) {
                _controllerDirection += (vector_float2){ 1,  0};
            }
            return YES;
    }
    
    return success;
}

- (BOOL)keyUp:(NSView *)view event:(NSEvent *)theEvent {
    
    BOOL success = NO;
    
    if (theEvent.keyCode == 49) { // Spacebar
         if (!theEvent.isARepeat) {
            _holdingTrigger = 0;
             success = YES;
        }
    }
    
    switch (theEvent.keyCode) {
        case 126: // Up
            if (!theEvent.isARepeat) {
                _controllerDirection -= (vector_float2){ 0, -1};
            }
            return YES;
        case 125: // Down
            if (!theEvent.isARepeat) {
                _controllerDirection -= (vector_float2){ 0,  1};
            }
            return YES;
        case 123: // Left
            if (!theEvent.isARepeat) {
                _controllerDirection -= (vector_float2){-1,  0};
            }
            return YES;
        case 124: // Right
            if (!theEvent.isARepeat) {
                _controllerDirection -= (vector_float2){ 1,  0};
            }
            return YES;
    }
    
    return success;
}

@end
