//
//  UIView+Post.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "UIView+Post.h"
#import <objc/runtime.h>

static const void *lastViewAttrKey = &lastViewAttrKey;

@implementation UIView (Post)

- (void)setLastViewAttr:(MASViewAttribute *)lastViewAttr {
    objc_setAssociatedObject(self, &lastViewAttrKey, lastViewAttr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MASViewAttribute *)lastViewAttr {
    return objc_getAssociatedObject(self, &lastViewAttrKey);
}

- (CGFloat)viewHeight {
    return self.frame.size.height;
}

@end
