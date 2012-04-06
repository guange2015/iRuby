//
//  CommController.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@interface CommController : ListViewController<UITableViewDelegate, UITableViewDataSource>

-(void)setLoading:(BOOL)b;


// 开始加载数据
- (void) loadDataBegin;
// 加载数据中
- (void) loadDataing;
// 加载数据完毕
- (void) loadDataEnd;


-(void) loadMoreData;
@end
