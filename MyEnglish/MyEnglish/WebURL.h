//
//  WebURL.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 21..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebURL : UIViewController<UITabBarDelegate, UITableViewDelegate, UITableViewDataSource> {
	
    NSMutableArray		*arrBookmarks;
	IBOutlet UIView		*viewBookmark;

	IBOutlet UITableView	*tblBookmark;
	NSString				*strName;
	NSMutableString				*strURL;
	NSString					*strFileNameBookmarksPlist;
	NSInteger				selBookmarkIndex;
}

@property (nonatomic, strong)	IBOutlet UIView		*viewBookmark;
@property (nonatomic, strong)	IBOutlet UITableView	*tblBookmark;

@property (nonatomic, strong)	NSMutableArray		*arrBookmarks;
@property (nonatomic, strong) 	NSString					*strName;
@property (nonatomic, strong)	NSMutableString				*strURL;
@property (nonatomic, strong) 	NSString					*strFileNameBookmarksPlist;
@property (nonatomic) 	NSInteger				selBookmarkIndex;

- (void) addBookmarkWithName:(NSString*)name andUrl:(NSString*)url;

@end
