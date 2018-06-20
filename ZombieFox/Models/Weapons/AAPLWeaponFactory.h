//
//  AAPLWeaponFactory.h
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAPLWeapon.h"

@interface AAPLWeaponFactory : NSObject
+ (AAPLWeapon*)weaponWithConfiguration:(AAPLWeaponConfiguration*)configuration;
@end
