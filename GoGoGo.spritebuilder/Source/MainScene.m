#import "MainScene.h"

@implementation MainScene

- (void)startGame {
    CCScene *game = [CCBReader loadAsScene:@"GameScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
