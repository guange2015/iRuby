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

@interface MasterPostView : UITableViewCell 
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              info:(NSDictionary *)info;
@end

@implementation MasterPostView
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
info:(NSDictionary *)info
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextView *v = [[UITextView alloc]init];
        v.frame = self.bounds;
        v.editable = NO;
        v.text = [info stringForKey:@"body"];
        [self addSubview:v];
        
        CGRect rc = v.frame;
        rc.size = v.contentSize;
        v.frame =  rc;
        
        rc = self.frame;
        rc.size = v.contentSize;
        self.frame = rc;
        
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
    // [SVProgressHUD showInView:self.view];
    int _id = [[info numberForKey:@"_id"] intValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:
                            [NSString stringWithFormat:@"http://ruby-china.com/api/topics/%d.json",_id]]];
    
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
            
            [self.table reloadData];
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        }
        
        //[SVProgressHUD dismissWithSuccess:@"Ok!"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
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
        info = [d retain];
        
        self.title = [info stringForKey:@"title"];
        
        m_cell = [[MasterPostView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"master post view" info:info];
        
        [self refreshData];
    }
    return self;
}

- (void)dealloc {
    [replies release];
    [m_cell release];
    [info release];
    [super dealloc];
}

-(void)loadView {
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44)] autorelease];
    
    UITableView* t = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    t.delegate = self;
    t.dataSource = self;
    
    self.table = t;
    [t release];
    [self.view addSubview:self.table];
}

@end
