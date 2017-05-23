//
//  ViewController.m
//  MyActionSheetView
//
//  Created by 梅毅 on 2017/5/23.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ViewController.h"
#import "MyActionSheetView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView        *headView;
@property (nonatomic, strong) NSArray       *dataArray;


@end


@implementation ViewController
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"苹果地图",@"高德地图",@"百度地图",@"谷歌地图"];
    }
    
    return _dataArray;
}
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 20, 100)];
        _headView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _headView.frame.size.height/2-15, self.view.bounds.size.width-20, 30)];
        titleLab.text = @"请选择导航";
        titleLab.textColor = [UIColor redColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:titleLab];
    }
    return _headView;
}
- (IBAction)buttonClicked:(id)sender
{
    __weak typeof(self)weakSelf = self;
    MyActionSheetView *actionSheetView = [[MyActionSheetView alloc] initWithTitleView:self.headView optionArr:self.dataArray cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
        NSString  *optionStr = weakSelf.dataArray[index];
        NSLog(@"%@",optionStr);
    } cancelBlock:^{
        NSLog(@"取消");
    }];
    [self.view addSubview:actionSheetView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}





@end
