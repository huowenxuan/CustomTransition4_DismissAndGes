//
//  CustomViewControllerTransition.m
//  转场动画
//
//  Created by 霍文轩 on 15/10/30.
//  Copyright © 2015年 霍文轩. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "DismissTransition.h"

@interface DismissTransition()
@end

@implementation DismissTransition
// 返回动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.8;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    SecondViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    [container addSubview:toVC.view];
    
    // 改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;
    
    // 设置archPoint和position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    toVC.view.frame = initalFrame;
    toVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    toVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    toVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
    
    // 添加阴影效果
    CAGradientLayer * shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.colors =@[
                         [UIColor colorWithWhite:0 alpha:1],
                         [UIColor colorWithWhite:0 alpha:0.5],
                         [UIColor colorWithWhite:1 alpha:0.5]
                         ];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    
    UIView * shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [toVC.view addSubview:shadow];
    shadow.alpha = 1;
    
    // 动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:2 animations:^{
        toVC.view.layer.transform = CATransform3DIdentity;
        shadow.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        [shadow removeFromSuperview];
        
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]];
    }];
}

@end
