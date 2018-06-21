//
// AAPLWeaponPrivate.h
// ZombieFox
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#ifndef AAPLWeaponPrivate_h
#define AAPLWeaponPrivate_h

#import "AAPLGameStateManager.h"

@interface AAPLWeapon ()
@property (strong, nonatomic) SCNNode *node;
@property (nonatomic) CGFloat damage;
@property (strong, nonatomic) NSString *name;
@end

#endif /* AAPLWeaponPrivate_h */
