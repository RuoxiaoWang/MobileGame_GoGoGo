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
    
    int _score; // Store the score
    
    double _operateAlien1; // Count the time to launch and delete an Alien1
    double _operateAlien2; // Count the time to launch and delete an Alien2
    
    NSMutableArray *alien1s; // Store all alien1
    NSMutableArray *alien2s; // Store all alien2
    
}

-(void) didLoadFromCCB
{
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadGame];

    // generate Alien1
    
    _operateAlien1 = 0.0;
    
    _scoreLabel.visible = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:(@selector(countScore)) userInfo:nil repeats:YES];
    
    alien1s = [[NSMutableArray alloc] init];
    alien2s = [[NSMutableArray alloc] init];
    
    // generate 10 Alien1
    for (int i=0; i<10; i++) {
        [self launchAlien1];
    }
    
    // generate 2 Alien2
    for (int i=0; i<2; i++) {
        [self launchAlien2];
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


// Launch Alien1
-(void)launchAlien1
{
    // Load the Alien1.cbb
    CCNode* alien1 = [CCBReader load:@"Alien1"];
    // Add the alien1 to the array alien1s
    [alien1s addObject:alien1];
    
    // set the alien1 location(1920 1080)
    alien1.position = ccpAdd(ccp(arc4random_uniform(100), arc4random_uniform(100)),
                           ccp(arc4random_uniform(100),arc4random_uniform(100)));
    // add alien1 to physicsNode
    [_physicsNode addChild:alien1];
}

-(void)deleteAlien1
{
    CCNode *alien1 = [alien1s objectAtIndex: 0]; // Find the alien1 at index 0
    [alien1 removeFromParent]; // remove it from Scene
    [alien1s removeObjectAtIndex:0]; // remove it from the array alien1s
}


// Launch Alien2
-(void)launchAlien2
{
    // Load the Alien2.cbb
    CCNode* alien2 = [CCBReader load:@"Alien2"];
    // Add the alien1 to the array alien1s
    [alien2s addObject:alien2];
    
    // set the alien2 location(1920 1080)
    alien2.position = ccpAdd(ccp(arc4random_uniform(100), arc4random_uniform(100)),
                             ccp(arc4random_uniform(100),arc4random_uniform(100)));
    // add alien2 to physicsNode
    [_physicsNode addChild:alien2];
}

-(void)deleteAlien2
{
    CCNode *alien2 = [alien2s objectAtIndex: 0]; // Find the alien2 at index 0
    [alien2 removeFromParent]; // remove it from Scene
    [alien2s removeObjectAtIndex:0]; // remove it from the array alien2s
}

// Accelerate the player node as needed
-(void) update:(CCTime)delta
{
    _operateAlien1 += delta;
    _operateAlien2 += delta;
    
    // if _operateAlien1 large than 10 seconds, do the following operations
    if(_operateAlien1 > 1.5f){
        
        // Delete an Alien1
        [self deleteAlien1];
        // Add an Alien1
        [self launchAlien1];
        
        _operateAlien1 = 0.0f;
        
    }
    
    // if _operateAlien2 large than 20 seconds, do the following operations
    if(_operateAlien2 > 15.0f){
        
        // Delete an Alien1
        [self deleteAlien2];
        // Add an Alien1
        [self launchAlien2];
        
        _operateAlien2 = 0.0f;
        
    }
    
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

// Set the method when collide with the alien1
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                           alien1:(CCNode *)alien1
{
    // When touching the alien1, add 100 to the score
    _score += 100;
    // Set the score to the scoreLabel
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    _scoreLabel.visible = YES;
    // Remove the alien1 touched
    [alien1s removeObject:alien1];
    // Remove the alien1 from the array alien1s
    [alien1 removeFromParent];
    // Add an alien1 to the screen
    [self launchAlien1];
    return NO;
}

// Set the method when collide with the alien2
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                         alien2:(CCNode *)alien2
{
    // When touching the alien2, add 100 to the score
    _score += 500;
    // Set the score to the scoreLabel
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    _scoreLabel.visible = YES;
    // Remove the alien2 touched
    [alien2s removeObject:alien2];
    // Remove the alien2 from the array alien1s
    [alien2 removeFromParent];
    // Add an alien1 to the screen
    [self launchAlien2];
    return NO;
}
@end
