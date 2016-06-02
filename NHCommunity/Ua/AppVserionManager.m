//
//  AppVserionManager.m
//  MobileFieldManager
//
//  Created by Arsenal on 15/11/6.
//  Copyright © 2015年 comtop. All rights reserved.
//

#import "AppVserionManager.h"
#import "HttpManager.h"
#import "BDL_JsonSeriler.h"

@implementation AppVserionManager

#define URL_CHECK_VERSION [NSString stringWithFormat:@"%@version.jhtml",ROOT_URL]

+ (void)checkVersion:(NSInteger)appType success:(void(^)(BOOL needUpgrate,NSInteger forceUpgrate ,NSString *url))success{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL_CHECK_VERSION]];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *  response, NSData *  data, NSError *  connectionError) {
//        NSLog(@"error %@",connectionError);
        NSString *reqData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"reqDat = %@",reqData);
        if (!connectionError) {
            NSDictionary *dict = [BDL_JsonSeriler dictFromJsonData:data];
            if (dict == nil) {
                success(NO,NO,nil);
                return;
            }
            if ([dict[@"code"] integerValue] == 0) {
                NSDictionary *data = [dict[@"data"] objectAtIndex:0];
                NSString *server = data[@"version"];
                if (![server isEqualToString:[AppVserionManager appVersion]]) {
                    float serverFloat = server.floatValue;
                    float curVer = [AppVserionManager appVersion].floatValue;
                    if (curVer >= serverFloat) {
                        success(NO,NO,nil);
                    }else{
                        success(YES,NO,data[@"ios_download"]);
                    }
                }else{
                    success(NO,NO,nil);
                }
            }else{
                success(NO,NO,nil);
            }
        }else{
            success(NO,NO,nil);
        }
    }];

}


+ (NSString *)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end
