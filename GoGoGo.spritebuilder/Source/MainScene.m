#import "MainScene.h"

@implementation MainScene

- (void)startGame {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio preloadBg:@"file:///Users/longma/Library/Developer/CoreSimulator/Devices/EA290C63-03DA-410A-B92F-4F45C96BEB7F/data/Containers/Bundle/Application/3622F606-0ED3-4F72-AB57-AD99FE7EA8D2/GoGoGo.app/background.mp3"];
    
    CCScene *game = [CCBReader loadAsScene:@"Container"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:game withTransition:transition];
}

@end
