//
//  MyActionSheetView.h
//  MyActionSheetView
//
//  Created by 梅毅 on 2017/5/23.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionSheetView : UIView
- (instancetype)initWithTitleView:(UIView *)titleView
                        optionArr:(NSArray *)optionArr
                      cancelTitle:(NSString *)cancelTitle
                    selectedBlock:(void(^)(NSInteger))selectedBlock
                      cancelBlock:(void(^)())cancelBlock;
@end
