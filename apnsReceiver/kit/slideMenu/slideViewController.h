//
//  slideViewController.h
//
//  Created by maxhu on 2016/1/25.
//  Copyright © 2016年 maxhu. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 [slideMenu delegate]
 must do it , if you want to get slide side btn action feedback
 */
@protocol slideMenuDelegate

@required
-(void)didSlideSideBtnFeedback:(id)sender;

@end

@interface slideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSObject<slideMenuDelegate> *passSideBtnAction_delegate;
}
@property (nonatomic, retain) NSObject<slideMenuDelegate> *passSideBtnAction_delegate;

extern slideViewController *slideController;

/*
 [required]
 init slide
 setting slide frame and mask frame use default
 */
+ (slideViewController *)slide_initAndBaseOn:(id)baseController;

/*
 [required]
 slide menu content
 */
@property (nonatomic, strong) NSArray *menuArray;


/*
 [required]
 if you want this slide action , do it
 */
+ (void)switchSlideMove;



#pragma mark - optional

/*
 [optional]
 slideMenu margin
 */
#define slideMenu_margin_top 64
#define slideMenu_margin_bottom 0
#define slideMenu_margin_left 0
#define slideMenu_margin_right 100

/*
 [optional]
 slide mask margin
 */
#define slideMask_margin_top 64
#define slideMask_margin_bottom 0
#define slideMask_margin_left 0
#define slideMask_margin_right 0

/*
 [optional]
 slide menu background color
 default : [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *slideMenu_backGround_color;

/*
 [optional]
 slide mask background color
 default : [UIColor colorWithWhite:.7 alpha:.2]
 */
@property (nonatomic, strong) UIColor *slideMask_backGround_color;


/*
 when slide animation activity
 you can use it to lock amnition repeat action. if someone tap menu btn more than one time.
 */
@property (nonatomic) BOOL is_lock;

@end

