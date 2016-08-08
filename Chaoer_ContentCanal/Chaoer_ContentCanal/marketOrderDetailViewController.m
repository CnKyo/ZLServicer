//
//  marketOrderDetailViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "marketOrderDetailViewController.h"
#import "marketHeaderView.h"
#import "marketOrderDetailTableViewCell.h"
@interface marketOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation marketOrderDetailViewController
{
    
    marketHeaderView *mHeaderView;
    marketHeaderView *mFooterView;
    marketHeaderView *mBottomView;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"购物订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-124) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    self.haveFooter = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"marketOrderDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    mHeaderView = [marketHeaderView shareHeaderView];
    mHeaderView.frame = CGRectMake(0, 0, DEVICE_Width, 190);
    [self.tableView setTableHeaderView:mHeaderView];
    
    mFooterView = [marketHeaderView shareFooterView];
    mFooterView.frame = CGRectMake(0, 0, DEVICE_Width, 250);
    [self.tableView setTableFooterView:mFooterView];
    
    mBottomView = [marketHeaderView shareBottomView];
    [self.view addSubview:mBottomView];
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(@0);
        make.height.offset(@60);
        make.width.offset(DEVICE_Width);
    }];
    
    
}


- (void)headerBeganRefresh{
    
    self.page = 1;
    
    [[mUserInfo backNowUser] getShoppingOrderDetail:@"5" andShopId:@"1" block:^(mBaseData *resb, GFixOrder *mFixOrder) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            //self.orderItem = mFixOrder;
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
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    marketOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    fixDetailViewController *fff = [[fixDetailViewController alloc] initWithNibName:@"fixDetailViewController" bundle:nil];
    //    [self pushViewController:fff];
}

@end
