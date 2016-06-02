//
//  SubmitViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/9.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "SubmitViewController.h"
#import "SubTitleTableViewCell.h"
#import "SubTxFInputTableViewCell.h"
#import "SubTxTInputTableViewCell.h"
#import "ButtonTableViewCell.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "SubmitBiz.h"



typedef enum {
    INP_TITLE = 0,
    INP_BUTTON = 1,
    INP_TXF = 2,
    INP_TXT = 3
}INPUT_TYPE;

@interface DataModel : NSObject

@property (nonatomic, copy) NSString *placeshold;
@property (nonatomic, assign) INPUT_TYPE type;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *selector;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger tag;
@end

@implementation DataModel



@end

@interface SubmitViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSArray *_titleDataSource;
  
    
    
    NSInteger _curTitleIndex;
    SubmitBiz *_subBiz;
    
    UIView *_navBarView;
    UITextField *_curTxfild;
    UITextView *_curTxView;
}
@property (nonatomic, strong) NSMutableArray *askDataSource;
@property (nonatomic, strong) NSMutableArray *portDataSource;
@property (nonatomic, strong) NSMutableArray *helpDataSource;
@property (nonatomic, strong) NSMutableArray *onlineDataSource;
@end

@implementation SubmitViewController

static NSString *titleIdentify = @"titleCell";
static NSString *txFIdentify = @"txfCell";
static NSString *txTIdentify = @"txtCell";
static NSString *btnIdentify = @"btnCell";

static NSInteger firstTag = 1000;
static NSInteger secondTag = 2000;
static NSInteger thirdTag = 3000;
static NSInteger fourTag = 4000;

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)canOpen{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [sheet addButtonWithTitle:@"不允许公开"];
    [sheet addButtonWithTitle:@"允许公开"];
    [sheet addButtonWithTitle:@"取消"];
    [sheet setCancelButtonIndex:2];
    [sheet setTag:1000001];
    [sheet showInView:self.view];
}

- (void)submit{
    [self.view endEditing:YES];
    [_tableView endEditing:YES];
    if (!_subBiz) {
        _subBiz = [[SubmitBiz alloc] init];
    }

    NSMutableArray *data = nil;
    NSInteger baseTag = 0;
    if (_curType == REQ_ASK) {
        baseTag = 1;
        data = _askDataSource;
    }else if (_curType == REQ_PORT){
        baseTag = 2;
        data = _portDataSource;
    }else if (_curType == REQ_HELP){
        baseTag = 3;
        data = _helpDataSource;
    }else{
        baseTag = 23;
        data = _onlineDataSource;
    }
    
    
    __block NSString *errrorMSg = nil;
    __block NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:0];
    [reqData setObject:@(baseTag) forKey:@"ctgId"];
    [data enumerateObjectsUsingBlock:^(DataModel *obj, NSUInteger idx, BOOL *stop) {
        if (obj.type == INP_TXF || obj.type == INP_TXT) {
            if (obj.value == nil || obj.value.length == 0) {
                errrorMSg = @"请完善好资料，再发表留言";
                *stop = YES;
                return;
            }
        }
        
        if (_curType == REQ_ASK || _curType == REQ_PORT) {
            if (idx == 0) {
                [reqData setObject:obj.value forKey:@"title"];
            }else if (idx == 1){
                [reqData setObject:obj.value forKey:@"email"];
                if (obj.value.length > 0) {
                    if (![Util regularWithString:obj.value withRex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]) {
                        errrorMSg = @"邮箱格式不正确";
                    }
                }

            }else if (idx == 2){
                [reqData setObject:obj.value forKey:@"phone"];
                if (obj.value.length > 0) {
                    if (![Util regularWithString:obj.value withRex:@"^\\d{11}$"]) {
                        errrorMSg = @"手机号码格式不正确";
                    }
                }
            }else if (idx == 3){
                [reqData setObject:obj.value forKey:@"qq"];
            }
//            else if (idx == 4){
//                if ([obj.value isEqualToString:@"允许公开"]) {
//                    [reqData setObject:@"1" forKey:@"isPub"];
//                }else{
//                    [reqData setObject:@"0" forKey:@"isPub"];
//                }
//            }
            else if (idx == 5){
                [reqData setObject:obj.value forKey:@"content"];
            }
        }
        
        if ([obj.value isEqualToString:@"允许公开"]) {
            [reqData setObject:@"1" forKey:@"isPub"];
        }else{
            [reqData setObject:@"0" forKey:@"isPub"];
        }
        
        if (_curType == REQ_HELP) {
            if (idx == 0) {
                [reqData setObject:obj.value forKey:@"title"];
            }else if (idx == 1){
                [reqData setObject:obj.value forKey:@"email"];
                if (obj.value.length > 0) {
                    if (![Util regularWithString:obj.value withRex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]) {
                        errrorMSg = @"邮箱格式不正确";
                    }
                }
            }else if (idx == 2){
                [reqData setObject:obj.value forKey:@"phone"];
                if (obj.value.length > 0) {
                    if (![Util regularWithString:obj.value withRex:@"^\\d{11}$"]) {
                        errrorMSg = @"手机号码格式不正确";
                    }
                }

            }else if (idx == 3){
                [reqData setObject:obj.value forKey:@"qq"];
            } else if (idx == 4){
                [reqData setObject:obj.value forKey:@"content"];
            }
        }
        
        if (_curType == REQ_ONLINE) {
            if (idx == 0) {
                [reqData setObject:obj.value forKey:@"title"];
            }else if (idx == 1){
                [reqData setObject:obj.value forKey:@"content"];
            }
        }
    }];
    
    if (errrorMSg != nil) {
        [self showErrorWithStatus:errrorMSg];
        return;
    }
    
    [self showLoading];
    __weak __typeof(self)weakSelf = self;
    [_subBiz submitData:reqData
                success:^(NSDictionary *responseObj) {
                    [weakSelf showSuccessWithStatus:responseObj[DATA_KEY_MSG]];
                    [weakSelf.askDataSource removeAllObjects];
                    [weakSelf.portDataSource removeAllObjects];
                    [weakSelf.helpDataSource removeAllObjects];
                    [weakSelf.onlineDataSource removeAllObjects];
                    
                    [weakSelf genDataSource];
                    
                    [_tableView reloadData];
                }
                   fail:^(NSString *errorMsg) {
                       [weakSelf showErrorWithStatus:errorMsg];
    }];
}

- (void)createNavbar{
    
    _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0,20,SCREEN_WIDTH,44)];
    [_navBarView setBackgroundColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.view addSubview:_navBarView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"navigation_back_btn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigation_back_btn_press"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(10, 0, 64, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_navBarView addSubview:button];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"综合咨询";
    [self createBackBtn];
    
//    [self createNavbar];
    
    _curTitleIndex = (NSInteger)_curType;

    _askDataSource= [[NSMutableArray alloc] init];;
    _portDataSource= [[NSMutableArray alloc] init];;
    _helpDataSource= [[NSMutableArray alloc] init];;
    _onlineDataSource= [[NSMutableArray alloc] init];

    _titleDataSource = @[@"在线咨询",@"投诉建议",@"法律援助",@"在线维权"];
    
    [self genDataSource];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setBackgroundColor:TableViewBgColor];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:@"SubTitleTableViewCell" bundle:nil] forCellReuseIdentifier:titleIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"SubTxFInputTableViewCell" bundle:nil] forCellReuseIdentifier:txFIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"SubTxTInputTableViewCell" bundle:nil] forCellReuseIdentifier:txTIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"ButtonTableViewCell" bundle:nil] forCellReuseIdentifier:btnIdentify];
    [self.view addSubview: _tableView];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)genDataSource{
    NSArray *t1 = @[@"标题",@"邮件",@"联系电话",@"QQ",@"允许公开",@"请输入你所需要咨询的事项"];
    [t1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DataModel *m = [[DataModel alloc] init];
        if (idx == 4) {
            [m setType:INP_TITLE];
            [m setHeight:44.f];
            m.value = obj;
            [m setSelector:@"canOpen"];
        }else if (idx == 5){
            [m setType:INP_TXT];
            [m setHeight:88.f];
        }else{
            [m setType:INP_TXF];
            [m setHeight:44.f];
        }
        [m setPlaceshold:obj];
        m.tag = firstTag + idx;
        [_askDataSource addObject:m];
    }];
    
    [t1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DataModel *m = [[DataModel alloc] init];
        if (idx == 4) {
            [m setType:INP_TITLE];
            [m setHeight:44.f];
            m.value = obj;
            [m setSelector:@"canOpen"];
        }else if (idx == 5){
            [m setType:INP_TXT];
            [m setHeight:88.f];
        }else{
            [m setType:INP_TXF];
            [m setHeight:44.f];
        }
        [m setPlaceshold:obj];
        m.tag = secondTag + idx;
        [_portDataSource addObject:m];
    }];
    
    
    
    NSArray *t3 = @[@"标题",@"邮件",@"联系电话",@"QQ",@"请输入你所需要咨询的事项"];
    
    
    [t3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DataModel *m = [[DataModel alloc] init];
        if (idx == 4){
            [m setType:INP_TXT];
            [m setHeight:88.f];
        }else{
            [m setType:INP_TXF];
            [m setHeight:44.f];
        }
        [m setPlaceshold:obj];
        m.tag = thirdTag + idx;
        [_helpDataSource addObject:m];
    }];
    
    
    NSArray *t4 = @[@"标题",@"请输入你所需要咨询的事项"];
    [t4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DataModel *m = [[DataModel alloc] init];
        if (idx == 0) {
            [m setType:INP_TXF];
            [m setHeight:44.f];
        }else if (idx == 1){
            [m setType:INP_TXT];
            [m setHeight:88.f];
        }
        [m setPlaceshold:obj];
        m.tag = fourTag + idx;
        [_onlineDataSource addObject:m];
    }];
    
    DataModel *m = [[DataModel alloc] init];
    [m setType:INP_BUTTON];
    [m setHeight:44.f];
    [m setSelector:@"submit"];
    [m setPlaceshold:@"提交"];
    
    [_askDataSource addObject:m];
    [_portDataSource addObject:m];
    [_helpDataSource addObject:m];
    [_onlineDataSource addObject:m];
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
    if (_curType == REQ_ASK) {
        return _askDataSource.count * 2  + 2;
    }else if (_curType == REQ_PORT){
        return _portDataSource.count * 2 + 2;
    }else if (_curType == REQ_HELP){
        return _helpDataSource.count * 2 + 2;
    }else
        return _onlineDataSource.count * 2 + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row / 2;
    NSInteger indx = indexPath.row % 2;
    if (indx == 0) {
        return 10;
    }
    
    if (_curType == REQ_ASK) {
        if (row == 0) {
            return 44;
        }
        DataModel *model = _askDataSource[row - 1];
        return model.height;
    }else if (_curType == REQ_PORT){
        if (row == 0) {
            return 44;
        }
        DataModel *model = _portDataSource[row - 1];
        return model.height;

    }else if (_curType == REQ_HELP){
        if (row == 0) {
            return 44;
        }
        DataModel *model = _helpDataSource[row - 1];
        return model.height;

    }else if(_curType == REQ_ONLINE){
        if (row == 0) {
            return 44;
        }
        DataModel *model = _onlineDataSource[row - 1];
        return model.height;
    }

    return 44;
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
    
    NSInteger row = indexPath.row / 2;
    if (row == 0) {
        SubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleIdentify];
        NSString *data = _titleDataSource[_curTitleIndex];
        [cell.leftLabel setText:data];
        [cell.leftLabel setTextColor:[UIColor blackColor]];
        [cell.rightImg setHidden:YES];
        return cell;
    }
    
    NSArray *data = nil;
    if (_curType == REQ_ASK) {
        data = _askDataSource;
    }else if (_curType == REQ_PORT){
        data = _portDataSource;
    }else if (_curType == REQ_HELP){
        data = _helpDataSource;
    }else
        data = _onlineDataSource;
    
    DataModel *model = data[row - 1];
    if (model.type == INP_BUTTON) {
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnIdentify];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.submitBtn addTarget:self action:NSSelectorFromString(model.selector) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (model.type == INP_TXF){
        SubTxFInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:txFIdentify];
        [cell.inputTxF setPlaceholder:model.placeshold];
        [cell.inputTxF setDelegate:self];
        [cell.inputTxF setTag:model.tag];
        if (model.value != nil) {
            [cell.inputTxF setText:model.value];
        }else{
            [cell.inputTxF setText:@""];
        }
        return cell;
    }else if (model.type == INP_TITLE){
        SubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleIdentify];
        [cell.leftLabel setText:model.placeshold];
        [cell.rightImg setHidden:YES];
        return cell;

    }
    else{
        SubTxTInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:txTIdentify];
//        [cell.txtView setPlaceholder:model.placeshold];
        [cell.txtView setDelegate:self];
        [cell.txtView setTag:model.tag];
        

            [cell.txtView setText:model.value];


        return cell;
    }
        
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row / 2;
    [_curTxView resignFirstResponder];
    [_curTxfild resignFirstResponder];
    if (row == 0) {
//        __block UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
//        [_titleDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [sheet addButtonWithTitle:_titleDataSource[idx]];
//        }];
//        
//        [sheet addButtonWithTitle:@"取消"];
//        [sheet setCancelButtonIndex:_titleDataSource.count];
//        
//        [sheet showInView:self.view];
    }else if (_curType == REQ_ASK || _curType == REQ_PORT){
        NSArray *data = (_curType == REQ_ASK ? _askDataSource : _portDataSource);
        DataModel *m = data[row - 1];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (m.selector != nil) {
            [self performSelector:NSSelectorFromString(m.selector) withObject:nil];
        }
#pragma clang diagnostic pop

    }
    
}

#pragma mark -- action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000001) {
        if (buttonIndex == 2) {
            return;
        }
        DataModel *m = nil;
        if (_curType == REQ_ASK) {
            m = _askDataSource[4];
        }
        if (_curType == REQ_PORT) {
            m = _portDataSource[4];
        }
        if (buttonIndex == 0) {
            m.placeshold = @"不允许公开";
            m.value = @"不允许公开";
        }else if(buttonIndex == 1){
            m.placeshold = @"允许公开";
            m.value = @"允许公开";
        }
        
        if (m.type == INP_TXT) {
            m.value = @"";
        }
        [_tableView reloadData];
        return;
    }
        if (buttonIndex == 4) {
            return;
        }
        _curTitleIndex = buttonIndex;
        _curType = (REQ_TYPE)_curTitleIndex;
    [_askDataSource removeAllObjects];
    [_portDataSource removeAllObjects];
    [_helpDataSource removeAllObjects];
    [_onlineDataSource removeAllObjects];
    [self genDataSource];
        [_tableView reloadData];
}

#pragma mark -- txf delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _curTxfild = textField;
    if (_curType != REQ_ONLINE) {
        NSLog(@"%@",@(SCREEN_HEIGHT));
//        if (SCREEN_HEIGHT == 480 || SCREEN_HEIGHT == 568) {
        
            NSInteger baseTag = 0;
            if (_curType == REQ_ASK) {
                baseTag = firstTag;
            }else if (_curType == REQ_PORT){
                baseTag = secondTag;
            }else if (_curType == REQ_HELP){
                baseTag = thirdTag;
            }else{
                baseTag = fourTag;
            }
            
            NSInteger index = textField.tag - baseTag;
            if (index >= 2){
                [_tableView setContentOffset:CGPointMake(0, 160) animated:YES];
            }
            
//        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (textField.text.length == 0) {
        return;
    }
    NSMutableArray *data = nil;
    NSInteger baseTag = 0;
    if (_curType == REQ_ASK) {
        baseTag = firstTag;
        data = _askDataSource;
    }else if (_curType == REQ_PORT){
        baseTag = secondTag;
        data = _portDataSource;
    }else if (_curType == REQ_HELP){
        baseTag = thirdTag;
        data = _helpDataSource;
    }else{
        baseTag = fourTag;
        data = _onlineDataSource;
    }
    
    NSInteger index = textField.tag - baseTag;
    DataModel *model = data[index];
    model.value = textField.text;

}



#pragma mark -- text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (_curType != REQ_ONLINE) {
        if (SCREEN_HEIGHT == 480) {
            [_tableView setContentOffset:CGPointMake(0, 270) animated:YES];
        }else{
            [_tableView setContentOffset:CGPointMake(0, 200) animated:YES];
        }
    }else{
        [_tableView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _curTxView = textView;
    if (textView.text.length == 0) {
        return;
    }
    NSMutableArray *data = nil;
    NSInteger baseTag = 0;
    if (_curType == REQ_ASK) {
        baseTag = firstTag;
        data = _askDataSource;
    }else if (_curType == REQ_PORT){
        baseTag = secondTag;
        data = _portDataSource;
    }else if (_curType == REQ_HELP){
        baseTag = thirdTag;
        data = _helpDataSource;
    }else{
        baseTag = fourTag;
        data = _onlineDataSource;
    }

    
    NSInteger index = textView.tag - baseTag;
    DataModel *model = data[index];
    model.value = textView.text;
    
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end


