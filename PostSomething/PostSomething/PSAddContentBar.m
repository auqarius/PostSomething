//
//  PSAddContentBar.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSAddContentBar.h"
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PSTool.h"
#import <Masonry/Masonry.h>

@interface PSAddContentBar()
<
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>
{
    UIButton *addPhotoButton;
}

@end

@implementation PSAddContentBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
        addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPhotoButton setTitle:@"照片" forState:UIControlStateNormal];
        [addPhotoButton setFrame:CGRectMake(10, 0, 44, 44)];
        [addPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addPhotoButton addTarget:self action:@selector(showPhotLibrary) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addPhotoButton];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.mas_top).offset(0.5);
        }];
    }
    return self;
}

/**
 跳转到相册
 */
- (void)showPhotLibrary {
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"对不起，此设备不支持相册功能.");
        return;
    }
    
    //获得相机模式下支持的媒体类型
    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL canUsePhtotLibrary = NO;
    
    for (NSString* mediaType in availableMediaTypes) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            //支持摄像
            canUsePhtotLibrary = YES;
            break;
        }
    }
    
    //检查是否支持摄像
    if (!canUsePhtotLibrary) {
        NSLog(@"对不起，暂时没有使用相册权限");
        return;
        
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置图像选取控制器的类型为动态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie,kUTTypeImage, nil];
    
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    
    //设置委托对象
    imagePickerController.delegate = self;
    
    //以模式视图控制器的形式显示
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    } else {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (!error) {
        NSLog(@"Video saved with no error.");
    } else {
        NSLog(@"error occured while saving the Video%@", error);
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //获取用户编辑之后的图像
    UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //将该图像保存到媒体库中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(editedImage, self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    if (!editedImage) {
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if ([self.delegate respondsToSelector:@selector(psAddContentBar:didSelectedImage:)]) {
        [self.delegate psAddContentBar:self didSelectedImage:editedImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
