//
//  MainFrameC.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainFrameC.h"
#import "SBJson.h"
#import "INetwork.h"
#import "OTopic.h"

@implementation MainFrameC


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [top_lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"topic cell"];  
    
    OTopic * o = [top_lists objectAtIndex:indexPath.row];
    cell.textLabel.text = o.title;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)loadView {
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    ib_list = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    ib_list.delegate = self;
    ib_list.dataSource = self;
    [self.view addSubview:ib_list];
}

-(void)recv_data:(NSData *)data {
    const char * s = (const char *)[data bytes]; 
    NSString *ss = [NSString stringWithUTF8String:s];
    NSArray *l = [ss JSONValue];
    
    // 校验收回数据
    if ([l isKindOfClass:[NSArray class]]) {
        DLog(@"list count %d", [l count]);
        
        [top_lists removeAllObjects];
        for (NSDictionary* d in l) {
            OTopic * o = [OTopic read:d];
            [top_lists addObject:o];
        }
        
        [ib_list reloadData];
    }
    
}

- (id)init {
    DLog(@"init");
    self = [super init];
    if (self) {
        top_lists = [[NSMutableArray alloc]initWithCapacity:20];
        INetwork *inet = [[INetwork alloc]init];
        inet.target = JTargetMake(self, @selector(recv_data:));
        [inet addTask:@"/api/topics.json" content:nil];
        [inet release];
    }
    return self;
}

- (void)dealloc {
    [top_lists release];
    [super dealloc];
}
-(_Bool)hiddenNavigationBar {
    return YES;
}

@end
