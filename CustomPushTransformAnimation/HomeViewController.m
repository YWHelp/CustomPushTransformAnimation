//
//  HomeViewController.m
//  CustomPushTransformAnimation
//
//  Created by changcai on 17/6/27.
//  Copyright © 2017年 changcai. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "PushTransformAnimation.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
/**   */
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.title  = @"转场动画";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //主线程执行
        //        [self.navigationController setNavigationBarHidden:NO];
        //        self.tabBarController.tabBar.hidden = NO;
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    
}

#pragma mark  --UITableViewDelegate/UITableViewDataSource ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    cell.contentView.backgroundColor = [UIColor redColor];
    NSString *value = @"-0";
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",value.integerValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    //testVc.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    self.popRect = rect;
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:detailVc  animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth([UIScreen mainScreen].bounds), 10)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

-( id<UIViewControllerAnimatedTransitioning> )navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    return [[PushTransformAnimation alloc]initWithTransitionType:TransformAnimationTypePush];
}


@end

