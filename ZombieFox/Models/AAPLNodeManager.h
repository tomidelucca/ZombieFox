//
// AAPLNodeManager.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface AAPLNodeManager : NSObject
+ (id)sharedManager;
- (void)associateNode:(SCNNode *)node withModel:(id)model;
- (id)modelForAssociatedNode:(SCNNode *)node;
@end
