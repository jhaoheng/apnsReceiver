//
//  cusNaviController.m
//  apnsReceiver
//
//  Created by max on 2016/3/30.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import "cusNaviController.h"

@implementation cusNaviController

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
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                              target:self
                                                                              action:@selector(infoItem:)];
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
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:copyAction];
    
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:emailAction];
    
    UIAlertAction *smsAction = [UIAlertAction actionWithTitle:@"SMS" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:smsAction];
    
    UIAlertAction *apiAction = [UIAlertAction actionWithTitle:@"API" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:apiAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
