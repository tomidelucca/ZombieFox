//
// AAPLNodeManager.m
// Fox OS X (Objective-C)
//
// Created by Tomi De Lucca on 6/17/18.
// Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLNodeManager.h"

@interface AAPLNodeManager ()
@property (strong, nonatomic) NSMapTable <SCNNode *, NSObject *> *nodes;
@end

@implementation AAPLNodeManager

+ (id)sharedManager
{
	static AAPLNodeManager *sharedMyManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedMyManager = [[self alloc] init];
		sharedMyManager.nodes = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
	});
	return sharedMyManager;
}

- (void)associateNode:(SCNNode *)node withModel:(id)model
{
	[self.nodes setObject:model forKey:node];
}

- (id)modelForAssociatedNode:(SCNNode *)node
{
	return [self.nodes objectForKey:node];
}

@end
