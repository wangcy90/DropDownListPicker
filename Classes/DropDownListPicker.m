//
//  DropDownListPicker.m
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

#import "DropDownListPicker.h"

#define itemHeight 40
#define itemSpacing 8

#define kFontSize 14
#define kBackgroundColor [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f]
#define kMainColor [UIColor colorWithRed:72/255.0f green:190/255.0f blue:216/255.0f alpha:1.0f]
#define kFontColor [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f]

@interface DropDownListPickerCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation DropDownListPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 5;
    }
    return _titleLabel;
}

@end

@interface DropDownListPicker()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UIView *_backgroundView;
    UICollectionView *_collectionView;
    UILabel *_titleLabel;
    NSString *_title;
    NSString *_selectedTitle;
    NSArray *_dataSource;
    void (^_selectHandler)(NSInteger selectedIndex);
}

@property(nonatomic,assign)NSInteger itemsInRow;

@end

@implementation DropDownListPicker

- (instancetype)initWithOrigin:(CGPoint)origin title:(NSString *)title itemTitles:(NSArray<NSString *> *)itemTitles selectedTitle:(NSString *)selectedTitle selection:(void (^)(NSInteger))selection {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)]) {
        _title = title;
        _selectedTitle = selectedTitle;
        _dataSource = itemTitles;
        _selectHandler = [selection copy];
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    
    _backgroundView = [[UIView alloc]init];
    _backgroundView.backgroundColor = kBackgroundColor;
    
    if (_title.length > 0) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        _titleLabel.textColor = kFontColor;
        _titleLabel.text = _title;
        [_backgroundView addSubview:_titleLabel];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = itemSpacing;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[DropDownListPickerCell class] forCellWithReuseIdentifier:@"DropDownListPickerCell"];
    _collectionView.backgroundColor = kBackgroundColor;
    [_backgroundView addSubview:_collectionView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (!CGRectContainsPoint(_backgroundView.frame, point)) {
        !_selectHandler ? : _selectHandler(NSNotFound);
        [self hide];
    }
    
}

- (void)showInView:(UIView *)view {
    
    [self animateSelfInView:view show:YES completion:^{
        [self animateBackgroundView:_backgroundView show:YES completion:NULL];
    }];
    
}

- (void)hide {
    
    [self animateBackgroundView:_backgroundView show:NO completion:^{
        [self animateSelfInView:nil show:NO completion:NULL];
    }];
    
}

- (void)animateSelfInView:(UIView *)view show:(BOOL)show completion:(void(^)())completion {
    
    if (show) {
        
        [view addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
    
    !completion ? : completion();
}

- (void)animateBackgroundView:(UIView *)backgroundView show:(BOOL)show completion:(void(^)())completion {
    
    if (show) {
        
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
        
        _titleLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 0);
        
        _collectionView.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 0);
        
        [self addSubview:backgroundView];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        NSInteger rowNum = ceilf(_dataSource.count/(float)self.itemsInRow);
        
        CGFloat collectionViewHeight = rowNum * itemHeight + (rowNum - 1) * 10;
        
        CGFloat height = collectionViewHeight + 36;
        
        if (_title.length > 0) {
            height += 20 + 10;
        }
        
        height = MIN(height, screenHeight - 64 * 2);
        
        [UIView animateWithDuration:0.2 animations:^{
            backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), height);
            CGFloat offsetY = 18;
            if (_titleLabel) {
                _titleLabel.frame = CGRectMake(15, offsetY, CGRectGetWidth(self.bounds) - 30, 20);
                offsetY += 30;
            }
            _collectionView.frame = CGRectMake(15, offsetY, CGRectGetWidth(self.bounds) - 30, collectionViewHeight);
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _titleLabel.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 0);
            
            _collectionView.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 0);
            
            backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0);
            
        } completion:^(BOOL finished) {
            
            [backgroundView removeFromSuperview];
            
        }];
        
    }
    
    !completion ? : completion();
}

#pragma mark - UICollectionView methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger items = self.itemsInRow;
    
    return CGSizeMake(floor((CGRectGetWidth(collectionView.bounds) - (items - 1) * itemSpacing)/items), itemHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DropDownListPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DropDownListPickerCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = _dataSource[indexPath.row];
    
    BOOL selected = [_selectedTitle isEqualToString:_dataSource[indexPath.row]];
    
    cell.titleLabel.backgroundColor = selected ? kMainColor : [UIColor whiteColor];
    
    cell.titleLabel.textColor = selected ? [UIColor whiteColor] : kFontColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !_selectHandler ? : _selectHandler(indexPath.row);
    
    [self hide];
}

#pragma mark - getters

- (NSInteger)itemsInRow {
    if (_itemsInRow == 0) {
        _itemsInRow = 3;
    }
    return _itemsInRow;
}

@end
