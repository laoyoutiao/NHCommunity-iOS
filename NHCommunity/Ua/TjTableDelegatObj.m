//
//  TjTableDelegatObj.m
//  NHCommunity
//
//  Created by aa on 16/3/18.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "TjTableDelegatObj.h"

@interface TjTableDelegatObj()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation TjTableDelegatObj

- (void)updateDataWithData:(NSArray *)data
                clickBlock:(void(^)(id obj))click{
    
}


- (void)regeitDataSourceAndDelegate:(UITableView *)table{
    [table setDelegate:self];
    [table setDataSource:self];
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
  
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
    }
}
@end

