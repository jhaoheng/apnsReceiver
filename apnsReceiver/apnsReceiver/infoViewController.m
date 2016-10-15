//
//  infoViewController.m
//  apnsReceiver
//
//  Created by max on 2016/10/15.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import "infoViewController.h"

@interface infoViewController ()

@end

@implementation infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    NSString *bundle_id = [[NSBundle mainBundle] bundleIdentifier];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    mainArray = [[NSMutableArray alloc] initWithObjects:
                 @{@"Bundle_id":bundle_id},
                 @{@"Provision":[self check_Mobileprovision]},
                 @{@"Version":version},
                 nil];
    
    mainTable = [[UITableView alloc] initWithFrame:self.view.frame];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                    completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 檢查 ipa 證書類別
- (NSString *)check_Mobileprovision{
    
    NSLog(@"========");
    NSData *provisioningProfile = nil;
    NSData *raw = [NSData dataWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"embedded" withExtension:@"mobileprovision"]];
    char *start = memmem(raw.bytes,
                         raw.length,
                         "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0",
                         47);
    if (start) {
        char *end = memmem(start,
                           (uintptr_t)start - raw.length,
                           "</plist>",
                           8);
        if (end) {
            provisioningProfile = [NSData dataWithBytes:start length:8 + end - start];
        }
    }
    
    NSString *provision;
    if (provisioningProfile) {
        NSDictionary* plist = [NSPropertyListSerialization propertyListWithData:provisioningProfile
                                                                        options:NSPropertyListImmutable
                                                                         format:0
                                                                          error:0];
        NSLog(@"\n\n\nTeam name: %@", plist[@"TeamName"]);
        
        if ([plist[@"ProvisionsAllDevices"] boolValue]) {
            NSLog(@"Enterprise");
            provision = @"Enterprise";
        } else if ([plist[@"ProvisionedDevices"] count] > 0) {
            if ([plist[@"Entitlements"][@"get-task-allow"] boolValue]) {
                NSLog(@"Development");
                provision = @"Development";
            } else {
                NSLog(@"Ad Hoc");
                provision = @"Ad Hoc";
            }
        } else {
            NSLog(@"App Store");
            provision = @"App Store";
        }
    }
    NSLog(@"========");
    
    return provision;
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CELL_ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_ID];
        cell.backgroundColor = [UIColor clearColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSString *title;
    NSString *detail;
    
    NSDictionary *dic = [mainArray objectAtIndex:indexPath.row];
    title = [[dic allKeys] objectAtIndex:0];
    detail = [[dic allValues] objectAtIndex:0];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    
    return cell;
}

@end
