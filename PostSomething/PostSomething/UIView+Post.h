//
//  UIView+Post.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个分类为 UIView 添加了一些新的功能
 
 */

@class MASViewAttribute;

@interface UIView (Post)

/**
 当前视图的顶部应该相对哪一个视图的 constrant，一般是 superView.mas_top 或者 view.mas_bottom
 
 这个属性也是为了让 PSContentView 在维护 PSInputView/PSImageView 的时候可以直接使用 UIView 调用 lastViewAttr
 */
@property (nonatomic, strong) MASViewAttribute *lastViewAttr;

/**
 这个方法只是为了让 PSContentView 在维护 PSInputView/PSImageView 的时候可以直接使用 UIView 调用 viewHeight
 
 返回的高度是当前视图的高度
 
 但是如果是 PS... 系列的自定义 view，其实都会调用其对应的 viewHeight 方法

 @return 高度
 */
- (CGFloat)viewHeight;

@end
