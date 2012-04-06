//
//  MyWebView.m
//  iRuby
//
//  Created by xiaoguang huang on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyWebView.h"

@implementation MyWebView

@synthesize jtarget;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{ 
    CGFloat webViewHeight = 0.0f; 
    if (webView.subviews.count > 0)  
        { 
            UIView *scrollerView = [webView.subviews objectAtIndex:0];//为什么要取第一个？ 
            if (scrollerView.subviews.count > 0)  
                { 
                    UIView *webDocView = scrollerView.subviews.lastObject; 
                    if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) 
                        { 
                            webViewHeight = webDocView.frame.size.height;//获取文档的高度 
                            webView.frame= webDocView.frame; //更新UIWebView 的高度 
                        } 
                } 
        } 
    
    [jtarget.ins performSelector:jtarget.act];
} 

@end
