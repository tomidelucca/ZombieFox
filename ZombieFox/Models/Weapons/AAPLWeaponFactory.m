//
//  AAPLWeaponFactory.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLWeaponFactory.h"
#import "AAPLWeaponShotgun.h"

@implementation AAPLWeaponFactory

+ (AAPLWeapon*)weaponWithConfiguration:(AAPLWeaponConfiguration*)configuration
{
    if (configuration.weaponType == nil) {
        int rand = arc4random_uniform(3);
        configuration.weaponType = rand == 0 ? AAPLWeaponTypeShotgun : rand == 1 ? AAPLWeaponTypeGranade : AAPLWeaponTypeFlameThrower;
    }
    
    if ([configuration.weaponType isEqualToString:AAPLWeaponTypeShotgun]) {
        AAPLWeaponShotgun* shotgun = [[AAPLWeaponShotgun alloc] initWithConfiguration:configuration];
        return shotgun;
    }
    
    return nil;
}

@end
