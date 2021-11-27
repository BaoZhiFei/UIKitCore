//
//  UIMenuElement.m
//  UIKitCore
//
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#import "UIMenuElement.h"

@interface UIMenuElement ()
{
    NSString *_subtitle;
    NSString *_accessibilityIdentifier;
    NSString *_title;
    /* id<_UIMenuImageOrName>*/ id _imageOrName;
}

@property (nonatomic, readonly) BOOL isLeaf;

@property (nonatomic, readonly) BOOL isLoadingPlaceholder;

@property (nonatomic, readonly) /* id<_UIMenuImageOrName>*/ id imageOrName;

@end

@implementation UIMenuElement

- (BOOL)_isInlineGroup {
    if (self.isLeaf) {
        return NO;
    } else {
        return YES;
//        return [self options];
    }
}

- (BOOL)_canBeHighlighted {
    return NO;
}

- (BOOL)_isVisible {
    return NO;
}

- (void)_customContentView {
    
}

+ (BOOL)supportsSecureCoding {
    return NO;
}

- (BOOL)isLeaf {
    return NO;
}

- (BOOL)isLoadingPlaceholder {
    return NO;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return nil;
}

- (instancetype)initWithTitle:(id)arg1 image:(id)arg2 imageName:(id)arg3 {
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
}

- (UIImage *)image {
    return nil;
}

- (void)_acceptMenuVisit:(/*^block*/id)arg1 commandVisit:(/*^block*/id)arg2 actionVisit:(/*^block*/id)arg3 deferredElementVisit:(/*^block*/id)arg4  {
    
}

- (BOOL)_acceptBoolMenuVisit:(/*^block*/id)arg1 commandVisit:(/*^block*/id)arg2 actionVisit:(/*^block*/id)arg3 {
    return NO;
}

- (void)_acceptMenuVisit:(/*^block*/id)arg1 leafVisit:(/*^block*/id)arg2  {
    
}

- (BOOL)_acceptBoolMenuVisit:(/*^block*/id)arg1 leafVisit:(/*^block*/id)arg2 {
    return NO;
}

- (instancetype)_mutableCopy {
    return nil;
}

- (instancetype)_immutableCopy {
    return nil;
}

- (void)_setTitle:(id)arg1 {
    
}

- (void)_setSubtitle:(id)arg1 {
    
}

- (void)_setImage:(id)arg1 {
    
}

- (void)_willBePreparedForInitialDisplay:(id)arg1 {
    
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return nil;
}

- (id)accessibilityIdentifier {
    return nil;
}

- (void)setAccessibilityIdentifier:(id)arg1 {
    
}

- (NSString *)title {
    return nil;
}

- (NSString *)subtitle {
    return nil;
}

- (void)setSubtitle:(NSString *)subtitle {
    
}

- (id)imageOrName {
    return nil;
}

@end
