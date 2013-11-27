//
//  TweetsViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 11/22/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "TweetsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncAndCache.h"
#import "SVProgressHUD.h"
#import "myCommon.h"

#define     SNS_ALERT           300
#define     MESSAGE_TAG         200
#define     COMMENT_ALERT       210

@interface TweetsViewController (){

    IBOutlet UIView *headerView;
    IBOutlet UILabel* lblUserName;
    IBOutlet UIWebView* webViewContent;
    IBOutlet UILabel* lblTime;
    
    IBOutlet UILabel* lblFullName;
    IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *likePost;
    
    IBOutlet UIButton *commentPost;
    IBOutlet UIButton *snsPost;
    IBOutlet UIButton *bookmarkPost;
    
    NSString *nextPageComments;
    BOOL isBookMarkMood;
    NSURL *handleUrl;
    UIActivityIndicatorView *activityIndicator;
    
    NSString *strUnknownWord;
    NSMutableArray *comments;
}

@end

@implementation TweetsViewController

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
    
    [self setUpTableViewHeader];
    [self setupTableViewFooter];
}

-(void)setUpTableViewHeader{
    
//    [headerView.layer setBorderColor:[UIColor redColor].CGColor];
//    [headerView.layer setBorderWidth:1.0f];
    
    NSDictionary *dicUser = [self.tweet objectForKey:@"user"];
    
    lblFullName.text = [dicUser objectForKey:@"name"];
    lblUserName.text = [NSString stringWithFormat:@"@%@",[dicUser objectForKey:@"screen_name"]];
    
    NSURL *url = [NSURL URLWithString:(NSString *)[dicUser objectForKey:@"profile_image_url"]];   //이미지 url 가져오기
    [profilePic setImageURL:url];
    
    [webViewContent loadHTMLString:[self.tweet objectForKey:@"text"] baseURL:nil];
    
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    date = [df dateFromString:[self.tweet objectForKey:@"created_at"]];
    [df setDateFormat:@"eee MMM dd\nhh:mm a"];
    NSString *dateStr = [df stringFromDate:date];
    lblTime.text = dateStr;
    
    webViewContent.scrollView.scrollEnabled = NO;
    webViewContent.delegate = self;
    
    self.tableView.tableHeaderView = headerView;
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
    
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITextView *_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    _textView.font = [UIFont systemFontOfSize:14.0];
    NSDictionary *comment = comments[indexPath.row];
    _textView.text = comment[@"message"];
    
    CGRect frame = _textView.frame;
    frame.size.height = _textView.contentSize.height;
    _textView.frame = frame;
    
    float fittingHeight = _textView.contentSize.height + 36;
    
    return (fittingHeight>52)?(fittingHeight):52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    UILabel *lblCTime;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        cell.imageView.image = [UIImage imageNamed:@"dummy_propic.png"];
        
        lblCTime = [[UILabel alloc] initWithFrame:CGRectMake(262, 4, self.view.frame.size.width-52, 24)];
        lblCTime.numberOfLines = 0;
        lblCTime.lineBreakMode = NSLineBreakByWordWrapping;
        lblCTime.font = [UIFont systemFontOfSize:9.0];
        lblCTime.backgroundColor = [UIColor clearColor];
        lblCTime.textColor = [UIColor grayColor];
        [cell addSubview:lblCTime];
    }
    
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    date = [df dateFromString:[self.tweet objectForKey:@"created_at"]];
    [df setDateFormat:@"eee MMM dd\nhh:mm a"];
    NSString *dateStr = [df stringFromDate:date];
    lblCTime.text = dateStr;
    
    return cell;
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

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    CGRect hRect = headerView.frame;
    hRect.size.height = 100 + fittingSize.height;
    headerView.frame = hRect;
    
    [headerView.layer setMasksToBounds:YES];
    self.tableView.tableHeaderView = headerView;
    [self.tableView.tableHeaderView setNeedsDisplay];
    
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
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


- (void)postCommentWithMessage:(NSString*)message{
    
    
}

- (IBAction)replyTweet:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
}

- (IBAction)reTweet:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
    
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

- (IBAction)snsTweet:(id)sender{
    
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

- (IBAction)favoriteTweet:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.isSelected;
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
