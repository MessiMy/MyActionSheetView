//
//  MyActionSheetView.m
//  MyActionSheetView
//
//  Created by 梅毅 on 2017/5/23.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MyActionSheetView.h"
#import "ActionSheetViewwCell.h"

#define ScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define SPACE  10

@interface MyActionSheetView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView        *maskView;
@property (nonatomic, strong) UITableView   *contentView;
@property (nonatomic, strong) NSArray       *dataArray;
@property (nonatomic, copy)   void(^selectedBlock)(NSInteger);
@property (nonatomic, copy)   void(^cancelBlock)();
@property (nonatomic, strong) UIView        *headView;
@property (nonatomic, strong) NSString      *cancelTitle;

@end

@implementation MyActionSheetView
#pragma mark - 懒加载
-(UIView *)maskView
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}
-(UITableView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentView.showsVerticalScrollIndicator =NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.bounces = NO;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.rowHeight = 44.0;
        _contentView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        _contentView.tableHeaderView = self.headView;
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView registerNib:[UINib nibWithNibName:@"ActionSheetViewwCell" bundle:nil] forCellReuseIdentifier:@"ActionSheetViewCell"];
    }
    return _contentView;
}
- (instancetype)initWithTitleView:(UIView *)titleView
                        optionArr:(NSArray *)optionArr
                      cancelTitle:(NSString *)cancelTitle
                    selectedBlock:(void(^)(NSInteger))selectedBlock
                      cancelBlock:(void(^)())cancelBlock
{
    self = [super init];
    if (self) {
        _headView = titleView;
        _dataArray = optionArr;
        _cancelTitle = cancelTitle;
        _selectedBlock = selectedBlock;
        _cancelBlock = cancelBlock;
        [self initUI];
    }
    return self;
}
#pragma mark - initView
- (void)initUI
{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
}
#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? self.dataArray.count : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionSheetViewwCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionSheetViewCell"];
    if (indexPath.section == 0) {
        cell.nameLab.text = self.dataArray[indexPath.row];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == self.dataArray.count - 1) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth - SPACE *2, tableView.rowHeight) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.contentView.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
        return cell;
        
    }
    cell.nameLab.text = self.cancelTitle;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.selectedBlock(indexPath.row);
    }
    else
    {
        self.cancelBlock();
    }
    [self dismiss];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SPACE;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SPACE)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self show];
}
#pragma mark - 显示
- (void)show
{
    _contentView.frame = CGRectMake(SPACE, ScreenHeight, ScreenWidth - SPACE *2, _contentView.rowHeight * (self.dataArray.count + 1) + _headView.bounds.size.height + SPACE * 2);
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _contentView.frame;
        rect.origin.y -= _contentView.bounds.size.height;
        _contentView.frame = rect;
    }];
}
#pragma mark - disappear
- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _contentView.frame;
        rect.origin.y += _contentView.bounds.size.height;
        _contentView.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - 点击屏幕视图消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
@end
