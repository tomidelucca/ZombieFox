//
// AAPLPlayer.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/16/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLCharacter.h"
#import "AAPLWeapon.h"

@class AAPLPlayer;

@protocol AAPLPlayerDelegate <NSObject>
- (void)player:(AAPLPlayer *)player selectedWeaponDidChange:(AAPLWeapon *)newWeapon;
@end

@interface AAPLPlayer : AAPLCharacter
@property (weak, nonatomic) id <AAPLPlayerDelegate> playerDelegate;
@property (strong, nonatomic) AAPLWeapon *weapon;
+ (AAPLPlayer *)playerForNode:(SCNNode *)node;
- (void)shoot;
- (void)letGo;
@end
