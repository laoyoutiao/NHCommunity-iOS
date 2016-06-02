//
//  WebDetailOnlyByLinkViewController.h
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "BaseViewController.h"
@class StaffIconModel;
@interface WebDetailOnlyByLinkViewController : BaseViewController
@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, strong) StaffIconModel *model;
@end
