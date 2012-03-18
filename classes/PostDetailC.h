//
//  PostDetailC.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class MasterPostView;
@interface PostDetailC : ListViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *info;
    MasterPostView *m_cell;
}

@property (nonatomic, retain)NSArray *replies;

-(id)initWhitInfo:(NSDictionary *)d;
@end
