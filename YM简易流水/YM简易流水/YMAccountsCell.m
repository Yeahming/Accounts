//
//  YMAccountsCell.m
//  YM简易流水
//
//  Created by Yeahming on 15/7/26.
//  Copyright © 2015年 Yeahming. All rights reserved.
//

#import "YMAccountsCell.h"
#import "YMPersonalItem.h"

@interface YMAccountsCell()
/** 图片 */
@property (nonatomic, weak) UIImageView  *iconImageView;
@property (nonatomic, weak) UILabel  *typeLabel;
@property (nonatomic, weak) UILabel  *detailMoneysLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UILabel  *remarkLabel;

@end
@implementation YMAccountsCell

- (void)awakeFromNib {
    // Initialization code
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 图片
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        iconImageView.contentMode = UIViewContentModeScaleToFill;
        // 流水类型label
        UILabel *typeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:typeLabel];
        typeLabel.font = [UIFont systemFontOfSize:14];
        self.typeLabel = typeLabel;
        
        // 流水金额
        UILabel *detailMoneysLabel = [[UILabel alloc] init];
        [self.contentView addSubview:detailMoneysLabel];
        
        self.detailMoneysLabel = detailMoneysLabel;
        // 日期
        UILabel *dateLabel = [[UILabel alloc] init];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        // 备注
        UILabel *remarkLabel = [[UILabel alloc] init];
        [self.contentView addSubview:remarkLabel];
        self.remarkLabel = remarkLabel;
        remarkLabel.textAlignment = NSTextAlignmentRight;
        remarkLabel.font = [UIFont systemFontOfSize:12];
        remarkLabel.textColor = [UIColor brownColor];
         //分割线
        UIView *lineView = [[UIView alloc] init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        
        
        // 约束
        // 图片
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(YMmargin*2);
            make.top.equalTo(self).offset(YMmargin);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
        
        //收入类型
        [typeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.right).offset(YMmargin);
            make.right.equalTo(detailMoneysLabel.left).offset(-YMmargin);
            make.centerY.equalTo(iconImageView);
        }];
        
        // 具体金额
        [detailMoneysLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(typeLabel);
            make.right.equalTo(self).offset(-YMmargin*2);
        }];
        
        // 日期
        [dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(YMmargin*2);
            make.top.equalTo(iconImageView.bottom).offset(YMmargin);
            make.bottom.equalTo(lineView.top);
            
        }];
        
        // 备注
        [remarkLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.right).offset(YMmargin);
            make.right.equalTo(self).offset(-YMmargin);
            make.bottom.equalTo(lineView.top);
        }];
        // 分割线
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(1);
        }];
        
    }
    return self;
}


#pragma mark - 设置数据
- (void)setPersonalItem:(YMPersonalItem *)personalItem
{
    _personalItem = personalItem;

    if (personalItem.itemType == YMPersonalItemTypeIncome) {// 收入
        
        self.iconImageView.image = [UIImage imageNamed:@"收入"];
        self.typeLabel.text = @"收入";
        
        self.detailMoneysLabel.text = [NSString stringWithFormat:@"+%@",personalItem.income];
    }else
    {
        self.iconImageView.image = [UIImage imageNamed:@"支出"];
        self.typeLabel.text = @"支出";
        
        self.detailMoneysLabel.text = [NSString stringWithFormat:@"-%@",personalItem.expend];
    }
    // 获取模型中时间
    NSString *currenDate = personalItem.date;
    
    // 备注
    if (personalItem.remark.length == 0 || personalItem.remark == nil) {// 如果为空，设置为默认
         personalItem.remark =  @"备注:(左滑添加)";
    }
    self.remarkLabel.text=  personalItem.remark;
    
    if (currenDate == nil || currenDate.length == 0) {// 如果时间为空，则设置当前时间为默认时间
        NSDate *date = [NSDate date];
        NSDateFormatter *fmr = [[NSDateFormatter alloc] init];
        fmr.dateFormat = @"yyyy-MM-dd";
        currenDate = [fmr stringFromDate:date];
    }
    self.dateLabel.text = currenDate;
    self.dateLabel.textColor = [UIColor brownColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}










@end
