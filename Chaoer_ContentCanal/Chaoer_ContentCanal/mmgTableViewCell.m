//
//  mmgTableViewCell.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "mmgTableViewCell.h"

@implementation mmgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMMsg:(GMsgObj *)mMsg{

    self.mName.text = mMsg.mMsg_title;
    self.mTime.text = mMsg.mGen_time;
    self.mContent.text = mMsg.mMsg_content;
    
    
    self.mPoint.hidden = mMsg.mIsRead?YES:NO;
    
}
@end
