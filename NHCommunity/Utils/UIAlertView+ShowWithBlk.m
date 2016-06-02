//
//  UIAlertView+ShowWithBlk.m
//  GwGroup
//
//  Created by gao wenjian on 14-5-21.
//  Copyright (c) 2014年 gwj. All rights reserved.
//

#import "UIAlertView+ShowWithBlk.h"
#import <objc/runtime.h>

@implementation UIAlertView (ShowWithBlk)

static char key;

- (void)showAlertViewOn:(ClickIndexBlk)blk
{
    objc_removeAssociatedObjects(self);
    if (blk) {
        objc_setAssociatedObject(self, &key, blk, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   ClickIndexBlk blk = objc_getAssociatedObject(self, &key);
    if (blk) {
        blk(buttonIndex);
    }
}
@end
