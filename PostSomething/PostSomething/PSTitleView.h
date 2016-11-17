//
//  PSTitleView.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 这个 view 是用来做发帖子视图的标题
 
 */

@class PSTitleView;
@protocol PSTitleiewDelegate <NSObject>

@optional
/**
 标题视图会因为输入的内容而改变高度
 
 @param contentView 标题视图
 @param height 高度
 */
- (void)psTitleView:(PSTitleView *)contentView didChangeHeight:(CGFloat)height;

/**
 标题视图编辑的时候点击了 return

 @param contentView 标题视图
 */
- (void)psTitleViewDidReturn:(PSTitleView *)contentView;

@end

@interface PSTitleView : UIView

@property (nonatomic, weak) id<PSTitleiewDelegate> delegate;

/**
 输入的标题
 */
@property (nonatomic, copy, readonly) NSString *inputedTitle;

/**
 视图高度

 @return <#return value description#>
 */
- (CGFloat)viewHeight;

@end
