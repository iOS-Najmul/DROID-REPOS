//
//  TwitterCell.h
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 4. 23..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *lblFullName;
@property (nonatomic, strong) IBOutlet UILabel      *lblUserName;
@property (nonatomic, strong) IBOutlet UIWebView    *webViewContent;
@property (nonatomic, strong) IBOutlet UILabel      *lblTime;
@property (nonatomic, strong) IBOutlet UIImageView  *imgUser;

@end
