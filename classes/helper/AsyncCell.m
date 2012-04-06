//
//  AsyncCell.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "AsyncCell.h"
#import "DictionaryHelper.h"

#import "UIImageView+AFNetworking.h"

@implementation AsyncCell

@synthesize info;
@synthesize image;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
    {
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
    }
    return self;
}

- (void) prepareForReuse {
	[super prepareForReuse];
    self.image = nil;
}

static UIFont* system14 = nil;
static UIFont* bold14 = nil;
static UIFont* system12 = nil;
static UIFont* bold12 = nil;

+ (void)initialize
{
	if(self == [AsyncCell class])
	{
		system14 = [[UIFont systemFontOfSize:14] retain];
		bold14 = [[UIFont boldSystemFontOfSize:14] retain];
        system12 = [[UIFont systemFontOfSize:14] retain];
        bold12 = [[UIFont boldSystemFontOfSize:14] retain];

	}
}

- (void)dealloc {
    [info release];
    [image release];
    
    [super dealloc];
}


+ (NSDate *)parseRFC3339Date:(NSString *)dateString 
{
    if (dateString.length > 20) {
        dateString = [dateString stringByReplacingOccurrencesOfString:@":"
                                                           withString:@""
                                                              options:0
                                                                range:NSMakeRange(20, dateString.length-20)];
    }
    
    NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfc3339TimestampFormatterWithTimeZone setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:NSChineseCalendar] autorelease]];
    [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *theDate = nil;
    NSError *error = nil; 
    if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
    }
    
    [rfc3339TimestampFormatterWithTimeZone release];
    return theDate;
}

- (void) drawContentView:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
    
    NSDictionary *user = [info dictionaryForKey:@"user"];
    
	
	NSString* text = [info stringForKey:@"title"];
    
    NSString* user_name = [user stringForKey:@"login"];
    
    id x  = [info objectForKey:@"replied_at"];
    
    NSDate *date = [self.class parseRFC3339Date:x];
    
    NSTimeInterval n = [date timeIntervalSinceNow];
    long n1 = (long)ABS(n);
    
    int hour = 0;
    int min = 0;
    if (n1/60/60>0) {
        hour = n1/60/60;
    } else {
        min = n1/60;
    }
    
    NSString* time = [NSString stringWithFormat:@"%d分钟前", min];
    if (hour>0) {
        time = [NSString stringWithFormat:@"%d小时前", n]; //需计算
    }

    NSString *replies_count = [NSString stringWithFormat:@"%d",[[info numberForKey:@"replies_count"] intValue] ];
    
    NSString* last_reply = [NSString stringWithFormat:@"【%@】%@于%@回复",
                            [info stringForKey:@"node_name"],[info stringForKey:@"last_reply_user_login"],time];
	
	CGFloat widthr = self.frame.size.width - 70;
	
	[[UIColor blackColor] set];
	[user_name drawInRect:CGRectMake(63.0, 5.0, widthr, 20.0) withFont:system12 lineBreakMode:UILineBreakModeTailTruncation];
    
    if ([replies_count length]>0) {
        [[UIImage imageNamed:@"reply_count"] drawInRect:CGRectMake(250.0, 5.0, 15.0, 15.0)];
        [[UIColor whiteColor] set];
        CGSize size = [replies_count sizeWithFont:[UIFont systemFontOfSize:10]];
        
        [replies_count drawInRect:CGRectMake(250.0+(15-size.width )/2, 5.0+(15.0-size.height)/2, 15.0, 15.0) withFont:[UIFont systemFontOfSize:10]];
        
        
    }
    
	[[UIColor blackColor] set];
    
	[text drawInRect:CGRectMake(63.0, 25.0, widthr, 20.0) withFont:bold14 lineBreakMode:UILineBreakModeTailTruncation];
    
    [[UIColor grayColor] set];
    [last_reply drawInRect:CGRectMake(63.0, 45.0, widthr, 20.0) withFont:bold12 lineBreakMode:UILineBreakModeTailTruncation];
	
	if (self.image) {
		CGRect r = CGRectMake(5.0, 10.0, 48.0, 48.0);
		[self.image drawInRect:r];
	}
}

- (void) updateCellInfo:(NSDictionary*)_info {
	self.info = _info;
    NSDictionary *user =  [info dictionaryForKey:@"user"];
    NSString *urlString = [user stringForKey:@"avatar_url"];
    

    if (urlString==nil || [urlString length]<=0) {
        urlString = [user stringForKey:@"gravatar_hash"];
        if ([urlString length]<=0) {
            urlString = @"http://gravatar.com/avatar?s=48";
        } else {
            urlString = [NSString stringWithFormat:@"http://gravatar.com/avatar/%@?s=48",
                         urlString
         ];
        }
    }
    
    NSLog(@"avatar_url = %@",urlString);
    
	if (urlString) {
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] success:^(UIImage *requestedImage) {
            self.image = requestedImage;
            [self setNeedsDisplay];
        }];
        [operation start];
    }
}

@end
