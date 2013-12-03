//
//  TweetsViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 11/22/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "STTwitterAPI.h"

@interface TweetsViewController : UITableViewController<UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) STTwitterAPI *twitter;

@property (nonatomic, retain) NSDictionary *tweet;
@property(nonatomic, retain) NSMutableArray *bookmarkPosts;
@property(nonatomic) BOOL isOwnStream;

- (IBAction)replyTweet:(id)sender;
- (IBAction)reTweet:(id)sender;
- (IBAction)snsTweet:(id)sender;
- (IBAction)favoriteTweet:(id)sender;

@end
