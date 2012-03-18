//
//  INetwork.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IosApi.h"

@interface INetwork : NSObject
{
    NSURLConnection *connection;
}


@property (nonatomic,retain)     NSMutableData *recive_data;
@property (nonatomic,assign) JTarget target;

- (void) addTask:(NSString *)url content:(NSData *)content; 

@end
