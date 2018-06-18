//
// AAPLItem.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "AAPLCollisionMasks.h"
#import "AAPLPlayer.h"

typedef void (^ItemAction)(AAPLPlayer *);

@interface AAPLItem : NSObject
@property (nonatomic, strong) SCNNode *node;
+ (AAPLItem *)itemForNode:(SCNNode *)node;
- (instancetype)initWithAction:(ItemAction)action;
- (void)runActionWithPlayer:(AAPLPlayer *)player;
- (void)setItemColor:(NSColor *)color;
@end
