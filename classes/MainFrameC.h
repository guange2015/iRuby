//
//  MainFrameC.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommController.h"

@interface MainFrameC : CommController
{
    int lastPage;
}

@property (nonatomic,retain)NSMutableArray *top_lists ;

@end
