//
//  ShowAndSetLevel.m
//  Ready2Read
//
//  Created by KIM HyungDal on 11. 11. 1..
//  Copyright (c) 2011 dalnimSoft. All rights reserved.
//

#import "ShowAndSetLevel.h"
#import "DicListController.h"
#import "myCommon.h"
#import "FlashCardController.h"
#import "AddMeaningViewController.h"
#import "SVProgressHUD.h"

//#define appWidth [myCommon getWidthDevice]
//#define appHeight [myCommon getHeightDevice]
#define intModeUserLevel 1
#define intModeSetLevel 2
#define intModeSetWordsAndMeaning 3
#define intModeWordsByCategory 4
#define intModeLoadText 5
#define intModeLoadTextATUserDic 6
#define intModeUserDic 7
#define intModeSetDefaultDicUpdate 8

@implementation ShowAndSetLevel
@synthesize tblLevel, viewLevel;
@synthesize arrWordGroup, arrUserLevel, intBeforeTabBarItemTag;
@synthesize intMode, blnLoadUserLevel, blnLoadWordGroup;
@synthesize txtViewSetWords, arrSetWordsAndMeaning, tblOne, intTypeSetWordsAndMeaning;
@synthesize arrDocList, tabBarOne, blnShowKeyboard, oriFrameOfTextView;
@synthesize actionSheetProgress, progressViewInActionSheet;
@synthesize arrUserDic;
@synthesize txtNewCategory, strFieldNameOfNewCategory;
@synthesize tabBarItemMyLevel, tabBarItemWordLevel;
@synthesize intDoWordGroupOrLevelTest;
@synthesize blnCancelSaveSetWordsAndMeaning;
@synthesize tabBarItemAddMeaning, tabBarItemDefaultUpdate;
@synthesize arrSetDefaultUpdateDic;

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

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = NSLocalizedString(@"My Level", @"");
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Level Test", @"") style:UIBarButtonItemStylePlain target:self action:@selector(testUserLevel)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    tabBarItemMyLevel.title = NSLocalizedString(@"My Level", @"");
    tabBarItemWordLevel.title = NSLocalizedString(@"Word Group", @"");
    tabBarItemDefaultUpdate.title = NSLocalizedString(@"Update Dic", @"");
    tabBarItemAddMeaning.title = NSLocalizedString(@"Add Meaning", @"");
    
    intBeforeTabBarItemTag = -1;
    
    arrWordGroup = [[NSMutableArray	alloc] init];
    NSInteger intDicLevelMax = 18;
#ifdef CHINESE
    intDicLevelMax = 12;
#endif
    for (NSInteger i = 1; i < intDicLevelMax; i++)
    {
        NSMutableDictionary *dicLevel1 = [[NSMutableDictionary alloc] init];
        [dicLevel1 setObject:NSLocalizedString(@"Original", @"") forKey:@"SegConSelIndex"];
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"NotRated"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Unknown"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"NotSure"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Known"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Exclude"];        
        [dicLevel1 setObject:[NSString stringWithFormat:@"%d", i] forKey:@"LEVEL"];    
        [arrWordGroup addObject:dicLevel1];
    }

    //사용자가 아는 단어를 보여준다.
    arrUserLevel = [[NSMutableArray	alloc] init];
    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [dicOne setObject:[NSString stringWithFormat:@"%@", NSLocalizedString( @"All Words", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne];

    NSMutableDictionary *dicOne1 = [[NSMutableDictionary alloc] init];
    [dicOne1 setObject:[NSString stringWithFormat:@"NR : %@", NSLocalizedString( @"Not Rated", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne1];

    NSMutableDictionary *dicOne2 = [[NSMutableDictionary alloc] init];
    [dicOne2 setObject:[NSString stringWithFormat:@"X : %@", NSLocalizedString( @"Unknown", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne2];

    NSMutableDictionary *dicOne3 = [[NSMutableDictionary alloc] init];
    [dicOne3 setObject:[NSString stringWithFormat:@"? : %@", NSLocalizedString( @"Not Sure", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne3];

    NSMutableDictionary *dicOne4 = [[NSMutableDictionary alloc] init];
    [dicOne4 setObject:[NSString stringWithFormat:@"! : %@", NSLocalizedString( @"Known", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne4];

    NSMutableDictionary *dicOne5 = [[NSMutableDictionary alloc] init];
    [dicOne5 setObject:[NSString stringWithFormat:@"- : %@", NSLocalizedString( @"Exclude", @"")] forKey:@"TITLE"];    
    [arrUserLevel addObject:dicOne5];
    
    intMode = intModeUserLevel;
    blnLoadUserLevel = FALSE;
    blnLoadWordGroup = FALSE;

    
    arrSetDefaultUpdateDic = [[NSMutableArray alloc] init];
    [self.arrSetDefaultUpdateDic addObject:NSLocalizedString(@"Add Phrasal Verb", @"")];    
    [self.arrSetDefaultUpdateDic addObject:NSLocalizedString(@"Add Pronounce", @"")];
    
    DLog(@"self.arrSetDefaultUpdateDic : %@", self.arrSetDefaultUpdateDic);
    
    
    arrSetWordsAndMeaning = [[NSMutableArray alloc] init];
    [self.arrSetWordsAndMeaning addObject:NSLocalizedString(@"Word Meaning", @"")];    
    
    arrDocList = [[NSMutableArray alloc] init];
    
    arrUserDic = [[NSMutableArray alloc] init];
    [self.arrUserDic addObject:@"Basic 1000"];
    [self.arrUserDic addObject:@"TOEIC 3000"];
    
    DLog(@"[self.arrUserDic count] : %d", [self.arrUserDic count]);
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    blnShowKeyboard = FALSE;

    oriFrameOfTextView = CGRectMake(0, 0, appWidth, appHeight - naviBarHeight - tabbarHeight);
    
    
    txtNewCategory = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    txtNewCategory.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtNewCategory.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtNewCategory setBackgroundColor:[UIColor whiteColor]];
    txtNewCategory.placeholder = @"Category's Name";
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    if (intMode == intModeUserLevel) {
    
        [self getUserLevel:nil];

    } else if (intMode == intModeSetLevel) {
        
        [self getWordGroup:nil];
    }
    [self.view bringSubviewToFront:tblLevel];
    
    [arrUserDic removeAllObjects];
    self.arrUserDic = [myCommon getArrCategory];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
  
}

-(IBAction) back {
	[self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark 일반함수


- (void) getUserLevel:(NSTimer*)sender
{
    //이건 전체사전에서 알파벳일때만 한다.
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@", TBL_EngDic];			
    NSInteger cntOfAllWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
    NSMutableDictionary *dicOne = [arrUserLevel objectAtIndex:0];
    [dicOne setObject:[NSNumber numberWithInt:cntOfAllWords] forKey:@"NoOfWords"];
           
    strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = 0", TBL_EngDic, FldName_Know];			
    NSInteger cntOfNotRatedWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
    NSMutableDictionary *dicOne1 = [arrUserLevel objectAtIndex:1];
    [dicOne1 setObject:[NSNumber numberWithInt:cntOfNotRatedWords] forKey:@"NoOfWords"];
    float percentOfWords = (float)cntOfNotRatedWords / cntOfAllWords;
    [dicOne1 setObject:[NSNumber numberWithFloat:percentOfWords] forKey:@"PercentOfWords"];
    
     strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = 1", TBL_EngDic, FldName_Know];			
     NSInteger cntOfKnowWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
     NSMutableDictionary *dicOne2 = [arrUserLevel objectAtIndex:2];
     [dicOne2 setObject:[NSNumber numberWithInt:cntOfKnowWords] forKey:@"NoOfWords"];
    percentOfWords = (float)cntOfKnowWords / cntOfAllWords;
    [dicOne2 setObject:[NSNumber numberWithFloat:percentOfWords] forKey:@"PercentOfWords"];
    
     strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = 2", TBL_EngDic, FldName_Know];			
     NSInteger cntOfNotSureWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
     NSMutableDictionary *dicOne3 = [arrUserLevel objectAtIndex:3];
    [dicOne3 setObject:[NSNumber numberWithInt:cntOfNotSureWords] forKey:@"NoOfWords"];
    percentOfWords = (float)cntOfNotSureWords / cntOfAllWords;
    [dicOne3 setObject:[NSNumber numberWithFloat:percentOfWords] forKey:@"PercentOfWords"];
      
    strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = 3", TBL_EngDic, FldName_Know];			
    NSInteger cntOfUnKnownWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
     NSMutableDictionary *dicOne4 = [arrUserLevel objectAtIndex:4];
     [dicOne4 setObject:[NSNumber numberWithInt:cntOfUnKnownWords] forKey:@"NoOfWords"];
    percentOfWords = (float)cntOfUnKnownWords / cntOfAllWords;
    [dicOne4 setObject:[NSNumber numberWithFloat:percentOfWords] forKey:@"PercentOfWords"];
    
    strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ > 3", TBL_EngDic, FldName_Know];			
    NSInteger cntOfExcludeWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB]; 
    NSMutableDictionary *dicOne5 = [arrUserLevel objectAtIndex:5];
    [dicOne5 setObject:[NSNumber numberWithInt:cntOfExcludeWords] forKey:@"NoOfWords"];
    percentOfWords = (float)cntOfExcludeWords / cntOfAllWords;
    [dicOne5 setObject:[NSNumber numberWithFloat:percentOfWords] forKey:@"PercentOfWords"];

    DLog(@"arrShowLevel : %@", arrUserLevel);
//    NSString *strMsg = [NSString stringWithFormat:@"ALL Words : %d\nNR (NotRated) : %d\nX (Unknown) : %d\n? (Not Sure) : %d\n! (Known) : %d\n- (Exclude) : %d", cntOfAllWords, cntOfNotRatedWords, cntOfUnKnownWords, cntOfNotSureWords, cntOfKnowWords, cntOfExcludeWords];
    [self.tblLevel reloadData];
    
    [SVProgressHUD dismiss];
    blnLoadUserLevel = TRUE;
}

- (void) getWordGroup:(NSTimer *)sender
{
    DLog(@"Before arrSetLevel : %@", arrWordGroup);
    //이건 전체사전에서 알파벳일때만 한다.
    NSInteger intAllLevel = [arrWordGroup count];
    for (NSInteger i = 1; i <= intAllLevel; i++) {
        NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d", TBL_EngDic, FldName_WORDLEVEL1, i];			

        NSInteger cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        NSMutableDictionary *dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NoOfWords"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and (%@ = 0) ", TBL_EngDic, FldName_WORDLEVEL1, i, FldName_Know];			

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NotRated"];

        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = 1 ", TBL_EngDic, FldName_WORDLEVEL1, i, FldName_Know];			

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Unknown"];

        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = 2 ", TBL_EngDic, FldName_WORDLEVEL1, i, FldName_Know];			

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NotSure"];

        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = 3 ", TBL_EngDic, FldName_WORDLEVEL1, i, FldName_Know];			

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Known"];

        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ > 3 ", TBL_EngDic, FldName_WORDLEVEL1, i, FldName_Know];	

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        dicLvlTemp = [arrWordGroup objectAtIndex:i-1];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Exclude"];
    }

    DLog(@"After arrSetLevel : %@", arrWordGroup);
    [self.tblLevel reloadData];
    
    [SVProgressHUD dismiss];
    blnLoadWordGroup = TRUE;
}


- (void) showSaveBtnAtTextView
{
    self.navigationItem.rightBarButtonItem = nil;
    
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Open", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		
}

- (void)selSegControl:(id)sender
{	
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
        self.navigationItem.rightBarButtonItem = nil;
        intMode = intModeLoadText;
        
        self.tblLevel.frame = CGRectMake(-tblLevel.frame.size.width, 0, tblLevel.frame.size.width, tblLevel.frame.size.height);
        
        [self.view bringSubviewToFront:txtViewSetWords];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.3f];
        CGRect viewQAFrame1 = CGRectMake(txtViewSetWords.frame.size.width, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        tblLevel.frame = CGRectMake(0, 0, tblLevel.frame.size.width, tblLevel.frame.size.height);
        self.txtViewSetWords.frame = viewQAFrame1;
        [UIView commitAnimations];
        
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(getBookList:)
                                       userInfo:nil
                                        repeats:NO];
       
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

	[tblLevel reloadData];
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
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show]; 
        return;
    }
    
    //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to update dictionary", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
    [actionSheetProgress showInView:self.view];
    
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
    
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
//            [arrLOG addObject:strOneLineTemp];
            continue;
        }
        NSMutableString *strOneLine = [NSMutableString stringWithString:strOneLineTemp];
        //탭을 못넣을때르 대비해서 키보드로 \t를 입력하면 (XCode에서는 \\t 로 인식함) 탭으로 치환해줌.
        [strOneLine replaceOccurrencesOfString:@"\\t" withString:@"\t" options:NSLiteralSearch range:NSMakeRange(0, [strOneLine length])];
        NSInteger countOfTab = [strOneLine replaceOccurrencesOfString:@"\t" withString:@"\t"
                                                           options:NSLiteralSearch range:NSMakeRange(0, [strOneLine length])];
        if (intTypeSetWordsAndMeaning == intTypeSetWordsAndMeaning_Unknonw_Word) {
            //단어의 아는정도와 단어를 등록한다
            if (countOfTab == 1) {
                NSArray *arrOne = [strOneLine componentsSeparatedByString:@"\t"];
                NSString *strKnow = [arrOne objectAtIndex:0];
                strKnow = [strKnow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([myCommon blnProperStrKnow:strKnow] == FALSE) {

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
                DLog(@"strOneLine : %@", strOneLine);
                DLog(@"arrOne : %@", arrOne);                
                NSString *strWord = [arrOne objectAtIndex:0];
                strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSRange rngWord = [strWord rangeOfString:@" "];
                DLog(@"rngWord : %@", [NSValue valueWithRange:rngWord]);
//                if (rngWord.length > 0) {
//                    //단어가 아니면(단어에 공백이 있으면 숙어나 문장이다.) 로그를 남겨준다.
                    
                NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
                BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:strWord dicWordWithOri:dicIdiom];
                DLog(@"dicIdiom : %@", dicIdiom);
                if ( (rngWord.length > 0) && (blnWordOrIdiomExistInDic == FALSE) ) {
                    //숙어가 사전에 없는것은 추가하지 않는다.
                    [arrLOG addObject:strOneLine];
                    continue;
                }
                
                DLog(@"strWord : %@", strWord);
                DLog(@"[dicIdiom objectForKey:KEY_DIC_StrOverOneWord] : %@", [dicIdiom objectForKey:KEY_DIC_StrOverOneWord]);                
                if ([[strWord lowercaseString] isEqualToString:[[dicIdiom objectForKey:KEY_DIC_StrOverOneWord] lowercaseString]] == FALSE) {
                    DLog(@"strWord : %@", strWord);
                    DLog(@"[dicIdiom objectForKey:KEY_DIC_StrOverOneWord] : %@", [dicIdiom objectForKey:KEY_DIC_StrOverOneWord]);
                }
                NSString *strWordOri = [dicIdiom objectForKey:KEY_DIC_StrOverOneWordOri];
                NSString *strWordForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strWord];
                NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", strWordOri]];
                
                DLog(@"strWord : [%@]", strWord);

                NSString *strMeaningForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:[arrOne objectAtIndex:1]];
                strMeaningForSQL = [strMeaningForSQL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                DLog(@"strMeaningForSQL : [%@]", strMeaningForSQL);                
                
//                NSString *strWordOriForSQL =[myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[myCommon GetOriWordOnlyIfExistInTbl:strWord]];
                
                 NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@';", FldName_Meaning, TBL_EngDic, FldName_WORDORI, strWordOriForSQL ];
                if (blnWordOrIdiomExistInDic == FALSE) {
                    //사전에 없으면 현재 단어/숙어를 넣는다.
                    NSArray *arrWord = [strWord componentsSeparatedByString:@" "];
                    NSInteger intWordLength = 0; [arrWord count];
                    NSString *strFirstTwoWordForSQL = @"";
                    if ([arrWord count] > 1) {
                        //단어가 아니고 숙어나 문장이면...(공백이 있으면...)
                        intWordLength = [arrWord count];
                        NSString *strFirstWordOri = [myCommon GetOriWordOnlyIfExistInTbl:[arrWord objectAtIndex:0]];
                        NSString *strSecondWordOri = [myCommon GetOriWordOnlyIfExistInTbl:[arrWord objectAtIndex:1]];
                        strFirstWordOri = [strFirstWordOri stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                        strSecondWordOri = [strSecondWordOri stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                        strFirstTwoWordForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@ %@", strFirstWordOri, strSecondWordOri]];
                    }
                    
                    NSString *strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@) VALUES('%@','%@','%@', %d, '%@')",TBL_EngDic, FldName_Word,FldName_Meaning, FldName_WORDORI,FldName_WordLength, FldName_FirstWord, strWordForSQL, strMeaningForSQL, strWordOriForSQL, intWordLength, strFirstTwoWordForSQL];
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //단어 추가가 안되면 로그를 남겨준다.
                        [arrLOG addObject:strOneLine];
                    }

                } else {
                    //이미 단어가 있으면 뜻만 추가하여 준다.
                    NSString *strMeaningWithWordOri = [myCommon getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
                    DLog(@"strMeaningWithWordOri : [%@]", strMeaningWithWordOri);  
                    if ( (strMeaningWithWordOri == NULL) || ([strMeaningWithWordOri isEqualToString:@""] ) ) {
                        //단어원형의 뜻이 없으면 단어의 원형에 현재 단어의 뜻을 넣는다.
                        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_Meaning, strMeaningForSQL, FldName_WORDORI, strWordOriForSQL];
                    } else {
                        //단어원형에 뜻이 있으면 현재 단어에만 뜻을 넣는다. (현재 단어의 뜻을 덮어쓴다.)
                        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_Meaning, strMeaningForSQL, FldName_Word, strWordForSQL];  
                    }
                    
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //업데이트가 안되면 단어가 없으므로 단어를 추가한다.
                        DLog(@"%@ is not in dic", strWord);
                        //단어 추가가 안되면 로그를 남겨준다.
                        [arrLOG addObject:strOneLine];
                    }
                }
            } else {
                //tab이 하나가 아니면 추가하지 않고, 로그를 남긴다.
                [arrLOG addObject:strOneLine];                
            }
        } else if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPronounce) {
            
            NSString *strOneLine1 = [NSString stringWithString:strOneLine];
                strOneLine1 = [strOneLine1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                DLog(@"strOneLine1 : %@", strOneLine1);
                NSArray *arrOne = [strOneLine1 componentsSeparatedByString:@"\t"];
                if ([arrOne count] == 2) {
                    NSString *strWord = [arrOne objectAtIndex:0];
                    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                    NSString *strPronounce = [arrOne objectAtIndex:1];
                    NSString *strPronounceForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strPronounce];
                    
                    
                    NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Pronounce, strPronounceForSQL, FldName_Word, strWordForSQL];
                    [myCommon changeRec:strQuery openMyDic:TRUE];
                    
                }
            
        }
    } 
    DLog(@"arrLog count : %d", [arrLOG count]);
    DLog(@"arrWordsAndmMeaning count : %d", [arrWordsAndmMeaning count]);        
    if ([arrLOG count] == 0) {
        NSString *strMsg = [NSString stringWithFormat:@"%@ :%d", NSLocalizedString(@"Success", @""), [arrWordsAndmMeaning count]];
    
        [SVProgressHUD showSuccessWithStatus:strMsg];
    } else {
        NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%@ : %d", NSLocalizedString(@"Success", @""),[arrWordsAndmMeaning count] - [arrLOG count], NSLocalizedString(@"Fail", @""),[arrLOG count]];
        if ([arrLOG count] == [arrWordsAndmMeaning count]) {
            strMsg = [NSString stringWithFormat:@"%@ :0\n%@ : %d", NSLocalizedString(@"Success", @""),NSLocalizedString(@"Fail", @""), [arrLOG count]];
        }
        [SVProgressHUD showSuccessWithStatus:strMsg];
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

- (void) defaultUpdateDic:(NSObject*)obj
{
    @autoreleasepool {
        NSString *strFileName = @"pronounce_130112";
        if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPronounce) {
            strFileName = @"pronounce_130112";
        } else if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPhrasalVerb) {
            strFileName = @"phrasalverb_130117";
        }
        NSString *strFileNamePronounce = [[NSBundle mainBundle] pathForResource:strFileName ofType:@"txt"];
        NSMutableString *strFileContents = [myCommon readTxtWithEncoding:strFileNamePronounce];
        //        DLog(@"strFileContents : %@", strFileContents);
        NSArray *arrAllLine = [[strFileContents lowercaseString] componentsSeparatedByString:@"\n"];
        NSInteger cntOfAllLine = [arrAllLine count];

        NSMutableArray *arrLOG = [[NSMutableArray alloc] init];
        for (NSInteger intIndex = 0; intIndex < cntOfAllLine; ++intIndex) {
            float	fVal = (intIndex+1) / ((float)cntOfAllLine);
            
            NSString *strMsgMain = NSLocalizedString(@"Add Pronounce", @"");
            if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPronounce) {
                strMsgMain = NSLocalizedString(@"Add Pronounce", @"");
            } else if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPhrasalVerb) {
                strMsgMain = NSLocalizedString(@"Add Phrasal Verb", @"");
            }
            
            NSString *strMsg = [NSString stringWithFormat:@"(%d/%d) %@... %@", intIndex+1, cntOfAllLine, strMsgMain, [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            if (blnCancelSaveSetWordsAndMeaning == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled updating dictionary.", @"")];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            
            NSString *strOneLineTemp = [arrAllLine objectAtIndex:intIndex];
            strOneLineTemp = [strOneLineTemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([strOneLineTemp isEqualToString:@""]) {
                continue;
            }

            if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPronounce) {
                
                DLog(@"strOneLineTemp : %@", strOneLineTemp);
                NSArray *arrOne = [strOneLineTemp componentsSeparatedByString:@"\t"];
                if ([arrOne count] == 2) {
                    NSString *strWord = [arrOne objectAtIndex:0];
                    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                    NSString *strPronounce = [arrOne objectAtIndex:1];
                    NSString *strPronounceForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strPronounce];
                    
                    
                    NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Pronounce, strPronounceForSQL, FldName_Word, strWordForSQL];
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //단어 발음이 없데이트가 안되면 로그를 남겨준다.
                        [arrLOG addObject:strOneLineTemp];
                    }
                    
                }
                
            } else if (intTypeSetWordsAndMeaning == intTypeSetDefaultUpdateDic_AddPhrasalVerb) {

                NSArray *arrOne = [strOneLineTemp componentsSeparatedByString:@" "];
                if ([arrOne count] > 1) {
                    
                    NSString *strPhrasalVerbForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneLineTemp];
                    
                    NSInteger intWordsCount = [arrOne count];
                    NSMutableString *strPhrasalVerbOri = [[NSMutableString alloc] init];
                    for (NSInteger i = 0; i < intWordsCount; ++i) {
                        NSString *strOneWord = [arrOne objectAtIndex:i];
                        NSString *strOneWordOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
                        [strPhrasalVerbOri appendFormat:@"%@,", strOneWordOri];
                    }
                    DLog(@"strPhrasalVerbOri : '%@'", strPhrasalVerbOri);
                    NSString *strFirstWord = [arrOne objectAtIndex:0];
                    NSString *strFirstWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstWord];
                    
                    NSString *strSecondWord = [arrOne objectAtIndex:1];
                    NSString *strSecondWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strSecondWord];
                    
                    
                    NSString *strPhrasalVerbOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strPhrasalVerbOri];
                    
                    
                    
                    NSString *strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@) VALUES('%@ %@', '%@', %d, %d, '%@')",TBL_EngDic,FldName_FirstWord, FldName_WORDORI, FldName_WordLength, FldName_InstalledWord, FldName_Word, strFirstWordForSQL, strSecondWordForSQL, strPhrasalVerbOriForSQL, intWordsCount, 1, strPhrasalVerbForSQL];
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //숙어가 추가가 안되면 로그를 남겨준다.
                        [arrLOG addObject:strOneLineTemp];
                    }
                }
                
            }
        }
        DLog(@"arrLog count : %d", [arrLOG count]);
        DLog(@"arrWordsAndmMeaning count : %d", cntOfAllLine);
        if ([arrLOG count] == 0) {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d", NSLocalizedString(@"Success", @""), cntOfAllLine];
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%@ : %d", NSLocalizedString(@"Success", @""),cntOfAllLine - [arrLOG count], NSLocalizedString(@"Fail", @""),[arrLOG count]];
            if ([arrLOG count] == cntOfAllLine) {
                strMsg = [NSString stringWithFormat:@"%@ :0\n%@ : %d", NSLocalizedString(@"Success", @""),NSLocalizedString(@"Fail", @""), [arrLOG count]];
            }
            
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        }
        DLog(@"arrLOG : %@", arrLOG);
        
//        self.navigationItem.title = @"";
        
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
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark NSNotification methods
- (void)keyboardWillShow:(NSNotification *)aNotification
{
	// the keyboard is showing so resize the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.size.height -= keyboardRect.size.width - 49;
    }else{
        frame.size.height -= keyboardRect.size.height - 49;
    }
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // the keyboard is hiding reset the table's height
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.size.height += keyboardRect.size.width - 49;
    }else{
        frame.size.height += keyboardRect.size.height - 49;
    }
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
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
    
    if (intMode == intModeLoadText) {
        [self showSaveBtnAtTextView];
    } else if (intMode == intModeLoadTextATUserDic) {
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (intMode == intModeUserLevel) {
        return [self.arrUserLevel count];
    } else if (intMode == intModeSetLevel) {
        return [self.arrWordGroup count];
    } else if (intMode == intModeSetWordsAndMeaning) {
        return [self.arrSetWordsAndMeaning count];
    } else if ((intMode == intModeLoadText) || (intMode == intModeLoadTextATUserDic)) {
        return [self.arrDocList count];
    } else if (intMode == intModeUserDic) {
        DLog(@"[self.arrUserDic count] : %d", [self.arrUserDic count]);
        return [self.arrUserDic count] + ([tableView isEditing] ? 1 : 0); //        return [self.arrMovieList count] + ([self isEditing] ? 1 : 0);;
    } else if (intMode == intModeSetDefaultDicUpdate) {
        DLog(@"self.arrSetDefaultUpdateDic : %@", self.arrSetDefaultUpdateDic);
        return [self.arrSetDefaultUpdateDic count];
    }
    return [self.arrUserLevel count];
}


static NSString *CellIdentifierSetLevel = @"CellSetLevel";
static NSString *CellIdentifierShowLevel = @"CellShowLevel";
static NSString *CellIdentifierCellUpdateDic = @"CellUpdateDic";
static NSString *CellIdentifierSetWordsAndMeaning  = @"CellSetWordsAndMeaning ";
static NSString *CellIdentifierWordsByCategory = @"CellWordsByCategory";
static NSString *CellIdentifierLoadText = @"CellLoadText";
static NSString *CellIdentifierUserDic = @"CellUserDic";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    //tableViewLevel에 해당되는 단어의 아는정도를 한번에 조정한다.
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setLocale:locale];
    
    UITableViewCell *cell;
    if (intMode == intModeUserLevel) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierShowLevel];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierShowLevel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        NSDictionary *dicOne = [self.arrUserLevel objectAtIndex:indexPath.row];
        DLog(@"dicOne : %@", dicOne);
        NSString *strTitle = [dicOne objectForKey:@"TITLE"];
        
        NSInteger noOfWords = [[dicOne objectForKey:@"NoOfWords"] integerValue];
        
        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", noOfWords]];
        NSString *strCount = [currencyFormatter stringFromNumber:someAmount];	
        
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", strTitle];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", strCount, NSLocalizedString(@"Words", @"")];
        } else {
            float percentOfWords = [[dicOne objectForKey:@"PercentOfWords"] floatValue] * 100;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.0f%%)", strTitle, percentOfWords];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ ", strCount, NSLocalizedString(@"Words", @"")];
        }
    } else if (intMode == intModeSetLevel) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSetLevel];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierSetLevel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        
        NSDictionary *dicOne = [self.arrWordGroup objectAtIndex:indexPath.row];
        DLog(@"dicOne : %@", dicOne);
        NSString *strLevel = [dicOne objectForKey:@"LEVEL"];
        NSString *strSegConSelIndex = [dicOne objectForKey:@"SegConSelIndex"];
        NSInteger noOfWords = [[dicOne objectForKey:@"NoOfWords"] integerValue];
        NSInteger intNotRated = [[dicOne objectForKey:@"NotRated"] integerValue];
        NSInteger intUnknown = [[dicOne objectForKey:@"Unknown"] integerValue];
        NSInteger intNotSure = [[dicOne objectForKey:@"NotSure"] integerValue];
        NSInteger intKnown = [[dicOne objectForKey:@"Known"] integerValue];
        NSInteger intExclude = [[dicOne objectForKey:@"Exclude"] integerValue];
        
        if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"All Known", @"")]) {
            intNotRated = 0;
            intUnknown = 0;
            intNotSure = 0;
            intKnown = noOfWords;
            intExclude = 0;
        } else if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"All Unknown", @"")]) {
            intNotRated = 0;
            intUnknown = noOfWords;
            intNotSure = 0;
            intKnown = 0;
            intExclude = 0;
        }
        
        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", noOfWords]];
        NSString *strCount = [currencyFormatter stringFromNumber:someAmount];	
        NSInteger percentOfKnown = (float)(intKnown + intExclude) / noOfWords * 100;
        DLog(@"percentOfKnown : %d", percentOfKnown);
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ : (%@ %@, %d%%)", NSLocalizedString(@"Group", @""), strLevel, strCount, NSLocalizedString(@"Words", @""), percentOfKnown];
        cell.detailTextLabel.numberOfLines = 5;
        NSDecimalNumber *someAmountNotRated = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intNotRated]];
        NSString *strCountNotRated = [currencyFormatter stringFromNumber:someAmountNotRated];	
        NSDecimalNumber *someAmountUnknown = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intUnknown]];
        NSString *strCountUnknown = [currencyFormatter stringFromNumber:someAmountUnknown];	
        NSDecimalNumber *someAmountNotSure = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intNotSure]];
        NSString *strCountNotSure = [currencyFormatter stringFromNumber:someAmountNotSure];	
        NSDecimalNumber *someAmountKnown = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intKnown]];
        NSString *strCountKnown = [currencyFormatter stringFromNumber:someAmountKnown];	
        NSDecimalNumber *someAmountExlude = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intExclude]];
        NSString *strCountExlude = [currencyFormatter stringFromNumber:someAmountExlude];	
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"NR(%@), X(%@) ?(%@), !(%@), -(%@)\n\n\n", strCountNotRated,strCountUnknown,strCountNotSure,strCountKnown,strCountExlude]; 
        
        UISegmentedControl *segConSetKnownUnknownInSetLevel = [[UISegmentedControl alloc] initWithFrame:CGRectMake((appWidth - 280)/2,65, 280, 30)];
        
        [segConSetKnownUnknownInSetLevel insertSegmentWithTitle:NSLocalizedString(@"Original", @"") atIndex:0 animated:YES];
        [segConSetKnownUnknownInSetLevel insertSegmentWithTitle:NSLocalizedString(@"All Known", @"") atIndex:1 animated:YES];
        [segConSetKnownUnknownInSetLevel insertSegmentWithTitle:NSLocalizedString(@"All Unknown", @"") atIndex:2 animated:YES];
        segConSetKnownUnknownInSetLevel.momentary = FALSE;
        if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"All Known", @"")]) {
            segConSetKnownUnknownInSetLevel.selectedSegmentIndex = 1;
        } else if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"All Unknown", @"")]) {
            segConSetKnownUnknownInSetLevel.selectedSegmentIndex = 2;            
        } else {
            segConSetKnownUnknownInSetLevel.selectedSegmentIndex = 0;            
        }
        segConSetKnownUnknownInSetLevel.tag = 0;
        [segConSetKnownUnknownInSetLevel addTarget:self action:@selector(selSegConKnownOrUnknownInSetLevel:) forControlEvents:UIControlEventValueChanged];
        segConSetKnownUnknownInSetLevel.segmentedControlStyle = UISegmentedControlStyleBar;
        [cell.contentView addSubview:segConSetKnownUnknownInSetLevel];		
    } else if (intMode == intModeSetWordsAndMeaning) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSetWordsAndMeaning];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierSetWordsAndMeaning];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        
        NSString *strTitle = [self.arrSetWordsAndMeaning objectAtIndex:indexPath.row];
        cell.textLabel.text = strTitle;
        cell.detailTextLabel.text = NSLocalizedString(@"Place tab between word and meanging", @"");
    } else if (intMode == intModeSetDefaultDicUpdate) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCellUpdateDic];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierCellUpdateDic];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        
        NSString *strTitle = [self.arrSetDefaultUpdateDic objectAtIndex:indexPath.row];
        cell.textLabel.text = strTitle;
//        if ([strTitle isEqualToString:NSLocalizedString(@"Add Pronounce", @"")] == TRUE) {
//            cell.detailTextLabel.text = NSLocalizedString(@"Add pronounce in your dictionary", @"");            
//        }
        
        
    } else if (intMode == intModeWordsByCategory) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierWordsByCategory];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierWordsByCategory];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        
        NSDictionary *dicOne = [self.arrWordGroup objectAtIndex:indexPath.row];
        DLog(@"dicOne : %@", dicOne);
        NSString *strLevel = [dicOne objectForKey:@"LEVEL"];
        NSString *strSegConSelIndex = [dicOne objectForKey:@"SegConSelIndex"];
        NSInteger noOfWords = [[dicOne objectForKey:@"NoOfWords"] integerValue];
        NSInteger intNotRated = [[dicOne objectForKey:@"NotRated"] integerValue];
        NSInteger intUnknown = [[dicOne objectForKey:@"Unknown"] integerValue];
        NSInteger intNotSure = [[dicOne objectForKey:@"NotSure"] integerValue];
        NSInteger intKnown = [[dicOne objectForKey:@"Known"] integerValue];
        NSInteger intExclude = [[dicOne objectForKey:@"Exclude"] integerValue];
        
        if ([[strSegConSelIndex uppercaseString] isEqualToString:@"ALL UNKNOWN"]) {
            intNotRated = 0;
            intUnknown = noOfWords;
            intNotSure = 0;
            intKnown = 0;
            intExclude = 0;
        } else if ([[strSegConSelIndex uppercaseString] isEqualToString:@"ALL KNOWN"]) {
            intNotRated = 0;
            intUnknown = 0;
            intNotSure = 0;
            intKnown = noOfWords;
            intExclude = 0;
        }
        
        //    NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"X"] integerValue];
        //    NSInteger cntOfHalfknownWords = [[dicOne objectForKey:@"?"] integerValue];            
        //    NSInteger cntOfknownWords = [[dicOne objectForKey:@"!"] integerValue];
        //    NSInteger cntOfAllWords = cntOfknownWords + cntOfHalfknownWords + cntOfUnknownWords;
        //    cell.textLabel.text = [NSString stringWithFormat:@"Level:%d (%d Words)", level, cntOfAllWords];
        //    cell.detailTextLabel.text = [NSString stringWithFormat:@"X:%d, ?:%d, !:%d", cntOfUnknownWords, cntOfHalfknownWords, cntOfknownWords];
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"Level:%@ (%d Words)", strLevel, noOfWords];
        cell.detailTextLabel.numberOfLines = 5;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"NR(%d), X(%d)\n?(%d), !(%d), -(%d)\n\n\n", intNotRated,intUnknown,intNotSure,intKnown,intExclude]; 

    } else if ((intMode == intModeLoadText) || (intMode == intModeLoadTextATUserDic)) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLoadText];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierLoadText];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }                
        NSString *strTitle = [self.arrDocList objectAtIndex:indexPath.row];
        cell.textLabel.text = strTitle;

    }  else if (intMode == intModeUserDic) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierUserDic];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierUserDic];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }                
        if([tblLevel isEditing] && indexPath.row == [self.arrUserDic count])
        {
            cell.textLabel.text =  @"신규항목 추가";
            //            cell.txtValue.text = @"0";
        } else {
            NSString *strTitle = [self.arrUserDic objectAtIndex:indexPath.row];
            cell.textLabel.text = strTitle;
        }
    }
    return cell;
}

//Level에서 단어의 아는정도를 조정할때 사용...
- (void) selSegConKnownOrUnknownInSetLevel:(id)sender //event:(id)event
{
	UISegmentedControl *segOne = (UISegmentedControl*)sender;
	//현재선택한 셀의 줄을 가져온다.
	NSIndexPath *indexPath = [tblLevel indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
//    UITableViewCell *cell = (UITableViewCell*)[tblLevel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    NSMutableDictionary *dicOne = [self.arrWordGroup	objectAtIndex:indexPath.row];
    DLog(@"Before arrSetLevel : %@", arrWordGroup);
    NSString *strSegConSelIndex = NSLocalizedString(@"Original", @"");
    if (segOne.selectedSegmentIndex == 1) {
        strSegConSelIndex = NSLocalizedString(@"All Known", @"");    
    } else if (segOne.selectedSegmentIndex == 2) {
        strSegConSelIndex = NSLocalizedString(@"All Unknown", @"");        
    }
    
    DLog(@"strSegConSelIndex : %@", strSegConSelIndex);
    [dicOne setObject:strSegConSelIndex forKey:@"SegConSelIndex"];    
    [self.arrWordGroup replaceObjectAtIndex:indexPath.row withObject:dicOne];
    DLog(@"After arrSetLevel : %@", arrWordGroup);
    [self.tblLevel reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath : %d", indexPath.row);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    
    DLog(@"indexPath : %d", indexPath.row);
    if ( (intMode == intModeUserLevel) || (intMode == intModeSetLevel) || (intMode == intModeUserDic) ) {
        // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
        
        [SVProgressHUD showProgress:-1 status:@""];
        //[aiv1 release];
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(openDicList:)
                                       userInfo:[NSNumber numberWithInt:indexPath.row]
                                        repeats:NO];
    } else if (intMode == intModeSetWordsAndMeaning) {

        self.txtViewSetWords.frame = CGRectMake(txtViewSetWords.frame.size.width, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        [self.view bringSubviewToFront:txtViewSetWords];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.3f];
        CGRect viewQAFrame1 = CGRectMake(0, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        tableView.frame = CGRectMake(-txtViewSetWords.frame.size.width, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        self.txtViewSetWords.frame = viewQAFrame1;
        [UIView commitAnimations];
        
        [self showSaveBtnAtTextView];
        
        if (indexPath.row == 0) {
            intTypeSetWordsAndMeaning = intTypeSetDefaultUpdateDic_AddPronounce;
        }
    } else if (intMode == intModeSetDefaultDicUpdate) {
        
        if (indexPath.row == 0) {
            intTypeSetWordsAndMeaning = intTypeSetDefaultUpdateDic_AddPhrasalVerb;
        } else if (indexPath.row == 1) {
            intTypeSetWordsAndMeaning = intTypeSetDefaultUpdateDic_AddPronounce;
        }
        //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
        actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to update dictionary", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
        
        [actionSheetProgress showInView:self.view];
        
        float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
        progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
        progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
        
        [actionSheetProgress addSubview:progressViewInActionSheet];
        
        UIActivityIndicatorView *aivInActionSheet = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aivInActionSheet.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);
        [aivInActionSheet startAnimating];
        [actionSheetProgress addSubview:aivInActionSheet];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(110, 55, 90, 37);
        btnCancel.center = CGPointMake(self.view.center.x, btnCancel.center.y);
        [btnCancel setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
        
        [btnCancel addTarget:self action:@selector(dismissBtnCancel) forControlEvents:UIControlEventTouchUpInside];
        [actionSheetProgress addSubview:btnCancel];
        
        blnCancelSaveSetWordsAndMeaning= FALSE;
        actionSheetProgress.hidden = FALSE;
        
        [NSThread detachNewThreadSelector:@selector(defaultUpdateDic:) toTarget:self withObject:nil];
    } else if ((intMode == intModeLoadText) || (intMode == intModeLoadTextATUserDic)) {

        if (intMode == intModeLoadText) {
            [self showSaveBtnAtTextView];
        } else if (intMode == intModeLoadTextATUserDic) {
            self.navigationItem.rightBarButtonItem = nil;
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory)];
            self.navigationItem.rightBarButtonItem = rightButton;
        }
        NSString *strFullFileName = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], [arrDocList objectAtIndex:indexPath.row]];        
        txtViewSetWords.text = [NSString stringWithFormat:@"%@", [myCommon readTxtWithEncoding:strFullFileName]];
            
        [txtViewSetWords scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
        self.txtViewSetWords.frame = CGRectMake(txtViewSetWords.frame.size.width, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        [self.view bringSubviewToFront:txtViewSetWords];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.3f];
        CGRect viewQAFrame1 = CGRectMake(0, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        tblLevel.frame = CGRectMake(-txtViewSetWords.frame.size.width, 0, txtViewSetWords.frame.size.width, txtViewSetWords.frame.size.height);
        self.txtViewSetWords.frame = viewQAFrame1;
        [UIView commitAnimations];
        
    }

}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
	[self.tblLevel beginUpdates];
	[super setEditing:editing animated:animated];
	
	if (editing) {
		[self.tblLevel insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrUserDic count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop];	
	} else {
		[self.tblLevel deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrUserDic count] inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		
	}
	[self.tblLevel endUpdates];
	
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //swipe했을때 에디팅 모드를 할지 안할지 결정한다.
//    // Detemine if it's in editing mode
//        DLog(@"editingStyleForRowAtIndexPath : %d", indexPath.row);
//    return UITableViewCellEditingStyleDelete;;    
//}

//Book에 해당되는 TBL_EngDic_테이블과 bookSetting의 내용도 같이 지운다.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (intMode == intModeUserDic) {
            DLog(@"UITableViewCellEditingStyleDelete : %d", indexPath.row);
            NSString *strOne = [arrUserDic objectAtIndex:indexPath.row];
            NSString *strOneForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strOne];
            NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = 0 WHERE %@ = '%@'", TBL_dicByCategory, FldName_USE, FldName_CATEGORYNAME, strOneForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            [arrUserDic removeObjectAtIndex:indexPath.row];
            [self.tblLevel reloadData];
        }
        DLog(@"UITableViewCellEditingStyleDelete : %d", indexPath.row);
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        DLog(@"UITableViewCellEditingStyleInsert : %d", indexPath.row);
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{

	if (intMode == intModeUserDic) {
            return UITableViewCellEditingStyleDelete;
//        //셀왼편에 보여줄 아이콘의 형태를 결정한다.
//        if ([tableView isEditing] == NO) {
//            //에디팅이 아니면 아무아이콘도 안나타낸다.
//            return UITableViewCellEditingStyleNone;
//        }
//        if ([tableView isEditing] && indexPath.row == [self.arrUserDic count]) {
//            //에디팅상태에서 맨마지막줄이면 삽입아이콘을 보여준다.
//            return UITableViewCellEditingStyleInsert;
//        } else {
//            //에디팅상태에서 맨마지막줄이 아니면 삭제아이콘을 보여준다.
//            return UITableViewCellEditingStyleDelete;
//        }
    }	
    return UITableViewCellEditingStyleNone;
}


- (void) openDicList:(NSTimer *)sender
{
    NSInteger row = [[sender userInfo] integerValue];
    DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
    dicListController.intDicWordOrIdiom = DicWordOrIdiom_Word;
    dicListController.blnUseKnowButton = FALSE;
    dicListController.intBookTblNo = -1;
    if (intMode == intModeUserLevel) {
        
        dicListController.intDicListType = DicListType_TBL_EngDicUserLevel;
        if (row == 0) {
            dicListController.strWhereClauseFldSQL = @"";
        } else if (row == 1) {
            dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ = %d) ", FldName_Know, KnowWord_NotRated];
        } else if (row == 2) {
            dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ = %d) ", FldName_Know, KnowWord_Unknown];
        } else if (row == 3) {
            dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ = %d) ", FldName_Know, KnowWord_NotSure];
        } else if (row == 4) {
            dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ = %d) ", FldName_Know, KnowWord_Known];
        } else if (row == 5) {
            dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ > %d) ", FldName_Know, KnowWord_Known];
        }        
        blnLoadUserLevel = FALSE;

    } else if (intMode == intModeUserDic) {
        dicListController.intDicListType = DicListType_TBL_EngDicUserDic;
        NSString *strOne = [arrUserDic objectAtIndex:row];
        NSString *strOneForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strOne];
        NSString *strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_FIELDNAME, TBL_dicByCategory, FldName_CATEGORYNAME, strOneForSQL];
        NSString *strFieldName = [myCommon getStringFldValueFromTbl:strQuery openMyDic:TRUE];
        dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" ( %@ = 1) ", strFieldName];

    }else {
        dicListController.intDicListType = DicListType_TBL_EngDicWordGroup;
        dicListController.blnUseKnowButton = TRUE;

        dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" ( %@ = %d ) ", FldName_WORDLEVEL1, (row + 1)];
        blnLoadWordGroup = FALSE;       
    }

    
	[self.navigationController pushViewController:dicListController animated:YES];
    
	[SVProgressHUD dismiss];
    
}

//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (intMode == intModeUserLevel) {
        return 60;
    } else if (intMode == intModeSetLevel) {
        return 100;
    } else if (intMode == intModeSetWordsAndMeaning) {
        return 44;
    } else if (intMode == intModeWordsByCategory) {
        return 100;
    }
    return 44;
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        self.strFieldNameOfNewCategory = @"";
		if (buttonIndex == 1) {
            //책이름을 적고 OK를 눌렀을때...
			DLog(@"txtNewCategory : %@", txtNewCategory.text);
            NSString *strCategoryName = [txtNewCategory.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([strCategoryName isEqualToString:@""] == TRUE) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need category's name to make a category.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                return;
            } 
            
            NSString *strCategorNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strCategoryName];

            NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_dicByCategory, FldName_CATEGORYNAME, strCategorNameForSQL];
            if ([myCommon chkRecExist:strQuery openMyDic:OPEN_DIC_DB] == TRUE) {
                //CATEGORY가 존재하면 덮어씌울지 물어본다.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Category's name already exist.\nReplace it?", @""), strCategoryName]  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];
                alert.tag = 2;
                [alert show];
                return;
            } else {            
                //CATEGORY가 없으면 카테고릐 이름을 추가한다. 카테고리필드를 아래함수에서 채우고, 다채우고나면 USE를 1로 둔다.
                strQuery = [NSString stringWithFormat:@"select %@ from %@ where %@ = 0 limit 1", FldName_FIELDNAME, TBL_dicByCategory, FldName_USE];
                if ([myCommon chkRecExist:strQuery openMyDic:OPEN_DIC_DB] == TRUE) {                    
                    self.strFieldNameOfNewCategory = [myCommon getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
                    strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_dicByCategory, FldName_CATEGORYNAME, strCategorNameForSQL, FldName_FIELDNAME, strFieldNameOfNewCategory];
                    [myCommon changeRec:strQuery openMyDic:TRUE];

                }
                [self callWriteCategoryFromTxtView];
            }
		}	
	} else if (alertView.tag == 2) {

    }
}

//실제 txtView에 있는 내용을 가지고 Category를 만든다.
- (void) callWriteCategoryFromTxtView
{
    //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:@"\nPreparing to write category...\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
    
    [actionSheetProgress showInView:self.view];
    
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
    [actionSheetProgress addSubview:progressViewInActionSheet];
    
    UIActivityIndicatorView *aivInActionSheet = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aivInActionSheet.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);            
    [aivInActionSheet startAnimating];
    [actionSheetProgress addSubview:aivInActionSheet];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(110, 55, 90, 37);
    btnCancel.center = CGPointMake(self.view.center.x, btnCancel.center.y);
    [btnCancel setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    
    [btnCancel addTarget:self action:@selector(dismissBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetProgress addSubview:btnCancel];    
    
    blnCancelSaveSetWordsAndMeaning= FALSE;
    actionSheetProgress.hidden = FALSE;
    //	self.actionSheetProgress.title = @"Prepare to Read...\n\n";
    [NSThread detachNewThreadSelector:@selector(writeCategoryFromTxtView:) toTarget:self withObject:nil];
}
- (void) writeCategoryFromTxtView:(NSObject*)obj
{
    @autoreleasepool {
        //	[self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:@"Preparing to anlayze..." waitUntilDone:YES];
        
        NSString *strWordsAndmMeaningTemp = [NSString stringWithString:txtViewSetWords.text];    
        strWordsAndmMeaningTemp = [strWordsAndmMeaningTemp stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        strWordsAndmMeaningTemp = [strWordsAndmMeaningTemp stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
        NSMutableString *strWordsAndmMeaning = [NSMutableString stringWithString:strWordsAndmMeaningTemp];
        NSArray *arrWordsAndmMeaning = [strWordsAndmMeaning componentsSeparatedByString:@"\n"];
        NSMutableArray *arrLOG = [[NSMutableArray alloc] init];
        
        NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = 0", TBL_EngDic, strFieldNameOfNewCategory];
        [myCommon changeRec:strQuery openMyDic:TRUE];

        for (NSInteger intIndex = 0; intIndex < [arrWordsAndmMeaning count]; ++intIndex) {
            float	fVal = (intIndex+1) / ((float)[arrWordsAndmMeaning count]);
            
            NSString *strMsg = [NSString stringWithFormat:@"(%d/%d) Update category... %@", intIndex+1, [arrWordsAndmMeaning count], [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            
            if (blnCancelSaveSetWordsAndMeaning == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled updating category.", @"")];
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
            NSInteger countOfTab = [strOneLine replaceOccurrencesOfString:@" " withString:@" "
                                                                  options:NSLiteralSearch range:NSMakeRange(0, [strOneLine length])];
            DLog(@"strOneLine : %@", strOneLine);
            

            //단어에 해당되는 category필드에 1을 넣어준다.
            if (countOfTab == 0) {
                NSString *strWord = strOneLine;
                strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = 1 WHERE %@ = '%@'", TBL_EngDic, strFieldNameOfNewCategory, FldName_Word, strWordForSQL];
                if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                    //업데이트가 안되면 단어가 없으므로 단어를 추가한다.
                    DLog(@"%@ is not in dic", strWord);
                    strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@ ) VALUES('%@',1, '', 0, '', '', 0, 99)",TBL_EngDic, FldName_Word, strFieldNameOfNewCategory, FldName_WORDORI, FldName_Know, FldName_Meaning, FldName_DESC, FldName_ToMemorize, FldName_WORDLEVEL1,  strWordForSQL];
                    if ([myCommon changeRec:strQuery openMyDic:TRUE] == FALSE) {
                        //단어 추가가 안되면 로그를 남겨준다.
                        [arrLOG addObject:strOneLine];
                    }
                }
            } else {
                //tab이 하나가 아니면 추가하지 않고, 로그를 남긴다.
                [arrLOG addObject:strOneLine];                
            }
        }
        
        NSString *strCategoryName = [txtNewCategory.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
        NSString *strCategorNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strCategoryName];
        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = 1 WHERE %@ = '%@'",TBL_dicByCategory, FldName_USE, FldName_CATEGORYNAME, strCategorNameForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];

        if ([arrLOG count] == 0) {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%@ : 0", NSLocalizedString(@"Success", @""), [arrWordsAndmMeaning count], NSLocalizedString(@"Fail", @"")];
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Update Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"%@ :%d\n%d : %@", NSLocalizedString(@"Success", @""),[arrWordsAndmMeaning count] - [arrLOG count],[arrLOG count], NSLocalizedString(@"Fail", @"")];
            if ([arrLOG count] == [arrSetWordsAndMeaning count]) {
                strMsg = [NSString stringWithFormat:@"%@ : 0\n%d : %@",NSLocalizedString(@"Success", @""), [arrLOG count], NSLocalizedString(@"Fail", @"")];
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
#pragma mark -
#pragma mark UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //같은것을 눌렀을때는 동작을 안하게 할려구...
    DLog(@"item.tag : %d", item.tag);
    DLog(@"item.title : [%@]", item.title);
    DLog(@"intBeforeTabBarItemTag : %d", intBeforeTabBarItemTag);
    if ([item.title isEqualToString: NSLocalizedString(@"Update Dic", @"")]) {
        DLog(@"item.title : [%@]", item.title);
        DLog(@"item.title : [%@]", item.title);            
    }
//    if ((item.tag == intBeforeTabBarItemTag) && (item.tag != 3)) {
//        return;
//    }
    if (item.tag == intBeforeTabBarItemTag) {
        return;
    }

    intBeforeTabBarItemTag = item.tag;
    DLog(@"intBeforeTabBarItemTag : %d", intBeforeTabBarItemTag);
//    txtViewSetWords.hidden = TRUE;
    [self.view sendSubviewToBack:txtViewSetWords];
//    [self.view sendSubviewToBack:tblLevel];
    [self.view sendSubviewToBack:tblOne];
    
    if ([item.title isEqualToString: NSLocalizedString(@"My Level", @"")]) {
        [self.view bringSubviewToFront:tblLevel];        
        tblLevel.frame = CGRectMake(0, 0, tblLevel.frame.size.width, tblLevel.frame.size.height);

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Level Test", @"") style:UIBarButtonItemStylePlain target:self action:@selector(testUserLevel)];
        self.navigationItem.rightBarButtonItem = rightButton;

        
        self.navigationItem.title = NSLocalizedString(@"My Level", @"");
        intMode = intModeUserLevel;
            
        [SVProgressHUD showProgress:-1 status:@""];
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(getUserLevel:)
                                       userInfo:nil
                                        repeats:NO];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tblLevel cache:YES];
        [UIView commitAnimations];
    } else if ([item.title isEqualToString:NSLocalizedString(@"Word Group", @"")]) {
        [self.view bringSubviewToFront:tblLevel];   
        tblLevel.frame = CGRectMake(0, 0, tblLevel.frame.size.width, tblLevel.frame.size.height);       
        self.navigationItem.title = NSLocalizedString(@"Word Group", @"");
     
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(CallSave)];
        self.navigationItem.rightBarButtonItem = saveButton;
        
        intMode = intModeSetLevel;
        if (blnLoadWordGroup == FALSE) {
            [SVProgressHUD showProgress:-1 status:@""];
            
            //아래가 안되네... 함수를 타지를 않아요...
            [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                             target:self
                                           selector:@selector(getWordGroup:)
                                           userInfo:nil
                                            repeats:NO];
            //            [self getSetLevel:nil];
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
        [UIView commitAnimations];
        
    } else if ([item.title isEqualToString: NSLocalizedString(@"Update Dic", @"")]) {
        
        self.navigationItem.title = NSLocalizedString(@"Update Dic", @"");
        [txtViewSetWords resignFirstResponder];
        blnShowKeyboard = FALSE;
        self.navigationItem.rightBarButtonItem = nil;
        //        [self showSaveBtnAtTextView];
        //        [self.view bringSubviewToFront:tblLevel];
        intMode = intModeSetDefaultDicUpdate;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
        //        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.txtViewSetWords cache:YES];
        [UIView commitAnimations];
        
    
    } else if ([item.title isEqualToString: NSLocalizedString(@"Add Meaning", @"")]) {

        [txtViewSetWords resignFirstResponder];
        blnShowKeyboard = FALSE;
        self.navigationItem.rightBarButtonItem = nil;

        intMode = intModeSetWordsAndMeaning;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
        [UIView commitAnimations];

    } else if ([[item.title uppercaseString] isEqualToString:@"단어장들"]) {
        self.arrUserDic = [myCommon getArrCategory];        
        intMode = intModeUserDic; 
        [self updateDicByCategoryIfNotExists];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
        [UIView commitAnimations];

        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addCategoryFile)];

        self.navigationItem.rightBarButtonItem = saveButton;
    }
    [self.tblLevel reloadData];
}

- (void) testUserLevel
{
    FlashCardController *flashCardController = [[FlashCardController alloc] initWithNibName:@"FlashCardController" bundle:nil];
    
    NSMutableArray *arrWordList = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrOne = [[NSMutableArray alloc] init];
    
    
#ifdef ENGLISH
    [arrOne addObject:@"this"];
    [arrOne addObject:@"and"];
    [arrOne addObject:@"know"];
    
    [arrOne addObject:@"take"];
    [arrOne addObject:@"night"];
    [arrOne addObject:@"hard"];
    
    [arrOne addObject:@"play"];
    [arrOne addObject:@"watch"];
    [arrOne addObject:@"fall"];
    
    [arrOne addObject:@"reach"];
    [arrOne addObject:@"marriage"];
    [arrOne addObject:@"imagine"];
    
    [arrOne addObject:@"shame"];
    [arrOne addObject:@"ocean"];
    [arrOne addObject:@"influence"];
    
    [arrOne addObject:@"separate"];
    [arrOne addObject:@"rude"];
    [arrOne addObject:@"pool"];
    
    [arrOne addObject:@"author"];
    [arrOne addObject:@"sufficient"];
    [arrOne addObject:@"sheep"];
    
    [arrOne addObject:@"employee"];
    [arrOne addObject:@"weigh"];
    [arrOne addObject:@"herd"];
    
    [arrOne addObject:@"galaxy"];
    [arrOne addObject:@"hormone"];
    [arrOne addObject:@"rogue"];
    
    [arrOne addObject:@"peal"];
    [arrOne addObject:@"summit"];
    [arrOne addObject:@"thigh"];
    
    [arrOne addObject:@"resemble"];
    [arrOne addObject:@"velocity"];
    [arrOne addObject:@"phobia"];
    //12
    [arrOne addObject:@"raffle"];
    [arrOne addObject:@"peel"];
    [arrOne addObject:@"rhino"];
    
    [arrOne addObject:@"assemble"];
    [arrOne addObject:@"inquire"];
    [arrOne addObject:@"rust"];
    
    [arrOne addObject:@"exaggerate"];
    [arrOne addObject:@"gawk"];
    [arrOne addObject:@"strive"];
    //15
    [arrOne addObject:@"morph"];
    [arrOne addObject:@"inquest"];
    [arrOne addObject:@"audit"];
    
    [arrOne addObject:@"abolish"];
    [arrOne addObject:@"nasal"];
    [arrOne addObject:@"leer"];
    
    [arrOne addObject:@"depreciate"];
    [arrOne addObject:@"stipend"];
#elif CHINESE
    [arrOne addObject:@"上"];
    [arrOne addObject:@"了"];
    [arrOne addObject:@"个"];
    
    [arrOne addObject:@"在"];
    [arrOne addObject:@"外"];
    [arrOne addObject:@"新"];
    
    [arrOne addObject:@"地方"];
    [arrOne addObject:@"短"];
    [arrOne addObject:@"小心"];
    
    [arrOne addObject:@"国际"];
    [arrOne addObject:@"大夫"];
    [arrOne addObject:@"词典"];
    
    [arrOne addObject:@"博物馆"];
    [arrOne addObject:@"小说"];
    [arrOne addObject:@"现代"];
    
    [arrOne addObject:@"力量"];
    [arrOne addObject:@"平均"];
    [arrOne addObject:@"汽油"];
    
    [arrOne addObject:@"哲学"];
    [arrOne addObject:@"说不定"];
    [arrOne addObject:@"卫生间"];
    
    [arrOne addObject:@"报到"];
    [arrOne addObject:@"爱不释手"];
    [arrOne addObject:@"打官司"];
    
    [arrOne addObject:@"根深蒂固"];
    [arrOne addObject:@"观光"];
    [arrOne addObject:@"继往开来"];
    
    [arrOne addObject:@"品尝"];
    [arrOne addObject:@"期望"];
    [arrOne addObject:@"理直气壮"];
    
    [arrOne addObject:@"师范"];
    [arrOne addObject:@"社区"];
    [arrOne addObject:@"讨价还价"];
    
    [arrOne addObject:@"众所周知"];
    [arrOne addObject:@"遥控"];
    [arrOne addObject:@"驻扎"];
#endif
    for (NSInteger i = 0; i < [arrOne count]; ++i) {
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
        [dicOne setValue:[arrOne objectAtIndex:i]  forKey:@"Word"];
        NSInteger intLevel = (i / 3) + 1;
        [dicOne setValue:[NSNumber numberWithInt:intLevel]  forKey:@"WordGroup"];
        [arrWordList addObject:dicOne];    
    }
    
    DLog(@"arrWordList : %@", arrWordList);
    
    flashCardController.arrWordsList = arrWordList;
    
    flashCardController.intBookTblNo = 0;
    flashCardController.intDicListType = DicListType_TBL_EngDic;
    flashCardController.intFlashCardType = intFlashCardType_TestLevel;
    
    [self.navigationController pushViewController:flashCardController animated:YES];
}
- (void) updateDicByCategoryIfNotExists
{
    //dicByCategory테이블에 레코드가 하나도 없으며 레코드를 추가한다.
    NSString *strQuery = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",TBL_dicByCategory];
    
    [myCommon openDBMyDicInBundle];
    NSInteger cntRecOfMyDic = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
    NSInteger cntRecOfMyDicInBundle = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BUNDLE];
    
    if (cntRecOfMyDic < cntRecOfMyDicInBundle) {
       
        
        NSString        *strDBPathInBundle = [[NSBundle mainBundle] pathForResource:@"MyEnglish" ofType:@"sqlite"];
        sqlite3 *dbInBundle = nil;
        if (sqlite3_open([strDBPathInBundle UTF8String], &dbInBundle) != SQLITE_OK)
        {
            sqlite3_close(dbInBundle);
            DLog(@"Can't open DB : %@", strDBPathInBundle);
            return;
        }


        NSInteger intdicMyCategory = FLD_NO_ENG_DIC_CATEGORY_1;
        for (NSInteger i = 1; i <= cntRecOfMyDicInBundle; ++i) {            
            //필드를 만들고
            NSString *strFieldName = [NSString stringWithFormat:@"CATEGORY%d", i];
            if ([myCommon chkFieldExist:strFieldName TableName:[NSString stringWithFormat:@"%@", TBL_EngDic] OpenMyDic:TRUE] == FALSE) {
                strQuery = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ CHAR DEFAULT \"0\"", TBL_EngDic, strFieldName];
                [myCommon executeSqlQuery:strQuery openMyDic:TRUE];
            }
            
            //필드의 내용을 번들에 있는 테이블에서 가지고 와서 채우고            
            strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = \"1\" ",TBL_EngDic, strFieldName];
            DLog(@"strQuery : %@", strQuery);
            const char *sqlQuery = [strQuery UTF8String];
            sqlite3_stmt *stmt = nil;
            
            int ret = sqlite3_prepare_v2(dbInBundle, sqlQuery, -1, &stmt, NULL);
            if (ret == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    NSString *strdicMyCategory = @"";
                    char *localityChars = (char*)sqlite3_column_text(stmt, intdicMyCategory + i - 1);			
                    if (localityChars == NULL)
                        strdicMyCategory = @"";
                    else
                        strdicMyCategory = [NSString stringWithUTF8String:localityChars];
                    
                    NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
                    if (strWord == NULL) {
                        continue;
                    }
                    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                    
//                    NSString *strdicMyCategory = @"";
//                    char *localityChars = (char*)sqlite3_column_text(stmt, intdicMyCategory + i - 1);			
//                    if (localityChars == NULL)
//                        strdicMyCategory = @"";
//                    else
//                        strdicMyCategory = [NSString stringWithUTF8String:localityChars];						

                    if ([strdicMyCategory isEqualToString:@"1"]) {
                        //
                        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = \"1\" WHERE %@ = '%@'", TBL_EngDic, strFieldName, FldName_Word, strWordForSQL];
                        [myCommon changeRec:strQuery openMyDic:TRUE];
                    }
                }
            }
            

            //dicByCategory에 레코드를 추가한다.
            strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = \"%@\" ",TBL_dicByCategory, FldName_CATEGORYNAME, strFieldName];
            DLog(@"strQuery : %@", strQuery);
            sqlQuery = [strQuery UTF8String];
            stmt = nil;
            
            ret = sqlite3_prepare_v2(dbInBundle, sqlQuery, -1, &stmt, NULL);
            if (ret == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    NSString *strFieldName = @"";
                    char *charFieldName = (char*)sqlite3_column_text(stmt, FLD_NO_TBL_EngDic_dicByCategory_FIELDNAME);			
                    if (charFieldName == NULL)
                        strFieldName = @"";
                    else
                        strFieldName = [NSString stringWithUTF8String:charFieldName];		
                    
                    NSString *strCategoryName = @"";
                    char *charCategoryName = (char*)sqlite3_column_text(stmt, FLD_NO_TBL_EngDic_dicByCategory_CATEGORYNAME);			
                    if (charCategoryName == NULL)
                        strCategoryName = @"";
                    else
                        strCategoryName = [NSString stringWithUTF8String:charCategoryName];						

                    NSString *strUSE = @"";
                    char *charUSE = (char*)sqlite3_column_text(stmt, FLD_NO_TBL_EngDic_dicByCategory_USE);			
                    if (charUSE == NULL)
                        strUSE = @"";
                    else
                        strUSE = [NSString stringWithUTF8String:charUSE];						

                    strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_dicByCategory, FldName_FIELDNAME, strFieldName];
                    if ([myCommon chkRecExist:strQuery openMyDic:OPEN_DIC_DB] == FALSE) {
                        strQuery = [NSString	stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@) VALUES('%@', '%@', '%@')", TBL_dicByCategory, FldName_FIELDNAME, FldName_CATEGORYNAME, FldName_USE, strFieldName, strCategoryName, strUSE];
                        [myCommon changeRec:strQuery openMyDic:TRUE];
                    }
                    
                }
            }

            
            
            sqlite3_reset(stmt);
            sqlite3_finalize(stmt);
        }        
        sqlite3_close(dbInBundle);
//        sqlite3_close(dbMyDic);
    }
    [myCommon closeDBMyDicInBundle];                                           
}
- (void) editTable
{
    [myCommon editTable:tblLevel viewController:self];
    [self.tblLevel reloadData];
}

- (void) addCategoryFile
{
//    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveCategory)];
//    
//    self.navigationItem.rightBarButtonItem = saveButton;
//    [saveButton release];
    
    
    intMode = intModeLoadTextATUserDic;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:tblLevel];
    
    [SVProgressHUD showProgress:-1 status:@""];
    
    
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(getBookList:)
                                   userInfo:nil
                                    repeats:NO];

    
//    NSString *strFullFileName = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], [arrDocList objectAtIndex:indexPath.row]];        
//    txtViewSetWords.text = [NSString stringWithFormat:@"%@", [myCommon readTxt:strFullFileName]];
//    //        [txtViewSetWords setContentOffset:CGPointMake(0,0) animated:YES];            
//    [txtViewSetWords scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//    
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:2.8f];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblLevel cache:YES];       
//    [UIView commitAnimations];
//    [self.view bringSubviewToFront:txtViewSetWords];
}

- (void) saveCategory
{
    if ([txtViewSetWords.text isEqualToString:@""]) {
        NSString *strMsg = [NSString stringWithFormat:@"%@", NSLocalizedString(@"There is no name to make a category.", @"")];
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];  
        return;
    }
    
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Category's Name", @"")		   
                                                     message:@"\n\n" // 중요!! 칸을 내려주는 역할을 합니다.							   
                                                    delegate:self                                 
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"")								   
                                           otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    prompt.tag = 1;	
    txtNewCategory.text = @"";
    [prompt addSubview:txtNewCategory]; 	
    [txtNewCategory becomeFirstResponder]; 
    [prompt show];	
}
- (void) CallSave
{
    BOOL blnChanged = FALSE;
    DLog(@"arrSetLevel : %d", [arrWordGroup count]);
    //하나라도 All Known이나 All Unknown 이면... 저장할게 있다고 본다.
    for (NSInteger i = 0; i < [arrWordGroup count]; i++) {
        NSMutableDictionary *dicOneTemp = [self.arrWordGroup	objectAtIndex:i];
        NSString *strSegConSelIndexTemp = [dicOneTemp objectForKey:@"SegConSelIndex"];
        if ([strSegConSelIndexTemp isEqualToString:NSLocalizedString(@"Original", @"")] == FALSE) {
            blnChanged = TRUE;
            break;
        }
    }
    
    if (blnChanged == FALSE) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Nothing to save", @"")];
        return;
    }
    [SVProgressHUD showProgress:-1 status:@""];
    [self performSelector:@selector(save) withObject:nil afterDelay:0.0]; 
}

- (void) save
{
    [self makeBackUp];
    NSString *strQuery = @"";
    DLog(@"Before arrSetLevel : %@", arrWordGroup);
    //단어 전체가 아닌 Level별로 조정할때...
    for (NSInteger i = 0; i < [arrWordGroup count]; i++) {
        NSMutableDictionary *dicOne = [self.arrWordGroup	objectAtIndex:i];
        NSString *strSegConSelIndex = [dicOne objectForKey:@"SegConSelIndex"];
        strSegConSelIndex = [dicOne objectForKey:@"SegConSelIndex"];
        DLog(@"dicOne : %@", dicOne);
        DLog(@"strSegConSelIndex : %@", strSegConSelIndex);
         if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"Original", @"")] == FALSE) {
             //Original이 아닐때 조정을 한다.
              if ([strSegConSelIndex isEqualToString:NSLocalizedString(@"All Known", @"")] == TRUE) {
                  //단어의 아는정도와 발음의 아는정도를 KnowWord_Known로 업데이트 한다.
                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = %d", TBL_EngDic, FldName_Know, KnowWord_Known,FldName_KnowPronounce, KnowWord_Known, FldName_WORDLEVEL1, i+1];
                  [myCommon changeRec:strQuery openMyDic:TRUE];
                  
//                  //단어의 아는정도가 KnowWord_NotRated인것은 발음의 아는정도를 KnowWord_Known로 업데이트 한다.
//                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = %d and %@ = %d", TBL_EngDic, FldName_KnowPronounce, KnowWord_Known, FldName_WORDLEVEL1, i+1, FldName_Know, KnowWord_NotRated];
//                  [myCommon changeRec:strQuery openMyDic:TRUE];
//                  
//                  //그다음에 단어의 아는정도를 KnowWord_Known로 업데이트 한다.
//                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = %d", TBL_EngDic, FldName_Know, KnowWord_Known, FldName_WORDLEVEL1, i+1];
//                  [myCommon changeRec:strQuery openMyDic:TRUE];
              } else {
                  //단어의 아는정도와 발음의 아는정도를 KnowWord_Unknown로 업데이트 한다.
                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = %d", TBL_EngDic, FldName_Know, KnowWord_Unknown, FldName_KnowPronounce, KnowWord_Unknown, FldName_WORDLEVEL1, i+1];
                  [myCommon changeRec:strQuery openMyDic:TRUE];
                  
//                  //단어의 아는정도가 KnowWord_NotRated인것은 발음의 아는정도를 KnowWord_Unknown로 업데이트 한다.
//                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = %d and %@ = %d", TBL_EngDic, FldName_Know, KnowWord_Unknown, FldName_WORDLEVEL1, i+1, FldName_Know, KnowWord_NotRated];
//                  [myCommon changeRec:strQuery openMyDic:TRUE];
//                  
//                  //그다음에 단어의 아는정도를 KnowWord_Unknown로 업데이트 한다.
//                  strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = %d", TBL_EngDic, FldName_Know, KnowWord_Unknown, FldName_WORDLEVEL1, i+1];
//                  [myCommon changeRec:strQuery openMyDic:TRUE];
              }
         }
        [dicOne setObject:NSLocalizedString(@"Original", @"") forKey:@"SegConSelIndex"];
    }
    DLog(@"After arrSetLevel : %@", arrWordGroup);

    [self getWordGroup:nil];
    [SVProgressHUD dismiss];
}
- (BOOL) makeBackUp
{
    NSString *strFileName = [[[myCommon getDBPath] lastPathComponent] stringByDeletingPathExtension];		
    strFileName = [NSString stringWithFormat:@"%@_%@.sqlite", strFileName, [myCommon getCurrentDatAndTimeForBackup]];
    
    
    NSString *strFileOri = [myCommon getDBPath];
    NSString *strFileTarget = [NSString	stringWithFormat:@"%@/%@", [myCommon getDocPath], strFileName];
    DLog(@"strFileName : %@", strFileName);
    DLog(@"strFileOri : %@", strFileOri);
    DLog(@"strFileTarget : %@", strFileTarget);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    [fm removeItemAtPath:strFileTarget error:&error];
    BOOL success = [fm copyItemAtPath:strFileOri toPath:strFileTarget error:&error];
    if (!success) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Fail to make a backup file.", @"")];
        
    } else {    
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Made a backup file", @"")];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
            DLog(@"strFileTarget : %@", strFileTarget);
            NSURL *pathURL= [NSURL fileURLWithPath:strFileTarget];                
            if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                DLog(@"Success : addSkipBackupAttributeToItemAtURL");
            } else {
                DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
            }            
        }            
#endif        
    }
    [SVProgressHUD dismiss];
    return success;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tblLevel reloadData];
}

@end
