//
//  HomeNewVC.m
//  Chaoer_ContentCanal
//
//  Created by 瞿伦平 on 16/8/29.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "HomeNewVC.h"
#import "UIView+Additions.h"
#import "UIView+AutoSize.h"
#import "APIObjectDefine.h"
#import "CustomBtnView.h"
#import "pptORderViewController.h"
#import "fixViewController.h"
#import "marketOrderViewController.h"
#import "kitchenViewController.h"

#import "kitchenTableViewCell.h"
#import "mMyHeaderView.h"

#import "mMyTableViewCell.h"
#import "messageViewController.h"
#import "WithdrawViewController.h"
#import "mBankCarViewController.h"
#import "historyViewController.h"
#import "forgetAndChangePwdView.h"
#import "BankTVC.h"
#import "cashViewController.h"

@interface HomeNewVC ()<QUItemBtnViewDelegate>
@property(nonatomic,strong) UIButton *iconImgView;
@property(nonatomic,strong) UILabel *nameLable;
@property(nonatomic,strong) UILabel *telLable;
@property(nonatomic,strong) UILabel *moneyLable;

@property(nonatomic,strong) UIView *middleView;
@end

@implementation HomeNewVC




-(void)initView
{
    UIView *superView = self.view;
    int padding = 10;
    
    UIView *aView = ({
        UIView *view = [superView newUIView];
        UIImageView *imgbgView = [view newUIImageViewWithImg:IMG(@"home_bg.png")];
        UIButton *imgView = [view newUIButtonWithTarget:self mehotd:@selector(goUserMethod:) bgImgNormal:IMG(@"home_header.png")];
//        UIImageView *imgView = [view newUIImageViewWithImg:IMG(@"home_header.png")];
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        tapGesture.numberOfTapsRequired = 1;
//        [imgView addGestureRecognizer:tapGesture];
        UIColor *color = [UIColor whiteColor];
        UILabel *nameLable = [view newUILableWithText:@"" textColor:color font:[UIFont systemFontOfSize:15] textAlignment:QU_TextAlignmentCenter];
        UILabel *telLable = [view newUILableWithText:@"" textColor:color font:[UIFont systemFontOfSize:15] textAlignment:QU_TextAlignmentCenter];
        UILabel *yueLable = [view newUILableWithText:@"" textColor:color font:[UIFont systemFontOfSize:15] textAlignment:QU_TextAlignmentCenter];
        yueLable.layer.masksToBounds = YES;
        yueLable.layer.borderColor = color.CGColor;
        yueLable.layer.borderWidth = 1;
        yueLable.layer.cornerRadius = 10;
        yueLable.adjustsFontSizeToFitWidth = YES;
        self.iconImgView = imgView;
        self.nameLable = nameLable;
        self.telLable = telLable;
        self.moneyLable = yueLable;
        [imgbgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(view);
        }];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view.mas_width).multipliedBy(0.3);
            make.height.equalTo(imgView.mas_width);
            make.centerX.equalTo(view.centerX);
            make.centerY.equalTo(view.centerY).offset(-padding*2);
        }];
        [nameLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.left).offset(padding);
            make.right.equalTo(view.right).offset(-padding);
            make.top.equalTo(imgView.bottom).offset(padding);
            make.height.equalTo(20);
        }];
        [telLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(nameLable);
            make.top.equalTo(nameLable.bottom);
        }];
        [yueLable makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(telLable.bottom).offset(padding/2);
            make.centerX.equalTo(view.centerX);
            make.width.equalTo(130);
            make.height.equalTo(30);
            make.bottom.equalTo(view.bottom).offset(-padding);
        }];
        nameLable.text = @"张三";
        telLable.text = @"13637959618";
        yueLable.text = @"余额：￥123.00";
        view;
    });
    self.middleView = [superView newUIView];
    UILabel *noteLable = [superView newUILableWithText:@"温馨提示：请选择您的服务种类！\n祝您使用愉快！" textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15] textAlignment:QU_TextAlignmentCenter];
    noteLable.numberOfLines = 0;
    
    
    
    [aView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superView);
        make.height.equalTo(aView.mas_width).multipliedBy(0.8);
    }];
    [noteLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(padding);
        make.right.equalTo(superView.right).offset(-padding);
        make.bottom.equalTo(superView.bottom).offset(-padding);
        make.height.equalTo(40);
    }];
    [self.middleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(aView.bottom);
        make.bottom.equalTo(noteLable.top);
    }];
    
//    self.middleView.backgroundColor = [UIColor greenColor];
//    noteLable.backgroundColor = [UIColor blueColor];
//    self.view.backgroundColor = [UIColor redColor];

}

-(void)reloadMiddleViewSub
{
    mUserInfo *user = [mUserInfo backNowUser];
    
    self.nameLable.text = user.mServiceName.length ? user.mServiceName : @"暂无";
    self.telLable.text = user.mPhone.length ? user.mPhone : @"暂无";
    self.moneyLable.text = [NSString stringWithFormat:@"余额：￥%.2f", user.mMoney];
    [self.iconImgView sd_setBackgroundImageWithURL:[NSURL URLWithString:user.mUserImgUrl] forState:UIControlStateNormal placeholderImage:IMG(@"home_header.png")];

    
    
    [self.tempArray removeAllObjects];
    
    
    if (user.mIsOpenShop )
        [self.tempArray addObject:[NSString stringWithFormat:@"%i", kShopType_cao]];
    if (user.mIsOpenMerchant )
        [self.tempArray addObject:[NSString stringWithFormat:@"%i", kShopType_fix]];
    if (user.mIsOpenClean )
        [self.tempArray addObject:[NSString stringWithFormat:@"%i", kShopType_clean]];
    //[self.tempArray addObjectsFromArray:[mUserInfo backNowUser].mOrderArr];
    
    
    [self.middleView removeAllSubviews];
    
    int row = 3;
    float paddingX = 10;
    float width = (DEVICE_Width - paddingX*(row+1))/row+1;
    UIView *lastView = nil;
    for (int i=0; i<self.tempArray.count; i++) {
        NSString *str = @"";
        UIImage *img = IMG(@"home_header.png");
        
        int type = [self.tempArray[i] intValue];
        switch (type) {
            case kShopType_cao:
                str = @"超市";
                img = IMG(@"home_caoshi.png");
                break;
            case kShopType_fix:
                str = @"维修";
                img = IMG(@"home_pao.png");
                break;
            case kShopType_pao:
                str = @"跑跑腿";
                img = IMG(@"home_pao.png");
                break;
            case kShopType_clean:
                str = @"干洗";
                img = IMG(@"home_ganxi.png");
                break;
            default:
                break;
        }
        
        NSInteger tag = 200 + type;
        CustomBtnView *btnView = [CustomBtnView initWithTag:tag title:str img:img];
        btnView.textLable.textColor = [UIColor colorWithRed:0.443 green:0.451 blue:0.443 alpha:1.000];
        btnView.delegate = self;
        //btnView.backgroundColor = [UIColor greenColor];
        [self.middleView addSubview:btnView];
        [btnView makeConstraints:^(MASConstraintMaker *make) {
            int bai = i % row;
            if (bai == 0) {
                if (lastView == nil)
                    make.top.equalTo(self.middleView.top).offset(paddingX);
                else
                    make.top.equalTo(lastView.bottom).offset(paddingX);
                make.left.equalTo(self.middleView.left).offset(paddingX);
            } else {
                make.top.equalTo(lastView.top);
                make.left.equalTo(lastView.right).offset(paddingX);
            }
            make.width.height.equalTo(width);
        }];
        lastView = btnView;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"订单首页";
    self.hiddenBackBtn = YES;
    self.hiddenRightBtn = YES;
    self.contentView.hidden = YES;
    
    [self initView];
//    self.hiddenlll = YES;
//    self.hiddenNavBar = YES;
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserChangeSuccess:)
                                                 name:MyUserInfoUpdateSuccessNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)handleUserChangeSuccess:(NSNotification *)note
{
    [self loadData];
}



- (void)loadData{
    
    [self reloadMiddleViewSub];
    
//    if ([mUserInfo isNeedLogin]) {
//        [self gotoLoginVC];
//        return;
//    } else {
//        
//        [[mUserInfo backNowUser] getNowUserInfo:^(mBaseData *resb, mUserInfo *user) {
//            
//            if (resb.mSucess) {
//                [self reloadMiddleViewSub];
//            }else{
//                [LCProgressHUD showFailure:resb.mMessage];
//                [self addEmptyView:nil];
//            }
//            
//        }];
//    }
    
}


- (void)tapAction:(UITapGestureRecognizer *)sender{

}

-(void)goUserMethod:(UIButton *)sender
{
    kitchenViewController *vc = [[kitchenViewController alloc] init];
    [self pushViewController:vc];
}


- (void)selectItemBtnView:(QUItemBtnView *)view
{
    NSInteger type = view.tag - 200;
    
    [self pusthVCWithType:type];
}


-(void)pusthVCWithType:(kShopType)type
{
    switch (type) {
        case kShopType_cao:
        {
            marketOrderViewController *mmm = [[marketOrderViewController alloc] initWithNibName:@"marketOrderViewController" bundle:nil];
            mmm.shopType = type;
            [self pushViewController:mmm];
        }
            break;
        case kShopType_fix:
        {
            fixViewController *fix = [[fixViewController alloc] initWithNibName:@"fixViewController" bundle:nil];
            [self pushViewController:fix];
        }
            break;
        case kShopType_clean:
        {
            marketOrderViewController *mmm = [[marketOrderViewController alloc] initWithNibName:@"marketOrderViewController" bundle:nil];
            mmm.shopType = type;
            [self pushViewController:mmm];
        }
            break;
        default:
            break;
    }
}

-(void)jPusthVCWithType:(NSString *)orderType
{
    int type = -100;
    if ([orderType isEqualToString:@"GX"]) {
        type = kShopType_clean;
        
    } else if ([orderType isEqualToString:@"WX"]) {
        type = kShopType_fix;
        
    } else if ([orderType isEqualToString:@"GW"]) {
        type = kShopType_cao;
    }
    
    if (type != -100) {
         [self pusthVCWithType:type];
    }
   
}

@end
