//
//  MyWebView.h
//  iRuby
//
//  Created by xiaoguang huang on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Api.h"
@interface MyWebView : UIWebView<UIWebViewDelegate>

@property (nonatomic,assign) JTarget jtarget;
@end
