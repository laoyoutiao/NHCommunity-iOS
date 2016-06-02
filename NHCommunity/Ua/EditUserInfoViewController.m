//
//  EditUserInfoViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "InfoHeaderTableViewCell.h"
#import "InfoOneInputTableViewCell.h"
#import "InfoTwoInputTableViewCell.h"
#import "UserCenterViewController.h"
#import "UserInfoVo.h"
#import "UserBiz.h"
#import "TransformObjDict.h"
#import "UIImage+ImageUtil.h"
#import "DatePickerView.h"
#import "UserForSubmit.h"

@interface EditUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,InfoHeadCellDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_oneInputDataSource;
    NSMutableArray *_twoInputDataSource;
    
    BOOL _editing;
    
    DatePickerView *_picker;
}
@property (nonatomic, strong) UITextField *curTxtf;
@property (nonatomic, strong) UIImage *curChoiceImg;
@end

@implementation EditUserInfoViewController

static NSString *L_TITLE = @"L_TITLE";
static NSString *L_VALUE = @"l_value";
static NSString *titles = @"请输入";

- (void)requestUserInfo{
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    NSString *uname = [GlobalUtil shareInstant].loginInfo[U_NAME];
    [[UserBiz bizInstant] requestUserInfo:@{@"userName":uname}
                                  success:^(UserInfoVo *responseObj) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf refrshData];
                                          [weakSelf hiddenLoading];
                                      });
                                      
                                  }
                                     fail:^(NSString *errorMsg) {
                                        [weakSelf hiddenLoading];
                                     }];
}

- (void)refrshData{
    
     UserInfoVo *user = [[GlobalUtil shareInstant] userInfo];
    [_oneInputDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *data = obj;
        NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
        NSString *value = @"";
        if (idx == 0) {
            value = (user == nil ? titles : user.SIGN);
        }
        if (idx == 1) {
            value = (user == nil ? titles : user.EMAIL);
        }
        if (idx == 2) {
            value = (user == nil ? titles : user.BIRTHDAY);
        }
        if (idx == 3) {
            value = (user == nil ? titles : user.INTRO);
        }
        if (idx == 4) {
            value = (user == nil ? titles :user.COMEFROM);
        }
        [muData setObject:value forKey:L_VALUE];
        [_oneInputDataSource replaceObjectAtIndex:idx withObject:muData];
    }];
    
    [_twoInputDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *data = obj;
        NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
        NSString *value = @"";
        if (idx == 0) {
            value = (user == nil ? titles : user.REALNAME);
        }
        if (idx == 1) {
            value = (user == nil ? titles : (user.GENDER.integerValue == 0 ? @"女" : @"男"));
        }
        if (idx == 2) {
            value = (user == nil ? titles : user.MSN);
        }
        if (idx == 3) {
            value = (user == nil ? titles : user.QQ);
        }
        if (idx == 4) {
            value = (user == nil ? titles :user.PHONE);
        }
        if (idx == 5) {
            value = (user == nil ? titles :user.MOBILE);
        }
        [muData setObject:value forKey:L_VALUE];
        [_twoInputDataSource replaceObjectAtIndex:idx withObject:muData];
    }];
    
    [_tableView reloadData];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员信息";
    _oneInputDataSource = [[NSMutableArray alloc] init];
    _twoInputDataSource = [[NSMutableArray alloc] init];
    
    NSArray *one = @[@"个性签名:",@"邮箱:",@"出生日期:",@"自我介绍:",@"来自:"];
    for (int i = 0; i < one.count; i++) {
        NSString *value = @"";
        [_oneInputDataSource addObject:@{L_TITLE:one[i],L_VALUE:value}];
    }
    
    NSArray *two = @[@"真实姓名:",@"性别:",@"MSN:",@"QQ:",@"电话:",@"手机:"];
    for (int i = 0; i < two.count; i++) {
        [_twoInputDataSource addObject:@{L_TITLE:two[i],L_VALUE:@""}];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [_tableView setBackgroundColor:TableViewBgColor];
    [_tableView registerNib:[UINib nibWithNibName:@"InfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:[InfoHeaderTableViewCell identify]];
    
    [_tableView registerNib:[UINib nibWithNibName:@"InfoOneInputTableViewCell" bundle:nil] forCellReuseIdentifier:[InfoOneInputTableViewCell identify]];
    
    [_tableView registerNib:[UINib nibWithNibName:@"InfoTwoInputTableViewCell" bundle:nil] forCellReuseIdentifier:[InfoTwoInputTableViewCell identify]];

    [self.view addSubview: _tableView];
    
    
    if (_fromMain) {
        [self createBackBtn];
    }else{
        [self createLeftUserCenterBtn];
        UISwipeGestureRecognizer *swap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft:)];
        [swap setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swap];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestUserInfo];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadImg{
    if (_curChoiceImg) {
        NSString *base64 = [Util imageToBase64:_curChoiceImg];
        NSString *name = [[GlobalUtil shareInstant] loginInfo][U_NAME];
        NSString *pwd = [[GlobalUtil shareInstant] loginInfo][U_PWD];
        
        NSString *type = @"png";
        if ([Util imageHasAlph:_curChoiceImg]) {
            type = @"png";
        }else
            type = @"jpg";
        
        NSDictionary *param = @{@"username":name,@"password":pwd,@"fileBase64":base64,@"suffix":type};
            
        
        [[UserBiz bizInstant] uploadHeadImage:param
                                      success:^(NSString *success) {
                                          NSLog(@"上传头像成功 = %@",success);
                                      }
                                         fail:^(NSString *error) {
                                            NSLog(@"上传头像失败 = %@",error);
        }];
    }
}

- (void)saveInfo{
    
    __block UserForSubmit *subimtUser = [[UserForSubmit alloc] init];

    InfoHeaderTableViewCell *cell = (InfoHeaderTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [subimtUser setUserName:cell.nameTextfiled.text];
    
    [_oneInputDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *data = obj;
        if (idx == 0) {
            subimtUser.sign = data[L_VALUE];
        }
        if (idx == 1) {
            subimtUser.email = data[L_VALUE];
        }
        if (idx == 2) {
             subimtUser.birthday = data[L_VALUE];
        }
        if (idx == 3) {
            subimtUser.intro = data[L_VALUE];
        }
        if (idx == 4) {
           subimtUser.comfrom = data[L_VALUE];
        }
    }];
    
    [_twoInputDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *data = obj;
        if (idx == 0) {
            subimtUser.realName = data[L_VALUE];
        }
        if (idx == 1) {
             subimtUser.gender = data[L_VALUE];
        }
        if (idx == 2) {
             subimtUser.msn = data[L_VALUE];
        }
        if (idx == 3) {
            subimtUser.qq = data[L_VALUE];
        }
        if (idx == 4) {
            subimtUser.phone = data[L_VALUE];
        }
        if (idx == 5) {
            subimtUser.mobile = data[L_VALUE];
        }
    }];
    
    //邮箱
    if (subimtUser.email.length > 0) {
        if (![Util regularWithString:subimtUser.email withRex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"]) {
            [self showErrorWithStatus:@"邮箱格式不正确"];
            return;
        }
    }
    
    //电话
    if (subimtUser.mobile.length > 0) {
        if (![Util regularWithString:subimtUser.mobile withRex:@"^\\d{11}$"]) {
            [self showErrorWithStatus:@"手机号码格式不正确"];
            return;
        }
    }
    
    
    NSDictionary *param = [TransformObjDict dictWithObject:subimtUser];
    NSLog(@"save user info param = %@",param);
    [self showLoading];
    [[UserBiz bizInstant] updatetUserInfo:param
                                  success:^(NSString *success) {
                                      [self showSuccessWithStatus:success];
                                  }
                                     fail:^(NSString *error) {
                                         [self showErrorWithStatus:error];
    }];
}

- (void)editable:(UIButton *)btn{
    _editing = !_editing;
    [_tableView reloadData];
    if (!_editing) {
        [self saveInfo];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self uploadImg];
        });
        
    }
}

#pragma mark --
#pragma mark tableview delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 17;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 85;
    }else{
        CGFloat clearCellIndex = (indexPath.row - 1) % 2;
        if (clearCellIndex == 0) {
            return 10;
        }else
            return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        InfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoHeaderTableViewCell identify]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        [cell.editBtn addTarget:self action:@selector(editable:) forControlEvents:UIControlEventTouchUpInside];
        if (_editing) {
            [cell.editBtn setTitle:@"上传资料" forState:UIControlStateNormal];
        }else{
            [cell.editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        }
        
        [cell.leftHeadImage setUserInteractionEnabled:_editing];
        [cell.nameTextfiled setUserInteractionEnabled:_editing];
        
        
        UserInfoVo *user = [[GlobalUtil shareInstant] userInfo];
        if (user) {
            [cell.nameTextfiled setText:user.USERNAME];
            BOOL flag = NO;
            if ([[user USER_IMG] isKindOfClass:[NSNull class]]) {
                flag = YES;
            }
            if ([user USER_IMG] == nil) {
                flag = YES;
            }
            if ([[user USER_IMG] isKindOfClass:[NSString class]]) {
                if ([user USER_IMG].length == 0 ) {
                    flag = YES;
                }
            }
//            if (flag) {
//                UIImage *i = [BASE_IMAGE imageAsCircle:YES
//                                              withDiamter:59
//                                              borderColor:[UIColor clearColor]
//                                              borderWidth:0.0f
//                                             shadowOffSet:CGSizeZero];
//                [cell.leftHeadImage setImage:i];
//            }else{
                NSString *url = [NSString stringWithFormat:@"%@%@",ROOT_URL,[user USER_IMG]];
                UIImage *i = [BASE_IMAGE imageAsCircle:YES
                                           withDiamter:59
                                           borderColor:[UIColor clearColor]
                                           borderWidth:0.0f
                                          shadowOffSet:CGSizeZero];
                [cell.leftHeadImage sd_setImageWithURL:[NSURL URLWithString:url]
                                      placeholderImage:i
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 if (image) {
                                                     UIImage *i = [image imageAsCircle:YES
                                                                           withDiamter:59
                                                                           borderColor:[UIColor clearColor]
                                                                           borderWidth:0.0f
                                                                          shadowOffSet:CGSizeZero];
                                                     [cell.leftHeadImage setImage:i];
                                                 }
                                             }];
//            }
        }
        
        if (_curChoiceImg) {
            UIImage *i = [_curChoiceImg imageAsCircle:YES
                                  withDiamter:59
                                  borderColor:[UIColor clearColor]
                                  borderWidth:0.0f
                                 shadowOffSet:CGSizeZero];
            [cell.leftHeadImage setImage:i];
        }
        return cell;
    }else{
        CGFloat clearCellIndex = (indexPath.row - 1) % 2;
        if (clearCellIndex == 0) {
            static NSString *identify = @"normalIdentify";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
                [cell setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.f)];
            }
            return cell;

        }else{
            NSInteger row = indexPath.row;
            if (row == 2 || row == 4 || row == 8 || row == 10 || row == 12) {
                InfoOneInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoOneInputTableViewCell identify]];
                [self configSigleCell:cell indexPath:indexPath];
                return cell;
            }else{
                InfoTwoInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoTwoInputTableViewCell identify]];
                [self configInfoTwoInputTableViewCell:cell indexPath:indexPath];
                return cell;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_editing) {
        return;
    }
    if ([_curTxtf isFirstResponder]) {
        [_curTxtf resignFirstResponder];
    }
    if (indexPath.row == 8) {
        if (_picker == nil) {
            _picker = [[DatePickerView alloc] initWithCallBack:^(NSString *date) {
                NSDictionary *data = _oneInputDataSource[2];
                NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
                [muData setObject:[date substringToIndex:10] forKey:L_VALUE];
                [_oneInputDataSource replaceObjectAtIndex:2 withObject:muData];
                [_tableView reloadData];
            }];
        }
        
        NSDate *date = [NSDate date];
        [_picker showPickerOnSuperView:self.view
                               curDate:date];

    }
}

- (void)configSigleCell:(InfoOneInputTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger row = indexPath.row;
    NSArray *rowArray = @[@(2),@(4),@(8),@(10),@(12)];
    [cell.valueInputTxf setDelegate:self];

    [rowArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] == row) {
            NSDictionary *data = _oneInputDataSource[idx];
            [cell.leftTitleLabel setText:data[L_TITLE]];
            [cell.valueInputTxf setText:data[L_VALUE]];
            [cell.valueInputTxf setTag:1000 + idx];
            
            if (idx == 2) {
                [cell.valueInputTxf setUserInteractionEnabled:NO];
            }else{
                [cell.valueInputTxf setUserInteractionEnabled:_editing];
            }
        }
    }];
}

- (void)configInfoTwoInputTableViewCell:(InfoTwoInputTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSDictionary *leftData = nil;
    NSDictionary *rightData = nil;
    NSInteger idx = 0;
    if (indexPath.row == 6) {
        leftData = _twoInputDataSource[0];
        rightData = _twoInputDataSource[1];
        idx = 0;
    }
    
    if (indexPath.row == 14) {
        leftData = _twoInputDataSource[2];
        rightData = _twoInputDataSource[3];
        idx = 2;
    }
    
    if (indexPath.row == 16) {
        leftData = _twoInputDataSource[4];
        rightData = _twoInputDataSource[5];
        idx = 4;
    }
    
    [cell.leftInput setTag:2000 + idx];
    [cell.rightInput setTag:2000 + idx + 1];
    [cell.leftInput setUserInteractionEnabled:_editing];
    [cell.rightInput setUserInteractionEnabled:_editing];
    
    [cell.leftInput setDelegate:self];
    [cell.rightInput setDelegate:self];
    [cell.leftTitleLabel setText:leftData[L_TITLE]];
    [cell.leftInput setText:leftData[L_VALUE]];
    
    [cell.rightTitleLabel setText:rightData[L_TITLE]];
    [cell.rightInput setText:rightData[L_VALUE]];
   
}

#pragma mark -- textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger tag = 0;
    if (textField.tag < 2000) {
        tag = textField.tag - 1000;
        if (tag == 1) {
             [_tableView setContentOffset:CGPointMake(0, 80) animated:YES];
        }
        if (tag == 2) {
//            [_tableView setContentOffset:CGPointMake(0, 160) animated:YES];
            
//            if (_picker == nil) {
//                _picker = [[DatePickerView alloc] initWithCallBack:^(NSString *date) {
//                    NSDictionary *data = _oneInputDataSource[2];
//                    NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
//                    [muData setObject:[date substringToIndex:10] forKey:L_VALUE];
//                    [_oneInputDataSource replaceObjectAtIndex:tag withObject:muData];
//                    [_tableView reloadData];
//                }];
//            }
//        
//            if ([_curTxtf isFirstResponder]) {
//                [_curTxtf resignFirstResponder];
//            }
//            
//            NSDate *date = [NSDate date];
//            [_picker showPickerOnSuperView:self.view
//                                  curDate:date];
            
        }
        if (tag == 3 || tag == 4) {
            [_tableView setContentOffset:CGPointMake(0, 250) animated:YES];
        }
    }else{
        tag = textField.tag - 2000;
        if (tag == 1 || tag == 0) {
            [_tableView setContentOffset:CGPointMake(0, 80) animated:YES];
        }else if (tag == 2 || tag == 3) {
            if (SCREEN_HEIGHT <= 568) {
                [_tableView setContentOffset:CGPointMake(0, 300) animated:YES];
            }else{
                [_tableView setContentOffset:CGPointMake(0, 250) animated:YES];
            }
        }else{
            if (SCREEN_HEIGHT  <= 568) {
                [_tableView setContentOffset:CGPointMake(0, 300) animated:YES];
            }else{
                [_tableView setContentOffset:CGPointMake(0, 250) animated:YES];
            }
                
        }
    }
    
    if (tag >= 3) {
       
    }
    
    _curTxtf = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        return;
    }
    NSInteger tag = 0;
    if (textField.tag < 2000) {
        tag = textField.tag - 1000;
        NSDictionary *data = _oneInputDataSource[tag];
        NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
        [muData setObject:textField.text forKey:L_VALUE];
        [_oneInputDataSource replaceObjectAtIndex:tag withObject:muData];
    }else{
        tag = textField.tag - 2000;
        NSDictionary *data = _twoInputDataSource[tag];
        NSMutableDictionary *muData = [NSMutableDictionary dictionaryWithDictionary:data];
        [muData setObject:textField.text forKey:L_VALUE];
        [_twoInputDataSource replaceObjectAtIndex:tag withObject:muData];
    }
}

#pragma mark -- 相机

- (void)showPic{
    UIActionSheet *shteer = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"照相机", nil];
    [shteer showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showALben];
    }else if(buttonIndex == 1){
        [self showCarmaer];
    }
}

- (void)showALben{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型、
    [controller setAllowsEditing:YES];
    [controller setDelegate:self];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
    
}
- (void)showCarmaer{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型、
    [controller setDelegate:self];
    [controller setAllowsEditing:YES];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if ([type isEqualToString:@"public.image"]) {
        //拍照
        __weak __typeof(self)weakSelf = self;
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
            dispatch_queue_t queue =  dispatch_queue_create("md5", NULL);
            dispatch_async(queue, ^{
                UIImage *selectImage = [Util rotateImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
                
                if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
                    UIImageWriteToSavedPhotosAlbum(selectImage, NULL, NULL, NULL);
                }
                weakSelf.curChoiceImg = selectImage;
                
            });
            
            [picker dismissViewControllerAnimated:YES completion:^{
                [_tableView reloadData];
            }];
        }
        else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ){
            
            dispatch_queue_t queue =  dispatch_queue_create("md5", NULL);
            dispatch_async(queue, ^{
                UIImage *selectImage = [Util rotateImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
                 weakSelf.curChoiceImg = selectImage;
            });
            
            [picker dismissViewControllerAnimated:YES completion:^{
                [_tableView reloadData];
            }];
        }
    }
}

#pragma mark -- header delegate
- (void)imgClick{
    [self showPic];
}
@end
