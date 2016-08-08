//
//  mFixBottomView.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "mFixBottomView.h"

@implementation mFixBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (mFixBottomView  *)shareView{

    mFixBottomView *view = [[[NSBundle mainBundle] loadNibNamed:@"mFixBottomView" owner:self options:nil] objectAtIndex:0];
    
    view.mLeftBtn.layer.masksToBounds = view.mRightBtn.layer.masksToBounds = YES;
    view.mLeftBtn.layer.cornerRadius = view.mRightBtn.layer.cornerRadius = 3;
    
    view.mLeftBtn.layer.borderColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.00].CGColor;
    view.mLeftBtn.layer.borderWidth = 0.5;
    
    
    
    return view;
}

- (IBAction)mCancelOrderAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithCancelOrderBtnAction)]) {
        [self.delegate cellWithCancelOrderBtnAction];
    }
    
    
}

- (IBAction)mAcceptOrderAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellWithAcceptOrderBtnAction)]) {
        [self.delegate cellWithAcceptOrderBtnAction];
    }
    
}

@end

