//
//  cashViewController.m
//  Chaoer_ContentCanal
//
//  Created by 王钶 on 16/3/24.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "cashViewController.h"
#import "BankTVC.h"
#import "QUCustomDefine.h"

@interface cashViewController ()
@property(nonatomic,strong) BankObject *chooseBankItem;
@end

@implementation cashViewController

{
    NSString *mPayType;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mOkBtn.selected = NO;

    /**
     IQKeyboardManager为自定义收起键盘
     **/
    [[IQKeyboardManager sharedManager] setEnable:YES];///视图开始加载键盘位置开启调整
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];///是否启用自定义工具栏
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;///启用手势
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];///视图消失键盘位置取消调整
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];///关闭自定义工具栏
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hiddenRightBtn = YES;
    self.hiddenlll = YES;
    self.hiddenTabBar = YES;
    self.Title = self.mPageName = @"余额提现";
    
    self.mOkBtn.layer.masksToBounds = YES;
    self.mOkBtn.layer.cornerRadius = 3;
    
    self.mBalance.text = [NSString stringWithFormat:@"%.2f元",[mUserInfo backNowUser].mMoney];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1.00];
    
//    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapChoose:)];
//    singleRecognizer.numberOfTapsRequired = 1; // 单击
//    [self.mBankCode addGestureRecognizer:singleRecognizer];
//    self.mBankCode.backgroundColor = [UIColor redColor];
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


- (IBAction)mTimeAction:(id)sender {
    
    
    MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:@"请选择到账时间" style:MHSheetStyleWeiChat itemTitles:@[@"T+1",@"T+0"]];
    actionSheet.cancleTitle = @"取消选择";
    
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        NSString *text = title;
        MLLog(@"%@",text);
        mPayType = [NSString stringWithFormat:@"%ld",(long)index];
        [self.mTimeBtn setTitle:text forState:0];
        
    }];

}

-(void)SingleTapChoose:(UITapGestureRecognizer*)recognizer
{

}

- (void)leftBtnTouched:(id)sender{
    [self popViewController];
}

- (IBAction)okbtn:(UIButton *)sender {
    
  
    if (self.mMoneyTx.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您要提现的金额！"];
        [self.mMoneyTx becomeFirstResponder];
        return;
        
    }
    if ([mUserInfo backNowUser].mMoney < [self.mMoneyTx.text floatValue]) {
        [self showErrorStatus:@"余额不足，提现失败！"];
        [self.mMoneyTx becomeFirstResponder];
        return;
    }
    if ([mUserInfo backNowUser].mMoney < 50) {
        [self showErrorStatus:@"提现余额不能低于50元，且不高于5万元！"];
        [self.mMoneyTx becomeFirstResponder];
        return;
    }
    
    if ([mUserInfo backNowUser].mMoney >= 50000) {
        [self showErrorStatus:@"提现余额不能低于50元，且不高于5万元！"];
        [self.mMoneyTx becomeFirstResponder];
        return;
    }
    
    if (_chooseBankItem == nil) {
        [self showErrorStatus:@"请选择银行卡！"];
        return;
    }
   
    if ([self.mTimeBtn.titleLabel.text isEqualToString:@"请选择到账时间"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择到账时间！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];
    
    [mUserInfo  getUserCash:_chooseBankItem.mId andMoney:self.mMoneyTx.text andPresentManner:mPayType block:^(mBaseData *resb) {
        if (resb.mSucess) {
            [SVProgressHUD showSuccessWithStatus:resb.mMessage];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MyUserNeedUpdateNotification object:nil];

        }else{
            [SVProgressHUD showErrorWithStatus:resb.mMessage];

        }
        
    }];
    
}


- (IBAction)chooseBankCodeMethod:(UIButton *)sender {
    BankTVC *hhh = [[BankTVC alloc] init];
    hhh.chooseCallBack = ^(BankObject* item) {
        self.chooseBankItem = item;
        [self.bankCodeBtn setTitle:item.bankCard.length>0 ? item.bankCard : @"请选择银行卡" forState:UIControlStateNormal];
    };
    [self pushViewController:hhh];
}

@end
