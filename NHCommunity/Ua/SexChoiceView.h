//
//  SexChoiceView.h
//  NHCommunity
//
//  Created by aa on 16/3/22.
//  Copyright © 2016年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SexChoiceCallBack)(NSString *sex);

@interface SexChoiceView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, copy) SexChoiceCallBack callBackBlk;
@property (weak, nonatomic) IBOutlet UIView *segView;

- (void)toInital;
@end
