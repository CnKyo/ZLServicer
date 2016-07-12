//
//  mMyHeaderView.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/12.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "mMyHeaderView.h"

@implementation mMyHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (mMyHeaderView *)shareView{

    mMyHeaderView *View = [[[NSBundle mainBundle] loadNibNamed:@"mMyHeaderView" owner:self options:nil] objectAtIndex:0];
    
    View.mHeader.layer.masksToBounds = YES;
    View.mHeader.layer.cornerRadius = View.mHeader.mwidth/2;
    View.mHeader.layer.borderColor = [UIColor whiteColor];
    View.mHeader.layer.borderWidth = 2;
    
    return View;
}

@end
