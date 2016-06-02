//
//  JoinInTableViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/20.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "JoinInTableViewController.h"
#import "UIBarButtonItem+CTop.h"
#import "SubTxFInputTableViewCell.h"
#import "SubmitBiz.h"

@interface JoinDataModel : NSObject

@property (nonatomic, copy) NSString *placeshold;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *text;
@end

@implementation JoinDataModel



@end

@interface JoinInTableViewController ()<UITextFieldDelegate>
{
    SubmitBiz *_subBiz;
}
@property (nonatomic, strong) UITextField *cureTxtField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JoinInTableViewController

static NSString *txFIdentify = @"txfCell";

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)createFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 5, 220)];
    [label setNumberOfLines:0];
    [label setTextColor:RGB(92, 92, 92, 1)];
    [label setText:@"\n       以工资收入为主要生活来源的体力劳动者和脑力劳动者，均有依法参加和组织工会的权利。\n       您若自愿加入工会组织，请提供相关信息。我们将尽快安排工作人员与您联系，帮助您进一步了解和掌握中国工会的性质、基本职责、根本任务以及会员享有的权利和应尽义务，办理网上登记入会的相关手续。\n       您提交的留言，我们将有专人及时处理并回复。为确保我们的服务质量，请您务必详细、准确地填写姓名和联系方式等信息。\n        南海区总工会竭诚为每一名会员提供热情周到的服务。\n        友情提示：1.建议您先联系本单位询问是否有工会组织。2.以上职工个人信息及单位信息项请务必如实、完整填写。"];
    [label setFont:[UIFont systemFontOfSize:12.f]];
    [view addSubview:label];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要入会";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:RGB(42.f, 111.f, 231.f, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"提交" titleColor:[UIColor whiteColor] target:self action:@selector(tosubmit) edgInset:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubTxFInputTableViewCell" bundle:nil] forCellReuseIdentifier:txFIdentify];
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
    NSArray *text = @[@"姓        名:",@"身份证号:",@"手  机  号:",@"工作单位:",@"所属位置:",@"单位地址:"];
    NSArray *title = @[@"姓名",@"身份证号",@"手机号",@"工作单位",@"所属镇街及村社区、工业园",@"单位地址"];
    NSArray *keyArray = @[@"uname",@"identity",@"phone",@"workunit",@"labour",@"workaddr"];
    [title enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * stop) {
        JoinDataModel *model = [[JoinDataModel alloc] init];
        [model setPlaceshold:obj];
        [model setHeight:50];
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
    [_dataSource enumerateObjectsUsingBlock:^(JoinDataModel  * obj, NSUInteger idx, BOOL *  stop) {
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
        [param setObject:obj.value forKey:obj.key];
    }];
    
    if (errorMsg.length > 0) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }
    
    if (IS_TESTING) {
        //测试地址
        [param setObject:@"4" forKey:@"ctgId"];
    }else{
        //正式环境
        [param setObject:@"24" forKey:@"ctgId"];
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
    JoinDataModel *data = _dataSource[row];
    return data.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
//    NSInteger indx = indexPath.row % 2;
//    if (indx == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
//            [cell setBackgroundColor:TableViewBgColor];
//        }
//        return cell;
//    }

    JoinDataModel *model = _dataSource[row];
    
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
    JoinDataModel *model = _dataSource[index];
    model.value = textField.text;
    
}


@end
