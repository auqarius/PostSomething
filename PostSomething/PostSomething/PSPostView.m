//
//  PSPostView.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSPostView.h"
#import "PSTitleView.h"
#import "PSContentView.h"
#import <Masonry/Masonry.h>
#import "PSTool.h"

@interface PSPostView() <PSContentViewDelegate, PSTitleiewDelegate>
{
    PSTitleView *_titleView;
    PSContentView *_contentView;
}

@end

@implementation PSPostView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleView = [[PSTitleView alloc] initWithFrame:CGRectZero];
        _titleView.delegate = self;
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        _contentView = [[PSContentView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate = self;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(56);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startInputLastView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Public

- (CGFloat)viewHeight {
    CGFloat height = (CGRectGetMaxY(_contentView.frame) + 8) > (PSTool.screenHeight - 64 - 44) ? (CGRectGetMaxY(_contentView.frame) + 8) : (PSTool.screenHeight - 64 - 44);
    self.frame = CGRectMake(0, 0, PSTool.screenWidth, height);
    return height;
}

- (void)addNewImage:(UIImage *)image {
    [_contentView addImage:image];
}

- (PSInputVIew *)nowInputView {
    return _contentView.nowInputView;
}

- (NSString *)postTitle {
    return _titleView.inputedTitle;
}

- (NSArray *)postContent {
    return _contentView.inputedContents;
}

#pragma mark - Private

- (void)updatelayout {
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(_titleView.viewHeight);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(_contentView.viewHeight);
        make.top.equalTo(_titleView.mas_bottom).offset(0);
    }];
    
    [self layoutIfNeeded];
    [self postSelfHeight];
}

- (void)postSelfHeight {
    if ([self.delegate respondsToSelector:@selector(psPostView:didChangeHeight:)]) {
        [self.delegate psPostView:self didChangeHeight:[self viewHeight]];
    }
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [_titleView resignFirstResponder];
    [_contentView resignFirstResponder];
    return YES;
}

- (void)startInputLastView {
    [_contentView becomeFirstResponder];
}

#pragma mark - PSContentViewDelegate

- (void)psContentView:(PSContentView *)contentView didChangeHeight:(CGFloat)height {
    [self updatelayout];
}

- (void)psContentView:(PSContentView *)contentView beginEdit:(PSInputVIew *)psInputView {
    if ([self.delegate respondsToSelector:@selector(psPostView:beginEdit:)]) {
        [self.delegate psPostView:self beginEdit:psInputView];
    }
}

#pragma mark - PSTitleiewDelegate

- (void)psTitleView:(PSTitleView *)contentView didChangeHeight:(CGFloat)height {
    [self updatelayout];
}

- (void)psTitleViewDidReturn:(PSTitleView *)contentView {
    [_contentView startInputFirstView];
}

@end
