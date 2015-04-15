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
    // Stop the existing action with the same tag before running the new one
    [_playerNode stopActionByTag:1];
    //  Define the touch range
    CGPoint pos = [touch locationInNode:self];
    //Moving the player smoothly with a move action
    CCAction* move = [CCActionMoveTo actionWithDuration:1.2 position:pos];
    move.tag = 1;
    [_playerNode runAction:move];
}

-(void) update:(CCTime)delta
{
    // Update scroll node position to player node, with offset to center player in the view
    [self scrollToTarget:_playerNode];
}

-(void) scrollToTarget:(CCNode*)target
{
    // Assign the size of the view to viewSize
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    // The center point of the view is calculated and assigned to viewCenter
    CGPoint viewCenter = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    // Keeps the target node centered in the view
    CGPoint viewPos = ccpSub(target.positionInPoints, viewCenter);
    CGSize screenSize = self.contentSizeInPoints;
    viewPos.x = MAX(0.0, MIN(viewPos.x, screenSize.width - viewSize.width));
    viewPos.y = MAX(0.0, MIN(viewPos.y, screenSize.height - viewSize.height));
    self.positionInPoints = ccpNeg(viewPos);
}

@end
