//
//  CommentsViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 11/22/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBookFeed.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>

@interface CommentsViewController : UITableViewController<UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) FaceBookFeed *fbFeed;
@property(nonatomic, retain) NSMutableArray *bookmarkPosts;
@property(nonatomic) BOOL isOwnStream;

@end
