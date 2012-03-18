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

@implementation MainFrameC

@synthesize  top_lists;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [top_lists count];
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
    UIViewController *vc = [[PostDetailC alloc]init];
    [APP.nav pushViewController:vc animated:YES];
    [vc release];
}


-(void)loadView {
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-NAV_HEIGHT)] autorelease];
    
    UITableView* t = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    t.delegate = self;
    t.dataSource = self;
    
    self.table = t;
    [t release];
    [self.view addSubview:self.table];
}

-(void)refreshData {
    
    // [SVProgressHUD showInView:self.view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ruby-china.com/api/topics.json"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *l = JSON;
        // 校验收回数据
        if ([l isKindOfClass:[NSArray class]]) {
            DLog(@"list count %d", [l count]);
            self.top_lists = l;
            [self.table reloadData];
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
        
        //[SVProgressHUD dismissWithSuccess:@"Ok!"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
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


@end
