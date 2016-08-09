//
//  marketOrderDetailTableViewCell.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "marketOrderDetailTableViewCell.h"

@implementation marketOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMGoods:(GGoods *)mGoods{

    
    [self.mImg sd_setImageWithURL:[NSURL URLWithString:mGoods.mGoodsImg] placeholderImage:[UIImage  imageNamed:@"DefaultImg"]];
    
    self.mNum.text = [NSString stringWithFormat:@"数量:%d",mGoods.mNumber];
    self.mPrice.text = [NSString stringWithFormat:@"现价:¥%.2f元",mGoods.mUnitPrice];
    self.mContent.text = mGoods.mGoodsName;
    self.mSubContent.text = mGoods.mGoodsComment;
    
    
}

@end
