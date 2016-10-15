//
//  AppDelegate.m
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        //#ifdef __IPHONE_8_0
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            //Right, that is the point
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                                 |UIRemoteNotificationTypeSound
                                                                                                 |UIRemoteNotificationTypeAlert) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        else
        {
            
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        }
    //#else
    //register to receive notifications
    //#endif
    
    
    application.idleTimerDisabled = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    baseView = [[ViewController alloc] init];
    
//    cusNaviController *navi = [[cusNaviController alloc] initWithRootViewController:temp];
//    navi.naviBtnOn = temp;//set cus btn
    self.window.rootViewController = baseView;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /*
     設定監控網路的回饋
     */
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        baseView.net_status = AFStringFromNetworkReachabilityStatus(status);
        
    }];
    
    /*
     啟動網路監控
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - notification

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /* Get device token */
    NSString *strDevToken = [NSString stringWithFormat:@"%@", deviceToken];
    
    //    NSLog(@"(NSData* )deviceToken : %@",strDevToken);
    
    /* Replace '<', '>' and ' ' */
    NSCharacterSet *charDummy = [NSCharacterSet characterSetWithCharactersInString:@"<> "];
    strDevToken = [[strDevToken componentsSeparatedByCharactersInSet: charDummy] componentsJoinedByString: @""];
    //        NSLog(@"Device Name=[%@]",[UIDevice currentDevice].name);
    //        NSLog(@"Device token=[%@]", strDevToken);
    
    /* 可以把token傳到server，之後server就可以靠它送推播給使用者了 */
    
    baseView.passToken = strDevToken;
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    baseView.passUserInfo = userInfo;
}


@end
