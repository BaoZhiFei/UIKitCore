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
    CGFloat _statusBarHeightForHideShow;
    UIViewController *_disappearingViewController;
    UINavigationDeferredTransitionContext *_deferredTransitionContext;
    UITraitCollection *_overrideTraitCollectionForPoppingViewControler;
    __weak id<UINavigationControllerDelegate> _delegate;
    NSInteger _savedNavBarStyleBeforeSheet;
    NSInteger _savedToolBarStyleBeforeSheet;
    UITapGestureRecognizer* _backGestureRecognizer;
    UIKeyCommand *_backKeyCommand;
    _UINavigationControllerPalette *_topPalette;
    UIView *_paletteClippingView;
    _UINavigationControllerPalette *_freePalette;
    _UINavigationControllerPalette *_transitioningTopPalette;
    _UINavigationControllerVisualStyle *_visualStyle;
    BOOL _interactiveScrollActive;
    struct {
        CGFloat minimum;
        CGFloat preferred;
        CGFloat maximum;
    } _interactiveScrollNavBarIntrinsicHeightRange;
    NSInteger _updateTopViewFramesToMatchScrollOffsetDisabledCount;
    CGSize _externallySetNavControllerPreferredContentSize;
    NSUInteger _computingNavigationBarHeightWithRevealPresentationIterations;
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
        unsigned isAnimatingExchangeBetweenInnerAndOuterToolbars : 1;
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
        unsigned scrollViewObservationReasonIsEmulatingChromelessEverywhere : 1;
        unsigned suspendToolbarBackgroundUpdating : 1;
        unsigned isBottomBarUnhidingDuringPushOrPop : 1;
        unsigned hasUpdatedToolbarBackgroundAfterAppLaunch : 1;
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
    CGFloat _customNavigationTransitionDuration;
    NSMapTable *_rememberedFocusedItemsByViewController;
    NSInteger _builtinTransitionStyle;
    CGFloat _builtinTransitionGap;
    UIViewController *__temporaryWindowLocator;
    NSString *__backdropGroupName;
    NSInteger __preferredNavigationBarPosition;
    id<UIViewControllerAnimatedTransitioning> __transitionController;
    id<UIViewControllerInteractiveTransitioning> __interactionController;
    NSUUID *__toolbarAnimationId;
    NSUUID *__navbarAnimationId;
    dispatch_block_t __updateNavigationBarHandler;
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

- (void)_commonInitWithBuiltinTransitionGap:(CGFloat)gap {
    
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

- (BOOL)_isCrossfadingOutTabBar {
    return NO;
}

- (BOOL)_isCrossfadingInTabBar {
    return NO;
}

- (BOOL)_didExplicitlyHideTabBar {
    return NO;
}

- (void)_setCrossfadingOutTabBar:(BOOL)arg1 {
    
}

- (void)_setCrossfadingInTabBar:(BOOL)arg1 {
    
}

- (void)_setDidExplicitlyHideTabBar:(BOOL)arg1 {
    
}

- (void)_setUseCurrentStatusBarHeight:(BOOL)arg1 {
    
}

- (void)_setUseStandardStatusBarHeight:(BOOL)arg1 {
    
}

- (BOOL)_useCurrentStatusBarHeight {
    return NO;
}

- (BOOL)_useStandardStatusBarHeight {
    return NO;
}

- (BOOL)allowUserInteractionDuringTransition {
    return NO;
}

- (void)setAllowUserInteractionDuringTransition:(BOOL)arg1 {
    
}

- (BOOL)enableBackButtonDuringTransition {
    return NO;
}

- (void)setEnableBackButtonDuringTransition:(BOOL)arg1 {
    
}

- (UIViewController *)topViewController {
    return nil;
}

- (UIViewController *)bottomViewController {
    return nil;
}

- (NSInteger)modalTransitionStyle {
    return 0;
}

- (UIViewController *)visibleViewController {
    return nil;
}

- (UIViewController *)previousViewController {
    return nil;
}

- (BOOL)_isPresentationContextByDefault {
    return NO;
}

- (NSArray<__kindof UIViewController *> *)viewControllers {
    return nil;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    
}

- (int)_transitionForOldViewControllers:(id)arg1 newViewControllers:(id)arg2 {
    return 0;
}

- (void)setViewControllers:(id)arg1 animated:(BOOL)arg2 {
    
}

- (void)_setAllowNestedNavigationControllers:(BOOL)arg1 {
    
}

- (BOOL)_allowNestedNavigationControllers {
    return NO;
}

- (void)_setIsNestedNavigationController:(BOOL)arg1  {
    
}

- (BOOL)_isNestedNavigationController {
    return NO;
}

// -[UINavigationController _nestedTopViewController]

- (BOOL)_hasNestedNavigationController {
    return NO;
}

- (void)_setAllowChildSplitViewControllers:(BOOL)arg1 {
    
}

- (BOOL)_allowChildSplitViewControllers {
    return NO;
}


- (UINavigationItem *)navigationItem {
    return nil;
}

- (id)_navigationItems {
    return nil;
}


- (BOOL)_isAlreadyPoppingNavItem {
    return NO;
}

- (BOOL)_shouldCrossFadeBottomBars {
    return YES;
}

- (void)setNavigationBarClass:(Class)naivgationBarClass {
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /*
     ; ================ B E G I N N I N G   O F   P R O C E D U R E ================

     ; Variables:
     ;    var_30: int64_t, -48
     ;    var_38: int64_t, -56
     ;    var_48: int64_t, -72
     ;    var_68: int8_t, -104
     ;    var_90: int8_t, -144
     ;    var_C0: int8_t, -192
     ;    var_F8: int8_t, -248


                  -[UINavigationController pushViewController:animated:]:
     000000000043a7d8         push       rbp                                         ; Objective C Implementation defined at 0x138d5ac (instance method)
     000000000043a7d9         mov        rbp, rsp
     000000000043a7dc         push       r15
     000000000043a7de         push       r14
     000000000043a7e0         push       r13
     000000000043a7e2         push       r12
     000000000043a7e4         push       rbx
     000000000043a7e5         sub        rsp, 0xd8
     
     // r12 = animated
     000000000043a7ec         mov        r12d, ecx
     // r14 = _cmd
     000000000043a7ef         mov        r14, rsi
     // r15 = self
     000000000043a7f2         mov        r15, rdi
     // r13 = objc_retain
     000000000043a7f5         mov        r13, qword [_objc_retain_186e958]           ; _objc_retain_186e958
     // rdi = viewController
     000000000043a7fc         mov        rdi, rdx                                    ; argument "instance" for method _objc_retain
     // [viewController retain], rax = viewController
     000000000043a7ff         call       r13                                         ; Jumps to 0x2e33f90 (_objc_retain), _objc_retain
     // rcx = _NSConcreteStackBlock, block_impl.isa
     000000000043a802         mov        rcx, qword [__NSConcreteStackBlock_186de50] ; __NSConcreteStackBlock_186de50
     // rbx = &var_68
     000000000043a809         lea        rbx, qword [rbp+var_68]
     // var_68 = NSConcreteStackBlock, var_68 就是本地block变量
     000000000043a80d         mov        qword [rbx], rcx
     // ecx = 0xc2000000， block_impl的Flags = 0xc2000000 = BLOCK_HAS_COPY_DISPOSE | BLOCK_HAS_SIGNATURE | BLOCK_HAS_EXTENDED_LAYOUT
     000000000043a810         mov        ecx, 0xc2000000
     // 设置block的isa为_NSConcreteStackBlock
     000000000043a815         mov        qword [rbx+8], rcx
     // rcx = block_invode，block的函数指针
     000000000043a819         lea        rcx, qword [___54-[UINavigationController pushViewController:animated:]_block_invoke] ; ___54-[UINavigationController pushViewController:animated:]_block_invoke
     // 设置block的FuncPtr
     000000000043a820         mov        qword [rbx+0x10], rcx
     // rcx = block
     // ___block_descriptor_48_e8_32s40s_e8_v12?0B8l]
     // 正常block是32个字节大小，这里是48，说明捕获了两个本地变量
     000000000043a824         lea        rcx, qword [___block_descriptor_48_e8_32s40s_e8_v12?0B8l] ; ___block_descriptor_48_e8_32s40s_e8_v12?0B8l
     // 设置block的Desc
     000000000043a82b         mov        qword [rbx+0x18], rcx
     // rdi = viewController
     000000000043a82f         mov        rdi, rax                                    ; argument "instance" for method _objc_retain
     // [viewController retain], rax = viewController
     000000000043a832         call       r13                                         ; Jumps to 0x2e33f90 (_objc_retain), _objc_retain
     // var_38 = viewController
     000000000043a835         mov        qword [rbp+var_38], rax
     // block捕获的第一个变量是viewController
     000000000043a839         mov        qword [rbx+0x20], rax
     // block捕获的第二个变量是self
     000000000043a83d         mov        qword [rbx+0x28], r15
     // rdi = block
     000000000043a841         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_retainBlock
     // 对 block 进行 retain
     000000000043a844         call       imp___stubs__objc_retainBlock               ; objc_retainBlock
     // var_30 = block1
     000000000043a849         mov        qword [rbp+var_30], rax
     // rsi = @selector(_transitionCoordinator)
     000000000043a84d         mov        rsi, qword [0x1b2e8c8]                      ; argument "selector" for method _objc_msgSend, @selector(_transitionCoordinator)
     // rdi = self
     000000000043a854         mov        rdi, r15                                    ; argument "instance" for method _objc_msgSend
     // [self _transitionCoordinator]
     000000000043a857         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a85d         mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_retainAutoreleasedReturnValue
     000000000043a860         call       imp___stubs__objc_retainAutoreleasedReturnValue ; objc_retainAutoreleasedReturnValue
     000000000043a865         mov        r13, rax
     000000000043a868         test       rax, rax
     000000000043a86b         je         loc_43a8e9

     // rsi = @selector(_transitionConflictsWithNavigationTransitions:)
     000000000043a86d         mov        rsi, qword [0x1b44460]                      ; argument "selector" for method _objc_msgSend, @selector(_transitionConflictsWithNavigationTransitions:)
     // rdi = self
     000000000043a874         mov        rdi, r15                                    ; argument "instance" for method _objc_msgSend
     // rdx = _transitionCoordinator
     000000000043a877         mov        rdx, r13
     000000000043a87a         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a880         test       al, al
     000000000043a882         je         loc_43a976

     // r14 = _cmd
     000000000043a888         mov        rdi, r14                                    ; argument "aSelector" for method imp___stubs__NSStringFromSelector
     // NSStringFromSelector(_cmd)
     000000000043a88b         call       imp___stubs__NSStringFromSelector           ; NSStringFromSelector
     // rdi = @"pushViewController"
     000000000043a890         mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_retainAutoreleasedReturnValue
     000000000043a893         call       imp___stubs__objc_retainAutoreleasedReturnValue ; objc_retainAutoreleasedReturnValue
     // r14 = string
     000000000043a898         mov        r14, rax
     // rdi = self
     000000000043a89b         mov        rdi, r15
     // [self class]
     000000000043a89e         call       imp___stubs__objc_opt_class                 ; objc_opt_class
     // NSStringFromClass([self class])
     000000000043a8a3         mov        rdi, rax                                    ; argument "aClass" for method imp___stubs__NSStringFromClass
     000000000043a8a6         call       imp___stubs__NSStringFromClass              ; NSStringFromClass
     000000000043a8ab         mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_retainAutoreleasedReturnValue
     000000000043a8ae         call       imp___stubs__objc_retainAutoreleasedReturnValue ; objc_retainAutoreleasedReturnValue
     000000000043a8b3         mov        rbx, rax
     000000000043a8b6         lea        rdi, qword [cfstring____called_on______p__while_an_existing_transition_or_presentation_is_occurring__the_navigat] ; argument "format" for method imp___stubs__NSLog, @"%@ called on <%@ %p> while an existing transition or presentation is occurring; the navigation stack will not be updated."
     000000000043a8bd         mov        rsi, r14
     000000000043a8c0         mov        rdx, rax
     000000000043a8c3         mov        rcx, r15
     000000000043a8c6         xor        eax, eax
     000000000043a8c8         call       imp___stubs__NSLog                          ; NSLog
     // r15 = objc_release
     000000000043a8cd         mov        r15, qword [_objc_release_186e950]          ; _objc_release_186e950
     000000000043a8d4         mov        rdi, rbx                                    ; argument "instance" for method _objc_release
     000000000043a8d7         call       r15                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     000000000043a8da         mov        rdi, r14                                    ; argument "instance" for method _objc_release
     000000000043a8dd         call       r15                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     // r14 = viewController
     000000000043a8e0         mov        r14, qword [rbp+var_38]
     000000000043a8e4         jmp        loc_43aa60

                          loc_43a8e9:
     000000000043a8e9         mov        rsi, qword [0x1b42cb8]                      ; argument "selector" for method _objc_msgSend, @selector(_isTransitioning), CODE XREF=-[UINavigationController pushViewController:animated:]+147
     000000000043a8f0         mov        rdi, r15                                    ; argument "instance" for method _objc_msgSend
     000000000043a8f3         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a8f9         test       al, al
     000000000043a8fb         jne        loc_43a915

     000000000043a8fd         mov        rsi, qword [0x1b434d8]                      ; argument "selector" for method _objc_msgSend, @selector(needsDeferredTransition)
     000000000043a904         mov        rdi, r15                                    ; argument "instance" for method _objc_msgSend
     000000000043a907         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a90d         test       al, al
     000000000043a90f         je         loc_43aa66

                          loc_43a915:
     000000000043a915         test       r12b, r12b                                  ; CODE XREF=-[UINavigationController pushViewController:animated:]+291
     000000000043a918         je         loc_43aa66

     000000000043a91e         lea        rax, qword [_UIApp]                         ; _UIApp
     000000000043a925         mov        r14, qword [rax]
     000000000043a928         lea        rbx, qword [rbp+var_C0]
     000000000043a92f         mov        rax, qword [__NSConcreteStackBlock_186de50] ; __NSConcreteStackBlock_186de50
     000000000043a936         mov        qword [rbx], rax
     000000000043a939         mov        eax, 0xc2000000
     000000000043a93e         mov        qword [rbx+8], rax
     000000000043a942         lea        rax, qword [___54-[UINavigationController pushViewController:animated:]_block_invoke_3] ; ___54-[UINavigationController pushViewController:animated:]_block_invoke_3
     000000000043a949         mov        qword [rbx+0x10], rax
     000000000043a94d         lea        rax, qword [___block_descriptor_41_e8_32bs_e5_v8?0l] ; ___block_descriptor_41_e8_32bs_e5_v8?0l
     000000000043a954         mov        qword [rbx+0x18], rax
     000000000043a958         mov        r15, qword [rbp+var_30]
     000000000043a95c         mov        rdi, r15                                    ; argument "instance" for method _objc_retain
     000000000043a95f         call       qword [_objc_retain_186e958]                ; _objc_retain, _objc_retain_186e958,_objc_retain
     000000000043a965         mov        qword [rbx+0x20], rax
     000000000043a969         mov        byte [rbx+0x28], r12b
     000000000043a96d         mov        rsi, qword [0x1b2e590]                      ; @selector(_performBlockAfterCATransactionCommits:)
     000000000043a974         jmp        loc_43a9e0

                          loc_43a976:
     000000000043a976         test       r12b, r12b                                  ; CODE XREF=-[UINavigationController pushViewController:animated:]+170
     000000000043a979         jne        loc_43a9f8

     000000000043a97b         mov        rsi, qword [0x1b42760]                      ; argument "selector" for method _objc_msgSend, @selector(presentationStyle)
     000000000043a982         mov        rdi, r13                                    ; argument "instance" for method _objc_msgSend
     000000000043a985         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a98b         cmp        rax, 0xffffffffffffffff
     000000000043a98f         je         loc_43a9f8

     000000000043a991         mov        r14, qword [objc_cls_ref_UIViewController]  ; objc_cls_ref_UIViewController
     000000000043a998         lea        rbx, qword [rbp+var_90]
     000000000043a99f         mov        rax, qword [__NSConcreteStackBlock_186de50] ; __NSConcreteStackBlock_186de50
     000000000043a9a6         mov        qword [rbx], rax
     000000000043a9a9         mov        eax, 0xc2000000
     000000000043a9ae         mov        qword [rbx+8], rax
     000000000043a9b2         lea        rax, qword [___54-[UINavigationController pushViewController:animated:]_block_invoke.1950] ; ___54-[UINavigationController pushViewController:animated:]_block_invoke.1950
     000000000043a9b9         mov        qword [rbx+0x10], rax
     000000000043a9bd         lea        rax, qword [___block_descriptor_40_e8_32bs_e5_v8?0l] ; ___block_descriptor_40_e8_32bs_e5_v8?0l
     000000000043a9c4         mov        qword [rbx+0x18], rax
     000000000043a9c8         mov        r15, qword [rbp+var_30]
     000000000043a9cc         mov        rdi, r15                                    ; argument "instance" for method _objc_retain
     000000000043a9cf         call       qword [_objc_retain_186e958]                ; _objc_retain, _objc_retain_186e958,_objc_retain
     000000000043a9d5         mov        qword [rbx+0x20], rax
     000000000043a9d9         mov        rsi, qword [0x1b2e698]                      ; @selector(_performWithoutDeferringTransitions:)

                          loc_43a9e0:
     000000000043a9e0         mov        rdi, r14                                    ; argument "instance" for method _objc_msgSend, CODE XREF=-[UINavigationController pushViewController:animated:]+412
     000000000043a9e3         mov        rdx, rbx
     000000000043a9e6         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043a9ec         mov        rdi, qword [rbx+0x20]                       ; argument "instance" for method _objc_release
     000000000043a9f0         call       qword [_objc_release_186e950]               ; _objc_release, _objc_release_186e950,_objc_release
     000000000043a9f6         jmp        loc_43aa75

                          loc_43a9f8:
     000000000043a9f8         lea        rbx, qword [rbp+var_F8]                     ; CODE XREF=-[UINavigationController pushViewController:animated:]+417, -[UINavigationController pushViewController:animated:]+439
     000000000043a9ff         mov        rax, qword [__NSConcreteStackBlock_186de50] ; __NSConcreteStackBlock_186de50
     000000000043aa06         mov        qword [rbx], rax
     000000000043aa09         mov        eax, 0xc2000000
     000000000043aa0e         mov        qword [rbx+8], rax
     000000000043aa12         lea        rax, qword [___54-[UINavigationController pushViewController:animated:]_block_invoke_2] ; ___54-[UINavigationController pushViewController:animated:]_block_invoke_2
     000000000043aa19         mov        qword [rbx+0x10], rax
     000000000043aa1d         lea        rax, qword [___block_descriptor_49_e8_32s40s_e56_v16?0"<UIViewControllerTransitionCoordinatorContext>"8l] ; ___block_descriptor_49_e8_32s40s_e56_v16?0"<UIViewControllerTransitionCoordinatorContext>"8l
     000000000043aa24         mov        qword [rbx+0x18], rax
     000000000043aa28         mov        qword [rbx+0x20], r15
     000000000043aa2c         mov        r14, qword [rbp+var_38]
     000000000043aa30         mov        rdi, r14                                    ; argument "instance" for method _objc_retain
     000000000043aa33         call       qword [_objc_retain_186e958]                ; _objc_retain, _objc_retain_186e958,_objc_retain
     000000000043aa39         mov        qword [rbx+0x28], rax
     000000000043aa3d         mov        byte [rbx+0x30], r12b
     000000000043aa41         mov        rsi, qword [0x1b2c338]                      ; argument "selector" for method _objc_msgSend, @selector(animateAlongsideTransition:completion:)
     000000000043aa48         mov        rdi, r13                                    ; argument "instance" for method _objc_msgSend
     000000000043aa4b         xor        edx, edx
     000000000043aa4d         mov        rcx, rbx
     000000000043aa50         call       qword [_objc_msgSend_186e948]               ; _objc_msgSend, _objc_msgSend_186e948,_objc_msgSend
     000000000043aa56         mov        rdi, qword [rbx+0x28]                       ; argument "instance" for method _objc_release
     000000000043aa5a         call       qword [_objc_release_186e950]               ; _objc_release, _objc_release_186e950,_objc_release

                          loc_43aa60:
     000000000043aa60         mov        r15, qword [rbp+var_30]                     ; CODE XREF=-[UINavigationController pushViewController:animated:]+268
     000000000043aa64         jmp        loc_43aa79

                          loc_43aa66:
     000000000043aa66         movzx      esi, r12b                                   ; CODE XREF=-[UINavigationController pushViewController:animated:]+311, -[UINavigationController pushViewController:animated:]+320
     000000000043aa6a         mov        r15, qword [rbp+var_30]
     000000000043aa6e         mov        rdi, r15
     000000000043aa71         call       qword [r15+0x10]

                          loc_43aa75:
     000000000043aa75         mov        r14, qword [rbp+var_38]                     ; CODE XREF=-[UINavigationController pushViewController:animated:]+542

                          loc_43aa79:
     000000000043aa79         mov        rbx, qword [_objc_release_186e950]          ; _objc_release_186e950, CODE XREF=-[UINavigationController pushViewController:animated:]+652
     000000000043aa80         mov        rdi, r13                                    ; argument "instance" for method _objc_release
     000000000043aa83         call       rbx                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     000000000043aa85         mov        rdi, r15                                    ; argument "instance" for method _objc_release
     000000000043aa88         call       rbx                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     000000000043aa8a         mov        rdi, qword [rbp+var_48]                     ; argument "instance" for method _objc_release
     000000000043aa8e         call       rbx                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     000000000043aa90         mov        rdi, r14                                    ; argument "instance" for method _objc_release
     000000000043aa93         call       rbx                                         ; Jumps to 0x2e33f88 (_objc_release), _objc_release
     000000000043aa95         add        rsp, 0xd8
     000000000043aa9c         pop        rbx
     000000000043aa9d         pop        r12
     000000000043aa9f         pop        r13
     000000000043aaa1         pop        r14
     000000000043aaa3         pop        r15
     000000000043aaa5         pop        rbp
     000000000043aaa6         ret
                             ; endp
     */
    
    void (^block)(BOOL) = ^(BOOL animated) {
        UIViewController *vc = viewController;
        UINavigationController *nav = self;
        
        NSLog(@"%@,%@",vc, nav);
    };
    id coordinator = [self _transitionCoordinator];
    if (coordinator != nil) {
        if (![self _transitionConflictsWithNavigationTransitions:coordinator]) {
            NSLog(@"%@ called on <%@ %p> while an existing transition or presentation is occurring; the navigation stack will not be updated.", NSStringFromSelector(_cmd), NSStringFromClass([self class]), self);
        } else {
            
        }
    } else {
        
    }
    block(animated);
}

- (BOOL)_isTransitioning {
    return NO;
}

- (id)_transitionCoordinator {
    return nil;
}

- (BOOL)_transitionConflictsWithNavigationTransitions:(id)arg1 {
    return NO;
}

- (void)pushViewController:(UIViewController *)viewController transition:(int)transition forceImmediate:(BOOL)forceImmediate {
    
}

- (void)pushViewController:(UIViewController *)viewController transition:(int)transition {
    [self pushViewController:viewController transition:transition forceImmediate:NO];
}

- (id)_nthChildViewControllerFromTop:(unsigned long long)arg1 {
    return nil;
}

- (id)_findViewControllerToPopTo {
    return nil;
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return nil;
}

- (BOOL)_shouldBottomBarBeHidden {
    return YES;
}

- (void)_resetBottomBarHiddenState {
    self->_navigationControllerFlags.didHideBottomBar = NO;
}

- (void)_updateBottomBarHiddenState {
    [self _hideOrShowBottomBarIfNeededWithTransition:nil];
}

- (void)_hideOrShowBottomBarIfNeededWithTransition:(int)transition {

}

@end

