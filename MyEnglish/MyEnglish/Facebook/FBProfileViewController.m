//
//  FBProfileViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "FBProfileViewController.h"
#import "FacebookViewController.h"
#import "UIImageView+Cached.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "FaceBookFeed.h"
#import "User.h"

#define     CELL_ROW_HEIGHT     136
#define     TBL_PAGE_SIZE       20

static NSString *const iTellAFriendiOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/myenglish/id527050097?mt=8";

@interface FBProfileViewController (){
    
    FBFriendsPaginator *fbFriendsPaginator;
    
    UILabel *footerLabel;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation FBProfileViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Log out", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logoutMe:)];
    
    [self setupTableViewFooter];
    fbFriendsPaginator = [[FBFriendsPaginator alloc] initWithPageSize:TBL_PAGE_SIZE delegate:self];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
    _mDict = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setUpTableViewHeader];
}

-(void)setUpTableViewHeader{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    [headerView.layer setBorderColor:[UIColor redColor].CGColor];
//    [headerView.layer setBorderWidth:1.0f];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    button.frame = CGRectMake(20, 20, 280, 30);
    [button setTitle:@"Show Post" forState:UIControlStateNormal];
    [button setTitle:@"Don't Show Post" forState:UIControlStateSelected];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [button setBackgroundImage:[UIImage imageNamed:@"new_reservation.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toggleShowingPost:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    FBProfilePictureView *proImgView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 60, 80, 80)];
    proImgView.profileID = self.user.user_id;
    
    [proImgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [proImgView.layer setBorderWidth:2.0f];
    [headerView addSubview:proImgView];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 214, 32)];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont boldSystemFontOfSize:18.0f];
    userName.adjustsFontSizeToFitWidth = YES;
    userName.textColor = [UIColor blackColor];
    userName.text = [NSString stringWithFormat:@"%@",self.user.name];
    [headerView addSubview:userName];
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(110, 90, 214, 40)];
    location.backgroundColor = [UIColor clearColor];
    location.font = [UIFont boldSystemFontOfSize:12.0f];
    location.adjustsFontSizeToFitWidth = YES;
    location.numberOfLines = 0;
    location.lineBreakMode = NSLineBreakByWordWrapping;
    location.textColor = [UIColor grayColor];
    location.text = [NSString stringWithFormat:@"%@",self.user.location];
    [headerView addSubview:location];
    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeSystem];
    [message.layer setCornerRadius:4.0f];
    [message.layer setMasksToBounds:YES];
    message.frame = CGRectMake(20, 155, 130, 30);
    [message setTitle:@"Message" forState:UIControlStateNormal];
    [message addTarget:self action:@selector(showMessage:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:message];
    
    UIButton *friends = [UIButton buttonWithType:UIButtonTypeSystem];
    [friends.layer setCornerRadius:4.0f];
    [friends.layer setMasksToBounds:YES];
    friends.frame = CGRectMake(170, 155, 130, 30);
    [friends setTitle:@"Friends" forState:UIControlStateNormal];
    [friends addTarget:self action:@selector(showFriends:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:friends];
    
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
    return [fbFriendsPaginator.results count];
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
    
    NSDictionary *friendDict = [fbFriendsPaginator.results objectAtIndex:indexPath.row];
    
    cell.textLabel.text = friendDict[@"name"];
    
    UIImageView	*thumb = (UIImageView*)cell.imageView;
    [thumb loadFromURL:[NSURL URLWithString:friendDict[@"pic_square"]]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)fetchNextPage
{
    [fbFriendsPaginator fetchNextPage];
    [activityIndicator startAnimating];
}

- (void)updateTableViewFooter
{
    footerLabel.text = @"No More Friends";
    [footerLabel setNeedsDisplay];
}

#pragma mark - Paginator delegate methods
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    // update tableview footer
//    [self updateTableViewFooter];
    [activityIndicator stopAnimating];
    
    // update tableview content
    // easy way : call [tableView reloadData];
    // nicer way : use insertRowsAtIndexPaths:withAnimation:
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger i = [fbFriendsPaginator.results count] - [results count];
    
    for(NSDictionary *result in results)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
}

- (void)paginatorDidReset:(id)paginator
{
    [self.tableView reloadData];
//    [self updateTableViewFooter];
}

- (void)paginatorDidFailToRespond:(id)paginator
{
    // Todo
}

#pragma mark - UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    NSLog(@"currentOffset:%d",currentOffset);
    NSLog(@"maximumOffset:%d",maximumOffset);
    // Change 10.0 to adjust the distance from bottom
    if (currentOffset > maximumOffset) {
        if(![fbFriendsPaginator reachedLastPage])
        {
            // fetch next page of results
            [self fetchNextPage];
        }else{
            
            [self updateTableViewFooter];
        }
    }
}

- (void)toggleShowingPost:(id)sender{

    UIButton *button = (UIButton*)sender;
    [button setSelected:!button.selected];
}

- (void)back:(id)sender{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)logoutMe:(id)sender{

    if (FBSession.activeSession.isOpen) {
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        self.user = nil;
    }
}

- (void)showMessage:(id)sender {
    // Query to fetch the active user's friends, limit to 25.
    
   [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    NSString *query = @"SELECT post_id,message,comments,likes,created_time  FROM stream WHERE source_id = me() AND app_id = '236345139854268'";
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  [SVProgressHUD showErrorWithStatus:@"Sorry! there is an error please try again later"];
                              } else {
                                  NSLog(@"Result: %@", result);
                                  // Get the friend data to display
                                  NSArray *streamPosts = (NSArray *) result[@"data"];
                                  [self showStreamPost:streamPosts];
                              }
                          }];
}

- (void)showStreamPost:(NSArray*)streams{

    if (![streams count]) {
        
        [SVProgressHUD showErrorWithStatus:@"No Post Available Now"];
        return;
    }
    NSMutableArray *streamPost = [[NSMutableArray alloc] init];
    [streams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FaceBookFeed *feed =[[FaceBookFeed alloc] initWithDictionaryForOwnPost:(NSDictionary*)obj withUser:self.user];
        
        [streamPost addObject:feed];
    }];
    
    FacebookViewController *fbVC = [[FacebookViewController alloc] initWithNibName:@"FacebookViewController" bundle:nil];
    
    fbVC.posts = streamPost;
    fbVC.isOwnStream = YES;
    [self.navigationController pushViewController:fbVC animated:YES];
    [SVProgressHUD dismiss];
}

- (void)showFriends:(id)sender {
    
    [fbFriendsPaginator fetchFirstPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
