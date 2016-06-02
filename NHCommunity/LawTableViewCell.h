//
//  LawTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LawItemView.h"

@protocol LawItemViewDelegate <NSObject>

- (void)lawItemClick:(NSInteger)lawType;

@end

@interface LawTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet LawItemView *law1;
@property (weak, nonatomic) IBOutlet LawItemView *law2;
@property (weak, nonatomic) IBOutlet LawItemView *law3;
@property (weak, nonatomic) IBOutlet LawItemView *law4;

@property (nonatomic, assign) id<LawItemViewDelegate> delegate;

- (void)refreshLawView;

+ (CGFloat)cellHeight;
@end
