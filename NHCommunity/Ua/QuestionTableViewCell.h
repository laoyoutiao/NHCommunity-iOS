//
//  QuestionTableViewCell.h
//  NHCommunity
//
//  Created by Arsenal on 15/9/8.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

+ (CGFloat)cellHeightWithData:(NSDictionary *)data;

+ (NSString *)identify;
@end
