//
//  AAPLWeapon.h
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/20/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "AAPLWeaponConfiguration.h"

@interface AAPLWeapon : NSObject
@property (strong, nonatomic, readonly) SCNNode* node;
@property (strong, nonatomic, readonly) NSString* name;

- (instancetype)initWithConfiguration:(AAPLWeaponConfiguration*)configuration;

- (void)pullTheTrigger;

@end
