//
//  UIAlertView+ShowWithBlk.h
//  GwGroup
//
//  Created by gao wenjian on 14-5-21.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (ShowWithBlk)

typedef void(^ClickIndexBlk)(NSInteger index);

- (void)showAlertViewOn:(ClickIndexBlk)blk;
@end
