//
//  BankTVC.m
//  Chaoer_ContentCanal
//
//  Created by 瞿伦平 on 16/8/26.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "BankTVC.h"

@interface BankTVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BankTVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"银行卡";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    self.page = 1;
    
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height) delegate:self dataSource:self];
    //    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
    
    self.haveHeader = YES;
    self.haveFooter = NO;
    
    
    UINib   *nib = [UINib nibWithNibName:@"mmgTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)headerBeganRefresh{
    
    self.page = 1;
    [[mUserInfo backNowUser] getBankInfo:^(mBaseData *resb, NSArray *mArr) {
        
        [self headerEndRefresh];
        [self removeEmptyView];
        [self.tempArray removeAllObjects];
        
        if (resb.mSucess) {
            [self.tempArray addObjectsFromArray:mArr];
            [self.tableView reloadData];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self addEmptyView:nil];
        }
    }];
    
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bankTableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.backgroundColor = [UIColor clearColor];
    }
    BankObject *item = [self.tempArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.bankName.length>0 ? item.bankName : @"暂无";
    cell.detailTextLabel.text = item.bankCard.length>0 ? item.bankCard : @"暂无";
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tempArray.count > indexPath.row &&  self.chooseCallBack!=nil) {
        self.chooseCallBack([self.tempArray objectAtIndex:indexPath.row]);
        [self popViewController];
    }
    
}

@end
