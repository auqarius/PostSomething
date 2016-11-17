//
//  PSImageView.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSImageView.h"
#import "PSTool.h"
#import <Masonry/Masonry.h>
#import "UIView+Post.h"

@interface PSImageView()
{
    UIImageView *_imageView;
    UIButton *_removeButton;
}

@end

@implementation PSImageView

+ (PSImageView *)createInView:(UIView <PSImageViewDelegate>*)superView andImage:(UIImage *)image downViewAttr:(MASViewAttribute *)viewAttr {
    PSImageView *imageView = [[self alloc] initWithFrame:CGRectZero];
    imageView.delegate = superView;
    imageView.lastViewAttr = viewAttr;
    imageView.image = image;
    [superView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(8);
        make.right.equalTo(superView.mas_right).offset(-8);
        make.height.mas_equalTo(imageView.viewHeight);
        make.top.equalTo(viewAttr).offset(8);
    }];
    return imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PSTool.screenWidth, 0)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(2);
            make.right.equalTo(self.mas_right).offset(-2);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setTitle:@"删除" forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeButton setBackgroundColor:[UIColor blackColor]];
        [_removeButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_removeButton];
        [_removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imageView.mas_right).offset(0);
            make.top.equalTo(_imageView.mas_top).offset(0);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
    }
    return self;
}

- (void)removeSelf {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(psImageViewDidRemove:)]) {
            [self.delegate psImageViewDidRemove:self];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"不了" style:(UIAlertActionStyleDefault) handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Public

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

- (UIImage *)image {
    return _imageView.image;
}

- (CGFloat)viewHeight {
    return _imageView.viewHeight;
}

@end
