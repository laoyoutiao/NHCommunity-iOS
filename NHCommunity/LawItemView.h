//
//  LawItemView.h
//  NHCommunity
//
//  Created by Arsenal on 15/8/25.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawItemView : UIView
/**
 *  0:法律法规 1：法律常识 2：法律文书 3：常见问题
 */
@property (nonatomic, assign) NSInteger lawType;
@end
