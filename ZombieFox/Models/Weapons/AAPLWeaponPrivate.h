//
//  AAPLWeaponPrivate.h
//  ZombieFox
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#ifndef AAPLWeaponPrivate_h
#define AAPLWeaponPrivate_h

@interface AAPLWeapon()
@property (weak, nonatomic) SCNScene* scene;
@property (weak, nonatomic) AAPLPlayer* player;
@property (nonatomic) CGFloat damage;
@property (strong, nonatomic) NSString* name;
@end

#endif /* AAPLWeaponPrivate_h */
