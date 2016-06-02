//
//  SearchByCategorViewCtr.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/17.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "SearchByCategorViewCtr.h"
#import "SearchBiz.h"

#import "NewsTableViewCell.h"
#import "CommunityBaseInfoTableViewCell.h"
#import "CommunityNewsTableViewCell.h"
#import "ActiveTableViewCell.h"
#import "BDL_WebDetailViewController.h"

@interface SearchByCategorViewCtr ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    SearchBiz *_searchBiz;
    
    NSString *_pageRefreshSource;
    NSString *_pageLoadMoreSource;
    
    
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *keyWord;
@end

@implementation SearchByCategorViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - 64;
    [self.view setFrame:frame];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    [view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [self.view addSubview:view];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview: _tableView];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setHidden:YES];
    
    [self resetDateAfterCatechange];
    
    _searchBiz = [[SearchBiz alloc] init];

}

- (void)resetDateAfterCatechange{
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    _pageRefreshSource = dateStr;
    _pageLoadMoreSource = dateStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    NSDictionary *param = @{@"channel_id":@(_cateType),@"size":@(10),@"time":dateStr,@"type":@(stautu),@"title":_keyWord};
    
    return param;
}

- (void)searchWithKeyWord:(NSString *)keyword{
    
    [SVProgressHUD showWithStatus:@"正在搜索..." maskType:SVProgressHUDMaskTypeBlack];
    [_dataSource removeAllObjects];
    self.keyWord = keyword;
    NSDictionary *param = [self getParmWithStatu:1];
    NSLog(@"search param = %@",param);
    [_searchBiz searchData:param
                   success:^(NSDictionary *responseObj) {
                       [SVProgressHUD dismiss];
                       NSArray *data = responseObj[DATA_KEY_DATA];
                       if (data.count > 0) {
                           id value = _dataSource;
                           if ([value count] == 0) {
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
                       
                       if (data.count == 0) {
                           [SVProgressHUD showSuccessWithStatus:@"没有找到搜索内容"];
                       }
                       
                       [_tableView setHidden:NO];
                       [_tableView.mj_header endRefreshing];
                       [_tableView reloadData];
                       
                       
    } fail:^(NSString *errorMsg) {
        
        [_tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
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
//    if (_cateType == 111) {
//        [CommunityNewsTableViewCell cellHeight];
//    }else if (_cateType == 110 ||  _cateType == 113) {
//        return [CommunityBaseInfoTableViewCell cellHeight];
//    }else if (_cateType == 462 || _cateType == 465 || _cateType == 461 || _cateType == 92){
//        return [CommunityBaseInfoTableViewCell cellHeight];
//    }else if (_cateType == 464){
//        //market
//        
//    }else if (_cateType == Acitve_Search_Tag){
//        return [ActiveTableViewCell cellHeight];
//    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_cateType == 111) {
//        static NSString *identify = @"cmmCell";
//        CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommunityNewsTableViewCell" owner:nil options:nil] lastObject];
//        }
//        [self configNewsCell:cell indexPath:indexPath];
//        return cell;
//        
//    }else if (_cateType == 110 ||  _cateType == 113) {
//        static NSString *identify = @"cmmBaseCell";
//        CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommunityBaseInfoTableViewCell" owner:nil options:nil] lastObject];
//        }
//        [self configBaseNewsCell:cell indexPath:indexPath];
//        return cell;
//        
//    }else if (_cateType == 462 || _cateType == 465 || _cateType == 461 || _cateType == 92){
//
//        static NSString *identify = @"cmmBaseCell";
//        CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommunityBaseInfoTableViewCell" owner:nil options:nil] lastObject];
//        }
//        [self configLawCell:cell indexPath:indexPath];
//        return cell;
//    }else if (_cateType == 464){
//        //market
//        
//    }else if (_cateType == Acitve_Search_Tag){
//        //active
//        static NSString *identity = @"activeCell";
//        ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
//        [self configActiveCell:cell indexPath:indexPath];
//        return cell;
//    }
    

    static NSString *identify = @"normalIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
//        [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 30, 44)];
        [label setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:label];
        [label setFont:[UIFont systemFontOfSize:15.f]];
        [label setTag:10001];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10001];
    NSDictionary *data = _dataSource[indexPath.row];
    NSString *title = data[DATA_KEY_TITLE];
    [label setText:title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = _dataSource[indexPath.row];
    
//    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
//    [detail setTitleString:data[DATA_KEY_TITLE]];
//    [detail setContentId:data[DATA_KEY_CONTENT_ID]];
//    [self.navigationController pushViewController:detail animated:YES];
    
    if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(searchResultClickWithData:)]) {
        [_searchDelegate searchResultClickWithData:data];
    }
    
    
}

#pragma mark -- config
- (void)configActiveCell:(ActiveTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSDictionary *dict = _dataSource[row];
    [cell.headTitleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.orgLabel setText:[NSString stringWithFormat:@"主办单位:%@",dict[DATA_KEY_CHARGER]]];
    [cell.siteLabel setText:[NSString stringWithFormat:@"活动地点:%@",dict[DATA_KEY_ADDRESS]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"活动时间:%@",dict[DATA_KEY_DATELINE]]];
}

- (void)configLawCell:(CommunityBaseInfoTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSDictionary *dict = _dataSource[row];
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



- (void)configNewsCell:(CommunityNewsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSDictionary *dict = _dataSource[row];
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
            
//            [cell.leftImag sd_setImageWithURL:[NSURL URLWithString:url relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
        }
    }
}

- (void)configBaseNewsCell:(CommunityBaseInfoTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    NSDictionary *dict = _dataSource[row];
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


#pragma mark -- set
- (void)setCateType:(NSInteger)cateType{
    _cateType = cateType;
    [self resetDateAfterCatechange];
}
@end
