//
//  TTSWordViewController.m
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 9. 20..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TTSWordViewController.h"
#import "myCommon.h"
#import "TTSWordTableCell.h"
#import "DicListCell.h"
#import "SVProgressHUD.h"

@interface TTSWordViewController ()

@end

@implementation TTSWordViewController

@synthesize cntOfRepeatWord, cntOfRepeatAlphbet, cntOfRepeatMeaning, strFullContents;
@synthesize txtViewOne, tblOption, oriFrameOfTextView, arrWords, dicWords;
@synthesize blnShowOption;

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
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.title = NSLocalizedString(@"Text to Speech", @"");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //    UIPasteboard *board = [UIPasteboard generalPasteboard];
    //    txtViewOne.text = board.string;
    //    if ([txtViewOne.text length] == 0) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Select all texts and tap \"Speak\" menu", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert show];
//    dicWords = [[NSMutableDictionary alloc] init];
    arrWords = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TBL_EngDic_BookTemp];
    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:arrWords byDic:nil openMyDic:OPEN_DIC_DB];
    
    DLog(@"dicWords : %@", dicWords);
    
    cntOfRepeatWord = 3;
    cntOfRepeatAlphbet = 2;
    cntOfRepeatMeaning = 1;
    oriFrameOfTextView = CGRectMake(0, 0, appWidth, appHeight - naviBarHeight);
    
    [self makeTextToSpeech];
    [txtViewOne becomeFirstResponder];
        
    blnShowOption = FALSE;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (void) changeOption
{
    if (blnShowOption == FALSE) {
        //옵션을 보여준다.
        blnShowOption = TRUE;
        [self.view bringSubviewToFront:tblOption];
        tblOption.frame = CGRectMake(0, appHeight, appWidth, tblOption.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        tblOption.frame = CGRectMake(0, 0, appWidth, tblOption.frame.size.height);
        [UIView commitAnimations];
        

    } else {
        blnShowOption = FALSE;
        tblOption.frame = CGRectMake(0, 0, appWidth, tblOption.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        tblOption.frame = CGRectMake(0, appHeight, appWidth, tblOption.frame.size.height);
        [UIView commitAnimations];
        [SVProgressHUD showProgress:-1 status:@""];        
        [self makeTextToSpeech];
    }
}



#pragma mark -
#pragma mark NSNotification methods
- (void) keyboardWillShow : (NSNotification*) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewOne.frame]);
    DLog(@"keyboardSize.height : %f", keyboardSize.height);
    NSTimeInterval animationDuration = 0.300000011920929;
    
    CGRect frame = oriFrameOfTextView;
    //    frame.origin.y -= keyboardSize.height;
    frame.size.height -= keyboardSize.height;
    //    frame.size.height += tabBarOne.frame.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.txtViewOne.frame = frame;
    [UIView commitAnimations];
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewOne.frame]);
    [txtViewOne resignFirstResponder];
}

- (void) keyboardWillHide : (NSNotification*) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewOne.frame]);
    DLog(@"keyboardSize.height : %f", keyboardSize.height);
    NSTimeInterval animationDuration = 0.300000011920929;
    
    CGRect frame = self.txtViewOne.frame;
    //    frame.origin.y += keyboardSize.height;
    frame.size.height += keyboardSize.height;
    //    frame.size.height -=tabBarOne.frame.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.txtViewOne.frame = frame;
    [UIView commitAnimations];
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewOne.frame]);
    //    blnShowKeyboard = FALSE;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	TTSWordTableCell * cell = (TTSWordTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"TTSWordTableCell" owner:nil options:nil];
		cell = [arr	objectAtIndex:0];
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.lblTitle.text = NSLocalizedString(@"Word", @"");
        cell.stepperOne.minimumValue = 1;
        cell.stepperOne.maximumValue = 3;
        cell.stepperOne.value = 1;
//        cntOfRepeatWord = cell.stepperOne.value;
        NSInteger intRepeatTime = cell.stepperOne.value;
        if (intRepeatTime > 1) {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d times", @""), intRepeatTime];
        } else {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d time", @""), intRepeatTime];
        }
        BOOL blnShow = TRUE;
        cell.switchShow.on = blnShow;
    } else if (indexPath.row == 1) {
        cell.lblTitle.text = NSLocalizedString(@"Alphabet", @"");
        
        cell.stepperOne.minimumValue = 0;
        cell.stepperOne.maximumValue = 2;
        cell.stepperOne.value = 1;
//        cntOfRepeatAlphbet = cell.stepperOne.value;
        
        NSInteger intRepeatTime = cell.stepperOne.value;
        if (intRepeatTime > 1) {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d times", @""), intRepeatTime];
        } else {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d time", @""), intRepeatTime];
        }
        BOOL blnShow = TRUE;
        cell.switchShow.on = blnShow;
        
    } else if (indexPath.row == 2) {
        cell.lblTitle.text = NSLocalizedString(@"Meaning", @"");
        cell.stepperOne.minimumValue = 0;
        cell.stepperOne.maximumValue = 2;
        cell.stepperOne.value = 1;
//        cntOfRepeatMeaning = cell.stepperOne.value;
        
        NSInteger intRepeatTime = cell.stepperOne.value;
        if (intRepeatTime > 1) {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d times", @""), intRepeatTime];
        } else {
            cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d time", @""), intRepeatTime];
        }
        BOOL blnShow = TRUE;
        cell.switchShow.on = blnShow;
    }
    DLog(@"cell.stepperOne.value : %f", cell.stepperOne.value);
     [cell.stepperOne addTarget:self action:@selector(onStepperOne:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void) onStepperOne:(id)sender
{
	UIStepper *stepperOneTemp = (UIStepper*)sender;
    DLog(@"stepperOneTemp : %f", stepperOneTemp.value);
    TTSWordTableCell *cell = (TTSWordTableCell*)[[sender superview] superview];
	//현재선택한 셀의 줄을 가져온다.
	NSIndexPath *indexPath = [tblOption indexPathForCell:cell];
    //    UITableViewCell *cell = (UITableViewCell*)[tblLevel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    if (indexPath.row == 0) {
        if (stepperOneTemp.value < 1) {
            stepperOneTemp.value = 1;
        } else if (stepperOneTemp.value >= 3) {
            stepperOneTemp.value = 3;
//        } else {
//            stepperOneTemp.value++;
        }
        cntOfRepeatWord = stepperOneTemp.value;
    } else if (indexPath.row == 1) {
        if (stepperOneTemp.value < 0) {
            stepperOneTemp.value = 0;
        } else if (stepperOneTemp.value >= 3) {
            stepperOneTemp.value = 3;
//        } else {
//            stepperOneTemp.value++;
        }
        cntOfRepeatAlphbet = stepperOneTemp.value;
    } else if (indexPath.row == 2) {
        if (stepperOneTemp.value < 0) {
            stepperOneTemp.value = 0;
        } else if (stepperOneTemp.value >= 3) {
            stepperOneTemp.value = 3;
//        } else {
//            stepperOneTemp.value++;
        }
        cntOfRepeatMeaning = stepperOneTemp.value;
    }
    cell.stepperOne.value = stepperOneTemp.value;
    NSInteger intRepeatTime = stepperOneTemp.value;
    if (intRepeatTime > 1) {
        cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d times", @""), intRepeatTime];
    } else {
        cell.lblRepeatTimes.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat %d time", @""), intRepeatTime];
    }


}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 71;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    //    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"");

}

- (void)textViewDidEndEditing:(UITextView *)textView
{ 
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if([text isEqualToString:@"\n"])
//    {
        [textView resignFirstResponder];
        return NO;
//    }
//    return YES;
}


- (void) makeTextToSpeech
{
    self.txtViewOne.text = @"";
    NSMutableString *strText = [NSMutableString stringWithString:@""];    
    for(NSInteger i = 0; i < [arrWords count]; ++i) { // *dicOne in dicWords)
        NSMutableDictionary *dicOne = [arrWords objectAtIndex:i];
        DLog(@"dicOne : %@", dicOne);
        NSString    *strWord = [dicOne objectForKey:KEY_DIC_WORD];
        NSString    *strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
        NSInteger intKnow  = [[dicOne objectForKey:KEY_DIC_KNOW] integerValue];
        
        if ( (intKnow == KnowWord_NotSure) || (intKnow == KnowWord_Unknown) || (intKnow == KnowWord_NotRated) ) {            
            for (NSInteger i = 0; i < cntOfRepeatWord; i++) {
                [strText appendString:[NSString stringWithFormat:@"%@\n", strWord]];
            }

            
            for (NSInteger i = 0; i < cntOfRepeatAlphbet; i++) {
                NSMutableString *strAlphabet = [NSMutableString stringWithString:@""];
                for (NSInteger i = 0; i < [strWord length]; i++) {
                    [strAlphabet appendString:[NSString stringWithFormat:@"%@,", [strWord substringWithRange: NSMakeRange(i, 1)]]];
                }
                [strText appendString:[NSString stringWithFormat:@"%@\n", strAlphabet]];
            }
            
            
            if ([strMeaning isEqualToString:@""]) {
                [strText appendString:[NSString stringWithString:[NSString stringWithFormat:NSLocalizedString(@"You need meaning of the word \"%@\"\n", @""), strWord]]];
            } else {
                [strText appendString:[NSString stringWithFormat:@"%@\n", strMeaning]];
                [strText appendString:[NSString stringWithFormat:@"%@\n", strMeaning]];                
            }
            
            NSMutableString *strSentence = [NSMutableString stringWithString:[myCommon getSentenceWithWord:strWord strFullContents:strFullContents]];
            [strText appendString:[NSString stringWithFormat:@"%@\n\n", strSentence]];
        }
        
        DLog(@"strText : %@", strText);
    }
    self.txtViewOne.text = strText;
    [txtViewOne resignFirstResponder];
    
    [SVProgressHUD dismiss];
}
@end
