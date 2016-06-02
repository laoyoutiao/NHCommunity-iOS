//
//  LawListViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LawListViewController.h"
#import "CommunityBaseInfoTableViewCell.h"
#import "CommunityBiz.h"

#import "UIBarButtonItem+CTop.h"
#import "SubmitViewController.h"
#import "BDL_WebDetailViewController.h"
#import "QusetionBiz.h"
#import "QuestionTableViewCell.h"
typedef enum {
    Law_List = 0,
    Law_know,
    Law_Question
}LawType;

@interface LawListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SearchResultDelegate,UIScrollViewDelegate>
{
    QusetionBiz *_qBiz;
    LawType _curLawType;
    CommunityBiz *_biz;
    
    UISearchBar *_searchBar;
    
    NSMutableDictionary *_dataSource;
    NSMutableDictionary *_pageRefreshSource;
    NSMutableDictionary *_pageLoadMoreSource;
    
    SearchByCategorViewCtr *_displayController;
    
    UIScrollView *_scrollHeaderView;
    
    UIScrollView *_contentScroll;
    
    NSMutableArray *_viewArray;
    
    NSInteger _lastPage;
    
}


@end

@implementation LawListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lawType:(NSInteger)lawType{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        switch (lawType) {
//            case 0:{
//                _curLawType = Law_List;
//                [_lawList setSelected:YES];
//            }
//                break;
//            case 1:{
//                _curLawType = Law_know;
//                [_lawKnow setSelected:YES];
//            }
//                break;
//            case 2:{
//                _curLawType = Law_Question;
//                [_lawQuestion setSelected:YES];
//            }
//                break;
//            default:
//                break;
//        }
    }
    return self;
}

- (void)goBack{
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:@""];
}


- (void)showRight{
//    if ([[GlobalUtil shareInstant] loginWithCus]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if (![Util isLoginToDoOpereation]) {
        return;
    }
    SubmitViewController *sub = [[SubmitViewController alloc] init];
    [sub setCurType:REQ_ASK];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sub];
    [self presentViewController:nav animated:NO completion:NULL];
}

- (void)createNavSearchBar{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0.0f,SCREEN_WIDTH  - 44 - 70,44.0f)];
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
    self.navigationItem.titleView = searchView;

}

- (void)createScrollSegView{
    _scrollHeaderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    [_scrollHeaderView setShowsVerticalScrollIndicator:NO];
    [_scrollHeaderView setShowsHorizontalScrollIndicator:NO];
    [_scrollHeaderView setBackgroundColor:[Util getColor:@"F0F0F0"]];
    [self.view addSubview:_scrollHeaderView];
    
    CGFloat w = 70.f;
    CGFloat h = 24.f;
    CGFloat x = 5.f;
    CGFloat y = 4.f;
    CGFloat marginX = 10.f;
    NSArray *title = @[@"法律法规",@"法律常识",@"常见问题"];
    for (int i = 0; i < title.count; i++) {
        CGRect frame = CGRectMake(x + w * i + marginX * i, y, w, h);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:frame];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_scrollHeaderView addSubview:btn];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[Util getColor:@"868686"] forState:UIControlStateNormal];
        btn.tag = 1001 + i;
        [btn addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setBorderColor:[UIColor clearColor].CGColor];
        [btn.layer setBorderWidth:0.5f];
        [btn.layer setCornerRadius:5.f];
        
        switch (i) {
            case 0:{
                _lawList = btn;
            }
                break;
            case 1:{
                _lawKnow = btn;
            }
                break;
            case 2:{
                _lawQuestion = btn;
            }
                break;
            default:
                break;
        }
    }

}

- (void)createContentScroll{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 33, SCREEN_WIDTH, SCREEN_HEIGHT - 33 - 64)];
    [_contentScroll setShowsVerticalScrollIndicator:NO];
    [_contentScroll setShowsHorizontalScrollIndicator:NO];
    [_contentScroll setScrollEnabled:YES];
    [_contentScroll setPagingEnabled:YES];
    [_contentScroll setDelegate:self];
    [_contentScroll setBackgroundColor:TableViewBgColor];
    [self.view addSubview:_contentScroll];
    
    _viewArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 3; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH * i, 0, SCREEN_WIDTH, CGRectGetHeight(_contentScroll.bounds)) style:UITableViewStylePlain];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [table setTableFooterView:[[UIView alloc] init]];
        
        [table setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.0)];
        
        [table registerNib:[UINib nibWithNibName:@"CommunityBaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityBaseInfoTableViewCell identify]];
        [table registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:[QuestionTableViewCell identify]];
        
        if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [table setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [table setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        __weak __typeof(self)weakSelf = self;
        table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refresh];
        }];
        
        table.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        
        [_contentScroll addSubview:table];
        
        [_viewArray addObject:table];
        
    }
    
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"护权益";
    
    [self.view setBackgroundColor:[Util getColor:@"F0F0F0"]];
    
    [self createLeftUserCenterBtn];

//    [self createNavSearchBar];
    
    [self createScrollSegView];
    
    [self createContentScroll];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"在线维权" titleColor:[UIColor whiteColor] target:self action:@selector(showRight) edgInset:UIEdgeInsetsMake(0, 10, 0, -10)];
    

    _dataSource = [[NSMutableDictionary alloc] init];
    _pageRefreshSource = [[NSMutableDictionary alloc] init];
    _pageLoadMoreSource = [[NSMutableDictionary alloc] init];
    
    [_dataSource setObject:[NSNull null] forKey:@(Law_List)];
    [_dataSource setObject:[NSNull null] forKey:@(Law_know)];
    [_dataSource setObject:[NSNull null] forKey:@(Law_Question)];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    
    [_pageRefreshSource setObject:dateStr forKey:@(Law_List)];
    [_pageRefreshSource setObject:dateStr forKey:@(Law_know)];
    [_pageRefreshSource setObject:dateStr forKey:@(Law_Question)];
    
    [_pageLoadMoreSource setObject:dateStr forKey:@(Law_List)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Law_know)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Law_Question)];
    
    _biz = [CommunityBiz bizInstant];
    _qBiz = [QusetionBiz bizInstant];
    
    UIButton *btn = nil;
    switch (_curLawType) {
        case Law_List:{
            [_lawList setSelected:YES];
            btn = _lawList;
        }
            break;
        case Law_know:{
            [_lawKnow setSelected:YES];
            btn = _lawKnow;
        }
            break;
        case Law_Question:{
            [_lawQuestion setSelected:YES];
            btn = _lawQuestion;
        }
            break;
            
        default:
            break;
    }
    
    [btn setBackgroundColor:[Util getColor:@"007AFF"]];
    
    _lastPage = (NSInteger)_curLawType;
    [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH * (NSInteger)_curLawType, 0) animated:NO];
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:btn waitUntilDone:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateRefreshTime:(NSString *)dateString{
    [_pageRefreshSource setObject:dateString forKey:@(_curLawType)];
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    [_pageLoadMoreSource setObject:dateString forKey:@(_curLawType)];
}

#pragma mark -- 法律
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
        dateStr = _pageRefreshSource[@(_curLawType)];
    }else{
        dateStr = _pageLoadMoreSource[@(_curLawType)];
    }
    
    
    NSInteger chan = -1;
    switch (_curLawType) {
        case Law_List:
            chan = 114;
            break;
        case Law_know:
            chan = 444;
            break;
        case Law_Question:
            chan = 92;
            break;
        default:
            break;
    }

    NSDictionary *param = @{@"channel_id":@(chan),@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{

    //当前的pageIndex
    NSInteger pageIndex = (NSInteger)_curLawType;
    
    NSInteger statu = 0;
    id data = _dataSource[@(_curLawType)];
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
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         [weakSelf hiddenLoading];
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             id value = _dataSource[@(_curLawType)];
                             if (value == [NSNull null]) {
                                 [_dataSource setObject:data forKey:@(_curLawType)];
                                 
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
                         
                         UITableView *table = _viewArray[pageIndex];
                         [table.mj_header endRefreshing];
                         [table reloadData];
                     }
                        fail:^(NSString *errorMsg) {
                            [weakSelf hiddenLoading];
                            UITableView *table = _viewArray[pageIndex];
                            [table.mj_header endRefreshing];
                        }];
}

- (void)loadMore{
    //当前的pageIndex
    NSInteger pageIndex = (NSInteger)_curLawType;
    
    NSDictionary *param = [self getParmWithStatu:1];
    
    [self showLoading];
    __weak __typeof(self)weakSelf = self;
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         [weakSelf hiddenLoading];
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             
                             id oldData = _dataSource[@(_curLawType)];
                             if (oldData == [NSNull null]) {
                                 [_dataSource setObject:data forKey:@(_curLawType)];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }else{
                                 NSMutableArray *allData = [NSMutableArray arrayWithArray:oldData];
                                 [allData addObjectsFromArray:data];
                                 [_dataSource setObject:allData forKey:@(_curLawType)];
                                 
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }
                         
                         UITableView *table = _viewArray[pageIndex];
                         [table.mj_footer endRefreshing];
                         [table reloadData];
                     }
                        fail:^(NSString *errorMsg) {
                            [weakSelf hiddenLoading];
                            UITableView *table = _viewArray[pageIndex];
                            [table.mj_footer endRefreshing];
                        }];
}

- (IBAction)segChange:(UIButton *)btn{
    NSInteger tag = btn.tag - 1001;
    
    switch (tag) {
        case 0:
            _curLawType = Law_List;
            break;
        case 1:
            _curLawType = Law_know;
            break;
        case 2:
            _curLawType = Law_Question;
            break;
        default:
            break;
    }
    
    [_scrollHeaderView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *segBtn = (UIButton *)obj;
            if (btn.tag == segBtn.tag) {
                [segBtn setSelected:YES];
                [segBtn setBackgroundColor:[Util getColor:@"007AFF"]];
            }else{
                [segBtn setSelected:NO];
                [segBtn setBackgroundColor:[UIColor clearColor]];
            }
        }
    }];
    
    id data = _dataSource[@(_curLawType)];
    UITableView *table = _viewArray[tag];
    [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH * tag, 0) animated:NO];
    if (data == [NSNull null]) {
        [table.mj_header beginRefreshing];
        
    }else{
        [table reloadData];
    }
    
}

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

    id data = _dataSource[@(_curLawType)];
    if (data == [NSNull null]) {
        return 0;
    }else{
        return [data count] * 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inde = indexPath.row % 2;
    if (inde == 0) {
        return 10;
    }
    return [CommunityBaseInfoTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inde = indexPath.row % 2;
    if (inde == 0) {
        static NSString *noridentify = @"normalIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noridentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noridentify];
            [cell setBackgroundColor:TableViewBgColor];
        }
        return cell;
    }

    
    static NSString *identify = @"cmmBaseCell";
    CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    [self configBaseNewsCell:cell indexPath:indexPath];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *data = _dataSource[@(_curLawType)];
    NSInteger row = indexPath.row / 2;
    NSDictionary *dict = data[row];
    
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];

    if (_curLawType == Law_List) {
        [detail setTitleString:@"法律法规"];
    }else if (_curLawType == Law_know){
        [detail setTitleString:@"法律常识"];
    }else{
        [detail setTitleString:@"常见问题"];
    }

    
    [detail setContentId:dict[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)configBaseNewsCell:(CommunityBaseInfoTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{

    id value = _dataSource[@(_curLawType)];
    if(value == [NSNull null])
        return;
    
    NSArray *data = value;
    NSInteger row = indexPath.row / 2;
    NSDictionary *dict = data[row];
    [cell.titleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.dateLabel setText:dict[DATA_KEY_RELEASE_DATE]];
    id content = dict[DATA_KEY_DESCRIPTION];
    if (![content isKindOfClass:[NSNull class]]) {
        if ([content stringIsNull]) {
            [cell.contentLabel setText:@""];
        }else{
            [cell.contentLabel setText:content];
        }
    }else
        [cell.contentLabel setText:@""];
}

#pragma mark -- search bar delegate
- (void)searchResultClickWithData:(NSDictionary *)data{
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setTitleString:data[DATA_KEY_TITLE]];
    [detail setContentId:data[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)createSearchCtr{
    if (!_displayController) {
        _displayController = [[SearchByCategorViewCtr alloc] init];
        [self.view addSubview:_displayController.view];
        [_displayController setSearchDelegate:self];
    }
    
    NSInteger chan = 0;
    switch (_curLawType) {
        case Law_List:
            chan = 443;
            break;
        case Law_know:
            chan = 444;
            break;
        case Law_Question:
            chan = 92;
            break;
        default:
            break;
    }
    [_displayController setCateType:chan];
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

#pragma mark -- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    int page = (scrollView.contentOffset.x + CGRectGetWidth(_contentScroll.bounds)/2.0) / CGRectGetWidth(_contentScroll.bounds);
    
    if (_lastPage == page) {
        return;
    }
    _lastPage = page;
    
    UIButton *btn = nil;
    switch (page) {
        case 0:{
            _curLawType = Law_List;
            btn = _lawList;
        }
            break;
        case 1:{
            _curLawType = Law_know;
            btn = _lawKnow;}
            break;
        case 2:{
            _curLawType = Law_Question;
            btn = _lawQuestion;
        }
            break;
        default:
            break;
    }
    
    if (page == 4) {
         [_scrollHeaderView setContentOffset:CGPointMake(78, 0) animated:YES];
    }else{
        [_scrollHeaderView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:btn waitUntilDone:NO];
}
@end
