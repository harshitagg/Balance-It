//
//  WinPopup.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 4/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WinPopup.h"

@implementation WinPopup {
    CCLabelTTF *_scoreLabel;
}

- (void)setScore:(int)score {
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
}

@end
