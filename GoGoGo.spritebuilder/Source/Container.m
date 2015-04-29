//
//  Container.m
//  GoGoGo
//
//  Created by longma on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Container.h"
#import "Alien1.h"
#import "Alien2.h"
#import "Star.h"
#import "GameOver.h"
#import "OALSimpleAudio.h"
#import "Pause.h"

@implementation Container

// variable declarations (ivars)
{
    CCNode* _levelNode;
    CCPhysicsNode* _physicsNode;
    CCNode* _playerNode;
    CCNode* _backgroundNode;
    CCLabelTTF *_scoreLabel;
    NSTimer *_myTime;
    
    Pause *pause;
    
    OALSimpleAudio* audio;
    OALSimpleAudio* audio1;
    OALSimpleAudio* audio3;
    
    BOOL *_jumped;
    
    int _score; // Store the score
    double _speed1; // High level star speed
    double _speed2; // Low level star speed
    
    double _operateAlien1; // Count the time to launch and delete an Alien1
    double _operateAlien2; // Count the time to launch and delete an Alien2
    double _operateLowStar; // Count the time to launch and delete an low level Star
    double _operateHighStar; // Count the time to launch and delete an high level Star
    
    NSMutableArray *alien1s; // Store all alien1
    NSMutableArray *alien2s; // Store all alien2
    NSMutableArray *lowStars; // Store all low level stars
    NSMutableArray *highStars; // Store all low level stars
    
}

-(void) didLoadFromCCB
{
    
    _speed1 = 180.0f;
    _speed2 = 40.0f;
    // enable receiving input events
    self.userInteractionEnabled = YES;
    // load the current level
    [self loadGame];

    // generate Alien1
    
    _operateAlien1 = 0.0;
    _operateAlien2 = 0.0;
    _operateLowStar = 0.0;
    
    _scoreLabel.visible = YES;
    _myTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:(@selector(countScore)) userInfo:nil repeats:YES];
    
    alien1s = [[NSMutableArray alloc] init];
    alien2s = [[NSMutableArray alloc] init];
    lowStars = [[NSMutableArray alloc] init];
    highStars = [[NSMutableArray alloc] init];
    
    // generate 10 Alien1
    for (int i=0; i<20; i++) {
        [self launchAlien1];
    }
    
    // generate 2 Alien2
    for (int i=0; i<10; i++) {
        [self launchAlien2];
    }
    
    // generate initial low level stars
    for(int i=100;i<=700;i=i+100){
        [self launchLowStar:i];
    }
    
    // generate initial high level stars
    for(int i=800;i<=1080;i=i+100){
        [self launchHighStar:i];
    }
    
    // Set background audio
    audio1 = [OALSimpleAudio sharedInstance];
    [audio1 stopBg];
    
    audio3 = [OALSimpleAudio sharedInstance];
    [audio3 stopBg];
    
    audio = [OALSimpleAudio sharedInstance];
    [audio playBg:@"background1.mp3" loop:YES];
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
    CGPoint pos1 = [touch locationInNode:self];
    CGPoint pos2 = [touch locationInNode:_levelNode];
        
//    // if touch position<300, jump to left
//    if(pos1.x<300){
//        //if location<=700
//        if(pos2.y<=700){
//            if(lastTouch-firstTouch<1.0f){
//                [_playerNode.physicsBody applyImpulse:ccp(-700,2000)];
//            }else{
//                if (!_jumped) {
//                    [_playerNode.physicsBody applyImpulse:ccp(-800,3200)];
//                    _jumped = TRUE;
//                    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.0f];
//                }
//            }
//        // if location>700
//        }else{
//            [_playerNode.physicsBody applyImpulse:ccp(-800,3200)];
//        }
//    }
//    // if touch position>300, jump to right
//    if(pos1.x>=300){
//        //if location<=700
//        if(pos2.y<=700){
//            if(lastTouch-firstTouch<1.0f){
//                [_playerNode.physicsBody applyImpulse:ccp(700,2000)];
//            }else{
//                if (!_jumped) {
//                    [_playerNode.physicsBody applyImpulse:ccp(800,3200)];
//                    _jumped = TRUE;
//                    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.0f];
//                }
//            }
//            // if location>700
//        }else{
//            [_playerNode.physicsBody applyImpulse:ccp(800,3200)];
//        }
//    }
    
//    if(pos1.x<300){
//        [_playerNode stopActionByTag:1];
//        CGPoint pos = CGPointMake(-(2000.0-_playerNode.position.x),_playerNode.position.y);
//        CCAction* move = [CCActionMoveTo actionWithDuration:18.0 position:pos];
//        move.tag = 1;
//        [_playerNode runAction:move];
//    }
//    if(pos1.x>=300){
//        [_playerNode stopActionByTag:1];
//        CGPoint pos = CGPointMake(_playerNode.position.x+2000.0,_playerNode.position.y);
//        CCAction* move = [CCActionMoveTo actionWithDuration:18.0 position:pos];
//        move.tag = 1;
//        [_playerNode runAction:move];
//    }
    
    
    
    // if touch position<300, jump to left
    if(pos1.x<300){
        // if location<=700
        if(pos2.y<=700){
            if (!_jumped) {
                [_playerNode.physicsBody applyImpulse:ccp(-800,3400)];
                _jumped = TRUE;
                [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.6f];
            }
        // if location>700
        }else{
            [_playerNode.physicsBody applyImpulse:ccp(-400,2500)];
        }
    // if touch position>300, jump to right
    }else{
        // if location<=700
        if(pos2.y<=700){
            if (!_jumped) {
                [_playerNode.physicsBody applyImpulse:ccp(800,3400)];
                _jumped = TRUE;
                [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.6f];
            }
        // if location>700
        }else{
            [_playerNode.physicsBody applyImpulse:ccp(400,2500)];
        }
    }
}


// Reset jump
-(void)resetJump
{
    _jumped = FALSE;

}

// Launch Alien1
-(void)launchAlien1
{
    // Load the Alien1.cbb
    CCNode* alien1 = [CCBReader load:@"Alien1"];
    // Add the alien1 to the array alien1s
    [alien1s addObject:alien1];
    
    // set the alien1 location(1920 1080)
    alien1.position = ccp(arc4random_uniform(1920), arc4random_uniform(1080));
    // add alien1 to physicsNode
    [_physicsNode addChild:alien1];
}

// Delete Alien1
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
    alien2.position = ccp(arc4random_uniform(1920), 1080 - arc4random_uniform(380));
    // add alien2 to physicsNode
    [_physicsNode addChild:alien2];
}

// Delete Alien2
-(void)deleteAlien2
{
    CCNode *alien2 = [alien2s objectAtIndex: 0]; // Find the alien2 at index 0
    [alien2 removeFromParent]; // remove it from Scene
    [alien2s removeObjectAtIndex:0]; // remove it from the array alien2s
}

// Launch Low Level Star
-(void)launchLowStar: (int) height
{

    // Load the Star.cbb
    CCNode* star = [CCBReader load:@"Star"];
    // Add the star to the array stars
    [lowStars addObject:star];
    [_physicsNode addChild:star];
    
    star.position = ccp(0, height);
}

// Launch High Level Star
-(void)launchHighStar: (int) height
{
    
    // Load the Star.cbb
    CCNode* star = [CCBReader load:@"Star"];
    // Add the star to the array stars
    [highStars addObject:star];
    [_physicsNode addChild:star];
    
    star.position = ccp(0, height);
}

// Accelerate the player node as needed
-(void) update:(CCTime)delta
{
    _operateAlien1 += delta;
    _operateAlien2 += delta;
    _operateLowStar += delta;
    _operateHighStar += delta;
    
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
    
    // launch low level star every 12 seconds
    if(_operateLowStar > 8.0f){
        for(int i=100;i<=700;i=i+100){
            [self launchLowStar:i];
        }
        _operateLowStar = 0.0f;
    }
    // keep stars moving
    for(int i=0;i<lowStars.count;i++){
        CCNode *star = [lowStars objectAtIndex: i];
        star.position = ccp(star.position.x + _speed2*delta, star.position.y);
    }
    
    // launch high level star every 8 seconds
    if(_operateHighStar > 4.0f){
        for(int i=800;i<=1080;i=i+100){
            [self launchHighStar:i];
        }
        _operateHighStar = 0.0f;
    }
    // keep stars moving
    for(int i=0;i<highStars.count;i++){
        CCNode *star = [highStars objectAtIndex: i];
        star.position = ccp(star.position.x + _speed2*delta, star.position.y);
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
    _levelNode.positionInPoints = ccpNeg(viewPos);
    
}

// Set the method when player collide with the alien1
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                           alien1:(CCNode *)alien1
{
    // load particle effect
    CCParticleSystem *explosion1 = (CCParticleSystem *)[CCBReader load:@"Alien1Explosion"];
    // make the particle effect clean itself up, once it is completed
    explosion1.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion1.position = alien1.position;
    // add the particle effect to the same node the seal is on
    [alien1.parent addChild:explosion1];
    
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

// Set the method when player collide with the alien2
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                         alien2:(CCNode *)alien2
{
    // load particle effect
    CCParticleSystem *explosion2 = (CCParticleSystem *)[CCBReader load:@"Alien2Explosion"];
    // make the particle effect clean itself up, once it is completed
    explosion2.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion2.position = alien2.position;
    // add the particle effect to the same node the seal is on
    [alien2.parent addChild:explosion2];
    
    
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


// Set the method when player collide with the star
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         player:(CCNode *)player
                         star:(CCNode *)star
{
    // Pause the game
    self.paused = YES;
    
    audio = [OALSimpleAudio sharedInstance];
    [audio playBg:@"failed.mp3" loop:NO];
    
    // pause and clear the score
    [_myTime invalidate];
    _myTime = nil;
    // When touching the star, game over
    GameOver *gameover = (GameOver *)[CCBReader load:@"GameOver" owner:self];
    gameover.positionType = CCPositionTypeNormalized;
    gameover.position = ccp(0.5,0.5);
    [self addChild:gameover];
    
    return NO;
}

// Set the method when star collide with the right bar
-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         star:(CCNode *)star
                           rightBar:(CCNode *)rightBar
{
    if(star.position.y<=700){
        [lowStars removeObject:star];
        [star removeFromParent];
        
    }else{
        [highStars removeObject:star];
        [star removeFromParent];
    }
    
    return NO;
}



// Set the loadMainScene method
-(void)loadMainScene
{

    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:mainScene withTransition:transition];
    
}

// Set the restart method
-(void)restart
{

    CCScene *container = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:container withTransition:transition];
}


-(void)loadPause
{
    // Pause the game
    self.paused = YES;
    
    [_myTime invalidate];
    // When enter the pause button, pause
    pause = (Pause *)[CCBReader load:@"Pause" owner:self];
    pause.positionType = CCPositionTypeNormalized;
    pause.position = ccp(0.5,0.5);
    [self addChild:pause];
}

// Set the resume method
-(void)resume
{
    _myTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:(@selector(countScore)) userInfo:nil repeats:YES];
    [self removeChild:pause];
    self.paused = NO;
}

@end
