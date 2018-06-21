//
// AAPLGameState.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/21/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "AAPLEnemy.h"

@interface AAPLGameState : NSObject
@property (weak, nonatomic) NSArray <AAPLEnemy *> *enemies;
@property (weak, nonatomic) SCNScene *scene;
@end
