//
//  CommController.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommController.h"

#define NAV_HEIGHT 44
#define ACTIVITY_TAG 0x101
#define T_FOOT_ACTIVITY_TAG 0x102

@implementation CommController


-(void)setLoading:(BOOL)b{
    UIActivityIndicatorView *spinnerView = (UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_TAG];
    if (b) {
        if (spinnerView==nil) {
            spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinnerView setTag:ACTIVITY_TAG];
            spinnerView.hidesWhenStopped = YES;
            spinnerView.bounds = CGRectMake(0, 0, 37, 37);
            [self.view addSubview:spinnerView];
            spinnerView.center = self.view.center;
        }
        [spinnerView startAnimating];
    } else {
        [spinnerView stopAnimating];
    }
}


-(void)loadView {
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-NAV_HEIGHT)] autorelease];
    
    UITableView* t = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [t setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    t.delegate = self;
    t.dataSource = self;
    
    self.table = t;
    [t release];
    [self.view addSubview:self.table];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{    
    // 下拉到最底部时显示更多数据
	if(scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
        {
        [self loadDataBegin];
        }
}


// 创建表格底部
- (void) createTableFooter
{
    self.table.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.table.bounds.size.width, 40.0f)]; 
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];    

    self.table.tableFooterView = tableFooterView;
    
    UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
    [tableFooterActivityIndicator setHidesWhenStopped:YES];
    [tableFooterActivityIndicator setTag:T_FOOT_ACTIVITY_TAG];
    [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.table.tableFooterView addSubview:tableFooterActivityIndicator];
    [tableFooterActivityIndicator release];
}

- (void) loadDataEnd {
    [self createTableFooter];
    UIActivityIndicatorView *tableFooterActivityIndicator = (UIActivityIndicatorView *)[self.table.tableFooterView viewWithTag:T_FOOT_ACTIVITY_TAG];
    [tableFooterActivityIndicator stopAnimating];
}

-(void)loadDataBegin {
    UIActivityIndicatorView *tableFooterActivityIndicator = (UIActivityIndicatorView *)[self.table.tableFooterView viewWithTag:T_FOOT_ACTIVITY_TAG];
    [tableFooterActivityIndicator startAnimating];
    
    if ([self respondsToSelector:@selector(loadMoreData)]) {
        [self loadMoreData];
    }
}

@end
