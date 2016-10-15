//
//  infoViewController.h
//  apnsReceiver
//
//  Created by max on 2016/10/15.
//  Copyright © 2016年 max hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTable;
    NSMutableArray *mainArray;
}

@end
