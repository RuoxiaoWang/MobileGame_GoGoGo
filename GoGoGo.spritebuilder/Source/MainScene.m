#import "MainScene.h"

@implementation MainScene

- (void)didLoadFromCCB{
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio preloadBg:@"background.mp3"];
}

- (void)startGame {
    
    CCScene *game = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
