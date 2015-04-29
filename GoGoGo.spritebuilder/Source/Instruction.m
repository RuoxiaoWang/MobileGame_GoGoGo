//
//  Instruction.m
//  GoGoGo
//
//  Created by longma on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction

// Set the loadMainScene method
-(void)loadMainScene
{
    
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:mainScene withTransition:transition];
    
}


- (void)startGame {
    
    CCScene *game = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
