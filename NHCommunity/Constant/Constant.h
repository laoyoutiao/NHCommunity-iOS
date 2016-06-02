//
//  Constant.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/22.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#ifndef NHCommunity_Constant_h
#define NHCommunity_Constant_h

static NSInteger Acitve_Search_Tag = 1000000;

//配置是否使用测试地址 1: 测试 0:正式环境
#define IS_TESTING 0

#if IS_TESTING
#define ROOT_URL @"http://cgt.vicp.net:8085/"
#else
#define ROOT_URL @"http://staffhome.nanhai.gov.cn/"
#endif

#define RETIVE_URL  [NSURL URLWithString:ROOT_URL]

#define URL_SEARCH_COMPANY @"ApproveService/enterprise.do"
#define URL_LOGIN @"ApproveService/login.do"
#define URL_REGEDIT @"ApproveService/appRegister.do"
#define URL_AUTH @"ApproveService/auth.do"
#define URL_CHECK_AUTH @"ApproveService/checkauth.do"
#define URL_UPDATE_PWD @"ApproveService/updatePwd.do"
#define URL_ACTIVE_LIST @"ApproveService/getActivityNewsByTime.do"
#define URL_ACTIVE_DETAIL @"ApproveService/activityContent.do"
#define URL_CONTENT_DETAIL @"ApproveService/docContent.do"
#define URL_NEW_BY_TIME @"ApproveService/getNewsByTime.do"
#define URL_GET_GUEST_BOOK @"ApproveService/getGuestBook.do"
#define URL_ADD_GUEST_BOOK @"ApproveService/addGuestBook.do"
#define URL_USER_INFO @"ApproveService/getUserInfo.do"
#define URL_UPDATE_USER_INFO @"ApproveService/updateUserInfo.do"
#define URL_UPLOAD_IMAGE @"ApproveService/uploadImg.do"
#define URL_SEARCH @"ApproveService/searchNewsByTime.do"

/************************ constant ************************/
#define U_NAME @"username"
#define U_PWD @"password"
#define P_START @"start"
#define P_END @"end"
#define P_PAGESIZE 10
#define SESSION_KEY @"session_key"
#define RE_REQUEST_FLAG @"RE_REQUEST_FLAG"
#define kLoginStatu @"kLoginStatu"

#define COLOR_ORGIN @"ff9f00"
#define COLOR_LIGHT_GRAY @"8f8f8f"

#define DATE_FORMMAT_STYLE_NORMARL @"yyyy-MM-dd hh:mm:ss"

#define BASE_IMAGE [UIImage imageNamed:@"ic_user_avatar_default"]

#define DATA_KEY_CONTENT_ID @"CONTENT_ID"
#define DATA_KEY_DESCRIPTION @"DESCRIPTION"
#define DATA_KEY_RELEASE_DATE @"RELEASE_DATE"
#define DATA_KEY_RN @"RN"
#define DATA_KEY_TITLE @"TITLE"
#define DATA_KEY_TYPE_IMG @"TYPE_IMG"
#define DATA_KEY_DATA @"data"
#define DATA_KEY_ADDRESS @"ADDRESS"
#define DATA_KEY_CHARGER @"CHARGER"
#define DATA_KEY_DATELINE @"DATELINE"
#define DATA_KEY_CREATE_TIME @"CREATE_TIME"
#define DATA_KEY_CONTENT @"CONTENT"
#define DATA_KEY_REPLY @"REPLY"
#define DATA_KEY_MSG @"msg"

/*************************   log   **************************/
#define USERDEFUALT [NSUserDefaults standardUserDefaults]
#define IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IOS_8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define RGB(r,g,b,alph) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alph])

#define TableViewBgColor RGB(231.f, 231.f, 231.f, 1.0)

#define IPhone6_Height 667
#endif
