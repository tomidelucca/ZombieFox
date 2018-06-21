//
// AAPLWeapon.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeapon.h"
#import "AAPLWeaponPrivate.h"

@implementation AAPLWeapon

- (instancetype)initWithDamage:(CGFloat)damage
{
	self = [super init];
	if (self) {
		self.damage = damage;
	}
	return self;
}

- (void)pullTheTrigger
{
}

- (void)releaseTheTrigger
{
}

- (void)dealloc
{
	[self releaseTheTrigger];
}

@end
