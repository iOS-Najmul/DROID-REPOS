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

@interface TwitterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    UITabBar       *tabBarOne;
    UITabBarItem   *tabBarItemTweet;
    UITabBarItem   *tabBarItemFriend;
    UITabBarItem   *tabBarItemAboutMe;
    UITableView    *tblTweets;
    NSInteger       intTwitterType;
    NSInteger       intTwitterPeopleType;
    NSInteger               intBeforeTabBarItemTag;    
    NSMutableArray                 *arrTweets;
    NSMutableArray                 *arrFollowers;
    NSMutableDictionary          *dicUserIDs;
    NSMutableDictionary     *dicUserImage;
    NSMutableDictionary     *dicStudyFriends;
    NSMutableDictionary     *dicFollowers;
    NSMutableDictionary     *dicFollowing;
    
    ACAccountStore          *_accountStore;
    ACAccount               *twitterMainAccount;
}

@property (nonatomic, strong)     IBOutlet UITabBar       *tabBarOne;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemTweet;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemFriend; 
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemAboutMe;
@property (nonatomic, strong)     IBOutlet UITableView    *tblTweets;
@property (nonatomic)     NSInteger               intBeforeTabBarItemTag;
@property (nonatomic)     NSInteger       intTwitterType;
@property (nonatomic)     NSInteger       intTwitterPeopleType;
@property (nonatomic, strong)     NSMutableDictionary          *dicUserIDs;
@property (nonatomic, strong) NSMutableArray                 *arrTweets;
@property (nonatomic, strong) NSMutableArray                 *arrFollowers;
@property (nonatomic, strong) NSMutableDictionary           *dicUserImage;
@property (nonatomic, strong) NSMutableDictionary     *dicStudyFriends;
@property (nonatomic, strong) NSMutableDictionary     *dicFollowers;
@property (nonatomic, strong) NSMutableDictionary     *dicFollowing;
@property (nonatomic, strong) ACAccountStore          *_accountStore;
@property (nonatomic, strong) ACAccount               *twitterMainAccount;
-(void) back;

- (void) onBtnTwitter;
- (void) fetchTimelineWithText:(NSString *)text;
- (void) fetchTimelineWithTextWithUserName:(NSString *)text userName:(NSString*)strUserName;
- (void) followOnTwitter;
- (void) fetchData;
//- (void) getStudyFriends;
//- (void) getFollowers;
//- (void) getFollowing;
- (void) getFollowers:(NSInteger)intFindPeopleType screenName:(NSString*)strScreenName;

@end
