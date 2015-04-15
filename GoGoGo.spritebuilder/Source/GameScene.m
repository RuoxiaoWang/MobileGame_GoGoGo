//
//  GameScene.m
//  GoGoGo
//
//  Created by longma on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void) didLoadFromCCB
{
    NSLog(@"GameScene created");
}

-(void) exitButtonPressed
{
    NSLog(@"Get me outa here!");
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

@end
