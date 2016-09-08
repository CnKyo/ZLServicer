//
//  kitchenViewController.m
//  Chaoer_ContentCanal
//
//  Created by 王钶 on 16/4/1.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

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
#import "QUCustomDefine.h"

@interface kitchenViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation kitchenViewController
{
    mMyHeaderView *mHeaderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Title = self.mPageName = @"个人中心";
    self.hiddenBackBtn = NO;
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    self.hiddenTabBar = YES;
    self.page = 1;
    
    self.tabBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor greenColor];
    
    [self removeEmptyView];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(handleUserChangeSuccess:)  name:MyUserInfoUpdateSuccessNotification object:nil];

}
- (void)loadData{
    [self.tempArray removeAllObjects];
    NSArray *mArr1 = @[@"接单地区",@"服务类型"];
    NSArray *mArr2 = @[@"我的消息",@"账单记录",@"修改密码", @"提现"];
    [self.tempArray addObject:mArr1];
    [self.tempArray addObject:mArr2];

}
- (void)initView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114) delegate:self dataSource:self];
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
    
    UINib   *nib = [UINib nibWithNibName:@"mMyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
    nib = [UINib nibWithNibName:@"mMyTableViewCell2" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell2"];
    
    mHeaderView = [mMyHeaderView shareView];
    mHeaderView.frame = CGRectMake(0, 0, DEVICE_Width, 200);
    [mHeaderView.mCashBtn addTarget:self action:@selector(withDrawAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:mHeaderView];
    
    UIView *mFooterView = [UIView new];
    mFooterView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
    mFooterView.frame = CGRectMake(0, 0, DEVICE_Width, 60);
    
    UIButton  *mLogoutBtn = [UIButton new];
    mLogoutBtn.frame = CGRectMake(10, 10, DEVICE_Width-20, 40);
    mLogoutBtn.layer.masksToBounds = YES;
    mLogoutBtn.layer.cornerRadius =3;
    mLogoutBtn.backgroundColor = M_CO;
    [mLogoutBtn setTitle:@"退出" forState:0];
    [mLogoutBtn addTarget:self action:@selector(mLogOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [mFooterView addSubview:mLogoutBtn];
    [self.tableView setTableFooterView:mFooterView];
    [self upDatePage];
    
    
}

- (void)upDatePage{

    [self loadData];
    [mHeaderView.mHeader sd_setImageWithURL:[NSURL URLWithString:[mUserInfo backNowUser].mUserImgUrl] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    mHeaderView.mName.text = [mUserInfo backNowUser].mServiceName;
    mHeaderView.mPhone.text = [mUserInfo backNowUser].mPhone;
    mHeaderView.mMoney.text = [NSString stringWithFormat:@"账户余额:¥%.2f元",[mUserInfo backNowUser].mMoney];
    [self.tableView reloadData];
    
}

-(void)handleUserChangeSuccess:(NSNotification *)note
{
    [self upDatePage];
    [self.tableView reloadData];
}

- (void)withDrawAction:(UIButton *)sender{
    cashViewController *hhh = [[cashViewController alloc] initWithNibName:@"cashViewController" bundle:nil];
    [self pushViewController:hhh];
    
//    WithdrawViewController *www = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
//    [self pushViewController:www];
}
- (void)mLogOutAction:(UIButton *)sender{
    [mUserInfo logOut];
    [self gotoLoginVC];
    
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
#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return self.tempArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return nil;
    }else{
    
        UIView *vvv = [UIView new];
        vvv.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
        vvv.frame = CGRectMake(0, 0, DEVICE_Width, 10);
        return vvv;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseCellId = nil;
    
    if (indexPath.section == 0) {
        
        reuseCellId = @"cell1";
        
        mMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
        cell.mName.text = self.tempArray[0][indexPath.row];
        
        if (indexPath.row == 0) {
            cell.mLogo.image = IMG(@"user_jiedan.png");
            cell.mContent.text = [mUserInfo backNowUser].mProvince.length>0 ? [mUserInfo backNowUser].mProvince : @"暂无";
        }else{
            cell.mLogo.image = IMG(@"user_fuwu.png");
            //cell.mContent.text = [mUserInfo backNowUser].mServiceType;
            
            NSMutableString *str = [NSMutableString string];
            mUserInfo *user = [mUserInfo backNowUser];
            if (user.mIsOpenShop )
                [str appendString:@"超市"];
            if (user.mIsOpenMerchant ) {
                if (str.length > 0)
                    [str appendString:@","];
                
                [str appendString:@"报修"];
            }
            if (user.mIsOpenClean ){
                if (str.length > 0)
                    [str appendString:@","];
                [str appendString:@"干洗"];
            }
            cell.mContent.text = str.length>0 ? str : @"暂无";
        }
        
        return cell;

    }else{
        reuseCellId = @"cell2";
        mMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
        cell.mName.text = self.tempArray[1][indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.mLogo.image = IMG(@"user_message.png");
                break;
            case 1:
                cell.mLogo.image = IMG(@"user_bankcardrecord.png");
                break;
            case 2:
                cell.mLogo.image = IMG(@"user_editpassword.png");
                break;
            default:
                break;
        }
        
        if (indexPath.row == 1) {
            cell.mBadge.hidden = YES;
        }else{
            cell.mBadge.hidden = YES;
        }
        
        return cell;
    }
    
        
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else{
        MLLog(@"点击了%ld",(long)indexPath.row);
        if (indexPath.row == 0) {
//            mBankCarViewController *mmm = [[mBankCarViewController alloc] initWithNibName:@"mBankCarViewController" bundle:nil];
//            [self pushViewController:mmm];
            messageViewController *mmm = [[messageViewController alloc] initWithNibName:@"messageViewController" bundle:nil];
            [self pushViewController:mmm];
        }
        else if (indexPath.row == 1) {
            historyViewController *hhh = [[historyViewController alloc] initWithNibName:@"historyViewController" bundle:nil];
            [self pushViewController:hhh];
        }
        else if (indexPath.row == 3) {
            //BankTVC *hhh = [[BankTVC alloc] init];
            cashViewController *hhh = [[cashViewController alloc] initWithNibName:@"cashViewController" bundle:nil];
            [self pushViewController:hhh];
        }
        else{
        
            UIStoryboard *secondStroyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            forgetAndChangePwdView *f =[secondStroyBoard instantiateViewControllerWithIdentifier:@"forget"];
            [self pushViewController:f];
        }
    }
}


@end
