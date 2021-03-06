//
//  Level.h
//  BalanceIt
//
//  Created by Harshit Agarwal on 4/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, copy) NSString *nextLevelName;
@property (nonatomic, assign) int levelNumber;
@property (nonatomic, assign) int spriteCount;
@property (nonatomic, assign) int timeLimit;
@property (nonatomic, assign) int minScore;

- (CCNode *)getRightLevelMarker;

@end
