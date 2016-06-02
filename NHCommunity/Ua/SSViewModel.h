//
//  ViewModel.h
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StaffIconModel;

@interface SSViewModel : NSObject

- (UIView *)headerImageView;
- (UIView *)middelDescTxtView;
- (UIView *)operationViewWithClick:(void(^)(StaffIconModel *smodel,NSInteger clickIndex))clickBlock;
- (UIView *)serviceViewWithClick:(void(^)(StaffIconModel *smodel,NSInteger clickIndex))clickBlock;

- (UIView *)bookViewWithClick:(void(^)(StaffIconModel *model,NSInteger clickIndex))clickBlock;
@end
