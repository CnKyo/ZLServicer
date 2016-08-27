//
//  marketOrderViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "marketOrderViewController.h"
#import "marketOrderTableViewCell.h"
#import "marketOrderDetailViewController.h"
#import "BaseHeaderRefresh.h"

@interface marketOrderViewController ()<UITableViewDelegate,UITableViewDataSource,WKSegmentControlDelagate,marketCellDelegate>

@end

@implementation marketOrderViewController
{
    int     mType;
    WKSegmentControl    *mSegmentView;
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_shopType == kShopType_cao) {
        self.Title = self.mPageName = @"购物订单";
    } else if (_shopType == kShopType_clean) {
        self.Title = self.mPageName = @"干洗订单";
    }
    
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    mType =0;
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //self.haveHeader = YES;
    self.haveFooter = YES;
    
    BaseHeaderRefresh *mHeader = [BaseHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerBeganRefresh)];
    mHeader.lastUpdatedTimeLabel.hidden = YES;
    mHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = mHeader;
    
    
    UINib   *nib = [UINib nibWithNibName:@"marketOrderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    mSegmentView = [WKSegmentControl initWithSegmentControlFrame:CGRectMake(0, 165, DEVICE_Width, 40) andTitleWithBtn:@[@"进行中订单",@"已完成订单",@"已取消订单"] andBackgroudColor:[UIColor whiteColor] andBtnSelectedColor:M_CO andBtnTitleColor:M_TextColor1 andUndeLineColor:M_CO andBtnTitleFont:[UIFont systemFontOfSize:15] andInterval:20 delegate:self andIsHiddenLine:NO andType:1];
    
}

- (void)headerBeganRefresh{
    
    self.page = 1;
    
    [[mUserInfo backNowUser] getShoppingOrderList:self.page andState:mType type:_shopType block:^(mBaseData *resb, NSArray *mArr) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            [self.tempArray addObjectsFromArray:mArr];
            [self.tableView reloadData];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self addEmptyView:nil];
        }
        
    }];
    
}

- (void)footetBeganRefresh{
    self.page ++;
    
    [[mUserInfo backNowUser] getShoppingOrderList:self.page andState:mType type:_shopType block:^(mBaseData *resb, NSArray *mArr) {
        
        [self footetEndRefresh];
        [self removeEmptyView];
        
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return mSegmentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (void)WKDidSelectedIndex:(NSInteger)mIndex{
    MLLog(@"点击了%lu",(unsigned long)mIndex);
    
    mType = [[NSString stringWithFormat:@"%ld",(long)mIndex] intValue];
    [self headerBeganRefresh];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 190;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    marketOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    cell.mIndexPath = indexPath;
    cell.delegate = self;
    [cell setMOrder:self.tempArray[indexPath.row]];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GShopOrder *mOrder = self.tempArray[indexPath.row];
    marketOrderDetailViewController *ddd = [[marketOrderDetailViewController alloc] initWithNibName:@"marketOrderDetailViewController" bundle:nil];
    
    ddd.mShopId = mOrder.mShopId;
    ddd.mOrderId = mOrder.mOrderId;
    ddd.shopType = _shopType;
    
    [self pushViewController:ddd];
}
/**
 *  左边按钮的代理方法
 *
 *  @param cell         cell
 *  @param mOrderStatus 状态
 *  @param IndexPath    索引
 */
- (void)cellWithLeftBtnClick:(marketOrderTableViewCell *)cell andOrderStatus:(int)mOrderStatus andIndexPath:(NSIndexPath *)IndexPath{
    
    GShopOrder *mOrder = self.tempArray[IndexPath.row];

    [self showWithStatus:@"正在操作中..."];
    
    [[mUserInfo backNowUser] finishShopOrder:mOrder.mOrderId andShopId:mOrder.mShopId type:_shopType block:^(mBaseData *resb) {
        
        if (resb.mSucess) {
            [self showSuccessStatus:resb.mMessage];
            [self headerBeganRefresh];
        }else{
            
            [self showErrorStatus:resb.mMessage];
            [self headerBeganRefresh];
        }
        
    }];
    
    
}
/**
 *  右边按钮的代理方法
 *
 *  @param cell         cell
 *  @param mOrderStatus 状态
 *  @param IndexPath    索引
 */
- (void)cellWithRightBtnClick:(marketOrderTableViewCell *)cell andOrderStatus:(int)mOrderStatus andIndexPath:(NSIndexPath *)IndexPath{
    
    
    GShopOrder *mOrder = self.tempArray[IndexPath.row];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mOrder.mPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

@end
