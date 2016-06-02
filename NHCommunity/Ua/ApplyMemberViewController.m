//
//  ApplyMemberViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/28.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "ApplyMemberViewController.h"
#import "UserCenterViewController.h"
#import "AppDelegate.h"
#import "GlobalUtil.h"
#import "InfoOneInputTableViewCell.h"
#import "SVProgressHUD.h"
#import "AddressTableViewCell.h"
#import "ApplyMemberTableViewCell.h"
#import "SearchCompanyViewController.h"


static NSString *addressIdentifu = @"address";

@interface AuthInfoView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

}
@property (nonatomic, strong) NSDictionary *dataSource;


- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict;
@end

@implementation AuthInfoView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict{
    self = [super initWithFrame:frame];
    if (self ) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = dict;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:TableViewBgColor];
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView registerNib:[UINib nibWithNibName:@"InfoOneInputTableViewCell" bundle:nil] forCellReuseIdentifier:[InfoOneInputTableViewCell identify]];
        [_tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:addressIdentifu];
        [self addSubview: _tableView];

    }
    return self;
}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat inde = indexPath.row % 2;
    if (inde == 0) {
        return 10;
    }
    if (indexPath.row / 2 == 2) {
        if (_dataSource == nil) {
            return 44;
        }else if ([_dataSource[@"UNIONNAME"] isKindOfClass:[NSNull class]]){
            return 44;
        }else{
        CGFloat maxWidth = SCREEN_WIDTH - 66 - 5 - 10;
        CGSize textBlockMinSize = CGSizeMake(maxWidth, 1000);
        CGSize size = [_dataSource[@"UNIONNAME"] sizeWithFont:[UIFont systemFontOfSize:13.f]
                          constrainedToSize:textBlockMinSize
                              lineBreakMode:NSLineBreakByTruncatingTail];
            CGFloat height = size.height + 14 * 2;
            return height;
        }

    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowIdex = indexPath.row % 2;
    if (rowIdex == 0) {
        static NSString *identify = @"normalIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
            [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
        }
        return cell;
    }
    
     NSInteger row = indexPath.row / 2;
    if (row == 2) {
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifu];
        [cell.leftTitle setText:@"所属工会:"];
        [cell.rightValue setText:_dataSource[@"UNIONNAME"]];
        return cell;
    }else{
        InfoOneInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoOneInputTableViewCell identify]];
        [cell.valueInputTxf setEnabled:NO];
        [cell.valueInputTxf setTextColor:[UIColor grayColor]];
        
        if (row == 0) {
            [cell.leftTitleLabel setText:@"论坛用户名:"];
            [cell.valueInputTxf setText:[[[GlobalUtil shareInstant] userInfo] USERNAME]];
        }else if (row == 1){
            [cell.leftTitleLabel setText:@"真实姓名:"];
            [cell.valueInputTxf setText:_dataSource[@"NAME"]];
        }else if (row == 2){
          
        }else if (row == 3){
            [cell.leftTitleLabel setText:@"政治面貌:"];
            if (![_dataSource[@"POLITICS_STATUS"] isKindOfClass:[NSNull class]]) {
                [cell.valueInputTxf setText:_dataSource[@"POLITICS_STATUS"]];
            }else{
                [cell.valueInputTxf setText:@"暂无"];
            }
            
        }else if (row == 4){
            if (![_dataSource[@"EDUCATION"] isKindOfClass:[NSNull class]]) {
                [cell.valueInputTxf setText:_dataSource[@"EDUCATION"]];
            }else{
                [cell.valueInputTxf setText:@"暂无"];
            }
            [cell.leftTitleLabel setText:@"学历:"];
            
        }else if (row == 5){
            if (![_dataSource[@"TELEPHONE"] isKindOfClass:[NSNull class]]) {
                [cell.valueInputTxf setText:_dataSource[@"TELEPHONE"]];
            }else{
                [cell.valueInputTxf setText:@"暂无"];
            }
            [cell.leftTitleLabel setText:@"电话:"];
            
        }
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@interface KeyValueModel:NSObject

@property (nonatomic, copy) NSString *titleKey;
@property (nonatomic, copy) NSString *values;
@property (nonatomic, strong) NSDictionary *obj;
@end
@implementation KeyValueModel


@end

@interface ApplyMemberViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    NSArray *_sfArray;
    NSArray *_xlArray;
    NSMutableArray *_titles;
        UITextField *_curTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (assign, nonatomic) NSInteger reqCount;

@property (assign, nonatomic) BOOL isAuth;
@property (nonatomic, strong) AuthInfoView *infoView;

@end

@implementation ApplyMemberViewController


- (void)createLeftUserCenterBtn{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"m_user" highIcon:@"m_user" target:self action:@selector(showLeft:) edgInset:UIEdgeInsetsMake(0, -5, 0, 5)];
}

- (void)showLeft:(id)sender{
    UserCenterViewController *left = [[AppDelegate appDelegate] userCenterController];
    [self.revealSideViewController pushViewController:left onDirection:PPRevealSideDirectionLeft animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请正式会员";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *t = @[@"真实姓名",@"身份证号",@"所属企业",@"政治面貌",@"学历",@"电话"];
    _titles = [[NSMutableArray alloc] initWithCapacity:t.count];
    for (NSString *title in t) {
        KeyValueModel *model = [[KeyValueModel alloc] init];
        [model setTitleKey:title];
        [model setValues:@""];
        [_titles addObject:model];
    }
    
    
    _sfArray = @[@"党员",@"团员",@"群众",@"其他"];
    _xlArray = @[@"博士硕士",@"研究生",@"本科",@"高中",@"初中",@"小学",@"专科、专职",@"其他"];

    
    [self createLeftUserCenterBtn];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];


    
    [self.confirmBtn.layer setMasksToBounds:YES];
    [self.confirmBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    CGColorRef colorref = [Util getColorFromRed:254 Green:166 Blue:92 Alpha:1];
    
    [self.confirmBtn.layer setBorderColor:colorref];//边框颜色
    
    CGColorRelease(colorref);
    
    // 改变表的背景视图
    UIView *bv = [[UIView alloc] init];
    bv.backgroundColor = TableViewBgColor;
    self.tableView.backgroundView = bv;
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setHidden:YES];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyMemberTableViewCell" bundle:nil] forCellReuseIdentifier:[ApplyMemberTableViewCell indetify]];
    [self.tableView setScrollEnabled:NO];
    
    UISwipeGestureRecognizer *swap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft:)];
    [swap setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swap];
    
    [self checkAuth];
}



- (void)checkAuth{
    //ApproveService/checkauth.do
    
    
    __weak __typeof(self)weakSelf = self;
    
    NSString *userId = [[[GlobalUtil shareInstant] userInfo] USER_ID];
    if ([userId isKindOfClass:[NSNull class]]) {
        return;
    }else{
        NSString *uId = [NSString stringWithFormat:@"%@",userId];
        if ([uId isEqualToString:@"(null)"]) {
            return;
        }
        if (uId.length == 0 || uId == nil) {
            return;
        }
    }
    
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_CHECK_AUTH]
                                                 param:@{@"userid":userId}
                                               success:^(id responObject) {
                                                  
                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                       NSLog(@"-- %@",responObject);
                                                       NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
                                                       if (reRequest != nil) {
                                                           BOOL reFlag = reRequest.boolValue;
                                                           if (reFlag) {
                                                               [weakSelf checkAuth];
                                                           }
                                                       }else{
                                                            [SVProgressHUD dismiss];
                                                           NSDictionary *data = responObject[DATA_KEY_DATA];
                                                           if ([data isKindOfClass:[NSDictionary class]]) {
                                                               if (data.count > 0) {
                                                                   //已认证
                                                                   weakSelf.isAuth = YES;
                                                                   [weakSelf.tableView setHidden:NO];
                                                                   [weakSelf.infoView removeFromSuperview];
                                                                   weakSelf.infoView = [[AuthInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) withData:data];
                                                                   [self.view addSubview:weakSelf.infoView];
                                                                   
                                                                   
                                                                   return;
                                                               }
                                                           }
                                                           weakSelf.isAuth = NO;
                                                           [weakSelf.tableView setHidden:NO];
                                                           [_infoView removeFromSuperview];
                                                           
                                                       }
                                                   });
                                                   
        
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"认证失败"];
    }];

}

- (void)auth:(id)sender{
    
    NSString *useid = [NSString stringWithFormat:@"%@",[GlobalUtil shareInstant].userInfo.USER_ID];
    
    __block NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:useid forKey:@"memberid"];
    [_titles enumerateObjectsUsingBlock:^(KeyValueModel *obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"名字不能为空" ];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"userName"];
            }
        }else if (idx == 1){
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"身份证不能为空" ];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"idNo"];
            }
        }else if (idx == 2){
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择所属企业"];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"unionName"];
            }
        }else if (idx == 3){
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择政治面貌"];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"politicsStatus"];
            }
        }else if (idx == 4){
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择学历"];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"education"];
            }
        }else{
            if (obj.values.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"电话号码不能为空"];
                *stop = YES;
            }else{
                [param setObject:obj.values forKey:@"telephone"];
            }
        }
    }];

//    NSLog(@"parma = %@",param);
    if (param.count != 7) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    [[HttpManager shareInstant] httpPostRequestWithUrl:[NSString stringWithFormat:@"%@%@",ROOT_URL,URL_AUTH] param:param success:^(id responObject) {
//        NSLog(@"auth callbakc %@",responObject);
        NSNumber *reRequest = responObject[RE_REQUEST_FLAG];
        if (reRequest != nil) {
            BOOL reFlag = reRequest.boolValue;
            if (reFlag) {
                [weakSelf auth:nil];
            }
        }else{
            if ([responObject[@"code"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:responObject[@"msg"]];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakSelf checkAuth];
//                });
            }else{
                [SVProgressHUD showErrorWithStatus:responObject[@"msg"]];
            }
            
        }
    } fail:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"认证失败"];
    }];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _curTextField = textField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger row = textField.tag - 8000;
    if (textField.text.length > 0) {
        KeyValueModel *model = _titles[row];
        [model setValues:textField.text];
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setBackgroundColor:RGB(239, 129, 22, 1)];
    [btn setTitle:@"认证" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20,  44)];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(auth:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyMemberTableViewCell indetify] forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    KeyValueModel *model = _titles[row];
    [cell.inputTxt setDelegate:self];
    [cell.inputTxt setTag:8000 + row];
    if (row == 2|| row == 3 || row == 4) {
        [cell.rightBtn setHidden:NO];
        [cell.inputTxt setUserInteractionEnabled:NO];
    }else {
        [cell.rightBtn setHidden:YES];

        [cell.inputTxt setUserInteractionEnabled:YES];
    }
    [cell.inputTxt setPlaceholder:model.titleKey];
    if (model.values.length > 0) {
        [cell.inputTxt setText:model.values];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 2|| row == 3 || row == 4) {
        if (row == 2) {
            [_curTextField resignFirstResponder];
            
            SearchCompanyViewController *sarhc = [[SearchCompanyViewController alloc] initWithNibName:@"SearchCompanyViewController" bundle:nil];
            
            __weak __typeof(self)weakSelf = self;
            [sarhc setClickBlk:^(NSDictionary *dict){
                KeyValueModel *model = _titles[2];
                model.values = dict[@"TRADEUNION"];
                model.obj = dict;
                [weakSelf.tableView reloadData];
            }];
            [self.navigationController pushViewController:sarhc animated:YES];
            return;
        }else{
            UIActionSheet *sheet = [[UIActionSheet alloc] init];
            [sheet setTag:1000 + row];
            [sheet setDelegate:self];
            NSArray *data = (row == 3 ? _sfArray : _xlArray);
            for (NSString *str in data) {
                [sheet addButtonWithTitle:str];
            }
            [sheet addButtonWithTitle:@"取消"];
            [sheet setCancelButtonIndex:data.count];
            [sheet showInView:self.view];
            return;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger index = actionSheet.tag - 1000;
    if (index == 3) {
        if (buttonIndex != _sfArray.count) {
            NSString *value = _sfArray[buttonIndex];
            KeyValueModel *model = _titles[3];
            model.values = value;
            
            [self.tableView reloadData];
        }
    }else if (index == 4){
        if (buttonIndex != _xlArray.count) {
            NSString *value = _xlArray[buttonIndex];
            KeyValueModel *model = _titles[4];
            model.values = value;
            
            [self.tableView reloadData];
        }
    }
}
@end
