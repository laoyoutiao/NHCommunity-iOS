//
//  CompanylistTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/12/28.
//  Copyright © 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanylistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;

+ (NSString *)indetify;
@end
