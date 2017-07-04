//
//  PushTransformAnimation.m
//  CustomPushTransformAnimation
//
//  Created by changcai on 17/6/27.
//  Copyright © 2017年 changcai. All rights reserved.
//

#import "PushTransformAnimation.h"
#import "HomeViewController.h"

@interface PushTransformAnimation()
@property (nonatomic, assign) TransformAnimationType type;
@end

@implementation PushTransformAnimation
- (instancetype)initWithTransitionType:(TransformAnimationType)type
{
    if (self == [super init]) {
        _type = type;
    }
    return self;
}

//指定转场动画持续的时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case TransformAnimationTypePush:
            [self pushTransform:transitionContext];
            break;
        case TransformAnimationTypePop:
            [self popTransform:transitionContext];
            break;
        default:
            break;
    }
}

//转场动画的具体内容
- (void)pushTransform:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *contentView = [transitionContext containerView];
    contentView.backgroundColor = [UIColor blackColor];
    
    //原始的控制器
    HomeViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //放大的视图
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = [contentView convertRect:fromVC.popRect fromView:fromVC.view];
    tempView.backgroundColor = [UIColor blueColor];
    
    //Y缩放比例
    CGFloat tempViewYScale = CGRectGetMidY(tempView.frame) > CGRectGetMidY(contentView.bounds) ? 2*CGRectGetMidY(tempView.frame)/CGRectGetHeight(tempView.frame) : 2*(CGRectGetHeight(contentView.bounds)-CGRectGetMidY(tempView.frame))/CGRectGetHeight(tempView.bounds);
    
    //目标控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获取屏幕快炸
    UIView  *snapShotView = [fromVC.navigationController.view.window snapshotViewAfterScreenUpdates:NO];
    snapShotView.tag = 4444;
    snapShotView.frame = [contentView convertRect:fromVC.navigationController.view.frame fromView:fromVC.navigationController.view];
    fromVC.view.alpha = 0.0;
    //fromVC.view.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0.0;
    
    [contentView addSubview:snapShotView];
    [contentView addSubview:tempView];
    [contentView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         snapShotView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:[self transitionDuration:transitionContext]-0.2  animations:^{
                             
                             tempView.transform = CGAffineTransformMakeScale(1, tempViewYScale);
                             
                         } completion:^(BOOL finished) {
                             
                             [tempView removeFromSuperview];
                             
                             toVC.view.alpha = 1.0;
                             //添加
                             fromVC.view.alpha = 0.0;
                             //告诉系统动画结束
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
                     }];
    
}

- (void)popTransform:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor blackColor];
    //目标控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    NSArray *subviewsArray = containerView.subviews;
    UIView *tempView = subviewsArray.firstObject;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] - 0.1 animations:^{
        
        fromVC.view.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            fromVC.view.transform = CGAffineTransformIdentity;
            tempView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            toVC.view.alpha = 1.0;
            [toVC.navigationController setNavigationBarHidden:NO];
            toVC.tabBarController.tabBar.hidden = NO;
            [tempView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }];
    
}
@end
