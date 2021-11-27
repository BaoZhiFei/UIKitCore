//
//  UISplitViewController.m
//  UIKitCore
//
//  Created by mac on 2021/11/26.
//  Copyright © 2021 Apple Inc. All rights reserved.
//

#import "UISplitViewController.h"
#import "UISplitViewControllerImpl.h"
#import "dyld_priv.h"
#import "UIDevice.h"

@interface UISplitViewController () {
    id<UISplitViewControllerImpl> _impl;
    BOOL __lockedForDelegateCallback;
}

@end

@implementation UISplitViewController

- (void)_commonInit {
    dyld_build_version_t ios8 = { .platform = PLATFORM_IOS, .version = 0x00080000 };
    if (!dyld_program_sdk_at_least(ios8) && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [NSException raise:NSInvalidArgumentException format:@"UISplitViewController is only supported when running under UIUserInterfaceIdiomPad"];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    
    static BOOL sUseSlidingBars;
    
}

@end
