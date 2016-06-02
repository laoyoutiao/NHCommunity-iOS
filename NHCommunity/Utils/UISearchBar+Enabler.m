//
//  UISearchBar+Enabler.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/17.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "UISearchBar+Enabler.h"

@implementation UISearchBar (Enabler)
- (void) alwaysEnableSearch {
    // loop around subviews of UISearchBar
    NSMutableSet *viewsToCheck = [NSMutableSet setWithArray:[self subviews]];
    while ([viewsToCheck count] > 0) {
        UIView *searchBarSubview = [viewsToCheck anyObject];
        [viewsToCheck addObjectsFromArray:searchBarSubview.subviews];
        [viewsToCheck removeObject:searchBarSubview];
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                // always force return key to be enabled
                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
            }
            @catch (NSException * e) {
                // ignore exception
            }
        }
    }
}
@end
