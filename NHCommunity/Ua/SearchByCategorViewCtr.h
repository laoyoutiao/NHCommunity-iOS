//
//  SearchByCategorViewCtr.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/17.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultDelegate <NSObject>

- (void)searchResultClickWithData:(NSDictionary *)data;

@end

@interface SearchByCategorViewCtr : UIViewController

@property (nonatomic, assign) NSInteger cateType;
@property (nonatomic, assign) id<SearchResultDelegate> searchDelegate;

- (void)searchWithKeyWord:(NSString *)keyword;

@end
