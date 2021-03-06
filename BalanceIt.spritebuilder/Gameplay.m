//
//  Gameplay.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "WinPopup.h"
#import "LosePopUp.h"
#import "Sprite.h"
#import "Level.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";
static BOOL isTutorialShown = false;

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_leftLaunchNode;
    CCNode *_rightLaunchNode;
    NSArray *_objectsArray;
    CCNode *_lever;
    
    CCLabelTTF *_timerLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_targetScoreLabel;
    CCLabelTTF *_levelLabel;
    int _timer;
    int _spriteCount;
    SEL _decrementSelector;
    BOOL _isScheduled;

    CCScene *_firstTutorial;
    CCScene *_secondTutorial;
    CCScene *_thirdTutorial;
    BOOL _pauseTimer;

    CCNode *_levelNode;
    Level *_loadedLevel;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    _pauseTimer = false;
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _objectsArray = [[NSArray alloc] initWithObjects:@"Bird", @"Tank", @"Television", @"Plane", @"Tree", @"House", @"Monster", @"SpaceShip", @"Bot", @"Frog", @"Dog", @"Donut", nil];
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    //_physicsNode.debugDraw = YES;
    
    _decrementSelector = @selector(decrement);
    [self schedule:_decrementSelector interval:1.0];
    _timer = _loadedLevel.timeLimit;
    [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer]];
    _isScheduled = true;
    _spriteCount = 0;
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", _spriteCount]];
    [_targetScoreLabel setString:[NSString stringWithFormat:@"%d", _loadedLevel.minScore]];
    [_levelLabel setString:[NSString stringWithFormat:@"%d", _loadedLevel.levelNumber]];

    if (!isTutorialShown) {
        _firstTutorial = [CCBReader loadAsScene:@"Tutorial"];
        [self addChild:_firstTutorial];
        isTutorialShown = true;
        _pauseTimer = true;
    }
}

- (void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Gameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

// called on every touch in this scene
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    if (_firstTutorial != nil) {
        [self removeChild:_firstTutorial];
        _secondTutorial = [CCBReader loadAsScene:@"SecondTutorial"];
        [self addChild:_secondTutorial];
        _firstTutorial = nil;
        return;
    } else if (_secondTutorial != nil) {
        [self removeChild:_secondTutorial];
        _thirdTutorial = [CCBReader loadAsScene:@"ThirdTutorial"];
        [self addChild:_thirdTutorial];
        _secondTutorial = nil;
        return;
    } else if (_thirdTutorial != nil) {
        [self removeChild:_thirdTutorial];
        _thirdTutorial = nil;
        _pauseTimer = false;
        return;
    }

    if (_isScheduled) {
        _spriteCount++;
        [self launchSprite:touchLocation];
        [_scoreLabel setString:[NSString stringWithFormat:@"%d", _spriteCount]];
    }
}

- (void)launchSprite:(CGPoint)touchLocation {
    NSUInteger randomNumber = arc4random_uniform((unsigned int) _loadedLevel.spriteCount);
    Sprite *object = (Sprite *) [CCBReader load:_objectsArray[randomNumber]];
    object.scale = object.scaleOnScreen;
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
    CGPoint force = ccpMult(launchDirection, 10);
    [object.physicsBody applyForce:force];

    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SpriteEntry"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = object.position;
    [self addChild:explosion];
}

- (void)update:(CCTime)delta {
    if (_timer == 0 && _isScheduled) {
        [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer]];
        [self unschedule:_decrementSelector];
        _isScheduled = false;

        CGPoint leverCorner = ccp(_lever.contentSize.width/2, 0);
        leverCorner = [_lever convertToWorldSpaceAR:leverCorner];

        CCNode *_rightLevelMarker = [_loadedLevel getRightLevelMarker];
        CGPoint topCornerRightMarker = ccp(_rightLevelMarker.contentSize.width/2, _rightLevelMarker.contentSize.height/2);
        topCornerRightMarker = [_rightLevelMarker convertToWorldSpaceAR:topCornerRightMarker];

        CGPoint bottomCornerRightMarker = ccp(_rightLevelMarker.contentSize.width/2, -_rightLevelMarker.contentSize.height/2);
        bottomCornerRightMarker = [_rightLevelMarker convertToWorldSpaceAR:bottomCornerRightMarker];

        [self setPaused:TRUE];
        if ((leverCorner.y - 10) >= bottomCornerRightMarker.y && (leverCorner.y + 10) <= topCornerRightMarker.y && _spriteCount >= _loadedLevel.minScore) {
            CCLOG(@"You Win!! :)");
            WinPopup *popup = (WinPopup *)[CCBReader load:@"WinPopup" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            [popup setScore:_spriteCount];
            [self addChild:popup];
        } else {
            CCLOG(@"You lose!! :(");
            LosePopUp *popup = (LosePopUp *)[CCBReader load:@"LosePopup" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            if (_spriteCount < _loadedLevel.minScore) {
                [popup setLossReason: @"Failed to meet target score"];
            } else {
                [popup setLossReason: @"Failed to achieve balance"];
            }
            [self addChild:popup];
        }
    }
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair sprite:(CCNode *)nodeA wall:(CCNode *)nodeB {
    [self spriteRemoved:nodeA];
}

- (void)spriteRemoved:(CCNode *)sprite {
    _spriteCount--;

    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SpriteExplosion"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = sprite.position;
    [sprite.parent addChild:explosion];

    [sprite removeFromParent];
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", _spriteCount]];
}

- (void)retry {
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

- (void)decrement {
    if (!_pauseTimer) {
        [_timerLabel setString:[NSString stringWithFormat:@"%d", _timer--]];
    }
}

@end
