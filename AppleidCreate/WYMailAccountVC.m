//
//  WYMailAccountVC.m
//  AppleidCreate
//
//  Created by ixingmi on 2017/3/3.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import "WYMailAccountVC.h"

@interface WYMailAccountVC ()<UITextViewDelegate>

@end

@implementation WYMailAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.txtTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, kMainScreenHeight - 20)];
    self.txtTextView.delegate = self;
    self.txtTextView.backgroundColor = [UIColor clearColor];
    //self.txtTextView.alpha = 0.7;
    //self.txtTextView.showsVerticalScrollIndicator = NO;
    //        self.txtTextView.scrollView.showsHorizontalScrollIndicator = YES;
    //self.txtWebView.scrollView.bounces = NO;
    self.txtTextView.editable = NO;
    self.txtTextView.font = [UIFont systemFontOfSize:15.0];
    self.txtTextView.textColor = [UIColor blueColor];
    self.txtTextView.textAlignment = NSTextAlignmentNatural;
    [self.view addSubview:self.txtTextView];
    
    
    NSError *error = nil;
    NSString *readFileStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"邮箱账号" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    if (readFileStr == nil)
    {
        NSLog(@"出错了！%@",error);
    }
    
    self.txtTextView.text = readFileStr;
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(20, kMainScreenHeight - 80, 80, 30);
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.backgroundColor = [UIColor blueColor];
    returnBtn.layer.cornerRadius = 8.0;
    [self.view addSubview:returnBtn];
}


- (void)returnBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
