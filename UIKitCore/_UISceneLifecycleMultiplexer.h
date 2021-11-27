//
//  _UISceneLifecycleMultiplexer.h
//  UIKitCore
//
//  Created by 鱼非 on 2021/11/26.
//  Copyright © 2021 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKitCore/UIApplication.h>

NS_ASSUME_NONNULL_BEGIN

@class UIScene;
@class UIApplicationSceneSettings;

@interface _UISceneLifecycleMultiplexer : NSObject {
    __weak UIScene *_uiSceneOfRecord;
    UIApplicationSceneSettings *_transitionalLifecycleState;
    struct {
        unsigned completedLaunch:1;
        unsigned activatedOnce:1;
    } _multiplexerFlags;
}

@property (nonatomic, assign, readonly) BOOL activatedOnce;
@property (nonatomic, assign, readonly) BOOL lifecycleWantsUnnecessaryDelayForSceneDelivery;
@property (nonatomic, assign, readonly) UIApplicationState applicationState;
@property (nonatomic, assign, readonly, getter=isActive) BOOL active;
@property (nonatomic, assign, readonly) BOOL suspendedEventsOnly;
@property (nonatomic, assign, readonly) BOOL suspendedUnderLock;
@property (nonatomic, assign, readonly) BOOL runningInTaskSwitcher;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
