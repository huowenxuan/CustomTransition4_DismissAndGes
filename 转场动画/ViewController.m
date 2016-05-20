//
//  ViewController.m
//  转场动画
//
//  Created by 霍文轩 on 15/10/30.
//  Copyright © 2015年 霍文轩. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "PresentTransition.h"
#import "DismissTransition.h"

@interface ViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition * percentDrivenTransition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    [self addScreenEdgePanGestureRecognizer:self.view edges:UIRectEdgeRight]; // 为self.view增加右侧的手势，用于push
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"i5.png"];
    imageView.userInteractionEnabled = NO;
    
    UIButton * presentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    presentButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:presentButton];
    presentButton.backgroundColor = [UIColor blackColor];
    [presentButton setTitle:@"present" forState:UIControlStateNormal];
    [presentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [presentButton addTarget:self action:@selector(presentClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)presentClick{
    SecondViewController * secondVC = [[SecondViewController alloc] init];
    secondVC.transitioningDelegate = self; // 必须second同样设置delegate才有动画
    [self addScreenEdgePanGestureRecognizer:secondVC.view edges:UIRectEdgeLeft];
    [self presentViewController:secondVC animated:YES completion:^{
    }];
}
// present动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentTransition alloc] init];
}
// dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissTransition alloc] init];
}
// 添加手势的方法
- (void)addScreenEdgePanGestureRecognizer:(UIView *)view edges:(UIRectEdge)edges{
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)]; // viewController和SecondViewController的手势都由self管理
    edgePan.edges = edges;
    [view addGestureRecognizer:edgePan];
}
// 手势的监听方法
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x / [UIApplication sharedApplication].keyWindow.bounds.size.width);// 有两个手势，所以这里计算百分比使用的是 KeyWindow
    
    if(edgePan.state == UIGestureRecognizerStateBegan){
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        if(edgePan.edges == UIRectEdgeRight){
            // present，避免重复，直接调用点击方法
            [self presentClick];
        }else if(edgePan.edges == UIRectEdgeLeft){
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }else if(edgePan.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if(edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded){
        if(progress > 0.5){
            [_percentDrivenTransition finishInteractiveTransition];
        }else{
            [_percentDrivenTransition cancelInteractiveTransition];
        }
        _percentDrivenTransition = nil;
    }
}
#pragma mark - UIViewControllerTransitioningDelegate另外两个方法，返回动画的百分比
// 百分比present
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}
// 百分比dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _percentDrivenTransition;
}
@end
