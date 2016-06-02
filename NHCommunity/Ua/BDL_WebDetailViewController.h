//
//  BDL_WebDetailViewController.h
//  Bendilianxi
//
//  Created by Arsenal on 15/3/21.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BaseViewController.h"

@interface BDL_WebDetailViewController : BaseViewController
//@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *titleString;


@property (nonatomic, assign) BOOL active;
 @end
