//
//  DropDownListPicker.h
//  DropDownListPicker
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/3/14.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownListPicker : UIView

- (instancetype)initWithOrigin:(CGPoint)origin title:(NSString *)title itemTitles:(NSArray<NSString *> *)itemTitles selectedTitle:(NSString *)selectedTitle  selection:(void (^)(NSInteger selectedIndex))selection;

- (void)showInView:(UIView *)view;

@end
