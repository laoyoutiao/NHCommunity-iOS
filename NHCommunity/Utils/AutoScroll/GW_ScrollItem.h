//
//  GW_ScrollItem.h
//  EOA
//
//  Created by Arsenal on 15/7/17.
//
//

#import <Foundation/Foundation.h>

@interface GW_ScrollItem : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) id originObj;
@end
