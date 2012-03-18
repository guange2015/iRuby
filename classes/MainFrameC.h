//
//  MainFrameC.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentViewController.h"

@interface MainFrameC : ContentViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *top_lists ;
    
    UITableView *ib_list;
}

@end
