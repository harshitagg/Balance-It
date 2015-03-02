//
//  Gameplay.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_leftLaunchNode;
    CCNode *_rightLaunchNode;
    NSArray *_objectsArray;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _objectsArray = [[NSArray alloc] initWithObjects:@"Monster", @"SpaceShip", @"Donut", @"Frog", nil];
    _physicsNode.collisionDelegate = self;
   // _physicsNode.debugDraw = YES;
}

// called on every touch in this scene
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self launchMonster:touchLocation];
}

- (void)launchMonster:(CGPoint)touchLocation {
    NSUInteger randomNumber = arc4random_uniform((unsigned int) _objectsArray.count);
    CCNode* object = [CCBReader load:_objectsArray[randomNumber]];
    object.scale = 0.5;
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    if (touchLocation.x > winSize.width/2) {
        object.position = _rightLaunchNode.position;
    }
    else {
        object.position = _leftLaunchNode.position;
    }
    
    // add the penguin to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:object];
    
    // manually create & apply a force to launch the penguin
    CGPoint launchDirection = ccp(0, 0);
    CGPoint force = ccpMult(launchDirection, 0);
    [object.physicsBody applyForce:force];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair sprite:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    //Set kinetic energy as zero
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair sprite:(CCNode *)nodeA wall:(CCNode *)nodeB {
    [self spriteRemoved:nodeA];
}

- (void)spriteRemoved:(CCNode *)sprite {
    [sprite removeFromParent];
}

- (void)retry {
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

@end
