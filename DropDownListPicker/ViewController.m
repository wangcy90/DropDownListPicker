//
//  ViewController.m
//  DropDownListPicker
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/6/8.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import "ViewController.h"
#import "DropDownListPicker.h"

@interface ViewController () {
    BOOL _showPicker;
    NSString *_selectedTitle;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target actions

- (IBAction)click:(id)sender {
    
    if (!_showPicker) {
        
        NSArray *areas = @[@"北京",@"上海",@"广州",@"深圳",@"杭州"];
        
        if (!_selectedTitle) {
            _selectedTitle = areas.firstObject;
        }
        
        DropDownListPicker *picker = [[DropDownListPicker alloc]initWithOrigin:CGPointMake(0, 64) title:@"选择地区" itemTitles:areas selectedTitle:_selectedTitle selection:^(NSInteger selectedIndex) {
            
            _showPicker = NO;
            
            NSLog(@"%@",@(selectedIndex));
            
            if (selectedIndex != NSNotFound) {
                _selectedTitle = areas[selectedIndex];
            }
            
        }];
        
        [picker showInView:self.navigationController.view];
        
        _showPicker = YES;
    }
    
}

@end
