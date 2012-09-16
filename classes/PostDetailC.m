//
//  PostDetailC.m
//  iRuby
//
//  Created by xiaoguang huang on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostDetailC.h"
#import "AsyncCell.h"
#import "DictionaryHelper.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "MyWebView.h"
#import "Api.h"

@interface MasterPostView : UITableViewCell {
    MyWebView *web_v;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              info:(NSDictionary *)info;

@property (nonatomic,assign) UITableView* parent;
@end

@implementation MasterPostView
@synthesize parent;

-(void)refresh_web {
    CGRect rc = self.frame;
    rc.size =  web_v.bounds.size;
    self.frame = rc;
    
    [parent reloadData];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
info:(NSDictionary *)info
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        web_v = [[MyWebView alloc]initWithFrame:self.bounds];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
        NSData *myData = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
        
        NSString *content =[[NSString alloc]initWithData:myData encoding:NSUTF8StringEncoding];
        
        NSArray *ary = [content componentsSeparatedByString:@"__BODY__"];
        NSString *body = [NSString stringWithFormat:@"%@%@%@",[ary objectAtIndex:0],
         [info stringForKey:@"body_html"],
         [ary objectAtIndex:1]];
        
        [content release];
        NSLog(@"%@",body);
        [web_v loadHTMLString:body baseURL:nil];
        [self addSubview:web_v];
        
        web_v.jtarget = JTargetMake(self, @selector(refresh_web));        
        UIView *v = web_v;
                
        [v release];
    }
    return self;
}
@end


@interface PostCell : AsyncCell 
@end

@implementation PostCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc]init];

        [label setTag:0x10001];
        
        [self.contentView addSubview:label];
    }
    return self;
}

-(void)updateCellInfo:(NSDictionary *)_info {
    [super updateCellInfo:_info];
    UILabel *label = (UILabel *)[self viewWithTag:0x10001];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    //设置自动行数与字符换行  
    [label setNumberOfLines:0];  
    label.lineBreakMode = UILineBreakModeWordWrap;   
    // 测试字串  
    NSString *s = [self.info stringForKey:@"body"];  
    label.text = s;
    UIFont *font = [UIFont systemFontOfSize:12];  
    label.font = font;
    //设置一个行高上限  
    CGFloat widthr = self.frame.size.width - 70;
    CGSize size = CGSizeMake(widthr,2000);  
    //计算实际frame大小，并将label的frame变成实际大小  
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];  
    label.frame = CGRectMake(63.0, 25.0, labelsize.width, labelsize.height); 
}

- (void) drawContentView:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
    
    NSDictionary *user = [self.info dictionaryForKey:@"user"];
    
    NSString* user_name = [user stringForKey:@"name"];

	CGFloat widthr = self.frame.size.width - 70;
	
	[[UIColor blackColor] set];
	[user_name drawInRect:CGRectMake(63.0, 5.0, widthr, 20.0) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation];
	
	if (self.image) {
		CGRect r = CGRectMake(5.0, 10.0, 48.0, 48.0);
		[self.image drawInRect:r];
	}
}

@end

@implementation PostDetailC

@synthesize replies;

-(CGFloat)tableView:(UITableView *)tableView 
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return m_cell.frame.size.height;
    }
    
    int n = indexPath.row - 1;
    NSDictionary *d = [self.replies objectAtIndex:n];
    
    CGSize size = CGSizeMake(250.00,2000);  
    //计算实际frame大小，并将label的frame变成实际大小  
    CGSize labelsize = [[d stringForKey:@"body"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];  
    
    return 70+labelsize.height;
}

- (NSInteger)tableView:(UITableView *)tableView 
    numberOfRowsInSection:(NSInteger)section {
    return  1 + [self.replies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        m_cell.parent = tableView;
        return m_cell; 
    } 
    
    int n = indexPath.row - 1;
    if (n>=0) {
        NSString *indentifier =  @"post detail cell";
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell==nil) {
            cell = [[PostCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"post detail cell"]; 
        }
        NSDictionary *d = [self.replies objectAtIndex:n];
        [cell updateCellInfo:d];
        return cell;
    }
    
    return nil;
}

-(void)refreshData {
    [self setLoading:YES];
    int _id = [[self.info numberForKey:@"_id"] intValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                            [NSString stringWithFormat:@"http://ruby-china.org/api/topics/%d.json",_id]]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *d = JSON;
        // 校验收回数据
        if ([d isKindOfClass:[NSDictionary class]]) {
            self.replies = [d arrayForKey:@"replies"];
            self.replies = [self.replies sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
                if( [[obj1 numberForKey:@"_id"] intValue] < [[obj2 numberForKey:@"_id"] intValue] )
                    return (NSComparisonResult)NSOrderedDescending;
                else if ([[obj1 numberForKey:@"_id"] intValue] > [[obj2 numberForKey:@"_id"] intValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            if ([self.replies count]>0) {
                [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.table reloadData];
            }
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
            [self setLoading:NO];
        }
        
        //[SVProgressHUD dismissWithSuccess:@"Ok!"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
        [self setLoading:NO];
    }];
    [operation start];
}

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
    [self refreshData];
}

-(id)initWhitInfo:(NSDictionary *)d {
    self = [super init];
    if (self) {
        self.info = d;
        
        self.title = [self.info stringForKey:@"title"];
        
        m_cell = [[MasterPostView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"master post view" info:self.info];

        [self refreshData];
    }
    return self;
}

- (void)dealloc {
    [replies release];
    [m_cell release];
    [_info release];
    [super dealloc];
}



@end
