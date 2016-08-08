//
//  fixDetailViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "fixDetailViewController.h"
#import "fixDetailTableViewCell.h"
#import "mFixBottomView.h"
@interface fixDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) GFixOrder *orderItem;
@end

@implementation fixDetailViewController
{
    
    mFixBottomView *mBottomView;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"物业报修订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-124) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"fixDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    mBottomView = [mFixBottomView shareView];
    [self.view addSubview:mBottomView];
    [mBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(@0);
        make.height.offset(@60);
        make.width.offset(DEVICE_Width);
    }];
    
}


- (void)headerBeganRefresh{
    
    self.page = 1;
    
    [[mUserInfo backNowUser] getOrderDetail:[NSString stringWithFormat:@"%i", _baseItem.mId] block:^(mBaseData *resb, GFixOrder *mFixOrder) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        
        if (resb.mSucess) {
            self.orderItem = mFixOrder;
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
    
    return 1;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 530;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseCellId = @"cell";
    
    fixDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    
    
    cell.mName.text = [NSString stringWithFormat:@"服务名称:%@", _orderItem.mClassificationName.length>0 ? _orderItem.mClassificationName : @"暂无"];
    cell.mOrderCode.text = [NSString stringWithFormat:@"订单编号:%@", _orderItem.mOrderCode.length>0 ? _orderItem.mOrderCode : @"暂无"];
    cell.mServiceName.text = [NSString stringWithFormat:@"顾客名称:%@", _orderItem.mMerchantName.length>0 ? _orderItem.mMerchantName : @"暂无"];
    cell.mPhone.text = [NSString stringWithFormat:@"联系电话:%@", _orderItem.tel.length>0 ? _orderItem.tel : @"暂无"];
    cell.mAddress.text = [NSString stringWithFormat:@"联系地址:%@", _orderItem.mAddress.length>0 ? _orderItem.mAddress : @"暂无"];
    cell.mNote.text = [NSString stringWithFormat:@"服务名称:%@", _orderItem.mNote.length>0 ? _orderItem.mNote : @"暂无"];
    cell.mMoney.text = [NSString stringWithFormat:@"维修金额:￥%.2f", _orderItem.mOrderPrice];
    cell.mPromisPrice.text = [NSString stringWithFormat:@"保证金:￥%.2f", _orderItem.mOrderPrice];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
