//
//  FBProfileViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBFriendsPaginator.h"

@class User;
@interface FBProfileViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NMPaginatorDelegate,UIScrollViewDelegate>

@property(nonatomic, retain) User *user;
@property(nonatomic, retain) NSMutableDictionary *mDict;

@end
