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

@implementation AAPLWeaponFactory

+ (AAPLWeapon *)weaponWithConfiguration:(AAPLWeaponConfiguration *)configuration
{
	if (configuration.type == nil) {
		int rand = arc4random_uniform(3);
		configuration.type = rand == 0 ? AAPLWeaponTypeShotgun : rand == 1 ? AAPLWeaponTypeGrenade : AAPLWeaponTypeFlameThrower;
	}

	if ([configuration.type isEqualToString:AAPLWeaponTypeShotgun]) {
		AAPLWeaponShotgun *shotgun = [[AAPLWeaponShotgun alloc] initWithConfiguration:configuration];
		return shotgun;
    } else if ([configuration.type isEqualToString:AAPLWeaponTypeGrenade]) {
        AAPLWeaponGrenade *grenade = [[AAPLWeaponGrenade alloc] initWithConfiguration:configuration];
        return grenade;
    }

	return nil;
}

@end
