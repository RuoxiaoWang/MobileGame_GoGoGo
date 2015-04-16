#import "MainScene.h"

@implementation MainScene

- (void)startGame {
    CCScene *game = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
