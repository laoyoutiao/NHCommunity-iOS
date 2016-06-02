//
//  SubmitViewController.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/9.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    REQ_ASK = 0,
    REQ_PORT = 1,
    REQ_HELP = 2,
    REQ_ONLINE = 3
}REQ_TYPE;

@interface SubmitViewController : BaseViewController
@property (nonatomic, assign) REQ_TYPE curType;
@end
