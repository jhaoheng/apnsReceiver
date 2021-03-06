//
//  ViewController.m
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UILabel *token_label;
    
    UIScrollView *logView;
    
    UILabel *accept_times_label;
    CGFloat accept_times_label_h;
    int count;
}

@end

@implementation ViewController
@synthesize passToken=_passToken, passUserInfo=_passUserInfo;
@synthesize net_status=_net_status;

#define infoBlockHeight 190;

- (void)setPassToken:(NSString *)passToken
{
    NSLog(@"token is : %@",passToken);
    
    _passToken = passToken;
    
    token_label.text = _passToken;
    [token_label sizeToFit];
}

- (void)setPassUserInfo:(NSDictionary *)passUserInfo
{
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *localeDate = [dateFormatter stringFromDate:[NSDate date]];
    
    //
    _passUserInfo = passUserInfo;
    
    //
    CGFloat h = infoBlockHeight;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logView.contentSize.height, CGRectGetWidth(logView.frame), h)];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",localeDate,_passUserInfo];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    infoLabel.textAlignment = NSTextAlignmentLeft;
    //    [infoLabel sizeToFit];
    infoLabel.font = [UIFont systemFontOfSize:12];
    [logView addSubview:infoLabel];
    
    logView.contentSize = CGSizeMake(logView.frame.size.width, logView.contentSize.height+h);
    
    [UIView beginAnimations:nil context:nil];
    logView.contentOffset = CGPointMake(0, logView.contentSize.height-logView.frame.size.height);
    [UIView commitAnimations];
    
    //接收次數
    count++;
    accept_times_label.text = [NSString stringWithFormat:@"Times : %d",count];
}

- (void)setNet_status:(NSString *)net_status
{
    NSLog(@"網路狀態(Reachability)：%@",net_status);
    /*
     2:wifi
     1:wwan
     0:none
     */
    if ((long)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==2) {
        netStatus_label.text = @"WiFi";
        netStatusImg.image = [UIImage imageNamed:@"icon_blue.png"];
    }
    else if ((long)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==1)
    {
        netStatus_label.text = @"WWAN";
        netStatusImg.image = [UIImage imageNamed:@"icon_green.png"];
    }
    else
    {
        netStatus_label.text = @"None";
        netStatusImg.image = [UIImage imageNamed:@"icon_red.png"];
    }
}

#pragma mark - view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    //sys version
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSLog(@"%i Keys:  %@", [infoDictionary count], [[infoDictionary allKeys] componentsJoinedByString: @" ,"]);
    NSLog(@"CFBundleVersion : %@",[infoDictionary objectForKey:@"CFBundleVersion"]);
    NSLog(@"CFBundleShortVersionString : %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]);
    
    //
    CGFloat tokenT_ori_h = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UILabel *tokenTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, tokenT_ori_h+10, CGRectGetWidth(self.view.frame)-20, 0)];
    tokenTitle.text = @"Device Token is : ";
    [tokenTitle sizeToFit];
    NSLog(@"%@",NSStringFromCGRect(tokenTitle.frame));
    [self.view addSubview:tokenTitle];

    //
    token_label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tokenTitle.frame)+10, CGRectGetWidth(self.view.frame)-20, 60)];
    token_label.numberOfLines = 0;
    token_label.lineBreakMode = NSLineBreakByCharWrapping;
    token_label.text = @"hello, wait to get token.";
    [self.view addSubview:token_label];

    
    //log scroll view
    [self init_logView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - uiscroll view : log view
- (void)init_logView
{
    logView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(token_label.frame)+10, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(token_label.frame)-20)];
    logView.backgroundColor = [UIColor blackColor];
    logView.alwaysBounceVertical = YES;
    [self.view addSubview:logView];
    
    //
    
    
    //remote notification times
    count = 0;
    accept_times_label_h = 20;
    CGRect frame = CGRectMake(20, CGRectGetMinY(logView.frame)+5, 100, 20);
    accept_times_label = [[UILabel alloc] initWithFrame:frame];
    accept_times_label.text = [NSString stringWithFormat:@"Times : %d",count];
    accept_times_label.textAlignment = NSTextAlignmentLeft;
    accept_times_label.textColor = [UIColor redColor];
    accept_times_label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:accept_times_label];
    
    //uibutton clean log
    UIButton *cleanLog_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanLog_btn.frame = CGRectMake( CGRectGetMaxX(logView.frame)-80,CGRectGetMinY(logView.frame),100,30);
    [cleanLog_btn setTitle:@"Clean" forState:UIControlStateNormal];
    [cleanLog_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cleanLog_btn addTarget:self action:@selector(cleanLog_activity:) forControlEvents:UIControlEventTouchUpInside];
    cleanLog_btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:cleanLog_btn];
    
    //net status
    frame = CGRectMake(CGRectGetWidth(self.view.frame)-50-50, CGRectGetHeight(self.view.frame)-20.5-20, 50, 20.5);
    netStatus_label = [[UILabel alloc] initWithFrame:frame];
    netStatus_label.text = @"NONE";
    netStatus_label.textColor = [UIColor grayColor];
    netStatus_label.textAlignment = NSTextAlignmentRight;
    netStatus_label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:netStatus_label];
    
    //
    frame = CGRectMake(CGRectGetMaxX(netStatus_label.frame)+10, CGRectGetMinY(netStatus_label.frame), 20, 20);
    netStatusImg = [[UIImageView alloc] initWithFrame:frame];
    netStatusImg.image = [UIImage imageNamed:@"icon_red.png"];
    [self.view addSubview:netStatusImg];
}

#pragma mark 日誌清除
- (void)cleanLog_activity:(id)sender
{
    if (count==0) {
        [self alertOfTitle:@"" andMsg:@"Log was clean!"];
        return;
    }
    count = 0;
    accept_times_label.text = [NSString stringWithFormat:@"Times : %d",count];
    [self init_logView];
}

#pragma mark - alert
- (void)alertOfTitle:(NSString *)title andMsg:(NSString *)msg
{
    UIDevice *device = [UIDevice currentDevice];
    
    if ([device.systemVersion floatValue]>=8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





@end
