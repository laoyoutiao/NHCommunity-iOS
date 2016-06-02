//
//  SearchCompanyViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/12/28.
//  Copyright © 2015年 ku. All rights reserved.
//

#import "SearchCompanyViewController.h"
#import "UISearchBar+Enabler.h"
#import "Util.h"
#import "CompanylistTableViewCell.h"

@interface SearchCompanyViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong)NSMutableArray *searchResult;


@end

@implementation SearchCompanyViewController

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询所属企业";
    [self createBackBtn];
    _searchResult = [[NSMutableArray alloc] init];
    
    [_searchBar alwaysEnableSearch];
    [_searchBar setPlaceholder:@"请输入企业名称"];
    [_searchBar setDelegate:self];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setBackgroundColor:TableViewBgColor];
    [_tableView registerNib:[UINib nibWithNibName:@"CompanylistTableViewCell" bundle:nil] forCellReuseIdentifier:[CompanylistTableViewCell indetify]];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    return _searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompanylistTableViewCell indetify] forIndexPath:indexPath];
    if (_searchResult.count > 0) {
        NSDictionary *dict = _searchResult[indexPath.row];
        [cell.nameL setText:dict[@"NAME"]];
        if ([dict[@"TRADEUNION"] isKindOfClass:[NSString class]]) {
            [cell.addressL setText:dict[@"TRADEUNION"]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_searchResult.count > 0) {
        _clickBlk(_searchResult[indexPath.row]);
    }
    [self goBack];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_searchBar setText:@""];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [self doSearchWithTxt:searchBar.text];
}

- (void)doSearchWithTxt:(NSString *)txt{
    
    [self.searchResult removeAllObjects];
    [_tableView reloadData];
    [_searchBar setUserInteractionEnabled:NO];
    
    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在搜索" maskType:SVProgressHUDMaskTypeNone];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_SEARCH_COMPANY] param:@{@"searcheKey":txt} success:^(id responObject) {
        NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
        if (reRequest != nil) {
            BOOL reFlag = reRequest.boolValue;
            if (reFlag) {
                [weakSelf doSearchWithTxt:txt];
            }
        }else{

            if ([responObject[@"code"] integerValue] == 0) {
                [SVProgressHUD dismiss];
                [weakSelf.searchResult removeAllObjects];
                [weakSelf.searchResult addObjectsFromArray:responObject[@"data"]];
                [weakSelf.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:responObject[@"msg"]];
            }
            
            [weakSelf.searchBar setUserInteractionEnabled:YES];
        }
    } fail:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
        [weakSelf.searchBar setUserInteractionEnabled:YES];
    }];
}
@end
