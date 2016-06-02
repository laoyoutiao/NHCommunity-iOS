//
//  AutoScrollBannerView.m
//  EOA
//
//  Created by Arsenal on 15/4/15.
//
//

#import "AutoScrollBannerView.h"
#import "GW_AutoScrollDataPaser.h"
#import "GW_ScrollItem.h"
#import "Util.h"

#import "UIImageView+WebCache.h"

static NSInteger ScrollTimeDuration = 5.0f;

#define TOTALCOUNT _bannerArray.count
#define SCROLL_ITEM_WIDTH [UIScreen mainScreen].bounds.size.width

@interface AutoScrollBannerView()<UIScrollViewDelegate,GW_AutoScrollDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_imgArray;
    
    GW_AutoScrollDataPaser *_paser;
}

@property (nonatomic, retain) NSMutableArray *bannerArray;

@end

@implementation AutoScrollBannerView

- (void)dealloc{
    [_paser setDelegate:nil];
    [self stopAutoScroll];
    self.bannerArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imgArray = [[NSMutableArray alloc] initWithCapacity:0];
        _bannerArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_scrollView setDelegate:self];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setPagingEnabled:YES];
        [self addSubview:_scrollView];
        [_scrollView setBackgroundColor:[Util getColor:@"e6e6e6"]];
        
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[Util getColor:@"6b501e"]];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)updatePageControlFrame{
    NSInteger pageCount = 0;
    if (TOTALCOUNT > 1) {
        pageCount = TOTALCOUNT - 2;
    }else
        pageCount = TOTALCOUNT;
    
    [_pageControl setNumberOfPages:pageCount];
    CGSize pageSize = [_pageControl sizeForNumberOfPages:pageCount];
    [_pageControl setFrame:CGRectMake(self.frame.size.width - pageSize.width - 13, self.frame.size.height - pageSize.height + 5, pageSize.width, pageSize.height)];
}

- (void)updateScrollContent:(NSArray *)arrary withImageHeight:(CGFloat)imageHeight{
    
    if (imageHeight != _scrollView.frame.size.height) {
        //update frame
        CGRect viewFrame = self.frame;
        viewFrame.size.height = imageHeight;
        
        CGRect scrollFrame = _scrollView.frame;
        scrollFrame.size.height = imageHeight;
        
        self.frame = viewFrame;
        _scrollView.frame = scrollFrame;
    }
    
    if (!_paser) {
        _paser = [[GW_AutoScrollDataPaser alloc] init];
        [_paser setDelegate:self];
    }
    
    [_paser updateDataSource:arrary];
}

- (void)clearAllView{
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    [_pageControl setNumberOfPages:0];
    [self stopAutoScroll];
}

- (void)doownLoadImageWitItem:(GW_ScrollItem *)item
                withImageView:(UIImageView *)imgView{

    NSString *url = item.url;
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
}

#pragma mark -- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offsetX = _scrollView.contentOffset.x;
    if (TOTALCOUNT >= 3) {
        if (offsetX >= SCROLL_ITEM_WIDTH * (TOTALCOUNT - 1)) {
            offsetX = SCROLL_ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        }else if(offsetX <= 0){
            offsetX = SCROLL_ITEM_WIDTH * (TOTALCOUNT - 2);
            [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        }
    }
    
    NSInteger page = (_scrollView.contentOffset.x + SCROLL_ITEM_WIDTH/2.0) / SCROLL_ITEM_WIDTH;
    if (TOTALCOUNT > 1) {
        page--;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
            
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
    
    if (_pageControl.currentPage != page) {
        [self loadPrepageImageWithPage:page];
        [self loadNextPageImageWithPage:page];
    }
    
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat offsetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        offsetX = (int)(offsetX / SCROLL_ITEM_WIDTH) * SCROLL_ITEM_WIDTH;
        [self moveToTargetOffsetX:offsetX];
    }
}

#pragma mark -- common methods
- (void)loadNextPageImageWithPage:(NSInteger)page{
    if (page == 0) {
        //重新加载头部第一个
        UIImageView *img = [_imgArray objectAtIndex:0];
        GW_ScrollItem *item = _bannerArray[0];
        [self doownLoadImageWitItem:item withImageView:img];
    }
}

- (void)loadPrepageImageWithPage:(NSInteger)page{
    if (page == _pageControl.numberOfPages - 1) {
        //重新加载最后一个
        UIImageView *img = _imgArray.lastObject;
        GW_ScrollItem *item = _bannerArray.lastObject;
        [self doownLoadImageWitItem:item withImageView:img];
    }
}

- (void)moveToTargetOffsetX:(CGFloat)offsetX
{
    if([_bannerArray count]>0){
        BOOL animated = YES;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
        
        GW_ScrollItem *item = _bannerArray[_pageControl.currentPage + 1];
        UIImageView *imgView = (UIImageView *)[_scrollView viewWithTag:1000 + _pageControl.currentPage + 1];
        [self doownLoadImageWitItem:item withImageView:imgView];
    }
    
}

- (void)imgClick:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)[tap view];
    NSInteger tag = tapView.tag - 1000;
    //#warning here to call back logic for click banner
    NSDictionary *item = [(GW_ScrollItem *)_bannerArray[tag] originObj];
    if (_delegate && [_delegate respondsToSelector:@selector(bannerClick:)]) {
        [_delegate bannerClick:item];
    }
}

- (void)stopAutoScroll{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changePage) object:nil];
}

- (void)changePage{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changePage) object:nil];
    
    CGFloat offsetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    offsetX = (int)(offsetX/SCROLL_ITEM_WIDTH) * SCROLL_ITEM_WIDTH;
    [self moveToTargetOffsetX:offsetX];
    
    [self performSelector:@selector(changePage) withObject:nil afterDelay:ScrollTimeDuration];
}

#pragma mark -- paser datasource delegate
- (void)finishDataPaser:(NSArray *)arrary{
    
    [self.bannerArray removeAllObjects];
    [self.bannerArray addObjectsFromArray:arrary];
    
    if (arrary.count > 1) {
        //默认 开启循环滑动效果
        id firstObj = _bannerArray[0];
        id lastObj = _bannerArray.lastObject;
        //一头一尾分别插入
        [_bannerArray insertObject:lastObj atIndex:0];
        [_bannerArray insertObject:firstObj atIndex:_bannerArray.count];
    }
    
    NSMutableArray *tempImgarray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < _bannerArray.count; i++) {
        GW_ScrollItem *item = _bannerArray[i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * i, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        
        [self doownLoadImageWitItem:item withImageView:imgView];
        [_scrollView addSubview:imgView];
        
        
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, CGRectGetHeight(_scrollView.frame) - 25, CGRectGetWidth(_scrollView.frame), 25)];
        [bgLabel setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [_scrollView addSubview:bgLabel];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x + 10, CGRectGetHeight(_scrollView.frame) - 25, CGRectGetWidth(_scrollView.frame) - 20 - 40, 25)];
        [titleLable setFont:[UIFont systemFontOfSize:13.f]];
        [titleLable setTextColor:[UIColor whiteColor]];
        [titleLable setText:[item.originObj objectForKey:@"TITLE"]];
        [_scrollView addSubview:titleLable];
        [titleLable setTag:4000 + i];
        
        NSInteger tag = 1000 + i;
        [imgView setTag:tag];
        [imgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
        [imgView addGestureRecognizer:tap];
        
        [tempImgarray addObject:imgView];
        
        
    }
    
    [_imgArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [_imgArray removeAllObjects];
    [_imgArray addObjectsFromArray:tempImgarray];
    
    
    [self updatePageControlFrame];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * TOTALCOUNT, 0)];
    
    [self stopAutoScroll];
    // > = 2个以上，才开启自动轮播
    if (arrary.count > 1) {
        [self moveToTargetOffsetX:SCROLL_ITEM_WIDTH];
        [self performSelector:@selector(changePage) withObject:nil afterDelay:ScrollTimeDuration];
    }
}
@end