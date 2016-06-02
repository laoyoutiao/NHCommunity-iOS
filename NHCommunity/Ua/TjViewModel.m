//
//  TjViewModel.m
//  NHCommunity
//
//  Created by aa on 16/3/18.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "TjViewModel.h"


@implementation TjViewModel

- (UITableView *)genTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//    [table setDelegate:self];
//    [table setDataSource:self];
    [table setTableFooterView:[[UIView alloc] init]];
    
    [table setBackgroundColor:RGB(231.f, 231.f, 231.f, 1.0)];
    
//    [table registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [table setLayoutMargins:UIEdgeInsetsZero];
    }
    
    __weak __typeof(self)weakSelf = self;
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    
    table.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    
    return table;
}

- (void)refresh{

}

- (void)loadMore{

}
@end
