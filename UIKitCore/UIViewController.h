//
//  UIViewController.h
//  UIKitCore
//
//  Copyright (c) 2007-2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIViewController : NSObject

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (nullable instancetype)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (void)didMoveToParentViewController;

+ (BOOL)doesOverrideViewControllerMethod:(SEL)method inBaseClass:(Class)baseClass;

- (long long)preferredInterfaceOrientationForPresentation;

@end
