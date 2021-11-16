//
//  UILayoutContainerViewDelegate.h
//  UIKitCore
//
//  Copyright (c) 2007-2018 Apple Inc. All rights reserved.
//

@protocol UILayoutContainerViewDelegate <NSObject>

@optional
- (void)_layoutContainerViewDidMoveToWindow:(id)arg1;
- (void)__viewWillLayoutSubviews;
- (void)_layoutContainerViewSemanticContentAttributeChanged:(id)arg1;
- (void)_layoutContainerViewWillMoveToWindow:(id)arg1;
@end
