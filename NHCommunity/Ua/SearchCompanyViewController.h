//
//  SearchCompanyViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/12/28.
//  Copyright © 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CompanyClickBlock)(NSDictionary *data);

@interface SearchCompanyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) CompanyClickBlock clickBlk;

@end
