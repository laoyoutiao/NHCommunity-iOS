//
//  ActiveViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "ActiveViewController.h"
#import "ActiveTableViewCell.h"
#import "BDL_WebDetailViewController.h"
#import "ActiveBiz.h"
@interface ActiveViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SearchResultDelegate>{
    NSMutableArray *_dataSource;
    ActiveBiz *_biz;
    UISearchBar *_searchBar;
    NSString *_pageRefreshSource;
    NSString *_pageLoadMoreSource;

    SearchByCategorViewCtr *_displayController;
}

@end

@implementation ActiveViewController

static NSString *identity = @"activeCell";
static NSString *normalIdentify = @"normal";

- (void)goBack{
//    [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:@""];
}

- (void)createNavSearchBar{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(-20,0.0f,SCREEN_WIDTH  - 44 - 4,44.0f)];
    _searchBar.delegate = self;
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar alwaysEnableSearch];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768.f, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动中心";
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
//    [self createNavSearchBar];
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    _pageRefreshSource = dateStr;
    _pageLoadMoreSource = dateStr;
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView registerNib:[UINib nibWithNibName:@"ActiveTableViewCell" bundle:nil] forCellReuseIdentifier:identity];
    [_tableView setBackgroundColor:TableViewBgColor];
    
    _biz = [ActiveBiz bizInstant];
    
    __weak __typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    
    _tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];


    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRefreshTime:(NSString *)dateString{
    _pageRefreshSource = dateString;
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    _pageLoadMoreSource = dateString;
}


/**
 *  获取参数
 *
 *  @param stautu 0：刷新，1 加载更富哦
 *
 *  @return param
 */
- (NSDictionary *)getParmWithStatu:(NSInteger)stautu{
    NSString *dateStr = nil;
    if (stautu == 0) {
        dateStr = _pageRefreshSource;
    }else
        dateStr = _pageLoadMoreSource;
    
    NSString *uname = [[[GlobalUtil shareInstant] loginInfo] objectForKey:U_NAME];
    if (uname == nil) {
        return [NSDictionary dictionary];
    }
    NSDictionary *param = @{@"userName":uname,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{
    NSInteger statu = 0;
    id data = _dataSource;
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *finalData = data;
        if (finalData.count > 0) {
            statu = 0;
        }else
            statu = 1;
    }else if (data == [NSNull null]){
        statu = 1;
    }
    NSDictionary *param = [self getParmWithStatu:statu];
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    [_biz requestActive:param
                success:^(NSDictionary *responseObj) {
                    [weakSelf hiddenLoading];
                    NSArray *data = responseObj[DATA_KEY_DATA];
                    if ([data isKindOfClass:[NSNull class]]) {
                        
                    }else{
                        if (data.count > 0) {
                            id value = _dataSource;
                            if (value == [NSNull null] || _dataSource.count == 0) {
                                [_dataSource addObjectsFromArray:data];
                                
                                NSDictionary *first = data[0];
                                NSDictionary *lastObj = data.lastObject;
                                [self updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                                
                            }else{
                                __block NSMutableArray *finalData = [NSMutableArray arrayWithArray:data];
                                [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    [finalData addObject:obj];
                                }];
                                
                                NSDictionary *first = finalData[0];
                                NSDictionary *lastObj = finalData.lastObject;
                                [self updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                            }
                        }
                    }
                    
                    [_tableView.mj_header endRefreshing];
                    [_tableView reloadData];
                }
                   fail:^(NSString *errorMsg) {
                        [weakSelf hiddenLoading];
                       [_tableView.mj_header endRefreshing];
                   }];
}

- (void)loadMore{
    NSDictionary *param = [self getParmWithStatu:1];
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    [_biz requestActive:param
                success:^(NSDictionary *responseObj) {
                                        [weakSelf hiddenLoading];
                    NSArray *data = responseObj[DATA_KEY_DATA];
                    if (data.count > 0) {
                        
                        id oldData = _dataSource;
                        if (oldData == [NSNull null]) {
                            [_dataSource addObjectsFromArray:data];
                            NSDictionary *lastObj = data.lastObject;
                            [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                        }else{
                            NSMutableArray *allData = [NSMutableArray arrayWithArray:oldData];
                            [allData addObjectsFromArray:data];
                            [_dataSource addObjectsFromArray:allData];
                            
                            NSDictionary *lastObj = data.lastObject;
                            [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                        }
                    }
                    
                    [_tableView.mj_footer endRefreshing];
                    [_tableView reloadData];

                }
                   fail:^(NSString *errorMsg) {
                                           [weakSelf hiddenLoading];
                       [_tableView.mj_footer endRefreshing];
                   }];
}


//- (void)updateReqTime{
//    _pageSource = [NSDate date];
//}
//
///**
// *  获取参数
// *
// *  @param stautu 0：刷新，1 加载更富哦
// *
// *  @return param
// */
//- (NSDictionary *)getParmWithStatu:(NSInteger)stautu{
//    NSDate *reqDate = _pageSource;
//    NSString *dateStr = [Util stringFromDate:reqDate withFormat:DATE_FORMMAT_STYLE_NORMARL];
//    NSString *uname = [[[GlobalUtil shareInstant] loginInfo] objectForKey:U_NAME];
//    NSDictionary *param = @{@"userName":uname,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
//    
//    return param;
//}
//
//- (void)refresh{
//    
//    NSDictionary *param = [self getParmWithStatu:0];
//    
//    [_biz requestActive:param
//                success:^(NSDictionary *responseObj) {
//                         [self updateReqTime];
//                         [_tableView.header endRefreshing];
//                    }
//                        fail:^(NSString *errorMsg) {
//                            [_tableView.header endRefreshing];
//                        }];
//}
//
//- (void)loadMore{
//    NSDictionary *param = [self getParmWithStatu:1];
//    
//    [_biz requestActive:param
//                     success:^(NSDictionary *responseObj) {
//                         [self updateReqTime];
//                         [_tableView.footer endRefreshing];
//                     }
//                        fail:^(NSString *errorMsg) {
//                            [_tableView.footer endRefreshing];
//                        }];
//}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger value = indexPath.row % 2;
    if (value == 0) {
        return 10;
    }
    return [ActiveTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger value = indexPath.row % 2;
    if (value == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
            [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
        }
        return cell;
    }
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    [self configBaseNewsCell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setHidesBottomBarWhenPushed:YES];
    [detail setActive:YES];
    
    NSInteger row = indexPath.row / 2;
    NSDictionary *dict = _dataSource[row];
    [detail setTitleString:dict[DATA_KEY_TITLE]];
    [detail setContentId:dict[@"ID"]];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configBaseNewsCell:(ActiveTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSArray *data = _dataSource;
    NSInteger row = indexPath.row / 2;
    NSDictionary *dict = data[row];
    [cell.headTitleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.orgLabel setText:[NSString stringWithFormat:@"主办单位:%@",dict[DATA_KEY_CHARGER]]];
    [cell.siteLabel setText:[NSString stringWithFormat:@"活动地点:%@",dict[DATA_KEY_ADDRESS]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"活动时间:%@",dict[DATA_KEY_DATELINE]]];
//    id content = dict[DATA_KEY_DESCRIPTION];
//    if (![content isKindOfClass:[NSNull class]]) {
//        if ([content stringIsNull]) {
//            [cell.contentLabel setText:@""];
//        }else{
//            [cell.contentLabel setText:content];
//        }
//    }else
//        [cell.contentLabel setText:@""];
}


#pragma mark -- search bar delegate
- (void)searchResultClickWithData:(NSDictionary *)data{
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setTitleString:data[DATA_KEY_TITLE]];
    [detail setContentId:data[DATA_KEY_CONTENT_ID]];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)createSearchCtr{
    if (!_displayController) {
        _displayController = [[SearchByCategorViewCtr alloc] init];
        [_displayController setSearchDelegate:self];
        [self.view addSubview:_displayController.view];
    }
    
    [_displayController setCateType:Acitve_Search_Tag];
    [_displayController.view setHidden:NO];
}

- (void)closeSearchCtr:(BOOL)hidden{
    [_displayController.view setHidden:hidden];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        [searchBar resignFirstResponder];
    }else{
        [_displayController searchWithKeyWord:_searchBar.text];
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self createSearchCtr];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        [self closeSearchCtr:YES];
    }
}
@end
