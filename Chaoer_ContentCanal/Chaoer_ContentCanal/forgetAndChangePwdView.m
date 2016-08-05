//
//  forgetAndChangePwdView.m
//  O2O_JiazhengSeller
//
//  Created by 密码为空！ on 15/8/6.
//  Copyright (c) 2015年 zongyoutec.com. All rights reserved.
//

#import "forgetAndChangePwdView.h"
#import "MZTimerLabel.h"

@interface forgetAndChangePwdView ()<UITextFieldDelegate,MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wkPhoneTX;
@property (weak, nonatomic) IBOutlet UITextField *wkCodeTx;
@property (weak, nonatomic) IBOutlet UITextField *wkNewPWD;

@property (weak, nonatomic) IBOutlet UIButton *wkLoginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *mPwdImg;


@property (weak, nonatomic) IBOutlet UIView *wkV1;
@property (weak, nonatomic) IBOutlet UIView *wkV2;
@property (weak, nonatomic) IBOutlet UIView *wkV3;

@end

@implementation forgetAndChangePwdView
{
    UILabel *timer_show;//倒计时label

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];

    self.hiddenlll = YES;
    
    self.mPageName = self.Title = @"修改密码";
    [self.wkLoginBtn setTitle:@"确定修改" forState:0];
       [self initView];

}

- (void)initView
{
    self.wkV1.layer.masksToBounds = YES;
    self.wkV1.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV1.layer.borderWidth = 0.75f;
    self.wkV1.layer.cornerRadius = 5.0f;
    
    self.wkV2.layer.masksToBounds = YES;
    self.wkV2.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV2.layer.borderWidth = 0.75f;
    self.wkV2.layer.cornerRadius = 5.0f;
    
    self.wkV3.layer.masksToBounds = YES;
    self.wkV3.layer.borderColor = [UIColor colorWithHue:0.028 saturation:0.031 brightness:0.757 alpha:1].CGColor;
    self.wkV3.layer.borderWidth = 0.75f;
    self.wkV3.layer.cornerRadius = 5.0f;
    
    
   
    self.wkPhoneTX.delegate = self;
    

    self.wkCodeTx.delegate = self;
    

    self.wkNewPWD.delegate = self;
        
    self.mPwdImg.image = [UIImage imageNamed:@"passwd"];
    self.wkNewPWD.placeholder = @"请输入新密码";

    
    self.wkLoginBtn.layer.masksToBounds = YES;
 
    self.wkLoginBtn.layer.cornerRadius = 3;

    [self.wkLoginBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)LoginAction{
    [self.wkPhoneTX resignFirstResponder];
    [self.wkCodeTx resignFirstResponder];
    [self.wkNewPWD resignFirstResponder];
    MLLog(@"确认修改");
    
    
    if (![Util isMobileNumber:self.wkPhoneTX.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [self.wkPhoneTX becomeFirstResponder];
        return;
    }
    if (self.wkCodeTx.text.length == 0) {
        [self showErrorStatus:@"请输入原密码"];
        [self.wkCodeTx becomeFirstResponder];
        return;
    }
//    if (![self.wkCodeTx.text isEqualToString:[mUserInfo backNowUser].mPwd]) {
//        [self showErrorStatus:@"原密码输入错误"];
//        [self.wkCodeTx becomeFirstResponder];
//        return;
//        
//    }
 
    if (self.wkNewPWD.text.length == 0) {
        [self showErrorStatus:@"请输入新密码"];
        [self.wkNewPWD becomeFirstResponder];
        return;
    }
    [self showWithStatus:@"正在操作中..."];
    [mUserInfo modifyPwd:self.wkPhoneTX.text andOldPwd:self.wkCodeTx.text andNewPwd:self.wkNewPWD.text block:^(mBaseData *resb, mUserInfo *mUser) {
        
        
        if (resb.mSucess) {
            [self showSuccessStatus:resb.mMessage];
            [self popViewController];
        }else{
        
            [self showErrorStatus:resb.mMessage];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -----键盘消失
- (void)tapAction{
    
    [self.wkPhoneTX resignFirstResponder];
    [self.wkCodeTx resignFirstResponder];
    [self.wkNewPWD resignFirstResponder];

}
///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制密码输入长度
#define PASS_LENGHT 20
#define CodeLength 6
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res = 0;
    if (textField.tag==20) {
        res= PASS_LENGHT-[new length];
        
        
    }
    if (textField.tag == 11) {
        res= TEXT_MAXLENGTH-[new length];

    }
    if (textField.tag == 6)
    {
        res= CodeLength-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}
- (void)leftBtnTouched:(id)sender{
    [self popViewController];
}
@end
