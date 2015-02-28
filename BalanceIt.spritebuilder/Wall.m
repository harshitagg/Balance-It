//
//  Wall.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 2/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Wall.h"

@implementation Wall

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"wall";
}

@end
