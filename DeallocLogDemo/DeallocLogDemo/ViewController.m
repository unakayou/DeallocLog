//
//  ViewController.m
//  DeallocLogDemo
//
//  Created by unakayou on 8/14/19.
//  Copyright © 2019 unakayou. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+DeallocLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deallocLog = YES;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setFrame:CGRectMake((self.view.frame.size.width - 50) / 2, (self.view.frame.size.height - 50) / 2, 50, 50)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    [self presentViewController:[ViewController new] animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController] == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
