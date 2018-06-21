//
// AAPLItemFactory.h
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLItem.h"

@interface AAPLItemFactory : NSObject
+ (AAPLItem *)healthItemWithLife:(CGFloat)life;
+ (AAPLItem *)speedItemWithSpeed:(CGFloat)speed forInterval:(NSTimeInterval)interval;
+ (AAPLItem *)shieldForInterval:(CGFloat)interval;
+ (AAPLItem *)damageForCharacter:(CGFloat)damage;
+ (AAPLItem *)weaponItem;
+ (AAPLItem *)randomItemForScene:(SCNScene *)scene;
@end
