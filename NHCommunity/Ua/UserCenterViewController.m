//
//  UserCenterViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/23.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterTableViewCell.h"
#import "EditUserInfoViewController.h"
#import "BaseNavViewController.h"
#import "AppDelegate.h"
#import "ChangePwdViewController.h"
#import "ApplyMemberViewController.h"

#import "UIImageView+WebCache.h"
#import "UserInfoVo.h"
#import "UserBiz.h"
#import "UIImage+ImageUtil.h"

@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *_titleArray;
    NSArray *_imgNameArray;
    NSInteger _curSeleted;
}

@end

@implementation UserCenterViewController

static NSString *identify = @"userCell";


- (void)reloadData{
    [self refreshView];
}

- (void)refreshView{
    
    UIImage *i = [BASE_IMAGE imageAsCircle:YES
                               withDiamter:130
                               borderColor:[UIColor clearColor]
                               borderWidth:0.0f
                              shadowOffSet:CGSizeZero];
    [_headImage setImage:i];
    [_nameLabel setText:@""];

    if ([[GlobalUtil shareInstant] loginWithCus]) {
            return;
    }
    
    UserInfoVo *user = [[GlobalUtil shareInstant] userInfo];
    if (user != nil) {
        BOOL flag = NO;
        if ([[user USER_IMG] isKindOfClass:[NSNull class]]) {
            flag = YES;
        }
        if ([user USER_IMG] == nil) {
            flag = YES;
        }
        if ([[user USER_IMG] isKindOfClass:[NSString class]]) {
            if ([user USER_IMG].length == 0 ) {
                flag = YES;
            }
        }
        if (!flag) {
            NSString *url = [NSString stringWithFormat:@"%@%@",ROOT_URL,[user USER_IMG]];
            
            UIImage *i = [BASE_IMAGE imageAsCircle:YES
                                       withDiamter:130
                                       borderColor:[UIColor clearColor]
                                       borderWidth:0.0f
                                      shadowOffSet:CGSizeZero];
            [_headImage sd_setImageWithURL:[NSURL URLWithString:url]
                          placeholderImage:i
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (image != nil) {
                                             UIImage *i = [image imageAsCircle:YES
                                                                   withDiamter:_headImage.frame.size.width
                                                                   borderColor:[UIColor clearColor]
                                                                   borderWidth:0.0f
                                                                  shadowOffSet:CGSizeZero];
                                             [_headImage setImage:i];

                                         }
                                     });
                                 }];
        }

        
        
        [_nameLabel setText:user.USERNAME];
    }else{
        [[AppDelegate appDelegate] requestUserInfo];
    }

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _curSeleted = 0;
        
        CGFloat imgW = 110.0;
        CGFloat imgH = 110.f;
        CGFloat rightOffset = self.revealSideViewController.offsetForCurrentPaningDirection;
        
       
        
        _headImage =[[UIImageView alloc] initWithImage:BASE_IMAGE];
        CGFloat imgX = (SCREEN_WIDTH - rightOffset - imgW) / 2 - 30;
        [_headImage setFrame:CGRectMake(imgX, 80, imgW, imgH)];
        [self.view addSubview:_headImage];
        
    
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFrame:CGRectMake(imgX, imgH + _headImage.frame.origin.y + 10, 110.f, 21.f)];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_nameLabel];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, SCREEN_WIDTH-74, 47 * 5) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[Util getColor:@"2a2a2a"]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setScrollEnabled:NO];
        [_tableView registerNib:[UINib nibWithNibName:@"UserCenterTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
        [self.view addSubview: _tableView];
        [_tableView setSeparatorColor:[Util getColor:@"2c2d33"]];

        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"主页",@"个人信息",@"密码修改",@"申请正式会员",@"退出"];
    _imgNameArray = @[@"Home",@"u_user",@"u_pwd",@"u_contract",@"Exit"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark tableview delegate & datasource


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (indexPath.row == 4) {
//        [cell.msgCountLabel setHidden:NO];
//    }else{
        [cell.msgCountLabel setHidden:YES];
//    }
    
    if (indexPath.row == _curSeleted) {
        [cell.statuLabel setHidden:NO];
    }else
        [cell.statuLabel setHidden:YES];
    
    [cell.leftTitleLabel setText:_titleArray[indexPath.row]];
    [cell.leftImageView setImage:[UIImage imageNamed:_imgNameArray[indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        if ([[GlobalUtil shareInstant] loginWithCus]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        if (![Util isLoginToDoOpereation]) {
            return;
        }
        EditUserInfoViewController *edit = [[EditUserInfoViewController alloc] init];
        
        BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:edit];
        
        [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    }
    else if (indexPath.row == 0){
        
        [self.revealSideViewController popViewControllerWithNewCenterController:[[AppDelegate appDelegate] mainViewController] animated:YES];
    }else if (indexPath.row == 2){
//        if ([[GlobalUtil shareInstant] loginWithCus]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        if (![Util isLoginToDoOpereation]) {
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([ChangePwdViewController class]) bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        
        BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
        
        [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];

    }else if (indexPath.row == 3){
//        if ([[GlobalUtil shareInstant] loginWithCus]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        if (![Util isLoginToDoOpereation]) {
            return;
        }
        
        ApplyMemberViewController *app = [[ApplyMemberViewController alloc] initWithStyle:UITableViewStyleGrouped];
        BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:app];
        [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    }else{
        [[AppDelegate appDelegate] logout];
        return;
    }
    
    _curSeleted = indexPath.row;
    [tableView reloadData];
}
@end
