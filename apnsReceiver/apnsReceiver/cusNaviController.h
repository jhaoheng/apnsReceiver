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

@interface cusNaviController : UINavigationController<UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *pushtoken;

@end
