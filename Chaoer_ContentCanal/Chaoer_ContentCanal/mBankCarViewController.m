//
//  mBankCarViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "mBankCarViewController.h"

@interface mBankCarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mBankName;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mCode;
@property (weak, nonatomic) IBOutlet UILabel *mBankCard;

@end

@implementation mBankCarViewController

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Title = self.mPageName = @"银行卡信息";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;

    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    [self loadData];
}

- (void)loadData{

    [[mUserInfo backNowUser] getBankInfo:^(mBaseData *resb) {
        if (resb.mSucess) {
            
            self.mBankName.text = [resb.mData objectForKey:@"bankName"];
            self.mName.text =  [resb.mData objectForKey:@"realName"];
            self.mBankCard.text =  [resb.mData objectForKey:@"card"];
            self.mCode.text =  [resb.mData objectForKey:@"bankWebSite"];
        }else{
            [self emptyPage];
            [self showErrorStatus:resb.mMessage];
        }
    }];
    
    
}

- (void)emptyPage{
    self.mBankName.text = @"无";
    self.mName.text = @"无";
    self.mBankCard.text = @"无";
    self.mCode.text = @"无";

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

@end
