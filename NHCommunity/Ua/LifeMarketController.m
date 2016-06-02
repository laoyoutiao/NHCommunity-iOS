//
//  LifeMarketController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "LifeMarketController.h"
#import "LiftMarketCollectionViewCell.h"
#import "CommunityBiz.h"
#import "LiftMarketViewCell.h"
#import "CommunityNewsTableViewCell.h"
#import "BDL_WebDetailViewController.h"
@interface LifeMarketController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SearchResultDelegate>{
    CommunityBiz *_biz;
    
    NSString *_pageRefreshSource;
    NSString *_pageLoadMoreSource;
    
    UISearchBar *_searchBar;
    SearchByCategorViewCtr *_displayController;
    
}
@property (nonatomic, strong) NSMutableArray *dataMArr;
@end

@implementation LifeMarketController

 static NSString *collectionCellID = @"lifeCell";

- (void)createNavSearchBar{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0.0f,SCREEN_WIDTH  - 44 - 44,44.0f)];
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

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务超市";
    self.dataMArr = [[NSMutableArray alloc] init];
    [self createBackBtn];
//    [self createLeftUserCenterBtn];
//    [self createNavSearchBar];
//    [self setUpCollection];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView registerNib:[UINib nibWithNibName:@"CommunityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityNewsTableViewCell identify]];
    [_tableView setBackgroundColor:TableViewBgColor];

    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    _pageRefreshSource = dateStr;
    _pageLoadMoreSource = dateStr;
    
    _biz = [CommunityBiz bizInstant];
    
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
    }else{
        dateStr = _pageLoadMoreSource;
    }
    NSString *channleId = [NSString stringWithFormat:@"%@",@(446)];
    NSDictionary *param = @{@"channel_id":channleId,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{
    NSInteger statu = 0;
    if (_dataMArr.count == 0) {
        statu = 1;
    }
    NSDictionary *param = [self getParmWithStatu:statu];
    __weak __typeof(self)weakSelf = self;
//    NSLog(@"param = %@",param);
    [self showLoading];
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         [weakSelf hiddenLoading];
//                          NSLog(@"markte = %@",responseObj);
                         
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             
                             if (_dataMArr.count == 0) {
                                 [_dataMArr addObjectsFromArray:data];
                                 NSDictionary *first = data[0];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                                 
                             }else{
                                 __block NSMutableArray *finalData = [NSMutableArray arrayWithArray:data];
                                 [_dataMArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     [finalData addObject:obj];
                                 }];
                                 
                                 NSDictionary *first = finalData[0];
                                 NSDictionary *lastObj = finalData.lastObject;
                                 [self updateRefreshTime:first[DATA_KEY_RELEASE_DATE]];
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }

                         [_tableView.mj_header endRefreshing];
                         [_tableView reloadData];
                     }
                        fail:^(NSString *errorMsg) {

                            [_tableView.mj_header endRefreshing];
                            [weakSelf showErrorWithStatus:errorMsg];
                        }];
}

- (void)loadMore{
    NSDictionary *param = [self getParmWithStatu:1];
//    NSLog(@"param = %@",param);
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                                                  [weakSelf hiddenLoading];
//                         NSLog(@"markte = %@",responseObj);
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                            
                             if (_dataMArr.count == 0) {
                                 [_dataMArr addObjectsFromArray:data];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }else{
                                
                                 [_dataMArr addObjectsFromArray:data];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }

                         [_tableView.mj_footer endRefreshing];
                         [_tableView reloadData];
                     }
                        fail:^(NSString *errorMsg) {
                            [_tableView.mj_footer endRefreshing];
                            [weakSelf showErrorWithStatus:errorMsg];
                        }];
}

-(void)setUpCollection{
//    self.dataMArr = [[NSMutableArray alloc] init];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;

}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataMArr.count * 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row % 2;
    if (row == 0) {
        return 10;
    }
    return [CommunityNewsTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row % 2;
    if (row == 0) {
        static NSString *identify = @"normalIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
        }
        return cell;
    }
    
    CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommunityNewsTableViewCell identify]];
    [cell.rightImg setHidden:YES];
    
    
    NSInteger cellRow = indexPath.row / 2;
    NSDictionary *dict = _dataMArr[cellRow];
    [cell.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [cell.contentLabel setFont:[UIFont systemFontOfSize:11.f]];
    [cell.dateLabel setFont:[UIFont systemFontOfSize:11.f]];
    [cell.fromLabel setFont:[UIFont systemFontOfSize:11.f]];
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger cellRow = indexPath.row % 2;
    if (cellRow == 0) {
        return;
    }
    NSDictionary *data = _dataMArr[cellRow];
    
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setTitleString:data[DATA_KEY_TITLE]];
    [detail setContentId:data[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

//#pragma mark - Collection View Data Source
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return _dataMArr.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    LiftMarketCollectionViewCell *cell = (LiftMarketCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
//
//    NSInteger row = indexPath.row % 3;
//    NSLog(@"--- cell = ---- %d %d,%d",indexPath.row,indexPath.section,row);
//    NSDictionary *data = _dataMArr[row];
//
//    [cell.nameLabel setText:data[DATA_KEY_TITLE]];
//    return cell;
//};
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = (SCREEN_WIDTH - 45)/3;
//    return CGSizeMake(width, 103);
//}
//
////-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
////{
////    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右
////}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 15;
//}

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
    
    [_displayController setCateType:464];
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
