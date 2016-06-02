//
//  StaffAskTableViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/22.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "StaffAskTableViewController.h"
#import "UIBarButtonItem+CTop.h"
#import "SubTxFInputTableViewCell.h"
#import "SubmitBiz.h"
#import "SexChoiceTableViewCell.h"
#import "SexChoiceView.h"

@interface AskDataModel : NSObject

@property (nonatomic, copy) NSString *placeshold;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *text;

@end

@implementation AskDataModel



@end


@interface StaffAskTableViewController ()<UITextFieldDelegate>
{
    SubmitBiz *_subBiz;
}
@property (nonatomic, strong) UITextField *cureTxtField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation StaffAskTableViewController

static NSString *txFIdentify = @"txfCell";

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)createFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 5, 150)];
    [label setNumberOfLines:0];
    [label setTextColor:RGB(92, 92, 92, 1)];
    [label setText:@"       \"我要咨询\"是南海区总工会面向广大职工群众的一个重要窗口。主要是为职工群众提供政策咨询、法律援助、困难帮扶、互助保障、职业介绍、职业培训、意见投诉等方面的留言。\n        您提交的留言，我们将有专人及时处理并回复。为确保我们的服务质量，请您务必详细、准确地填写姓名和联系方式等信息，我们将为您提供服务。\n        服务电话：12351"];
    [label setFont:[UIFont systemFontOfSize:12.f]];
    [view addSubview:label];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要咨询";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(tosubmit) edgInset:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubTxFInputTableViewCell" bundle:nil] forCellReuseIdentifier:txFIdentify];
    [self.tableView registerNib:[UINib nibWithNibName:@"SexChoiceTableViewCell" bundle:nil] forCellReuseIdentifier:[SexChoiceTableViewCell identify]];
    [self.tableView setTableFooterView:[self createFooterView]];
    [self.tableView setBackgroundColor:TableViewBgColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _subBiz = [SubmitBiz bizInstant];
    
    _dataSource = [[NSMutableArray alloc] init];
    NSArray *text = @[@"姓        名:",@"性        别:",@"手  机  号:",@"邮        箱:",@"",@"主        题:",@"求助信息:"];
    NSArray *title = @[@"姓名",@"性别",@"手机号",@"邮箱",@"",@"主题",@"输入求助信息"];
    NSArray *keyArray = @[@"uname",@"sex",@"phone",@"email",@"",@"title",@"content"];
    [title enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
        AskDataModel *model = [[AskDataModel alloc] init];
        [model setPlaceshold:obj];
        if (idx == 4) {
            [model setHeight:25];
        }else{
            [model setHeight:50];
        }
        [model  setValue:@""];
        [model setTag:2000 + idx];
        [model setKey:keyArray[idx]];
        [model setText:text[idx]];
        [_dataSource addObject:model];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tosubmit{
    if ([_cureTxtField isFirstResponder]) {
        [_cureTxtField resignFirstResponder];
    }
    __block NSString *errorMsg = @"";
    __block NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [_dataSource enumerateObjectsUsingBlock:^(AskDataModel  * obj, NSUInteger idx, BOOL *  stop) {
        if (idx != 4) {
            if (obj.value.length == 0) {
                errorMsg = [NSString stringWithFormat:@"%@不能为空",obj.placeshold];
                *stop = YES;
            }
            if ([obj.placeshold isEqualToString:@"手机号"]) {
                if (![Util regularWithString:obj.value withRex:@"^\\d{11}$"]) {
                    errorMsg = @"手机号码格式不正确";
                    *stop = YES;
                }
            }
            if ([obj.placeshold isEqualToString:@"邮箱"]) {
                if (![Util regularWithString:obj.value withRex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]) {
                    errorMsg = @"邮箱格式不正确";
                    *stop = YES;
                }
            }
            
            [param setObject:obj.value forKey:obj.key];

        }
    }];
    
    if (errorMsg.length > 0) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }
     if (IS_TESTING) {
         //测试地址
         [param setObject:@"5" forKey:@"ctgId"];
     }else{
         //正式环境
         [param setObject:@"25" forKey:@"ctgId"];
     }
    
    [param setObject:@"1" forKey:@"isPub"];
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    __weak __typeof(self)weakSelf = self;
    [_subBiz submitData:param
                success:^(NSDictionary *responseObj) {
                    [SVProgressHUD showSuccessWithStatus:responseObj[DATA_KEY_MSG]];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf goBack];
                    });
                }
                   fail:^(NSString *errorMsg) {
                       [SVProgressHUD showErrorWithStatus:errorMsg];
                   }];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    AskDataModel *data = _dataSource[row];
    return data.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row ;
    if (row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
            [cell setBackgroundColor:TableViewBgColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
    
    
    
    AskDataModel *model = _dataSource[row];
    
    if (row == 1) {
        SexChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SexChoiceTableViewCell identify] forIndexPath:indexPath];
        [cell.sexInput setPlaceholder:model.placeshold];
        [cell.sexInput setDelegate:self];
        [cell.sexInput setTag:model.tag];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (model.value != nil) {
            [cell.sexInput setText:model.value];
        }else{
            [cell.sexInput setText:@""];
        }
        return cell;
    }
    
    SubTxFInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:txFIdentify];
//    [cell.inputTxF setPlaceholder:model.placeshold];
    [cell.inputTxF setPlaceholder:@"填写"];
    [cell.inputTxF setDelegate:self];
    [cell.inputTxF setTag:model.tag];
    [cell.textLbl setText:model.text];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (model.value != nil) {
        [cell.inputTxF setText:model.value];
    }else{
        [cell.inputTxF setText:@""];
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self choiceSex];
    }
}

- (void)choiceSex{
    SexChoiceView *view = [[[NSBundle mainBundle] loadNibNamed:@"SexChoiceView" owner:nil options:nil] lastObject];
    [view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    __weak __typeof(self)weakSelf = self;
    [view setCallBackBlk:^(NSString *mans){
        AskDataModel *model = weakSelf.dataSource[1];
        [model setValue:mans];
        [weakSelf.tableView reloadData];
    }];
    [self.view addSubview:view];
    [view toInital];
}

#pragma mark -- txf delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.cureTxtField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        return;
    }
    
    NSInteger index = textField.tag - 2000;
    AskDataModel *model = _dataSource[index];
    model.value = textField.text;
    
}

@end
