//
//  UINavigationController.m
//  UIKitCore
//
//  Copyright (c) 2007-2018 Apple Inc. All rights reserved.
//

#import "UINavigationController.h"
#import <objc/runtime.h>
#import <mach-o/loader.h>
#import "dyld_priv.h"
#import "UIToolbar.h"
#import "UILayoutContainerView.h"
#import "UILayoutContainerViewDelegate.h"
#import "UIViewControllerPrivate.h"
#import "UINavigationTransitionView.h"
#import "_UINavigationControllerVisualStyleFactory.h"

@interface UINavigationController () <UILayoutContainerViewDelegate>
{
    UILayoutContainerView *_containerView;
    UINavigationBar *_navigationBar;
    Class _navigationBarClass;
    UIToolbar *_toolbar;
    UIView *_navigationTransitionView;
    double _statusBarHeightForHideShow;
    UIViewController *_disappearingViewController;
    UINavigationDeferredTransitionContext *_deferredTransitionContext;
    UITraitCollection *_overrideTraitCollectionForPoppingViewControler;
    __weak id<UINavigationControllerDelegate> _delegate;
    long long _savedNavBarStyleBeforeSheet;
    long long _savedToolBarStyleBeforeSheet;
    UITapGestureRecognizer* _backGestureRecognizer;
    UIKeyCommand *_backKeyCommand;
    _UINavigationControllerPalette *_topPalette;
    UIView *_paletteClippingView;
    _UINavigationControllerPalette *_freePalette;
    _UINavigationControllerPalette *_transitioningTopPalette;
    _UINavigationControllerVisualStyle *_visualStyle;
    BOOL _interactiveScrollActive;
    struct {
        double minimum;
        double preferred;
        double maximum;
    } _interactiveScrollNavBarIntrinsicHeightRange; /// Unknonw Struct
    long long _updateTopViewFramesToMatchScrollOffsetDisabledCount;
    CGSize _externallySetNavControllerPreferredContentSize;
    unsigned long long _computingNavigationBarHeightWithRevealPresentationIterations;
    struct {
        unsigned isAppearingAnimated : 1;
        unsigned isAlreadyPoppingNavigationItem : 1;
        unsigned isNavigationBarHidden : 1;
        unsigned isToolbarShown : 1;
        unsigned needsDeferredTransition : 1;
        unsigned isTransitioning : 1;
        unsigned paletteTransitionPending : 1;
        unsigned lastOperation : 4;
        unsigned lastOperationAnimated : 1;
        unsigned deferredTransition : 8;
        unsigned didPreloadKeyboardAnimation : 1;
        unsigned didHideBottomBar : 1;
        unsigned didExplicitlyHideTabBar : 1;
        unsigned isChangingOrientationForPop : 1;
        unsigned pretendNavBarHidden : 1;
        unsigned avoidMovingNavBarOffscreenBeforeUnhiding : 1;
        unsigned searchBarHidNavBar : 1;
        unsigned isCustomTransition : 1;
        unsigned isBuiltinTransition : 1;
        unsigned resetDidHideOnCancel : 1;
        unsigned delegateWillShowViewController : 1;
        unsigned delegateDidShowViewController : 1;
        unsigned delegateTransitionController : 1;
        unsigned delegateTransitionControllerEx : 1;
        unsigned delegateInteractionController : 1;
        unsigned delegateInteractionControllerEx : 1;
        unsigned delegateShouldCrossFadeNavigationBar : 1;
        unsigned delegateShouldCrossFadeBottomBars : 1;
        unsigned delegateShouldUseBuiltinInteractionController : 1;
        unsigned delegateSupportedInterfaceOrientations : 1;
        unsigned delegatePreferredInterfaceOrientationForPresentation : 1;
        unsigned delegateLayoutTransitioningClass : 1;
        unsigned delegateWasNonNil : 1;
        unsigned navigationBarHidesCompletelyOffscreen : 1;
        unsigned clipUnderlapWhileTransitioning : 1;
        unsigned isCrossfadingOutTabBar : 1;
        unsigned isCrossfadingInTabBar : 1;
        unsigned skipContentInsetCalculation : 1;
        unsigned neverInWindow : 1;
        unsigned useStandardStatusBarHeight : 1;
        unsigned allowUserInteractionDuringTransition : 1;
        unsigned enableBackButtonDuringTransition : 1;
        unsigned allowsGroupBlending : 1;
        unsigned allowNestedNavigationControllers : 1;
        unsigned allowChildSplitViewControllers : 1;
        unsigned nestedNavigationBarWasHidden : 1;
        unsigned nestedToolbarWasHidden : 1;
        unsigned isNested : 1;
        unsigned searchHidNavigationBar : 1;
        unsigned suppressMixedOrientationPop : 1;
        unsigned disappearingViewControllerIsBeingRemoved : 1;
        unsigned disappearingViewControllerNeedsToBeRemoved : 1;
        unsigned isWrappingDuringAdaptation : 1;
        unsigned cannotPerformShowViewController : 1;
        unsigned navigationSoundsEnabled : 1;
        unsigned didSetNeedsFocusInTransition : 1;
        unsigned layingOutTopViewController : 1;
        unsigned hasScheduledDeferredUpdateNavigationBarHostedRefreshControl : 1;
        unsigned allowsFreezeLayoutForOrientationChangeOnDismissal : 1;
        unsigned scrollViewObservationReasonHasVariableHeightNavigationBar : 1;
        unsigned scrollViewObservationReasonIsEmulatingChromelessForFixedHeightNavigationBar : 1;
        unsigned scrollViewObservationReasonIsAutoUpdatingManualScrollEdgeAppearance : 1;
        unsigned createdBySplitViewController : 1;
        unsigned isExecutingSplitViewControllerActions : 1;
    } _navigationControllerFlags;
    BOOL _interactiveTransition;
    BOOL _hidesBarsWhenKeyboardAppears;
    BOOL _hidesBarsOnSwipe;
    BOOL _hidesBarsWhenVerticallyCompact;
    BOOL _hidesBarsOnTap;
    BOOL __positionBarsExclusivelyWithSafeArea;
    BOOL __usingBuiltinAnimator;
    BOOL __shouldIgnoreDelegateTransitionController;
    BOOL __toolbarAnimationWasCancelled;
    BOOL __navigationBarAnimationWasCancelled;
    Class _toolbarClass;
    double _customNavigationTransitionDuration;
    NSMapTable *_rememberedFocusedItemsByViewController;
    long long _builtinTransitionStyle;
    double _builtinTransitionGap;
    UIViewController *__temporaryWindowLocator;
    NSString *__backdropGroupName;
    long long __preferredNavigationBarPosition;
    id<UIViewControllerAnimatedTransitioning> __transitionController;
    id<UIViewControllerInteractiveTransitioning> __interactionController;
    NSUUID *__toolbarAnimationId;
    NSUUID *__navbarAnimationId;
    /*^block*/id __updateNavigationBarHandler; /// Unknown Block
    UIFocusContainerGuide *_contentFocusContainerGuide;
    id __keyboardAppearedNotificationToken;
    _UIBarPanGestureRecognizer *__barSwipeHideGesture;
    _UIAnimationCoordinator *__barInteractiveAnimationCoordinator;
    _UIBarTapGestureRecognizer *__barTapHideGesture;
}

@end

@implementation UINavigationController

+ (BOOL)doesOverridePreferredInterfaceOrientationForPresentation {
    return [self doesOverrideViewControllerMethod:@selector(preferredInterfaceOrientationForPresentation)
                                      inBaseClass:[UINavigationController class]];
}

- (void)_setToolbarClass:(Class)toolbarClass {
    if (toolbarClass) {
        if (__builtin_expect(![toolbarClass isSubclassOfClass:[UIToolbar class]], NO)) {
            [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd
                                                                object:self
                                                                  file:@__FILE_NAME__
                                                            lineNumber:__LINE__
                                                           description:@"%@ is not a subclass of UIToolbar", NSStringFromClass(toolbarClass)];
        }
    }
    
    self->_toolbarClass = toolbarClass;
}

- (void)_commonNonCoderInit {
    self->_modalTransitionStyle = -1;
    [self _commonInitWithBuiltinTransitionGap:20];
}

- (void)_commonInitWithBuiltinTransitionGap:(double)gap {
    
}

- (void)didMoveToParentViewController {
    [super didMoveToParentViewController];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    dyld_build_version_t ios13 = { .platform = PLATFORM_IOS, .version = 0x000d0000 };
    if (dyld_program_sdk_at_least(ios13)) {
        self = [super initWithNibName:nil bundle:nil];
    } else {
        self = [self initWithNibName:nil bundle:nil];
    }
    if (self) {
        if (dyld_program_sdk_at_least(ios13)) {
            [self _commonNonCoderInit];
        }
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    dyld_build_version_t ios13 = { .platform = PLATFORM_IOS, .version = 0x000d0000 };
    if (dyld_program_sdk_at_least(ios13)) {
        self = [super initWithNibName:nil bundle:nil];
    } else {
        self = [self initWithNibName:nil bundle:nil];
    }
    if (self) {
        if (dyld_program_sdk_at_least(ios13)) {
            [self _commonNonCoderInit];
        }
        [self setNavigationBarClass:navigationBarClass];
        [self _setToolbarClass:toolbarClass];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    self = [super initWithNibName:nibName bundle:bundle];
    if (self) {
        [self _commonNonCoderInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return nil;
}

- (BOOL)_shouldPersistViewWhenCoding {
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)coder; {
    
}

- (void)_releaseContainerViews {
    if (self == [self->_containerView delegate]) {
        [self->_containerView setDelegate:nil];
    }
    self->_containerView = nil;
    [(UINavigationTransitionView *)self->_navigationTransitionView setDelegate:nil];
    self->_navigationTransitionView = nil;
}

- (void)dealloc {
    
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
}

- (void)_setupVisualStyle {
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (BOOL)_shouldBottomBarBeHidden {
    return YES;
}

- (BOOL)_shouldCrossFadeBottomBars {
    return YES;
}

- (void)setNavigationBarClass:(Class)naivgationBarClass {
    
}

- (void)_hideOrShowBottomBarIfNeededWithTransition:(int)transition {

}

@end

