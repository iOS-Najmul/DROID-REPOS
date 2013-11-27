//
//  WordDetail.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 1. 27..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "WordDetail.h"
#import "myCommon.h"
#import "WebDicController.h"
#import "WordDetailEditViewController.h"
#import "SVProgressHUD.h"

#define intChangeKnownOrUnKnownProunce 1
#define intChangeKnownOrUnKnownWord 2

@implementation WordDetail
@synthesize intDicWordOrIdiom;
@synthesize _strWord, _strWordFirst, _strWordFirstSampleText, arrLevel, arrKnow, _arrWords, _dicWord;
@synthesize tblViewGroup, tblViewDetail, txtView, tabBarOne;
@synthesize keyboardVisible, intBeforeSegSelectedTag, intBookTblNo, lblAlarmSaved, lblWordLevel;
@synthesize strBookTblName, blnFirstWordOpen;
@synthesize txtWordIndexInArrWords, txtWordOriIndexInArrWords, viewNewHeadword, txtNewHeadword;
@synthesize arrSampleSentences, viewSampleSentenceMain, viewSampleSnetneceSegCon, segConSampleSentence, txtViewSampleSentenceEng, txtViewSampleSentenceKor, tblViewSampleSentence;
//@synthesize dicWordsForQuiz;
@synthesize pickerKnowPronounce, strKnowPronounceInPickerView, viewSelectKnowPronounce, btnCancelKnowPronounce, btnSelectKnowPronounce, strKnowPronounceChangedTemp, strKnowWordInPickerView, strKnowWordChangedTemp;
@synthesize lblNewHeadword, intChangeKnownOrUnKnownWhat;
@synthesize _lblWordInCell, _lblMeaningInCell, _lblPronounceInCell, _lblTraditionalChineseInCell, _strProverb, _arrWordsInProverb;
//@synthesize _strWordOri, _strMeaning, _strPronounce, _strTraditionalChinese;
@synthesize _btnChangeKnowing, _btnChangeKnowingPronounce;
@synthesize _txtFldWord, _lblDescInCell; //_strDesc,
@synthesize viewSegControl, lblKnowWord, lblKnowPronounce;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [myCommon closeDB:true];
    [myCommon openDB:true];
    
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;

	UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;

    [SVProgressHUD showProgress:-1 status:@""];
    
    CGRect viewNewHeadwordFrame = CGRectMake(0.0, -viewNewHeadword.frame.size.height, appWidth, viewNewHeadword.frame.size.height);
    self.viewNewHeadword.frame = viewNewHeadwordFrame;
    [self.view bringSubviewToFront:viewNewHeadword];
	
    
//    segConKnow.selectedSegmentIndex = 2;
    
    CGRect viewSegControlFrame = CGRectMake(0.0, 0.0, appWidth, viewNewHeadword.frame.size.height);
    self.viewSegControl.frame = viewSegControlFrame;
    segConKnow.momentary = NO;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        segConKnow.frame = CGRectMake((appWidth - 280) / 2, 10, 280, 30);
    } else {
        segConKnow.frame = CGRectMake(20, 10, 280, 30);
    }
    self.tblViewGroup.tableHeaderView = nil;
//    [self.viewSegControl addSubview:segConKnow];
    [self.view sendSubviewToBack:viewSegControl];


    //단어를 바꿀때 적을 텍스트필드
    _txtFldWord = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
    _txtFldWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _txtFldWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtFldWord.backgroundColor = [UIColor whiteColor];

    lblKnowWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    lblKnowWord.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    lblKnowWord.backgroundColor = [UIColor clearColor];

    lblKnowPronounce = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    lblKnowPronounce.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    lblKnowPronounce.backgroundColor = [UIColor clearColor];

    _lblDescInCell = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblDescInCell.lineBreakMode = UILineBreakModeCharacterWrap;
    _lblDescInCell.numberOfLines = 0;
    _lblDescInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    _lblDescInCell.backgroundColor = [UIColor clearColor];
    
    _lblWordInCell = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblWordInCell.numberOfLines = 0;
    _lblWordInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    _lblWordInCell.backgroundColor = [UIColor clearColor];
    
       
    _lblMeaningInCell = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblMeaningInCell.lineBreakMode = UILineBreakModeCharacterWrap;
    _lblMeaningInCell.numberOfLines = 0;
    _lblMeaningInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    _lblMeaningInCell.backgroundColor = [UIColor clearColor];
    
    _lblPronounceInCell = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblPronounceInCell.numberOfLines = 0;
    _lblPronounceInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    _lblPronounceInCell.backgroundColor = [UIColor clearColor];
    
    _lblTraditionalChineseInCell = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblTraditionalChineseInCell.numberOfLines = 0;
    _lblTraditionalChineseInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
    _lblTraditionalChineseInCell.backgroundColor = [UIColor clearColor];
    

    _btnChangeKnowing  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnChangeKnowing.frame = CGRectMake(0, 0, 50, 30);
    [_btnChangeKnowing setTitle:@"X?!" forState:UIControlStateNormal];
    [_btnChangeKnowing setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_btnChangeKnowing addTarget:self action:@selector(onBtnKnowWordChange:) forControlEvents:UIControlEventTouchUpInside];

    _btnChangeKnowingPronounce  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnChangeKnowingPronounce.frame = CGRectMake(0, 0, 50, 30);
    [_btnChangeKnowingPronounce setTitle:@"X?!" forState:UIControlStateNormal];
    [_btnChangeKnowingPronounce setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [_btnChangeKnowingPronounce addTarget:self action:@selector(onBtnKnowPronounceChange:) forControlEvents:UIControlEventTouchUpInside];

    _dicWord = [[NSMutableDictionary alloc] init];
	_arrWords = [[NSMutableArray alloc] init];
    arrSampleSentences = [[NSMutableArray alloc] init];


    _strProverb = [NSString stringWithString:_strWord];
    _arrWordsInProverb = [[NSMutableArray alloc] init];
    
    txtWordOriIndexInArrWords = -1;
    txtWordIndexInArrWords = -1;
	intBeforeSegSelectedTag = 1;
	
    lblAlarmSaved.text = [NSString stringWithFormat:@"%@...",NSLocalizedString(@"Saved", @"")]; 
    
    lblNewHeadword.text = NSLocalizedString(@"Headword", @"");

//    CGRect viewSelectKnowPronounceFrame = CGRectMake(0.0, appHeight, appWidth, viewSelectKnowPronounce.frame.size.height);
//    self.viewSelectKnowPronounce.frame = viewSelectKnowPronounceFrame;
    viewSelectKnowPronounce.hidden = YES;
//    [self.view addSubview:viewSelectKnowPronounce];
    
    
	arrLevel = [[NSArray alloc] initWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"99",nil];
	arrKnow = [[NSArray alloc] initWithObjects:@"None", @"Know?", @"Know!", nil];
    
    self.blnFirstWordOpen = FALSE;
    self.strKnowPronounceChangedTemp = @"0";
    

    self._strWord = [_strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //DLog(@"_strWord : %@", _strWord);
    
    self._strWordOri = @"";
    
    //밑의 순서는 바꾸면 안된다.
    [self getWordsFromTbl];
    [self.tblViewDetail reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self getEachWordFromTbl];
    
    if (indexPathTblViewDetailsNeedReload) {
        
        [self reloadRow:indexPathTblViewDetailsNeedReload ofTableView:self.tblViewDetail];
    }
    [self didRotateFromInterfaceOrientation:[UIDevice currentDevice].orientation];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = _strWord;
    [SVProgressHUD dismiss];
}

-(void)reloadRow:(NSIndexPath*)indexPath ofTableView:(UITableView*)tableView{

    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

-(IBAction) back {

    // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(callStartAiv:)
                                   userInfo:nil
                                    repeats:NO];
	
}

- (void) callStartAiv:(NSTimer*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getWordInfoFromArray
{
    //DLog(@"_arrWord : %@", _arrWords);
    
    NSString *strMeaningOri = @"";
    NSString *strDescOri = @"";
    //단어의 WordOri와 MeaningOri를 가져온다.
    for (int i = 0; i < [_arrWords count]; i++) {
        NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
        NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
        NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
        //DLog(@"dicOne : %@", dicOne);
        if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE) {
            //단어의 원형이면...
            strDescOri = [dicOne objectForKey:KEY_DIC_DescChanged];
            strMeaningOri = [dicOne objectForKey:KEY_DIC_MeaningChanged];
            
            break;
        }
    }
    
    //현재 단어의 정보를 가져온다.
    for (int i = 0; i < [_arrWords count]; i++) {
        NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
        NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
        if ([[strWord lowercaseString] isEqualToString:[_strWord lowercaseString]] == TRUE) {
            _dicWord = [_arrWords objectAtIndex:i];
            NSString *strDesc = [_dicWord objectForKey:KEY_DIC_DescChanged];
            [_dicWord setObject:strDesc forKey:KEY_DIC_DescChanged];

            NSString *strPronounce = [_dicWord objectForKey:KEY_DIC_PronounceChanged];
            NSInteger intKnowPronounce = [[_dicWord objectForKey:KEY_DIC_KnowPronounceChanged] integerValue];
            if ( ([strPronounce length] > 0) && (intKnowPronounce == KnowWord_NotRated) ) {
                //발음이 있고 발음기호를 아직 설정하지 않았으면...
    #ifdef ENGLISH
                //영어버전에서는 아는단어로 설정한다.
                [_dicWord setObject:[NSNumber numberWithInt:KnowWord_Known] forKey:KEY_DIC_KnowPronounceChanged];
//                self._intKnowPronounce = KnowWord_Known;
    #elif CHINSE
                //중국어버젼에서는 모르는 단어로 설정한다.
                [_dicWord setObject:[NSNumber numberWithInt:KnowWord_UnKnown] forKey:KEY_DIC_KnowPronounceChanged];
//                self._intKnowPronounce = KnowWord_UnKnown;
    #endif
            }
            [_dicWord setObject:strDescOri forKey:KEY_DIC_DescChanged];
            //DLog(@"_dicWOrd : %@", _dicWord);
            [self.tblViewDetail reloadData];
            break;
        }
    }
    
//    //현재 단어의 뜻이 없으면 원형의 뜻을 넣어준다.
//    if ([self._strMeaning isEqualToString:@""]) {
//        self._strMeaning = [NSString stringWithString:strMeaningOri];
//    }
    
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)selSegControl:(id)sender
{	
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
		[self onOpenWebDic];
	} else 	if( [sel selectedSegmentIndex] == 1 ){
        
        self._strWord = [_strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        NSRange rngWord = [_strWord rangeOfString:@" "];
        //DLog(@"rngWord : %@", [NSValue valueWithRange:rngWord]);
        NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
        BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:_strWord dicWordWithOri:dicIdiom];
        
        if (rngWord.length > 0) {
            //공백이 있으면... (숙어, 문장등일때)            
            //DLog(@"dicIdiom : %@", dicIdiom);
            if (blnWordOrIdiomExistInDic == FALSE) {
                //숙어의 경우 사전에 있는것만 허락한다.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You can't add new idiom or sentence.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                return;
            } else {
                [self OnSaveWord];
            }
        } else {
            //그냥 한개의 단어이면...
            if (blnWordOrIdiomExistInDic == TRUE) {
                //현재 사전에 있는 단어이면 바로 저장한다.
                [self OnSaveWord];
            } else {
                //현재 사전에 없는 단어이면 추가할것이냐고 물어보고 한다.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The word is not in the dictionary. Do you want to add it?", @"")
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                      otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                
                alert.tag = 3;
                [alert show];
            }
        }
	}
}

- (IBAction) OnSaveWord
{

    NSString	*strWord = [_strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString	*strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
	if ([strWordForSQL isEqualToString:@""] == TRUE) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Need a word to save.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert show];
		
		return;
	}
	
	//DLog(@"strWordInTxtField : %@", strWordForSQL);
	//저장했다는 뷰가 나타나고 자동으로 사라진다.
    
	[SVProgressHUD showSuccessWithStatus:@"Saved Successfully"];

    NSString	*strMeaningOri = @"";
    NSString	*strWordOri = [myCommon getOriWithWordOrIdiom:_strWord];//[NSString stringWithString:_strWord];
    NSString	*strDescWordOri = @"";
    
    for (NSDictionary *dicOne in _arrWords) {
        NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
        NSString *strWordOriTemp = [dicOne objectForKey:KEY_DIC_WORD];
        if ([[strWord lowercaseString] isEqualToString:[strWordOriTemp lowercaseString] ] == TRUE) {
            strMeaningOri = [dicOne objectForKey:KEY_DIC_MEANING];
            strDescWordOri = [dicOne objectForKey:KEY_DIC_DescChanged];
            break;
        }
    }
    

    NSString	*strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
    //DLog(@"strWordOriForSQL ; %@", strWordOriForSQL);
    
    //DLog(@"arrWords : %@", _arrWords);
    //DLog(@"arrProverb : %@", _arrWordsInProverb);
    
    for (NSDictionary *dicOne in _arrWords) {
        NSString *strWord = [dicOne objectForKey:@"Word"];
        NSString *strKnow = [dicOne objectForKey:@"Know"];
        NSString *strKnowChanged = [dicOne objectForKey:KEY_DIC_KnowChanged];
        NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
        NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
//        strMeaning = [strMeaning stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//        strMeaningChanged = [strMeaningChanged stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *strPronounce= [dicOne objectForKey:@"Pronounce"];
//        strPronounce = [strPronounce stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *strPronounceChanged= [dicOne objectForKey:@"PronounceChanged"];
//        strPronounceChanged = [strPronounceChanged stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *strKnowPronounce = [dicOne objectForKey:@"KnowPronounce"];
        NSString *strKnowPronounceChanged = [dicOne objectForKey:@"KnowPronounceChanged"];
//        NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
        
        //DLog(@"dicOne : %@", dicOne);
        
        //DLog(@"strWord : %@", strWord);
        //DLog(@"strKnow : %@", strKnow);
        //DLog(@"strKnowChanged : %@", strKnowChanged);
        //DLog(@"strMeaning : %@", strMeaning);
        //DLog(@"strMeaningChanged : %@", strMeaningChanged);
        //DLog(@"strPronounce : %@", strPronounce);     
        //DLog(@"strPronounceChanged : %@", strPronounceChanged);             
        //DLog(@"strKnowPronounce : %@", strKnowPronounce);     
        //DLog(@"strKnowPronounceChanged : %@", strKnowPronounceChanged); 
        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
        
        if ([strKnow isEqualToString:@""]) {
            strKnow = @"0";
        }

        if (strKnowChanged != NULL) {
            strKnow = strKnowChanged;
        }

        if (strMeaningChanged != NULL) {
            strMeaning = strMeaningChanged;
        }

        if (strPronounceChanged != NULL) {
            strPronounce = strPronounceChanged;
        }

        if (strKnowPronounceChanged != NULL) {
            strKnowPronounce = strKnowPronounceChanged;
        }
        
        NSString *strPronounceForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strPronounce];
        NSString  *strMeanginForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strMeaning];

        
        NSString	*strQuery = nil;
        //원형일때...
        if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE) {
            //TBL_EngDic에 단어Ori가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다.
            NSString  *strDescWordOriForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strDescWordOri];
            
            [myCommon insertWordIfNotExist:strWord wordOriForSQL:@"" know:strKnow];
            
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_DESC, strDescWordOriForSQL, FldName_Meaning, strMeanginForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Pronounce, strPronounceForSQL, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            if (intBookTblNo > 0) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeanginForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (strBookTblName != NULL) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@'  WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_Meaning, strMeanginForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        } else {
            //원형이 아닐때....
            NSRange rngOne = [strWord rangeOfString:@" "];
            //DLog(@"rngOne : %@", [NSValue valueWithRange:rngOne]);
            
#ifdef ENGLISH
            //하나의 단어이면 (공백이 없으면...)
            if (rngOne.length == 0) {
                //DLog(@"strMeaning : %@", strMeaning);
                //DLog(@"strMeaningOri : %@", strMeaningOri);
                if ([strMeaning isEqualToString:strMeaningOri]) {
                    //단어의 뜻이 원형과 같으면 단어의 뜻은 따로 저장하지 않는다.(원형의 뜻을 그대로 쓴다.)
                    strMeaning = @"";
                    //DLog(@"strMeaning : %@", strMeaning);                
                }
            }
#endif
            
            //단어의 Desch는 넣지 않는다. (원형에만 넣도록 한다.)
//            NSString *strDesc = @"";
            
            strMeanginForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strMeaning];
//            NSString *strDescForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strDesc];
            
            
            //TBL_EngDic에 단어가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다. 
            [myCommon insertWordIfNotExist:strWord wordOriForSQL:@"" know:strKnow];
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@'  WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaning, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Pronounce, strPronounceForSQL, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            
            if (intBookTblNo > 0) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaning, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (strBookTblName != NULL) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic_BookTemp, FldName_Meaning, strMeaning, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        }
    }
           
	[self getWordsFromTbl];

    self.navigationItem.title = _strWord;
}

- (IBAction) onOpenWebDic
{
	WebDicController *webDicController = [[WebDicController alloc] initWithNibName:@"WebDicController" bundle:nil];
	webDicController.strWord = _strWord;
	[self.navigationController pushViewController:webDicController animated:YES];			
}

- (void) getWordsFromTbl
{
    [_dicWord removeAllObjects];
    [_arrWords removeAllObjects];

    self._strWord = [_strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *strWordOri = [NSString stringWithString:_strWord];
    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:_strWord];
    NSString* strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strWordForSQL];
    NSMutableArray *arrWordInfos = [[NSMutableArray alloc] init];;
    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWordInfos byDic:nil openMyDic:OPEN_DIC_DB];
    //DLog(@"_strWord : %@", _strWord);
    //DLog(@"strWordOri : %@", strWordOri);
    //DLog(@"arrWordInfos : %@", arrWordInfos);
    if ([arrWordInfos count] > 0) {
        //일단 맨처음 단어에서 단어의 원형을 가져온다.
        NSMutableDictionary *dicOne = [arrWordInfos objectAtIndex:0];
        //DLog(@"dicOne : %@", dicOne);
        strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
        [_arrWords addObject:dicOne];
    }
    

    if ((strWordOri != NULL) && ([strWordOri isEqualToString:@""] == FALSE) ) {
        //단어의 원형이 있으면 같은 원형을 가지는 단어의 정보를 가져온다. (이건 영어에서만 한다.)
#ifdef ENGLISH
        NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
        strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_WORDORI, strWordOriForSQL];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:_arrWords byDic:nil openMyDic:OPEN_DIC_DB];
#endif
    }
    //DLog(@"_arrWords : %@", _arrWords);
    //원형으로 단어를 못가져올때는 현재단어만 추가한다.
    if ([_arrWords count] == 0) {
        [_dicWord setValue:_strWord forKey:KEY_DIC_WORD];
        [_dicWord setValue:_strWord forKey:KEY_DIC_WORDORI];
        [_dicWord setValue:@"" forKey:@"Text"];
        [_dicWord setValue:@"" forKey:@"Meaning"];
        [_dicWord setValue:@"" forKey:KEY_DIC_MeaningChanged];
        [_dicWord setValue:@"0" forKey:@"Know"];
        [_dicWord setValue:@"0" forKey:KEY_DIC_KnowChanged];
        [_dicWord setValue:@"0" forKey:@"Count"];
        [_dicWord setValue:@"0" forKey:@"Level"];
        [_dicWord setValue:@"" forKey:@"Pronounce"];
        [_dicWord setValue:@"" forKey:KEY_DIC_PronounceChanged];
        [_dicWord setValue:@"" forKey:KEY_DIC_Desc];
        [_dicWord setValue:@"" forKey:KEY_DIC_DescChanged];
        [_dicWord setValue:@"0" forKey:@"KnowPronounce"];
        [_dicWord setValue:@"0" forKey:KEY_DIC_KnowPronounceChanged];
        
        [_arrWords addObject:_dicWord];
    } else {
        //_arrWords에서 현재 단어의 정보를 가져온다.
        for (int i = 0; i < [_arrWords count]; i++) {
            NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
            NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
            //DLog(@"strWord : %@", strWord);
            //DLog(@"_strWord : %@", _strWord);            
            if ([[strWord lowercaseString] isEqualToString:[_strWord lowercaseString]] == TRUE) {
                _dicWord = [_arrWords objectAtIndex:i];
            }
        }

    }

    //발음이 없을때 발음의 아는정도는 영어, 중국어에 따라서 다르게 표시하여 준다.
    NSString *strPronounce = [_dicWord objectForKey:KEY_DIC_PronounceChanged];
    NSInteger intKnowPronounce = [[_dicWord objectForKey:KEY_DIC_KnowPronounceChanged] integerValue];
    if ( ([strPronounce length] > 0) && (intKnowPronounce == KnowWord_NotRated) ) {
        //발음이 있고 발음기호를 아직 설정하지 않았으면...
#ifdef ENGLISH
        //영어버전에서는 아는단어로 설정한다.
        [_dicWord setObject:[NSNumber numberWithInt:KnowWord_Known] forKey:KEY_DIC_KnowPronounceChanged];
        //                self._intKnowPronounce = KnowWord_Known;
#elif CHINSE
        //중국어버젼에서는 모르는 단어로 설정한다.
        [_dicWord setObject:[NSNumber numberWithInt:KnowWord_UnKnown] forKey:KEY_DIC_KnowPronounceChanged];
        //                self._intKnowPronounce = KnowWord_UnKnown;
#endif
    }
    
    
    //단어의 정보들이 있을때... 현재 단어의 정보를 가져온다
    //왜 이걸 가져오지?
//    [self getWordInfoFromArray];
    
    //DLog(@"arrWords : %@", _arrWords);
    
    //DLog(@"dicWord : %@", _dicWord);
    NSSortDescriptor *publishedSorter = nil;
    publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"Word" ascending:YES];
    [_arrWords sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
 
    [self getEachWordFromTbl];
    //DLog(@"arrWords : %@", _arrWords);
}


- (void) getEachWordFromTbl
{
    
#ifdef ENGLISH
    NSRange rangeOne = [_strWord rangeOfString:@" "];
    
    //공백으로 구분된 두글자 이상이면
    if (rangeOne.location != NSNotFound) {
        
        [_arrWordsInProverb removeAllObjects];
        
        //DLog(@"arrWords : %@", _arrWords);
        NSArray *arrOne = [_strWord componentsSeparatedByString:@" "];
        
        for (NSString *strOneWithPunctuation in arrOne) {
            NSMutableArray *arrAlphabetAndPunctuationInOneWord = [myCommon getWordsAndPunctuationInSelectedWord:strOneWithPunctuation];
            //DLog(@"arrAlphabetAndPunctuationInOneWord : %@", arrAlphabetAndPunctuationInOneWord);
            //                NSString *strOneWord = [NSString stringWithString:strOneWordResultTrimmed];
            for (NSString *strOne in arrAlphabetAndPunctuationInOneWord) {
               
                //DLog(@"strOne : %@", strOne);
                NSString *strOneTrimmed = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                strOneTrimmed = [strOneTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneTrimmed];
                
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOneForSQL];
                NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrTemp byDic:nil openMyDic:OPEN_DIC_DB];
                
                //원형으로 단어를 못가져올때는 현재단어를 넣는다...
                if ([arrTemp count] > 0) {
                    [_arrWordsInProverb addObjectsFromArray:arrTemp];
                }
            }
        }
        //DLog(@"arrWordsInProverb : %@", _arrWordsInProverb);
    }

#elif CHINESE
    //중국어의 경우 한자의 번체자와 한글일때는 한자의 한글뜻을 넣어준다.
    NSString *regStrExceptChinese = @"[^\u4e00-\u4eff\u4f00-\u4fff\u5000-\u50ff\u5100-\u51ff\u5200-\u52ff\u5300-\u53ff\u5400-\u54ff\u5500-\u55ff\u5600-\u56ff\u5700-\u57ff\u5800-\u58ff\u5900-\u59ff\u5a00-\u5aff\u5b00-\u5bff\u5c00-\u5cff\u5d00-\u5dff\u5e00-\u5eff\u5f00-\u5fff\u6000-\u60ff\u6100-\u61ff\u6200-\u62ff\u6300-\u63ff\u6400-\u64ff\u6500-\u65ff\u6600-\u66ff\u6700-\u67ff\u6800-\u68ff\u6900-\u69ff\u6a00-\u6aff\u6b00-\u6bff\u6c00-\u6cff\u6d00-\u6dff\u6e00-\u6eff\u6f00-\u6fff\u7000-\u70ff\u7100-\u71ff\u7200-\u72ff\u7300-\u73ff\u7400-\u74ff\u7500-\u75ff\u7600-\u76ff\u7700-\u77ff\u7800-\u78ff\u7900-\u79ff\u7a00-\u7aff\u7b00-\u7bff\u7c00-\u7cff\u7d00-\u7dff\u7e00-\u7eff\u7f00-\u7fff\u8000-\u80ff\u8100-\u81ff\u8200-\u82ff\u8300-\u83ff\u8400-\u84ff\u8500-\u85ff\u8600-\u86ff\u8700-\u87ff\u8800-\u88ff\u8900-\u89ff\u8a00-\u8aff\u8b00-\u8bff\u8c00-\u8cff\u8d00-\u8dff\u8e00-\u8eff\u8f00-\u8fff\u9000-\u90ff\u9100-\u91ff\u9200-\u92ff\u9300-\u93ff\u9400-\u94ff\u9500-\u95ff\u9600-\u96ff\u9700-\u97ff\u9800-\u98ff\u9900-\u99ff\u9a00-\u9aff\u9b00-\u9bff\u9c00-\u9cff\u9d00-\u9dff\u9e00-\u9eff\u9f00-\u9fff]";
    
    
    //정규표현식으로 중국어의 경우에는 한자를 제외하고 다 지운다.
    NSError *err = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regStrExceptChinese options:NSRegularExpressionCaseInsensitive error:&err];
    NSString  *strHanjaOnly = [regEx stringByReplacingMatchesInString:_strWord options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [_strWord length]) withTemplate:@" "];
    //DLog(@"_strWord : %@", _strWord);
    strHanjaOnly = [strHanjaOnly stringByReplacingOccurrencesOfString:@" " withString:@""];
    //DLog(@"strHanjaOnly : %@", strHanjaOnly);
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    //    //DLog(@"lang : %@", languages);
    NSString *strOutputLang = [NSString stringWithFormat:@"%@", [languages objectAtIndex:0]];
    //DLog(@"strOutputLang : %@", strOutputLang);
    
    //DLog(@"locale : %@", [NSLocale currentLocale]);
    //DLog(@"locale : %@", [[NSLocale currentLocale] localeIdentifier]);
    
    [_arrWordsInProverb removeAllObjects];
    NSMutableString *strTraditionalHanjaAndKoreanMeaning = [[NSMutableString alloc] initWithFormat:@""];
    for (NSInteger i = 0; i < [strHanjaOnly length]; ++i) {
        NSString *strWord = [strHanjaOnly substringWithRange:NSMakeRange(i, 1)];
        //DLog(@"strWord : %@", strWord);
        NSString *strHanjaOnlyForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strWord];
        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strHanjaOnlyForSQL];
        NSMutableArray *arrHanjaOnly = [[NSMutableArray alloc] init];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrHanjaOnly byDic:nil openMyDic:OPEN_DIC_DB];
        //DLog(@"arrHanjaOnly : %@", arrHanjaOnly);
        if ([arrHanjaOnly count] == 1) {
            NSString *strTraditionalChinese = [[arrHanjaOnly objectAtIndex:0] objectForKey:KEY_DIC_WORDORI];
            NSString *strHanjaKoreanMeaning = [[arrHanjaOnly objectAtIndex:0] objectForKey:KEY_DIC_HanjaKoreanMeaning];
            //DLog(@"strTraditionalChinese : %@", strTraditionalChinese);
            //DLog(@"strHanjaKoreanMeaning : %@", strHanjaKoreanMeaning);
            
            if ( (strTraditionalChinese == NULL) || ([strTraditionalChinese isEqualToString:@""] == TRUE) ) {
                strTraditionalChinese = strWord;
            }
            
            if (strHanjaKoreanMeaning == NULL) {
                strHanjaKoreanMeaning = @"";
            }
            
            
            if ([strOutputLang isEqualToString:@"ko"]) {
                
                if ([strHanjaKoreanMeaning isEqualToString:@""]) {
                    //한자의 한글 뜻이 없으면...
                    [strTraditionalHanjaAndKoreanMeaning appendFormat:@"%@ ", strTraditionalChinese];
                } else {
                    //한자의 한글 뜻이 있으면...
                    [strTraditionalHanjaAndKoreanMeaning appendFormat:@"%@[%@] ", strTraditionalChinese, strHanjaKoreanMeaning];
                    
                }
            } else {
                //한글모드가 아니면 한글의 뜻은 안보여주고 번체자만 보여준다.
                [strTraditionalHanjaAndKoreanMeaning appendFormat:@"%@", strTraditionalChinese];
            }
            //DLog(@"strTraditionalHanjaAndKoreanMeaning : %@", strTraditionalHanjaAndKoreanMeaning);
            
            
            //각각의 단어를 _arrWordsInProverb에 넣는다.
            [_arrWordsInProverb addObjectsFromArray:arrHanjaOnly];
        }
    }
    //DLog(@"_arrWordsInProverb : %@", _arrWordsInProverb);
    
    [strTraditionalHanjaAndKoreanMeaning setString:[NSString stringWithFormat:@"%@\n\n%@", strHanjaOnly, strTraditionalHanjaAndKoreanMeaning]];
    
    //DLog(@"strTraditionalHanjaAndKoreanMeaning : %@", strTraditionalHanjaAndKoreanMeaning);
    
    [_dicWord setValue:strTraditionalHanjaAndKoreanMeaning forKey:KEY_DIC_HanjaKoreanMeaning];
    //    [_dicWord setValue:strHanjaOnly forKey:KEY_DIC_HanjaOnly];
    //DLog(@"_dicWord : %@", _dicWord);
#endif
}

- (IBAction) selSegConSmapleSentence
{
    
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (void) onBtnKnowWordChange:(id)sender
{
    intChangeKnownOrUnKnownWhat = intChangeKnownOrUnKnownWord;
    [self onBtnKnowWordOrPronounceChange];
}

- (void) onBtnKnowPronounceChange:(id)sender
{
    intChangeKnownOrUnKnownWhat = intChangeKnownOrUnKnownProunce;
    [self onBtnKnowWordOrPronounceChange];    
}

- (void) onBtnKnowWordOrPronounceChange
{

    [self.view bringSubviewToFront:viewSelectKnowPronounce];
    
    if (self.viewSelectKnowPronounce.hidden) {
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.4f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [ani setType:kCATransitionPush];
        [ani setSubtype:kCATransitionFromTop];
        self.viewSelectKnowPronounce.hidden = NO;
        [[viewSelectKnowPronounce layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    }

    [self.pickerKnowPronounce reloadAllComponents];
    NSInteger intSelRow = 1;
    //단어의 발음의 아는정도를 바꾸면...
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        NSInteger intKnowPronounceChangedAgain = 0;
        NSInteger intKnowPronounceChanged = [[_dicWord objectForKey:KEY_DIC_KnowPronounceChanged] integerValue];
        
        if (intKnowPronounceChanged == KnowWord_NotRated) {
            intSelRow = 2;
            lblKnowPronounce.text = KnowWord_StrUnknown;
            intKnowPronounceChangedAgain = KnowWord_Unknown;
        } else if (intKnowPronounceChanged == KnowWord_Unknown) {
            intSelRow = 2;
            lblKnowPronounce.text = KnowWord_StrUnknown;
            intKnowPronounceChangedAgain = KnowWord_Unknown;
        } else if (intKnowPronounceChanged == KnowWord_NotSure) {
            intSelRow = 1;
            lblKnowPronounce.text = KnowWord_StrNotSure;
            intKnowPronounceChangedAgain = KnowWord_NotSure;
        } else if (intKnowPronounceChanged == KnowWord_Known) {
            intSelRow = 0;
            lblKnowPronounce.text = KnowWord_StrKnown;
            intKnowPronounceChangedAgain = KnowWord_Known;
        }
        self.strKnowPronounceInPickerView = [NSString stringWithFormat:@"%d", intKnowPronounceChangedAgain];
        
        //현재 단어 발음의 Know를 바뀐것을 넣어준다.
        for (int i = 0; i < [_arrWords count]; i++) {
            NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
            NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
            if ([[strWord lowercaseString] isEqualToString:[_strWord lowercaseString]] == TRUE) {
                [_dicWord setObject:[NSNumber numberWithInt:intKnowPronounceChangedAgain] forKey:KEY_DIC_KnowPronounceChanged];
                break;
            }
        }
        
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        //단어의 아는정도를 바꾸면
        NSInteger intKnowChangedAgain = 0;
        NSInteger intKnowChanged = [[_dicWord objectForKey:KEY_DIC_KnowChanged] integerValue];
        if (intKnowChanged == KnowWord_NotRated) {
            intSelRow = 3;
            lblKnowWord.text = KnowWord_StrUnknown;
            intKnowChangedAgain = KnowWord_Unknown;
        } else if (intKnowChanged == KnowWord_Unknown) {
            intSelRow = 3;
            lblKnowWord.text = KnowWord_StrUnknown;
            intKnowChangedAgain = KnowWord_Unknown;
        } else if (intKnowChanged == KnowWord_NotSure) {
            intSelRow = 2;
            lblKnowWord.text = KnowWord_StrNotSure;
            intKnowChangedAgain = KnowWord_NotSure;
        } else if (intKnowChanged == KnowWord_Known) {
            intSelRow = 1;
            lblKnowWord.text = KnowWord_StrKnown;
            intKnowChangedAgain = KnowWord_Known;
        } else if (intKnowChanged == KnowWord_Exclude) {
            intSelRow = 0;
            lblKnowWord.text = KnowWord_StrExclude;
            intKnowChangedAgain = KnowWord_Exclude;
        }
        self.strKnowWordInPickerView = [NSString stringWithFormat:@"%d", intKnowChangedAgain];
        
        //현재 단어의 Know를 바뀐것을 넣어준다.
        for (int i = 0; i < [_arrWords count]; i++) {
            NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
            NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
            if ([[strWord lowercaseString] isEqualToString:[_strWord lowercaseString]] == TRUE) {
                [_dicWord setObject:[NSNumber numberWithInt:intKnowChangedAgain] forKey:KEY_DIC_KnowChanged];
                break;
            }
        }
    }
    [self.pickerKnowPronounce selectRow:intSelRow inComponent:0 animated:YES];
}

//피커뷰에 보이는 글자...
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrUnknown,  NSLocalizedString(@"Unknown", @"")];
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        if (row == 0) {
            strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrKnown,  NSLocalizedString(@"Known", @"")];;
        } else if (row == 1) {
            strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrNotSure,  NSLocalizedString(@"Not Sure", @"")];;
        }
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        if (row == 0) {
            strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrExclude,  NSLocalizedString(@"Exclude", @"")];;
        } else if (row == 1) {
            strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrKnown,  NSLocalizedString(@"Known", @"")];;
        } else if (row == 2) {
            strReturn = [NSString stringWithFormat:@"%@ : %@", KnowWord_StrNotSure,  NSLocalizedString(@"Not Sure", @"")];;
        }
    }
	return [NSString stringWithFormat:@"%@", strReturn];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        return 3;
    }
    return 4;
}

//피커뷰에서 선택한것을 적는다.
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        self.strKnowPronounceInPickerView = [NSString stringWithFormat:@"%d", KnowWord_Unknown];
        NSString *strKnow = KnowWord_StrUnknown;
//        _intKnowPronounce = KnowWord_Unknown;
        if (row == 0) {
            self.strKnowPronounceInPickerView = [NSString stringWithFormat:@"%d", KnowWord_Known];//@"3";
            strKnow = KnowWord_StrKnown;
//            _intKnowPronounce = KnowWord_Known;
        } else if (row == 1) {
            self.strKnowPronounceInPickerView = [NSString stringWithFormat:@"%d", KnowWord_NotSure];//@"2";
            strKnow = KnowWord_StrNotSure;
//            _intKnowPronounce = KnowWord_NotSure;
        }
        lblKnowPronounce.text = strKnow;
//        NSString *strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", _intKnowPronounce]];
//        [_btnChangeKnowingPronounce setTitle:strKnow forState:UIControlStateNormal];
        
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        self.strKnowWordInPickerView = [NSString stringWithFormat:@"%d", KnowWord_Unknown];
        NSString *strKnow = KnowWord_StrUnknown;
//        _intKnow = KnowWord_Unknown;
        if (row == 0) {
            self.strKnowWordInPickerView = [NSString stringWithFormat:@"%d", KnowWord_Exclude];
            strKnow = KnowWord_StrExclude;
//            _intKnow = KnowWord_Exclude;
        } else if (row == 1) {
            self.strKnowWordInPickerView =[NSString stringWithFormat:@"%d", KnowWord_Known];
            strKnow = KnowWord_StrKnown;
//            _intKnow = KnowWord_Known;
        } else if (row == 2) {
            self.strKnowWordInPickerView = [NSString stringWithFormat:@"%d", KnowWord_NotSure];
            strKnow = KnowWord_StrNotSure;
//            _intKnow = KnowWord_NotSure;
        }
        lblKnowWord.text = strKnow;
    }
}

- (IBAction) btnCancelKnowPronounce:(id)sender {
    //DLog(@"strKnowPronounceChangedTemp : %@", strKnowPronounceChangedTemp);
    NSString *strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", [[_dicWord objectForKey:KEY_DIC_KnowChanged] integerValue] ]];
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        lblKnowWord.text = strKnow;
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", [[_dicWord objectForKey:KEY_DIC_KnowPronounceChanged] integerValue]]];
        lblKnowPronounce.text = strKnow;
    }
    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.4f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromBottom];
    self.viewSelectKnowPronounce.hidden = YES;
    
    [[viewSelectKnowPronounce layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    
}

- (IBAction) btnSelectKnowPronounce:(id)sender{
    [self onKnowPronounceChanged];
    
    [self btnCancelKnowPronounce:nil];
    [self.tblViewDetail reloadData];
}

- (IBAction) onKnowPronounceChanged
{
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        self.strKnowPronounceChangedTemp = strKnowPronounceInPickerView;
        NSInteger intKnowPronounce = [strKnowPronounceChangedTemp integerValue];
        [_dicWord setObject:[NSNumber numberWithInt:intKnowPronounce] forKey:KEY_DIC_KnowPronounceChanged];
        
        NSString *strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", intKnowPronounce]];
        //DLog(@"intKnowPronounce : %d", intKnowPronounce);
        lblKnowPronounce.text = strKnow;
        
        //DLog(@"strKnowPronounceChangedTemp : %@", strKnowPronounceChangedTemp);
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        self.strKnowWordChangedTemp = strKnowWordInPickerView;
        NSInteger intKnow = [strKnowWordChangedTemp integerValue];
        [_dicWord setObject:[NSNumber numberWithInt:intKnow] forKey:KEY_DIC_KnowChanged];
        NSString *strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", intKnow]];
        lblKnowWord.text = strKnowWordChangedTemp;

        //DLog(@"intKnow : %d", intKnow);
        //DLog(@"strKnowWordChangedTemp : %@", strKnow);
    }
    
    txtWordIndexInArrWords = -1;
    //DLog(@"arrWords : %@", _arrWords);
    for (int i = 0; i < [_arrWords count]; i++) {
        NSDictionary *dicOne = [_arrWords objectAtIndex:i];
        NSString *strWord = [dicOne objectForKey:@"Word"];
        if ([[_strWord lowercaseString] isEqualToString:[strWord lowercaseString]] == TRUE) {
            //단어의 발음을 바꾸었을때... 그단어를 찾으면...
            txtWordIndexInArrWords = i;
            break;
        }
    }
    
    if (txtWordIndexInArrWords >= 0) {

        [_arrWords replaceObjectAtIndex:txtWordIndexInArrWords withObject:_dicWord];
        //DLog(@"arrWords after : %@", _arrWords);
        
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownWord) {
        NSInteger intKnow = 99;
        intKnow = 99;
        if (buttonIndex == 0) {
            intKnow = 99;
        } else if (buttonIndex == 1) {
            intKnow = 98;
        } else if (buttonIndex == 2) {
            intKnow = 91;
        }
        [_dicWord setObject:[NSNumber numberWithInt:intKnow] forKey:KEY_DIC_KnowChanged];
    } else if (intChangeKnownOrUnKnownWhat == intChangeKnownOrUnKnownProunce) {
        NSInteger intKnowPronounce = 99;
        intKnowPronounce = 99;
        if (buttonIndex == 0) {
            intKnowPronounce = 99;
        } else if (buttonIndex == 1) {
            intKnowPronounce = 98;
        } else if (buttonIndex == 2) {
            intKnowPronounce = 91;
        }
        [_dicWord setObject:[NSNumber numberWithInt:intKnowPronounce] forKey:KEY_DIC_KnowPronounceChanged];        
    }
}

#pragma mark -
#pragma mark NSNotification methods   
- (void) keyboardDidShow : (NSNotification*) notif
{
//	if (keyboardVisible) {
//		return;
//	}
////	self.navigationItem.rightBarButtonItem.enabled = FALSE;
////	if ([txtWordOri.text isEqualToString:@""] == TRUE) {
////		txtWordOri.text = txtWord.text;
////	}
//	keyboardVisible = YES;
}

- (void) keyboardDidHide : (NSNotification*) notif
{
//	if (!keyboardVisible) {
//		return;
//	}
////	self.navigationItem.rightBarButtonItem.enabled = TRUE;
//	keyboardVisible = NO;	
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == txtView) {
        [self.tblViewDetail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];

        //미해결질문)textview에서 테이블만 disable시키고 textview만 enable시키고 싶은데... 아래를 하면... paste가 안된다...

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Finish", @"") style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    } else {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Finish", @"") style:UIBarButtonItemStylePlain target:self action:@selector(doneEditingSampleSentence:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self doneEditing:nil];

}

- (void) doneEditing:(id)sender
{
    self.tblViewDetail.userInteractionEnabled = true;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		
    
    [self.txtView resignFirstResponder];
    [self.txtViewSampleSentenceEng resignFirstResponder];
    [self.txtViewSampleSentenceKor resignFirstResponder];
}

- (void) doneEditingSampleSentence:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(callSaveChangeKnowing)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangeSampleSentence)];
    self.navigationItem.leftBarButtonItem = leftButton;

    [self.tblViewSampleSentence reloadData];    
    [self.txtViewSampleSentenceEng resignFirstResponder];
    [self.txtViewSampleSentenceKor resignFirstResponder];
}

#pragma mark -
#pragma mark UITabBarDelegate methods   
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	//DLog(@"tabBar.tag : %d", tabBar.tag);
	//DLog(@"item.title : %@", item.title);
	//DLog(@"item.tag : %d", item.tag);
	//해결질문) item.tag가 왜 전부 0일까? 답변)tag에 값을 안주었으니까...-_-
	if ( ([item.title isEqualToString:@"Detail"] == TRUE) && (intBeforeSegSelectedTag != item.tag) ) {
		//self.navigationItem.leftBarButtonItem.enabled = TRUE;
        self.navigationItem.rightBarButtonItem = nil;
        UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
        [segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
        [segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
        segControl.tag = 1;
        segControl.momentary = TRUE;
        [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
        segControl.segmentedControlStyle = UISegmentedControlStyleBar;
        UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
        self.navigationItem.rightBarButtonItem = toAdd;		

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [tblViewGroup removeFromSuperview];
//        [self.view addSubview:tblViewDetail];
        tblViewDetail.hidden = NO;
        [UIView commitAnimations];
	} else if ( ([item.title isEqualToString:@"Group"] == TRUE) && (intBeforeSegSelectedTag != item.tag) ) {
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Headword" style:UIBarButtonItemStylePlain target:self action:@selector(changeHeadword)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
		[self getWordsFromTbl];
        [self.tblViewGroup reloadData];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//        [tblViewDetail removeFromSuperview];
        tblViewDetail.hidden = YES;
        [self.view addSubview:tblViewGroup];
        [UIView commitAnimations];
	}
	intBeforeSegSelectedTag = item.tag;
}

- (void) changeHeadword
{
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(callSaveChangeHeadword)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangeHeadword)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    txtNewHeadword.text = [_dicWord objectForKey:KEY_DIC_WORDORI];
    
    blnChangeHeadword = true;
    [self.tblViewGroup reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//    [tblViewDetail removeFromSuperview];
    tblViewDetail.hidden = YES;
    [self.view addSubview:tblViewGroup];
    [UIView commitAnimations];
    
    [self.tblViewGroup reloadData];
}

- (void) callSaveChangeHeadword
{
    [SVProgressHUD showProgress:-1 status:@""];
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(saveChangeHeadword:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) saveChangeHeadword:(NSTimer*)sender
{
    blnChangeHeadword = FALSE;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = nil;
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
    segControl.tag = 1;
    segControl.momentary = TRUE;
    [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    self.navigationItem.rightBarButtonItem = toAdd;		

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [tblViewGroup removeFromSuperview];
//    [self.view addSubview:tblViewDetail];
    tblViewDetail.hidden = NO;
    [UIView commitAnimations];
    
    NSString *strNewHeadwordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:txtNewHeadword.text];
    BOOL blnNewHeadwordExistInArrWords = false;
    //DLog(@"arrWords : %@", _arrWords);
    //현 그룹의 모든 단어의 원형을 바꾸어준다.
    for (NSDictionary *dicOne in self._arrWords) {
        NSString *strWord = [dicOne objectForKey:@"Word"];
        NSString *strKnow = [dicOne objectForKey:@"Know"];
        NSString *strKnowChanged = [dicOne objectForKey:KEY_DIC_KnowChanged];
        NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
        strMeaning = [strMeaning stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
        strMeaningChanged = [strMeaningChanged stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        //DLog(@"dicOne : %@", dicOne);
        
        if ([strKnow isEqualToString:@""]) {
            strKnow = @"0";
        }
        if ((strKnowChanged == NULL) || ([strKnowChanged isEqualToString:@""])) {
            //            strKnow = @"0"; 
        } else {
            strKnow = strKnowChanged;
        }
        
        if ((strMeaningChanged == NULL) || ([strMeaningChanged isEqualToString:@""])) {
            //            strKnow = @"0"; 
        } else {
            strMeaning = strMeaningChanged;
        }

        
        if ([strWord isEqualToString:strNewHeadwordForSQL]) {
            blnNewHeadwordExistInArrWords = true;
        }
        
        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
//        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];        
        //TBL_EngDic에 단어가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다. 
        
        NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES('%@', '%@', '%@', '%@', 0, 99, '')", TBL_EngDic, FldName_Word, FldName_WORDORI, FldName_Know, FldName_Meaning, FldName_ToMemorize, FldName_WORDLEVEL1, FldName_DESC, strWordForSQL, strNewHeadwordForSQL, strKnow, strMeaning ];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        
        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaning, FldName_WORDORI, strNewHeadwordForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        
        if (intBookTblNo > 0) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaning, FldName_WORDORI, strNewHeadwordForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];
        }
        if (strBookTblName != NULL) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_Meaning, strMeaning, FldName_WORDORI, strNewHeadwordForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
    }
    
    //만약 newHeadword가 arrWords에 없으면
    if (blnNewHeadwordExistInArrWords == FALSE) {
        //단어가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다. 
        [myCommon insertWordIfNotExist:txtNewHeadword.text wordOriForSQL:txtNewHeadword.text know:@"0"];
        NSString	*strQuery = nil;

        if (intBookTblNo > 0) {
            strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES('%@', '%@', '0', '', '', 0, 99)", TBL_EngDic, FldName_Word, FldName_WORDORI, FldName_Know, FldName_Meaning, FldName_DESC, FldName_ToMemorize, FldName_WORDLEVEL1, strNewHeadwordForSQL, strNewHeadwordForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];
        }
        if (strBookTblName != NULL) {
            strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES('%@', '%@', '0', '', '', 0, 99)", TBL_EngDic_BookTemp, FldName_Word, FldName_WORDORI, FldName_Know, FldName_Meaning, FldName_DESC, FldName_ToMemorize, FldName_WORDLEVEL1, strNewHeadwordForSQL, strNewHeadwordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
        //단어의 원형을 바꾸어준다...
        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_WORDORI, strNewHeadwordForSQL, FldName_Word, strNewHeadwordForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        if (intBookTblNo > 0) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_WORDORI, strNewHeadwordForSQL, FldName_Word, strNewHeadwordForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];
        }
        if (strBookTblName != NULL) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_WORDORI, strNewHeadwordForSQL, FldName_Word, strNewHeadwordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
    }
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strNewHeadwordForSQL];
	NSMutableArray *arrHeadword = [[NSMutableArray alloc] init];
    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrHeadword byDic:nil openMyDic:OPEN_DIC_DB];  
    
    if ([arrHeadword count] > 0) {
        NSDictionary *dicHeadword = [arrHeadword objectAtIndex:0];
    
        self._strWordOri = [dicHeadword objectForKey:@"Word"];
    }
    
    [txtNewHeadword resignFirstResponder];
    [self getWordsFromTbl];
}

- (void) cancelChangeHeadword
{
    blnChangeHeadword = FALSE;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
    segControl.tag = 1;
    segControl.momentary = TRUE;
    [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    self.navigationItem.rightBarButtonItem = toAdd;		

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [tblViewGroup removeFromSuperview];
//    [self.view addSubview:tblViewDetail];
    tblViewDetail.hidden = NO;
    [self.view sendSubviewToBack:viewSegControl];
    [UIView commitAnimations];
    
    for (int i = 0; i < [_arrWords count]; ++i) {
        NSDictionary *dicOne = [_arrWords objectAtIndex:i];
        [dicOne setValue:NULL forKey:KEY_DIC_KnowChanged];
        [_arrWords replaceObjectAtIndex:i withObject:dicOne];
    }

    [txtNewHeadword resignFirstResponder];
}

- (void) cancelChangeSampleSentence
{
    blnChangeHeadword = FALSE;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
    segControl.tag = 1;
    segControl.momentary = TRUE;
    [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    self.navigationItem.rightBarButtonItem = toAdd;		
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [tblViewSampleSentence removeFromSuperview];
//    [self.view addSubview:tblViewDetail];
    tblViewDetail.hidden = NO;
    [UIView commitAnimations];
    
    for (int i = 0; i < [_arrWords count]; ++i) {
        NSDictionary *dicOne = [_arrWords objectAtIndex:i];
        [dicOne setValue:NULL forKey:KEY_DIC_KnowChanged];
        [_arrWords replaceObjectAtIndex:i withObject:dicOne];
    }
}

- (void) changeKnowing
{
    [self.view bringSubviewToFront:viewSegControl];
//DLog(@"arrWords : %@", _arrWords);
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(callSaveChangeKnowing)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangeHeadword)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    txtNewHeadword.text = [_dicWord objectForKey:KEY_DIC_WORDORI];
    
    blnChangeHeadword = false;
    [self.tblViewGroup reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//    [tblViewDetail removeFromSuperview];
    tblViewDetail.hidden = YES;
    [self.view addSubview:tblViewGroup];
    [UIView commitAnimations];
    
    CGRect tblViewGroupFrame = CGRectMake(0.0, viewNewHeadword.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - viewNewHeadword.frame.size.height);
    self.tblViewGroup.frame = tblViewGroupFrame;
    
    [self.tblViewGroup reloadData];
}

- (void) callSaveChangeKnowing
{
    [SVProgressHUD showProgress:-1 status:@""];
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(saveChangeKnowing:)
                                   userInfo:nil
                                    repeats:NO];
}
- (void) saveChangeKnowing:(NSTimer*)sender
{
    blnChangeHeadword = FALSE;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = nil;
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 110, 30)];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"WebDic", @"") atIndex:0 animated:NO];
    [segControl insertSegmentWithTitle:NSLocalizedString(@"Save", @"") atIndex:1 animated:NO];
    segControl.tag = 1;
    segControl.momentary = TRUE;
    [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    self.navigationItem.rightBarButtonItem = toAdd;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [tblViewGroup removeFromSuperview];
//    [self.view addSubview:tblViewDetail];
    tblViewDetail.hidden = NO;
    [UIView commitAnimations];
    
//    //DLog(@"Before dicWordsForQuiz : %@", dicWordsForQuiz);
    //DLog(@"arrWords : %@", _arrWords);
    
    for (NSDictionary *dicOne in _arrWords) {
        NSString *strWord = [dicOne objectForKey:@"Word"];
        NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
        NSString	*strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
        
        NSString *strKnow = [dicOne objectForKey:@"Know"];
        NSString *strKnowChanged = [dicOne objectForKey:KEY_DIC_KnowChanged];
        NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
        NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
        NSString *strPronounce = [dicOne objectForKey:@"Pronounce"];

        NSString *strKnowPronounce = [dicOne objectForKey:@"KnowPronounce"];
        NSString *strKnowPronounceChanged = [dicOne objectForKey:@"KnowPronounceChanged"];
        NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
        NSString *strDescChanged = [dicOne objectForKey:KEY_DIC_DescChanged];
        
        //DLog(@"dicOne : %@", dicOne);
        
        if ([strKnow isEqualToString:@""]) {
            strKnow = @"0";
        }
        
        if (strKnowChanged != NULL) {
            strKnow = strKnowChanged;
        }

        if (strMeaningChanged != NULL) {
            strMeaning = strMeaningChanged;
        }
        
        if (strKnowPronounceChanged != NULL) {
            strKnowPronounce = strKnowPronounceChanged;
        }

        if (strDescChanged != NULL) {
            strDesc = strDescChanged;
        }
        
        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
        NSString *strMeaningForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strMeaning];
        NSString *strPronounceForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strPronounce];
        NSString *strDescForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strDesc];
//        //txtWord의 단어일때는 아는정도를 갱신한다.

        NSString	*strQuery = nil;
        //원형일때...
        if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE) {
            //TBL_EngDic에 단어Ori가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다.
            [myCommon insertWordIfNotExist:strWord wordOriForSQL:@"" know:strKnow];
            
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_DESC, strDescForSQL, FldName_Meaning, strMeaningForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Pronounce, strPronounceForSQL, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordOriForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            if (intBookTblNo > 0) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaningForSQL, FldName_Know, strKnow, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordOriForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (strBookTblName != NULL) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_Meaning, strMeaningForSQL, FldName_Know, strKnow, FldName_Word, strWordOriForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        } else {            
            //원형이 아니고 다른 뜻일때...
            //TBL_EngDic에 단어가 없으면 TBL_EngDic에만 추가하고 뜻은 TBL_EngDic과 다른테이블에도 있으면 같이 업데이트 한다. 
            [myCommon insertWordIfNotExist:strWord wordOriForSQL:@"" know:strKnow];
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaningForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Pronounce, strPronounceForSQL, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            
            if (intBookTblNo > 0) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_Meaning, strMeaningForSQL,  FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_KnowPronounce, strKnowPronounce, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (strBookTblName != NULL) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@', %@ = '%@', %@ = '%@' WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_Meaning, strMeaningForSQL, FldName_WORDORI, strWordOriForSQL, FldName_Know, strKnow, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        }
        
        //아는정도가 바뀌면 WordHistory에 저장한다.
        if ([dicOne objectForKey:KEY_DIC_KnowChanged] != NULL) {
            if ([[dicOne objectForKey:KEY_DIC_KnowChanged] isEqualToString:[dicOne objectForKey:@"Know"] ] == FALSE) {
                NSInteger intKnowBefore = [[dicOne objectForKey:@"Know"] integerValue];
                NSInteger intKnow = [[dicOne objectForKey:KEY_DIC_KnowChanged] integerValue];
                //현재단어의 아는정도를 MyEnglish에 업데이트 한다.
                [myCommon changeKnow:strWord know:intKnow knowBefore:intKnowBefore tblName:TBL_EngDic bookTblNo:intBookTblNo openMyDic:OPEN_DIC_DB];
                //책에 있는 단어도 아는정도를 업데이트 해준다.
                if (intBookTblNo > 0) {
                    [myCommon changeKnow:strWord know:intKnow knowBefore:intKnowBefore tblName:TBL_EngDic bookTblNo:intBookTblNo openMyDic:OPEN_DIC_DB_BOOK];
                }
            }
        }
        
    }

    [self getWordsFromTbl];
    [self.tblViewDetail reloadData];
    [self.view sendSubviewToBack:viewSegControl];
    [SVProgressHUD dismiss];
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {
		if (buttonIndex == 1) {
			[myCommon updateDeleteKnow];	
		}
	} else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSString *strWord = _txtFldWord.text;
            strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //바꾼것이 똑같은 글자이면 아무것도 안한다.
            if ([strWord isEqualToString:_strWord] == TRUE) {
                return;
            }
            
            NSRange rngWord = [strWord rangeOfString:@" "];
            //DLog(@"rngWord : %@", [NSValue valueWithRange:rngWord]);
            
            if (rngWord.length > 0) {
                //공백이 있으면... (숙어, 문장등일때)
                
                NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
                BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:strWord dicWordWithOri:dicIdiom];
                //DLog(@"dicIdiom : %@", dicIdiom);
                if (blnWordOrIdiomExistInDic == FALSE) {
                    //숙어의 경우 사전에 있는것만 허락한다.
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You can select idiom or sentence only in the dictionary.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }            
            _strWord = [NSString stringWithString:strWord];
            [self getWordsFromTbl];
            [self.tblViewDetail reloadData];
            
        }
        [_txtFldWord resignFirstResponder];
    } else if (alertView.tag == 3) {
        //단어가 없는 단어이면 추가할것이냐고 물어보면 YES일때만 추가한다.
        if (buttonIndex == 0) {
            return;
        } else if (buttonIndex == 1) {
            [self OnSaveWord];
        }
        
    }
    
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //DLog(@"numberOfSectionsInTableView");
    // Return the number of sections.
#ifdef ENGLISH
    if ([_arrWordsInProverb count] > 1) {
        //한글자 이상이면 한글자마다 단어와 뜻, 발음을 보여준다.
        return 2;
        
    } else {
        if (tableView == tblViewGroup)
        {
            return 1;
        } else if (tableView == tblViewDetail)
        {
            return 2;
        } else if (tableView == tblViewSampleSentence)
        {
            return 1;
        }
        
        return 2;
    }
#elif CHINESE
    if (tableView == tblViewDetail) {
        //한글자 이상이면 한글자마다 단어와 뜻, 발음을 보여준다.
        if ([_strWord length] <= 1) {
            return 1;
        } else {
            return 2;
        }
    } else if (tableView == tblViewSampleSentence) {
        return 1;
    }
    
    return 1;
#endif
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    // 영어 버전의 경우
#ifdef ENGLISH
    if ([_arrWordsInProverb count] > 1) {
        //한개의 단어가 아닐때...
        if (tableView == tblViewDetail) {
            
            if (section == 0) {
#ifdef DEBUG
                return 3;
#else
                return 2;
#endif
            } else if (section == 1) {
                //한글자 이상일때는 한글자에 해당되는 단어와 뜻, 발음을 보여준다.
                //DLog(@"[_arrWordsInProverb count] : %d", [_arrWordsInProverb count]);
                return [_arrWordsInProverb count];
            }
        }else if (tableView == tblViewSampleSentence) {
            return [arrSampleSentences count] + 1;
        }
        return 4;
    } else {
        //속담이 아니고 그냥 단어일때...
        if (tableView == tblViewGroup) {
            return [_arrWords count];
        } else if (tableView == tblViewDetail) {
            if (section == 0) {
    #ifdef DEBUG
                return 5;
    #else
                return 4;
    #endif
            } else if (section == 1) {
                if  ([_arrWords count] > 1) {
                    return [_arrWords count] + 1;
                } else {
                    return 0;
                }
                
//            } else if (section == 2) {
//                return [_arrWords count] + 1;
            }
        }else if (tableView == tblViewSampleSentence)
        {
            return [arrSampleSentences count] + 1;
        }
        return 4;
    }
    //중국어 버전의 경우
#elif CHINESE
    
    if (tableView == tblViewDetail) {
        if (section == 0) {
//#ifdef DEBUG
            return 5;
//#else
//            return 4;
//#endif
        } else if (section == 1) {
            //한글자 이상일때는 한글자에 해당되는 단어와 뜻, 발음을 보여준다.
//            NSString *strHanjaOnly = [_dicWord objectForKey:KEY_DIC_HanjaOnly];
//            if (strHanjaOnly == NULL) {
//                strHanjaOnly = @"";
//            }
            return [_arrWordsInProverb count];
        } else if (section == 2) {
            return [_arrWords count] + 1;
        }
    }else if (tableView == tblViewSampleSentence)
    {
        return [arrSampleSentences count] + 1;
    }
    return 4;
#endif

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation");
    
    [self reloadRow:[NSIndexPath indexPathForRow:0 inSection:0] ofTableView:self.tblViewDetail];
    [self reloadRow:[NSIndexPath indexPathForRow:1 inSection:0] ofTableView:self.tblViewDetail];
    [self reloadRow:[NSIndexPath indexPathForRow:2 inSection:0] ofTableView:self.tblViewDetail];
}

static NSString *CellIdentifier = @"Cell";
static NSString *CellIdentifier1 = @"Cell1";
//static NSString *CellIdentifierChinese_EachWord = @"Cell_Chinese_EachWord";
static NSString *CellIdentifierGroup = @"Cell_Group";
static NSString *CellIdentifierGroupSegControl = @"Cell_GroupSegControl";
static NSString *CellIdentifier_TextField = @"Cell_TextField";
//static NSString *CellIdentifier_SegControl = @"Cell_SegControl";
//static NSString *CellIdentifier_Proverb = @"Cell_Proverb";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BOOL is_iOS6 = ([myCommon getIOSVersion] >= IOSVersion_6_0);
    
    if (tableView == tblViewGroup) {
#ifdef ENGLISH
        //이건 HEADWORD를 바꿀때 하는거 같은데...
        //한개의 단어일때만 그룹을 보여준다.
        if ([_arrWords count] > indexPath.row) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            //DLog(@"arrWords : %@", _arrWords);
            if ( (_arrWords == NULL) || ([_arrWords count] == 0) ) {
                return cell;
            }
            NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row];
            NSString *strWord = @"";
            if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
                strWord = [dicOne objectForKey:KEY_DIC_Idiom];
            } else {
                strWord = [dicOne objectForKey:@"Word"];
            }
            NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
            NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
            NSString *strKnow = [dicOne objectForKey:@"Know"];
            NSString *strKnowChanged = [dicOne objectForKey:KEY_DIC_KnowChanged];
            DLog(@"dicOne : %@", dicOne);
            if (strMeaningChanged != NULL) {
                strMeaning = strMeaningChanged;
            }
            if (strKnowChanged != NULL) {
                strKnow = strKnowChanged;
            }
            
            NSInteger intKnow = [strKnow intValue];
            strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", strKnow, strWord];
            cell.detailTextLabel.text = strMeaning;
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
#endif
    } else if (tableView == tblViewDetail) {
       
        if (indexPath.section == 0) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
            }
            
            //현재 선택한 단어일때...
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_TextField];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier_TextField];
                }

                //선택한 단어의 스펠링
                if (intDicWordOrIdiom != DicWordOrIdiom_Proverb) {
                    //속담(한문장)이 아닌경우에만 단어를 바꿀수 있게 한다.
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                NSInteger intKnow = [[_dicWord objectForKey:KEY_DIC_KnowChanged] integerValue];
                NSString *strKnow = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", intKnow]];
                lblKnowWord.text = strKnow;
                
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    _lblWordInCell.frame = CGRectMake( 30, 6, tblViewDetail.frame.size.width - 180, 31);
                    _btnChangeKnowing.frame = CGRectMake(tblViewDetail.frame.size.width - 50 - 115, 5, 50, 30);
                } else {
                    _btnChangeKnowing.frame = CGRectMake(self.view.frame.size.width - 92, 5, 50, 30);
                    CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
                    CGSize cellStringSize = [_strWord sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                           constrainedToSize:maximumSize
                                                               lineBreakMode:UILineBreakModeWordWrap];
                    CGFloat cellHeight = cellStringSize.height;// + CELL_CONTENT_MARGIN * 2;
                    DLog(@"_strProverb : %@", _strProverb);
                    DLog(@"cellHeight : %f", cellHeight);
                    DLog(@"cellStringSize : %f", cellStringSize.height);
                    CGFloat height = MAX(cellHeight, 44.0f - CELL_CONTENT_MARGIN * 2);

                    _lblWordInCell.frame = CGRectMake(30, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH, height);
                }
                [cell.contentView addSubview:_lblWordInCell];
                
//              cell.accessoryView = _btnChangeKnowing;
                [cell.contentView addSubview:_btnChangeKnowing];
                
                if (intDicWordOrIdiom == DicWordOrIdiom_Word) {
                    _lblWordInCell.text = _strWord;
                } else {
                    _lblWordInCell.text = _strProverb;
                }
                
                CGRect lblKnowWordFrame = CGRectMake(5, 5, 15, 30);
                lblKnowWord.frame = lblKnowWordFrame;
                [cell.contentView addSubview:lblKnowWord];
            } else if (indexPath.row == 1) {
                //선택한 단어의 뜻  
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                NSString *strMeaningChanged = [_dicWord objectForKey:KEY_DIC_MeaningChanged];
                
                DLog(@"strMeaningChanged : %@", strMeaningChanged);

                if ( (strMeaningChanged == NULL) || ([strMeaningChanged isEqualToString:@""]) ) {
                    //단어의 뜻이 없으면 원형의 뜻을 가져오고... 연하게 칠해준다.
                    strMeaningChanged = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Meaning", @"")];
                    for (NSInteger i = 0; i < [_arrWords count]; ++i) {
                        NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
                        NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
                        NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
                        if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE ) {
                            //원형이면 원형을 뜻을 가져온다.
                            strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
                            if ( (strMeaningChanged == NULL) || ([strMeaningChanged isEqualToString:@""]) ) {
                                strMeaningChanged = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Meaning", @"")];
                            }
                            break;
                        }
                    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                    if (is_iOS6) {
                        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strMeaningChanged];
                        [attStrResult addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18] range:NSMakeRange(0, [strMeaningChanged length])];
                        
                        [attStrResult addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [strMeaningChanged length])];

                        _lblMeaningInCell.attributedText = attStrResult;
                    } else {
                        _lblMeaningInCell.font = [UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18];
                        _lblMeaningInCell.text = strMeaningChanged;
                    }
#endif
                    
                } else {
                    //단어의 뜻이 있으면 진하게 칠해준다.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                    if (is_iOS6) {
                        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strMeaningChanged];
                        [attStrResult addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18] range:NSMakeRange(0, [strMeaningChanged length])];

                        _lblMeaningInCell.attributedText = attStrResult;
                    } else {
                        _lblMeaningInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
                        _lblMeaningInCell.text = strMeaningChanged;
                    }
#endif
                }
                
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    _lblMeaningInCell.frame = CGRectMake( 30, 6, tblViewDetail.frame.size.width - 120, 31);
                } else {
                                        
                    CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
                    CGSize cellStringSize = [_lblMeaningInCell.text sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                           constrainedToSize:maximumSize
                                                        lineBreakMode:UILineBreakModeCharacterWrap];
                    CGFloat cellHeight = cellStringSize.height;// + CELL_CONTENT_MARGIN * 2;
                    //DLog(@"_lblMeaningInCell : %@", _lblMeaningInCell.text);
                    //DLog(@"cellHeight : %f", cellHeight);
                    //DLog(@"cellStringSize : %@", [NSValue valueWithCGSize:cellStringSize]);
                    CGFloat height = MAX(cellHeight, 44.0f - CELL_CONTENT_MARGIN * 2);

                    _lblMeaningInCell.frame = CGRectMake(30, CELL_CONTENT_MARGIN, cellStringSize.width, height);

                    //DLog(@"_lblMeaningInCell.frame : %@", [NSValue valueWithCGRect:_lblMeaningInCell.frame]);
                    //DLog(@"maximumSize : %@", [NSValue valueWithCGSize:maximumSize]);
                }
                [cell.contentView addSubview:_lblMeaningInCell];                
            } else if (indexPath.row == 2) {
                //발음을 적어준다.
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                //발음기호가 있을때만 발음을 아는정도를 표시하는 버튼을 표시하여준다.
                NSString *strPronounce = [_dicWord objectForKey:KEY_DIC_PronounceChanged];
                if ([strPronounce length] > 0) {
                    NSInteger intKnowPronounce = [[_dicWord objectForKey:KEY_DIC_KnowPronounceChanged] integerValue];
                    NSString *strKnowPronounce = [myCommon getStrKnowPronounceXFromStrKnowPronounce123:[NSString stringWithFormat:@"%d", intKnowPronounce]];
                    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                        _btnChangeKnowingPronounce.frame = CGRectMake(tblViewDetail.frame.size.width - 50 - 115, 5, 50, 30);
                    } else {
                        _btnChangeKnowingPronounce.frame = CGRectMake(self.view.frame.size.width - 92, 5, 50, 30);
                    }
                    
                    lblKnowPronounce.text = strKnowPronounce;
                    
//                    cell.accessoryView = _btnChangeKnowingPronounce;
                    [cell.contentView addSubview:_btnChangeKnowingPronounce];
  
                } else {
                    lblKnowPronounce.text = @"";
                }

//                //DLog(@"strPronounce : %@", strPronounce);
                _lblPronounceInCell.text = strPronounce;
                if ([strPronounce isEqualToString:@""]) {
                    NSString *strTemp = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Pronounce", @"")];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                    if (is_iOS6) {
                        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strTemp];
                        [attStrResult addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18] range:NSMakeRange(0, [strTemp length])];
                        [attStrResult addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [strTemp length])];

                        _lblPronounceInCell.attributedText = attStrResult;
                    } else {
                        _lblPronounceInCell.font = [UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18];
                        _lblPronounceInCell.text = strTemp;
                    }
#endif
                    
                }
                
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    _lblPronounceInCell.frame = CGRectMake( 30, 6, tblViewDetail.frame.size.width - 120, 31);
                } else {

                    CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
                    CGSize cellStringSize = [_lblPronounceInCell.text sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                                     constrainedToSize:maximumSize
                                                                         lineBreakMode:UILineBreakModeWordWrap];
                    CGFloat cellHeight = cellStringSize.height;// + CELL_CONTENT_MARGIN * 2;
//                    //DLog(@"lblMeaningInCell.text : %@", _lblPronounceInCell.text);
//                    //DLog(@"cellHeight : %f", cellHeight);
//                    //DLog(@"cellStringSize : %f", cellStringSize.height);
                    CGFloat height = MAX(cellHeight, 44.0f - CELL_CONTENT_MARGIN * 2);
                    
                    _lblPronounceInCell.frame = CGRectMake(30, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH, height);
                }
                [cell.contentView addSubview:_lblPronounceInCell];
                
                CGRect lblKnowPronounceFrame = CGRectMake(5, 5, 15, 30);
                lblKnowPronounce.frame = lblKnowPronounceFrame;
                [cell.contentView addSubview:lblKnowPronounce];
            } else if (indexPath.row == 3) {
                //단어의 상세 설명
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                NSString *strDesc = [_dicWord objectForKey:KEY_DIC_DescChanged];
//                //DLog(@"strDesc : %@", strDesc);

                if  ( (strDesc == NULL) || ([strDesc isEqualToString:@""]) ) {
                    strDesc = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Desc", @"")];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                    if (is_iOS6) {
                        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strDesc];
                        
                        [attStrResult addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18] range:NSMakeRange(0, [strDesc length])];
                        
                        [attStrResult addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [strDesc length])];

                        _lblDescInCell.attributedText = attStrResult;
                    } else {
                        _lblDescInCell.font = [UIFont italicSystemFontOfSize:LABEL_FONT_SIZE_18];
                        _lblDescInCell.text = strDesc;
                    }
#endif
                } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                    if (is_iOS6) {
                        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strDesc];
                        [attStrResult addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18] range:NSMakeRange(0, [strDesc length])];

                        _lblDescInCell.attributedText = attStrResult;
                    } else {
                        _lblDescInCell.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE_18];
                        _lblDescInCell.text = strDesc;
                    }
#endif
                }
                
                CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
                CGSize cellStringSize = [_lblDescInCell.text sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                                      constrainedToSize:maximumSize
                                                                          lineBreakMode:UILineBreakModeWordWrap];
                CGFloat cellHeight = cellStringSize.height;// + CELL_CONTENT_MARGIN * 2;
//                //DLog(@"_lblDescInCell : %@", _lblDescInCell.text);
//                //DLog(@"cellHeight : %f", cellHeight);
//                //DLog(@"cellStringSize : %f", cellStringSize.height);
                CGFloat height = MAX(cellHeight, 44.0f - CELL_CONTENT_MARGIN * 2);
                
                _lblDescInCell.frame = CGRectMake(30, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH, height);
                
                [cell.contentView addSubview:_lblDescInCell];
                
            } else if (indexPath.row == 4) {
                //선택한 단어에 대한 번체자 + 한글 발음 및 뜻
                //이건 중국어일때만 해당된다.
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                //이건 중국어일때만 한다.
                NSString *strHanjaAndHanjaKoreanMeaning = [_dicWord objectForKey:KEY_DIC_HanjaKoreanMeaning];


                if (strHanjaAndHanjaKoreanMeaning == NULL) {
                    strHanjaAndHanjaKoreanMeaning = @"";
                }
                
//                //DLog(@"_dicWord : %@", _dicWord);
//                
//                //DLog(@"strHanjaAndHanjaKoreanMeaning : %@", strHanjaAndHanjaKoreanMeaning);
                _lblTraditionalChineseInCell.text = [NSString stringWithString:strHanjaAndHanjaKoreanMeaning];
                CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
                
                
                CGSize cellStringSize = [_lblTraditionalChineseInCell.text sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                                      constrainedToSize:maximumSize
                                                                          lineBreakMode:UILineBreakModeWordWrap];
                CGFloat cellHeight = cellStringSize.height;// + CELL_CONTENT_MARGIN * 2;
                
                CGFloat height = MAX(cellHeight, 44.0f - CELL_CONTENT_MARGIN * 2);
                
                _lblTraditionalChineseInCell.frame = CGRectMake(30, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH, height);
                
                [cell.contentView addSubview:_lblTraditionalChineseInCell];
                
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        } else if (indexPath.section == 1) {
#ifdef CHINESE

            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierChinese_EachWord];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierChinese_EachWord];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;

            if (indexPath.row < [_arrWordsInProverb count]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSDictionary *dicOne = [_arrWordsInProverb objectAtIndex:indexPath.row];
                NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];

                //DLog(@"dicOne : %@", dicOne);
                
                NSString *strMeanging = [dicOne objectForKey:KEY_DIC_MEANING];
                NSString *strPronounce = [dicOne objectForKey:KEY_DIC_Pronounce];
                NSString *strKnowPronounce = [dicOne objectForKey:KEY_DIC_KnowPronounce];
                
                if ([strPronounce isEqualToString:@""]) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [myCommon getStrKnowPronounceXFromStrKnowPronounce123:strKnowPronounce], strWord];                    
                } else {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@[%@]", [myCommon getStrKnowPronounceXFromStrKnowPronounce123:strKnowPronounce], strWord, strPronounce];
                }
                cell.detailTextLabel.text = strMeanging;
                
            }
#else
            if ([_arrWordsInProverb count] > 0) {
                //두단어 이상으로 이루어 져 있으면.... 한글자씩 따로 뿌려주는것
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSDictionary *dicOne = [_arrWordsInProverb objectAtIndex:indexPath.row];
                //DLog(@"dicOne : %@", dicOne);
                NSString *strOne = [dicOne objectForKey:KEY_DIC_WORD];
                NSString *strMeanging = [dicOne objectForKey:KEY_DIC_MEANING];
                NSString *strPronounce = [dicOne objectForKey:KEY_DIC_Pronounce];
                NSString *strKnow = [dicOne objectForKey:KEY_DIC_KNOW];
                if ( (strPronounce == NULL) || ([strPronounce isEqualToString:@""] == TRUE) ) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [myCommon getStrKnowPronounceXFromStrKnowPronounce123:strKnow], strOne];                    
                } else {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@[%@]", [myCommon getStrKnowPronounceXFromStrKnowPronounce123:strKnow], strOne, strPronounce];
                }
                cell.detailTextLabel.text = strMeanging;
                
            } else {
                //한글자 일때...
                //단어Group일때...
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierGroup];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (indexPath.row == 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroupSegControl];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierGroupSegControl];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIButton *btnChangeKnowing  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    
                    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                        btnChangeKnowing.frame = CGRectMake(tblViewDetail.frame.size.width - 50 - 100, 5, 60, 31);
                    } else {
                        btnChangeKnowing.frame = CGRectMake(self.view.frame.size.width - 92, 5, 50, 30);
                    }
                    
                    [btnChangeKnowing setTitle:@"X?!" forState:UIControlStateNormal];
                    [btnChangeKnowing addTarget:self action:@selector(changeKnowing) forControlEvents:UIControlEventTouchUpInside];
                    cell.accessoryView = btnChangeKnowing;
//                    [btnChangeKnowing setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
//                    [cell.contentView addSubview:btnChangeKnowing];
                    cell.textLabel.text = NSLocalizedString(@"Known or Unknown?", @"");
                    
                } else {
                    
                    cell.backgroundColor = [UIColor whiteColor];
//                    //DLog(@"indexPath.row : %d", indexPath.row);
//                    //DLog(@"arrWords count : %d", [_arrWords count]);
                    NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row-1];
                    NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
                    NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
                    NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
                    NSInteger intKnowChanged = [[dicOne objectForKey:KEY_DIC_KnowChanged] integerValue];
//                    //DLog(@"dicOne : %@", dicOne);
                    
                    NSString *strKnowChanged =[myCommon getStrKnowFromIntKnow:intKnowChanged];
                    if ([strWord isEqualToString:[_strWord lowercaseString]] == TRUE) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    } else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", strKnowChanged, strWord];
                    cell.detailTextLabel.text = strMeaningChanged;
                    
                    if ( [[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE ) {

                    }
                }
            }
#endif
        } else if (indexPath.section == 2) {
            //단어Group일때...
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierGroup];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroupSegControl];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierGroupSegControl];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *btnChangeKnowing  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    btnChangeKnowing.frame = CGRectMake(tblViewDetail.frame.size.width - 50 - 92, 5, 50, 30);
                } else {
                    btnChangeKnowing.frame = CGRectMake(self.view.frame.size.width - 92, 5, 50, 30);
                }
                
                [btnChangeKnowing setTitle:@"X?!" forState:UIControlStateNormal];
                [btnChangeKnowing addTarget:self action:@selector(changeKnowing) forControlEvents:UIControlEventTouchUpInside];
//                cell.accessoryView = btnChangeKnowing;
                [btnChangeKnowing setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
                [cell.contentView addSubview:btnChangeKnowing];
                cell.textLabel.text = NSLocalizedString(@"Known or Unknown?", @"");
                
            } else {
                //DLog(@"indexPath.row : %d", indexPath.row);
                //DLog(@"arrWords count : %d", [_arrWords count]);
                NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row-1];
                NSString *strWord = [dicOne objectForKey:@"Word"];
                NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
                NSString *strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
                NSString *strKnow = [dicOne objectForKey:@"Know"];
                NSString *strKnowChanged = [dicOne objectForKey:KEY_DIC_KnowChanged];
                //DLog(@"dicOne : %@", dicOne);
                if (strMeaningChanged != NULL){
                    strMeaning = strMeaningChanged;
                }
                if (strKnowChanged != NULL) {
                    strKnow = strKnowChanged;
                }
                
                NSInteger intKnow = [strKnow intValue];
                strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
                if ([strWord isEqualToString:[_strWord lowercaseString]] == TRUE) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", strKnow, strWord];
                cell.detailTextLabel.text = strMeaning;
            }
        }
    } else if (tableView == tblViewSampleSentence) {
        if (indexPath.row == [arrSampleSentences count]) {
            cell.textLabel.text = @"New Sentence";
        }
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblViewDetail) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                self.navigationItem.rightBarButtonItem = nil;
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(callSaveChangeKnowing)];
                self.navigationItem.rightBarButtonItem = rightButton;
                
                self.navigationItem.leftBarButtonItem = nil;
                UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangeSampleSentence)];
                self.navigationItem.leftBarButtonItem = leftButton;
                
                [self.tblViewSampleSentence reloadData];

                [self.view bringSubviewToFront:viewSampleSentenceMain];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.8f];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//                [tblViewDetail removeFromSuperview];
                tblViewDetail.hidden = YES;
                [self.view addSubview:tblViewSampleSentence];
                [UIView commitAnimations];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == tblViewGroup) {
        
        if (blnChangeHeadword == TRUE) {
                for (int i = 0; i < [self._arrWords count]; i++) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                cell1.accessoryType = UITableViewCellAccessoryCheckmark;
                
    //            UITableViewCell *cellHeadword = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row];
                NSString *strWord = [dicOne objectForKey:@"Word"];
            txtNewHeadword.text = strWord;

        } else {
            //단어Group일때...
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            
            NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row];
            NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
        
            NSInteger intKnow = (segConSampleSentence.selectedSegmentIndex + 1);
            NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", strKnow, strWord];
            
            [dicOne setValue:[NSString stringWithFormat:@"%d", intKnow] forKey:@"KnowChanged"];
            
            [_arrWords replaceObjectAtIndex:indexPath.row withObject:dicOne];

        }
    } else if (tableView == tblViewDetail) {
        
        indexPathTblViewDetailsNeedReload = indexPath;
        if (indexPath.section == 0) {
            //4번째 이하만 수행하게 한다.
            if (indexPath.row < 4) {
                if (indexPath.row == 0) {
                    if (intDicWordOrIdiom != DicWordOrIdiom_Proverb) {
                        //속담(한문장)이 아닌경우에만 단어를 바꿀수 있게 한다.
                        //단어를 선택하면 단어를 다른단어로 바꿀수 있게 텍스트박스를 띄워준다.
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Change Word", @"")
                                                                        message:@"\n\n" // 중요!! 칸을 내려주는 역할을 합니다.
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
                        
                        alert.tag = 2;
                        _txtFldWord.text = _strWord;                
                        [alert addSubview:_txtFldWord];
                        [alert show];
                        [_txtFldWord becomeFirstResponder];
                        return;
                    }
                }
                //두번째 줄부터는 WordDetailEditViewController에서 뜻, 발음등을 수정할수 있게 해준다.
                WordDetailEditViewController *wordDetailEdit = [[WordDetailEditViewController alloc] initWithNibName:@"WordDetailEditViewController" bundle:nil];
                wordDetailEdit._strWord = _strWord;
                wordDetailEdit._arrWords = _arrWords;

                if (indexPath.row == 1) {
                    wordDetailEdit._strNameToEdit = KEY_DIC_MEANING;
                    wordDetailEdit._strToEdit = [_dicWord objectForKey:KEY_DIC_MeaningChanged];
                } else if (indexPath.row == 2) {
                    wordDetailEdit._strNameToEdit = KEY_DIC_Pronounce;
                    wordDetailEdit._strToEdit = [_dicWord objectForKey:KEY_DIC_PronounceChanged];
                } else if (indexPath.row == 3) {
                    wordDetailEdit._strNameToEdit = KEY_DIC_Desc;
                    wordDetailEdit._strToEdit = [_dicWord objectForKey:KEY_DIC_DescChanged];//
                }

                [self.navigationController pushViewController:wordDetailEdit animated:YES];
            }
        }

        if (indexPath.section == 1) {
            if ([_arrWordsInProverb count] > 1) {
                //개벌 단어를 선택하면 다시 WordDetail을 열어준다.
                NSDictionary *dicOne = [_arrWordsInProverb objectAtIndex:indexPath.row];
                NSString *strOne = [dicOne objectForKey:KEY_DIC_WORD];

                WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
                wordDetail._strWord = strOne;
                wordDetail._strWordFirst = strOne;
                wordDetail.intBookTblNo = intBookTblNo;
                [self.navigationController pushViewController:wordDetail animated:YES];
            } else {
                if (indexPath.row == 0) {
                    return;
                }
                
                //단어Group일때...
                //일단 선택된것 마크를 없애주고...
                for (int i = 1; i < [self._arrWords count] + 1; i++) {
                    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    cell1.accessoryType = UITableViewCellAccessoryNone;
                }
                
                //_strWord를 바꾸어준다. 맨첫줄은 빼고 단어를 가져와야 한다.
                NSMutableDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row - 1];
                self._strWord = [dicOne objectForKey:KEY_DIC_WORD];
                //현재 쉘에만 선택 마크를 넣어준다.
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self getWordInfoFromArray];
                self.navigationItem.title = _strWord;
                
                //맨위로 스크롤한다...
                [self reloadRow:indexPath ofTableView:self.tblViewDetail];
                [self.tblViewDetail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    else if (tableView == tblViewSampleSentence)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row];
        NSString *strWord = [dicOne objectForKey:@"Word"];
        NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
        //DLog(@"strWord : %@", strWord);
        //DLog(@"strMeaning : %@", strMeaning);
        txtViewSampleSentenceEng.text = strWord;
        txtViewSampleSentenceKor.text = strMeaning;
        self.navigationItem.title = _strWord;
        
        NSInteger intKnow = (segConSampleSentence.selectedSegmentIndex + 1);
        NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", strKnow, strWord];
    }
}
//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //단어의 높이를 구한다.
            NSString *strWord = [_dicWord objectForKey:KEY_DIC_WORD];
            CGSize cellStringSize = [strWord sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                  constrainedToSize:maximumSize
                                                      lineBreakMode:UILineBreakModeWordWrap];
            CGFloat cellHeight = cellStringSize.height + CELL_CONTENT_MARGIN * 2;
            CGFloat height = MAX(cellHeight, 44.0f);
            //DLog(@"strWord : %@", strWord);
            //DLog(@"cellHeight : %f", cellHeight);
            //DLog(@"cellStringSize : %f", cellStringSize.height);
            return height;
        } else if (indexPath.row == 1) {
            //단어의 뜻을 구한다.
            NSString *strMeaningChanged = [_dicWord objectForKey:KEY_DIC_MeaningChanged];
            
            if ( (strMeaningChanged == NULL) || ([strMeaningChanged isEqualToString:@""]) ) {
                //단어의 뜻이 없으면 원형의 뜻을 가져오고... 연하게 칠해준다.
                for (NSInteger i = 0; i < [_arrWords count]; ++i) {
                    NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
                    NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
                    NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
                    if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE ) {
                        //원형이면 원형을 뜻을 가져온다.
                        strMeaningChanged = [dicOne objectForKey:KEY_DIC_MeaningChanged];
                        if ( (strMeaningChanged == NULL) || ([strMeaningChanged isEqualToString:@""]) ) {
                            strMeaningChanged = @"";
                        }
                        break;
                    }
                }
            }
            
            CGSize cellStringSize = [strMeaningChanged sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                   constrainedToSize:maximumSize
                                                       lineBreakMode:UILineBreakModeCharacterWrap];
            CGFloat cellHeight = cellStringSize.height + CELL_CONTENT_MARGIN * 2;
            CGFloat height = MAX(cellHeight, 44.0f);
            //DLog(@"strMeaningChanged : %@", strMeaningChanged);
            //DLog(@"cellHeight : %f", cellHeight);
            //DLog(@"cellStringSize : %@", [NSValue valueWithCGSize:cellStringSize]);
            //DLog(@"maximumSize : %@", [NSValue valueWithCGSize:maximumSize]);
            return height;
        } else if (indexPath.row == 2) {
            NSString *strPronounce = [_dicWord objectForKey:KEY_DIC_PronounceChanged];
            CGSize cellStringSize = [strPronounce sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                            constrainedToSize:maximumSize
                                                lineBreakMode:UILineBreakModeWordWrap];
            CGFloat cellHeight = cellStringSize.height + CELL_CONTENT_MARGIN * 2;
            CGFloat height = MAX(cellHeight, 44.0f);
            //DLog(@"strPronounce : %@", strPronounce);
            //DLog(@"cellHeight : %f", cellHeight);
            //DLog(@"cellStringSize : %f", cellStringSize.height);
            return height;
        } else if (indexPath.row == 3) {
            NSString *strDesc = [_dicWord objectForKey:KEY_DIC_DescChanged];
            CGSize cellStringSize = [strDesc sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                                       constrainedToSize:maximumSize
                                                           lineBreakMode:UILineBreakModeWordWrap];
            CGFloat cellHeight = cellStringSize.height + CELL_CONTENT_MARGIN * 2;
            CGFloat height = MAX(cellHeight, 44.0f);
            //DLog(@"strDesc : %@", strDesc);
            //DLog(@"cellHeight : %f", cellHeight);
            //DLog(@"cellStringSize : %f", cellStringSize.height);
            return height;

        } else if (indexPath.row == 4) {
            //이건 중국어일때만 한다. (번체자를 보여준다. 한글설정에서는 한자의 뜻도 보여준다.)
            NSString *strHanjaAndHanjaKoreanMeaning = [_dicWord objectForKey:KEY_DIC_HanjaKoreanMeaning];
            CGSize cellStringSize = [strHanjaAndHanjaKoreanMeaning sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE_18]
                                            constrainedToSize:maximumSize
                                                lineBreakMode:UILineBreakModeWordWrap];
            CGFloat cellHeight = cellStringSize.height + CELL_CONTENT_MARGIN * 2;
            CGFloat height = MAX(cellHeight, 44.0f);
            //DLog(@"strHanjaAndHanjaKoreanMeaning : %@", strHanjaAndHanjaKoreanMeaning);
            //DLog(@"cellHeight : %f", cellHeight);
            //DLog(@"cellStringSize : %f", cellStringSize.height);
            return height;
        }
    }

    return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //swipe했을때 에디팅 모드를 할지 안할지 결정한다.
    // Detemine if it's in editing mode
    //상세단어 테이블이고 3번째 섹션(단어 그룹)이며 첫번째셀이 아니고 단어가 2개이상일때만 스와이프할때 delete를 보여준다.
    if ((tableView == tblViewDetail) && (indexPath.section == 2) && (indexPath.row > 0)) {
        NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row-1];
		//DLog(@"dicOne didSelectRowAtIndexPath : %@", dicOne );
		NSString	*strWord = [dicOne objectForKey:KEY_DIC_WORD];
		NSString	*strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
        NSInteger installedWord = [[dicOne objectForKey:KEY_DIC_InstalledWord] integerValue];
        
        if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == true) {
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You can't remove headword in group.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert2 show];
            return UITableViewCellEditingStyleNone;
        } else if ((installedWord == 0) && ([_arrWords count] > 1 )) {
            return UITableViewCellEditingStyleDelete;                        
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSDictionary *dicOne = [_arrWords objectAtIndex:indexPath.row-1];
		//DLog(@"dicOne didSelectRowAtIndexPath : %@", dicOne );
		NSString	*strWord = [dicOne objectForKey:@"Word"];
        
        strWord = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
        
        //단어를 그룹에서 없앤다.(WordOri를 자기자신으로 한다...)
        NSString	*strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'", TBL_EngDic, FldName_WORDORI, strWord, FldName_Word, strWord];
		[myCommon changeRec:strQuery  openMyDic:TRUE];
		[myCommon changeRec:strQuery  openMyDic:FALSE];

        [_arrWords removeObjectAtIndex:indexPath.row - 1];

        [self.tblViewDetail reloadData];
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@ : \"%@\"\n", NSLocalizedString(@"Word", @""), strWord, NSLocalizedString(@"Removed from group.\n\nYou can delete the word in Dictionary's Sort Words By Alphabet.", @"")]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
	} 
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strResult = nil;
    if (tableView == tblViewDetail) {
        if (section == 0) {
            strResult = NSLocalizedString(@"Word", @"");
        } else if (section == 1) {
#ifdef CHINESE
            strResult = [NSString stringWithFormat:@"\n%@", NSLocalizedString(@"Each Word", @"")];
#else
            if ([_arrWordsInProverb count] > 1) {
                strResult = [NSString stringWithFormat:@"\n%@", NSLocalizedString(@"Each Word", @"")];
            } else {
                if ([_arrWords count] > 1 ) {
                    NSString *strWordOri = [_dicWord objectForKey:KEY_DIC_WORDORI];
                    if ( (strWordOri == NULL) || ([strWordOri isEqualToString:@""]) ) {
                        //원형이 없으면... 원형을 표시 하지 않는다.
                        strResult = [NSString stringWithFormat:@"\n%@ : %d", NSLocalizedString(@"Word Group", @""), [_arrWords count]];
                    } else {
                        //원형이 있으면 원형을 같이 표시하여 준다.                        
                        strResult = [NSString stringWithFormat:@"\n%@ : %d\n%@ : %@", NSLocalizedString(@"Word Group", @""), [_arrWords count], NSLocalizedString(@"Headword", @""), strWordOri];
                         NSString *strMeaning = [myCommon getMeaningOriFromTbl:[_dicWord objectForKey:KEY_DIC_WORDORI]];
                        //Headword단어의 뜻을 가져온다.
                        for (int i = 0; i < [_arrWords count]; i++) {
                            NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
                            NSString *strWord = [dicOne objectForKey:KEY_DIC_WORD];
                            NSString *strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
                            if ([[strWord lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE) {
                                strMeaning = [dicOne objectForKey:KEY_DIC_MeaningChanged];
                                break;
                            }
                        }
                       
                        //원형의 뜻이 있으면 뜻도 보여준다.
                        if ( (strMeaning != NULL) && ([strMeaning isEqualToString:@""] == FALSE) ) {
                            strResult = [NSString stringWithFormat:@"\n%@ : %d\n%@ : %@ [%@]", NSLocalizedString(@"Word Group", @""), [_arrWords count], NSLocalizedString(@"Headword", @""), strWordOri, strMeaning];
                            
                        }
                    }
                }
            }
#endif

        } else if (section == 2) {
            if ([_arrWords count] == 0) {
                strResult = [NSString stringWithFormat:@"\n%@", NSLocalizedString(@"Word Group", @"")];
            } else {
                strResult = [NSString stringWithFormat:@"\n%@ : %d", NSLocalizedString(@"Word Group", @""), [_arrWords count]];
            }
        }
        
    } else if (tableView == tblViewGroup) {
        if (blnChangeHeadword == TRUE) {
            strResult = NSLocalizedString(@"Write new headword in a textbox or select a word in Grouped Words", @"");
        } else {
            strResult = NSLocalizedString(@"X : Unknown\n? : Not Sure\n! : Known\n- : useless word, proper noun...", @"");
        }
    }
	return strResult;
}

- (NSString*) tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *strResult = nil;
    if (tableView == tblViewDetail) {
        if (section == 0) {

        }
    }
    if (blnChangeHeadword == true) {

    }
	return strResult;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [myCommon closeDB:true];
    [myCommon openDB:true];
#ifdef DEBUG
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Debug Info"	message:@"Memory Warning"  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert2 show];
#endif
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark ios 5 rotation code
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark ios6 rotation code

-(BOOL) shouldAutorotate
{
    return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  duration:(NSTimeInterval)duration
{

}

@end
