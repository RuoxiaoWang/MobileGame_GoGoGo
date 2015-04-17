//
//  Container.m
//  GoGoGo
//
//  Created by longma on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Container.h"
#import "Alien1.h"

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
    double _lanchAlien1;
    double _deleteAlien1;
    int _index;
    
    NSMutableArray *alien1s;
    
}

-(void) didLoadFromCCB
{
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadGame];

    // generate Alien1
    
    _lanchAlien1 = 0.0;
    _index = 0;

    
    
    _scoreLabel.visible = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:(@selector(countScore)) userInfo:nil repeats:YES];
    
    alien1s = [[NSMutableArray alloc] init];
    
    // generate 10 Aliens
    for (int i=0; i<5; i++) {
        [self launchAlien1];
    }
    
}

// Assigning physics, background, and player node in loadLevelNamed
-(void) loadGame
{
    
    _physicsNode = (CCPhysicsNode*)[_levelNode getChildByName:@"physics" recursively:NO];
    _physicsNode.collisionDelegate = self;
    // get the current level's player in the scene by searching for it recursively
    _backgroundNode = [_levelNode getChildByName:@"background" recursively:NO];
    _playerNode = [_physicsNode getChildByName:@"player" recursively:YES];
}


-(void)launchAlien1
{
    // Load the Alien1.cbb
    CCNode* alien1 = [CCBReader load:@"Alien1"];
    [alien1s addObject:alien1];
    
    // 1920 1080
    alien1.position = ccpAdd(ccp(arc4random_uniform(100), arc4random_uniform(100)),
                           ccp(arc4random_uniform(100),arc4random_uniform(100)));
    // add coin to physicsNode
    [_physicsNode addChild:alien1];
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
    _lanchAlien1 += delta;
    _deleteAlien1 += delta;
    
    if(_lanchAlien1 > 4.0f){
        
        // Delete an Alien1
        [self deleteAlien1];
        // Add an Alien1
        [self launchAlien1];
        
        _lanchAlien1 = 0.0f;
        
    }
    // Update scroll node position to player node, with offset to center player in the view
    
    [self scrollToTarget:_playerNode];

    
}

-(void)deleteAlien1
{
    CCNode *alien1 = [alien1s objectAtIndex: 0];
    [alien1 removeFromParent];
    [alien1s removeObjectAtIndex:0];
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


-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                           alien1:(CCNode *)alien1
{
    _score += 100;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    _scoreLabel.visible = YES;
    [alien1 removeFromParent];
    return NO;
}

@end
