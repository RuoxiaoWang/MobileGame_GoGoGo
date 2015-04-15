//
//  GameScene.m
//  GoGoGo
//
//  Created by longma on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
// variable declarations (ivars)
{
    __weak CCNode* _levelNode;
    __weak CCPhysicsNode* _physicsNode;
    __weak CCNode* _playerNode;
    __weak CCNode* _backgroundNode;
}

-(void) didLoadFromCCB
{
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadPlayer];
}

-(void) exitButtonPressed
{
    NSLog(@"Get me outa here!");
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition* transition = [CCTransition transitionFadeWithDuration:1.5];
    [[CCDirector sharedDirector] presentScene:scene withTransition:transition];
}

// Get the player node by its name
-(void) loadPlayer
{
    // get the current level's player in the scene by searching for it recursively
    _playerNode = [self getChildByName:@"player" recursively:YES];
}

// Move the player to the touch location
-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    [_playerNode stopActionByTag:1];
    CGPoint pos = [touch locationInNode:self];
    CCAction* move = [CCActionMoveTo actionWithDuration:20.2 position:pos];
    move.tag = 1;
    [_playerNode runAction:move];
}

@end
