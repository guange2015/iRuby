//
//  AppDelegate.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


///// TODO ...........
//1. 数据采用zlib压缩过再来传输
//2. 加入首页缓存机制


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) UINavigationController *nav;

@property (nonatomic,copy) NSString *serverUrl;
@end
