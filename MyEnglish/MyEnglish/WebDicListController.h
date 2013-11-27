//
//  WebDicListController.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 3. 26..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebDicListController : UIViewController<UITabBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    
	NSMutableArray          *arrWebDicLists;
    
	NSString				*strFileNameWebDicListsPlist;
	NSInteger				selWebDicListIndex;
}

@property (nonatomic, strong)	IBOutlet UIView		*viewWebDicList;
@property (nonatomic, strong)	IBOutlet UITableView	*tblWebDicList;
@property (nonatomic, strong)	NSMutableArray		*arrWebDicLists;
@property (nonatomic, strong) 	NSString					*strName;
@property (nonatomic, strong)	NSMutableString				*strURL;
@property (nonatomic, strong) 	NSString					*strFileNameWebDicListsPlist;

- (void) addBookmarkWithName:(NSString*)name andUrl:(NSString*)url;

@end
