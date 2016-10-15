//
//  cusNaviController.m
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import "cusNaviController.h"

@implementation cusNaviController
@synthesize pushtoken = _pushtoken;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if(navigationController.viewControllers.count != 1) { // not the root controller - show back button instead
        return;
    }
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(infoItem:)];
    [viewController.navigationItem setLeftBarButtonItem:infoItem];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    [viewController.navigationItem setRightBarButtonItem:sendItem];
}

#pragma mark - info
- (void)infoItem:(id)sender
{
    infoViewController *infoView = [[infoViewController alloc] init];
    [UIView transitionWithView:self.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self pushViewController:infoView animated:NO];
                    }
                    completion:nil];
}

#pragma mark - send
- (void)send:(id)sneder{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Send Token" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self copyToken];
    }];
    [alertController addAction:copyAction];
    
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self mail_pass_activity:nil];
    }];
    [alertController addAction:emailAction];
    
    UIAlertAction *smsAction = [UIAlertAction actionWithTitle:@"SMS" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self sms];
        [self alertOfTextTitle:@"Send token" do:@"SMS" textHint:@"Enter phone number"];
    }];
    [alertController addAction:smsAction];
    
    UIAlertAction *apiAction = [UIAlertAction actionWithTitle:@"API" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:apiAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark copy
- (void)copyToken{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _pushtoken;
    [self alertOfTitle:@"" andMsg:@"Copy Token to clipboard!"];
}

#pragma mark email
- (void)mail_pass_activity:(id)sender
{
    
    NSString *subject = [NSString stringWithFormat:@"Hello,this is '%@ token'",[UIDevice currentDevice].name];
    NSString *msg = [NSString stringWithFormat:@"DeviceToken is : \n\n%@",_pushtoken];
    
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    
    [mailCont setSubject:subject];
    //    [mailCont setToRecipients:[NSArray arrayWithObject:@""]];
    [mailCont setMessageBody:msg isHTML:NO];
    
    if (![MFMailComposeViewController canSendMail]) {
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [self alertOfTitle:@"" andMsg:@"Device mail not ready!"];
    }
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark sms
//觸發的btn
- (void)sms:(NSString *)phoneNumber
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    //判斷裝置是否在可傳送訊息的狀態
    if([MFMessageComposeViewController canSendText]) {
        
        //設定SMS訊息內容
        controller.body = _pushtoken;
        
        //設定接傳送對象的號碼
        controller.recipients = [NSArray arrayWithObjects:phoneNumber,nil];
        
        //設定代理
        controller.messageComposeDelegate = self;
        
        //顯示controller的畫面
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

//使用者完成操作時所呼叫的內建函式
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:Nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"訊息傳送成功");
            //訊息傳送成功
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"訊息傳送失敗");
            //訊息傳送失敗
            break;
            
        case MessageComposeResultCancelled:
            NSLog(@"訊息被使用者取消傳送");
            //訊息被使用者取消傳送
            break;
            
        default:
            break;
    }
}


#pragma mark - alert
- (void)alertOfTitle:(NSString *)title andMsg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertOfTextTitle:(NSString *)title do:(NSString *)actionStr textHint:(NSString *)textHint
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:actionStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = textHint;
    }];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *temp = alertController.textFields.firstObject;
        
        if ([actionStr isEqualToString:@"SMS"]) {
            [self sms:temp.text];
        }
    }];
    
    [alertController addAction:submitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
