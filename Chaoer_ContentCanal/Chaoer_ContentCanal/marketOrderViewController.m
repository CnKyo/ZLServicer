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
    self.Title = self.mPageName = @"购物订单";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    mType =1;
    [self initView];
    
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.haveHeader = YES;
    self.haveFooter = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"marketOrderTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    mSegmentView = [WKSegmentControl initWithSegmentControlFrame:CGRectMake(0, 165, DEVICE_Width, 40) andTitleWithBtn:@[@"进行中订单",@"已完成订单",@"已取消订单"] andBackgroudColor:[UIColor whiteColor] andBtnSelectedColor:M_CO andBtnTitleColor:M_TextColor1 andUndeLineColor:M_CO andBtnTitleFont:[UIFont systemFontOfSize:15] andInterval:20 delegate:self andIsHiddenLine:NO andType:1];
    
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return mSegmentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (void)WKDidSelectedIndex:(NSInteger)mIndex{
    MLLog(@"点击了%lu",(unsigned long)mIndex);
    
    mType = [[NSString stringWithFormat:@"%ld",(long)mIndex+1] intValue];
    //    [self headerBeganRefresh];
    [self.tableView reloadData];
    
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
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    marketOrderDetailViewController *ddd = [[marketOrderDetailViewController alloc] initWithNibName:@"marketOrderDetailViewController" bundle:nil];
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

}
/**
 *  右边按钮的代理方法
 *
 *  @param cell         cell
 *  @param mOrderStatus 状态
 *  @param IndexPath    索引
 */
- (void)cellWithRightBtnClick:(marketOrderTableViewCell *)cell andOrderStatus:(int)mOrderStatus andIndexPath:(NSIndexPath *)IndexPath{

    
}

@end
