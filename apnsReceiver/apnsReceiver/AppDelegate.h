//
//  AppDelegate.h
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ViewController.h"
#import "infoViewController.h"
#import "cusNaviController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    cusNaviController *navi;
    ViewController *baseView;
    infoViewController *infoView;
}

@property (strong, nonatomic) UIWindow *window;


@end

