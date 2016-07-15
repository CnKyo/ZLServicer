//
//  WithdrawViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mTx;
@property (weak, nonatomic) IBOutlet UIButton *mTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *mBalance;
@property (weak, nonatomic) IBOutlet UIImageView *mBankImg;
@property (weak, nonatomic) IBOutlet UILabel *mBankName;
@property (weak, nonatomic) IBOutlet UILabel *mBankCard;
@property (weak, nonatomic) IBOutlet UIButton *mOkBtn;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Title = self.mPageName = @"提现";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;

    self.mOkBtn.layer.masksToBounds = YES;
    self.mOkBtn.layer.cornerRadius = 3;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
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
- (IBAction)mOkAction:(UIButton *)sender {
}
- (IBAction)mTimeAction:(UIButton *)sender {
}

@end
