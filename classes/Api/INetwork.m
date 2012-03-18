//
//  INetwork.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  通用网络处理

#import "INetwork.h"

static NSString *serverUrl = @"http://ruby-china.com";

@implementation INetwork

@synthesize target;
@synthesize recive_data=_recive_data;

//通用回调接口
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"connect didFail %@",error);
    [target.ins performSelector:target.act withObject:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"didReceiveData %d",[data length]);
    [self.recive_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)respons{
    DLog(@"didReceiveResponse %@",respons);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"connectionDidFinishLoading len = %d", [self.recive_data length]);
    [target.ins performSelector:target.act withObject:self.recive_data];
}

- (void) addTask:(NSString *)url content:(NSData *)content {
    NSMutableURLRequest*  req = [[NSMutableURLRequest new]autorelease];     
	[req setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", serverUrl,url]]];     
    if (content) {
        [req setHTTPMethod:@"POST"];     
        [req setHTTPBody:content];
    } else {
        [req setHTTPMethod:@"GET"];     
    }
	
	[req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

	[req setTimeoutInterval:10.0f];
	NSLog(@"startDownload:>>");
	
    NSMutableData *d = [[NSMutableData alloc]init];
    self.recive_data = d;
    [d release];
	connection=[[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:TRUE];
}


- (void)dealloc {
    [_recive_data release];
    [connection release];
    [super dealloc];
}
@end
