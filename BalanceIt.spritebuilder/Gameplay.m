//
//  Gameplay.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "WinPopup.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_leftLaunchNode;
    CCNode *_rightLaunchNode;
    CCNode *_rightLevelMarker;
    NSArray *_objectsArray;
    CCNode *_lever;
    
    CCLabelTTF *_timerLabel;
    int _timer;
    int _spriteCount;
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
    _spriteCount = 0;
}

// called on every touch in this scene
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    if (_isScheduled) {
        _spriteCount++;
        [self launchMonster:touchLocation];
    }
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
        
        CGPoint leverCorner = ccp(_lever.contentSize.width/2, 0);
        leverCorner = [_lever convertToWorldSpaceAR:leverCorner];
        
        CGPoint topCornerRightMarker = ccp(_rightLevelMarker.contentSize.width/2, _rightLevelMarker.contentSize.height/2);
        topCornerRightMarker = [_rightLevelMarker convertToWorldSpaceAR:topCornerRightMarker];
        
        CGPoint bottomCornerRightMarker = ccp(_rightLevelMarker.contentSize.width/2, -_rightLevelMarker.contentSize.height/2);
        bottomCornerRightMarker = [_rightLevelMarker convertToWorldSpaceAR:bottomCornerRightMarker];
        
        [self setPaused:TRUE];
        if ((leverCorner.y - 10) >= bottomCornerRightMarker.y && (leverCorner.y + 10) <= topCornerRightMarker.y) {
            CCLOG(@"You Win!! :)");
            WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            [popup setScore:_spriteCount];
            [self addChild:popup];
        } else {
            CCLOG(@"You loose!! :(");
        }

    }
}

- (BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair sprite:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    //nodeA.physicsBody.velocity = ccp(0,0);
    //nodeB.physicsBody.elasticity = 0;
    return true;
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
