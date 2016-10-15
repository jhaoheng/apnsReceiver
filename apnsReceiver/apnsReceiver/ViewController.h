//
//  ViewController.h
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "http_manager.h"

@interface ViewController : UIViewController<httpFinishDelegate>
{
    
    //
    UILabel *netStatus_label;
    UIImageView *netStatusImg;
    
    UIActivityIndicatorView *indicatorView;
    UIView *maskView;
}

@property (nonatomic, retain) NSString *passToken;
@property (nonatomic, retain) NSDictionary *passUserInfo;

@property (nonatomic, strong) NSString *net_status;

@end



/*
 wanted :
 - 需要把 logView 做得更好一些
 - 延伸 nslog 的功能
 */


