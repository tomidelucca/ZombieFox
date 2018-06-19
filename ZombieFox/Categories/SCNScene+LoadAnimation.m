//
// SCNScene+LoadAnimation.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "SCNScene+LoadAnimation.h"

@implementation SCNScene (LoadAnimation)

- (CAAnimation *)loadAnimation
{
	__block CAAnimation *animation = nil;
	[self.rootNode enumerateChildNodesUsingBlock: ^(SCNNode *child, BOOL *stop) {
	    if (child.animationKeys.count > 0) {
	        animation = [child animationForKey:child.animationKeys[0]];
	        *stop = YES;
		}
	}];

	return animation;
}

- (void)loadAnimationsToNode:(SCNNode *)node withSpeed:(CGFloat)speed
{
	[self.rootNode enumerateChildNodesUsingBlock: ^(SCNNode *child, BOOL *stop) {
	    for (NSString *key in child.animationKeys) {
	        CAAnimation *animation = [child animationForKey:key];
	        animation.usesSceneTimeBase = NO;
	        animation.repeatCount = FLT_MAX;
	        animation.speed = speed;
	        [node addAnimation:animation forKey:key];
		}
	}];
}

@end
