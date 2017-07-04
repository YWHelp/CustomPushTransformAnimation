//
//  DetailViewController.m
//  CustomPushTransformAnimation
//
//  Created by changcai on 17/6/27.
//  Copyright © 2017年 changcai. All rights reserved.
//

#import "DetailViewController.h"
#import "PushTransformAnimation.h"

@interface DetailViewController ()<UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL isDismissAnimation;
/**   */
@property (nonatomic, strong) UIView *customView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报价详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.customView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview: self.customView];
    self.customView.backgroundColor = [UIColor redColor];
    self.customView.alpha = 0.0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    [self.navigationController setNavigationBarHidden:YES];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //主线程执行
        [UIView animateWithDuration:0.8  animations:^{
            self.customView.alpha = 1.0;
            
        } completion:nil];
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    self.title = @"iOS";
    [self.navigationController setNavigationBarHidden:YES];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    //if (!_isDismissAnimation) {
    PushTransformAnimation *inverseTransition = [[PushTransformAnimation alloc]initWithTransitionType:TransformAnimationTypePop];
    return inverseTransition;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
