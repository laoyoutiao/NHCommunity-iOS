//
//  ViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/20.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "MainPageViewCtr.h"
#import "MainPageBiz.h"
#import "UserCenterViewController.h"
#import "UIBarButtonItem+CTop.h"
#import "Util.h"
#import "BannerTableViewCell.h"
#import "ModuleTableViewCell.h"
#import "LawTableViewCell.h"
#import "NewsTableViewCell.h"
#import "ActiveViewController.h"
#import "ScrollBannerView.h"
#import "MessageViewController.h"
#import "LifeMarketController.h"
#import "CommunityViewController.h"
#import "QuestionViewController.h"
#import "LawListViewController.h"
#import "AutoScrollBannerView.h"
#import "BDL_WebDetailViewController.h"
#import "ActiveBiz.h"
#import "CommunityBiz.h"
#import "EditUserInfoViewController.h"

#import "MainTabBarViewController.h"

//#import "UINavigationController+HiddenNavBarAnimation.h"

@interface MainPageViewCtr ()<UITableViewDataSource,UITableViewDelegate,LawItemViewDelegate>
{
    UISearchBar *_searchBar;
    CommunityBiz *_biz;
    
    NSString *_pageRefreshSource;
    NSString *_pageLoadMoreSource;
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *activeDataSource;
@end

@implementation MainPageViewCtr

static NSString *firstIdentify = @"bannerCell";
static NSString *secondIdentify = @"moduleCell";
static NSString *lawIdentify = @"lawCell";
static NSString *newIdentify = @"newsCell";

- (void)showRight{
    MessageViewController *msg = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [self.navigationController pushViewController:msg animated:YES];
}

- (void)createNavSearchBar{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0.0f,SCREEN_WIDTH  - 44 - 10,44.0f)];
    _searchBar.delegate = self;
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar setTintColor:[UIColor whiteColor]];
    [_searchBar alwaysEnableSearch];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    
    // Change the search bar placeholder text color
//    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];


    
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768.f, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:_searchBar];
    self.navigationItem.titleView = searchView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.dataSource = [[NSMutableArray alloc] init];
    self.activeDataSource = [[NSMutableArray alloc] init];
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    _pageRefreshSource = dateStr;
    _pageLoadMoreSource = dateStr;

//    [self createNavSearchBar];
    
    self.title = @"南海职工之家";
    
    [self createLeftUserCenterBtn];
    
    [self preloadLeftCtr];
    
//     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"m_mail" highIcon:@"m_mail" target:self action:@selector(showRight) edgInset:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setBackgroundColor:TableViewBgColor];
    [_tableView registerNib:[UINib nibWithNibName:@"BannerTableViewCell" bundle:nil] forCellReuseIdentifier:firstIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"ModuleTableViewCell" bundle:nil] forCellReuseIdentifier:secondIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"LawTableViewCell" bundle:nil] forCellReuseIdentifier:lawIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:newIdentify];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    
    _tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    
    _biz = [[CommunityBiz alloc] init];

    [_tableView.mj_header beginRefreshing];
    
    if (![[GlobalUtil shareInstant] loginWithCus]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestActiveData];
        });
    }
    
    UISwipeGestureRecognizer *swap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft:)];
    [swap setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestActiveData{
    
    NSString *uname = [[[GlobalUtil shareInstant] loginInfo] objectForKey:U_NAME];
    NSDictionary *param = @{@"userName":uname,@"size":@(1),@"time":[Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL],@"type":@(1)};
    
    __weak __typeof(self)weakSelf = self;
    [[ActiveBiz bizInstant] requestActive:param
                                  success:^(NSDictionary *responseObj) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          NSArray *data = responseObj[DATA_KEY_DATA];
                                          if (![data isKindOfClass:[NSNull class]]) {
                                              if (data.count > 0) {
                                                  [weakSelf.activeDataSource removeAllObjects];
                                                  [weakSelf.activeDataSource addObjectsFromArray:data];
                                              }
                                          }
                                        [_tableView reloadData];
                                      });
                }
                   fail:^(NSString *errorMsg) {
//                       [_tableView.header endRefreshing];
                       [_tableView reloadData];
                   }];
}



- (void)updateRefreshTime:(NSString *)dateString{
    _pageRefreshSource = dateString;
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    _pageLoadMoreSource =dateString;
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
    
    NSDictionary *param = @{@"channel_id":@(111),@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
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
    
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         
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
                         
                         [_tableView.mj_header endRefreshing];
                         [_tableView reloadData];
                     }
                        fail:^(NSString *errorMsg) {
                            [_tableView.mj_header endRefreshing];
                        }];
}

- (void)loadMore{
    NSDictionary *param = [self getParmWithStatu:1];
    
    [_biz requestCommunitMsg:param
                     success:^(NSDictionary *responseObj) {
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             
                             id oldData = _dataSource;
                             if (oldData == [NSNull null]) {
                                 [_dataSource addObjectsFromArray:data];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }else{

                                 [_dataSource addObjectsFromArray:data];
                                 
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_RELEASE_DATE]];
                             }
                         }
                         
                         [_tableView.mj_footer endRefreshing];
                         [_tableView reloadData];
                     }
                        fail:^(NSString *errorMsg) {
                            [_tableView.mj_footer endRefreshing];
                        }];
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
    if (![[GlobalUtil shareInstant] loginWithCus]) {
        return  7 + _dataSource.count;
    }
    return  5 + _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (![[GlobalUtil shareInstant] loginWithCus]) {
        if (row == 0 || row == 2 || row == 4 || row == 6) {
            return 10;
        }else if(row == 1){
            return [BannerTableViewCell cellHeight];
        }else if(row == 3){
            return [ModuleTableViewCell cellHeight];
        }else if (row == 5){
            return [LawTableViewCell cellHeight];
        }else
            return [NewsTableViewCell cellHeight];

    }else{
        if (row == 0 || row == 2 || row == 4) {
            return 10;
        }else if(row == 1){
//            return [BannerTableViewCell cellHeight];
             return [ModuleTableViewCell cellHeight];
        }else if(row == 3){
//            return [ModuleTableViewCell cellHeight];
             return [LawTableViewCell cellHeight];
        }else{
            return [NewsTableViewCell cellHeight];
        
        }

    }

}

- (UITableViewCell *)cofingLogin:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if (row == 0 || row == 2 || row == 4 || row == 6) {
        static NSString *identify = @"normalIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }else if (row == 1){
        BannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstIdentify];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (_activeDataSource.count > 0) {
            NSDictionary *data = _activeDataSource[0];
            [cell.titleLabel setText:data[DATA_KEY_TITLE]];
            [cell.dateLabel setText:[NSString stringWithFormat:@"活动地点:%@" ,data[DATA_KEY_ADDRESS]]];
            [cell.tipsLabel setText:[NSString stringWithFormat:@"活动时间:%@",data[@"DATELINE"]]];
        }else{
            [cell.titleLabel setText:@"暂无数据"];
        }
        return cell;
    }
    else if(row == 3){
        ModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondIdentify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.marketBtn addTarget:self action:@selector(goMarket) forControlEvents:UIControlEventTouchUpInside];
        [cell.communiBtn addTarget:self action:@selector(goCommunity) forControlEvents:UIControlEventTouchUpInside];
        [cell.questionBtn addTarget:self action:@selector(goQuestion) forControlEvents:UIControlEventTouchUpInside];
        [cell.activeBtn addTarget:self action:@selector(goActive) forControlEvents:UIControlEventTouchUpInside];
        [cell.benifiBtn addTarget:self action:@selector(goLaw) forControlEvents:UIControlEventTouchUpInside];
        [cell.personInfoBtn addTarget:self action:@selector(goPersonInfo) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return cell;
        
    }else if (row == 5){
        LawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lawIdentify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        [cell refreshLawView];
        return cell;
    }else{
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newIdentify];
        if (_dataSource.count > 0) {
            NSDictionary *data = _dataSource[indexPath.row - 7];
            id imgUrl = data[@"TYPE_IMG"];
            if (![imgUrl isKindOfClass:[NSNull class]]) {
                if (![imgUrl stringIsNull]) {
                    //                [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:data[@"TYPE_IMG"] relativeToURL:RETIVE_URL] placeholderImage:BASE_IMAGE];
                    
                    if ([imgUrl stringStartwithHttp]) {
                        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                    }else{
                        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:imgUrl relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                    }
                }
            }
            
            [cell.ntitle setText:data[@"TITLE"]];
            id content = data[@"DESCRIPTION"];
            if (![content isKindOfClass:[NSNull class]]) {
                if (![content stringIsNull]) {
                    [cell.ndesc setText:content];
                }else
                    [cell.ndesc setText:@""];
            }else
                [cell.ndesc setText:@""];
        }
      
        
        return cell;
    }
}

- (UITableViewCell *)configCus:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    
    if (row == 0 || row == 2 || row == 4) {
        static NSString *identify = @"normalIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }else if(row == 1){
        ModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondIdentify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.marketBtn addTarget:self action:@selector(goMarket) forControlEvents:UIControlEventTouchUpInside];
        [cell.communiBtn addTarget:self action:@selector(goCommunity) forControlEvents:UIControlEventTouchUpInside];
        [cell.questionBtn addTarget:self action:@selector(goQuestion) forControlEvents:UIControlEventTouchUpInside];
        [cell.activeBtn addTarget:self action:@selector(goActive) forControlEvents:UIControlEventTouchUpInside];
        [cell.benifiBtn addTarget:self action:@selector(goLaw) forControlEvents:UIControlEventTouchUpInside];
        [cell.personInfoBtn addTarget:self action:@selector(goPersonInfo) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if(row == 3){
        LawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lawIdentify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        [cell refreshLawView];
        return cell;
    }else{
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newIdentify];
        if (_dataSource.count > 0) {
            NSDictionary *data = _dataSource[indexPath.row - 5];
            id imgUrl = data[@"TYPE_IMG"];
            if (![imgUrl isKindOfClass:[NSNull class]]) {
                if (![imgUrl stringIsNull]) {
                    //                [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:data[@"TYPE_IMG"] relativeToURL:RETIVE_URL] placeholderImage:BASE_IMAGE];
                    
                    if ([imgUrl stringStartwithHttp]) {
                        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                    }else{
                        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:imgUrl relativeToURL:RETIVE_URL] placeholderImage:[UIImage imageNamed:@"news_Logo"]];
                    }
                }
            }
            
            [cell.ntitle setText:data[@"TITLE"]];
            id content = data[@"DESCRIPTION"];
            if (![content isKindOfClass:[NSNull class]]) {
                if (![content stringIsNull]) {
                    [cell.ndesc setText:content];
                }else
                    [cell.ndesc setText:@""];
            }else
                [cell.ndesc setText:@""];
        }
        
        return cell;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![[GlobalUtil shareInstant] loginWithCus]) {
       return [self cofingLogin:tableView indexPath:indexPath];
    }else{
        return [self configCus:tableView indexPath:indexPath];
    }
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 1) {
        if (_activeDataSource.count == 0) {
            return;
        }
        NSDictionary *data = _activeDataSource[0];
        BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
        [detail setActive:YES];
        [detail setTitleString:data[DATA_KEY_TITLE]];
        [detail setContentId:data[@"ID"]];
        [self.navigationController pushViewController:detail animated:YES];

        return;
    }
    if ([[GlobalUtil shareInstant] loginWithCus]) {
        if ((row - 5) >= 0) {
            NSDictionary *data = _dataSource[row - 5];
            
            BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
            [detail setTitleString:data[@"TITLE"]];
            [detail setContentId:data[@"CONTENT_ID"]];
            [self.navigationController pushViewController:detail animated:YES];
            
        }
    }else{
        if ((row - 7) >= 0) {
            NSDictionary *data = _dataSource[row - 7];
            
            BDL_WebDetailViewController *detail = [[BDL_WebDetailViewController alloc] initWithNibName:@"BDL_WebDetailViewController" bundle:nil];
            [detail setTitleString:data[@"TITLE"]];
            [detail setContentId:data[@"CONTENT_ID"]];
            [self.navigationController pushViewController:detail animated:YES];
            
        }
    }
    
}


#pragma mark -- private 
- (void)goPersonInfo{
//    if ([[GlobalUtil shareInstant] loginWithCus]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if (![Util isLoginToDoOpereation]) {
        return;
    }
    EditUserInfoViewController *ed = [[EditUserInfoViewController alloc] init];
    [ed setFromMain:YES];
    [self.navigationController pushViewController:ed animated:YES];
}

- (void)goLaw{
//    LawListViewController *law = [[LawListViewController alloc] initWithNibName:@"LawListViewController" bundle:nil lawType:0];
//    [self.navigationController pushViewController:law animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"index"];
    MainTabBarViewController *comm = [[MainTabBarViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];

}
- (void)goActive{
//    if ([[GlobalUtil shareInstant] loginWithCus]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    ActiveViewController *active = [[ActiveViewController alloc] initWithNibName:@"ActiveViewController" bundle:nil];
//    [self.navigationController pushViewController:active animated:YES];
    
    if (![Util isLoginToDoOpereation]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(3) forKey:@"index"];
    MainTabBarViewController *comm = [[MainTabBarViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];
}

- (void)goMarket{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([LifeMarketController class]) bundle:nil];
//    UIViewController *vc = [storyboard instantiateInitialViewController];
//    [self.navigationController pushViewController:vc animated:YES];

            [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"index"];
    MainTabBarViewController *comm = [[MainTabBarViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];
}

- (void)goCommunity{
//    CommunityViewController *comm = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"index"];
    MainTabBarViewController *comm = [[MainTabBarViewController alloc] init];
//    [self.navigationController pushViewController:comm animated:YES];
    [self.navigationController pushViewController:comm animated:YES];
}

- (void)goQuestion{
//    QuestionViewController *q = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil title:@"综合咨询"];
//    [self.navigationController pushViewController:q animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(4) forKey:@"index"];
    MainTabBarViewController *comm = [[MainTabBarViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];
}



#pragma mark -- law item delegate
// *  0:法律法规 1：法律常识 2：法律文书 3：常见问题
- (void)lawItemClick:(NSInteger)lawType{
    LawListViewController *law = [[LawListViewController alloc] initWithNibName:@"LawListViewController" bundle:nil lawType:lawType];
    [self.navigationController pushViewController:law animated:YES];
}




@end
