//
//  AAPLItem.m
//  Fox OS X (Objective-C)
//
//  Created by Tomi De Lucca on 6/17/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

#import "AAPLItem.h"
#import "AAPLNodeManager.h"

@interface AAPLItem()
@property (nonatomic) ItemAction action;
@end

@implementation AAPLItem

- (instancetype)initWithAction:(ItemAction)action
{
    self = [self init];
    if (self) {
        self.action = action;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        SCNScene *scene = [SCNScene sceneNamed:@"game.scnassets/pearl.scn"];
        [self setupNodeWithScene:scene];
    }
    
    return self;
}

- (void)setupNodeWithScene:(SCNScene *)scene
{
    self.node = [SCNNode node];
    
    SCNScene *characterScene = scene;
    SCNNode *characterTopLevelNode = characterScene.rootNode.childNodes[0];
    
    characterTopLevelNode.physicsBody = [SCNPhysicsBody staticBody];
    characterTopLevelNode.physicsBody.categoryBitMask = AAPLBitmaskCollectable;
    
    [self.node addChildNode:characterTopLevelNode];
    
    [[AAPLNodeManager sharedManager] associateNode:self.node withModel:self];
    [[AAPLNodeManager sharedManager] associateNode:characterTopLevelNode withModel:self];
}

- (void)runActionWithPlayer:(AAPLPlayer*)player
{
    self.action(player);
}

- (void)setItemColor:(NSColor *)color
{
    SCNNode* pearl = self.node.childNodes[0];
    pearl.geometry.firstMaterial.diffuse.contents = color;
}

+ (AAPLItem*)itemForNode:(SCNNode*)node
{
    NSObject* model = [[AAPLNodeManager sharedManager] modelForAssociatedNode:node];
    
    if ([model isKindOfClass:[AAPLItem class]]) {
        return (AAPLItem*)model;
    }
    
    return nil;
}

@end
