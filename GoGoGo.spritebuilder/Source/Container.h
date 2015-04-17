//
//  Container.h
//  GoGoGo
//
//  Created by longma on 4/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

// Allow the Container class to be used as a receiver of physics collision messages
@interface Container : CCNode <CCPhysicsCollisionDelegate>

@end
