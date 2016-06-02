//
//  NewsTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *ntitle;
@property (weak, nonatomic) IBOutlet UILabel *ndesc;

+ (CGFloat)cellHeight;

+ (NSString *)cellIdentify;
@end
