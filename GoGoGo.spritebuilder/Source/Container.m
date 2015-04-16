//
//  Container.m
//  GoGoGo
//
//  Created by longma on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Container.h"

@implementation Container

// variable declarations (ivars)
{
    CCNode* _levelNode;
    CCPhysicsNode* _physicsNode;
    CCNode* _playerNode;
    CCNode* _backgroundNode;
    CCLabelTTF *_scoreLabel;
    BOOL _jumped;
    
    int _score;
    
}

-(void) didLoadFromCCB
{
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadGame];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:(@selector(countScore)) userInfo:nil repeats:YES];
    _scoreLabel.visible = YES;
    
}

// Assigning physics, background, and player node in loadLevelNamed
-(void) loadGame
{
    
    _physicsNode = (CCPhysicsNode*)[_levelNode getChildByName:@"physics" recursively:NO];
    // get the current level's player in the scene by searching for it recursively
    _backgroundNode = [_levelNode getChildByName:@"background" recursively:NO];
    _playerNode = [_physicsNode getChildByName:@"player" recursively:YES];
}

-(void) countScore
{
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    _scoreLabel.visible = YES;

}

// Move the player to the touch location
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_playerNode stopActionByTag:1];
    CGPoint pos = [touch locationInNode:_levelNode];
    CCAction* move = [CCActionMoveTo actionWithDuration:1.2 position:pos];
    move.tag = 1;
    [_playerNode runAction:move];
    // Enable the "user is currently touching the screen" mode
    // _acceleratePlayer = YES;
}


// Accelerate the player node as needed
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
    CGSize screenSize = _levelNode.contentSizeInPoints;
    viewPos.x = MAX(0.0, MIN(viewPos.x, screenSize.width - viewSize.width));
    viewPos.y = MAX(0.0, MIN(viewPos.y, screenSize.height - viewSize.height));
    // We should get the reference to the _physicsNode first because it’s being used to search for the player
    _levelNode.positionInPoints = ccpNeg(viewPos);
    
}


@end
