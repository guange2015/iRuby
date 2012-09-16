//
//  PostDetailC.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommController.h"

@class MasterPostView;
@interface PostDetailC : CommController
{
    
    MasterPostView *m_cell;
}

@property (nonatomic, retain)NSArray *replies;
@property (nonatomic, retain)NSDictionary *info;

-(id)initWhitInfo:(NSDictionary *)d;
@end
