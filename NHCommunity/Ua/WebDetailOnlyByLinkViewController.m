//
//  WebDetailOnlyByLinkViewController.m
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "WebDetailOnlyByLinkViewController.h"
#import "StaffIconModel.h"

@interface WebDetailOnlyByLinkViewController ()<UIWebViewDelegate>

@end

@implementation WebDetailOnlyByLinkViewController

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    //    [_webView.scrollView setScrollEnabled:NO];
    [self.view addSubview:_webView];
    
    self.title = _model.title;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hiddenLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hiddenLoading];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingWithType:SVProgressHUDMaskTypeNone];
}

@end
