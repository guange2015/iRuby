//
//  PostDetailC.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostDetailC.h"
#import "AsyncCell.h"

@implementation PostDetailC


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier =  @"topic cell";
    AsyncCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell = [[AsyncCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topic cell"]; 
    }

    return cell;
}


-(void)loadView {
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44)] autorelease];
    
    UITableView* t = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    t.delegate = self;
    t.dataSource = self;
    
    self.table = t;
    [t release];
    [self.view addSubview:self.table];
}


@end
