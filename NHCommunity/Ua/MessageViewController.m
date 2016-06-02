//
//  MessageViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "MessageViewController.h"
#import "UIBarButtonItem+CTop.h"
#import "MsgTableViewCell.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@end

@implementation MessageViewController

static NSString *idntify = @"msgCell";

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    _dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i<20; i++) {
        [_dataSource addObject:@"a"];
    }
    
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"忽略未读" forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero, CGSizeMake(60, 44)};
    [button setTitleColor:[Util getColor:@"c6e0ff"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [button addTarget:self action:@selector(unRead) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView registerNib:[UINib nibWithNibName:@"MsgTableViewCell" bundle:nil] forCellReuseIdentifier:idntify];
    [self.view addSubview: _tableView];
    
    
}

- (void)unRead{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MsgTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idntify];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
