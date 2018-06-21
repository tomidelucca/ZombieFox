//
// AAPLItemFactory.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLItemFactory.h"
#import "AAPLWeaponFactory.h"

@implementation AAPLItemFactory

+ (AAPLItem *)healthItemWithLife:(CGFloat)life
{
	AAPLItem *item = [[AAPLItem alloc] initWithAction: ^(AAPLPlayer *player) {
	    [player giveLife:life];
	}];

	[item setItemColor:[NSColor greenColor]];

	return item;
}

+ (AAPLItem *)speedItemWithSpeed:(CGFloat)speed forInterval:(NSTimeInterval)interval
{
	AAPLItem *item = [[AAPLItem alloc] initWithAction: ^(AAPLPlayer *player) {
	    [player speedMultiplier:speed forInterval:interval];
	}];

	[item setItemColor:[NSColor redColor]];

	return item;
}

+ (AAPLItem *)shieldForInterval:(CGFloat)interval
{
	AAPLItem *item = [[AAPLItem alloc] initWithAction: ^(AAPLPlayer *player) {
	    [player invulnerableForInterval:interval];
	}];

	[item setItemColor:[NSColor cyanColor]];

	return item;
}

+ (AAPLItem *)damageForCharacter:(CGFloat)damage
{
	AAPLItem *item = [[AAPLItem alloc] initWithAction: ^(AAPLPlayer *player) {
	    [player takeLife:damage];
	}];

	[item setItemColor:[NSColor orangeColor]];

	return item;
}

+ (AAPLItem *)weaponItem
{
	AAPLItem *item = [[AAPLItem alloc] initWithAction: ^(AAPLPlayer *player) {
	    AAPLWeapon *weapon = [AAPLWeaponFactory randomWeapon];
	    player.weapon = weapon;
	}];

	[item setItemColor:[NSColor purpleColor]];

	return item;
}

+ (AAPLItem *)randomItemForScene:(SCNScene *)scene
{
	int random = arc4random_uniform(4);
	AAPLItem *item = nil;

	if (random == 0) {
		CGFloat life = arc4random_uniform(20.0f) + 10.0f;
		item = [AAPLItemFactory healthItemWithLife:life];
	} else if (random == 1) {
		CGFloat speed = (double)arc4random_uniform(10.0f) / 10.0f + 1;
		int time = arc4random_uniform(5) + 2;
		item = [AAPLItemFactory speedItemWithSpeed:speed forInterval:time];
	} else if (random == 2) {
		int time = arc4random_uniform(5) + 5;
		item = [AAPLItemFactory shieldForInterval:time];
	} else if (random == 3) {
		item = [AAPLItemFactory weaponItem];
	}

	return item;
}

@end
