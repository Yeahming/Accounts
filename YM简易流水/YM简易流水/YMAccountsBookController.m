//
//  YMAccountsBookController.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/25.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import "YMAccountsBookController.h"
#import "YMPersonalAccountsViewController.h"
#import "YMFamilyAccountsTableViewController.h"
#import "YMNavigationViewController.h"


@interface YMAccountsBookController ()

@end

@implementation YMAccountsBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor brownColor];
    [self setChildViewControllers];
    
    
}

- (void)setChildViewControllers
{
    // 个人
    YMPersonalAccountsViewController *personalVC = [[YMPersonalAccountsViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
    [self setEachController:personalVC andImage:[UIImage imageNamed:@"个人"] andTitle:@"个人"];
    
    
    // 家庭
    YMFamilyAccountsTableViewController *familyVC = [[YMFamilyAccountsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setEachController:familyVC andImage:[UIImage imageNamed:@"家庭"] andTitle:@"家庭"];
    
}

- (void)setEachController:(UIViewController *)viewConroller andImage:(UIImage *)titleImage andTitle:(NSString *)title
{

    // 包装为导航控制器
    YMNavigationViewController *naviVC = [[YMNavigationViewController alloc] initWithRootViewController:viewConroller];
    
    
    // 添加到UITabBarController的子控制器显示
    [self addChildViewController:naviVC];
    
    // 设置tabbar显示属性
    naviVC.title = title;
    naviVC.tabBarItem.image = titleImage;

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
