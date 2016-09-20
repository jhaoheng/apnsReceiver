//
//  cusNaviController.h
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slideViewController.h"

@interface cusNaviController : UINavigationController
@property (nonatomic, strong) UIViewController *naviBtnOn;
@property (nonatomic) NSString *description;

- (void)menu_activity:(id)sender;

@end
