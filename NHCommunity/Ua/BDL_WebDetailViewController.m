//
//  BDL_WebDetailViewController.m
//  Bendilianxi
//
//  Created by Arsenal on 15/3/21.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import "BDL_WebDetailViewController.h"
#import "DetailBiz.h"
#import "WebDetailTableViewCell.h"
@interface BDL_WebDetailViewController ()<UIWebViewDelegate>{
    UITableView *_tableView;
    NSString *myTitle;
    NSString *myDate;
}

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation BDL_WebDetailViewController

static NSString *idntify = @"webHead";

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleString;
    self.navigationItem.leftBarButtonItem = [Util createNavBackButton:self selector:@selector(goBack)];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
//    [_tableView setTableFooterView:[[UIView alloc] init]];
//    [_tableView registerNib:[UINib nibWithNibName:@"WebDetailTableViewCell" bundle:nil] forCellReuseIdentifier:idntify];
//    [self.view addSubview: _tableView];

    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
//    [_webView.scrollView setScrollEnabled:NO];
    [self.view addSubview:_webView];
    
    __weak __typeof(self)weakSelf = self;
    [self showLoading];
    if (_active) {
        [[DetailBiz bizInstant] requestActiveDetail:@{@"id":_contentId} success:^(NSDictionary *responseObj) {
            [weakSelf hiddenLoading];
            NSLog(@"re == %@",responseObj);
            NSString *html = [responseObj[@"data"] objectForKey:@"TXT"];
            NSString *title = [responseObj[@"data"] objectForKey:@"TITLE"];
            NSString *date = [responseObj[@"data"] objectForKey:@"RELEASE_DATE"];
            myTitle = title;
            myDate = date;
            NSString *titleHtml = [NSString stringWithFormat:@"<center><p style=\"font-size: 25pt\">%@</p></center>",title];
            NSString *timeHtml = [NSString stringWithFormat:@"<center><p style=\"font-size: 19pt\">%@</p></center><p><hr /></p>",date];
            NSString *allHtml = [NSString stringWithFormat:@"<html><body>%@%@<div style=\"margin:auto 8pt auto 16pt;\">%@</div></body></html>",titleHtml,timeHtml,html];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadHTMLString:allHtml baseURL:RETIVE_URL];
            });
        } fail:^(NSString *errorMsg) {
            [weakSelf showErrorWithStatus:errorMsg];
        }];
    
    }else{
    [[DetailBiz bizInstant] requestDetail:@{@"content_id":_contentId} success:^(NSDictionary *responseObj) {
//        NSLog(@"re == %@",responseObj);
        [weakSelf hiddenLoading];
        
        NSString *html = [responseObj[@"data"] objectForKey:@"TXT"];
        NSString *title = [responseObj[@"data"] objectForKey:@"TITLE"];
         NSString *date = [NSString stringWithFormat:@"发布时间:%@ 发布人:职工家",[responseObj[@"data"] objectForKey:@"RELEASE_DATE"]];
        myTitle = title;
        myDate = date;
        
        
        
        NSString *titleHtml = [NSString stringWithFormat:@"<center><p style=\"font-size: 25pt\">%@</p></center>",title];
        NSString *timeHtml = [NSString stringWithFormat:@"<center><p style=\"font-size: 19pt\">%@</p></center><p><hr /></p>",date];
        NSString *allHtml = [NSString stringWithFormat:@"<html><body>%@%@<div style=\"margin:auto 8pt auto 16pt;\">%@</div></body></html>",titleHtml,timeHtml,html];
        NSLog(@"1111-------%@  %@",RETIVE_URL,_contentId);
        NSLog(@"%@",allHtml);
        dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadHTMLString:allHtml baseURL:RETIVE_URL];
        });
        
//         [_tableView reloadData];
    } fail:^(NSString *errorMsg) {
        [weakSelf showErrorWithStatus:errorMsg];
    }];
    
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark tableview delegate & datasource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        return 58;
//    }
//    return _webView.frame.size.height;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        WebDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idntify];
//        [cell.timeLab setText:myDate];
//        [cell.titleLab setText:myTitle];
//        return cell;
//    }
//    
//    static NSString *identify = @"normalIdentify";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normal];
//        [cell.contentView addSubview:_webView];
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
////    NSLog(@"UserAgent = %@", [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
////    
////    NSLog(@"url---- %@",request.URL.absoluteString);
//    
//    
//    return YES;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    NSLog(@"height = %f",height);
//    CGRect frame = webView.frame;
//    _webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height/2 - 1000);
//    [_tableView reloadData];
//}
@end
