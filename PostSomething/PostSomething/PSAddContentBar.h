//
//  PSAddContentBar.h
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 添加内容的 Bar
 目前只提供了添加图片功能
 
 */

@class PSAddContentBar;
@protocol PSAddContentBarDelegate <NSObject>

@optional;
/**
 选择了一个图片

 @param addContentBar self
 @param image 选择的图片
 */
- (void)psAddContentBar:(PSAddContentBar *)addContentBar didSelectedImage:(UIImage *)image;

@end

@interface PSAddContentBar : UIView

@property (nonatomic, weak) id <PSAddContentBarDelegate> delegate;

@end
