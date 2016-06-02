//
//  LaoDongBHViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/20.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "LaoDongBHViewController.h"
#import "LaodongBiz.h"
#import "CommunityNewsTableViewCell.h"
#import "BDL_WebDetailViewController.h"
#import "CommunityBaseInfoTableViewCell.h"

@interface LaoDongBHViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *_pageRefreshSource;
    NSString *_pageLoadMoreSource;
    
    LaodongBiz *_biz;
}
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMArr;

@end

@implementation LaoDongBHViewController


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"劳动保护";
    self.dataMArr = [[NSMutableArray alloc] init];
    [self createBackBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:@"CommunityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityNewsTableViewCell identify]];
    [_tableView registerNib:[UINib nibWithNibName:@"CommunityBaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:[CommunityBaseInfoTableViewCell identify]];
    [_tableView setBackgroundColor:TableViewBgColor];
    [self.view addSubview:_tableView];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    _pageRefreshSource = dateStr;
    _pageLoadMoreSource = dateStr;
    
    _biz = [LaodongBiz bizInstant];
    
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
    
}

#pragma mark -- refresh

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
    NSString *channleId = [NSString stringWithFormat:@"%@",@(469)];
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
    [_biz requesLDBH:param
              success:^(NSDictionary *responseObj) {
                  [weakSelf hiddenLoading];
//                  NSLog(@"went = %@",responseObj);
                  
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
    [_biz requesLDBH:param
              success:^(NSDictionary *responseObj) {
                  [weakSelf hiddenLoading];
//                  NSLog(@"went = %@",responseObj);
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
    
    NSInteger cellRow = indexPath.row / 2;
    NSDictionary *dict = _dataMArr[cellRow];
    NSString *url = dict[DATA_KEY_TYPE_IMG];
    if ([Util stringIsNull:url]) {
        return [CommunityBaseInfoTableViewCell cellHeight];
    }else{
        return [CommunityNewsTableViewCell cellHeight];
    }
    
    
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
    
    
    NSInteger cellRow = indexPath.row / 2;
    NSDictionary *dict = _dataMArr[cellRow];
    NSString *url = dict[DATA_KEY_TYPE_IMG];
    
    if ([Util stringIsNull:url]) {
        CommunityBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommunityBaseInfoTableViewCell identify] forIndexPath:indexPath];
        [cell.titleLabel setText:dict[DATA_KEY_TITLE]];
        [cell.dateLabel setText:dict[DATA_KEY_RELEASE_DATE]];
        NSString *content = dict[DATA_KEY_DESCRIPTION];
        if (![content isKindOfClass:[NSNull class]]) {
            if ([content stringIsNull]) {
                [cell.contentLabel setText:@""];
            }else{
                [cell.contentLabel setText:content];
            }
        }else{
            [cell.contentLabel setText:@""];
        }

        
        return cell;
    }else{
        CommunityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommunityNewsTableViewCell identify]];
        [cell.rightImg setHidden:YES];
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
        }else{
            [cell.contentLabel setText:@""];
        }
        
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger cellRow = indexPath.row % 2;
    if (cellRow == 0) {
        return;
    }
    NSInteger row = indexPath.row / 2;
    NSDictionary *data = _dataMArr[row];
    
    BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
    [detail setTitleString:data[DATA_KEY_TITLE]];
    [detail setContentId:data[DATA_KEY_CONTENT_ID]];
    [detail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detail animated:YES];
}
@end