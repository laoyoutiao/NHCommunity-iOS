//
//  StaffSercieHomeViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "StaffSercieHomeViewController.h"
#import "SSViewModel.h"
#import "StaffIconModel.h"
#import "WebDetailOnlyByLinkViewController.h"
#import "LifeMarketController.h"
#import "JoinInTableViewController.h"
#import "StaffAskTableViewController.h"
@interface StaffSercieHomeViewController (){
    SSViewModel *_viewModel;
    UIScrollView *_scrollView;
}

@end

@implementation StaffSercieHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"惠服务";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self createLeftUserCenterBtn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _viewModel = [[SSViewModel alloc] init];
    
    
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    
    [_scrollView addSubview:[_viewModel headerImageView]];
    
//    [_scrollView addSubview:[_viewModel middelDescTxtView]];
    
    __weak __typeof(self)weakSelf = self;
    UIView *opView = [_viewModel operationViewWithClick:^(StaffIconModel *smodel, NSInteger clickIndex) {
        if ([smodel.targetController isEqualToString:@"JoinInTableViewController"]) {
            if (![Util isLoginToDoOpereation]) {
                return;
            }
            JoinInTableViewController *vc = [[JoinInTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [vc setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if ([smodel.targetController isEqualToString:@"StaffAskTableViewController"]){
            if (![Util isLoginToDoOpereation]) {
                return;
            }
            StaffAskTableViewController *vc = [[StaffAskTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [vc setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            WebDetailOnlyByLinkViewController *vc = (WebDetailOnlyByLinkViewController *)[smodel controller];
            [vc setModel:smodel];
            [vc setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
    
    UIView *bookView = [_viewModel bookViewWithClick:^(StaffIconModel *model, NSInteger clickIndex) {
        WebDetailOnlyByLinkViewController *vc = (WebDetailOnlyByLinkViewController *)[model controller];
        [vc setModel:model];
        [vc setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    UIView *sView = [_viewModel serviceViewWithClick:^(StaffIconModel *smodel, NSInteger clickIndex) {
        [weakSelf servieGo:smodel];
    }];
    
    [_scrollView addSubview:opView];
    [_scrollView addSubview:bookView];
    [_scrollView addSubview:sView];
    
    [_scrollView setContentSize:CGSizeMake(0, sView.frame.size.height + sView.frame.origin.y + 36)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)servieGo:(StaffIconModel *)model{
    if (model.url) {
        WebDetailOnlyByLinkViewController *controller = (WebDetailOnlyByLinkViewController *)[model controller];
        [controller setModel:model];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([model.targetController isEqualToString:@"LifeMarketController"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([LifeMarketController class]) bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        UIViewController *controler = [model controller];
        [controler setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controler animated:YES];
    }
}
@end
