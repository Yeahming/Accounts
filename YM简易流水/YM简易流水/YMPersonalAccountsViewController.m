//
//  YMPersonalAccountsViewController.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/25.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import "YMPersonalAccountsViewController.h"
#import "YMAccountsCell.h"
#import "YMAddRecordViewController.h"

@interface YMPersonalAccountsViewController ()<YMAddRecordViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, weak) UITextField  *remarkTextField;

@property (nonatomic, weak) UIView  *cover;
@property (nonatomic, strong) NSIndexPath *selecedIndexPath;

@end

@implementation YMPersonalAccountsViewController
- (instancetype)init
{
    return [super initWithStyle:(UITableViewStylePlain)];
}
// 懒加载
- (NSMutableArray *)itemsArr
{
    if (_itemsArr == nil) {
        _itemsArr = [NSMutableArray array];
    }
    // 将数组中的数据进行排序
    NSSortDescriptor *descritor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [_itemsArr sortUsingDescriptors:@[descritor]];
    
    return _itemsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    YMPersonalItem *item1 = [[YMPersonalItem alloc] init];
    item1.itemType = YMPersonalItemTypeIncome;
    item1.income = @"1000";
    
    YMPersonalItem *item2 = [[YMPersonalItem alloc] init];
    item2.itemType = YMPersonalItemTypeExpend;
    item2.expend = @"800";
    
    [self.itemsArr addObject:item1];
    [self.itemsArr addObject:item2];
    //
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"个人";
    
    // 清空操作
    UIBarButtonItem *cleanAll = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithAlwaysOriginalRenderingModelFromImageName:@"empty"] style:(UIBarButtonItemStyleDone) target:self action:@selector(cleanAll:)];
    self.navigationItem.rightBarButtonItem = cleanAll;
    
}

#pragma mark - UIActionSheetDelegate(代理方法)
- (void)actionSheet:(nonnull UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.itemsArr removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)cleanAll:(UIBarButtonSystemItem *)cleanBtn
{
    UIActionSheet *aler = [[UIActionSheet alloc] initWithTitle:@"删除全部记录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    [aler showInView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source(数据源方法)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArr.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出模型
    YMPersonalItem *persnalItem = self.itemsArr[indexPath.row];
    static NSString *ID = @"accountCell";
    
    YMAccountsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YMAccountsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    // 设置数据
    cell.personalItem = persnalItem;
    

    return cell;
}

#pragma mark - UITableViewDelegate(tableView代理方法)
- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}
- (nullable NSArray *)tableView:(nonnull UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSMutableArray *rowActionArray = [NSMutableArray array];
    
    // 删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        // 删除模型数据，刷新表格
         [self.itemsArr removeObject:self.itemsArr[indexPath.row]];
        [self.tableView reloadData];
    }];
    // 编辑备注
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"备注" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        self.selecedIndexPath = indexPath;
       
        // 拿到窗口
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        CGRect frame = cover.frame;
        frame.origin.y += 69;
        cover.frame = frame;
        cover.backgroundColor = [UIColor whiteColor];
        // 取消按钮
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
        [cover addSubview:closeBtn];
        // 监听点击
        [closeBtn addTarget:self action:@selector(cancelRemark:) forControlEvents:(UIControlEventTouchUpInside)];
        closeBtn.frame = CGRectMake(cover.bounds.size.width- 52, 0, 50, 50);
        [keyWindow addSubview:cover];
        
        self.cover = cover;
        cover.alpha = 0;
        UITextField *remarkField = [[UITextField alloc] init];
        self.remarkTextField = remarkField;
        // 设置文本框代理
        remarkField.delegate = self;
        // placeholder
        remarkField.placeholder = @"说点什么（15字以内)";
        // 字体颜色
        remarkField.tintColor = [UIColor brownColor];
        remarkField.backgroundColor = [UIColor whiteColor];
        // 设置frame
        remarkField.frame = CGRectMake(0, 0, 200, 30);
        remarkField.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5);
        // 添加到窗口
        [keyWindow addSubview:remarkField];
        
        remarkField.alpha = 0;
        // 渐入式动画
        [UIView animateWithDuration:0.5 animations:^{
            cover.alpha = 0.8;
            remarkField.alpha = 1;
        }];
    }];
    
    // 添加左滑按钮选项
    [rowActionArray addObject:deleteAction];
    [rowActionArray addObject:editAction];
                                          
    return rowActionArray;
}

// 取消备注
- (void)cancelRemark:(UIButton *)closeBtn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.remarkTextField.alpha = 0;
        closeBtn.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.remarkTextField removeFromSuperview];
        [closeBtn.superview removeFromSuperview];
    }];
    }

#pragma mark -UITextFieldDelegate(文本框代理方法)
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField
{
    
    // 添加模型中数据，刷新表格
    NSIndexPath *indexPath = self.selecedIndexPath;
    YMPersonalItem *item = self.itemsArr[indexPath.row];
    
    NSString *remark = self.remarkTextField.text;
    item.remark = remark;
    
    [self.tableView reloadData];
    // 移除文本框和遮盖
    [textField removeFromSuperview];
    [self.cover removeFromSuperview];
    return YES;
}

#pragma mark - 头部视图
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  30;
}
- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 余额
    UIButton *savings = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [savings setImage:[UIImage imageNamed:@"savings"] forState:(UIControlStateNormal)];
    [savings setTitle:[NSString stringWithFormat:@"%.2f",[self getSavings]] forState:(UIControlStateNormal)];
    [savings setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    savings.font = [UIFont systemFontOfSize:14];
    // 设置位置
    savings.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, 22);
    return savings;
}

// 获取总余额
- (float)getSavings
{
    float savings = 0;
    for (YMPersonalItem *item in self.itemsArr) {
        if (item.itemType == YMPersonalItemTypeIncome) {
            savings += item.income.floatValue;
        }else
        {
            savings -= item.expend.floatValue;
        }
        
    }
    return savings;
}
#pragma mark - 尾部视图
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(nonnull UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // 添加一个button
    UIButton *headerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    // 监听按钮点击
    [headerView addTarget:self action:@selector(addRecord:) forControlEvents:(UIControlEventTouchDown)];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.alpha = 0.5;
    [headerView setTitle:@"记一笔" forState:(UIControlStateNormal)];
    [headerView setTitleColor:[UIColor brownColor] forState:(UIControlStateNormal)];
    [headerView setImage:[UIImage imageNamed:@"add_normal"] forState:(UIControlStateNormal)];
    [headerView setImage:[UIImage imageNamed:@"add_highlight"] forState:(UIControlStateHighlighted)];
    // 设置位置
    headerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, 22);
    return headerView;
    
}
#pragma mark - 添加开支记录
- (void)addRecord:(UIButton *)addBtn
{
    // modal出添加界面(故事板中加载)
    UIStoryboard *addBoard = [UIStoryboard storyboardWithName:@"YMAddRecordViewController" bundle:nil];
    YMAddRecordViewController *addVC = [addBoard instantiateInitialViewController];
    // 设置代理
    addVC.delegate = self;
    addVC.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:246/255.0 alpha:1];
    [self presentViewController:addVC animated:YES completion:nil];

}
#pragma mark - YMAddRecordViewControllerDelegate(添加界面代理)
- (void)saveBtnClicked:(UIButton *)button andContents:(YMPersonalItem *)item
{
    // 添加到模型数组中
    [self.itemsArr addObject:item];
    // 刷新
    [self.tableView reloadData];
}

#pragma mark - 代理方法
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
