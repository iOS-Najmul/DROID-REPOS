//
//  TWProfileViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"

@interface TWProfileViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, retain) NSDictionary *tweets;

- (IBAction)showStatus:(id)sender;
- (IBAction)showFollowings:(id)sender;
- (IBAction)showFollowers:(id)sender;

@end
