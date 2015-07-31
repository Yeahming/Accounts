//
//  YMAddRecordViewController.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/28.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import "YMAddRecordViewController.h"
#import "YMPersonalItem.h"

@interface YMAddRecordViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
/** 记录类型选择器 */
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
/** 金额 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
/** 时间 */
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
/** 记录类型 */
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
/** 日期选择器 */
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation YMAddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 不设置，pickerView 是不会调用相关方法
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    [self pickerView:self.typePicker didSelectRow:0 inComponent:0];
    
    // 设置日期键盘
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode  = UIDatePickerModeDate;
    datePicker.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    self.dateTextField.inputView = datePicker;
    self.datePicker = datePicker;
    
    // 设置文本框代理
    self.dateTextField.delegate = self;
    // 因为datePicker 没有代理方法
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:(UIControlEventValueChanged)];
}

// 实现日期选择器的监听方法
- (void)dateChange:(UIDatePicker *)datePicker
{
    // 设置文本框显示的日期
    NSDate *currentDate = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:currentDate];
    self.dateTextField.text = dateString;
    
}

#pragma mark - UITextFieldDelegate(文本框代理方法)
- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    [self dateChange:self.datePicker];
}
/** 返回事件监听 */
- (IBAction)backBtnClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
/** 保存事件监听 */
- (IBAction)saveBtnClicked:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:NO];
    
    // 由填写内容生成一个模型，以便传递
    YMPersonalItem *item = [[YMPersonalItem alloc] init];
    
    // 金额不能为空
    if (self.moneyTextField.text.length == 0) {
        // 提示不能为空,并返回
        [MBProgressHUD showError:@"金额不能为空！"];
        return;
    }
    if ([self.typeTextField.text isEqualToString:@"收入"]) {
        // 记录类型
        item.itemType = YMPersonalItemTypeIncome;
        // 收入金额
        item.income = self.moneyTextField.text;
            }else
    {
        item.itemType = YMPersonalItemTypeExpend;
        item.expend = self.moneyTextField.text;
    }
    
    // 记录日期
    item.date = self.dateTextField.text;

    if ([self.delegate respondsToSelector:@selector(saveBtnClicked:andContents:)]) {
        [self.delegate saveBtnClicked:sender andContents:item];
    }
    
    // 返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(nonnull UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"收入";
    }else
    {
        return @"支出";
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(nonnull UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (void)pickerView:(nonnull UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 设置文本框内容
    if (row == 0) {
        self.typeTextField.text = @"收入";
    }else
    {
        self.typeTextField.text = @"支出";
    }
}

// 点击view，取消编辑模式
- (void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event
{
    [self.view endEditing:YES];
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
