//
//  FBProfileViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "TWProfileViewController.h"
#import "TwitterViewController.h"
#import "UIImageView+Cached.h"
#import "UIImageView+AsyncAndCache.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

#define     CELL_ROW_HEIGHT     136
#define     TBL_PAGE_SIZE       20

static NSString *const iTellAFriendiOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/myenglish/id527050097?mt=8";

@interface TWProfileViewController (){
    
    IBOutlet UIView *headerView;
    IBOutlet UILabel* lblUserName;
    IBOutlet UILabel* lblTime;
    IBOutlet UILabel* lblFullName;
    
    IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *btnTweet;
    IBOutlet UIButton *btnFollowing;
    IBOutlet UIButton *btFfollowers;
    
    UILabel *footerLabel;
    UIActivityIndicatorView *activityIndicator;
    
    NSArray *followingFollowerList;
}

@end

@implementation TWProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log out", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logoutMe:)];
    
    [self setupTableViewFooter];
    [self getUserInformation];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)getUserInformation{
    
    [self.twitter getUserInformationFor:self.twitter.userName successBlock:^(NSDictionary *user) {
        NSLog(@"user:%@",user);
        [self setUpTableViewHeaderWithUser:user];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Plaese try again later"];
    }];
}

-(void)setUpTableViewHeaderWithUser:(NSDictionary*)user{
    
    lblFullName.text = [user objectForKey:@"name"];
    lblUserName.text = [NSString stringWithFormat:@"@%@",[user objectForKey:@"screen_name"]];
    
    NSURL *url = [NSURL URLWithString:(NSString *)[user objectForKey:@"profile_image_url"]];
    [profilePic setImageURL:url];
    
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    date = [df dateFromString:[user objectForKey:@"created_at"]];
    [df setDateFormat:@"eee MMM dd\nhh:mm a-yy"];
    NSString *dateStr = [df stringFromDate:date];
    lblTime.text = dateStr;
    
    NSString *tweetTitle = [NSString stringWithFormat:@"%@\nTweets",[user objectForKey:@"statuses_count"]];
    [btnTweet setTitle:tweetTitle forState:UIControlStateNormal];
    
    NSString *followingTitle = [NSString stringWithFormat:@"%@\nFollowing",[user objectForKey:@"friends_count"]];
    [btnFollowing setTitle:followingTitle forState:UIControlStateNormal];
    
    NSString *followersTitle = [NSString stringWithFormat:@"%@\nFollowers",[user objectForKey:@"followers_count"]];
    [btFfollowers setTitle:followersTitle forState:UIControlStateNormal];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    footerLabel = label;
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(self.view.frame.size.width/2, 22);
    activityIndicatorView.hidesWhenStopped = YES;
    
    activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    self.tableView.tableFooterView = footerView;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [followingFollowerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
    
    NSDictionary *eachFollower = followingFollowerList[indexPath.row];
    cell.textLabel.text = eachFollower[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@",eachFollower[@"screen_name"]];
    
    NSURL *url = [NSURL URLWithString:(NSString *)[eachFollower objectForKey:@"profile_image_url"]];
    UIImageView *imgView = (UIImageView*)cell.imageView;
    [imgView setImageURL:url];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewFooter
{
    footerLabel.text = @"No More Friends";
    [footerLabel setNeedsDisplay];
}

- (void)toggleShowingPost:(id)sender{

    UIButton *button = (UIButton*)sender;
    [button setSelected:!button.selected];
}

- (void)back:(id)sender{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showStatus:(id)sender {
    
    [self.twitter _getStatusesMentionsTimelineWithCount:@"50"
                                    contributorsDetails:[NSNumber numberWithInteger:0]
                                        includeEntities:[NSNumber numberWithInteger:1]
                                       includeMyRetweet:[NSNumber numberWithInteger:1]
                                           successBlock:^(NSArray *statuses) {
                                               TwitterViewController *twVC = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
                                               twVC.isOwnStream = YES;
                                               twVC.twitter = self.twitter;
                                               twVC.arrTweets = statuses;
                                               [self.navigationController pushViewController:twVC animated:YES];
                                           } errorBlock:^(NSError *error) {
                                               [SVProgressHUD showErrorWithStatus:@"Plaese try again later"];
                                           }];
    
}

- (IBAction)showFollowings:(id)sender {
    
    followingFollowerList = nil;
    [self.twitter getFriendsForScreenName:self.twitter.userName successBlock:^(NSArray *friends) {
        followingFollowerList = friends;
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Plaese try again later"];
    }];
}

- (IBAction)showFollowers:(id)sender {
    
    followingFollowerList = nil;
    [self.twitter getFollowersForScreenName:self.twitter.userName successBlock:^(NSArray *followers) {
       
        followingFollowerList = followers;
        [self.tableView reloadData];
        
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Plaese try again later"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
