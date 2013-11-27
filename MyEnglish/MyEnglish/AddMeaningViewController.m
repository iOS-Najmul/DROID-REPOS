//
//  AddMeaningViewController.m
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 7. 10..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "AddMeaningViewController.h"
#import "myCommon.h"
#import "SVProgressHUD.h"

@interface AddMeaningViewController ()

@end

//#define appWidth [myCommon getWidthDevice]
//#define appHeight [myCommon getHeightDevice]

@implementation AddMeaningViewController

@synthesize intMode;
@synthesize txtViewSetWords, arrSetWordsAndMeaning, tblOne, intTypeSetWordsAndMeaning;
@synthesize arrDocList, blnShowKeyboard, oriFrameOfTextView;
@synthesize actionSheetProgress, progressViewInActionSheet;
@synthesize blnCancelSaveSetWordsAndMeaning;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    blnShowKeyboard = FALSE;
    
    arrSetWordsAndMeaning = [[NSMutableArray alloc] init];
    [self.arrSetWordsAndMeaning addObject:NSLocalizedString(@"Word Meaning", @"")];
    
    oriFrameOfTextView = CGRectMake(0, 0, appWidth, appHeight - naviBarHeight - tabbarHeight);
    [self showSaveBtnAtTextView];
    
    [SVProgressHUD showImage:nil status:NSLocalizedString(@"Place tab between word and meanging", @"")];
}


#pragma mark -
#pragma mark NSNotification methods   
- (void) keyboardWillShow : (NSNotification*) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewSetWords.frame]);
    DLog(@"keyboardSize.height : %f", keyboardSize.height);    
    NSTimeInterval animationDuration = 0.300000011920929;
    
    CGRect frame = oriFrameOfTextView;
    //    frame.origin.y -= keyboardSize.height;
    frame.size.height -= keyboardSize.height;
//    frame.size.height += tabBarOne.frame.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.txtViewSetWords.frame = frame;
    [UIView commitAnimations];
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewSetWords.frame]);   
}

- (void) keyboardWillHide : (NSNotification*) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewSetWords.frame]);
    DLog(@"keyboardSize.height : %f", keyboardSize.height);        
    NSTimeInterval animationDuration = 0.300000011920929;
    
    CGRect frame = self.txtViewSetWords.frame;
    //    frame.origin.y += keyboardSize.height;
    frame.size.height += keyboardSize.height;
//    frame.size.height -=tabBarOne.frame.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.txtViewSetWords.frame = frame;
    [UIView commitAnimations];
    DLog(@"txtViewSetWords.frame : %@", [NSValue valueWithCGRect:txtViewSetWords.frame]);
    blnShowKeyboard = FALSE;   
    
    [self showSaveBtnAtTextView];
    
}


#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Finish", @"") style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) doneEditing:(id)sender
{
    [txtViewSetWords resignFirstResponder];
    
//    if (intMode == intModeLoadText) {
        [self showSaveBtnAtTextView];
//    } else if (intMode == intModeLoadTextATUserDic) {
//        self.navigationItem.rightBarButtonItem = nil;
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory)];
//        self.navigationItem.rightBarButtonItem = rightButton;
//    }
	
}

- (void) showSaveBtnAtTextView
{
    self.navigationItem.rightBarButtonItem = nil;
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveSetWordsAndMeaning)];
    //    self.navigationItem.rightBarButtonItem = rightButton;
    //    [rightButton release];
    
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Open", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		
    
    
    //    self.navigationItem.leftBarButtonItem = nil;
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSetWordsAndMeaning)];
    //    self.navigationItem.leftBarButtonItem = leftButton;
    //    [leftButton release];
}

- (void)selSegControl:(id)sender
{	
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
        self.navigationItem.rightBarButtonItem = nil;
//        intMode = intModeLoadText;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblOne cache:YES];
        [UIView commitAnimations];
        [self.view bringSubviewToFront:tblOne];
        
        [SVProgressHUD showProgress:-1 status:@""];
        
        
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(getBookList:)
                                       userInfo:nil
                                        repeats:NO];
        //		[self onOpenWebDic];
	} else 	if( [sel selectedSegmentIndex] == 1 ){
		[self callSaveWordsAndMeaning];
	}
}

- (void) getBookList:(NSTimer*)sender
{
    [self.arrDocList removeAllObjects];
    NSFileManager *fm = [NSFileManager defaultManager];
    
	NSError *error;
	NSArray *filelist = [fm contentsOfDirectoryAtPath:[myCommon getDocPath] error:&error];
    
    for (NSString *s in filelist){
		NSString *strFileNameExtension = [s pathExtension];
        
        //문서는 txt만을 선택한다.
        if ([[strFileNameExtension uppercaseString] isEqualToString:@"TXT"] == YES) {										           
            [self.arrDocList addObject:s];    
        }        
    }
    
    DLog(@"arrDocList : %@", arrDocList);
    
	[tblOne reloadData];
    [SVProgressHUD dismiss];
}


- (void) updateProgress:(NSNumber*) param  {
	progressViewInActionSheet.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	actionSheetProgress.title = [NSString stringWithFormat:@"%@\n\n",  param];
}

- (void) dismissBtnCancel
{
    blnCancelSaveSetWordsAndMeaning = TRUE;
}

- (void) callSaveWordsAndMeaning
{
    if ([txtViewSetWords.text isEqualToString:@""]) {
        
        NSString *strMsg = [NSString stringWithString:NSLocalizedString(@"There is no word to update dictionary.", @"")];
        [SVProgressHUD showImage:nil status:strMsg]; 
        return;
    }
    
    
    //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to update dictionary", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
    [actionSheetProgress showInView:self.view];
    
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
    //			progressViewInActionSheet.center = CGPointMake(actionSheetProgress.bounds.size.width / 2.0f, actionSheetProgress.bounds.size.height / 2.0f);		
    [actionSheetProgress addSubview:progressViewInActionSheet];
    
    UIActivityIndicatorView *aivInActionSheet = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aivInActionSheet.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);            
    [aivInActionSheet startAnimating];
    [actionSheetProgress addSubview:aivInActionSheet];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(110, 55, 90, 37);
    btnCancel.center = CGPointMake(self.view.center.x, btnCancel.center.y);
    [btnCancel setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    
    //            btnCancel.backgroundColor = [UIColor blueColor];            
    [btnCancel addTarget:self action:@selector(dismissBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetProgress addSubview:btnCancel];    
    
    blnCancelSaveSetWordsAndMeaning= FALSE;
    actionSheetProgress.hidden = FALSE;
    //	self.actionSheetProgress.title = @"Prepare to Read...\n\n";
    [NSThread detachNewThreadSelector:@selector(saveSetWordsAndMeaning:) toTarget:self withObject:nil];
}
- (void) saveSetWordsAndMeaning:(NSObject*)obj
{
    @autoreleasepool {
        
        //	[self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:@"Preparing to anlayze..." waitUntilDone:YES];
        
        NSString *strWordsAndmMeaningTemp = [NSString stringWithString:txtViewSetWords.text];    
        strWordsAndmMeaningTemp = [strWordsAndmMeaningTemp stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        strWordsAndmMeaningTemp = [strWordsAndmMeaningTemp stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
        NSMutableString *strWordsAndmMeaning = [NSMutableString stringWithString:strWordsAndmMeaningTemp];
        NSArray *arrWordsAndmMeaning = [strWordsAndmMeaning componentsSeparatedByString:@"\n"];
        NSMutableArray *arrLOG = [[NSMutableArray alloc] init];
        for (NSInteger intIndex = 0; intIndex < [arrWordsAndmMeaning count]; ++intIndex) {
            float	fVal = (intIndex+1) / ((float)[arrWordsAndmMeaning count]);
            
            NSString *strMsg = [NSString stringWithFormat:@"(%d/%d) Update words... %@", intIndex+1, [arrWordsAndmMeaning count], [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            
            if (blnCancelSaveSetWordsAndMeaning == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled updating dictionary.", @"")];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            
            self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", intIndex, [arrWordsAndmMeaning count]];
            NSString *strOneLineTemp = [arrWordsAndmMeaning objectAtIndex:intIndex];
            strOneLineTemp = [strOneLineTemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([strOneLineTemp isEqualToString:@""]) {
                [arrLOG addObject:strOneLineTemp];
                continue;
            }
            NSMutableString *strOneLine = [NSMutableString stringWithString:strOneLineTemp];
            NSInteger countOfTab = [strOneLine replaceOccurrencesOfString:@"\t" withString:@"\t"
                                                                  options:NSLiteralSearch range:NSMakeRange(0, [strOneLine length])];
            if (intTypeSetWordsAndMeaning == intTypeSetWordsAndMeaning_Unknonw_Word) {
                //단어의 아는정도와 단어를 등록한다
                if (countOfTab == 1) {
                    NSArray *arrOne = [strOneLine componentsSeparatedByString:@"\t"];
                    NSString *strKnow = [arrOne objectAtIndex:0];
                    strKnow = [strKnow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    if ([myCommon blnProperStrKnow:strKnow] == FALSE) {
                        //strUnknown이 X?!- 가 아니면 단어 추가를 안하고 로그를 남겨준다.
                        [arrLOG addObject:strOneLine];
                        continue;
                    }
                    NSString *strWord = [arrOne objectAtIndex:1];
                    strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                    
                    NSString *strKnowNumber = [myCommon getStrKnowNumberFromStrKnow:strKnow];
                    
                    NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_Know, strKnowNumber, FldName_Word, strWordForSQL];
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //업데이트가 안되면 단어가 없으므로 단어를 추가한다.
                        DLog(@"%@ is not in dic", strWord);
                        strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES('%@','%@', '', '', '', 0, 99)",TBL_EngDic, FldName_Word, FldName_Know, FldName_Meaning, FldName_DESC, FldName_WORDORI, FldName_ToMemorize, FldName_WORDLEVEL1, strWordForSQL, strKnowNumber];
                        if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                            //단어 추가가 안되면 로그를 남겨준다.
                            [arrLOG addObject:strOneLine];
                        }
                    }
                } else {
                    //tab이 하나가 아니면 추가하지 않고, 로그를 남긴다.
                    [arrLOG addObject:strOneLine];                
                }
            } else if (intTypeSetWordsAndMeaning == intTypeSetWordsAndMeaning_Word_Meaning) {
                //단어와 뜻을 등록한다.
                if (countOfTab >= 1) {
                    NSArray *arrOne = [strOneLine componentsSeparatedByString:@"\t"];
                    NSString *strWord = [arrOne objectAtIndex:0];
                    strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                    NSString *strMeaningForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:[arrOne objectAtIndex:1]];
                    strMeaningForSQL = [strMeaningForSQL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@';", FldName_WORDORI, TBL_EngDic, FldName_Word, strWordForSQL ];
                    
                    NSString *strWordOriForSQL =[myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[myCommon GetOriWordOnlyIfExistInTbl:strWord]];
                    
                    strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@';", FldName_WORDORI, TBL_EngDic, FldName_Word, strWordOriForSQL ];
                    
                    NSString *strWordOriMeaning = [myCommon getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
                    if ([strWordOriMeaning isEqualToString:@""]) {
                        //단어원형의 뜻이 없으면 원형의 뜻으로 넣는다.
                        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_Meaning, strMeaningForSQL, FldName_Word, strWordOriForSQL];
                    } else {
                        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_Know, strMeaningForSQL, FldName_Word, strWordForSQL];  
                    }
                    
                    if ([myCommon changeRec:strQuery openMyDic:FALSE] == FALSE) {
                        //업데이트가 안되면 단어가 없으므로 단어를 추가한다.
                        DLog(@"%@ is not in dic", strWord);
                        strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@) VALUES('%@','%@','%@')",TBL_EngDic, FldName_Word,FldName_Meaning, FldName_WORDORI, strWordForSQL, strMeaningForSQL, strWordForSQL];
                        if ([myCommon changeRec:strQuery openMyDic:FALSE] == FALSE) {
                            //단어 추가가 안되면 로그를 남겨준다.
                            [arrLOG addObject:strOneLine];
                        }
                    }
                } else {
                    //tab이 하나가 아니면 추가하지 않고, 로그를 남긴다.
                    [arrLOG addObject:strOneLine];                
                }
            }
        }
        
        if ([arrLOG count] == 0) {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%@ : 0", NSLocalizedString(@"Success", @""), [arrWordsAndmMeaning count], NSLocalizedString(@"Fail", @"")];
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%@ : %d", NSLocalizedString(@"Success", @""),[arrWordsAndmMeaning count] - [arrLOG count], NSLocalizedString(@"Fail", @""),[arrLOG count]];
            if ([arrLOG count] == [arrSetWordsAndMeaning count]) {
                strMsg = [NSString stringWithFormat:@"%@ :0\n%d : %@", NSLocalizedString(@"Success", @""),[arrLOG count], NSLocalizedString(@"Fail", @"")];
            }
            
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];        
        }
        DLog(@"arrLOG : %@", arrLOG);
        
        self.navigationItem.title = @"";
        
        //	self.self.navigationItem.title = strTitle;		
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress.hidden = TRUE;
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;
	}
    
}

- (void) cancelSetWordsAndMeaning
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblOne cache:YES];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrSetWordsAndMeaning count];
}


static NSString *CellIdentifierSetWordsAndMeaning  = @"CellSetWordsAndMeaning ";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    //tableViewLevel에 해당되는 단어의 아는정도를 한번에 조정한다.
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setLocale:locale];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSetWordsAndMeaning];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierSetWordsAndMeaning];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    NSString *strTitle = [self.arrSetWordsAndMeaning objectAtIndex:indexPath.row];
    cell.textLabel.text = strTitle;
    cell.detailTextLabel.text = @"Place tab between word and meanging";

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath : %d", indexPath.row);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    
    DLog(@"indexPath : %d", indexPath.row);

    //        [self.view bringSubviewToFront:txtViewSetWords];     
    [self.view bringSubviewToFront:txtViewSetWords];
    //        [self.view bringSubviewToFront:tblLevel];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.txtViewSetWords cache:YES];        
    //        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];        
    //        [tblLevel removeFromSuperview];
    //        [self.view addSubview:txtViewSetWords];
    //        [self.view sendSubviewToBack:tblLevel];
    //[self.view bringSubviewToFront:txtViewSetWords];        
    
    [UIView commitAnimations];
    
    
    [self showSaveBtnAtTextView];
    
    if (indexPath.row == 0) {
        intTypeSetWordsAndMeaning = intTypeSetWordsAndMeaning_Unknonw_Word;
    } else if (indexPath.row == 1) {
        intTypeSetWordsAndMeaning = intTypeSetWordsAndMeaning_Word_Meaning;
    } else if (indexPath.row == 2) {
        //            intTypeSetWordsAndMeaning = intTypeSetWordsAndMeaning_Unknonw_Word_Meaning;
    }
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
