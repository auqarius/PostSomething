//
//  PSInputVIew.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSInputVIew.h"
#import <Masonry/Masonry.h>
#import "PSTool.h"
#import "UIView+Post.h"

@interface PSInputVIew() <UITextViewDelegate>
{
    UITextView *_inputView;
    // 显示 placeholder 的 label
    UILabel *_placeHolderLabel;
    // 右侧显示可输入字数的 label
    UILabel *_tipWordNumberLabel;
}

@end

@implementation PSInputVIew

+ (PSInputVIew *)createInView:(UIView <PSInputVIewDelegate>*)superView downViewAttr:(MASViewAttribute *)viewAttr {
    PSInputVIew *inputView = [[self alloc] initWithFrame:CGRectZero];
    inputView.delegate = superView;
    inputView.lastViewAttr = viewAttr;
    [superView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(8);
        make.right.equalTo(superView.mas_right).offset(-8);
        make.height.mas_equalTo(DefaultTextViewHeight);
        make.top.equalTo(viewAttr).offset(8);
    }];
    return inputView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 19.0;

        _tipWordNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _tipWordNumberLabel.textColor = [UIColor lightGrayColor];
        _tipWordNumberLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tipWordNumberLabel];
        [_tipWordNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(0);
            make.width.mas_equalTo(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.height.mas_equalTo(30);
        }];
        
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, PSTool.screenWidth, 0)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.delegate = self;
        _inputView.scrollEnabled = NO;
        _inputView.font = [UIFont systemFontOfSize:_fontSize];
        [self addSubview:_inputView];
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(_tipWordNumberLabel.mas_left).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:_inputView.frame];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:_fontSize];
        _placeHolderLabel.userInteractionEnabled = YES;
        [self addSubview:_placeHolderLabel];
        [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_inputView).mas_offset(UIEdgeInsetsMake(0, 6, 0, 0));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomeFirstResponder)];
        [_placeHolderLabel addGestureRecognizer:tap];
        _placeHolderLabel.hidden = YES;
    }
    return self;
}

#pragma mark - Public

- (CGFloat)viewHeight {
    return [self heightForInputTextView];
}

- (void)setContent:(NSString *)content {
    _inputView.text = content;
}

- (NSString *)content {
    return _inputView.text;
}

- (void)setCursorPosition:(NSInteger)cursorPosition {
    _inputView.selectedRange = NSMakeRange(cursorPosition, 0);
}

- (NSInteger)cursorPosition {
    return _inputView.selectedRange.location;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
    _placeHolderLabel.hidden = (_inputView.text.length != 0);
}

- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
    if (_maxLength == 0) {
        return;
    }
    [_tipWordNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(30);
    }];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    _inputView.font = [UIFont systemFontOfSize:_fontSize];
    _placeHolderLabel.font = [UIFont systemFontOfSize:_fontSize];
}

- (void)appendContent:(NSString *)content {
    _inputView.text = [_inputView.text stringByAppendingString:content];
}

#pragma mark - Private

- (CGFloat)heightForInputTextView {
    if (!_inputView) {
        return DefaultTextViewHeight;
    }
    CGFloat height = [_inputView sizeThatFits:CGSizeMake(_inputView.frame.size.width, MAXFLOAT)].height;
    if (height < DefaultTextViewHeight) {
        height = DefaultTextViewHeight;
    }
    return height;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [_inputView becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [_inputView resignFirstResponder];
    return YES;
}

- (void)checkInputMaxLegth {
    if (_maxLength == 0) {
        return;
    }
    NSInteger textLength = _inputView.text.length;
    NSInteger lastLength = _maxLength - textLength;
    if (lastLength < 5) {
        _tipWordNumberLabel.text = [NSString stringWithFormat:@"%d", (int)lastLength];
    } else {
       _tipWordNumberLabel.text = @"";
    }
    if (lastLength < 0) {
        _inputView.textColor = [UIColor redColor];
    } else {
        _inputView.textColor = [UIColor blackColor];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    _placeHolderLabel.hidden = (textView.text.length != 0);
    [self checkInputMaxLegth];
    if ([self.delegate respondsToSelector:@selector(psInputView:didChangeViewHeight:)]) {
        [self.delegate psInputView:self didChangeViewHeight:[self heightForInputTextView]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(psInputViewDidReturn:)]) {
            [self.delegate psInputViewDidReturn:self];
        }
        return NO;
    }
    if ([text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(psInputViewDidBackward:)]) {
            [self.delegate psInputViewDidBackward:self];
        }
        if (self.cursorPosition == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(psInputViewDidBeginInput:)]) {
        [self.delegate psInputViewDidBeginInput:self];
    }
}

@end
