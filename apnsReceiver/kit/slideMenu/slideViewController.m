//
//  slideViewController.m
//
//  Created by maxhu on 2016/1/25.
//  Copyright © 2016年 maxhu. All rights reserved.
//

#import "slideViewController.h"

typedef NS_ENUM(NSUInteger, SMoveMode) {
    move_in = 0,
    move_out
};

@interface slideViewController ()
{
    id _baseController;
    CGRect originFramePosition;
    UITableView *menuTable;
    NSArray *menuArray;
    UIView *maskView;
}

/*
 slide 開關 bool 切換
 */
@property (nonatomic) SMoveMode slideMoveStatus;

/*
 amnimation
 */
- (void)slideMove:(BOOL)moveAct;
/*
 ...
 */
- (void)baseController:(id)baseController setMenuViewFrame:(CGRect)menuFrame setMaskViewFrame:(CGRect)maskFrame;

@end

@implementation slideViewController
@synthesize passSideBtnAction_delegate;

@synthesize slideMoveStatus;
@synthesize menuArray;
@synthesize slideMenu_backGround_color = _slideMenu_backGround_color;
@synthesize slideMask_backGround_color = _slideMask_backGround_color;
@synthesize is_lock;

#pragma mark - view life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - slideMenu background color set
- (void)setSlideMenu_backGround_color:(UIColor *)slideMenu_backGround_color
{
    _slideMenu_backGround_color = slideMenu_backGround_color;
    menuTable.backgroundColor = _slideMenu_backGround_color;
}

#pragma mark - slideMask background color set
- (void)setSlideMask_backGround_color:(UIColor *)slideMask_backGround_color
{
    _slideMask_backGround_color = slideMask_backGround_color;
    maskView.backgroundColor = _slideMask_backGround_color;
}


#pragma mark - menu view : table 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; 
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    [self slideMove:self.slideMoveStatus];
    
    for (int i=0; i<menuArray.count; i++) {
        if ([cellText isEqualToString:[menuArray objectAtIndex:i]]) {
            NSLog(@"select slide btn is : %@",[menuArray objectAtIndex:i]);
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"id"];
            [dic setObject:[menuArray objectAtIndex:i] forKey:@"object"];
            
            [passSideBtnAction_delegate didSlideSideBtnFeedback:dic];
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - init
slideViewController *slideController;
+ (slideViewController *)slide_initAndBaseOn:(id)baseController
{
    if (slideController == nil) {
        slideController = [[self alloc] init];
        slideController.slideMoveStatus = move_in;
        
        //
        CGRect frame = slideController.view.frame;
        //
        CGFloat menu_height = frame.size.height - slideMenu_margin_top - slideMenu_margin_bottom;
        CGFloat menu_weight = frame.size.width - slideMenu_margin_right;
        //
        CGFloat mask_height = frame.size.height - slideMask_margin_top;
        
        //
        CGRect menuFrame = CGRectMake(slideMask_margin_left, slideMenu_margin_top, menu_weight, menu_height);
        CGRect maskFrame = CGRectMake(slideMask_margin_left, slideMask_margin_top, frame.size.width, mask_height);
        [slideController baseController:baseController setMenuViewFrame:menuFrame setMaskViewFrame:maskFrame];
    }
    return slideController;
}

#pragma mark - setting
- (void)baseController:(id)baseController setMenuViewFrame:(CGRect)menuFrame setMaskViewFrame:(CGRect)maskFrame
{
    //
    _baseController = baseController;
    
    
    //mask frame setting
    maskView = [[UIView alloc] initWithFrame:maskFrame];
    maskView.backgroundColor = [UIColor colorWithWhite:.7 alpha:.2];
    maskView.alpha = 0;
    [((UIViewController *)baseController).view addSubview:maskView];
    
    //menu frame setting
    menuTable = [[UITableView alloc] initWithFrame:menuFrame style:UITableViewStylePlain];
    menuTable.backgroundColor = [UIColor whiteColor];
    menuTable.scrollEnabled = NO;
    menuTable.delegate = self;
    menuTable.dataSource = self;
    [self.view addSubview:menuTable];
    
    //set backgroundImg
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgImg"]];
    [imgView setFrame:menuTable.frame];
    [menuTable setBackgroundView:imgView];
}

#pragma mark - slide action
+ (void)switchSlideMove
{
    NSLog(@"call slide action");
    [slideController slideMove:slideController.slideMoveStatus];
}

#pragma mark 移動
- (void)slideMove:(BOOL)moveAct
{
    slideController.is_lock = YES;
    
    slideMoveStatus = !slideMoveStatus;
    NSLog(@"slide menu : %@",moveAct?@"open":@"close");
    
    originFramePosition = self.view.frame;
    
    if (slideMoveStatus) {
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame = CGRectMake(5, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView animateWithDuration:.1 delay:.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            } completion:^(BOOL finished){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.5];
                maskView.alpha = 1;
                [UIView commitAnimations];

            }];
            
        } completion:^(BOOL finished){
            slideController.is_lock = NO;
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.frame = CGRectMake(5, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView animateWithDuration:.1 delay:.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            } completion:^(BOOL finished){}];
            
        } completion:^(BOOL finished){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.5];
            maskView.alpha = 0;
            [UIView commitAnimations];
            
            
            slideController.is_lock = NO;

        }];
    }
}

#pragma mark - touch 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if([touch view] == self.view)
    {
        //close
        [slideController slideMove:slideController.slideMoveStatus];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
