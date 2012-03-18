//
//  OTopic.h
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInterface.h"

@interface OTopic : NSObject
{
//    jlong _id;
//    NSString *title;
//    NSString *body;
//    NSString *body_html;
//    NSString *created_at;
//    NSString *updated_at;
//    NSString *replied_at;
//    jlong replies_count;
//    NSString *node_name;
//    jlong node_id;
//    NSString *last_reply_user_login;
//    NSString *user;
}


@property (nonatomic, assign)  jlong Id;
@property (nonatomic, retain)  NSString *title;
@property (nonatomic, retain)  NSString *body;
@property (nonatomic, retain)  NSString *body_html;
@property (nonatomic, retain)  NSString *created_at;
@property (nonatomic, retain)  NSString *updated_at;
@property (nonatomic, retain)  NSString *replied_at;
@property (nonatomic, assign)  jlong replies_count;
@property (nonatomic, retain)  NSString *node_name;
@property (nonatomic, assign)  jlong node_id;
@property (nonatomic, retain)  NSString *last_reply_user_login;
@property (nonatomic, retain)  NSString *user;


+(OTopic *) read:(NSDictionary *)d;
@end
