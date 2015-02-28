//
//  Sprite.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 2/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"sprite";
}

@end
