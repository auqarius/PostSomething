//
//  PSPostView.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个 view 是用来做发帖子的
 
 它由填写标题的 PSTitleView 和填写内容的 PSContentView 组成
 
 */

@class PSPostView;
@class PSInputVIew;
@protocol PSPostViewDelegate <NSObject>

@optional
/**
 发帖子视图会因为内容的改变而改变高度

 @param postView 发帖子视图
 @param height 高度
 */
- (void)psPostView:(PSPostView *)postView didChangeHeight:(CGFloat)height;

/**
 开始编辑某一个输入框
 
 @param postView  发帖子视图
 @param inputView 输入框
 */
- (void)psPostView:(PSPostView *)postView beginEdit:(PSInputVIew *)inputView;

@end

@interface PSPostView : UIView

@property (nonatomic, weak) id<PSPostViewDelegate> delegate;

/**
 标题
 */
@property (nonatomic, copy, readonly) NSString *postTitle;

/**
 内容
 */
@property (nonatomic, strong, readonly) NSArray *postContent;

/**
 当前正在输入的输入框
 */
@property (nonatomic, strong, readonly) PSInputVIew *nowInputView;

- (CGFloat)viewHeight;

/**
 给内容添加一个新的图片

 @param image 图片
 */
- (void)addNewImage:(UIImage *)image;

@end
