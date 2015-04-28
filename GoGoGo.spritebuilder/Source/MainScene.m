#import "MainScene.h"
#import "Pause.h"

@implementation MainScene

- (void)didLoadFromCCB{
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio preloadBg:@"background1.mp3"];
    
    OALSimpleAudio *audio2 = [OALSimpleAudio sharedInstance];
    [audio2 preloadBg:@"failed.mp3"];
    
    // Set main background audio
    OALSimpleAudio* audio1 = [OALSimpleAudio sharedInstance];
    audio1.effectsVolume = 0.5;
    [audio1 playBg:@"mainground.mp3" loop:YES];
}

- (void)startGame {
    
    CCScene *game = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
