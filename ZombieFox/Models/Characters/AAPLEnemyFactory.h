//
//  AAPLEnemyFactory.h
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/17/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLEnemy.h"

@interface AAPLEnemyFactory : NSObject
+ (AAPLEnemy*)mummyWithLife:(CGFloat)life andStrength:(CGFloat)strength;
@end
