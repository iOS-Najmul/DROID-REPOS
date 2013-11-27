//
//  TwitterViewController.m
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 4. 21..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "TwitterViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "myCommon.h"
#import "TwitterCell.h"
#import "UIImageView+AsyncAndCache.h"
#import "TweetsViewController.h"
#import "TWProfileViewController.h"
#import "SVProgressHUD.h"


static NSString *const iTellAFriendiOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/myenglish/id527050097?mt=8";

@interface TwitterViewController (){

    NSURL *handleUrl;
}
@end

@implementation TwitterViewController


@synthesize intBeforeTabBarItemTag;
@synthesize tabBarOne, tabBarItemTweet, tabBarItemFriend, tabBarItemAboutMe;
@synthesize tblTweets, arrTweets, dicUserImage;
@synthesize dicStudyFriends, dicFollowers, dicFollowing;
@synthesize _accountStore, twitterMainAccount;
@synthesize intTwitterType, intTwitterPeopleType;
@synthesize dicUserIDs, arrFollowers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIBarButtonItem *btnFind = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStyleBordered target:self action:@selector(searchOnPost:)];
    UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(newPost:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnNew,btnFind, nil]];
    
    
    intBeforeTabBarItemTag = -1;

    dicUserImage = [[NSMutableDictionary alloc] init];
    dicStudyFriends = [[NSMutableDictionary alloc] init];
    dicFollowers = [[NSMutableDictionary alloc] init];
    dicFollowing = [[NSMutableDictionary alloc] init];
    _accountStore = [[ACAccountStore alloc] init];
    [self getMainAccount];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *btnBookMark = [[UIBarButtonItem alloc] initWithTitle:@"      Favorite      " style:UIBarButtonItemStyleDone target:self action:@selector(showFavoriteOnly:)];
    UIBarButtonItem *btnMe = [[UIBarButtonItem alloc] initWithTitle:@"            Me            " style:UIBarButtonItemStyleDone target:self action:@selector(showMe:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, btnBookMark,btnMe,flexibleSpace, nil]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void) back 
{
	[self.navigationController popViewControllerAnimated:YES];
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (intTwitterType == intTwitterType_Tweets) {
        return [self.arrTweets count] + ([self isEditing]? 1 : 0);
    } else if (intTwitterType == intTwitterType_UserInfo) {
        return [self.arrFollowers count] + ([self isEditing]? 1 : 0);
    }
    return 0;
}

static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    
	TwitterCell * cell = (TwitterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"TwitterCell" owner:nil options:nil];
		cell = [arr	objectAtIndex:0];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }

    NSDictionary *dicOne = [arrTweets objectAtIndex:indexPath.row];

    NSDictionary *dicUser = [dicOne objectForKey:@"user"];
    
    cell.lblFullName.text = [dicUser objectForKey:@"name"];
    cell.lblUserName.text = [NSString stringWithFormat:@"@%@",[dicUser objectForKey:@"screen_name"]];
    [cell.webViewContent loadHTMLString:[dicOne objectForKey:@"text"] baseURL:nil];
    cell.webViewContent.scrollView.scrollEnabled = NO;
    cell.webViewContent.delegate = self;
    
    NSURL *url = [NSURL URLWithString:(NSString *)[dicUser objectForKey:@"profile_image_url"]];   //이미지 url 가져오기
    [cell.imgUser setImageURL:url];
    
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    date = [df dateFromString:[dicOne objectForKey:@"created_at"]];
    [df setDateFormat:@"eee MMM dd\nhh:mm a"];
    NSString *dateStr = [df stringFromDate:date];
    cell.lblTime.text = dateStr;

    return cell;	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetsViewController *tweetVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    
    tweetVC.tweet = [arrTweets objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:tweetVC animated:YES];
}

//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
}

#pragma mark -
#pragma mark Twitters
- (void) onBtnTwitter
{
    Class iOSTwitter = NSClassFromString(@"TWTweetComposeViewController");
    if (iOSTwitter != nil) {        
        if ([iOSTwitter canSendTweet]) {
            ////            [self displayTwitterViewController];
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

            
            [twitter setInitialText:@"Twitter 테스트"];
            
            [self presentModalViewController:twitter animated:YES];
            //            
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
            {
                if (result == TWTweetComposeViewControllerResultCancelled) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Cancel", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                }
                [self dismissModalViewControllerAnimated:YES];
            };
        }
        
    }
}

- (void) fetchTimelineWithText:(NSString *)text
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
    DLog(@"text %@", text);
    DLog(@"urlString %@", urlString);
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:urlString] parameters:nil requestMethod:TWRequestMethodGET];        
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){        
        if ([urlResponse statusCode] == 200) {
            
            NSError *jsonError;
            
            NSDictionary *timelineInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            self.arrTweets = [timelineInfo objectForKey:@"results"];
            
            DLog(@"arrTweets : %@", arrTweets);
            
            [self.view bringSubviewToFront:tblTweets];
            [self.tblTweets reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } else {            
            DLog(@"Twitter Error : %@", [error localizedDescription]);            
        }        
    }];
}
- (void) fetchTimelineWithTextWithUserName:(NSString *)text userName:(NSString*)strUserName
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            DLog(@"accountsArray : %@", accountsArray);
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSString *urlString = @"http://api.twitter.com/1/statuses/home_timeline.json";
//                NSString *urlString = @"http://api.twitter.com/1/statuses/public_timeline.json";    
                DLog(@"strUserName : %@", strUserName);
                if ( (strUserName != nil) && ([strUserName isEqualToString:@""] == FALSE) ) {
                    urlString = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@&include_entities=true", [strUserName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                }
                
                DLog(@"text %@", text);
                DLog(@"urlString %@", urlString);
                
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:urlString] parameters:nil requestMethod:TWRequestMethodGET];       
                [request setAccount:twitterAccount];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){        
                    if ([urlResponse statusCode] == 200) {
                        
                        NSError *jsonError;
                        
            //            NSDictionary *timelineInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            //            DLog(@"timelineInfo : %@", timelineInfo);
                        self.arrTweets = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];

                        
                        DLog(@"arrTweets : %@", arrTweets);
                        
            //            [self.view bringSubviewToFront:tblTweets];
                        [self.tblTweets reloadData];
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                    } else {            
                        DLog(@"Twitter Error : %@", [error localizedDescription]);            
                    }        
                }];
            }
        }
    }];
}

- (void)followOnTwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            DLog(@"accountsArray : %@", accountsArray);
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                DLog(@"twitterAccount : %@", twitterAccount);
                
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"dalnimAppTest3" forKey:@"screen_name"];
                [tempDict setValue:@"false" forKey:@"follow"];
                
                
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict requestMethod:TWRequestMethodPOST];
                
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
//                    DLog(@"%@", output);
                    
                }];
            }
        }
    }];
}

- (void)fetchData
{
    intTwitterType = intTwitterType_Tweets;
    
    [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
//            DLog(@"accountsArray : %@", accountsArray);
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
//                DLog(@"twitterAccount : %@", twitterAccount);
                self.navigationItem.title = twitterAccount.accountDescription;
                TWRequest *postRequest = [[TWRequest alloc]
                                          initWithURL:
                                          [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"]
                                          parameters:nil
                                          requestMethod:TWRequestMethodGET];
                
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData,
                                                         NSHTTPURLResponse *urlResponse,
                                                         NSError *error) {
                    if ([urlResponse statusCode] == 200) {
                        NSError *jsonError = nil;
                        self.arrTweets = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:0
                                                                          error:&jsonError];
//                        DLog(@"arrTweets : %@", arrTweets);
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            [self.tblTweets reloadData];
                            [SVProgressHUD dismiss];
                            
                        });
                    }
                }];
            }
        }
    }];
}

- (void) getMainAccount
{
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];    
    [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [_accountStore accountsWithAccountType:accountType];
            DLog(@"accountsArray : %@", accountsArray);
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                self.twitterMainAccount = [accountsArray objectAtIndex:0];
                DLog(@"twitterMainAccount : %@", twitterMainAccount);
            }
        }
    }];
        
}

- (void) getFollowers:(NSInteger)intFindPeopleType screenName:(NSString*)strScreenName
{
//    DLog(@"twitterMainAccount : %@", twitterMainAccount.userName);
    intTwitterType = intTwitterType_UserInfo;
    if (strScreenName == NULL) {
        strScreenName = [NSString stringWithFormat:@"%@", twitterMainAccount.username];
    }
//    NSMutableArray *arrUserIDs = [[NSMutableArray alloc] init]; 
    NSString *strFindPeople = [NSString stringWithFormat:@"https://api.twitter.com/1/followers/ids.json?cursor=-1&screen_name=%@", strScreenName];
    if (intFindPeopleType == intTwitterPeopleType_Friends) {
        strFindPeople = [NSString stringWithFormat:@"https://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=%@", strScreenName];
    }
    TWRequest *postRequest = [[TWRequest alloc]
                              initWithURL:
                              [NSURL URLWithString:strFindPeople]
                              parameters:nil
                              requestMethod:TWRequestMethodGET];
    
    [postRequest setAccount:twitterMainAccount];
    [postRequest performRequestWithHandler:^(NSData *responseData,
                                             NSHTTPURLResponse *urlResponse,
                                             NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            self.dicUserIDs = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:&jsonError];
            DLog(@"dicUserIDs : %@", dicUserIDs);
            
            
//        https://api.twitter.com/1/users/lookup.json?screen_name=twitterapi,twitter&include_entities=true 
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSArray *arrOne = [dicUserIDs objectForKey:@"ids"];
                if ([arrOne count] > 0) {
                    NSMutableString *strUserIDS = [NSMutableString stringWithString:@""];
                    
                    DLog(@"arrOne : %@", arrOne);
                    for (NSInteger i = 0; i < [arrOne count]; i++) {
//                        DLog(@"i : %d", i);
//                        DLog(@"[arrOne objectAtIndex:%d] : %@", i, [arrOne objectAtIndex:i]);
                        if ( (i == ([arrOne count] - 1) ) || (i == 99) ) {
                            [strUserIDS appendString:[NSString stringWithFormat:@"%@", [arrOne objectAtIndex:i]]];
                            break;
                        } else {
                            [strUserIDS appendString:[NSString stringWithFormat:@"%@,",[arrOne objectAtIndex:i]]];                
                        }
                    }
                    
                    DLog(@"strUserIDS : %@", strUserIDS);
                    
                    TWRequest *postRequest1 = [[TWRequest alloc]
                                               initWithURL:
                                               [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@&include_entities=true", strUserIDS]]
                                               parameters:nil
                                               requestMethod:TWRequestMethodGET];
                    
                    [postRequest1 setAccount:twitterMainAccount];
                    [postRequest1 performRequestWithHandler:^(NSData *responseData,
                                                              NSHTTPURLResponse *urlResponse,
                                                              NSError *error) {
                        if ([urlResponse statusCode] == 200) {
                            NSError *jsonError = nil;
                            self.arrFollowers = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:0
                                                                                  error:&jsonError];
                            DLog(@"arrFollowers : %@", arrFollowers);
                            
                            
                            //         
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.tblTweets reloadData];
                            });
                        }
                    }];
                }
                
//                [self.tblTweets reloadData];
            });
        }
    }];
    
    

    
}

- (void)newPost:(id)sender{
    
    if (NSClassFromString(@"TWTweetComposeViewController")) {
        
        NSLog(@"Twitter framework is available on the device");

        TWTweetComposeViewController *twitterComposer = [[TWTweetComposeViewController alloc] init];
        [twitterComposer setInitialText:@"What the meaning of"];
        //add Image
        [twitterComposer addImage:[UIImage imageNamed:@"Icon@2x.png"]];
        
        //add Link
        [twitterComposer addURL:[NSURL URLWithString:iTellAFriendiOSAppStoreURLFormat]];
        
        //display the twitter composer modal view controller
        [self presentModalViewController:twitterComposer animated:YES];
        
        //check to update the user regarding his tweet
        twitterComposer.completionHandler = ^(TWTweetComposeViewControllerResult res){
            
            //if the posting is done successfully
            if (res == TWTweetComposeViewControllerResultDone)
            {
                UIAlertView *objAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Tweet successful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [objAlertView show];
            }
            //if posting is done unsuccessfully
            else if(res==TWTweetComposeViewControllerResultCancelled)
            {
                UIAlertView *objAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Tweet unsuccessful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [objAlertView show];
            }
            //dismiss the twitter modal view controller.
            [self dismissModalViewControllerAnimated:YES];
            //[tweetTextField resignFirstResponder];
        };
        
        
    }
    else
    {
        NSLog(@"Twitter framework is not available on the device");
        
        UIAlertView *objAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your device cannot send the tweet now, kindly check the internet connection or make a check whether your device has atleast one twitter account setup" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [objAlertView show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:handleUrl];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *) request navigationType:(UIWebViewNavigationType) navigationType {
    
    handleUrl = [request URL];
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		if ([[handleUrl scheme] isEqualToString:@"http"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait!" message:@"This will open in safari, do you agree?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            
            return NO;
        }
	}
	
	return YES;
}

- (void)showMe:(id)sender{
        
    TWProfileViewController *profileVC = [[TWProfileViewController alloc] initWithNibName:@"TWProfileViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)searchOnPost:(id)sender{
    
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end
