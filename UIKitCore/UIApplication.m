//
//  UIApplication.m
//  UIKitCore
//
//  Copyright (c) 2005-2018 Apple Inc. All rights reserved.
//

#import "UIApplication.h"
#import "_UISceneLifecycleMultiplexer.h"
#import "UIScene.h"

UIScene *UIApp;

@implementation UIApplication

- (UIApplicationState)applicationState {
    return [[_UISceneLifecycleMultiplexer sharedInstance] applicationState];
}

@end
