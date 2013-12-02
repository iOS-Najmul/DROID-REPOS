//
//  TwitterViewController.m
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 4. 21..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "TwitterViewController.h"
#include "ViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "myCommon.h"
#import "TwitterCell.h"
#import "UIImageView+AsyncAndCache.h"
#import "TweetsViewController.h"
#import "TWProfileViewController.h"
#import "TWLoginViewController.h"
#import "SVProgressHUD.h"

static NSString *const iTellAFriendiOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/myenglish/id527050097?mt=8";

@interface TwitterViewController (){

    NSURL *handleUrl;
}

@end

@implementation TwitterViewController

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
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (!_isOwnStream){
    
        UIBarButtonItem *btnBookMark = [[UIBarButtonItem alloc] initWithTitle:@"      Favorite      " style:UIBarButtonItemStyleDone target:self action:@selector(showFavoriteOnly:)];
        UIBarButtonItem *btnMe = [[UIBarButtonItem alloc] initWithTitle:@"            Me            " style:UIBarButtonItemStyleDone target:self action:@selector(showMe:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, btnBookMark,btnMe,flexibleSpace, nil]];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.twitter) {
        
        if (!_isOwnStream){
        
            [(ViewController*)self.parentVC setTwitter:self.twitter];
            [self getTimelineAction];
        }
        self.navigationItem.title = [NSString stringWithFormat:@"@%@",self.twitter.userName];
        
    }else{
    
        [self performSelector:@selector(presentLoginSettings) withObject:nil afterDelay:0.4];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)getTimelineAction{
    
    [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    [_twitter getHomeTimelineSinceID:nil
                               count:20
                        successBlock:^(NSArray *statuses) {
                            
                            [SVProgressHUD dismiss];
                            self.arrTweets = statuses;
                            [self.tblTweets reloadData];
                            
                        } errorBlock:^(NSError *error) {
                            [SVProgressHUD showErrorWithStatus:@"Sorry!\nSome Error occur to get tweets, Please try again"];
                        }];
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
//    // Return the number of rows in the section.
//    if (intTwitterType == intTwitterType_Tweets) {
//        return [self.arrTweets count] + ([self isEditing]? 1 : 0);
//    } else if (intTwitterType == intTwitterType_UserInfo) {
//        return [self.arrFollowers count] + ([self isEditing]? 1 : 0);
//    }
    return [self.arrTweets count];
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

    NSDictionary *dicOne = [self.arrTweets objectAtIndex:indexPath.row];

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
    
    tweetVC.tweet = [self.arrTweets objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:tweetVC animated:YES];
}

//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
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

- (void)showFavoriteOnly:(id)sender{

    [self.twitter getFavoritesListWithSuccessBlock:^(NSArray *statuses) {
        self.arrTweets = statuses;
        [self.tblTweets reloadData];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Plaese try again later"];
    }];
}

- (void)showMe:(id)sender{
        
    TWProfileViewController *profileVC = [[TWProfileViewController alloc] initWithNibName:@"TWProfileViewController" bundle:nil];
    
    profileVC.twitter = self.twitter;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)searchOnPost:(id)sender{
    
    
}

-(void)presentLoginSettings{

    TWLoginViewController *twLoginVC = [[TWLoginViewController alloc] initWithNibName:@"TWLoginViewController" bundle:nil];
    twLoginVC.parrentVC = self;
    [self.navigationController pushViewController:twLoginVC animated:YES];
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
