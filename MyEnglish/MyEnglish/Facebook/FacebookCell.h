//
//  FacebookCell.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/29/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* lblUserName;
@property (nonatomic, strong) IBOutlet UIWebView* webViewContent;
@property (nonatomic, strong) IBOutlet UILabel* lblTime;
@property (nonatomic, strong) IBOutlet UILabel* lblLikeComment;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;

@property (nonatomic, retain) IBOutlet UIButton *likePost;
@property (nonatomic, retain) IBOutlet UIButton *commentPost;
@property (nonatomic, retain) IBOutlet UIButton *snsPost;
@property (nonatomic, retain) IBOutlet UIButton *bookmarkPost;

@end
