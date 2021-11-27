//
//  _UISceneLifecycleMultiplexer.m
//  UIKitCore
//
//  Created by 鱼非 on 2021/11/26.
//  Copyright © 2021 Apple Inc. All rights reserved.
//

#import "_UISceneLifecycleMultiplexer.h"

extern UIScene *UIApp;
NSUserDefaults *_UIKitUserDefault(void)
{
    return nil;
}

@implementation _UISceneLifecycleMultiplexer

+ (instancetype)sharedInstance {
    static id multiplexer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        multiplexer = [[_UISceneLifecycleMultiplexer alloc] initForAppSingleton:UIApp];
    });
    return multiplexer;
}

- (instancetype)initForAppSingleton:(UIScene *)app {
    if (self = [super init]) {
        self->_uiSceneOfRecord = app;
        self->_transitionalLifecycleState = nil;
        self->_multiplexerFlags.activatedOnce = NO;
    }
    return nil;
}

- (BOOL)lifecycleWantsUnnecessaryDelayForSceneDelivery {
    static BOOL _lifecycleWantsUnnecessaryDelayForSceneDelivery;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = _UIKitUserDefault();
        BOOL val = [userDefaults boolForKey:@"UIRequireCrimsonLifecycle"];
    });
    return _lifecycleWantsUnnecessaryDelayForSceneDelivery;
}

- (UIApplicationState)applicationState {
    if (self->_uiSceneOfRecord) {
        
    } else {
        
    }
    return 0;
}

@end
