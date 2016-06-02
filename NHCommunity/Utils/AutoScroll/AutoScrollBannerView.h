//
//  AutoScrollBannerView.h
//  EOA
//
//  Created by Arsenal on 15/4/15.
//
//

#import <UIKit/UIKit.h>

@protocol AutoScrollBannerDelegate <NSObject>

- (void)bannerClick:(NSDictionary *)item;

@end
@interface AutoScrollBannerView : UIView

@property (nonatomic,assign) id<AutoScrollBannerDelegate> delegate;

/**
 *  更新内容
 *
 *  @param arrary panelItemArray
 */
- (void)updateScrollContent:(NSArray *)arrary withImageHeight:(CGFloat)imageHeight;

//+ (CGFloat)bannerHeight;
@end
