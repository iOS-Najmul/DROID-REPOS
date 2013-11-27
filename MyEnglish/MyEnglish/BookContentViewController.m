/*
 */

#import "BookContentViewController.h"

@implementation BookContentViewController

@synthesize fileName = fileName_;
@synthesize webView = webView_;

- (id) initWithBook: (NSString *) bookFileName navigationPoint: (NCXNavigationPoint*) navigationPoint
{
	if ((self = [super initWithNibName: @"BookContentViewController" bundle: nil]) != nil) {
		
		self.fileName = bookFileName;
		navigationPoint_ = [navigationPoint retain]; //레퍼런스 카운트 , 1
	}
	return self;
}

- (void) viewDidLoad
{
	
	// Load the content into the view //@"%@/%@/OPS/%@"
	NSString *contentFirst = nil;
	
	NSRange rangeResult = [navigationPoint_.content rangeOfString:@"#"];
	if( rangeResult.location == NSNotFound) {		
		contentFirst = navigationPoint_.content;
	} else {
		contentFirst = [navigationPoint_.content substringToIndex:rangeResult.location];		
	}
	
	NSString* path = [NSString stringWithFormat: @"%@/%@/OEBPS/%@", 
					  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], 
					  self.fileName,
					  contentFirst]; 
	DLog(@"path : %@", path);
	[webView_ loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
}

- (void) dealloc
{	
	[navigationPoint_ release];
	[super dealloc];
}

@end
