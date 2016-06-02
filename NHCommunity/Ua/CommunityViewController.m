//
//  CommunityViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityNewsTableViewCell.h"
#import "CommunityBaseInfoTableViewCell.h"
#import "CommunityBiz.h"
#import "SearchByCategorViewCtr.h"
#import "BDL_WebDetailViewController.h"
#import "AutoScrollBannerView.h"
#import "UserCenterViewController.h"
#import "AppDelegate.h"

typedef enum {
    Comm_Notifi = 110,
    Comm_Commnuity = 111,
    Comm_service = 113
}CommType;

#define ScrollBannerHeight 140

@interface CommunityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SearchResultDelegate,UIScrollViewDelegate,AutoScrollBannerDelegate>
{
    CommType _curCommType;
    CommunityBiz *_biz;
    UISearchBar *_searchBar;
    

    NSMutableDictionary *_pageRefreshSource;
    NSMutableDictionary *_pageLoadMoreSource;
    
    SearchByCategorViewCtr *_displayController;
    
    UIScrollView *_contentScroll;

    NSInteger _lastPage;
}
@property (nonatomic, strong)     NSMutableDictionary *dataSource;
@property (nonatomic, strong)     NSMutableArray *viewArray;
@end

@implementation CommunityViewController

- (void)goBack{
    [_displayController setSearchDelegate:nil];
//    if (self.navigationController.childViewControllers.count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:@""];
//        return;
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNavSearchBar{
   _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0.0f,SCREEN_WIDTH  - 44 - 4,44.0f)];
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

- (void)gestureSwip:(UISwipeGestureRecognizer *)swip{

    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_curCommType == Comm_Commnuity) {
            return;
        }
        switch (_curCommType) {
            case Comm_Notifi:
//                [self segChange:_comunitBtn];
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_notiBtn waitUntilDone:NO];
                break;
            case Comm_service:
//                [self segChange:_notiBtn];
                 [self performSelectorOnMainThread:@selector(segChange:) withObject:_comunitBtn waitUntilDone:NO];
                break;
            default:
                break;
        }
    }else if (swip.direction == UISwipeGestureRecognizerDirectionRight){
        if (_curCommType == Comm_service) {
            return;
        }
        switch (_curCommType) {
            case Comm_Notifi:
//                [self segChange:_serviceBtn];
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_serviceBtn waitUntilDone:NO];
                break;
            case Comm_Commnuity:
//                [self segChange:_notiBtn];

                 [self performSelectorOnMainThread:@selector(segChange:) withObject:_comunitBtn waitUntilDone:NO];
                break;
            default:
                break;
        }
    }
}

- (void)createContentScroll{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 33, SCREEN_WIDTH, SCREEN_HEIGHT - 33 - 64 - 49)];
    [_contentScroll setShowsVerticalScrollIndicator:NO];
    [_contentScroll setShowsHorizontalScrollIndicator:NO];
    [_contentScroll setScrollEnabled:YES];
    [_contentScroll setPagingEnabled:YES];
    [_contentScroll setDelegate:self];
    [_contentScroll setBounces:NO];
    [_contentScroll setBackgroundColor:TableViewBgColor];
    [self.view addSubview:_contentScroll];
    
    _viewArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH * i, 0, SCREEN_WIDTH, CGRectGetHeight(_contentScroll.bounds)) style:UITableViewStylePlain];
        [table setDelegate:self];
        [table setDataSource:self];
     
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [table setTableFooterView:[[UIView alloc] init]];
        
        [table setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.0)];
        
        [table registerNib:[UINib nibWithNibName:@"CommunityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityNewsTableViewCell identify]];
        [table registerNib:[UINib nibWithNibName:@"CommunityBaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityBaseInfoTableViewCell identify]];
        
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
    self.title = @"知工会";
//    [self createBackBtn];
    [self  createLeftUserCenterBtn];
    
//    [self createNavSearchBar];
    
    _biz = [CommunityBiz bizInstant];
    
    _curCommType = Comm_Commnuity;
    [_notiBtn setSelected:YES];
    _dataSource = [[NSMutableDictionary alloc] init];
    _pageRefreshSource = [[NSMutableDictionary alloc] init];
    _pageLoadMoreSource = [[NSMutableDictionary alloc] init];
    
    [_dataSource setObject:[NSNull null] forKey:@(Comm_Notifi)];
    [_dataSource setObject:[NSNull null] forKey:@(Comm_Commnuity)];
    [_dataSource setObject:[NSNull null] forKey:@(Comm_service)];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    [_pageRefreshSource setObject:dateStr forKey:@(Comm_Notifi)];
    [_pageRefreshSource setObject:dateStr forKey:@(Comm_Commnuity)];
    [_pageRefreshSource setObject:dateStr forKey:@(Comm_service)];
    
    [_pageLoadMoreSource setObject:dateStr forKey:@(Comm_Notifi)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Comm_Commnuity)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Comm_service)];

//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
//    [_tableView setTableFooterView:[[UIView alloc] init]];
//    [_tableView setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.0)];
//    [_tableView registerNib:[UINib nibWithNibName:@"CommunityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityNewsTableViewCell identify]];
//    [_tableView registerNib:[UINib nibWithNibName:@"CommunityBaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityBaseInfoTableViewCell identify]];
//
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    __weak __typeof(self)weakSelf = self;
//    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf refresh];
//    }];
//    
//    [_tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf loadMore];
//    }];
//    
//    [_tableView.header beginRefreshing];
    
    
//    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwip:)];
//    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwip:)];
//    [right setDirection:UISwipeGestureRecognizerDirectionRight];
//    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:right];
//    [self.view addGestureRecognizer:left];
    
    [self createContentScroll];
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:_notiBtn waitUntilDone:NO];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRefreshTime:(NSString *)dateString{
    [_pageRefreshSource setObject:dateString forKey:@(_curCommType)];
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    [_pageLoadMoreSource setObject:dateString forKey:@(_curCommType)];
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
        dateStr = _pageRefreshSource[@(_curCommType)];
    }else
        dateStr = _pageLoadMoreSource[@(_curCommType)];
    
    NSString *channleId = [NSString stringWithFormat:@"%@",@(_curCommType)];
    NSDictionary *param = @{@"channel_id":channleId,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{

    //当前的pageIndex
    NSInteger pageIndex = 0;
    switch (_curCommType) {
        case 110:{
            pageIndex = 1;
        }
            break;
        case 111:{
            pageIndex = 0;
            
        }
            break;
        case 113:{
            
            pageIndex = 2;
        }
            break;
            
        default:
            break;
    }


    NSInteger statu = 0;
    id data = _dataSource[@(_curCommType)];
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
    
    [self showLoading];
    __weak __typeof(self)weakSelf = self;
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         [weakSelf hiddenLoading];
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             id value = weakSelf.dataSource[@(_curCommType)];
                             if (value == [NSNull null]) {
                                 [weakSelf.dataSource setObject:data forKey:@(_curCommType)];
                                 
                                 NSDictionary *first = data[0];
                                 NSDictionary *lastObj = data.lastObject;
                                 [weakSelf updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                 [weakSelf updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                                 
                             }else{
                                 __block NSMutableArray *finalData = [NSMutableArray arrayWithArray:data];
                                 [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     [finalData addObject:obj];
                                 }];
                                 
                                 NSDictionary *first = finalData[0];
                                 NSDictionary *lastObj = finalData.lastObject;
                                 [weakSelf updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                 [weakSelf updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }
                         
                         UITableView *table = weakSelf.viewArray[pageIndex];
                         [table.mj_header endRefreshing];
                         [table reloadData];


                    }
                        fail:^(NSString *errorMsg) {
                                                     [weakSelf hiddenLoading];
                        UITableView *table = weakSelf.viewArray[pageIndex];
                        [table.mj_header endRefreshing];
    }];
}

- (void)loadMore{
    NSDictionary *param = [self getParmWithStatu:1];
    
    //当前的pageIndex
    NSInteger pageIndex = 0;
    switch (_curCommType) {
        case 110:{
            pageIndex = 1;
        }
            break;
        case 111:{
            pageIndex = 0;
          
        }
            break;
        case 113:{
          
            pageIndex = 2;
        }
            break;
            
        default:
            break;
    }

        [self showLoading];
    __weak __typeof(self)weakSelf = self;
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         NSArray *data = responseObj[DATA_KEY_DATA];
                        [weakSelf hiddenLoading];
                         if (data.count > 0) {
                             id oldData = weakSelf.dataSource[@(_curCommType)];
                             if (oldData == [NSNull null]) {
                                 [weakSelf.dataSource setObject:data forKey:@(_curCommType)];
                                 NSDictionary *lastObj = data.lastObject;
                                 [weakSelf updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }else{
                                 NSMutableArray *allData = [NSMutableArray arrayWithArray:oldData];
                                 [allData addObjectsFromArray:data];
                                 [weakSelf.dataSource setObject:allData forKey:@(_curCommType)];
                                 
                                 NSDictionary *lastObj = data.lastObject;
                                 [weakSelf updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }
                         
                         UITableView *table = weakSelf.viewArray[pageIndex];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [table.mj_footer endRefreshing];
                             [table reloadData];
                         });

                     }
                        fail:^(NSString *errorMsg) {
                            [weakSelf hiddenLoading];
                            UITableView *table = weakSelf.viewArray[pageIndex];
                            [table.mj_footer endRefreshing];

                        }];
}

- (IBAction)segChange:(UIButton *)btn{
    NSInteger tag = btn.tag;
//
//    if (tag == _curCommType) {
//        return;
//    }
    NSInteger index =0;
    switch (tag) {
        case 110:{
            index = 1;
            _curCommType = Comm_Notifi;}
            break;
        case 111:{
            index = 0;
            _curCommType = Comm_Commnuity;
        }
            break;
        case 113:{
            _curCommType = Comm_service;
            index = 2;
        }
            break;
            
        default:
            break;
    }


//    NSString *subType = nil;
//    
//    if (tag > _curCommType) {
//        subType = kCATransitionFromLeft;
//    }else{
//        subType = kCATransitionFromRight;
//    }
//    
//    [Util pushAnimationWithLayer:_tableView.layer
//                        duration:0.3f
//                            type:kCATransitionPush
//                        subtType:subType];
    
    [_segView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *segBtn = (UIButton *)obj;
            if (btn.tag == segBtn.tag) {
                [segBtn setSelected:YES];
            }else{
                [segBtn setSelected:NO];
            }
        }
    }];

    id data = _dataSource[@(_curCommType)];
    UITableView *table = _viewArray[index];
      [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
    if (data == [NSNull null]) {
    
        [table.mj_header beginRefreshing];
    }else{
        [table reloadData];
    }
}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_curCommType == Comm_Commnuity) {
        id data = _dataSource[@(_curCommType)];
        if (data == [NSNull null]) {
            return 1;
        }else{
            NSInteger toatalCount = [(NSArray*)data count];
            if (toatalCount > 3) {
                return 2 + (toatalCount - 3) * 2;
            }
            return 0;
        }
    }else{
        id data = _dataSource[@(_curCommType)];
        if (data == [NSNull null]) {
            return 0;
        }else{
            return [data count] * 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_curCommType == Comm_Commnuity) {
        if (indexPath.row == 0) {
            return ScrollBannerHeight;
        }
        else{
            CGFloat inde = indexPath.row % 2;
            if (inde == 1) {
                return 10;
            }
            return [CommunityBaseInfoTableViewCell cellHeight];
        }
    }
    
    CGFloat inde = indexPath.row % 2;
    if (inde == 0) {
        return 10;
    }
    if (_curCommType == Comm_Notifi) {
        return [CommunityNewsTableViewCell cellHeight];
    }else
        return [CommunityBaseInfoTableViewCell cellHeight];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_curCommType == Comm_Commnuity) {
        if (indexPath.row == 0) {
            static NSString *scrollIdentify = @"iscroll";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scrollIdentify];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
                [cell setBackgroundColor:TableViewBgColor];
                AutoScrollBannerView *scroll = [[AutoScrollBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScrollBannerHeight)];
                [cell.contentView addSubview:scroll];
                [scroll setDelegate:self];
                [scroll setTag:99991];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            AutoScrollBannerView *scroll = (AutoScrollBannerView *)[cell.contentView viewWithTag:99991];
            NSArray *data = _dataSource[@(_curCommType)];
            if ([data isKindOfClass:[NSArray class]]) {
                if (data.count > 0) {
                    NSMutableArray *scrollData = [[NSMutableArray alloc] init];
                    for (int i = 0; i < data.count; i++) {
                        if (i > 2) {
                            break;
                        }
                        [scrollData addObject:data[i]];
                    }
                    [scroll updateScrollContent:scrollData
                                withImageHeight:ScrollBannerHeight];
                }
            }
            return cell;
        }else{
            CGFloat inde = indexPath.row % 2;
            if (inde == 1) {
                static NSString *noridentify = @"normalIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noridentify];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noridentify];
                    [cell setBackgroundColor:TableViewBgColor];
                }
                return cell;
            }else{
                static NSString *identify = @"cmmCell";
                CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            
                NSArray *data = _dataSource[@(_curCommType)];
                NSInteger row = (indexPath.row) / 2 - 1;
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
                }else{
                    [cell.contentLabel setText:@""];
                }
                
                NSString *url = dict[DATA_KEY_TYPE_IMG];
                if (![url isKindOfClass:[NSNull class]]) {
                    if (![url stringIsNull]) {
                        if ([url stringStartwithHttp]) {
                            [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                        }else{
                            [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                        }
                    }
                }
                
                return cell;
            }
        }
    }


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
    
    if (_curCommType == Comm_Notifi) {
//        static NSString *identify = @"cmmCell";
//        CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        [self configNewsCell:cell indexPath:indexPath];
        static NSString *identify = @"cmmBaseCell";
        CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        NSArray *data = _dataSource[@(_curCommType)];
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
        
        return cell;
    }else{
        static NSString *identify = @"cmmBaseCell";
        CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        [self configBaseNewsCell:cell indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     NSInteger row = indexPath.row / 2;
    if (_curCommType == Comm_Commnuity) {
        row = (indexPath.row) / 2 - 1;
        
        CGFloat inde = indexPath.row % 2;
        if (inde == 1 || indexPath.row == 0) {
            return;
        }
    }
    
    NSArray *data = _dataSource[@(_curCommType)];
    NSDictionary *dict = data[row];
    
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    if (_curCommType == Comm_Commnuity) {
        [detail setTitleString:@"工会要闻"];
    }else if (_curCommType == Comm_Notifi){
        [detail setTitleString:@"通知公告"];
    }else{
        [detail setTitleString:@"服务信息"];
    }

    [detail setContentId:dict[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configNewsCell:(CommunityNewsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSArray *data = _dataSource[@(_curCommType)];
    NSInteger row = indexPath.row / 2;
    NSDictionary *dict = data[row];
    [cell.titleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.dateLabel setText:dict[DATA_KEY_RELEASE_DATE]];
    NSString *content = dict[DATA_KEY_DESCRIPTION];
    if (![content isKindOfClass:[NSNull class]]) {
        if ([content stringIsNull]) {
            [cell.contentLabel setText:@""];
        }else{
            [cell.contentLabel setText:content];
        }
    }else
        [cell.contentLabel setText:@""];

    
    NSString *url = dict[DATA_KEY_TYPE_IMG];
    if (![url isKindOfClass:[NSNull class]]) {
        if (![url stringIsNull]) {
            if ([url stringStartwithHttp]) {
                [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
            }else{
                [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
            }
        }
    }
}

- (void)configBaseNewsCell:(CommunityBaseInfoTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    if (_curCommType == Comm_Commnuity) {
        NSArray *data = _dataSource[@(_curCommType)];
        NSInteger row = (indexPath.row) / 2 + 3;
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
    }else{
        NSArray *data = _dataSource[@(_curCommType)];
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
    
    [_displayController setCateType:(NSInteger)_curCommType];
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
            _curCommType = Comm_Notifi;
            btn = _notiBtn;
        }
            break;
        case 1:{
            _curCommType = Comm_Commnuity;
            btn = _comunitBtn;}
            break;
        case 2:{
            _curCommType = Comm_service;
            btn = _serviceBtn;}
            break;

        default:
            break;
    }
    
 
    [self performSelectorOnMainThread:@selector(segChange:) withObject:btn waitUntilDone:NO];
}

#pragma mark -- scrollDelegate
- (void)bannerClick:(NSDictionary *)item{
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setTitleString:item[DATA_KEY_TITLE]];
    [detail setContentId:item[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
