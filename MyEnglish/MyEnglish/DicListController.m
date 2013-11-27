
//
//  DicListController.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 6..
//  Copyright 2011 dalnim. All rights reserved.
//
#import "AppDelegate.h"
#import "DicListController.h"
#import "DicListCell.h"
#import "DicListCellMark.h"
#import "myCommon.h"
#import "WordDetail.h"
#import "BackupController.h"
#import "FlashCardController.h"
#import "WordGroup.h"
#import "IdiomAndThemeCell.h"
#import "SVProgressHUD.h"
//#define kPageDivide 50

#define levelCapacity 23

@implementation DicListController

@synthesize arrProverb, intDicWordOrIdiom;
@synthesize strAllContentsInFile, arrIndexAlphabet,arrSentence, arrAllWordsAllAttribute, arrUnknownWordsAllAttribute, arrToMemorizeWordsAllAttribute, arrToWriteMeaningAllAttribute;
@synthesize dicKnowAndUnKnown, arrFiltered, tblView, strScriptFileName,intBookTblNo;
@synthesize blnFirstOpen, blnAscendingName, blnAscendingCount, blnAscendingWordOrder, blnAscendingKnow;
@synthesize pageNumber;
@synthesize	_cntOfAllWords, _cntOfExcludeWords, _cntOfKnowWords, _cntOfNotSureWords, _cntOfUnKnownWords, _cntOfNotRatedWords, noOfUniqueWords, intBeforeSegSelectedIndex,intBeforeTabbarSelectedIndex;
@synthesize viewTable, btnBackwordInTable, btnForwordInTable, pageNumberMax, sliderWordInTable;
@synthesize blnSelRowInTbl, strSelWord, intSelWordRow, intDicListType;
@synthesize arrLevel, tblViewLevel, viewLevel, intSelLevel;
@synthesize tabBarAllDic, tabBarOneBook, strBeforeType, lblLevelHeader, viewLevelHeader;
@synthesize blnMark, blnBackup, dicMark, dicMarkOri, intMarkKnow;
@synthesize actionSheetProgress, progressViewInActionSheet, alertViewProgress, txtViewUserLevel;
@synthesize viewTblSearchWord, searchBarWord, tblSearchWord, arrSearchedWordsAllAttribute;
@synthesize btnKnowNotRated, btnKnowUnknown, btnKnowNotSure, btnKnowKnown, btnKnowExclude;
@synthesize intKnowNotRated, intKnowUnknown, intKnowNotSure, intKnowKnown, intKnowExclude, blnOpenFlashCard, blnQuickSettingInBookMode;

@synthesize blnChangedInQuickSetting;
@synthesize blnUseKnowButton, strWhereClauseFldSQL;
@synthesize tabBarItemSearch, tabBarItemSort, tabBarItemQuickSetting, tabBarItemStudyWords, tabBarItemBackup; 
@synthesize tabBarItemOneBookSearch, tabBarItemOneBookSort, tabBarItemOneBookQuickSetting, tabBarItemOneBookStudyWords, tabBarItemOneBookExportAsText; 
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [myCommon closeDB:true];
    [myCommon openDB:true];
    
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(setCallRefreshWords)];
	self.navigationItem.rightBarButtonItem = rightButton;
    
    viewTblSearchWord.hidden = true;
    blnOpenFlashCard = FALSE;
	pageNumber = 1;
	pageNumberMax = 9999;
	arrIndexAlphabet = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"L",@"M",@"N",
				 @"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", @"etc",nil];

    //intBookTblNo는 이 클래스를 호출할때 미리 설정해준다.

    DLog(@"strWhereClauseFldSQL : %@", strWhereClauseFldSQL);
    
    arrSentence = [[NSMutableArray alloc] init];
	arrAllWordsAllAttribute = [[NSMutableArray	alloc] init];
	arrUnknownWordsAllAttribute = [[NSMutableArray	alloc] init];
	arrToMemorizeWordsAllAttribute = [[NSMutableArray alloc] init];
	arrToWriteMeaningAllAttribute = [[NSMutableArray alloc] init];
    arrSearchedWordsAllAttribute = [[NSMutableArray alloc] init];
	dicKnowAndUnKnown = [[NSMutableDictionary alloc] init];
	arrFiltered = [[NSMutableArray alloc] init];
	arrProverb = [[NSMutableArray alloc] init];
    
	arrLevel = [[NSMutableArray alloc] initWithCapacity:levelCapacity];

	
	//단어를 빈도순으로 나타나는것을 먼저 보여준다.
    self.navigationItem.title = NSLocalizedString(@"By Frequency", @"");
	pageNumber = 1;
	intBeforeSegSelectedIndex =  1;
	
	
	//단어장을 맨처음 열었을때를 활용할려구...
	blnFirstOpen = TRUE;
	
    //단어 아는정도를 빨리할려고 하는...
    dicMark = [[NSMutableDictionary alloc] init];
    dicMarkOri = [[NSMutableDictionary alloc] init];
    intMarkKnow = 3; //처음에는 !를 선택한다.
    blnMark = FALSE;
    blnBackup = FALSE;
    
    //tabbar를 선택할때 애니메이션 효과를 줄때 같은 tabbar를 누르면 효과를 안주기위해
    intBeforeTabbarSelectedIndex = -1;
    
    viewKnow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appWidth, 50)];
    fakeView = [[UIView alloc] initWithFrame:viewKnow.frame];
    
    fakeView.autoresizingMask = UIViewAutoresizingNone;
    [viewKnow addSubview:fakeView];
    
    NSInteger intOneBtnLength = 60;
    NSInteger intLeftSpaceBeforeFirstButton = 0;
    intLeftSpaceBeforeFirstButton = 10;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        intLeftSpaceBeforeFirstButton = (appWidth - (intOneBtnLength * 5) - 10 ) / 2;
    }
    
    btnKnowNotRated = [[UIButton alloc] initWithFrame:CGRectMake(intLeftSpaceBeforeFirstButton, 10, intOneBtnLength, 30)];
    [btnKnowNotRated setBackgroundImage:[UIImage imageNamed:@"btnKnow_nr.png"] forState:UIControlStateNormal];
    [btnKnowNotRated addTarget:self action:@selector(selBtnKnowNotRated) forControlEvents:UIControlEventTouchUpInside];
    [fakeView addSubview:btnKnowNotRated];
    
    btnKnowUnknown = [[UIButton alloc] initWithFrame:CGRectMake(intLeftSpaceBeforeFirstButton + (1 * intOneBtnLength), 10, intOneBtnLength, 30)];
    [btnKnowUnknown setTitle:@"X" forState:UIControlStateNormal];
    [btnKnowUnknown setBackgroundImage:[UIImage imageNamed:@"btnKnow_x.png"] forState:UIControlStateNormal];
    [btnKnowUnknown addTarget:self action:@selector(selBtnKnowUnknown) forControlEvents:UIControlEventTouchUpInside];
    [fakeView addSubview:btnKnowUnknown];
    
    btnKnowNotSure = [[UIButton alloc] initWithFrame:CGRectMake(intLeftSpaceBeforeFirstButton + (2 * intOneBtnLength), 10, intOneBtnLength, 30)];
    [btnKnowNotSure setTitle:@"?" forState:UIControlStateNormal];
    [btnKnowNotSure setBackgroundImage:[UIImage imageNamed:@"btnKnow_que.png"] forState:UIControlStateNormal];
    [btnKnowNotSure addTarget:self action:@selector(selBtnKnowNotSure) forControlEvents:UIControlEventTouchUpInside];
    [fakeView addSubview:btnKnowNotSure];

    btnKnowKnown = [[UIButton alloc] initWithFrame:CGRectMake(intLeftSpaceBeforeFirstButton + (3 * intOneBtnLength), 10, intOneBtnLength, 30)];
    [btnKnowKnown setTitle:@"!" forState:UIControlStateNormal];
    [btnKnowKnown setBackgroundImage:[UIImage imageNamed:@"btnKnow_exc.png"] forState:UIControlStateNormal];
    [btnKnowKnown addTarget:self action:@selector(selBtnKnowKnown) forControlEvents:UIControlEventTouchUpInside];
    [fakeView addSubview:btnKnowKnown];

    btnKnowExclude = [[UIButton alloc] initWithFrame:CGRectMake(intLeftSpaceBeforeFirstButton + (4 * intOneBtnLength), 10, intOneBtnLength, 30)];
    [btnKnowExclude setTitle:@"-" forState:UIControlStateNormal];
    [btnKnowExclude setBackgroundImage:[UIImage imageNamed:@"btnKnow_dash.png"] forState:UIControlStateNormal];
    [btnKnowExclude addTarget:self action:@selector(selBtnKnowExclude) forControlEvents:UIControlEventTouchUpInside];
    [fakeView addSubview:btnKnowExclude];

    if (intDicListType == DicListType_TBL_EngDicUserLevel) {
        fakeView.hidden = YES;
    }
    
    [SVProgressHUD showProgress:-1 status:NSLocalizedString(@"Wait please", @"")];
    
	//단어장의 정렬순서... 옵션에 따라 다르다...
	blnAscendingName = TRUE;
	blnAscendingCount = FALSE;
	blnAscendingWordOrder = TRUE;
	blnAscendingKnow = FALSE;	
                
	blnSelRowInTbl = FALSE;
    blnQuickSettingInBookMode = FALSE;
    
    self.strSelWord = @"";
    strBeforeType = [[NSString alloc] initWithString:NSLocalizedString(@"By Frequency", @"")];
	intSelWordRow = -1;
       
    self.txtViewUserLevel.text = @"";

    searchBarWord.placeholder = NSLocalizedString(@"Type a word", @"");
    tabBarItemSearch.title = NSLocalizedString(@"Search", @"");
    tabBarItemSort.title = NSLocalizedString(@"Sort", @"");
    tabBarItemQuickSetting.title = NSLocalizedString(@"Quick Setting", @"");
    tabBarItemStudyWords.title = NSLocalizedString(@"Study Words", @"");
    tabBarItemBackup.title = NSLocalizedString(@"Backup", @"");
    tabBarItemOneBookSearch.title = NSLocalizedString(@"Search", @"");
    tabBarItemOneBookSort.title = NSLocalizedString(@"Sort", @"");
    tabBarItemOneBookQuickSetting.title = NSLocalizedString(@"Quick Setting", @"");
    tabBarItemOneBookStudyWords.title = NSLocalizedString(@"Study Words", @"");
    tabBarItemOneBookExportAsText.title = NSLocalizedString(@"Export as Text", @"");
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];    
    NSString *strTemp = [defs stringForKey:@"KnowOfButton"];
    if ( (strTemp == nil) || ([strTemp isEqualToString:@"ON"] == FALSE) ) {
        [myCommon setKnowOfButtons:intSortType_Alphabet intNotRated:1 intUnknown:1 intNotSure:0 intKnown:0 intExclude:0];
        [myCommon setKnowOfButtons:intSortType_Frequency intNotRated:1 intUnknown:1 intNotSure:0 intKnown:0 intExclude:0];
        [myCommon setKnowOfButtons:intSortType_Searched intNotRated:1 intUnknown:1 intNotSure:0 intKnown:0 intExclude:0];
        [myCommon setKnowOfButtons:intSortType_MeaningNeeded intNotRated:0 intUnknown:1 intNotSure:1 intKnown:0 intExclude:0];
        [myCommon setKnowOfButtons:intSortType_AppearanceOrder intNotRated:1 intUnknown:1 intNotSure:1 intKnown:0 intExclude:0];
        
        //맨처음에는 intSortType_Frequency를 연다.
        intKnowNotRated = 1;
        intKnowUnknown = 1;
        intKnowNotSure = 1;
        intKnowKnown = 0;
        intKnowExclude = 0;
    } else {
        NSArray *arrKnow = [myCommon getKnowOfButtons:intSortType_Frequency];
        if ([arrKnow count] == 5) {
            intKnowNotRated = [[arrKnow objectAtIndex:0] integerValue];
            intKnowUnknown = [[arrKnow objectAtIndex:1] integerValue];
            intKnowNotSure = [[arrKnow objectAtIndex:2] integerValue];
            intKnowKnown = [[arrKnow objectAtIndex:3] integerValue];
            intKnowExclude = [[arrKnow objectAtIndex:4] integerValue];
        } else {
            intKnowNotRated = 1;
            intKnowUnknown = 1;
            intKnowNotSure = 1;
            intKnowKnown = 0;
            intKnowExclude = 0;
        }              
    }
    
    [self setButtonSelected];
        
    //단어 Study모드를 초기화 한다.
    _cntOfAllWords = 0;
    _cntOfExcludeWords = 0;
	_cntOfKnowWords = 0;
	_cntOfNotSureWords = 0;
	_cntOfUnKnownWords = 0;
    _cntOfNotRatedWords = 0;
	noOfUniqueWords = 0;
    
    [self callRefreshWords];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    if (blnUseKnowButton == TRUE) {
        self.tblView.tableHeaderView = viewKnow;
    } else {
        self.tblView.tableHeaderView = nil;
    }

	if (intSelWordRow > 0) {

        NSString *strQuery = nil;
        
        NSString *strSelWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strSelWord];
        strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ where %@ = '%@'", FldName_TBL_EngDic_WORDORI, TBL_EngDic, FldName_TBL_EngDic_WORD, strSelWordForSQL];
        DLog(@"strQuery : %@", strQuery);
        
		NSString *strWordOri = [myCommon getStringFldValueFromTbl:strQuery openMyDic:TRUE];
        if ((strWordOri == NULL) || ([strWordOri isEqualToString:@""])) {
            strWordOri = strSelWord;
        }
        NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
        NSMutableArray		*arrWords = [[NSMutableArray alloc] init];
            strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriForSQL];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWords byDic:nil openMyDic:OPEN_DIC_DB];        
                
		DLog(@"intBeforeSegSelectedIndex : %d", intBeforeSegSelectedIndex);
		DLog(@"strQuery viewWillAppear DicListController : %@", strQuery);
        
        //==============================================
        //버전1.1_업데이트] 사전에서 단어의 뜻과 아는정도 변경이 반영안되는 오류 수정 [arrWords count]가 1보다 크게 되어있어서 O보다 크면으로 수정
        //==============================================
		if ([arrWords count] > 0) {			
            
			NSDictionary *dicWords0 = [arrWords objectAtIndex:0];			

            NSString    *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[dicWords0 objectForKey:@"WordOri"]];
            NSString    *strMeaningOri = [myCommon getMeaningFromTbl:strWordOriForSQL];

            
            //==============================================
            //버전1.1_업데이트] 단어상세에서 바꾼 내용이 제대로 반영이 안되어서 바꾸엇엄. 바꾼단어를 원형으로부터 다 찾아와서 테이블의 단어와 일치하는것이 있으면 바꾼다.
            
            //알파벳순이면
			if (intSelWordRow == 1) {
	//					DLog(@"before : %@", arrAllWordsAllAttribute);				
				for(int i = 0; i < [arrAllWordsAllAttribute count]; i++)
				{
					NSDictionary *dicOne = [arrAllWordsAllAttribute objectAtIndex:i];
                    NSString		*strWordOne = [dicOne objectForKey:@"Word"];
                    DLog(@"Word : %@", [dicOne objectForKey:@"Word"]);    
                    DLog(@"wordOri : %@", [dicOne objectForKey:@"WordOri"]);
                    for (int j = 0; j < [arrWords count]; ++j) {
                        NSDictionary *dicWords = [arrWords objectAtIndex:j];
                        NSString		*strWord= [dicWords objectForKey:@"Word"];
                        if ([strWord isEqualToString:strWordOne]) {
                            //단어가 같으면... dicWords의 값으로 바꾸어 보여준다. (실제로는 sqlite에 저장되어 있다.)
                            NSString		*strMeaning= [dicWords objectForKey:@"Meaning"];
                            
                            //뜻이 없으면 원형의 뜻을 보여준다.
                            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                                [dicWords setValue:strMeaningOri forKey:@"Meaning"];
                            }
                            [arrAllWordsAllAttribute replaceObjectAtIndex:i withObject:dicWords];
                            [arrWords removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
                [self.tblView reloadData];
			}
            
            //빈도순또는 출현순이면
			if ((intSelWordRow == 2) || (intSelWordRow == 5)) {
                DLog(@"arrUnknownWordsAllAttribute : %@", arrUnknownWordsAllAttribute);
                for(int i = 0; i < [arrUnknownWordsAllAttribute count]; i++)
				{
					NSDictionary *dicOne = [arrUnknownWordsAllAttribute objectAtIndex:i];                    
                    NSString		*strWordOne = [dicOne objectForKey:@"Word"];
                    DLog(@"Word : %@", [dicOne objectForKey:@"Word"]);    
                    DLog(@"wordOri : %@", [dicOne objectForKey:@"WordOri"]);
                    for (int j = 0; j < [arrWords count]; ++j) {
                        NSDictionary *dicWords = [arrWords objectAtIndex:j];
                        NSString		*strWord= [dicWords objectForKey:@"Word"];
                        if ([strWord isEqualToString:strWordOne]) {
                            //단어가 같으면... dicWords의 값으로 바꾸어 보여준다. (실제로는 sqlite에 저장되어 있다.)
                            NSString		*strMeaning= [dicWords objectForKey:@"Meaning"];
                            DLog(@"array : %@",arrUnknownWordsAllAttribute);
                            DLog(@"dicOne : %@", dicOne);
                            //뜻이 없으면 원형의 뜻을 보여준다.
                            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                                [dicWords setValue:strMeaningOri forKey:@"Meaning"];
                            }
                            [arrUnknownWordsAllAttribute replaceObjectAtIndex:i withObject:dicWords];
                            [arrWords removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
                DLog(@"arrUnknownWordsAllAttribute After : %@", arrUnknownWordsAllAttribute);
                [self.tblView reloadData];
            }
            
            //검색순이면
			if (intSelWordRow == 3) {
                
                for(int i = 0; i < [arrToMemorizeWordsAllAttribute count]; i++)
				{
					NSDictionary *dicOne = [arrToMemorizeWordsAllAttribute objectAtIndex:i];
                    NSString		*strWordOne = [dicOne objectForKey:@"Word"];
                    DLog(@"Word : %@", [dicOne objectForKey:@"Word"]);    
                    DLog(@"wordOri : %@", [dicOne objectForKey:@"WordOri"]);
                    for (int j = 0; j < [arrWords count]; ++j) {
                        NSDictionary *dicWords = [arrWords objectAtIndex:j];
                        NSString		*strWord= [dicWords objectForKey:@"Word"];
                        if ([strWord isEqualToString:strWordOne]) {
                            //단어가 같으면... dicWords의 값으로 바꾸어 보여준다. (실제로는 sqlite에 저장되어 있다.)
                            NSString		*strMeaning= [dicWords objectForKey:@"Meaning"];
                            
                            //뜻이 없으면 원형의 뜻을 보여준다.
                            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                                [dicWords setValue:strMeaningOri forKey:@"Meaning"];
                            }
                            [arrToMemorizeWordsAllAttribute replaceObjectAtIndex:i withObject:dicWords];
                            [arrWords removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
                [self.tblView reloadData];
			}
            
            //뜻필요순이면
            if (intSelWordRow == 4) {    
                DLog(@"arrToWriteMeaningAllAttribute : %@", arrToWriteMeaningAllAttribute);
                for(int i = 0; i < [arrToWriteMeaningAllAttribute count]; i++)
				{
					NSDictionary *dicOne = [arrToWriteMeaningAllAttribute objectAtIndex:i];                    
                    NSString		*strWordOne = [dicOne objectForKey:@"Word"];
                    DLog(@"Word : %@", [dicOne objectForKey:@"Word"]);    
                    DLog(@"wordOri : %@", [dicOne objectForKey:@"WordOri"]);
                    for (int j = 0; j < [arrWords count]; ++j) {
                        NSDictionary *dicWords = [arrWords objectAtIndex:j];
                        NSString		*strWord= [dicWords objectForKey:@"Word"];
                        if ([strWord isEqualToString:strWordOne]) {
                            //단어가 같으면... dicWords의 값으로 바꾸어 보여준다. (실제로는 sqlite에 저장되어 있다.)
                            NSString		*strMeaning= [dicWords objectForKey:@"Meaning"];
                            DLog(@"array : %@",arrUnknownWordsAllAttribute);
                            DLog(@"dicOne : %@", dicOne);
                            DLog(@"dicWords : %@", dicWords);
                            //뜻이 없으면 원형의 뜻을 보여준다.
                            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                                [dicWords setValue:strMeaningOri forKey:@"Meaning"];
                            }
                            [arrToWriteMeaningAllAttribute replaceObjectAtIndex:i withObject:dicWords];
                            [arrWords removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
                DLog(@"arrToWriteMeaningAllAttribute After : %@", arrToWriteMeaningAllAttribute);
                [self.tblView reloadData];
            }
            
            //Word Search순이면
            if (intSelWordRow == 6) {
                DLog(@"arrSearchedWordsAllAttribute before : %@", arrSearchedWordsAllAttribute);
                for(int i = 0; i < [arrSearchedWordsAllAttribute count]; i++)
				{
					NSDictionary *dicOne = [arrSearchedWordsAllAttribute objectAtIndex:i];                    
                    NSString		*strWordOne = [dicOne objectForKey:@"Word"];
                    
                    for (int j = 0; j < [arrWords count]; ++j) {
                        NSDictionary *dicWords = [arrWords objectAtIndex:j];
                        NSString		*strWord= [dicWords objectForKey:@"Word"];
                        if ([strWord isEqualToString:strWordOne]) {
                            //단어가 같으면... dicWords의 값으로 바꾸어 보여준다. (실제로는 sqlite에 저장되어 있다.)
                            NSString		*strMeaning= [dicWords objectForKey:@"Meaning"];
                            DLog(@"strWordOne : %@",strWordOne);
                            DLog(@"strWord : %@", strWord);
                            DLog(@"dicWords : %@",dicWords);
                            DLog(@"dicOne : %@", dicOne);
                            //뜻이 없으면 원형의 뜻을 보여준다.
                            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                                [dicWords setValue:strMeaningOri forKey:@"Meaning"];
                            }
                            [arrSearchedWordsAllAttribute replaceObjectAtIndex:i withObject:dicWords];
                            [arrWords removeObjectAtIndex:j];
                            break;
                        }
                    }
                }
                DLog(@"arrSearchedWordsAllAttribute after : %@", arrSearchedWordsAllAttribute);
                [self.tblSearchWord reloadData];
            }
		}
	} 
    
    if (blnOpenFlashCard == TRUE) {
        [self.tblView reloadData];
        blnOpenFlashCard = FALSE;
    }

    intSelWordRow = -1;

	intSelLevel = -1;

    if (intDicListType == DicListType_TBL_EngDic) {
        [self.view bringSubviewToFront:tabBarAllDic];

    } else {
        [self.view bringSubviewToFront:tabBarOneBook];
    }
    
    //백업에서 돌아오면 리스토어를 했을때를 대비하여 다시한번 읽어준다.
    if (blnBackup == TRUE) {
        [self callRefreshWords];
        blnBackup = FALSE;
    }

	[SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [SVProgressHUD dismiss];
}

- (void) getUnKnownIdioms
{
    DLog(@"arrProverb count : %d", [arrProverb count]);
    DLog(@"strWhereClauseFldSQL : %@", strWhereClauseFldSQL);

    if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
        strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ > 1) ", FldName_WordLength];
    }
    
    [arrProverb removeAllObjects];
    [arrAllWordsAllAttribute removeAllObjects];
    [arrUnknownWordsAllAttribute removeAllObjects];
    [arrToMemorizeWordsAllAttribute	removeAllObjects];
    [arrToWriteMeaningAllAttribute removeAllObjects];
    
	_cntOfAllWords = 0;
	//알파벳순이면...
	if (intBeforeSegSelectedIndex == intSortType_Alphabet) {
		if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
            _cntOfAllWords = [myCommon getAllProverbsArrayFromTable:arrProverb useKnowButton:blnUseKnowButton sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_Idiom isAsc:TRUE openMyDic:OPEN_DIC_DB];
        } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB];
        }
        
	} else if ((intBeforeSegSelectedIndex == intSortType_Frequency) || (intBeforeSegSelectedIndex == intSortType_AppearanceOrder)) {
		//빈도순(1) 또는 출현순(4)이면..
        
		if (intBeforeSegSelectedIndex == intSortType_Frequency) {
            if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
                _cntOfAllWords = [myCommon getAllProverbsArrayFromTable:arrProverb useKnowButton:blnUseKnowButton sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_Idiom isAsc:TRUE openMyDic:OPEN_DIC_DB];
            } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];	
            }
		} else {
            if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
                _cntOfAllWords = [myCommon getAllProverbsArrayFromTable:arrProverb useKnowButton:blnUseKnowButton sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_Idiom isAsc:TRUE openMyDic:OPEN_DIC_DB];
            } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB];
            }
		}
        
	} else if (intBeforeSegSelectedIndex == intSortType_Searched) {
		//검색순이면...
        if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
            _cntOfAllWords = [myCommon getAllProverbsArrayFromTable:arrProverb useKnowButton:blnUseKnowButton sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_Idiom isAsc:TRUE openMyDic:OPEN_DIC_DB];
        } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_ToMemorize isAsc:FALSE openMyDic:OPEN_DIC_DB];
        } 
	} else if (intBeforeSegSelectedIndex == intSortType_MeaningNeeded) {
		//뜻필요순이면...
        if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
            _cntOfAllWords = [myCommon getAllProverbsArrayFromTable:arrProverb useKnowButton:blnUseKnowButton sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_Idiom isAsc:TRUE openMyDic:OPEN_DIC_DB];
        } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];
        }
	}

	NSInteger namuji = _cntOfAllWords % kPageDivide;
    
	if (namuji == 0) {
		pageNumberMax = _cntOfAllWords / kPageDivide;
	} else {
		pageNumberMax = (_cntOfAllWords / kPageDivide) + 1;
	}
    sliderWordInTable.value = (float)pageNumber/pageNumberMax;
}


- (void) getUnKnownWords
{
    DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
    DLog(@"arrUnknownWordsAllAttribute count : %d", [arrUnknownWordsAllAttribute count]);
    DLog(@"arrToMemorizeWordsAllAttribute count : %d", [arrToMemorizeWordsAllAttribute count]);
    
   
    [arrAllWordsAllAttribute removeAllObjects];	
    [arrUnknownWordsAllAttribute removeAllObjects];
    [arrToMemorizeWordsAllAttribute	removeAllObjects];
    [arrToWriteMeaningAllAttribute removeAllObjects];
    
	_cntOfAllWords = 0;
//	NSString *strQuery = nil;
	//알파벳순이면...
	if (intBeforeSegSelectedIndex == intSortType_Alphabet) {
		
		//NSMutableArray *arrAlphabet = [[NSMutableArray alloc] init];
            if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB];
            
        } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
			_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB];		
        } else {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];	
            
		}
        if (blnQuickSettingInBookMode == TRUE) {				
            [self getSentence:arrAllWordsAllAttribute];
        }
        
	} else if ((intBeforeSegSelectedIndex == intSortType_Frequency) || (intBeforeSegSelectedIndex == intSortType_AppearanceOrder)) {
		//빈도순(1) 또는 출현순(4)이면..
		
		if (intBeforeSegSelectedIndex == intSortType_Frequency) {
            if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
                
            } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
				_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
            } else {
				_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];		
			}

		} else {
            if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB];
            } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
				_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB];		
            } else {
				_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];		
			}
		}
        if (blnQuickSettingInBookMode == TRUE) {
            [self getSentence:arrUnknownWordsAllAttribute];
        }

	} else if (intBeforeSegSelectedIndex == intSortType_Searched) {
		//검색순이면...
		
        if (intDicListType == DicListType_TBL_EngDic) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_ToMemorize isAsc:FALSE openMyDic:OPEN_DIC_DB];
        } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_ToMemorize isAsc:FALSE openMyDic:OPEN_DIC_DB];		
        } else {
            _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:FldName_ToMemorize isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];
        }
        
        if (blnQuickSettingInBookMode == TRUE) {
            [self getSentence:arrToMemorizeWordsAllAttribute];
        }

	} else if (intBeforeSegSelectedIndex == intSortType_MeaningNeeded) {
		//뜻필요순이면...
		
        //==============================================
        //버전1.1_업데이트] 뜻필요순일때 알파벳순에서 빈도순으로 정렬하게 수정
        //==============================================
        if (intDicListType == DicListType_TBL_EngDic) {
			_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
        } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
			_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
        } else {
			_cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];		
		}
        if (blnQuickSettingInBookMode == TRUE) {
            [self getSentence:arrToWriteMeaningAllAttribute];
        }
	}

	NSInteger namuji = _cntOfAllWords % kPageDivide;
    DLog(@"namuji : %d", namuji);
    DLog(@"_cntOfAllWords : %d", _cntOfAllWords);
    DLog(@"kPageDivide : %d", kPageDivide);
    
	if (namuji == 0) {
		pageNumberMax = _cntOfAllWords / kPageDivide;
	} else {
		pageNumberMax = (_cntOfAllWords / kPageDivide) + 1;
	}
    sliderWordInTable.value = (float)pageNumber/pageNumberMax;
}

//단어를 가져오고 나면 문장을 가져온다.
- (void) getSentence:(NSMutableArray*)arrWords
{
    [arrSentence    removeAllObjects];
    NSString *strContentForSmallPageToSearchWord = @"";
    
    if (strAllContentsInFile == nil) {
        return;
    }
    
    strContentForSmallPageToSearchWord = [NSString stringWithString:strAllContentsInFile];
                               
    NSMutableArray *arrWordWithNoSentence = [[NSMutableArray alloc] init];
    //전체사전이 아니면 퀵세팅할때 단어에 해당되는 첫번째 문장도 같이 보여준다.
    if (intDicListType != DicListType_TBL_EngDic) {
        for (NSMutableDictionary *dicWord in arrWords) {
            NSString *strWord = [dicWord objectForKey:@"Word"];
            DLog(@"strWord : %@", strWord);             
            NSMutableDictionary *dicOne = [myCommon findFirstSentenceWithWordInText:strWord Text:strContentForSmallPageToSearchWord];            
            NSString *strSentence = [dicOne objectForKey:@"Sentence"];
            if (strSentence != nil) {
                [arrSentence addObject:strSentence];
                DLog(@"strWord : %@", strWord); 
                DLog(@"dicOne : %@", dicOne);            
            } else {
                [arrWordWithNoSentence addObject:strWord];
            }
        }
        
        //첫번째 책의 일부분에서 원하는 문장을 못가져오면
        if ([arrWordWithNoSentence count] > 0) {

        }
    }
}
- (void) callRefreshWords
{
    DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
    DLog(@"arrUnknownWordsAllAttribute count : %d", [arrUnknownWordsAllAttribute count]);
    DLog(@"arrToMemorizeWordsAllAttribute count : %d", [arrToMemorizeWordsAllAttribute count]);

    //미해결질문)아래 3개의 차이점은 무엇인가? 맨위꺼 빼고는 미처 단어를 refresh하기 전에 cellfor를 타서 죽는다...(검색순으로 할때...)   
    [self refreshWords];
}

//- (void) refreshWords:(NSTimer*)sender
- (void) refreshWords
{
    DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
    DLog(@"arrUnknownWordsAllAttribute count : %d", [arrUnknownWordsAllAttribute count]);
    DLog(@"arrToMemorizeWordsAllAttribute count : %d", [arrToMemorizeWordsAllAttribute count]);
    
    
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        [self getUnKnownIdioms];
    } else if (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) {
        [self getUnKnownIdioms];
    }else {
        [self getUnKnownWords];
    }
    
    
    [self.tblView reloadData];
    
    [alertViewProgress dismissWithClickedButtonIndex:0 animated:NO];
    
    //맨위로 스크롤한다...
    //알파벳순이면...
    if (intBeforeSegSelectedIndex == 0) {
        if ([arrAllWordsAllAttribute count] > 0) {
            [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
        //빈도순(1) 또는 출현순(4)이면..
        if ([arrUnknownWordsAllAttribute count] > 0) {
            [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    } else if (intBeforeSegSelectedIndex == 2) {
        //검색순이면...
        if ([arrToMemorizeWordsAllAttribute count] > 0) {
            [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    } else if (intBeforeSegSelectedIndex == 3) {
        //뜻필요순이면...
        if ([arrToWriteMeaningAllAttribute count] > 0) {
            [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
	DLog(@"[arrUnknownWordsAllAttribute count] : %d", [arrUnknownWordsAllAttribute count]);
}
-(IBAction)back
{
    [SVProgressHUD showProgress:-1 status:@""];
	//현재 책의 단어를 알고 있는 현황을 bookSetting에 추가한다.
	[myCommon updateBookSettingEachBookKnow:intBookTblNo] ;

    [self performSelector:@selector(backAndDismissViewAiv1) withObject:nil afterDelay:0.0];
}

- (void) backAndDismissViewAiv1
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void) backAndDismissViewAiv:(NSTimer*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}
- (IBAction) onBtnBackwordInTable
{
	if (pageNumber <= 1) {
		return;
	}
	pageNumber--;
    sliderWordInTable.value = (float)pageNumber/pageNumberMax;
	
	[alertViewProgress show];
	[self performSelector:@selector(callRefreshWords) withObject:nil afterDelay:0.0];
    [self setSliderWordInTable];	

    self.navigationItem.title = self.strBeforeType;

      
}
- (IBAction) onBtnForwordInTable
{
	if (pageNumber >= pageNumberMax) {
		return;
	}
    DLog(@"pageNumber Before : %d", pageNumber);
	pageNumber++;
    DLog(@"pageNumber After : %d", pageNumber);

    DLog(@"sliderWordInTable.value Before : %f", sliderWordInTable.value);
    sliderWordInTable.value = (float)pageNumber/pageNumberMax;
    DLog(@"sliderWordInTable.value After : %f", sliderWordInTable.value);
    
	[alertViewProgress show];
	[self performSelector:@selector(callRefreshWords) withObject:nil afterDelay:0.0];
    [self setSliderWordInTable];
    self.navigationItem.title = self.strBeforeType;
    
//	[self callRefreshWords];

}

- (void) setCallRefreshWords
{
    [self callRefreshWords];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)pickDicSort:(id)sender
{
}


- (IBAction) sliderWordInTableChanged : (id) sender
{
    
	[alertViewProgress show];
    
	[self performSelector:@selector(setSliderWordInTable) withObject:nil afterDelay:0.0];
    [self.tblView reloadData];
    
    [SVProgressHUD dismiss];
    self.navigationItem.title = self.strBeforeType;
}

- (IBAction) sliderWordInTableChanging : (id) sender
{

	
	NSInteger pageNumberTemp = pageNumberMax * sliderWordInTable.value;
	
	if (pageNumberTemp <= 1) {
		pageNumberTemp = 1;
	}
	if (pageNumberTemp >= pageNumberMax) {
		pageNumberTemp = pageNumberMax;
	}
	if (_cntOfAllWords >= kPageDivide) {
//        self.navigationItem.title = [NSString stringWithFormat:@"%d %d/%d%@", _cntOfAllWords, pageNumberTemp, pageNumberMax, NSLocalizedString(@"Pages",@"")];
        self.navigationItem.title = [NSString stringWithFormat:@"%d/%d%@", pageNumberTemp, pageNumberMax, NSLocalizedString(@"Pages",@"")];

	}	
}

- (void) setSliderWordInTable
{
	DLog(@"setSliderWordInTable slidePageNo.value : %f", sliderWordInTable.value);
	DLog(@"setSliderWordInTable slidePageNo.maximumValue : %f", sliderWordInTable.maximumValue);
	
	pageNumber = sliderWordInTable.value * pageNumberMax;
	if (pageNumber <= 1) {
		pageNumber = 1;
	}
	if (pageNumber >= pageNumberMax) {
		pageNumber = pageNumberMax;
	}
	
	DLog(@"pageNumber  : %d", pageNumber);
	if (pageNumber > pageNumberMax) {
		pageNumber = pageNumberMax;
	}
    
    [self callRefreshWords];
//	[self refreshWords];
	
}

#pragma mark -
#pragma mark TableView에서 버튼을 누를때
- (void) selBtnKnowNotRated
{
    if (intKnowNotRated == 1) {
        intKnowNotRated = 0;
    } else {
        intKnowNotRated = 1;
    }
    [self setButtonSelected];
    [self saveKnowOfBtuuon];
}
- (void) selBtnKnowUnknown
{
    if (intKnowUnknown == 1) {
        intKnowUnknown = 0;
    } else {
        intKnowUnknown = 1;
    }
    [self setButtonSelected];    
    [self saveKnowOfBtuuon];
}
- (void) selBtnKnowNotSure
{
    if (intKnowNotSure == 1) {
        intKnowNotSure = 0;
    } else {
        intKnowNotSure = 1;
    }
    [self setButtonSelected];    
    [self saveKnowOfBtuuon];
}
- (void) selBtnKnowKnown
{
    if (intKnowKnown == 1) {
        intKnowKnown = 0;
    } else {
        intKnowKnown = 1;
    }
    [self setButtonSelected];    
    [self saveKnowOfBtuuon];
}
- (void) selBtnKnowExclude
{
    if (intKnowExclude == 1) {
        intKnowExclude = 0;
    } else {
        intKnowExclude = 1;
    }
    [self setButtonSelected];
    [self saveKnowOfBtuuon];
}

- (void) saveKnowOfBtuuon
{

    [myCommon setKnowOfButtons:intBeforeSegSelectedIndex intNotRated:intKnowNotRated intUnknown:intKnowUnknown intNotSure:intKnowNotSure intKnown:intKnowKnown intExclude:intKnowExclude];
}

#pragma mark -
#pragma mark UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(callRefreshWords)];
	self.navigationItem.rightBarButtonItem = rightButton;
    
    viewTblSearchWord.hidden = true;
    
    if ([item.title isEqualToString:NSLocalizedString(@"Study Words", @"")]) {
        intSelWordRow = -1;
        blnOpenFlashCard = TRUE;
        
        FlashCardController *flashCardController = [[FlashCardController alloc] initWithNibName:@"FlashCardController" bundle:nil];
        
//        if ( (intDicWordOrIdiom == DicWordOrIdiom_Proverb) || (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) ) {
        if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
            if ([arrProverb count] == 0) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No words to study word.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
                return;
            }
            flashCardController.arrWordsList = arrProverb;
        } else {
            //알파벳순이면...
            if (intBeforeSegSelectedIndex == 0) {
                if ([arrAllWordsAllAttribute count] == 0) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No words to study word.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                    return;
                }
                flashCardController.arrWordsList = arrAllWordsAllAttribute;
            } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
                //빈도순(1) 또는 출현순(4)이면..
                if ([arrUnknownWordsAllAttribute count] == 0) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No words to study word.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                    return;
                }
                flashCardController.arrWordsList = arrUnknownWordsAllAttribute;
                
            } else if (intBeforeSegSelectedIndex == 2) {
                //검색순이면...
                if ([arrToMemorizeWordsAllAttribute count] == 0) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No words to study word.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                    return;
                }
                flashCardController.arrWordsList = arrToMemorizeWordsAllAttribute;
                
            } else if (intBeforeSegSelectedIndex == 3) {
                //뜻필요순이면...
                if ([arrToWriteMeaningAllAttribute count] == 0) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No words to study word.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                    return;
                }
                flashCardController.arrWordsList = arrToWriteMeaningAllAttribute;
            }
        }
        flashCardController.intBookTblNo = intBookTblNo;
        flashCardController.intDicListType = intDicListType;
        flashCardController.intDicWordOrIdiom = intDicWordOrIdiom;
        flashCardController.intFlashCardType = intFlashCardType_FlashCard;
//        flashCardController.dicWordsForQuiz  = self.dicWordsForQuiz;
        [self.navigationController pushViewController:flashCardController animated:YES];
    }
    
    if ((item.tag == 10) || (item.tag == 20)){
        //Search를 선택했을경우
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = NSLocalizedString(@"Search Word", @"");
        viewTblSearchWord.hidden = false;
        searchBarWord.text = @"";
        [arrSearchedWordsAllAttribute removeAllObjects];
        [self.tblSearchWord reloadData];
    }
    
    if (tabBar == tabBarAllDic) {
        //전체사전일경우

        if ([item.title isEqualToString:NSLocalizedString(@"Sort", @"")]) {
            //Type을 선택했을경우
            UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Sort By", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Alphabet", @""),NSLocalizedString(@"Frequency", @""),NSLocalizedString(@"Searched", @""), NSLocalizedString(@"Meaning Needed", @""),nil];
            
            actionSheet.tag = 2;
            [actionSheet showInView:self.view];
        } else if ([item.title isEqualToString:NSLocalizedString(@"Backup", @"")]) {
            
            [SVProgressHUD showProgress:-1 status:@""];
            [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                             target:self
                                           selector:@selector(openBackup:)
                                           userInfo:nil
                                            repeats:NO];

            
        } else if ([item.title isEqualToString:NSLocalizedString(@"Quick Setting", @"")]) {
            if (intBeforeTabbarSelectedIndex != item.tag) {
                //같은 탭바가 아니고 다른 탭바를 눌렀다가 이걸누를때 효과가 있게 한다.   
                blnChangedInQuickSetting = FALSE;
                [alertViewProgress show];
                [self performSelector:@selector(callQuickSetting) withObject:nil afterDelay:0.0];

                self.navigationItem.title = self.strBeforeType;
                
                
            }
        }
    } else if (tabBar == tabBarOneBook) {
        //부분 사전(책, 웹등)을 선택했을경우
        if ([item.title isEqualToString:NSLocalizedString(@"Sort", @"")]) {	
            UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Sort By", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Alphabet", @""),NSLocalizedString(@"Frequency", @""),NSLocalizedString(@"Searched", @""), NSLocalizedString(@"Meaning Needed", @""),NSLocalizedString(@"Appearance Order", @""), NSLocalizedString(@"Word Group", @""),nil];
           
            if ( (intDicListType == DicListType_TBL_EngDicUserDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup  ) ) {
                actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Sort By", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Alphabet", @""),NSLocalizedString(@"Frequency", @""),NSLocalizedString(@"Searched", @""), NSLocalizedString(@"Meaning Needed", @""),nil];
            }
            
            actionSheet.tag = 2;
            [actionSheet showInView:self.view];
        } else if ([item.title isEqualToString:NSLocalizedString(@"Export as Text", @"")]) {
            
#ifdef ENGLISH
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Which style do you want?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Word Meaning",@""), NSLocalizedString(@"Word Know Meaning",@""), NSLocalizedString(@"Word Count Meaning",@""), NSLocalizedString(@"Word Know Count Meaning",@""), nil];
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
#elif CHINESE
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Which style do you want?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Word Pronounce Meaning",@""), NSLocalizedString(@"Word Pronounce Know Meaning",@""), NSLocalizedString(@"Word Pronounce Count Meaning",@""), NSLocalizedString(@"Word Pronounce Know Count Meaning",@""), nil];
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];            
#endif
 
        } else if ([item.title isEqualToString:NSLocalizedString(@"Quick Setting", @"")]) {
            if (intBeforeTabbarSelectedIndex != item.tag) {
                //같은 탭바가 아니고 다른 탭바를 눌렀다가 이걸누를때 효과가 있게 한다.
//                [aiv startAnimating];
                blnChangedInQuickSetting = FALSE;
                if (intDicListType == DicListType_TBL_EngDicEachBook) {
                    blnQuickSettingInBookMode = TRUE;
                }
               
                [alertViewProgress show];
                [self performSelector:@selector(callQuickSetting) withObject:nil afterDelay:0.0];

                self.navigationItem.title = self.strBeforeType;
                

            }
        }
    }
    
    intBeforeTabbarSelectedIndex = item.tag;
}

- (void) openBackup:(NSTimer*)sender
{
    blnBackup = TRUE;
    BackupController *backupController = [[BackupController alloc] initWithNibName:@"BackupController" bundle:nil];
    [self.navigationController pushViewController:backupController animated:YES];
    [SVProgressHUD dismiss];
}

//지우지말것 단어를 레벨별로 보여줄때 사용한다.
- (void) openLevelView {

}

- (void) closeLevelView
{
    CGRect viewLevelFrame = CGRectMake(0.0, appHeight, appWidth, viewLevel.frame.size.height);
    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.4f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromBottom];
    self.viewLevel.frame = viewLevelFrame;   
    [[viewLevel layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    
    [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                     target:self
                                   selector:@selector(callCloseLevelView:)
                                   userInfo:nil
                                    repeats:NO];

    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(callRefreshWords)];
	self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = strBeforeType;
}

- (void) callCloseLevelView:(NSTimer*)sender
{
        [self.viewLevel removeFromSuperview];
}

- (void) saveMark
{
    intMarkKnow = KnowWord_Known; //다시 시작할때 !부터 시작하는데, 그때 3이 !이다...
//    [self restoreStatusBeforeMark];
    DLog(@"dicMark : %@", dicMark);
    DLog(@"dicMarkOri : %@", dicMarkOri);
    
    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n\n", NSLocalizedString(@"Preparing to update dictionary", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
	
    [actionSheetProgress showInView:self.view];
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];

	[actionSheetProgress addSubview:progressViewInActionSheet];
    UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 40.0f);
	[aiv1 startAnimating];
	[actionSheetProgress addSubview:aiv1];
    
    [NSThread detachNewThreadSelector:@selector(saveMarkOri:) toTarget:self withObject:nil];
	
}

- (void) saveMarkOri:(NSObject*)obj
{
    @autoreleasepool {
    
    NSInteger wordCnt = 0;
    [myCommon transactionBegin:TRUE];
    [myCommon transactionBegin:FALSE];
    for(NSString *strWord in dicMark) {
         DLog(@"strWord : %@", strWord);
		float	fVal = wordCnt++ / ((float)[dicMark count]);
        NSString *strMsg = [NSString stringWithFormat:@"%@... %@", NSLocalizedString(@"Unknown Words", @""), [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];

        NSInteger intKnowChanged = [[dicMark objectForKey:strWord] integerValue];
        
        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
        
        NSString *strWordOriForSQL = @"";
        
        NSMutableArray *arrWords = [[NSMutableArray alloc] init];
        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWordForSQL];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWords byDic:nil openMyDic:OPEN_DIC_DB];
                
		if ([arrWords count] > 0) {			
            //단어의 원형이 있으면 원형을 가져온다.
			NSDictionary *dicOneTBL_EngDic = [arrWords objectAtIndex:0];			
			strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[dicOneTBL_EngDic objectForKey:@"WordOri"]];
        } 
    
        if (intKnowChanged < KnowWord_Exclude) {
            //KnowWord_Exclude가 아닐때는 발음도 같이 업데이트 한다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORD, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        } else {
            //KnowWord_Exclude일때는 발음은 아는것으로 업데이트 한다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, KnowWord_Exclude, FldName_TBL_EngDic_WORD, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
        
        if (intDicListType >= DicListType_TBL_EngDicEachBook) {
            //책일때는 책의 테이블에도 업데이트 해준다.
            //해당 단어와 단어의 발음의 아는정도를 업데이트 한다.
            if (intKnowChanged < KnowWord_Exclude) {
                //KnowWord_Exclude가 아닐때는 발음도 같이 업데이트 한다.
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORD, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            } else {
                //KnowWord_Exclude일때는 발음은 아는것으로 업데이트 한다.
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, KnowWord_Exclude, FldName_TBL_EngDic_WORD, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }                
        }
        if (intDicListType >= DicListType_TBL_EngDicBookTemp) {
            //책일때는 책의 테이블에도 업데이트 해준다.
            //해당 단어와 단어의 발음의 아는정도를 업데이트 한다.
            if (intKnowChanged < KnowWord_Exclude) {
                //KnowWord_Exclude가 아닐때는 발음도 같이 업데이트 한다.
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORD, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            } else {
                //KnowWord_Exclude일때는 발음은 아는것으로 업데이트 한다.
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_KnowPronounce, KnowWord_Exclude, FldName_TBL_EngDic_WORD, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        }
        
#ifdef ENGLISH
        if ([strWordOriForSQL isEqualToString:@""] == false ) {
            //원형이 있으면 원형을 가지고 업데이트한다. (이미 한것은 안한다. Know가 1보다 작은것을 한다.)
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = %d)", TBL_EngDic, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know, KnowWord_NotRated];
            [myCommon changeRec:strQuery openMyDic:TRUE];

            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0)", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            if (intDicListType >= DicListType_TBL_EngDicEachBook) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = %d )", TBL_EngDic, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know, KnowWord_NotRated];
                [myCommon changeRec:strQuery openMyDic:FALSE];
                
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0 )", TBL_EngDic, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (intDicListType >= DicListType_TBL_EngDicBookTemp) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = %d)", TBL_EngDic_BookTemp, FldName_KnowPronounce, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know, KnowWord_NotRated];
                [myCommon changeRec:strQuery openMyDic:TRUE];
                
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0)", TBL_EngDic_BookTemp, FldName_TBL_EngDic_KNOW, intKnowChanged, FldName_TBL_EngDic_WORDORI, strWordOriForSQL, FldName_Know];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        }
#endif
        
    }
    [myCommon transactionCommit:TRUE];
    [myCommon transactionCommit:FALSE];
    
    [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
    actionSheetProgress = nil;
	progressViewInActionSheet = nil;
    //미해결질문) nil을하면 괜찮고 release를 하면 죽는다.
//	[progressViewInActionSheet release];
//	[actionSheetProgress release];    
    blnChangedInQuickSetting = FALSE;   //저장을 하고 나면 FALSE로 해야한다.
    [self performSelectorOnMainThread:@selector(callRestoreStatusBeforeMark:) withObject:nil waitUntilDone:YES];
    }
}

- (void) updateProgress:(NSNumber*) param  {
    progressViewInActionSheet.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	actionSheetProgress.title = [NSString stringWithFormat:@"%@\n\n",  param];
}

- (void) callQuickSetting
{
    blnMark = TRUE;
    
    self.tblView.tableHeaderView = nil;
    CGRect myRect = self.tblView.frame;
    myRect.size.height = myRect.size.height + 60;
    self.tblView.frame = myRect;

    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(callRestoreStatusBeforeMark:)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveMark)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
//    if (blnQuickSettingInBookMode == TRUE) {
        //알파벳순이면...
        if (intBeforeSegSelectedIndex == 0) {
            [self getSentence:arrAllWordsAllAttribute];               			
        } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
            //빈도순(1) 또는 출현순(4)이면..
            [self getSentence:arrUnknownWordsAllAttribute];
        } else if (intBeforeSegSelectedIndex == 2) {
            //검색순이면...
            [self getSentence:arrToMemorizeWordsAllAttribute];
        } else if (intBeforeSegSelectedIndex == 3) {
            //뜻필요순이면...
            [self getSentence:arrToWriteMeaningAllAttribute];	
        }
//    }
    
    [SVProgressHUD dismiss];

    CGRect btnBackwordInTableFrame = CGRectMake(btnBackwordInTable.frame.origin.x, btnBackwordInTable.frame.origin.y + tabBarAllDic.frame.size.height, btnBackwordInTable.frame.size.width, btnBackwordInTable.frame.size.height);
    self.btnBackwordInTable.frame = btnBackwordInTableFrame;
    CGRect btnForwordInTableFrame = CGRectMake(btnForwordInTable.frame.origin.x, btnForwordInTable.frame.origin.y + tabBarAllDic.frame.size.height, btnForwordInTable.frame.size.width, btnForwordInTable.frame.size.height);
    self.btnForwordInTable.frame = btnForwordInTableFrame;
    CGRect sliderWordInTableFrame = CGRectMake(sliderWordInTable.frame.origin.x, sliderWordInTable.frame.origin.y + tabBarAllDic.frame.size.height, sliderWordInTable.frame.size.width, sliderWordInTable.frame.size.height);
    self.sliderWordInTable.frame = sliderWordInTableFrame;
    
    self.tabBarAllDic.hidden = true;
    self.tabBarOneBook.hidden = true;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
    self.navigationItem.title = @"";
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 200, 30)];
    [segControl insertSegmentWithTitle:@"X" atIndex:0 animated:YES];
    [segControl insertSegmentWithTitle:@"?" atIndex:1 animated:YES];
    [segControl insertSegmentWithTitle:@"!" atIndex:2 animated:YES];
    [segControl insertSegmentWithTitle:@"-" atIndex:3 animated:YES];
    segControl.selectedSegmentIndex = 2;
    segControl.momentary = FALSE;
    [segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.navigationItem.titleView = segControl;	
    [self.tblView reloadData];
    [[self tblView] setContentOffset:CGPointMake(0,0)];
}

- (void) callRestoreStatusBeforeMark:(NSNumber*) param
{
    if (blnChangedInQuickSetting == TRUE) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Something's changed.\nStill want close?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];
        [alert setTag:3];
		[alert show];
    } else {
        [self restoreStatusBeforeMark];
    }
}

- (void) restoreStatusBeforeMark
{
    blnMark = false;
    blnQuickSettingInBookMode = FALSE;
    if (blnUseKnowButton == TRUE) {
        self.tblView.tableHeaderView = viewKnow;
    } else {
        self.tblView.tableHeaderView = nil;
    }

    CGRect myRect = self.tblView.frame;
    myRect.size.height = myRect.size.height - 60;
    self.tblView.frame = myRect;
    
    [dicMark removeAllObjects];
    [dicMarkOri removeAllObjects];
    
    pageNumber = 1;
    [self callRefreshWords];

    intBeforeTabbarSelectedIndex = -1;
    
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(callRefreshWords)];
    self.navigationItem.rightBarButtonItem = rightButton;    
    
    CGRect btnBackwordInTableFrame = CGRectMake(btnBackwordInTable.frame.origin.x, btnBackwordInTable.frame.origin.y - tabBarAllDic.frame.size.height, btnBackwordInTable.frame.size.width, btnBackwordInTable.frame.size.height);
    self.btnBackwordInTable.frame = btnBackwordInTableFrame;
    CGRect btnForwordInTableFrame = CGRectMake(btnForwordInTable.frame.origin.x, btnForwordInTable.frame.origin.y - tabBarAllDic.frame.size.height, btnForwordInTable.frame.size.width, btnForwordInTable.frame.size.height);
    self.btnForwordInTable.frame = btnForwordInTableFrame;
    CGRect sliderWordInTableFrame = CGRectMake(sliderWordInTable.frame.origin.x, sliderWordInTable.frame.origin.y - tabBarAllDic.frame.size.height, sliderWordInTable.frame.size.width, sliderWordInTable.frame.size.height);
    self.sliderWordInTable.frame = sliderWordInTableFrame;
    if(intDicListType == DicListType_TBL_EngDic) {
        self.tabBarAllDic.hidden = false;
    } else {
        self.tabBarOneBook.hidden = false;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = self.strBeforeType;

    [[self tblView] setContentOffset:CGPointMake(0,0)];
}
- (void) selSegControl:(id)sender
{
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
        intMarkKnow = 1;
	} else 	if( [sel selectedSegmentIndex] == 1 ){
        intMarkKnow = 2;
	} else 	if( [sel selectedSegmentIndex] == 2 ){
        intMarkKnow = 3;
	} else {
        intMarkKnow = 99;
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
	
    [self dismissModalViewControllerAnimated:YES];
	//	[txtMailAddress resignFirstResponder];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    DLog(@"buttonIndex : %d", buttonIndex);
    if (actionSheet.tag == 1) {
        if (buttonIndex == 4) {
            return;
        }
        //단어장 내보내기일때 
        NSMutableArray *arrOne = [[NSMutableArray alloc] init];
        
        //알파벳순이면...
        if (intBeforeSegSelectedIndex == intSortType_Alphabet) {
            
            //NSMutableArray *arrAlphabet = [[NSMutableArray alloc] init];
            if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB];
                
            } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB];		
            } else {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrAllWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];	
                
            }
            if (blnQuickSettingInBookMode == TRUE) {				
                [self getSentence:arrAllWordsAllAttribute];
            }
            
        } else if ((intBeforeSegSelectedIndex == intSortType_Frequency) || (intBeforeSegSelectedIndex == intSortType_AppearanceOrder)) {
            //빈도순(1) 또는 출현순(4)이면..
            
            if (intBeforeSegSelectedIndex == intSortType_Frequency) {
                if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
                    
                } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
                } else {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Frequency pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];		
                }
                
            } else {
                if ( (intDicListType == DicListType_TBL_EngDic) || (intDicListType == DicListType_TBL_EngDicUserLevel) || (intDicListType == DicListType_TBL_EngDicWordGroup) || (intDicListType == DicListType_TBL_EngDicUserDic) ) {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB];
                } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB];		
                } else {
                    _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrUnknownWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_AppearanceOrder pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"WordOrder" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];		
                }
            }
            if (blnQuickSettingInBookMode == TRUE) {
                [self getSentence:arrUnknownWordsAllAttribute];
            }
            
        } else if (intBeforeSegSelectedIndex == intSortType_Searched) {
            //검색순이면...
            
            if (intDicListType == DicListType_TBL_EngDic) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Rank" isAsc:FALSE openMyDic:OPEN_DIC_DB];
            } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"ToMemorize" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
            } else {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToMemorizeWordsAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Searched pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"ToMemorize" isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];
            }
            
            if (blnQuickSettingInBookMode == TRUE) {
                [self getSentence:arrToMemorizeWordsAllAttribute];
            }
            
        } else if (intBeforeSegSelectedIndex == intSortType_MeaningNeeded) {
            //뜻필요순이면...
            
            //==============================================
            //버전1.1_업데이트] 뜻필요순일때 알파벳순에서 빈도순으로 정렬하게 수정
            //==============================================
            if (intDicListType == DicListType_TBL_EngDic) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
            } else if (intDicListType == DicListType_TBL_EngDicBookTemp) {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB];		
            } else {
                _cntOfAllWords = [myCommon getAllWordsArrayFromBookTable:[NSString stringWithFormat:@"%d", intBookTblNo] arrOne:arrToWriteMeaningAllAttribute useKnowButton:blnUseKnowButton sqlType:getAllWordsSQLTypeNormal sortType:intSortType_MeaningNeeded pageNumber:pageNumber whereClauseFld:strWhereClauseFldSQL orderByFld:@"Count" isAsc:FALSE openMyDic:OPEN_DIC_DB_BOOK];		
            }
            if (blnQuickSettingInBookMode == TRUE) {
                [self getSentence:arrToWriteMeaningAllAttribute];
            }
        }
        
        
        
        if (intBeforeSegSelectedIndex == 0) {
            arrOne = arrAllWordsAllAttribute;
        } else if ((intBeforeSegSelectedIndex == 1) ||  (intBeforeSegSelectedIndex == 4)) {
            arrOne = arrUnknownWordsAllAttribute;
        } else if (intBeforeSegSelectedIndex == 2) {
            arrOne = arrToMemorizeWordsAllAttribute;
        } else if (intBeforeSegSelectedIndex == 3) {
            arrOne = arrToWriteMeaningAllAttribute;
        } 
        
        //단어들을 한줄에 단어, 빈도수, 뜻의 형태로 바꾼다.
        NSMutableArray *arrToWrite = [[NSMutableArray alloc] init];
#ifdef ENGLISH
        if (buttonIndex == 0) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tMeaning", @"")];            
        } else if (buttonIndex == 1) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tKnow\tMeaning", @"")];            
        } else if (buttonIndex == 2) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tCount\tMeaning", @"")];            
        } else if (buttonIndex == 3) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tKnow\tCount\tMeaning", @"")];            
        }
#elif CHINESE
        //중국어에서는 발음을 추가하여 단어장을 만든다.
        if (buttonIndex == 0) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tPronounce\tMeaning", @"")];
        } else if (buttonIndex == 1) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tPronounce\tKnow\tMeaning", @"")];
        } else if (buttonIndex == 2) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tPronounce\tCount\tMeaning", @"")];
        } else if (buttonIndex == 3) {
            [arrToWrite addObject:NSLocalizedString(@"Word\tPronounce\tKnow\tCount\tMeaning", @"")];
        }
        
#endif

        for(NSDictionary *dicOne in arrOne) {
            DLog(@"dicOne : %@", dicOne);
            NSString *strLine = [NSString stringWithFormat:@"%@\t%@", [dicOne objectForKey:@"Word"], [dicOne objectForKey:@"Meaning"]];
#ifdef ENGLISH
            if (buttonIndex == 0) {
//                [arrToWrite addObject:NSLocalizedString(@"Word\tMeaning", @"")];            
            } else if (buttonIndex == 1) {
                strLine = [NSString stringWithFormat:@"%@\t%@\t%@", [dicOne objectForKey:@"Word"],[myCommon getStrKnowFromIntKnow: [[dicOne objectForKey:@"Know"] integerValue]], [dicOne objectForKey:@"Meaning"]];
            } else if (buttonIndex == 2) {
                strLine = [NSString stringWithFormat:@"%@\t%d\t%@", [dicOne objectForKey:@"Word"], [[dicOne objectForKey:@"Count"] integerValue], [dicOne objectForKey:@"Meaning"]];            
            } else if (buttonIndex == 3) {
                strLine = [NSString stringWithFormat:@"%@\t%@\t%d\t%@", [dicOne objectForKey:@"Word"], [myCommon getStrKnowFromIntKnow: [[dicOne objectForKey:@"Know"] integerValue]], [[dicOne objectForKey:@"Count"] integerValue],[dicOne objectForKey:@"Meaning"]];           
            }
#elif CHINESE
            if (buttonIndex == 0) {
                strLine = [NSString stringWithFormat:@"%@\t[%@]\t%@", [dicOne objectForKey:@"Word"], [dicOne objectForKey:KEY_DIC_Pronounce], [dicOne objectForKey:@"Meaning"]];
            } else if (buttonIndex == 1) {
                strLine = [NSString stringWithFormat:@"%@\t[%@]\t%@\t%@", [dicOne objectForKey:@"Word"], [dicOne objectForKey:KEY_DIC_Pronounce],[myCommon getStrKnowFromIntKnow: [[dicOne objectForKey:@"Know"] integerValue]], [dicOne objectForKey:@"Meaning"]];
            } else if (buttonIndex == 2) {
                strLine = [NSString stringWithFormat:@"%@\t[%@]\t%d\t%@", [dicOne objectForKey:@"Word"], [dicOne objectForKey:KEY_DIC_Pronounce], [[dicOne objectForKey:@"Count"] integerValue], [dicOne objectForKey:@"Meaning"]];
            } else if (buttonIndex == 3) {
                strLine = [NSString stringWithFormat:@"%@\[%@]\t%@\t%d\t%@", [dicOne objectForKey:@"Word"], [dicOne objectForKey:KEY_DIC_Pronounce], [myCommon getStrKnowFromIntKnow: [[dicOne objectForKey:@"Know"] integerValue]], [[dicOne objectForKey:@"Count"] integerValue],[dicOne objectForKey:@"Meaning"]];
            }
#endif
            DLog(@"strLine : %@", strLine);
            [arrToWrite addObject:strLine];
        }
        
        NSError *error;	
        NSString *strToWrite = [arrToWrite componentsJoinedByString:@"\r\n"];
        NSString *strDateAndTime = [myCommon getCurrentDatAndTimeForBackup];
        NSString *strYearMonthDay =  [strDateAndTime substringWithRange:NSMakeRange (2, 6)];
        NSString *strHourMinute =  [strDateAndTime substringWithRange:NSMakeRange (8, 4)];
        NSString *strFileNameToExport = [NSString stringWithFormat:@"%@_%@_%@.txt", @"export", strYearMonthDay, strHourMinute];
        NSString *strFullFileNameToExport = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], strFileNameToExport];
        BOOL ok=[strToWrite writeToFile:strFullFileNameToExport atomically:YES encoding:NSUTF8StringEncoding error:&error];	
        DLog(@"strToWrite : %@", strToWrite);
        if(ok) {	
            //export파일을 만들었으면... 메일로 송부한다...
            NSData *myData = [NSData dataWithContentsOfFile:strFullFileNameToExport];
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            if (controller != NULL) {
                controller.mailComposeDelegate = self;
                [controller setSubject:[NSString stringWithFormat:@"Export WordList"]];
                NSString *body = [NSString stringWithFormat:@"%@", @"Export Your WordList"];
                [controller setMessageBody:body isHTML:YES];
                
                [controller addAttachmentData:myData mimeType:@"application/text" fileName:strFileNameToExport];
                [self presentModalViewController:controller animated:YES];
            } 
            
        } else {
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:NSLocalizedString(@"Fail to export words list.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];	
        }
    } else {
        if ( (actionSheet.numberOfButtons - 1) == buttonIndex) {
            return;
        }
        
        [SVProgressHUD showProgress:-1 status:@""];
        NSArray* arrOne = [NSArray arrayWithObjects:actionSheet, [NSNumber numberWithUnsignedInt:buttonIndex], nil];
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(doActionSheet:)
                                       userInfo:arrOne
                                        repeats:NO];
    }    

}

- (void) doActionSheet:(NSTimer*)sender
{
    NSArray* arrOne = [sender userInfo];
    UIActionSheet* actionSheet = (UIActionSheet*)[arrOne objectAtIndex:0];
    NSInteger buttonIndex =  [[arrOne objectAtIndex:1] integerValue];
    
    if (actionSheet.tag == 2) {
        sliderWordInTable.value = 0.0f;
        if (blnUseKnowButton == TRUE) {
            self.tblView.tableHeaderView = viewKnow;
        } else {
            self.tblView.tableHeaderView = nil;
        }
       
        if (buttonIndex == intSortType_Alphabet) {
            self.navigationItem.title = NSLocalizedString(@"By Alphabet", @"");
            
            [self setButton:intSortType_Alphabet];
        } else if (buttonIndex == intSortType_Frequency) {
            self.navigationItem.title = NSLocalizedString(@"By Frequency", @"");
            [self setButton:intSortType_Frequency];            
        } else if (buttonIndex == intSortType_Searched) {
            self.navigationItem.title = NSLocalizedString(@"By Searched", @"");
            [self setButton:intSortType_Searched];            
        } else if (buttonIndex == intSortType_MeaningNeeded) {
            self.navigationItem.title = NSLocalizedString(@"By Meaning Needed", @"");
            [self setButton:intSortType_MeaningNeeded];            
        } else if (buttonIndex == intSortType_AppearanceOrder) {
            self.navigationItem.title = NSLocalizedString(@"By Appearance Order", @"");
            [self setButton:intSortType_AppearanceOrder];
            //        } else if (buttonIndex == 5) {
            //            self.navigationItem.title = NSLocalizedString(@"By Word Group", @"");
            //            [self setButton:intSortType_WordGroup];            
        }
        
//        DLog(@"actionSheet.numberOfButtons : %d", actionSheet.numberOfButtons);
        DLog(@"buttonIndex : %d", buttonIndex);
		self.strBeforeType = self.navigationItem.title;
        if (buttonIndex == intSortType_WordGroup) {            
            WordGroup *wordGroupController = [[WordGroup alloc] initWithNibName:@"WordGroup" bundle:nil];            
            wordGroupController.intBookTblNo = intBookTblNo;
            wordGroupController.intDicListType = intDicListType;
            wordGroupController.strAllContentsInFile = strAllContentsInFile;
            [self.navigationController pushViewController:wordGroupController animated:YES];
        } else {
            //        if ((actionSheet.numberOfButtons - 1) != buttonIndex) {
			pageNumber = 1;
			intBeforeSegSelectedIndex =  buttonIndex;
            DLog(@"intBeforeSegSelectedIndex : %d", intBeforeSegSelectedIndex);
            DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
            DLog(@"arrUnknownWordsAllAttribute count : %d", [arrUnknownWordsAllAttribute count]);
            DLog(@"arrToMemorizeWordsAllAttribute count : %d", [arrToMemorizeWordsAllAttribute count]);
            
			[self callRefreshWords];
            //		}            
        }        
	} else if (actionSheet.tag == 3) {

        [self callRefreshWords];
    }
    [SVProgressHUD dismiss];
}

- (void) setButton:(NSInteger)intSortType
{
    NSArray *arrKnow = [myCommon getKnowOfButtons:intSortType];
    if ([arrKnow count] == 5) {
        intKnowNotRated = [[arrKnow objectAtIndex:0] integerValue];
        if (intKnowNotRated == 1) {
            btnKnowNotRated.titleLabel.text = @"_";
        } else {
            btnKnowNotRated.titleLabel.text = @" ";
        }

        intKnowUnknown = [[arrKnow objectAtIndex:1] integerValue];
        if (intKnowUnknown == 1) {
            btnKnowUnknown.titleLabel.text = @"X_";
        } else {
            btnKnowUnknown.titleLabel.text = @"X";
        }

        intKnowNotSure = [[arrKnow objectAtIndex:2] integerValue];
        if (intKnowNotSure == 1) {
            btnKnowNotSure.titleLabel.text = @"?_";
        } else {
            btnKnowNotSure.titleLabel.text = @"?";
        }

        intKnowKnown = [[arrKnow objectAtIndex:3] integerValue];
        if (intKnowKnown == 1) {
            btnKnowKnown.titleLabel.text = @"!_";
        } else {
            btnKnowKnown.titleLabel.text = @"!";
        }

        intKnowExclude = [[arrKnow objectAtIndex:4] integerValue];
        if (intKnowExclude == 1) {
            btnKnowExclude.titleLabel.text = @"-_";
        } else {
            btnKnowExclude.titleLabel.text = @"-";
        }
        [self setButtonSelected];
    }
}

- (void) setButtonSelected
{
    if (intKnowNotRated == 1) {
        [btnKnowNotRated setImage:[UIImage imageNamed:@"btnKnow_nr_down.png"] forState:UIControlStateNormal];
    } else {
       [btnKnowNotRated setImage:[UIImage imageNamed:@"btnKnow_nr.png"] forState:UIControlStateNormal];
    }
    if (intKnowUnknown == 1) {
        [btnKnowUnknown setImage:[UIImage imageNamed:@"btnKnow_x_down.png"] forState:UIControlStateNormal];
    } else {
        [btnKnowUnknown setImage:[UIImage imageNamed:@"btnKnow_x.png"] forState:UIControlStateNormal];
    }
    if (intKnowNotSure == 1) {
        [btnKnowNotSure  setImage:[UIImage imageNamed:@"btnKnow_que_down.png"] forState:UIControlStateNormal];
    } else {
        [btnKnowNotSure  setImage:[UIImage imageNamed:@"btnKnow_que.png"] forState:UIControlStateNormal];
    }
    if (intKnowKnown == 1) {
        [btnKnowKnown setImage:[UIImage imageNamed:@"btnKnow_exc_down.png"] forState:UIControlStateNormal];
    } else {
        [btnKnowKnown setImage:[UIImage imageNamed:@"btnKnow_exc.png"] forState:UIControlStateNormal];
    }
    if (intKnowExclude == 1) {
        [btnKnowExclude setImage:[UIImage imageNamed:@"btnKnow_dash_down.png"] forState:UIControlStateNormal];
    } else {
        [btnKnowExclude setImage:[UIImage imageNamed:@"btnKnow_dash.png"] forState:UIControlStateNormal];
    }  
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView1 {
	// Return the number of sections.
    fakeView.center = CGPointMake(self.view.center.x, fakeView.center.y);
	if (tableView1 == self.searchDisplayController.searchResultsTableView) {			
		return 1;
	}
	return 1;		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
//    DLog(@"arrToMemorizeWordsAllAttribute count : %d", [arrToMemorizeWordsAllAttribute count]);
    
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb)  {
        return [self.arrProverb count];
    } else {
        if (tableView == tblSearchWord) {
            return [self.arrSearchedWordsAllAttribute count];
        }
        //에디팅 모드이면 1줄을 더 반환한다.
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [arrFiltered count];
        }
        
        if (tableView.tag == 1) {
            if (intBeforeSegSelectedIndex == 0) {
                DLog(@"arrAllWordsAllAttribute count : %d", [arrAllWordsAllAttribute count]);
                return [self.arrAllWordsAllAttribute count];
            }else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
                return [self.arrUnknownWordsAllAttribute count];
            }else if (intBeforeSegSelectedIndex == 2) {
                return [self.arrToMemorizeWordsAllAttribute count];
            }else if (intBeforeSegSelectedIndex == 3) {
                return [self.arrToWriteMeaningAllAttribute count];
            }
        } else if (tableView.tag == 3) {
            DLog(@"arrLevel : %@", arrLevel);
            return [self.arrLevel count];
        }
    }
    return [self.arrAllWordsAllAttribute count];
}


static NSString *CellIdentifier = @"Cell";
//static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifier3 = @"Cell3";
static NSString *CellIdentifierMark = @"CellMark";
static NSString *CellIdentifierProverb = @"CellProverb";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( intDicWordOrIdiom == DicWordOrIdiom_Proverb ) {
        IdiomAndThemeCell * cell = (IdiomAndThemeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierProverb];
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IdiomAndThemeCell" owner:nil options:nil];
            cell = [arr	objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        NSDictionary *dicOne = [arrProverb objectAtIndex:indexPath.row];;
        NSString *strProverb = [dicOne objectForKey:KEY_DIC_Idiom];
        NSString *strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
        NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
        
        if ([strMeaning isEqualToString:@""]) {
            strMeaning = [NSString stringWithString:strDesc];
        }
        
        DLog(@"cell.lblProverb.frame : %@", [NSValue valueWithCGRect:cell.lblProverb.frame]);
        DLog(@"cell.lblMeaning.frame : %@", [NSValue valueWithCGRect:cell.lblMeaning.frame]);
        
        DLog(@"cell.frame : %@", [NSValue valueWithCGRect:cell.frame]);
        
        CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
        //    NSString *dateString = @"The date today is January 1st, 1999";
        //    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
        CGSize cellProverbStringSize = [strProverb sizeWithFont:[UIFont boldSystemFontOfSize:PROVERB_FONT_SIZE]
                                              constrainedToSize:maximumSize
                                                  lineBreakMode:UILineBreakModeWordWrap];
        cell.lblProverb.frame = CGRectMake(cell.lblProverb.frame.origin.x, CELL_CONTENT_MARGIN, cell.lblProverb.frame.size.width, cellProverbStringSize.height + CELL_CONTENT_MARGIN);
        
        CGSize cellMeaningStringSize = [strMeaning sizeWithFont:[UIFont systemFontOfSize:PROVERB_MEANING_FONT_SIZE]
                                              constrainedToSize:maximumSize
                                                  lineBreakMode:UILineBreakModeWordWrap];
        
        
        cell.lblMeaning.frame = CGRectMake(cell.lblMeaning.frame.origin.x, cell.lblProverb.frame.origin.y + cell.lblProverb.frame.size.height + CELL_CONTENT_MARGIN, cell.lblMeaning.frame.size.width, cellMeaningStringSize.height + CELL_CONTENT_MARGIN);
        
        
        DLog(@"cellForRowAtIndexPath strProverb : %@", strProverb);
        DLog(@"cellProverbStringSize.height : %f", cellProverbStringSize.height);
        DLog(@"cell.lblProverb.frame : %@", [NSValue valueWithCGRect:cell.lblProverb.frame]);
        
        
        
        
        DLog(@"cellForRowAtIndexPath strMeaning : %@", strMeaning);
        DLog(@"cellMeaningStringSize.height : %f", cellMeaningStringSize.height);
        DLog(@"cell.lblMeaning.frame : %@", [NSValue valueWithCGRect:cell.lblMeaning.frame]);
        
        //    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellProverbStringSize.height + cellMeaningStringSize.height + 5 + 5 + 5 + 5 + 5);
        
        DLog(@"cell.frame : %@", [NSValue valueWithCGRect:cell.frame]);
        cell.lblKnown.text = @"";
        
        NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strProverb];
        [attStrResult addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:PROVERB_FONT_SIZE] range:NSMakeRange(0, [strProverb length])];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if ([myCommon getIOSVersion] >= IOSVersion_6_0) {
            cell.lblProverb.attributedText = attStrResult;
        } else {
            cell.lblProverb.font = [UIFont boldSystemFontOfSize:PROVERB_FONT_SIZE];
            cell.lblProverb.text = strProverb;
        }
#endif
        
        
        //        cell.lblProverb.text = strProverb;
        cell.lblMeaning.font = [UIFont systemFontOfSize:PROVERB_MEANING_FONT_SIZE];
        cell.lblMeaning.text = strMeaning;
        
        //	}
        return cell;
        
    } else {
        if (tableView == tblSearchWord) {
            DicListCell * cell = (DicListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"DicListCell" owner:nil options:nil];
                cell = [arr	objectAtIndex:0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                CGRect cellFrame = CGRectMake(0.0, cell.frame.origin.y, cell.frame.size.width, 60);
                cell.frame = cellFrame;
                
            }
            NSDictionary *sections = [arrSearchedWordsAllAttribute objectAtIndex:indexPath.row];;
            
            NSInteger intKnow = [[sections objectForKey:@"Know"] intValue];
            NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
            NSString *strMeaning = [sections objectForKey:@"Meaning"];
            cell.lblWord.text = [sections objectForKey:@"Word"];
            //	DLog(@"Word : %@", cell.lblWord.text);
            cell.lblKnow.text = strKnow;
            
            NSInteger count = [[sections objectForKey:@"Count"] integerValue];
            
            NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [currencyFormatter setLocale:locale];
            
            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", count]];
            NSString *strCount = [currencyFormatter stringFromNumber:someAmount];
            
            
            cell.lblCount.text = [NSString stringWithFormat:@"%@", strCount];
            
            
            cell.lblCount.font = [UIFont systemFontOfSize:15];
            cell.txtMeaning.text = strMeaning;
            DLog(@"Meaning : %@", NSLocalizedString(@"Meaning...", @""));
            cell.txtMeaning.placeholder = NSLocalizedString(@"Meaning...", @"");
            
#ifdef ENGLISH
            cell.lblPronounce.hidden = TRUE;
#elif CHINESE
            //단어 발음을 보여준다...
            if ( (strPronounce != NULL) && ([strPronounce isEqualToString:@""] == FALSE) ) {
                cell.lblPronounce.textColor = [UIColor blackColor];
                cell.lblPronounce.text = strPronounce;
            } else {
                cell.lblPronounce.textColor = [UIColor lightGrayColor];
                cell.lblPronounce.text = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Pronounce.", @"")];
            }
#endif
            return cell;
        } else if (tableView == tblView) {
            //tableViewDic이면...
            if (blnMark == true) {
                //Mark모드 이면...
                DicListCellMark * cell = (DicListCellMark*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierMark];
                if (cell == nil) {
                    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"DicListCellMark" owner:nil options:nil];
                    cell = [arr	objectAtIndex:0];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                
                NSDictionary *sections = nil;
                if (tableView == self.searchDisplayController.searchResultsTableView){
                    sections = [arrFiltered objectAtIndex:indexPath.row];
                } else {
                    if (intBeforeSegSelectedIndex == 0) {
                        sections = [arrAllWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
                        sections = [arrUnknownWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if (intBeforeSegSelectedIndex == 2) {
                        sections = [arrToMemorizeWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if (intBeforeSegSelectedIndex == 3) {
                        sections = [arrToWriteMeaningAllAttribute objectAtIndex:indexPath.row];
                    }
                }
                
                NSInteger intKnow = [[sections objectForKey:@"Know"] intValue];
                NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
                
                
                cell.lblWord.text = [sections objectForKey:@"Word"];
                cell.lblKnow.text = strKnow;
                cell.lblSentence.text = @"";
                //mark모드이면 이고 아는정도를 바꾸었으면... know를 바꾸어준다.
                
                //            DLog(@"word : %@", [sections objectForKey:@"Word"]);
                if ([dicMark valueForKey:cell.lblWord.text] != nil) {
                    //know을 Mark에서 선택한것으로 보여준다.(저장은 save를 할때 같이 한다.)
                    intKnow = [[dicMark valueForKey:cell.lblWord.text] integerValue];
                    cell.lblKnow.text = [myCommon getStrKnowFromIntKnow:intKnow];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                
                return cell;
            } else {
                //Mark모드가 아니면...
                DicListCell * cell = (DicListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"DicListCell" owner:nil options:nil];
                    cell = [arr	objectAtIndex:0];
                    if (blnMark == TRUE) {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        CGRect cellFrame = CGRectMake(0.0, cell.frame.origin.y, cell.frame.size.width, 30);
                        cell.frame = cellFrame;
                    } else {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        CGRect cellFrame = CGRectMake(0.0, cell.frame.origin.y, cell.frame.size.width, 60);
                        cell.frame = cellFrame;
                    }
                }
                
                NSDictionary *sections = nil;
                if (tableView == self.searchDisplayController.searchResultsTableView){
                    sections = [arrFiltered objectAtIndex:indexPath.row];
                } else {
                
                    if (intBeforeSegSelectedIndex == 0) {
                        sections = [arrAllWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {
                        sections = [arrUnknownWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if (intBeforeSegSelectedIndex == 2) {
                        sections = [arrToMemorizeWordsAllAttribute objectAtIndex:indexPath.row];
                    } else if (intBeforeSegSelectedIndex == 3) {
                        sections = [arrToWriteMeaningAllAttribute objectAtIndex:indexPath.row];
                    }
                }

                DLog(@"sections : %@", sections);
                NSInteger intKnow = [[sections objectForKey:KEY_DIC_KNOW] intValue];
                NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
                NSString *strMeaning = [sections objectForKey:KEY_DIC_MEANING];
                
                cell.lblWord.text = [sections objectForKey:KEY_DIC_WORD];
                
                
                //	DLog(@"Word : %@", cell.lblWord.text);
                cell.lblKnow.text = strKnow;
                //mark모드이면 이고 아는정도를 바꾸었으면... know를 바꾸어준다.
                if ( (blnMark == TRUE) && ([dicMark valueForKey:cell.lblWord.text] != nil) ) {
                    //                DLog(@"word : %@", [sections objectForKey:@"Word"]);
                    if ([dicMark valueForKey:cell.lblWord.text] != nil) {
                        //know을 Mark에서 선택한것으로 보여준다.(저장은 save를 할때 같이 한다.)
                        NSInteger intKnow = [[dicMark valueForKey:cell.lblWord.text] integerValue];
                        cell.lblKnow.text = [myCommon getStrKnowFromIntKnow:intKnow];
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                
                if (intBeforeSegSelectedIndex == 2) {
                    
                    DLog(@"sections : %@", sections);
                    cell.lblCount.text = [NSString stringWithFormat:@"%@", [sections objectForKey:@"ToMemorize"]];
                    if (cell.lblCount.text == nil) {
                        cell.lblCount.text = @"";
                    }
                } else {
                    NSInteger count = [[sections objectForKey:@"Count"] integerValue];
                    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
                    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
                    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    [currencyFormatter setLocale:locale];
                    
                    NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", count]];
                    NSString *strCount = [currencyFormatter stringFromNumber:someAmount];
                    cell.lblCount.text = [NSString stringWithFormat:@"%@", strCount];
                }
                cell.lblCount.font = [UIFont systemFontOfSize:15];
                cell.txtMeaning.placeholder = NSLocalizedString(@"Meaning...", @"");
                cell.txtMeaning.text = strMeaning;
                
#ifdef ENGLISH
                cell.lblPronounce.hidden = TRUE;
#elif CHINESE
                //단어 발음을 보여준다...
                if ( (strPronounce != NULL) && ([strPronounce isEqualToString:@""] == FALSE) ) {
                    cell.lblPronounce.textColor = [UIColor blackColor];
                    cell.lblPronounce.text = strPronounce;
                } else {
                    cell.lblPronounce.textColor = [UIColor lightGrayColor];
                    cell.lblPronounce.text = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Pronounce.", @"")];
                }
                
#endif
                
                return cell;
            }
            
        }else if (tableView == tblViewLevel) {
            //tableViewLevel에 해당되는 단어의 아는정도를 한번에 조정한다.
            UITableViewCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier3];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
                
            NSDictionary *dicOne = [self.arrLevel objectAtIndex:indexPath.row];
            NSInteger level = [[dicOne objectForKey:@"Level"] integerValue];
            NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"X"] integerValue];
            NSInteger cntOfHalfknownWords = [[dicOne objectForKey:@"?"] integerValue];
            NSInteger cntOfknownWords = [[dicOne objectForKey:@"!"] integerValue];
            NSInteger cntOfAllWords = cntOfknownWords + cntOfHalfknownWords + cntOfUnknownWords;
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%d (%d %@)", NSLocalizedString(@"Level", @""), level, cntOfAllWords, NSLocalizedString(@"Words", @"")];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"X:%d, ?:%d, !:%d", cntOfUnknownWords, cntOfHalfknownWords, cntOfknownWords];
            
            UISwitch *switchOne = [[UISwitch alloc] initWithFrame:CGRectMake(200, 15, 100, 60)];
            if ((cntOfAllWords == cntOfknownWords) || (cntOfAllWords > 0)) {
                //전부 아는단어면 On으로 표시한다.
                [switchOne setOn:YES animated:NO];
            } else  {
                //하나라도 모르는게 있으면 Off로 표시한다.
                [switchOne setOn:NO animated:NO];
            }
            
            [switchOne addTarget:self action:@selector(selSwitchLevel:event:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchOne];		
            
            return cell;
        }
    }
	return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblView) {
        //tableViewDic이면...
        if (blnMark == true) {
            //Quick setting모드이면...
            DicListCellMark * cellTemp = (DicListCellMark*)cell;
            
            NSDictionary *sections = nil;
            cellTemp.lblSentence.textColor = [UIColor grayColor];
            
            if (tableView == self.searchDisplayController.searchResultsTableView){
                sections = [arrFiltered objectAtIndex:indexPath.row];
            } else {
                if (intBeforeSegSelectedIndex == 0) {	
                    sections = [arrAllWordsAllAttribute objectAtIndex:indexPath.row];
                } else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {				
                    sections = [arrUnknownWordsAllAttribute objectAtIndex:indexPath.row];
                } else if (intBeforeSegSelectedIndex == 2) {
                    sections = [arrToMemorizeWordsAllAttribute objectAtIndex:indexPath.row];
                } else if (intBeforeSegSelectedIndex == 3) {
                    sections = [arrToWriteMeaningAllAttribute objectAtIndex:indexPath.row];
                }		
            }
            
            NSInteger intKnow = [[sections objectForKey:@"Know"] intValue];
            if (intKnow == 2) {
                [cellTemp setBackgroundColor:[UIColor grayColor]];  
                cellTemp.lblSentence.textColor = [UIColor whiteColor];
            }

            //전체사전이 아니면 퀵세팅할때 단어에 해당되는 첫번째 문장도 같이 보여준다.
            if (intDicListType != DicListType_TBL_EngDic) {
                if (indexPath.row < [arrSentence count]) {
                    NSString *strSentence = [arrSentence objectAtIndex:indexPath.row];
                    DLog(@"strSentence : %@", strSentence);            
                    cellTemp.lblSentence.text = strSentence;
                }
            }
            
            if ([dicMark valueForKey:cellTemp.lblWord.text] != nil) {
                //know을 Mark에서 선택한것으로 보여준다.
                NSInteger intKnow = [[dicMark valueForKey:cellTemp.lblWord.text] integerValue];
                DLog(@"intKnow : %d", intKnow);
                if (intKnow <= 1) {
                    [cellTemp setBackgroundColor:[UIColor clearColor]];
                } else if (intKnow == 2) {
                    [cellTemp setBackgroundColor:[UIColor grayColor]];
                cellTemp.lblSentence.textColor = [UIColor whiteColor];                    
                } else if (intKnow == 3) {
                    [cellTemp setBackgroundColor:[UIColor lightGrayColor]];
                    cellTemp.lblSentence.textColor = [UIColor whiteColor];                    
                } else if (intKnow > 3) {
                    [cellTemp setBackgroundColor:[UIColor grayColor]];
                    cellTemp.lblSentence.textColor = [UIColor whiteColor];
                }
            }
        }
    }
}

//Level에서 단어의 아는정도를 조정할때 사용...
- (void) selSwitchLevel:(id)sender event:(id)event
{
	UISwitch *switchOne = (UISwitch*)sender;
	//현재선택한 셀의 줄을 가져온다.
	NSIndexPath *indexPath = [tblViewLevel indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    NSDictionary *dicOne = [self.arrLevel	objectAtIndex:indexPath.row];
	intSelLevel= [[dicOne objectForKey:@"Level"] integerValue];

	DLog(@"arrLevel : %@", arrLevel);
	DLog(@"indexPath.row : %d", indexPath.row);
	DLog(@"intSelLevel : %d", intSelLevel);
	if (switchOne.on == TRUE) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"") message:[NSString stringWithFormat:@"%@ : LEVEL %d",NSLocalizedString(@"Set to all words to \"Known Word\"", @""), intSelLevel] delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];		
		alert.tag = 1;
		[alert show];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"") message:[NSString stringWithFormat:@"%@ : LEVEL %d",NSLocalizedString(@"Set to all words to \"Unknown Word\"", @""), intSelLevel] delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];		
		alert.tag = 2;
		[alert show];
	}

}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {

		if (buttonIndex == 0) {

		}else if (buttonIndex == 1){
			NSString	*strQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = 3 WHERE %@ = %d",TBL_EngDic, FldName_Know, FldName_WORDLEVEL1, intSelLevel];

            NSDictionary *dicTemp = [self.arrLevel objectAtIndex:(intSelLevel - 1)];
            NSInteger cntOfknownWords = [[dicTemp objectForKey:@"!"] integerValue];
            NSInteger cntOfHalfknownWords = [[dicTemp objectForKey:@"?"] integerValue];
            NSInteger cntOfUnknownWords = [[dicTemp objectForKey:@"X"] integerValue];
            NSInteger cntOfAllWords = cntOfknownWords + cntOfHalfknownWords + cntOfUnknownWords;
            
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:[NSNumber numberWithInteger:intSelLevel] forKey:@"Level"];
            [dicOne setValue:[NSNumber numberWithInteger:cntOfAllWords] forKey:@"!"];
            [dicOne setValue:0 forKey:@"?"];
            [dicOne setValue:0 forKey:@"X"];
            [self.arrLevel replaceObjectAtIndex:(intSelLevel - 1) withObject:dicOne];
			
			[myCommon changeRec:strQuery openMyDic:TRUE];
		}	
	} else if (alertView.tag == 2) {
		
		if (buttonIndex == 0) {
			
		}else if (buttonIndex == 1){
			NSString	*strQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = 0 WHERE %@ = %d",TBL_EngDic, FldName_Know, FldName_WORDLEVEL1, intSelLevel];
			if (intSelLevel == -1) {
				strQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = 0",TBL_EngDic, FldName_Know];
            } else {
                NSDictionary *dicTemp = [self.arrLevel objectAtIndex:(intSelLevel - 1)];
                NSInteger cntOfknownWords = [[dicTemp objectForKey:@"!"] integerValue];
                NSInteger cntOfHalfknownWords = [[dicTemp objectForKey:@"?"] integerValue];
                NSInteger cntOfUnknownWords = [[dicTemp objectForKey:@"X"] integerValue];
                NSInteger cntOfAllWords = cntOfknownWords + cntOfHalfknownWords + cntOfUnknownWords;
                
                NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
                [dicOne setValue:[NSNumber numberWithInteger:intSelLevel] forKey:@"Level"];
                [dicOne setValue:0 forKey:@"!"];
                [dicOne setValue:0 forKey:@"?"];
                [dicOne setValue:[NSNumber numberWithInteger:cntOfAllWords] forKey:@"X"];
                [self.arrLevel replaceObjectAtIndex:(intSelLevel - 1) withObject:dicOne];
			}

			[myCommon changeRec:strQuery openMyDic:TRUE];
		}	
	} else if (alertView.tag == 3) {
        //QuickSetting에서 Close를 눌렀을때
        if (buttonIndex == 1) {
            [self restoreStatusBeforeMark];
        }
    }
    [self.tblViewLevel reloadData];
}

- (void) callOpenWordDetail:(NSTimer*)sender
{
    
    WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
    wordDetail._strWord = [sender userInfo];
    wordDetail._strWordFirst = [sender userInfo];
    wordDetail.strBookTblName = [NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp];
    wordDetail.intBookTblNo = intBookTblNo;
    wordDetail.intDicWordOrIdiom = intDicWordOrIdiom;
    [self.navigationController pushViewController:wordDetail animated:YES];  
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblView) {
        //tableViewDic이면...
        if (blnMark == true) {
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        
    } else {
        if ((tableView == tblView) || (tableView == tblSearchWord)){
            if (blnMark == TRUE) {
                DicListCellMark *cell = (DicListCellMark*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                DLog(@"indexPath : %@", indexPath);
                cell.lblSentence.textColor = [UIColor grayColor];
                if ((cell.backgroundColor == [UIColor grayColor]) || (cell.backgroundColor == [UIColor lightGrayColor])) {
                    cell.lblSentence.textColor = [UIColor whiteColor];                
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        
        [SVProgressHUD showProgress:-1 status:@""];
        IdiomAndThemeCell *cell    = (IdiomAndThemeCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        NSString *strProverb = cell.lblProverb.text;
        DLog(@"strProverb : %@", strProverb);
        
        // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(callOpenWordDetail:)
                                       userInfo:[NSString stringWithString:strProverb]
                                        repeats:NO];

        //버전1.1_업데이트] 단어상세에서 바꾼 내용이 제대로 반영이 안되어서 바꾸엇엄. 단어상세가기전이 어디인지 저장한다.
        if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Alphabet", @"")]) {
            intSelWordRow = 1;
        } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Frequency", @"")]) {
            intSelWordRow = 2;
        } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Searched", @"")]) {
            intSelWordRow = 3;
        } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Meaning Needed", @"")]) {
            intSelWordRow = 4;
        } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Appearance Order", @"")]) {
            intSelWordRow = 5;
        } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Search Word", @"")]) {
            intSelWordRow = 6;
        }

    } else {

        if ((tableView == tblView) || (tableView == tblSearchWord)){
            if (blnMark == TRUE) {
                 DLog(@"indexPath : %@", indexPath);
                blnChangedInQuickSetting = TRUE;
                DicListCellMark *cell = (DicListCellMark*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                NSString *word = cell.lblWord.text;
                cell.lblSentence.textColor = [UIColor whiteColor];
                if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    //체크를 해제한다...
                    cell.accessoryType = UITableViewCellAccessoryNone;    

                    if ([dicMarkOri valueForKey:word] != nil) {
                        //know을 원래껄로 돌려준다.
                        NSInteger intKnow = [[dicMarkOri valueForKey:word] integerValue];
                        cell.lblKnow.text = [myCommon getStrKnowFromIntKnow:intKnow];
                                         
                        [cell setBackgroundColor:[UIColor clearColor]];
                    }
                    
                    //선탠한 단어를 dicMark, dicMarkOri에서 삭제한다.
                    [dicMarkOri removeObjectForKey:word];
                    [dicMark removeObjectForKey:word];
                } else {
                    //체크를 한다. 
                    if ([dicMarkOri valueForKey:word] == nil ) {
                        //처음체크하는 단어는 상태를 저장해둔다.
                        NSString *strKnow = cell.lblKnow.text;
                        NSInteger intKnow = 0;
                        if ([strKnow isEqualToString:@"X"]) {                        
                            intKnow = 1;
                        } else if ([strKnow isEqualToString:@"?"]) {                        
                            intKnow = 2;
                        } else if ([strKnow isEqualToString:@"!"]) {                        
                            intKnow = 3;
                        } else if ([strKnow isEqualToString:@"-"]) {                         
                            intKnow = 99;
                        } else {
                            intKnow = 0;
                        }
                            
                        
                        [dicMarkOri setValue:[NSNumber numberWithInteger:intKnow] forKey:word];
                    }
                    
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [self.dicMark setValue:[NSNumber numberWithInt:intMarkKnow] forKey:word];
                    cell.lblKnow.text = [myCommon getStrKnowFromIntKnow:intMarkKnow];
                    if (intMarkKnow < 1) {
                        [cell setBackgroundColor:[UIColor clearColor]];
                    } else if (intMarkKnow == 1) {
                        [cell setBackgroundColor:[UIColor clearColor]];
                    } else if (intMarkKnow == 2) {
                        [cell setBackgroundColor:[UIColor grayColor]];
                        cell.lblSentence.textColor = [UIColor whiteColor];
                    } else if (intMarkKnow == 3) {
                        [cell setBackgroundColor:[UIColor lightGrayColor]];
                        cell.lblSentence.textColor = [UIColor whiteColor];
                    } else if (intMarkKnow > 3) {
                        [cell setBackgroundColor:[UIColor grayColor]];
                        cell.lblSentence.textColor = [UIColor whiteColor];
                    }
                }
            } else {
                
                [SVProgressHUD showProgress:-1 status:@""];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];	
                DicListCell *cell    = (DicListCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                NSString *strWord = cell.lblWord.text;
                DLog(@"strWord : %@", strWord);
                
                // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
                [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                                 target:self
                                               selector:@selector(callOpenWordDetail:)
                                               userInfo:[NSString stringWithString:strWord]
                                                repeats:NO];
            
                blnSelRowInTbl = TRUE;
                self.strSelWord = [strWord lowercaseString];
                DLog(@"title : =%@=", self.navigationItem.title);
                
                //==============================================
                //버전1.1_업데이트] 단어상세에서 바꾼 내용이 제대로 반영이 안되어서 바꾸엇엄. 단어상세가기전이 어디인지 저장한다.
                if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Alphabet", @"")]) {
                    intSelWordRow = 1;
                } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Frequency", @"")]) {
                    intSelWordRow = 2;
                } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Searched", @"")]) {
                    intSelWordRow = 3;
                } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Meaning Needed", @"")]) {
                    intSelWordRow = 4;
                } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"By Appearance Order", @"")]) {
                    intSelWordRow = 5;
                } else if ([self.navigationItem.title isEqualToString:NSLocalizedString(@"Search Word", @"")]) {
                    intSelWordRow = 6;
                }
                //==============================================
            }
        } 
    }
}
//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
//    if ( (intDicWordOrIdiom == DicWordOrIdiom_Proverb) || (intDicWordOrIdiom == DicWordOrIdiom_PhrasalVerb) ) {
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        NSDictionary *dicOne = [arrProverb objectAtIndex:indexPath.row];;
        NSString *strProverb = [dicOne objectForKey:KEY_DIC_Idiom];
        NSString *strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
        NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
        
        if ([strMeaning isEqualToString:@""]) {
            strMeaning = [NSString stringWithString:strDesc];
        }
        
        DLog(@"heightForRowAtIndexPath strProverb : %@", strProverb);
        DLog(@"heightForRowAtIndexPath strMeaning : %@", strMeaning);
        CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
        CGSize cellProverbStringSize = [strProverb sizeWithFont:[UIFont boldSystemFontOfSize:PROVERB_FONT_SIZE]
                                              constrainedToSize:maximumSize
                                                  lineBreakMode:UILineBreakModeWordWrap];

        
        CGSize cellMeaningStringSize = [strMeaning sizeWithFont:[UIFont systemFontOfSize:PROVERB_MEANING_FONT_SIZE]
                                              constrainedToSize:maximumSize
                                                  lineBreakMode:UILineBreakModeWordWrap];

        CGFloat cellHeight = cellProverbStringSize.height + cellMeaningStringSize.height + (CELL_CONTENT_MARGIN * 4);
        DLog(@"heightForRowAtIndexPath cellHeight : %f", cellHeight);
        
        CGFloat height = MAX(cellHeight, CELL_CONTENT_MIN_HEIGHT);
        
        return height;
    } else {
    
        if (blnMark == true) {
            return 44;
        }
        if (tableView == tblView) {
//            DLog(@"tblView");
#ifdef ENGLISH
            return 60;
#elif CHINESE
            return 86;
#endif
        }
        
        if (tableView == tblSearchWord) {
            DLog(@"tblSearchWord");
#ifdef ENGLISH
            return 60;
#elif CHINESE
            return 86;
#endif
        }
    }
    
    return 86;
}

//헤더의 내용을 적는다.
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == tblSearchWord) {
        if ([arrSearchedWordsAllAttribute count] == 0) {
            return @"";
        } else if ([arrSearchedWordsAllAttribute count] == 1) {
            return [NSString stringWithFormat:@"%d %@", [arrSearchedWordsAllAttribute count], NSLocalizedString(@"Word", @"")];
        } else {
            return [NSString stringWithFormat:@"%d %@",[arrSearchedWordsAllAttribute count], NSLocalizedString(@"Words", @"")];
        }
        return [NSString stringWithFormat:@"%@ %d,", NSLocalizedString(@"Words", @""), _cntOfAllWords];
    } else if (tableView == tblView) {
        if (_cntOfAllWords >= kPageDivide) {
            return [NSString stringWithFormat:@"%d %@, %d/%d %@", _cntOfAllWords, NSLocalizedString(@"Words", @""), pageNumber, pageNumberMax, NSLocalizedString(@"Pages", @"")];
        } else {
            return [NSString stringWithFormat:@"%d %@, %d %@", _cntOfAllWords, NSLocalizedString(@"Words", @""), pageNumber, NSLocalizedString(@"Page", @"")];
        }
    }
	return @"";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //swipe했을때 에디팅 모드를 할지 안할지 결정한다.
    // Detemine if it's in editing mode
    if (intDicListType == DicListType_TBL_EngDic) {
//        DLog(@"tbl.tag : %d", tableView.tag);
        if ((tableView == tblView) && (blnMark == FALSE) && (intBeforeSegSelectedIndex == 0) ){
            //전체사전이고 Mark가 아닐때만 에디팅 가능
            return UITableViewCellEditingStyleDelete;;
        }
        
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {


	if (intDicListType != DicListType_TBL_EngDic) {
        //전체사전일때만 에디팅 가능
        return;
    }
	if (tableView != tblView) {
		//tblView에서만 에디팅 가능
		return;
	}
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		DicListCell *cell    = (DicListCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
		NSString *strWord = cell.lblWord.text;
//		DLog(@"strWord Before : %@", strWord);
		
		strWord = [myCommon getCleanAndSingleQuoteWordForSQL:strWord];
//		DLog(@"strWord After : %@", strWord);
		
		NSString	*strQuery = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'", TBL_EngDic, FldName_Word, strWord];
		[myCommon changeRec:strQuery openMyDic:true];
		if (intDicListType >= DicListType_TBL_EngDicEachBook) {
			strQuery = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'", TBL_EngDic, FldName_Word, strWord];
			[myCommon changeRec:strQuery openMyDic:FALSE];
		}
		if (intDicListType >= DicListType_TBL_EngDicBookTemp) {
			strQuery = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'", TBL_EngDic_BookTemp, FldName_Word, strWord];
			[myCommon changeRec:strQuery openMyDic:TRUE];
		}
		
		
		
		if (intBeforeSegSelectedIndex == 0) {	
			[arrAllWordsAllAttribute removeObjectAtIndex:indexPath.row];
		} else if ((intBeforeSegSelectedIndex == 1) || (intBeforeSegSelectedIndex == 4)) {				
			[arrUnknownWordsAllAttribute removeObjectAtIndex:indexPath.row];
		} else if (intBeforeSegSelectedIndex == 2) {
			[arrToMemorizeWordsAllAttribute removeObjectAtIndex:indexPath.row];
		} else if (intBeforeSegSelectedIndex == 3) {
			[arrToWriteMeaningAllAttribute removeObjectAtIndex:indexPath.row];
		}	
		
		_cntOfAllWords--;
		if (_cntOfAllWords >= kPageDivide) {
			self.navigationItem.title = [NSString stringWithFormat:@"%d %d/%d%@", _cntOfAllWords, pageNumber, pageNumberMax, NSLocalizedString(@"Pages", @"")];
		} else {
			self.navigationItem.title = [NSString stringWithFormat:@"%d %d%@", _cntOfAllWords, pageNumber, NSLocalizedString(@"Page", @"")];
		}
		
		
		[tableView reloadData];
	} 
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = TRUE;
	return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = FALSE;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	DLog(@"searchBarCancelButtonClicked:");
	[searchBar resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
	DLog(@"searchBarBookmarkButtonClicked:");
	[searchBar resignFirstResponder];	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
    [SVProgressHUD showProgress:-1 status:@""];
    
    [searchBar resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(searchWord:)
                                   userInfo:searchBar.text
                                    repeats:NO];
}

- (void) searchWord:(NSTimer*)sender
{
    NSString *strWord = [sender userInfo];
    strWord = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
	NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@%%' order by Word", TBL_EngDic, FldName_TBL_EngDic_WORD, strWord];
    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrSearchedWordsAllAttribute byDic:nil openMyDic:OPEN_DIC_DB];     
    if ([arrSearchedWordsAllAttribute count] == 0) {
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"No word in the dictionary.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
    } else {
//        DLog(@"arrAllWordsAllAttribute : %@", arrSearchedWordsAllAttribute);
        for(int i = 0; i < [arrSearchedWordsAllAttribute count]; i++)
        {
            NSDictionary *dicOne = [arrSearchedWordsAllAttribute objectAtIndex:i];                
            NSString		*strMeaning = [dicOne objectForKey:@"Meaning"];
                    
            //뜻이 없으면 원형의 뜻으로 넣는다.
            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""])) {
                NSString	*strWordOri = [dicOne objectForKey:@"WordOri"];
                NSString    *worOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
                NSString    *strQueryWordOri = [NSString stringWithFormat:@"SELECT %@ From %@ WHERE %@ = '%@'",FldName_TBL_EngDic_MEANING, TBL_EngDic, FldName_TBL_EngDic_WORD, worOriForSQL];
                strMeaning = [myCommon getStringFldValueFromTbl:strQueryWordOri openMyDic:TRUE];
                [dicOne setValue:strMeaning forKey:@"Meaning"];
                
                [arrSearchedWordsAllAttribute replaceObjectAtIndex:i withObject:dicOne];
            }            
        }

        [self.tblSearchWord reloadData];
    }
    [SVProgressHUD dismiss];
    
}
#pragma mark -
#pragma mark UISearchDisplayController
- (BOOL) searchDisplayController:(UISearchDisplayController*) controller shouldReloadTableForSearchString:(NSString*)searchString
{
	NSString *strToSearchLowerString = [searchString lowercaseString];
	[arrFiltered removeAllObjects];
	for(NSDictionary* section in self.arrAllWordsAllAttribute)
	{	
		NSString *strWord = [section objectForKey:@"Word"];
		NSString *strMeaning = [section objectForKey:@"Meaning"];
		NSRange rWord = [strWord rangeOfString:strToSearchLowerString];
		NSRange rMeaning = [strMeaning rangeOfString:strToSearchLowerString];
		
		if(rWord.location != NSNotFound || rMeaning.location != NSNotFound)
		{
			[arrFiltered addObject:section];
		}
	}
	//	DLog(@"arrFiltered : %@", arrFiltered);
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [myCommon closeDB:true];
    [myCommon openDB:true];
#ifdef DEBUG
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Debug Mode"	message:@"Memory Warning"  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert2 show];
#endif    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
		DLog(@"viewDidUnload");
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
