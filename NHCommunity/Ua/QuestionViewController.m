//
//  PostNewNotifiViewController.m
//  MobileFieldManager
//
//  Created by Arsenal on 15/8/26.
//  Copyright (c) 2015年 comtop. All rights reserved.
//

#import "QuestionViewController.h"
#import "QusetionBiz.h"
#import "QuestionTableViewCell.h"
#import "SubmitViewController.h"

typedef enum {
    Q_ASK = 0,
    Q_POR ,
    Q_HELP,
    Q_ONLINE
}Question_Type;

@interface QuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    QusetionBiz *_qBiz;
    
    Question_Type _curQType;
    NSMutableDictionary *_dataSource;
    NSMutableDictionary *_pageRefreshSource;
    NSMutableDictionary *_pageLoadMoreSource;
    
    UIScrollView *_contentScroll;
    NSMutableArray *_viewArray;
    NSInteger _lastPage;
}

@end

@implementation QuestionViewController

static NSString *identify = @"questionCell";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (title.length > 0) {
            self.title = title;
        }
    }
    return self;
}

- (void)gestureSwip:(UISwipeGestureRecognizer *)swip{
    
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_curQType == Q_ONLINE) {
            return;
        }
        switch (_curQType) {
            case Q_ASK:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_porBtn waitUntilDone:NO];
                break;
            case Q_POR:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_helpBtn waitUntilDone:NO];
                break;
            case Q_HELP:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_onlineBenifiBtn waitUntilDone:NO];
                break;

            default:
                break;
        }
    }else if (swip.direction == UISwipeGestureRecognizerDirectionRight){
        if (_curQType == Q_ASK) {
            return;
        }
        switch (_curQType) {
//            case Q_ONLINE:
//                [self performSelectorOnMainThread:@selector(segChange:) withObject:_porBtn waitUntilDone:NO];
//                break;
            case Q_POR:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_askOnlineBtn waitUntilDone:NO];
                break;
            case Q_HELP:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_porBtn waitUntilDone:NO];
                break;
            case Q_ONLINE:
                [self performSelectorOnMainThread:@selector(segChange:) withObject:_helpBtn waitUntilDone:NO];
                break;

            default:
                break;
        }
    }
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:@""];
}

- (void)createContentScroll{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 33 - 64)];
    [_contentScroll setShowsVerticalScrollIndicator:NO];
    [_contentScroll setShowsHorizontalScrollIndicator:NO];
    [_contentScroll setScrollEnabled:YES];
    [_contentScroll setPagingEnabled:YES];
    [_contentScroll setDelegate:self];
        [_contentScroll setBounces:NO];
    [_contentScroll setBackgroundColor:TableViewBgColor];
    [self.view addSubview:_contentScroll];
    
    _viewArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH * i, 0, SCREEN_WIDTH, CGRectGetHeight(_contentScroll.bounds)) style:UITableViewStylePlain];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setTableFooterView:[[UIView alloc] init]];
        
        [table setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.0)];
        
        [table registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
        
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
    
    [_contentScroll setContentSize:CGSizeMake(SCREEN_WIDTH * 4, 0)];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要咨询";
    
    [self createBackBtn];
    
//    [self createLeftUserCenterBtn];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发表留言" titleColor:[UIColor whiteColor] target:self action:@selector(send) edgInset:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    _curQType = Q_HELP;
    _dataSource = [[NSMutableDictionary alloc] init];
    _pageRefreshSource = [[NSMutableDictionary alloc] init];
    _pageLoadMoreSource = [[NSMutableDictionary alloc] init];
    
    
    [_dataSource setObject:[NSNull null] forKey:@(Q_ASK)];
    [_dataSource setObject:[NSNull null] forKey:@(Q_POR)];
    [_dataSource setObject:[NSNull null] forKey:@(Q_HELP)];
     [_dataSource setObject:[NSNull null] forKey:@(Q_ONLINE)];
    
    NSString *dateStr = [Util stringFromDate:[NSDate date] withFormat:DATE_FORMMAT_STYLE_NORMARL];
    [_pageRefreshSource setObject:dateStr forKey:@(Q_ASK)];
    [_pageRefreshSource setObject:dateStr forKey:@(Q_POR)];
    [_pageRefreshSource setObject:dateStr forKey:@(Q_HELP)];
    [_pageRefreshSource setObject:dateStr forKey:@(Q_ONLINE)];
    
    [_pageLoadMoreSource setObject:dateStr forKey:@(Q_ASK)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Q_POR)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Q_HELP)];
    [_pageLoadMoreSource setObject:dateStr forKey:@(Q_ONLINE)];
    
//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
//    [_tableView setBackgroundColor:TableViewBgColor];
//    [_tableView setTableFooterView:[[UIView alloc] init]];
//    [_tableView registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
    
//    __weak __typeof(self)weakSelf = self;
//    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf refresh];
//    }];
//    
//    [_tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf loadMore];
//    }];
//    
//    
//    _qBiz = [[QusetionBiz alloc] init];
//    [self segChange:_askOnlineBtn];
//    
//    
//    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwip:)];
//    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureSwip:)];
//    [right setDirection:UISwipeGestureRecognizerDirectionRight];
//    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:right];
//    [self.view addGestureRecognizer:left];
    
    [self createContentScroll];
    
    _qBiz = [[QusetionBiz alloc] init];
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:_askOnlineBtn waitUntilDone:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)send{
//    if ([[GlobalUtil shareInstant] loginWithCus]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该操作需要登录才可以进行，请先登录！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    
    if (![Util isLoginToDoOpereation]) {
        return;
    }
    SubmitViewController *sub = [[SubmitViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sub];
    [self presentViewController:nav animated:NO completion:NULL];
}


- (void)updateRefreshTime:(NSString *)dateString{
    [_pageRefreshSource setObject:dateString forKey:@(_curQType)];
}

- (void)updateLoadMoreTime:(NSString *)dateString{
    [_pageLoadMoreSource setObject:dateString forKey:@(_curQType)];
}


/**
 *  获取参数
 * 
 *  1在线咨询，2投诉与建议，3法律援助，23在线维权
 *
 *  @param stautu 0：刷新，1 加载更富哦
 *
 *  @return param
 */
- (NSDictionary *)getParmWithStatu:(NSInteger)stautu{
    NSString *dateStr = nil;
    if (stautu == 0) {
        dateStr = _pageRefreshSource[@(_curQType)];
    }else{
        dateStr = _pageLoadMoreSource[@(_curQType)];
    }
    
    NSInteger channle = 0;
    if (_curQType == Q_ASK) {
        channle = 1;
    }else if (_curQType == Q_POR){
        channle = 2;
    }else if (_curQType == Q_HELP){
        channle = 3;
    }else{
        channle = 23;
    }
    
    NSString *channleId = [NSString stringWithFormat:@"%@",@(channle)];
    NSDictionary *param = @{@"ctgId":channleId,@"size":@(10),@"time":dateStr,@"type":@(stautu)};
    
    return param;
}

- (void)refresh{
    NSInteger statu = 0;
    id data = _dataSource[@(_curQType)];
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
    
    
    NSInteger pageIndex = 0;
    if (_curQType == Q_ASK) {
        pageIndex = 0;
    }else if (_curQType == Q_POR){
        pageIndex = 1;
    }else if (_curQType == Q_HELP){
        pageIndex = 2;
    }else{
        pageIndex = 3;
    }
    
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    [_qBiz requestQuestionList:param
                     success:^(NSDictionary *responseObj) {
                         [weakSelf hiddenLoading];
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {
                             id value = _dataSource[@(_curQType)];
                             if (value == [NSNull null]) {
                                 [_dataSource setObject:data forKey:@(_curQType)];
                                 
                                 NSDictionary *first = data[0];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateRefreshTime:first[DATA_KEY_CREATE_TIME]];
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_CREATE_TIME]];
                                 
                             }else{
                                 __block NSMutableArray *finalData = [NSMutableArray arrayWithArray:data];
                                 [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     [finalData addObject:obj];
                                 }];
                                 
                                 NSDictionary *first = finalData[0];
                                 NSDictionary *lastObj = finalData.lastObject;
                                 [self updateRefreshTime:first[DATA_KEY_CREATE_TIME]];
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_CREATE_TIME]];
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
    NSDictionary *param = [self getParmWithStatu:1];
    
    NSInteger pageIndex = 0;
    if (_curQType == Q_ASK) {
        pageIndex = 0;
    }else if (_curQType == Q_POR){
        pageIndex = 1;
    }else if (_curQType == Q_HELP){
        pageIndex = 2;
    }else{
        pageIndex = 3;
    }

    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    [_qBiz requestQuestionList:param
                     success:^(NSDictionary *responseObj) {
                        [weakSelf hiddenLoading];
                         NSArray *data = responseObj[DATA_KEY_DATA];
                         if (data.count > 0) {

                             id oldData = _dataSource[@(_curQType)];
                             if (oldData == [NSNull null]) {
                                 [_dataSource setObject:data forKey:@(_curQType)];
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_CREATE_TIME]];
                             }else{
                                 NSMutableArray *allData = [NSMutableArray arrayWithArray:oldData];
                                 [allData addObjectsFromArray:data];
                                 [_dataSource setObject:allData forKey:@(_curQType)];
                                 
                                 NSDictionary *lastObj = data.lastObject;
                                 [self updateLoadMoreTime:lastObj[DATA_KEY_CREATE_TIME]];
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
    NSInteger tag = btn.tag - 1000;
    
    switch (tag) {
        case 0:
            _curQType = Q_ASK;
            break;
        case 1:
            _curQType = Q_POR;
            break;
        case 2:
            _curQType = Q_HELP;
            break;
        case 3:
            _curQType = Q_ONLINE;
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

    id data = _dataSource[@(_curQType)];
    UITableView *table = _viewArray[tag];
    [_contentScroll setContentOffset:CGPointMake(SCREEN_WIDTH * tag, 0) animated:NO];
    if (data == [NSNull null]) {
        [table.mj_header beginRefreshing];
    }else{
        [table reloadData];
    }
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
    id data = _dataSource[@(_curQType)];
    if (data == [NSNull null]) {
        return 0;
    }else
        return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//     QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//     [self configBaseNewsCell:cell indexPath:indexPath];
//    [cell setNeedsUpdateConstraints];
//    
//    [cell updateConstraintsIfNeeded];
//    
//     CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height;
    NSArray *data = _dataSource[@(_curQType)];
    if (data.count == 0) {
        return 70.f;
    }else{
        NSInteger row = indexPath.row;
        NSDictionary *dict = data[row];
        return [QuestionTableViewCell cellHeightWithData:dict];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    [self configBaseNewsCell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //choice user
    }
}

- (void)configBaseNewsCell:(QuestionTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSArray *data = _dataSource[@(_curQType)];
    NSInteger row = indexPath.row;
    NSDictionary *dict = data[row];
    [cell.peopleLabel setText:dict[DATA_KEY_TITLE]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"匿名网友于%@评论道:",dict[DATA_KEY_CREATE_TIME]]];
    [cell.questionLabel setText:dict[DATA_KEY_CONTENT]];
    
    id content = dict[DATA_KEY_REPLY];
    if (![content isKindOfClass:[NSNull class]]) {
        if ([content stringIsNull]) {
            [cell.answerLabel setText:@""];
        }else{
            [cell.answerLabel setText:content];
        }
    }else
        [cell.answerLabel setText:@""];
}



#pragma mark -- textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- textview delegate

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
            _curQType = Q_ASK;
            btn = _askOnlineBtn;}
            break;
        case 1:{
            _curQType = Q_POR;
            btn = _porBtn;
        }
            break;
        case 2:{
            btn = _helpBtn;

            _curQType = Q_HELP;}
            break;
        case 3:{
            btn = _onlineBenifiBtn;

            _curQType = Q_ONLINE;
        }
            break;
            
        default:
            break;
    }
    
    [self performSelectorOnMainThread:@selector(segChange:) withObject:btn waitUntilDone:NO];
}
@end
