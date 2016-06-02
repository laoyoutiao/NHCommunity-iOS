//
//  GW_AutoScrollProtocol.h
//  EOA
//
//  Created by Arsenal on 15/7/16.
//
//

#import <Foundation/Foundation.h>

@protocol GW_AutoScrollDelegate;

@protocol GW_AutoScrollProtocol <NSObject>

@property (nonatomic, assign) id<GW_AutoScrollDelegate> delegate;

- (void)parserDataInput;

- (void)updateDataSource:(NSArray *)datasource;

@end

@protocol GW_AutoScrollDelegate <NSObject>

- (void)finishDataPaser:(NSArray *)finalData;

@end