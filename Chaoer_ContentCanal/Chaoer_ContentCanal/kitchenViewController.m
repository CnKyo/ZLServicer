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
    self.hiddenBackBtn = YES;
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    self.page = 1;
    [self loadData];
    [self initView];

}
- (void)loadData{

    NSArray *mArr1 = @[@"接单地区",@"服务类型"];
    NSArray *mArr2 = @[@"银行卡",@"我的消息",@"账单纪录"];
    [self.tempArray addObject:mArr1];
    [self.tempArray addObject:mArr2];

}
- (void)initView{

    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114) delegate:self dataSource:self];
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
    
//    self.haveHeader = YES;
//    self.haveFooter = YES;
    
    
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
    
}
- (void)withDrawAction:(UIButton *)sender{
    WithdrawViewController *www = [[WithdrawViewController alloc] initWithNibName:@"WithdrawViewController" bundle:nil];
    [self pushViewController:www];
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
        return cell;

    }else{
        reuseCellId = @"cell2";
        mMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
        cell.mName.text = self.tempArray[1][indexPath.row];

        if (indexPath.row == 1) {
            cell.mBadge.hidden = NO;
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
            mBankCarViewController *mmm = [[mBankCarViewController alloc] initWithNibName:@"mBankCarViewController" bundle:nil];
            [self pushViewController:mmm];
        }
        else if (indexPath.row == 1) {
            messageViewController *mmm = [[messageViewController alloc] initWithNibName:@"messageViewController" bundle:nil];
            [self pushViewController:mmm];
        }else{
            historyViewController *hhh = [[historyViewController alloc] initWithNibName:@"historyViewController" bundle:nil];
            [self pushViewController:hhh];
        }
    }
}


@end