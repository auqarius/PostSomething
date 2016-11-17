//
//  PSContentView.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个 view 是用来做发帖子的内容
  
 */

@class PSInputVIew;
@class PSContentView;
@protocol PSContentViewDelegate <NSObject>

@optional
/**
 内容视图会因为输入的内容而改变高度

 @param contentView 内容视图
 @param height 高度
 */
- (void)psContentView:(PSContentView *)contentView didChangeHeight:(CGFloat)height;

/**
 开始编辑某一个输入框

 @param contentView 内容视图
 @param psInputView 输入框
 */
- (void)psContentView:(PSContentView *)contentView beginEdit:(PSInputVIew *)psInputView;

@end

@interface PSContentView : UIView

@property (nonatomic, weak) id<PSContentViewDelegate> delegate;

/**
 当前正在输入的输入框
 */
@property (nonatomic, strong, readonly) PSInputVIew *nowInputView;

/**
 输入的内容
 里面的内容有 NSString 和 UIImage
 */
@property (nonatomic, strong, readonly) NSArray *inputedContents;

/**
 自己的高度

 @return 高度
 */
- (CGFloat)viewHeight;

/**
 添加一张图片

 @param image 图片
 */
- (void)addImage:(UIImage *)image;

/**
 开始编辑第一个输入框
 */
- (void)startInputFirstView;

@end
