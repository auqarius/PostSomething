//
//  PSContentView.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSContentView.h"
#import "PSTool.h"
#import <Masonry/Masonry.h>
#import "PSInputVIew.h"
#import "UIView+Post.h"
#import "PSImageView.h"

#define ContentPlaceHolder @"给这则帖子写几句有趣的文字......"

@interface PSContentView () <PSInputVIewDelegate, PSImageViewDelegate>
{
    // 这个数组是用来维护所有的控件的
    // 里面的控件的 index 与页面从上到下的控件位置对应
    NSMutableArray *_allUIArray;
    // 当前正在编辑的控件
    UIView *_nowEditingView;
}

@end

@implementation PSContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _allUIArray = [NSMutableArray array];
        
        // 创建第一个 textView
        PSInputVIew *firstInputView = [PSInputVIew createInView:self downViewAttr:self.mas_top];
        firstInputView.placeHolder = ContentPlaceHolder;
        [_allUIArray addObject:firstInputView];
    }
    return self;
}

#pragma mark - Public

- (CGFloat)viewHeight {
    UIView *lastView = _allUIArray.lastObject;
    return CGRectGetMaxY(lastView.frame) + 8;
}

- (void)addImage:(UIImage *)image {
    [self addNewImageViewWithImage:image];
}

- (void)startInputFirstView {
    UIView *view = _allUIArray.firstObject;
    [view becomeFirstResponder];
}

- (PSInputVIew *)nowInputView {
    return (PSInputVIew *)_nowEditingView;
}

- (NSArray *)inputedContents {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UIView *view in _allUIArray) {
        if ([view isKindOfClass:[PSInputVIew class]]) {
            PSInputVIew *inputView = (PSInputVIew *)view;
            [resultArray addObject:inputView.content];
        }
        if ([view isKindOfClass:[PSImageView class]]) {
            PSImageView *inputView = (PSImageView *)view;
            [resultArray addObject:inputView.image];
        }
    }
    return resultArray;
}

#pragma mark - Private

/**
 重新设置所有控件的 autolayout 并重新布局
 */
- (void)updateLayout {
    
    for (UIView *view in _allUIArray) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.superview.mas_left).offset(8);
            make.right.equalTo(view.superview.mas_right).offset(-8);
            make.height.mas_equalTo(view.viewHeight);
            NSInteger index = [_allUIArray indexOfObject:view];
            make.top.equalTo(view.lastViewAttr).offset(index?0:8);
        }];
    }
    
    [self showPlaceholderIfNeed];

    [self layoutIfNeeded];
    [self postSelfHeight];
}

// 看看是不是需要显示 placeholder
- (void)showPlaceholderIfNeed {
    PSInputVIew *firstInputView = _allUIArray.firstObject;
    if (firstInputView.content.length == 0 && _allUIArray.count == 1) {
        firstInputView.placeHolder = ContentPlaceHolder;
    } else {
        firstInputView.placeHolder = @"";
    }
}

- (void)postSelfHeight {
    if ([self.delegate respondsToSelector:@selector(psContentView:didChangeHeight:)]) {
        [self.delegate psContentView:self didChangeHeight:[self viewHeight]];
    }
}

/**
 添加一个新的输入框

 @param view 这个输入框在哪个视图的下面
 @param newContent 这个输入框初始化的时候的内容
 @param becomeFirstResonder 是否要立即开始输入
 */
- (void)addNewInputViewAfterView:(UIView *)view withNewContent:(NSString *)newContent becomeFirstResonder:(BOOL)becomeFirstResonder {
    // 获取点击 return 的输入框的 index
    NSInteger index = [_allUIArray indexOfObject:view];
    // 创建新的输入框并且加入数组
    PSInputVIew *newInputView = [PSInputVIew createInView:self downViewAttr:view.mas_bottom];
    newInputView.content = newContent;
    newInputView.cursorPosition = 0;
    [_allUIArray insertObject:newInputView atIndex:(index+1)];
    
    // 将新建的输入框以下的所有视图的相对位置进行调整
    [self adjustViewAttAfterIndex:index+1];
    
    if (becomeFirstResonder) {
        [newInputView becomeFirstResponder];
    }
}

/**
 添加一个图片
 
 添加图片的时候是根据当前正在输入的输入框的位置决定的
 如果没有记录当前正在输入的输入框，则使用最后一个输入框

 @param image 图片
 */
- (void)addNewImageViewWithImage:(UIImage *)image {
    // 获取正在输入的输入框的位置
    if (!_nowEditingView) {
        _nowEditingView = _allUIArray.lastObject;
    }
    NSInteger index = [_allUIArray indexOfObject:_nowEditingView];
    // 创建新的图片并加入数组
    PSImageView *newImageView = [PSImageView createInView:self andImage:image downViewAttr:_nowEditingView.mas_bottom];
    [_allUIArray insertObject:newImageView atIndex:(index+1)];
    [newImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.right.equalTo(self.mas_right).offset(-8);
        make.height.mas_equalTo(newImageView.viewHeight);
        make.top.equalTo(newImageView.lastViewAttr).offset(8);
    }];
    
    // 将新建的图片一下的所有视图的相对位置进行调整
    [self adjustViewAttAfterIndex:index+1];
    
    // 每个图片下面都将新建一个输入框
    [self addNewInputViewAfterView:newImageView withNewContent:@"" becomeFirstResonder:NO];
}

/**
 删除某一个控件
 
 因为 PSInputView 和 PSImageView 都是 UIView 的子类
 而且都有可能被传递，因此参数写 UIView 类
 删除的情况如下：
 1、如果当前输入框不是第一个
    并且当前输入框的上面一个控件不是图片
    并且光标之前没有任何文字
    则删除当前输入框
    并且上一个输入框获取焦点
    然后将当前输入框的内容添加在上一个输入框的内容之后
    然后将上一个输入框的光标放在新内容之前
 2、如果当前输入框不是第一个，并且当前输入框的上面一个控件是图片，则不进行任何删除操作
 3、如果当前输入框是第一个，则不进行任何删除操作
 4、如果要被删除的是图片，则直接删除

 @param view 控件
 */
- (void)removeView:(UIView *)view {
    NSInteger index = [_allUIArray indexOfObject:view];
    if ([view isKindOfClass:[PSInputVIew class]]) {
        PSInputVIew *toRemoveInputView = (PSInputVIew *)view;
        
        if (index == 0) {
            // 第一个输入框不允许删除
            return;
        }
        PSInputVIew *lastView = (PSInputVIew *)_allUIArray[index - 1];;
        if ([lastView isKindOfClass:[PSImageView class]]) {
            // 如果上一个视图是图片，也不允许删除
            return;
        }
        if (toRemoveInputView.cursorPosition != 0) {
            // 如果光标没在最开始，则代表光标之前还有内容
            return;
        }
        
        // 获取焦点
        [lastView becomeFirstResponder];
        // 将被删除的输入框的内容
        NSString *content = toRemoveInputView.content;
        // 添加到新的上一个视图上
        [lastView appendContent:content];
        // 移动光标到对应的位置
        lastView.cursorPosition = [lastView.content rangeOfString:content].location;
    }
    
    [_allUIArray removeObjectAtIndex:index];
    [view removeFromSuperview];
    
    // 移除后，将包括当前 index 以后的视图全部更新
    [self adjustViewAttAfterIndex:index-1];
}

/**
 将 index 以下的所有的视图相对位置进行调整
 
 在控件中间添加了新的控件以后，下面的第一个控件的相对位置都需要被更改

 @param index index
 */
- (void)adjustViewAttAfterIndex:(NSInteger)index {
    if (index == _allUIArray.count - 1) {
        // 重新刷新界面
        [self updateLayout];
        return;
    }
    UIView *lastInputView = [_allUIArray objectAtIndex:index];
    UIView *toChangeInputView = _allUIArray[index+1];
    toChangeInputView.lastViewAttr = lastInputView.mas_bottom;
    
    // 重新刷新界面
    [self updateLayout];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [self resignAll];
    return YES;
}

- (void)resignAll {
    for (UIView *view in _allUIArray) {
        [view resignFirstResponder];
    }
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self startInputLastView];
    
    return YES;
}

- (void)startInputLastView {
    UIView *view = _allUIArray.lastObject;
    [view becomeFirstResponder];
}

#pragma mark - PSInputVIewDelegate

- (void)psInputView:(PSInputVIew *)psInputView didChangeViewHeight:(CGFloat)viewHeight {
    [self updateLayout];
}

- (void)psInputViewDidReturn:(PSInputVIew *)psInputView {
    // 光标之前的内容
    NSString *retainContent = [psInputView.content substringWithRange:NSMakeRange(0, psInputView.cursorPosition)];
    // 光标之后的内容
    NSString *putToNextContent = [psInputView.content substringWithRange:NSMakeRange(psInputView.cursorPosition, psInputView.content.length - psInputView.cursorPosition)];
    // 设置内容为光标之前的内容
    psInputView.content = retainContent;
    // 创建新的输入框并且设置内容为光标之后的内容
    [self addNewInputViewAfterView:psInputView withNewContent:putToNextContent becomeFirstResonder:YES];
}

- (void)psInputViewDidBackward:(PSInputVIew *)psInputView {
    [self removeView:psInputView];
}

- (void)psInputViewDidBeginInput:(PSInputVIew *)psInputView {
    _nowEditingView = psInputView;
    if ([self.delegate respondsToSelector:@selector(psContentView:beginEdit:)]) {
        [self.delegate psContentView:self beginEdit:psInputView];
    }
}

#pragma mark - PSImageViewDelegate

- (void)psImageViewDidRemove:(PSImageView *)psImageView {
    [self removeView:psImageView];
}

@end
