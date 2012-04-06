//
//  Api.h
//  iRuby
//
//  Created by xiaoguang huang on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//包装一个对象和一个方法
typedef struct JTarget{
	NSObject * ins;
	SEL act;
}JTarget;

CG_INLINE JTarget JTargetMake(NSObject * ins,SEL act){
	JTarget r={ins,act};
	return r;
    
}

@interface Api : NSObject

@end
