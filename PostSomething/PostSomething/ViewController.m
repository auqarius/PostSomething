//
//  ViewController.m
//  PostSomething
//
//  Created by LIKai on 2016/11/16.
//  Copyright © 2016年 KralLee. All rights reserved.
//

#import "ViewController.h"
#import "PSPostViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)post:(id)sender {
    PSPostViewController *postVC = [[PSPostViewController alloc] init];
    [self.navigationController pushViewController:postVC animated:YES];
}

@end
