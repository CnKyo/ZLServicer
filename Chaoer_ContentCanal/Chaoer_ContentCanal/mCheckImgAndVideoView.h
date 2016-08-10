//
//  mCheckImgAndVideoView.h
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/8/10.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKCheckImgDelegate <NSObject>

@optional

- (void)WKCloseBtnClicked;

@end

@interface mCheckImgAndVideoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *mImg;

@property (weak, nonatomic) IBOutlet UIButton *mCloseBtn;

@property (strong,nonatomic) id<WKCheckImgDelegate> delegate;

+ (mCheckImgAndVideoView *)shareView;

@end
