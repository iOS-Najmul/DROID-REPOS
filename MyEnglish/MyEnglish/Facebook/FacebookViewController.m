//
//  FacebookViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 10/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "FacebookViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "FacebookCell.h"
#import "FaceBookFeed.h"
#import "myCommon.h"
#import "User.h"
#import "TargetConditionals.h"
#import "FBProfileViewController.h"
#import "CommentsViewController.h"

#define     SNS_ALERT           300
#define     MESSAGE_TAG         200
#define     COMMENT_ALERT       210
#define     CELL_ROW_HEIGHT     136

static NSString *const iTellAFriendiOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/myenglish/id527050097?mt=8";

@interface FacebookViewController (){

    IBOutlet UITableView *myTableView;
    NSString *nextPageFeed;

    BOOL isBookMarkMood;
    NSString *strUnknownWord;
    
    NSURL *handleUrl;
    UIActivityIndicatorView *activityIndicator;
    NSIndexPath *indexPathToComment;
}

@property (nonatomic, weak) IBOutlet FacebookCell *fbCell;
@property (nonatomic, retain) UINib *cellNib;
@property (strong, nonatomic) FBRequestConnection *requestConnection;

- (void)getAllPost;
- (void)requestCompleted:(FBRequestConnection *)connection result:(id)result error:(NSError *)error;

@end

@implementation FacebookViewController

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
    
    self.title = self.user.username;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIBarButtonItem *btnFind = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStyleBordered target:self action:@selector(searchOnPost:)];
    UIBarButtonItem *btnNew = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(newPost:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnNew,btnFind, nil]];
    
    myTableView.rowHeight = CELL_ROW_HEIGHT;
    self.cellNib = [UINib nibWithNibName:@"FacebookCell" bundle:nil];
    
    _bookmarkPosts = [[NSMutableArray alloc] init];
    [self setupTableViewFooter];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!_isOwnStream){

        UIBarButtonItem *btnBookMark = [[UIBarButtonItem alloc] initWithTitle:@"      Bookmarks     " style:UIBarButtonItemStyleDone target:self action:@selector(showBookMarksOlny:)];
        UIBarButtonItem *btnMe = [[UIBarButtonItem alloc] initWithTitle:@"            Me            " style:UIBarButtonItemStyleDone target:self action:@selector(showMe:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, btnBookMark,btnMe,flexibleSpace, nil]];
    }
    [myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (!self.user) {
        if (FBSession.activeSession.isOpen) {
            
            if (!_isOwnStream)
                [self populateUserDetails];
        } else {
            [self performSelector:@selector(presentLoginSettings) withObject:nil afterDelay:0.4];
        }
    }
    
    NSLog(@"streams:%d",[_posts count]);
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(self.view.frame.size.width/2, 22);
    activityIndicatorView.hidesWhenStopped = YES;
    
    activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    myTableView.tableFooterView = footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (isBookMarkMood)?[_bookmarkPosts count]:[_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FacebookCell";
    
    FacebookCell *cell = (FacebookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        [self.cellNib instantiateWithOwner:self options:nil];
		cell = self.fbCell;
		self.fbCell = nil;
    }

    FaceBookFeed *fbFeed;
    if (isBookMarkMood) {
        fbFeed = [_bookmarkPosts objectAtIndex:indexPath.row];
    }else{
        fbFeed = [_posts objectAtIndex:indexPath.row];
    }
    
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (_isOwnStream) {
        [cell.webViewContent loadHTMLString:fbFeed.message baseURL:nil];
        cell.lblLikeComment.text = [NSString stringWithFormat:@"%@ Likes, %@ Comments",fbFeed.likes[@"count"],fbFeed.comments[@"count"]];
        
        date = [NSDate dateWithTimeIntervalSince1970:[fbFeed.created_time integerValue]];
    }else{
    
        if ([fbFeed.type isEqualToString:@"link"]) {
            NSString *contentHtml = [NSString stringWithFormat:@"<html><body><a href='%@'>%@</a></body></html>",fbFeed.link,fbFeed.message];
            [cell.webViewContent loadHTMLString:contentHtml baseURL:nil];
        }else{
            [cell.webViewContent loadHTMLString:fbFeed.message baseURL:nil];
        }
        cell.lblLikeComment.text = [NSString stringWithFormat:@"%d Likes, %d Comments",[fbFeed.likes[@"data"] count],[fbFeed.comments[@"data"] count]];
        
        cell.bookmarkPost.selected = [_bookmarkPosts containsObject:fbFeed];
        
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        date = [df dateFromString:fbFeed.created_time];
    }
    
    cell.webViewContent.scrollView.scrollEnabled = NO;
    cell.webViewContent.delegate = self;
    cell.lblUserName.text = fbFeed.fromName;
    cell.profilePic.profileID = fbFeed.fromID;
    
    [df setDateFormat:@"eee MMM dd\nhh:mm a"];
    NSString *dateStr = [df stringFromDate:date];
    cell.lblTime.text = dateStr;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentsViewController *commentVC = [[CommentsViewController alloc] initWithNibName:@"CommentsViewController" bundle:nil];
    
    FaceBookFeed *fbFeed;
    if (isBookMarkMood) {
        fbFeed = [_bookmarkPosts objectAtIndex:indexPath.row];
    }else{
        fbFeed = [_posts objectAtIndex:indexPath.row];
    }
    commentVC.fbFeed = fbFeed;
    commentVC.bookmarkPosts = _bookmarkPosts;
    commentVC.isOwnStream = _isOwnStream;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)loadNextPageFeed{

    [activityIndicator startAnimating];
    [SVProgressHUD showProgress:-1 status:@"Loading"];
    
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection result:result error:error];
    };
    
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:nil];
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    [connection addRequest:request completionHandler:handler];
    
    // Override the URL using the one passed back in 'next'.
    NSURL *url = [NSURL URLWithString:nextPageFeed];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    connection.urlRequest = urlRequest;
    
    [connection start];
}

- (void)getAllPost {
        
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        // output the results of the request
        [self requestCompleted:connection result:result error:error];
    };
    
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"me/home"];
    NSLog(@"request:%@",request.parameters);
    [newConnection addRequest:request completionHandler:handler];
    
    [self.requestConnection cancel];
    self.requestConnection = newConnection;
    [newConnection start];
}

- (void)requestCompleted:(FBRequestConnection *)connection result:(id)result error:(NSError *)error {
   
    // not the completion we were looking for...
    if (self.requestConnection &&
        connection != self.requestConnection) {
        return;
    }
    
    // clean this up, for posterity
    self.requestConnection = nil;
    
    NSString *text;
    if (error) {
        // error contains details about why the request failed
        text = error.localizedDescription;
        
        [activityIndicator stopAnimating];
        [SVProgressHUD showErrorWithStatus:@"No More Feeds Available Now"];
    } else {
        // result is the json response from a successful request
        NSDictionary *dictionary = (NSDictionary *)result;
        NSLog(@"Dictionary:%@",dictionary);
        NSString *filePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:@"Home.plist"];
        NSLog(@"filePath:%@",filePath);
        [dictionary writeToFile:filePath atomically:YES];
        
        NSArray *feedArray = dictionary[@"data"];
        nextPageFeed = dictionary[@"paging"][@"next"];
        if (!_posts) {
            _posts = [[NSMutableArray alloc] init];
        }
        [feedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *feed = (NSDictionary *)obj;
            
            if (([feed[@"type"] isEqualToString:@"link"])||([feed[@"type"] isEqualToString:@"status"])) {
                FaceBookFeed *fbFeed = [[FaceBookFeed alloc] initWithDictionary:feed];
                [_posts addObject:fbFeed];
            }
        }];
        [myTableView reloadData];
        [SVProgressHUD dismiss];
        [activityIndicator stopAnimating];
    }
}

-(void)presentLoginSettings {
    if (self.settingsViewController == nil) {
        self.settingsViewController = [[FBUserSettingsViewController alloc] init];
#ifdef __IPHONE_7_0
        if ([self.settingsViewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.settingsViewController.edgesForExtendedLayout &= ~UIRectEdgeTop;
        }
#endif
        self.settingsViewController.delegate = self;
    }
    
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
}

- (void)showBookMarksOlny:(id)sender{
    
    UIBarButtonItem *barButton = (UIBarButtonItem*)sender;
    if (!isBookMarkMood) {
        
        if (![_bookmarkPosts count]) {
            [SVProgressHUD showErrorWithStatus:@"You have no bookmark posts"];
            return;
        }
        barButton.title = @"        All Post        ";
    }else{
        
        barButton.title = @"      Bookmarks     ";
    }

    isBookMarkMood = !isBookMarkMood;
    [myTableView reloadData];
}

- (void)showMe:(id)sender{
    
    if (FBSession.activeSession.isOpen) {
    
        FBProfileViewController *profileVC = [[FBProfileViewController alloc] initWithNibName:@"FBProfileViewController" bundle:nil];
        profileVC.user = self.user;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:profileVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
    
        [self presentLoginSettings];
    }
}

-(void)searchOnPost:(id)sender{

    
}

- (void)loadPost:(id)sender{
    
    NSLog(@"Find Post");
    
    if (FBSession.activeSession.isOpen) {
        
        [SVProgressHUD showProgress:-1 status:@"Loading" maskType:SVProgressHUDMaskTypeGradient];
        [self getAllPost];
    }else{
        [self presentLoginSettings];
    }
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        
        NSLog(@"error:%@",error.localizedDescription);
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
}

- (void)newPost:(id)sender{
    
    UIImage *_image = [UIImage imageNamed:@"Icon@2x.png"];
    NSURL *urlToShare = [NSURL URLWithString:iTellAFriendiOSAppStoreURLFormat];
    NSString *title = @"MyEnglish";
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:title
                                                       caption:nil
                                                   description:nil
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               [SVProgressHUD showErrorWithStatus:@"Sorry! there is an error please try again later"];
                                                           } else {
                                                               
                                                               NSLog(@"Post Result:%@\nDescription:%@\nDialogData:%@",call.ID,call.description,call.dialogData);
                                                               [SVProgressHUD showImage:nil status:@"Post Successfully to Your Timeline"];
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:title
                                                                                    image:_image
                                                                                      url:urlToShare
                                                                                  handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            [self performPublishAction:^{
                
                [SVProgressHUD showErrorWithStatus:@"Please Setup Your Facebook Account from Settings > Facebook"];
            }];
        }
    }
}

- (void)populateUserDetails {
   
    [SVProgressHUD showProgress:-1 status:nil maskType:SVProgressHUDMaskTypeGradient];
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 
                 NSDictionary *dictionary = (NSDictionary *)user;
                 NSLog(@"User Dict:%@",dictionary);
                 self.user = [[User alloc] initWithDictionary:dictionary];
                 [self loadPost:nil];
             }
         }];
    }
}

#pragma mark - FBUserSettingsDelegate methods

- (void)loginViewControllerDidLogUserIn:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginViewController:(id)sender receivedError:(NSError *)error{

    [self showAlert:@"Unknown error occured please try again" result:nil error:error];
}

- (void)back:(id)sender{

    [self.navigationController popToRootViewControllerAnimated:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (isBookMarkMood) return;
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset > maximumOffset) {
        [self loadNextPageFeed];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == COMMENT_ALERT) {
        if (buttonIndex == 1) {
            
            UITextView *txtFld = (UITextView*)[alertView viewWithTag:MESSAGE_TAG];
            [self postCommentWithMessage:txtFld.text];
        }
    }else if (alertView.tag == SNS_ALERT){
    
        strUnknownWord = [(UITextView*)[alertView viewWithTag:MESSAGE_TAG] text];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SNS", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Message",@""), NSLocalizedString(@"Twitter",@""), NSLocalizedString(@"Mail",@""), nil];
        actionSheet.tag = ActionSheet_Tag_OpenSNS;
        [actionSheet showInView:self.view];
    }else{
    
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:handleUrl];
        }
    }
}

- (IBAction)likePost:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
    
    NSIndexPath *indexPath = [myTableView indexPathForCell:(UITableViewCell*)[[sender superview] superview]];
    FaceBookFeed *feed = _posts [indexPath.row];
    
    [self performPublishAction:^{
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/likes", feed.feed_id]
                                     parameters:nil
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error)
            {
                [SVProgressHUD showErrorWithStatus:@"Sorry! there is an error please try again later"];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"You Liked the Post Successfully"];
            }
        }];
    }];
    
}

- (void)postCommentWithMessage:(NSString*)message{

    FaceBookFeed *feed = _posts [indexPathToComment.row];
    [self performPublishAction:^{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:message, @"message",
                                       [FBSession activeSession].accessTokenData.accessToken, @"access_token",nil];
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/comments", feed.feed_id]
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (error)
                                  {
                                     [SVProgressHUD showErrorWithStatus:@"Sorry! there is an error please try again later"];
                                  }
                                  else
                                  {
                                      [SVProgressHUD showSuccessWithStatus:@"Comment Posted Successfully"];
                                  }
                              }];
    }];
}

- (IBAction)commentPost:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
    
    indexPathToComment = [myTableView indexPathForCell:(UITableViewCell*)[[sender superview] superview]];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 50, 260, 100)];
    [textView setText:@"Put your comments here"];
    [textView.layer setCornerRadius:6.0];
    [textView becomeFirstResponder];
    textView.keyboardAppearance = UIKeyboardAppearanceAlert;
    textView.tag = MESSAGE_TAG;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Comment:\n\n\n\n\n\n" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Comment",nil];
    
    alert.tag = COMMENT_ALERT;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert addSubview:textView];
    [alert show];
}

- (IBAction)snsPost:(id)sender{
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 50, 260, 100)];
    [textView setText:@"Put your word here"];
    [textView.layer setCornerRadius:6.0];
    [textView becomeFirstResponder];
    textView.keyboardAppearance = UIKeyboardAppearanceAlert;
    textView.tag = MESSAGE_TAG;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SNS:\n\n\n\n\n\n" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"SNS",nil];
    
    alert.tag = SNS_ALERT;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert addSubview:textView];
    [alert show];
}

- (IBAction)bookmarkPost:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
    NSIndexPath *indexPath = [myTableView indexPathForCell:(UITableViewCell*)[[sender superview] superview]];
    
    NSLog(@"indexPath:%d",indexPath.row);
    FaceBookFeed *fbFeed;
    if (isBookMarkMood) {
        fbFeed = [_bookmarkPosts objectAtIndex:indexPath.row];
    }else{
        fbFeed = [_posts objectAtIndex:indexPath.row];
    }
    
    if ([_bookmarkPosts containsObject:fbFeed]) {
        [_bookmarkPosts removeObject:fbFeed];
    }else{
        [_bookmarkPosts addObject:fbFeed];
    }
    
    if (isBookMarkMood) {
        [myTableView reloadData];
    }
    
    NSLog(@"Total Bookmark:%d",[_bookmarkPosts count]);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ActionSheet_Tag_OpenSNS) {
        if (buttonIndex == 0) {
            [self openMessage];
        } else if (buttonIndex == 1) {
            [self openTwitter];
        } else if (buttonIndex == 2) {
            [self openMail];
        }
    }
}

- (void) openMessage
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", strUnknownWord];
		controller.messageComposeDelegate = self;
		[self.navigationController presentViewController:controller animated:YES completion:nil];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			DLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:@"Error" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
        }
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) openMail
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller != NULL) {
        controller.mailComposeDelegate = self;
        
        [controller setSubject:[NSString stringWithFormat: NSLocalizedString(@"SNS", @"")]];
        NSString *body = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", strUnknownWord];
        [controller setMessageBody:body isHTML:YES];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
		UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Mail", @"")	message:NSLocalizedString(@"Success", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert2 show];
    } else if (result == MFMailComposeResultFailed) {
		UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Mail", @"")	message:NSLocalizedString(@"Fail", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert2 show];
    }
	
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark 트위터 관련기능
-(void) openTwitter
{
    NSString *strPost = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", strUnknownWord];
    DLog(@"strPost : %@", strPost);
    [myCommon PostTwitter:strPost image:nil strURL:nil sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
