//
//  goCell.m
//  goTalk
//
//  Created by st chen on 16/9/15.
//  Copyright © 2016年 st chen. All rights reserved.
//

#import "goCell.h"

@implementation goCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setBasicView:(UIView *)basicView{
    [_basicView removeFromSuperview];
    _basicView = basicView;
    [self addSubview:_basicView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
