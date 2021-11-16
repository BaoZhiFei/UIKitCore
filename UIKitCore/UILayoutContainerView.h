//
//  UILayoutContainerView.h
//  UIKitCore
//
//  Copyright (c) 2007-2018 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UILayoutContainerViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UILayoutContainerView : NSObject

@property (nonatomic, weak, nullable) id<UILayoutContainerViewDelegate> delegate; 

@end

NS_ASSUME_NONNULL_END
