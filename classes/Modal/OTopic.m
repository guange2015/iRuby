//
//  OTopic.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "OTopic.h"

@implementation OTopic

@synthesize Id=_Id;
@synthesize title=_title;
@synthesize body=_body;
@synthesize body_html=_body_html;
@synthesize created_at=_created_at;
@synthesize updated_at=_updated_at;
@synthesize replied_at=_replied_at;
@synthesize replies_count=_replies_count;
@synthesize node_name=_node_name;
@synthesize node_id=_node_id;
@synthesize last_reply_user_login=_last_reply_user_login;
@synthesize user=_user;


- (void)dealloc {
    [_title release];
    [_body release];
    [_body_html release];
    [_created_at release];
    [_updated_at release];
    [_replied_at release];
    [_node_name release];
    [_last_reply_user_login release];
    [_user release];
    
    [super dealloc];
}

+(OTopic *) read:(NSDictionary *)d  {
    OTopic *obj = [[[OTopic alloc]init]autorelease ];
    obj.id = [[d objectForKey:@"_id"] longValue];
    obj.title = [d objectForKey:@"title"];
    obj.body = [d objectForKey:@"body"];
    obj.body_html = [d objectForKey:@"body_html"];
    obj.created_at = [d objectForKey:@"created_at"];
    obj.updated_at = [d objectForKey:@"updated_at"];
    obj.replied_at = [d objectForKey:@"replied_at"];
    obj.replies_count = [[d objectForKey:@"replies_count"] longValue];
    obj.node_name = [d objectForKey:@"node_name"];
    obj.node_id = [[d objectForKey:@"node_id"] longValue];
    obj.last_reply_user_login = [d objectForKey:@"last_reply_user_login"];
    obj.user  = [d objectForKey:@"user"];
    return obj;
}

-(NSString *)description {
    return  [NSString stringWithFormat:@"_id = %qx\
             title = %@\
             body = %@\
             body_html = %@\
             created_at = %@\
             updated_at = %@\
             replied_at = %@\
             replies_count = %qx\
             node_name = %@\
             node_id = %qx\
             last_reply_user_login = %@\
             user = %@\
             ",self.Id,
             self.title,
             self.body,
             self.body_html,
             self.created_at,
             self.updated_at,
             self.replied_at,
             self.replies_count,
             self.node_name,
             self.node_id,
             self.last_reply_user_login,
             self.user ];
}
@end
