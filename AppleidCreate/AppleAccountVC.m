//
//  AppleAccountVC.m
//  AppleidCreate
//
//  Created by ixingmi on 2017/3/14.
//  Copyright © 2017年 smallCar. All rights reserved.
//

#import "AppleAccountVC.h"

@interface AppleAccountVC ()<UITextViewDelegate>

@end

@implementation AppleAccountVC

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
    
    if ([self isFileExist:@"AppleAccount.txt"]) {
        NSLog(@"已经存在文件了");
        
        NSArray *documentsPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [documentsPathArr lastObject];
        // 拼接要写入文件的路径
        NSString *path = [documentsPath stringByAppendingPathComponent:@"AppleAccount.txt"];
        // 从路径中读取字符串
        NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@", str);
        self.txtTextView.text = str;
    }
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(kMainScreenWidth - 120, kMainScreenHeight - 80, 80, 30);
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.backgroundColor = [UIColor blueColor];
    returnBtn.layer.cornerRadius = 8.0;
    [self.view addSubview:returnBtn];
}

#pragma mark -
#pragma mark 判断沙盒中是否存在txt文件
//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
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
