//
//  PSInputVIew.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个 view 是一个输入框
 内部维护一个 textview
 高度会根据 textview 的内容而改变
 
 */

#define DefaultTextViewHeight 36

@class PSInputVIew;
@class MASViewAttribute;
@protocol PSInputVIewDelegate <NSObject>

@optional
/**
 高度改变代理

 @param psInputView 输入视图
 @param viewHeight 高度
 */
- (void)psInputView:(PSInputVIew *)psInputView didChangeViewHeight:(CGFloat)viewHeight;

/**
 输入视图点击了 return 后

 @param psInputView 输入视图
 */
- (void)psInputViewDidReturn:(PSInputVIew *)psInputView;

/**
 输入视图点击了删除后
 
 @param psInputView 输入视图
 */
- (void)psInputViewDidBackward:(PSInputVIew *)psInputView;

/**
 开始输入
 */
- (void)psInputViewDidBeginInput:(PSInputVIew *)psInputView;

@end

@interface PSInputVIew : UIView

@property (nonatomic, weak) id<PSInputVIewDelegate> delegate;

/**
 输入的内容
 */
@property (nonatomic, copy) NSString *content;

/**
 光标的位置
 */
@property (nonatomic, assign) NSInteger cursorPosition;

/**
 内容的默认值
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 最大可输入长度
 如果设置了这个属性，右边会出现一个数字提示框
 输入框将被往左挤一点
 */
@property (nonatomic, assign) NSInteger maxLength;

/**
 内容的文字大小，默认为 19
 */
@property (nonatomic, assign) CGFloat fontSize;


/**
 新建一个输入视图

 @param superView 将要被添加到的视图
 @param viewAttr 这个视图创建在哪个 constraint 下面
 @return 创建的视图
 */
+ (PSInputVIew *)createInView:(UIView <PSInputVIewDelegate>*)superView downViewAttr:(MASViewAttribute *)viewAttr;

/**
 计算后视图的高度

 @return 高度
 */
- (CGFloat)viewHeight;

/**
 给输入框后面添加文字

 @param content 待添加的文字
 */
- (void)appendContent:(NSString *)content;

@end
