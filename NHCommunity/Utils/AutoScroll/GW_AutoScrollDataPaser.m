//
//  GW_AutoScrollDataPaser.m
//  EOA
//
//  Created by Arsenal on 15/7/17.
//
//

#import "GW_AutoScrollDataPaser.h"
#import "GW_ScrollItem.h"


@interface GW_AutoScrollDataPaser()

@property (nonatomic, retain) NSMutableArray *originDataSource;

@end

@implementation GW_AutoScrollDataPaser
@synthesize delegate = _delegate;

- (void)dealloc{
    [self.originDataSource removeAllObjects];
    _originDataSource = nil;
}

- (id)init{
    self = [super init];
    if (self) {
        self.originDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parserDataInput{
    
    //TODO:
    //do data paser by your bussiness;
    //if other datasource,just replace here and return GW_scrollItem Array;
    //remain: import header need to modify;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i < _originDataSource.count; i++) {
        NSDictionary *data = _originDataSource[i];
        NSString *url = data[DATA_KEY_TYPE_IMG];
        if (![url isKindOfClass:[NSNull class]]) {
            if (![url stringIsNull]) {
                if ([url stringStartwithHttp]) {
                }else{
                    url = [NSString stringWithFormat:@"%@%@",ROOT_URL,[url substringFromIndex:1]];
                }
            }
        }

        GW_ScrollItem *item = [[GW_ScrollItem alloc] init];
        [item setUrl:url];
        item.originObj = data;
        [resultArray addObject:item];
    }
    
    //final return GW_scrollItem Array to scrollview
    if ([_delegate respondsToSelector:@selector(finishDataPaser:)]) {
        [_delegate finishDataPaser:resultArray];
    }
}

- (void)updateDataSource:(NSArray *)datasource{
    [self.originDataSource removeAllObjects];
    [_originDataSource addObjectsFromArray:datasource];
    
    [self parserDataInput];
}
@end
