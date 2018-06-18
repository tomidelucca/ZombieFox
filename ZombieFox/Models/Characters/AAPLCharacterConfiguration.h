//
// AAPLCharacterConfiguration.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface AAPLCharacterConfiguration : NSObject
@property (strong, nonatomic) SCNScene *characterScene;
@property (strong, nonatomic) SCNScene *walkAnimationScene;
@property (nonatomic) CGFloat maxLife;
@property (nonatomic) CGFloat strength;
@end
