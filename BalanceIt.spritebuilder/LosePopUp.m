//
//  LosePopUp.m
//  BalanceIt
//
//  Created by Harshit Agarwal on 4/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LosePopUp.h"

@implementation LosePopUp {
    CCLabelTTF *_lossReasonLabel;
}

- (void)setLossReason:(NSString *)reason {
    [_lossReasonLabel setString:[NSString stringWithFormat:@"%@", reason]];
}

@end
