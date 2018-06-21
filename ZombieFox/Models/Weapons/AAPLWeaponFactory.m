//
// AAPLWeaponFactory.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeaponFactory.h"
#import "AAPLWeaponShotgun.h"
#import "AAPLWeaponGrenade.h"
#import "AAPLWeaponFlameThrower.h"

@implementation AAPLWeaponFactory

+ (AAPLWeapon *)weaponWithType:(NSString *)type
{
	if ([type isEqualToString:AAPLWeaponTypeShotgun]) {
		return [AAPLWeaponShotgun new];
	} else if ([type isEqualToString:AAPLWeaponTypeGrenade]) {
		return [AAPLWeaponGrenade new];
	} else if ([type isEqualToString:AAPLWeaponTypeFlameThrower]) {
		return [AAPLWeaponFlameThrower new];
	}

	return nil;
}

+ (AAPLWeapon *)shotgun
{
	return [AAPLWeaponShotgun new];
}

+ (AAPLWeapon *)grenade
{
	return [AAPLWeaponGrenade new];
}

+ (AAPLWeapon *)flamethrower
{
	return [AAPLWeaponFlameThrower new];
}

+ (AAPLWeapon *)randomWeapon
{
	int random = arc4random_uniform(3);
	return random == 0 ? [AAPLWeaponShotgun new] : (random == 1 ? [AAPLWeaponGrenade new] : [AAPLWeaponFlameThrower new]);
}

@end
