//
//  PlaceholdTextView.h
//
//  Created by Arsenal on 15/3/19.
//  Copyright (c) 2015年 gwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholdTextView : UITextView

@property (nonatomic, copy) NSString *placsHost;

- (instancetype)initWithFrame:(CGRect)frame withPlacsHo:(NSString *)plashod;


@end
