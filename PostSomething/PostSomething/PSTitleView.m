//
//  PSTitleView.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSTitleView.h"
#import "PSTool.h"
#import <Masonry/Masonry.h>
#import "PSInputVIew.h"
#import "UIView+Post.h"

@interface PSTitleView() < PSInputVIewDelegate >
{
    PSInputVIew *_titleInputView;
}

@end

@implementation PSTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleInputView = [PSInputVIew createInView:self downViewAttr:self.mas_top];
        _titleInputView.placeHolder = @"标题 (3-25个字)";
        _titleInputView.maxLength = 25;
        [_titleInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.height.mas_equalTo(_titleInputView.viewHeight);
            make.top.equalTo(_titleInputView.lastViewAttr).offset(0);
        }];
        
        UIView *downLine = [[UIView alloc] init];
        downLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(_titleInputView.mas_bottom).offset(-0.5);
        }];
        
        UIView *leftRedView = [[UIView alloc] init];
        leftRedView.backgroundColor = [UIColor redColor];
        [self addSubview:leftRedView];
        [leftRedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(2);
            make.top.equalTo(self.mas_top).offset(8);
        }];
    }
    return self;
}

#pragma mark - Public

- (NSString *)inputedTitle {
    return _titleInputView.content;
}

#pragma mark - Private

- (void)updateLayout {
    [_titleInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.height.mas_equalTo(_titleInputView.viewHeight);
        make.top.equalTo(_titleInputView.lastViewAttr).offset(0);
    }];
    [self layoutIfNeeded];
    [self postSelfHeight];
}

- (void)postSelfHeight {
    if ([self.delegate respondsToSelector:@selector(psTitleView:didChangeHeight:)]) {
        [self.delegate psTitleView:self didChangeHeight:[self viewHeight]];
    }
}

- (CGFloat)viewHeight {
    return CGRectGetMaxY(_titleInputView.frame);
}

-(BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [_titleInputView resignFirstResponder];
    
    return YES;
}

#pragma mark - PSInputVIewDelegate

- (void)psInputView:(PSInputVIew *)psInputView didChangeViewHeight:(CGFloat)viewHeight {
    [self updateLayout];
}

- (void)psInputViewDidReturn:(PSInputVIew *)psInputView {
    if ([self.delegate respondsToSelector:@selector(psTitleViewDidReturn:)]) {
        [self.delegate psTitleViewDidReturn:self];
    }
}

- (void)psInputViewDidBackward:(PSInputVIew *)psInputView {
}

- (void)psInputViewDidBeginInput:(PSInputVIew *)psInputView {
}

@end
