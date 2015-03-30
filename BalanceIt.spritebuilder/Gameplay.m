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
    CCNode *_rightLevelMarker;
    NSArray *_objectsArray;
    CCNode *_lever;
    
    CCLabelTTF *_timerLabel;
    int _timer;
    SEL _decrementSelector;
    BOOL _isScheduled;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    _timer = 10;
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _objectsArray = [[NSArray alloc] initWithObjects:@"Monster", @"SpaceShip", @"Donut", @"Frog", nil];
    _physicsNode.collisionDelegate = self;
   // _physicsNode.debugDraw = YES;
    
    _decrementSelector = @selector(decrement);
    [self schedule:_decrementSelector interval:1.0];
    [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer]];
    _isScheduled = true;
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

- (void)update:(CCTime)delta {
    if (_timer == 0 && _isScheduled) {
        [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer]];
        [self unschedule:_decrementSelector];
        _isScheduled = false;
        

    }
    float f = _lever.positionInPoints.x;
    CCLOG(@"-----%f", _lever.positionInPoints.y);
    CGPoint topRight = ccp(f + _lever.contentSize.width, _lever.positionInPoints.y + _lever.contentSize.height);
    //CGPoint topRightWorldLever = [self convertToNodeSpace:[self convertToWorldSpace:topRight]];
    CGPoint topRightWorldLever = [_rightLevelMarker convertToWorldSpace:topRight];
    CCLOG(@"%f", topRightWorldLever.y);
    
    CGPoint topRightMarker = ccp(_rightLevelMarker.positionInPoints.x + _rightLevelMarker.contentSize.width, _rightLevelMarker.positionInPoints.y + _rightLevelMarker.contentSize.height);
    CGPoint topRightWorldMarker = [_rightLevelMarker convertToWorldSpace:topRightMarker];
    CCLOG(@"%f", topRightWorldMarker.y);
    
    CGPoint bottomRightMarker = ccp(_rightLevelMarker.positionInPoints.x + _rightLevelMarker.contentSize.width, _rightLevelMarker.positionInPoints.y);
    CGPoint bottomRightWorldMarker = [_rightLevelMarker convertToWorldSpace:bottomRightMarker];
    CCLOG(@"%f", bottomRightWorldMarker.y);
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

- (void)decrement {
    [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer--]];
}

@end
