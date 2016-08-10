//
//  mCheckImgAndVideoView.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "mCheckImgAndVideoView.h"

@implementation mCheckImgAndVideoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (mCheckImgAndVideoView *)shareView{

    mCheckImgAndVideoView *view = [[[NSBundle mainBundle] loadNibNamed:@"mCheckImgAndVideoView" owner:self options:nil] objectAtIndex:0];
    return view;
}


- (IBAction)mCloseAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(WKCloseBtnClicked)]) {
        [self.delegate WKCloseBtnClicked];
    }

    
}


@end
