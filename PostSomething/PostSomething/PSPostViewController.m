//
//  PSPostViewController.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "PSPostViewController.h"
#import "PSPostView.h"
#import "PSTool.h"
#import "PSAddContentBar.h"
#import "PSInputVIew.h"

@interface PSPostViewController () <PSPostViewDelegate, PSAddContentBarDelegate>
{
    PSPostView *_postView;
    PSAddContentBar *_addContentBar;
}
@end

@implementation PSPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发帖子";
    [self initialLayout];
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeContentBar];
    // 打开滑动返回的功能
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [_postView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 关闭滑动返回的功能
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self addContentBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addContentBar];
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - Initial

- (void)initialLayout {
    // 设置 post view 为 tableview 的 header
    _postView = [[PSPostView alloc] initWithFrame:CGRectMake(0, 0, PSTool.screenWidth, PSTool.screenHeight - 64 - 44)];
    _postView.backgroundColor = [UIColor whiteColor];
    _postView.delegate = self;
    self.tableView.tableHeaderView = _postView;
    // 设置 footer 高度 44 是为了不挡住 addContentBar
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PSTool.screenWidth, 44)];
    
    [self addPostButton];
    [self addCancelButton];
}

- (void)addPostButton {
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:@"提交" forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addCancelButton {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPost) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Post

- (void)post {
    NSLog(@"------------------------- 开始发帖 ------------------------------------\n");
    NSLog(@"发送标题：%@\n", _postView.postTitle);
    NSLog(@"发送内容：\n");

    for (NSString *content in _postView.postContent) {
        if ([content isKindOfClass:[NSString class]]) {
            NSLog(@"%@\n", content);
        }
        if ([content isKindOfClass:[UIImage class]]) {
            NSLog(@"[图片]\n");
        }
    }
    NSLog(@"------------------------- 结束发帖 ------------------------------------\n");
}

- (void)cancelPost {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出编辑？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Private
// 添加照片的 Bar
- (PSAddContentBar *)addContentBar {
    if (!_addContentBar) {
        _addContentBar = [[PSAddContentBar alloc] initWithFrame:CGRectMake(0, PSTool.screenHeight - 44, PSTool.screenHeight, 44)];
        _addContentBar.delegate = self;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_addContentBar];
    return _addContentBar;
}

// 移除照片的 Bar
- (void)removeContentBar {
    [self.addContentBar removeFromSuperview];
}

// 滚动到对应的输入框位置
- (void)scrollToShowInputView:(PSInputVIew *)inputView {
    CGRect inputRect = [inputView convertRect:inputView.bounds toView:_postView];
    CGRect addContentBarRect = [_addContentBar convertRect:_addContentBar.bounds toView:[UIApplication sharedApplication].keyWindow];
    // 输入框应该在的标准位置
    CGFloat standerdY = PSTool.screenHeight - addContentBarRect.origin.y - inputView.viewHeight + DefaultTextViewHeight;
    // 当前的位置
    CGFloat y = inputRect.origin.y;
    // 计算输入框是不是超出了
    if (y > standerdY) {
        inputRect.origin.y += 44;
        [self.tableView scrollRectToVisible:inputRect animated:NO];
    } else {
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:NO];
    }
}

#pragma mark - Keyboard Notification

- (void)registerNotification {
    // 注册进入后台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    // 注册进入前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self registerKeyboardNotification];
}

- (void)registerKeyboardNotification {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //注册键盘高度改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self removeKeyboardNotification];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.addContentBar.frame = CGRectMake(0, PSTool.screenHeight - 44 - keyBoardFrame.size.height, PSTool.screenHeight, 44);
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.addContentBar.frame = CGRectMake(0, PSTool.screenHeight - 44, PSTool.screenHeight, 44);
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyBoardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        self.addContentBar.frame = CGRectMake(0, PSTool.screenHeight - 44 - keyBoardFrame.size.height, PSTool.screenHeight, 44);
    }];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [_postView resignFirstResponder];
    // 为了不让其他的 app 使用键盘的时候改变我们当前的视图
    // 在进入后台的时候，将键盘通知监听移除
    [self removeKeyboardNotification];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    // 进入前台的时候再次将键盘通知添加
    [self registerKeyboardNotification];
}

#pragma mark - PSAddContentBarDelegate
// 选择了照片的代理
- (void)psAddContentBar:(PSAddContentBar *)addContentBar didSelectedImage:(UIImage *)image {
    [_postView addNewImage:image];
}

#pragma mark - PSPostViewDelegate
// header view 改变了高度
- (void)psPostView:(PSPostView *)postView didChangeHeight:(CGFloat)height {
    self.tableView.tableHeaderView = _postView;
    [self scrollToShowInputView:postView.nowInputView];
}

- (void)psPostView:(PSPostView *)postView beginEdit:(PSInputVIew *)inputView {
    [self scrollToShowInputView:inputView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_postView resignFirstResponder];
}

@end
