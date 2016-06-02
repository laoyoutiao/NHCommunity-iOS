//
//  InfoHeaderTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/27.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoHeadCellDelegate <NSObject>

- (void)imgClick;

@end

@interface InfoHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfiled;

@property (nonatomic, assign) id<InfoHeadCellDelegate> delegate;

+ (NSString *)identify;

@end
