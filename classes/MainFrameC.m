//
//  MainFrameC.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainFrameC.h"
#import "UiLib.h"
#import "AsyncCell.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "PostDetailC.h"

#define NAV_HEIGHT 44
#define ACTIVITY_TAG 0x101
#define MAX_GETPAGE 15

@implementation MainFrameC


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.top_lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier =  @"topic cell";
    AsyncCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell = [[AsyncCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topic cell"]; 
    }
    
    NSDictionary * o = [self.top_lists objectAtIndex:indexPath.row];
    [cell updateCellInfo:o];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * o = [self.top_lists objectAtIndex:indexPath.row];
    NSLog(@"%@",o);
    
    UIViewController *vc = [[PostDetailC alloc]initWhitInfo:o];
    [APP.nav pushViewController:vc animated:YES];
    [vc release];
}


-(NSString *)makeGetUrl {
    NSString *url = [NSString stringWithFormat:@"%@/api/topics.json?page=%d&per_page=%d",APP.serverUrl,
                     lastPage, MAX_GETPAGE];

    return url;
}

-(void)refreshData {
    [self setLoading:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self makeGetUrl]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *l = JSON;
        // 校验收回数据
        if ([l isKindOfClass:[NSArray class]]) {
            self.top_lists = [NSMutableArray arrayWithArray:l];
            
            if ([l count]>0) {
                [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.table reloadData];
                [self loadDataEnd];
            }
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
        
        lastPage ++;
        [self setLoading:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
        [self setLoading:NO];
    }];
    [operation start];
}

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
    [self refreshData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活跃帖子";
    
    lastPage = 1;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self refreshData];
}


- (void)dealloc {
    [_top_lists release];
    [super dealloc];
}


-(void)loadMoreData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self makeGetUrl]]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *l = JSON;
        // 校验收回数据
        if ([l isKindOfClass:[NSArray class]]) {
            for (NSObject *o in l) {
                [self.top_lists addObject:o];
            }
            
            if ([l count]>0) {
                [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.table reloadData];
                [self loadDataEnd];
            }
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
        lastPage ++;
        [self loadDataEnd];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
        [self loadDataEnd];
    }];
    [operation start];
}

@end
