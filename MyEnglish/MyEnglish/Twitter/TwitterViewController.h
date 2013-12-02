//
//  TwitterViewController.h
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 4. 21..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "STTwitter.h"

@interface TwitterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tblTweets;
@property (nonatomic, strong) NSArray *arrTweets;
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic) BOOL isOwnStream;

- (void) back;

@end
