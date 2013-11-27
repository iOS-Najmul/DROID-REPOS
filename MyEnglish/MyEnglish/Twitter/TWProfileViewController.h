//
//  TWProfileViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWProfileViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic, retain) NSMutableDictionary *mDict;
@property (nonatomic, retain) NSDictionary *tweet;

@end
