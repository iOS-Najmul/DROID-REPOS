//
//  MakeABook.m
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 3. 4..
//  Copyright (c) 2012 dalnimSoft. All rights reserved.
//

#import "MakeABook.h"
#import "BookViewController.h"
#import "myCommon.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@implementation MakeABook

@synthesize txtViewOne, txtFldBookName, oriFrameOfTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;

	
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveOrDone)];
    self.navigationItem.rightBarButtonItem = rightButton;
 
    
    self.navigationItem.title = NSLocalizedString(@"Make a Book", @"");
    
    txtFldBookName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    txtFldBookName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtFldBookName.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtFldBookName.backgroundColor = [UIColor whiteColor];
    
    oriFrameOfTextView = CGRectMake(0, 0, appWidth, appHeight - naviBarHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [SVProgressHUD dismiss];
    [SVProgressHUD showImage:nil status:NSLocalizedString(@"Type or paste text to make a book", @"")];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) saveOrDone
{
    if (self.txtViewOne.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Empty Content Can't Make a Book"];
        return;
    }
    //make a book을 선택했을때...
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FileName", @"") 						
                                                    message:@"\n\n" // 중요!! 칸을 내려주는 역할을 합니다.		   
                                                   delegate:self                                 
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")	   
                                          otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    
    alert.tag = 1;	
    NSString *strDateAndTime = [myCommon getCurrentDatAndTimeForBackup];
    NSString *strYearMonthDay =  [strDateAndTime substringWithRange:NSMakeRange (2, 6)];
    NSString *strHourMinute =  [strDateAndTime substringWithRange:NSMakeRange (8, 4)];
    txtFldBookName.text = [NSString stringWithFormat:@"%@_%@.txt", strYearMonthDay, strHourMinute];

    [alert addSubview:txtFldBookName]; 	
    [alert show];	
}

-(BOOL) makeNewBook
{
	NSString *strFileName = [txtFldBookName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strContents = txtViewOne.text;
    if ([strContents isEqualToString:@""] == FALSE) {

        strFileName = [[myCommon getDocPath] stringByAppendingPathComponent:strFileName];
        DLog(@"strFileName : %@", strFileName);
        
        
        NSError *error;	

        [myCommon setLatestBook:strFileName];
        BOOL ok=[strContents writeToFile:strFileName atomically:NO encoding:NSUTF8StringEncoding error:&error];	
        if(!ok)		
        {		
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Can't make a book.\nCheck file name or memory's space!!!", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];

            DLog(@"Error when writing %@ : %@ _ %@", strFileName, [error localizedDescription], [error localizedFailureReason]);		
            return FALSE;
        } 
        
    } else {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need text to make a book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];

    }
	return TRUE; 
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Save", @"");
            return;
        } else if (buttonIndex == 1) {
            //책이름을 적고 OK를 눌렀을때...
			DLog(@"txtFldBookName : %@", txtFldBookName.text);
            NSString *strFileName = [txtFldBookName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([strFileName isEqualToString:@""] == TRUE) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need file name to make a book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                return;
            } 
            
            if ([[strFileName lowercaseString] hasSuffix:@".txt"] == FALSE) {
                DLog(@"strFileName : %@", strFileName);
                strFileName = [NSString stringWithFormat:@"%@.txt", strFileName];
                txtFldBookName.text = strFileName;
                DLog(@"strFileName : %@", strFileName);                
            }
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:[[myCommon getDocPath] stringByAppendingPathComponent:strFileName]] ) {
                //파일이 존재하면 덮어씌울지 물어본다.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@\n%@", strFileName, NSLocalizedString(@"File already exist.\nReplace it?", @"")]  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];
                alert.tag = 2;
                [alert show];
                return;
            } else {            
                //파일이 없으면 새로 책을 만든다.
                if ([self makeNewBook] == TRUE) {


                    NSString *strFullFileName = [[myCommon getDocPath] stringByAppendingPathComponent:strFileName];
                    DLog(@"strFullFileName : %@", strFullFileName);
                    
                    [SVProgressHUD showProgress:-1 status:@""];
                    [self performSelector:@selector(openMoviePlayerController:) withObject:strFullFileName afterDelay:0.0f]; 

                } 
            }
		} 
	} else if (alertView.tag == 2) {
        //make a new를 할때 파일이 존재할때 덮어씌울지 물어본다.
        if (buttonIndex == 0) {
            //파일을 덮어씌우지 않으면 다시 파일명을 적는 창을 띄운다. (함수로 빼야 한다.)
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FileName", @"") 						
                                                            message:@"\n\n" // 중요!! 칸을 내려주는 역할을 합니다.		   
                                                           delegate:self                                 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")	   
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
			alert.tag = 1;	
            
            NSString *strDateAndTime = [myCommon getCurrentDatAndTimeForBackup];
            NSString *strYearMonthDay =  [strDateAndTime substringWithRange:NSMakeRange (2, 6)];
            NSString *strHourMinute =  [strDateAndTime substringWithRange:NSMakeRange (8, 4)];
            txtFldBookName.text = [NSString stringWithFormat:@"%@_%@.txt", strYearMonthDay, strHourMinute];
			[alert addSubview:txtFldBookName]; 	
			[txtFldBookName becomeFirstResponder]; 
			[alert show];	
        } else if (buttonIndex == 1) {
            //파일을 덮어씌운다. (함수로 빼야 한다.)
            if ([self makeNewBook] == TRUE) {
                NSString *strFileName = [txtFldBookName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([strFileName hasSuffix:@".txt"] == FALSE) {
                    strFileName = [NSString stringWithFormat:@"%@.txt", strFileName];
                }
                NSString *strFullFileName = [[myCommon getDocPath] stringByAppendingPathComponent:strFileName];
                DLog(@"strFullFileName : %@", strFullFileName);
                [SVProgressHUD showProgress:-1 status:@""];
                [self performSelector:@selector(openMoviePlayerController:) withObject:strFullFileName afterDelay:0.0f]; 
            } 
        }
    }
    return;
}

- (void) openMoviePlayerController:(NSString*)strFullFileName
{
    BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    DLog(@"strFullFileName : %@", strFullFileName);
    bookVC.strBookFullFileName = strFullFileName;
    bookVC.intViewType = viewTypeBook;
    bookVC.title = [strFullFileName lastPathComponent];
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark -
#pragma mark NSNotification methods   
- (void)keyboardWillShow:(NSNotification *)aNotification
{
	// the keyboard is showing so resize the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboardRect:%@",NSStringFromCGRect(keyboardRect));
    NSLog(@"self.view.frame:%@",NSStringFromCGRect(self.view.frame));
    
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.size.height -= keyboardRect.size.width;
    }else{
        frame.size.height -= keyboardRect.size.height;
    }
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    NSLog(@"self.view.frame After:%@",NSStringFromCGRect(self.view.frame));
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // the keyboard is hiding reset the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.size.height += keyboardRect.size.width;
    }else{
        frame.size.height += keyboardRect.size.height;
    }
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
//    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{ 
    
}

@end
