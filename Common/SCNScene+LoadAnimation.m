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
	// find top level animation
	__block CAAnimation *animation = nil;
	[self.rootNode enumerateChildNodesUsingBlock: ^(SCNNode *child, BOOL *stop) {
	    if (child.animationKeys.count > 0) {
	        animation = [child animationForKey:child.animationKeys[0]];
	        *stop = YES;
		}
	}];

	return animation;
}

@end
