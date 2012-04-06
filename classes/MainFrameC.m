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

@implementation MainFrameC

@synthesize  top_lists;

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
    
    NSDictionary * o = [top_lists objectAtIndex:indexPath.row];
    [cell updateCellInfo:o];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * o = [top_lists objectAtIndex:indexPath.row];
    UIViewController *vc = [[PostDetailC alloc]initWhitInfo:o];
    [APP.nav pushViewController:vc animated:YES];
    [vc release];
}




-(void)refreshData {
    [self setLoading:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ruby-china.org/api/topics.json"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *l = JSON;
        // 校验收回数据
        if ([l isKindOfClass:[NSArray class]]) {
            self.top_lists = l;
            
            if ([l count]>0) {
                [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.table reloadData];
                [self loadDataEnd];
            }
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
        
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
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self refreshData];
}


- (void)dealloc {
    [top_lists release];
    [super dealloc];
}


-(void)loadMoreData {
    
}

@end
