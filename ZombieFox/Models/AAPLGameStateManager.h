//
// AAPLGameStateManager.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/21/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "AAPLPlayer.h"
#import "AAPLEnemy.h"
#import "AAPLItem.h"

@interface AAPLGameStateManager : NSObject
@property (weak, nonatomic) SCNScene *mainScene;
@property (strong, nonatomic) AAPLPlayer *player;
@property (strong, nonatomic) NSMutableArray <AAPLEnemy *> *enemies;
@property (strong, nonatomic) NSMutableArray <AAPLItem *> *items;
+ (AAPLGameStateManager *)sharedManager;
@end
