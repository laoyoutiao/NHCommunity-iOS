//
//  LoveHomeViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/21.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "LoveHomeViewController.h"
#import "LoveBiz.h"
#import "CommunityNewsTableViewCell.h"
#import "BDL_WebDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WebDetailOnlyByLinkViewController.h"
#import "StaffIconModel.h"

#import "CommunityBaseInfoTableViewCell.h"

typedef enum {
    Love_Service = 462,
    Love_Active = 481,
    Love_Show = 94,
}LoveType;

@interface LoveHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableDictionary *_pageRefreshSource;
    NSMutableDictionary *_pageLoadMoreSource;
    UIScrollView *_contentScroll;
    NSInteger _lastPage;
    LoveBiz *_biz;
    LoveType _currentLoveType;
}

@property (nonatomic, strong)     NSMutableDictionary *dataSource;
@property (nonatomic, strong)     NSMutableArray *viewArray;
@end

@implementation LoveHomeViewController

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
    self.title = @"职工·家";
    [self  createLeftUserCenterBtn];
    
    _biz = [LoveBiz bizInstant];
    
    _currentLoveType = Love_Service;
    
    _dataSource = [[NSMutableDictionary alloc] init];
    _pageRefreshSource = [[NSMutableDictionary alloc] init];
    _pageLoadMoreSource = [[NSMutableDictionary alloc] init];
    
    [_dataSource setObject:[NSNull null] forKey:@(Love_Service)];
    [_dataSource setObject:[NSNull null] forKey:@(Love_Active)];
    [_dataSource setObject:[NSNull null] forKey:@(Love_Show)];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    [_pageRefreshSource setObject:dateStr forKey:@(Love_Service)];
    [_pageRefreshSource setObject:dateStr forKey:@(Love_Active)];
    [_pageRefreshSource setObject:dateStr forKey:@(Love_Show)];
    
    [_pageLoadMoreSource setObject:dateStr forKey:@(Love_Service)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Love_Active)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Love_Show)];
    
    
    [self createContentScroll];
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:_severicebtn waitUntilDone:NO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- refresh
- (void)updateRefreshTime:(NSString *)dateString{
    [_pageRefreshSource setObject:dateString forKey:@(_currentLoveType)];
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    [_pageLoadMoreSource setObject:dateString forKey:@(_currentLoveType)];
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
        dateStr = _pageRefreshSource[@(_currentLoveType)];
    }else
        dateStr = _pageLoadMoreSource[@(_currentLoveType)];
    
    NSString *channleId = [NSString stringWithFormat:@"%@",@(_currentLoveType)];
    NSDictionary *param = @{@"channel_id":channleId,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{
    
    //当前的pageIndex
    NSInteger pageIndex = 0;
    switch (_currentLoveType) {
        case Love_Service:{
            pageIndex = 0;
        }
            break;
        case Love_Active:{
            pageIndex = 1;
            
        }
            break;
        case Love_Show:{
            
            pageIndex = 2;
        }
            break;
            
        default:
            break;
    }
    
    
    NSInteger statu = 0;
    id data = _dataSource[@(_currentLoveType)];
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
    [_biz requestLoveMsg:param
                 success:^(NSDictionary *responseObj) {
                     [weakSelf hiddenLoading];
                     NSArray *data = responseObj[DATA_KEY_DATA];
                     if (data.count > 0) {
                         id value = weakSelf.dataSource[@(_currentLoveType)];
                         if (value == [NSNull null]) {
                             [weakSelf.dataSource setObject:data forKey:@(_currentLoveType)];
                             
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
    
    NSInteger pageIndex = 0;
    switch (_currentLoveType) {
        case Love_Service:{
            pageIndex = 0;
        }
            break;
        case Love_Active:{
            pageIndex = 1;
            
        }
            break;
        case Love_Show:{
            
            pageIndex = 2;
        }
            break;
            
        default:
            break;
    }
    
    [self showLoading];
    __weak __typeof(self)weakSelf = self;
    [_biz requestLoveMsg:param
                 success:^(NSDictionary *responseObj) {
                     NSArray *data = responseObj[DATA_KEY_DATA];
                     [weakSelf hiddenLoading];
                     if (data.count > 0) {
                         id oldData = weakSelf.dataSource[@(_currentLoveType)];
                         if (oldData == [NSNull null]) {
                             [weakSelf.dataSource setObject:data forKey:@(_currentLoveType)];
                             NSDictionary *lastObj = data.lastObject;
                             [weakSelf updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                         }else{
                             NSMutableArray *allData = [NSMutableArray arrayWithArray:oldData];
                             [allData addObjectsFromArray:data];
                             [weakSelf.dataSource setObject:allData forKey:@(_currentLoveType)];
                             
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
    
    NSInteger index =0;
    switch (tag) {
        case 462:{
            index = 0;
            _currentLoveType = Love_Service;}
            break;
        case 481:{
            index = 1;
            _currentLoveType = Love_Active;
        }
            break;
        case 94:{
            _currentLoveType = Love_Show;
            index = 2;
        }
            break;
            
        default:
            break;
    }
    
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
    
    id data = _dataSource[@(_currentLoveType)];
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
    
    id data = _dataSource[@(_currentLoveType)];
    if (data == [NSNull null]) {
        return 1;
    }else{
        NSInteger toatalCount = [(NSArray*)data count];
        return toatalCount * 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inde = indexPath.row % 2;
    if (inde == 0) {
        return 10;
    }
    return [CommunityNewsTableViewCell cellHeight];
    
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
    }else{
        
        NSArray *data = _dataSource[@(_currentLoveType)];
        NSInteger row = (indexPath.row) / 2;
        NSDictionary *dict = data[row];
        
        
        NSString *url = dict[DATA_KEY_TYPE_IMG];
        if ([Util stringIsNull:url]) {
            CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommunityBaseInfoTableViewCell identify]];
            
            [self configNoImageCell:cell indexPath:indexPath];
            
            return cell;
        }else{
            CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommunityNewsTableViewCell identify]];
            
            [self configHadImageCell:cell indexPath:indexPath];

            return cell;
        }
    }
}

- (void)configHadImageCell:(CommunityNewsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSArray *data = _dataSource[@(_currentLoveType)];
    NSInteger row = (indexPath.row) / 2;
    NSDictionary *dict = data[row];
    
    NSString *url = dict[DATA_KEY_TYPE_IMG];

    [cell.titleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.dateLabel setText:dict[DATA_KEY_RELEASE_DATE]];
    id content = dict[DATA_KEY_DESCRIPTION];
    
    if ([Util stringIsNull:content]) {
        [cell.contentLabel setText:@""];
    }else{
        [cell.contentLabel setText:content];
    }
    
    if ([url stringStartwithHttp]) {
        [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
    }else{
        [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
    }
}

- (void)configNoImageCell:(CommunityBaseInfoTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSArray *data = _dataSource[@(_currentLoveType)];
    NSInteger row = (indexPath.row) / 2;
    NSDictionary *dict = data[row];
    
    [cell.titleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.dateLabel setText:dict[DATA_KEY_RELEASE_DATE]];
    id content = dict[DATA_KEY_DESCRIPTION];
    
    if ([Util stringIsNull:content]) {
        [cell.contentLabel setText:@""];
    }else{
        [cell.contentLabel setText:content];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = (indexPath.row) / 2;
    
    
    NSArray *data = _dataSource[@(_currentLoveType)];
    NSDictionary *dict = data[row];
    
    if (_currentLoveType == Love_Service) {
        WebDetailOnlyByLinkViewController *web = [[WebDetailOnlyByLinkViewController alloc] init];
        StaffIconModel *model = [[StaffIconModel alloc] init];
        [model setTitle:@"职工·家服务中心"];
        NSString *url = [NSString stringWithFormat:@"http://staffhome.nanhai.gov.cn/zgjfwzx/%@.jhtml",dict[DATA_KEY_CONTENT_ID]];
        [model setUrl:url];
        [web setModel:model];
        
        [web setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:web animated:YES];
        
    }else{
        
        BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
        if (_currentLoveType == Love_Active) {
            [detail setTitleString:@"活动信息"];
        }else{
            [detail setTitleString:@"活动展示"];
        }

        [detail setContentId:dict[DATA_KEY_CONTENT_ID]];
        [detail setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark -- scrollview delegate

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
            _currentLoveType = Love_Service;
            btn = _severicebtn;
        }
            break;
        case 1:{
            _currentLoveType = Love_Active;
            btn = _activeBtn;}
            break;
        case 2:{
            _currentLoveType = Love_Show;
            btn = _showBtn;
        }
            break;
            
        default:
            break;
    }
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:btn waitUntilDone:NO];
}
@end
