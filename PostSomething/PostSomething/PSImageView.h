//
//  PSImageView.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个 view 是一个图片
 内部维护一个 UIImageView 和一个删除按钮
 高度固定为 200
 宽度根据屏幕宽度改变
 
 */

@class PSImageView;
@class MASViewAttribute;
@protocol PSImageViewDelegate <NSObject>

@optional;
/**
 移除图片

 @param psImageView 被移除的图片
 */
- (void)psImageViewDidRemove:(PSImageView *)psImageView;

@end

@interface PSImageView : UIView

@property (nonatomic, weak) id<PSImageViewDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

/**
 新建一个图片视图

 @param superView 父视图
 @param image 图片
 @param viewAttr 在哪一个 attr 下面，一般都是 : superView.mas_top 或者 view.mas_bottom
 @return 创建好的视图
 */
+ (PSImageView *)createInView:(UIView <PSImageViewDelegate>*)superView andImage:(UIImage *)image downViewAttr:(MASViewAttribute *)viewAttr;

/**
 计算后视图的高度
 
 @return 高度
 */
- (CGFloat)viewHeight;

@end
