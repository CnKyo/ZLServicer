

//
//  messageViewController.m
//  Chaoer_ContentCanal
//
//  Created by Mac on 16/7/15.
//  Copyright © 2016年 zongyoutec.com. All rights reserved.
//

#import "messageViewController.h"
#import "mmgTableViewCell.h"
#import "fixViewController.h"
#import "marketOrderViewController.h"
#import "kitchenViewController.h"
#import "fixDetailViewController.h"

@interface messageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation messageViewController

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"消息";
    self.hiddenlll = YES;
    self.hiddenRightBtn = YES;
    
    self.page = 1;
    
    [self initView];

}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    //    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1.00];
    
        self.haveHeader = YES;
        self.haveFooter = YES;
    
    
    UINib   *nib = [UINib nibWithNibName:@"mmgTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)headerBeganRefresh{

    self.page = 1;
    [[mUserInfo backNowUser] getMsgList:self.page block:^(mBaseData *resb, NSArray *mArr) {
        
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

- (void)footetBeganRefresh{

    self.page ++;
    [[mUserInfo backNowUser] getMsgList:self.page block:^(mBaseData *resb, NSArray *mArr) {
        
        [self headerEndRefresh];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseCellId = nil;
    
    reuseCellId = @"cell";
    mmgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    
    [cell setMMsg:self.tempArray[indexPath.row]];
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GMsgObj *mMsg = self.tempArray[indexPath.row];
    MLLog(@"点击了%ld",(long)indexPath.row);
    
    [[mUserInfo backNowUser] readMsg:mMsg.mId block:^(mBaseData *resb) {
        
        if (resb.mSucess) {
            
            for (GMsgObj *obj in self.tempArray) {
                if (mMsg.mId == obj.mId) {
                    obj.mIsRead = YES;
                }
            }
            [self.tableView reloadData];
            
        }else{
        
            [self showErrorStatus:resb.mMessage];
        }
        
    }];
    

    if ([mMsg.mExtras.mOrderType isEqualToString:@"GX"]) {
        marketOrderViewController *mmm = [[marketOrderViewController alloc] initWithNibName:@"marketOrderViewController" bundle:nil];
        mmm.shopType = kShopType_clean;
        [self pushViewController:mmm];
        
    } else if ([mMsg.mExtras.mOrderType isEqualToString:@"WX"]) {
        fixViewController *fix = [[fixViewController alloc] initWithNibName:@"fixViewController" bundle:nil];
        [self pushViewController:fix];
        
    } else if ([mMsg.mExtras.mOrderType isEqualToString:@"GW"]) {
        marketOrderViewController *mmm = [[marketOrderViewController alloc] initWithNibName:@"marketOrderViewController" bundle:nil];
        mmm.shopType = kShopType_cao;
        [self pushViewController:mmm];
    }

    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GMsgObj *mmsg = self.tempArray[indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[mUserInfo backNowUser] deleteMsg:mmsg.mId block:^(mBaseData *resb) {
            if (resb.mSucess) {
                
                [self.tempArray removeObject:self.tempArray[indexPath.row]];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                
            }else{
            
                [self showErrorStatus:resb.mMessage];
            }
        }];

    }
}



@end
