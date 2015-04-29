//
//  Instruction.m
//  GoGoGo
//
//  Created by longma on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction
{
    CCNode* _levelNode1;
    CCNode* _viewNode;
    CCPhysicsNode* _physicsNode;
    NSTimer *_myTime;
    double position;
    
    OALSimpleAudio* audio1;
    OALSimpleAudio* audio3;
}



-(void) didLoadFromCCB
{

    // Set background audio
    audio1 = [OALSimpleAudio sharedInstance];
    [audio1 stopBg];
    
    audio3 = [OALSimpleAudio sharedInstance];
    [audio3 playBg:@"background.mp3" loop:YES];
    
    self.userInteractionEnabled = YES;
    _physicsNode = (CCPhysicsNode*)[_levelNode1 getChildByName:@"physics" recursively:NO];
    _physicsNode.collisionDelegate = self;
    _viewNode = [_physicsNode getChildByName:@"view" recursively:YES];
    _myTime = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:(@selector(countHeight)) userInfo:nil repeats:YES];
    position = 50.0f;
    
}

-(void) countHeight
{
    position = position + 0.8f;
    _viewNode.position = CGPointMake(254.0, position);
}

-(void) update:(CCTime)delta
{
    
    [self scrollToTarget:_viewNode];
}

-(void) scrollToTarget:(CCNode*)target
{
    // Assign the size of the view to viewSize
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    // The center point of the view is calculated and assigned to viewCenter
    CGPoint viewCenter = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    // Keeps the target node centered in the view
    CGPoint viewPos = ccpSub(target.positionInPoints, viewCenter);
    CGSize screenSize = _levelNode1.contentSizeInPoints;
    viewPos.x = MAX(0.0, MIN(viewPos.x, screenSize.width - viewSize.width));
    viewPos.y = MAX(0.0, MIN(viewPos.y, screenSize.height - viewSize.height));
    _levelNode1.positionInPoints = ccpNeg(viewPos);
    
}

-(BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                         view:(CCNode *)view
                         top:(CCNode *)top
{
    CCScene *container = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:container withTransition:transition];
    return NO;
}

@end
