//
//  cusNaviController.h
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "infoViewController.h"
#import "http_manager.h"

@interface cusNaviController : UINavigationController<UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,httpFinishDelegate>
{
    UIActivityIndicatorView *indicatorView;
    UIView *maskView;
}

@property (nonatomic, strong) NSString *pushtoken;

@end
