//
// AAPLCollisionMasks.h
// ZombieFox
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#ifndef AAPLCollisionMasks_h
#define AAPLCollisionMasks_h

typedef NS_OPTIONS (NSUInteger, AAPLBitmask) {
	AAPLBitmaskPlayer      = 1UL << 1,
	AAPLBitmaskCollectable = 1UL << 2,
	AAPLBitmaskEnemy       = 1UL << 3,
	AAPLBitmaskCollision   = 1UL << 4
};

#endif
