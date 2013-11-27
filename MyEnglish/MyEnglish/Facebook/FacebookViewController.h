//
//  FacebookViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@class User;
@interface FacebookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBUserSettingsDelegate, UINavigationControllerDelegate, UIWebViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>

@property(nonatomic, retain) User *user;
@property(nonatomic) BOOL isOwnStream;
@property(nonatomic, retain) NSMutableArray *posts;
@property(nonatomic, retain) NSMutableArray *bookmarkPosts;
@property (strong, nonatomic) FBUserSettingsViewController *settingsViewController;

@end
