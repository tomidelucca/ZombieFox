//
// AAPLWeaponPrivate.h
// ZombieFox
//
// Created by Tomi De Lucca on 6/20/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#ifndef AAPLWeaponPrivate_h
#define AAPLWeaponPrivate_h

@interface AAPLWeapon ()
@property (strong, nonatomic) SCNNode *node;
@property (weak, nonatomic) SCNScene *scene;
@property (nonatomic) CGFloat damage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) AAPLGameState *gameState;
@end

#endif /* AAPLWeaponPrivate_h */
