//
//  DicListController.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 6..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
@class AppDelegate;

@interface DicListController : UIViewController<UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIActionSheetDelegate, UISearchBarDelegate> {
    
    AppDelegate *appDelegate;
    
    NSMutableArray    *arrProverb;
    NSString                        *strAllContentsInFile;
	NSArray							*arrIndexAlphabet;
	NSMutableArray					*arrAllWordsAllAttribute;
	NSMutableArray					*arrLevel;
	NSInteger						intSelLevel;
    NSMutableArray                  *arrSentence;
	NSMutableArray					*arrUnknownWordsAllAttribute;
	NSMutableArray					*arrToMemorizeWordsAllAttribute;
	NSMutableArray					*arrToWriteMeaningAllAttribute;
    NSMutableArray                  *arrSearchedWordsAllAttribute;
	NSMutableDictionary				*dicKnowAndUnKnown;
	NSMutableArray					*arrFiltered;
    NSMutableDictionary             *dicMark;
    NSMutableDictionary             *dicMarkOri;    
    NSInteger                       intMarkKnow;
	IBOutlet UITableView			*tblViewLevel;
	IBOutlet UITableView			*tblView;
	IBOutlet UIView					*viewLevel;
    IBOutlet UIView					*viewLevelHeader;
	IBOutlet UIView					*viewTable;
    IBOutlet UIView                 *viewTblSearchWord;
    IBOutlet UILabel                *lblLevelHeader;
    IBOutlet UITextView             *txtViewUserLevel;
	NSString						*strScriptFileName;
	BOOL							blnFirstOpen;
	BOOL							blnAscendingName;
	BOOL							blnAscendingCount;
	BOOL							blnAscendingWordOrder;
	BOOL							blnAscendingKnow;
	NSInteger						intBeforeSegSelectedIndex;
    NSInteger                       intBeforeTabbarSelectedIndex;
	NSInteger						_cntOfExcludeWords;
	NSInteger						_cntOfKnowWords;    
	NSInteger						_cntOfNotSureWords;
	NSInteger						_cntOfUnKnownWords;
	NSInteger						_cntOfNotRatedWords;    
	NSInteger						noOfUniqueWords;	
	NSInteger						_cntOfAllWords;
//    NSInteger						_cntOfAllIdioms;
	NSUInteger						pageNumber;
	NSUInteger						pageNumberMax;
	
	IBOutlet UIButton				*btnBackwordInTable;
	IBOutlet UIButton				*btnForwordInTable;
	IBOutlet UISlider				*sliderWordInTable;
	IBOutlet UISearchBar			*searchBarOne;
    IBOutlet UITabBar               *tabBarAllDic;
    IBOutlet UITabBarItem           *tabBarItemSearch;
    IBOutlet UITabBarItem           *tabBarItemSort;
    IBOutlet UITabBarItem           *tabBarItemQuickSetting;
    IBOutlet UITabBarItem           *tabBarItemStudyWords;
    IBOutlet UITabBarItem           *tabBarItemBackup;    
    IBOutlet UITabBar               *tabBarOneBook;
    IBOutlet UITabBarItem               *tabBarItemOneBookSearch;
    IBOutlet UITabBarItem               *tabBarItemOneBookSort;
    IBOutlet UITabBarItem               *tabBarItemOneBookQuickSetting;
    IBOutlet UITabBarItem               *tabBarItemOneBookStudyWords;
    IBOutlet UITabBarItem               *tabBarItemOneBookExportAsText; 
    IBOutlet UISearchBar            *searchBarWord;
    IBOutlet UITableView            *tblSearchWord;

	NSInteger						intBookTblNo;
	BOOL							blnSelRowInTbl;
    BOOL                            blnMark;
    BOOL                            blnBackup;
    BOOL                            blnQuickSettingInBookMode;
    BOOL                            blnChangedInQuickSetting;
	NSString						*strSelWord;
	NSInteger						intSelWordRow;
	NSInteger						intDicListType;
    NSInteger                       intDicWordOrIdiom;

    NSString                        *strBeforeType;
    UIActionSheet					*actionSheetProgress;
	UIProgressView					*progressViewInActionSheet;
    UIAlertView                     *alertViewProgress;
    UIView                          *viewKnow;
    UIButton                        *btnKnowNotRated;
    UIButton                        *btnKnowUnknown;
    UIButton                        *btnKnowNotSure;
    UIButton                        *btnKnowKnown;
    UIButton                        *btnKnowExclude;
    NSInteger                            intKnowNotRated;
    NSInteger                            intKnowUnknown;
    NSInteger                            intKnowNotSure;
    NSInteger                            intKnowKnown;
    NSInteger                            intKnowExclude;
    BOOL                            blnOpenFlashCard;

    BOOL                            blnUseKnowButton;
    NSString                        *strWhereClauseFldSQL;

    UIView *fakeView;
}
@property (nonatomic, strong) NSMutableArray    *arrProverb;
@property (nonatomic, strong) NSString                        *strAllContentsInFile;
@property (nonatomic, strong) NSArray						*arrIndexAlphabet;
@property (nonatomic, strong) NSMutableArray				*arrLevel;
@property (nonatomic, strong) NSMutableArray                  *arrSentence;
@property (nonatomic, strong) NSMutableArray				*arrUnknownWordsAllAttribute;
@property (nonatomic, strong) NSMutableArray				*arrAllWordsAllAttribute;
@property (nonatomic, strong) NSMutableArray				*arrToMemorizeWordsAllAttribute;
@property (nonatomic, strong) NSMutableArray				*arrToWriteMeaningAllAttribute;
@property (nonatomic, strong) NSMutableArray                 *arrSearchedWordsAllAttribute;
@property (nonatomic, strong) NSMutableDictionary			*dicKnowAndUnKnown;
@property (nonatomic, strong) NSMutableArray			*arrFiltered;
@property (nonatomic, strong) NSMutableDictionary             *dicMark;
@property (nonatomic, strong) NSMutableDictionary             *dicMarkOri;
@property (nonatomic)   NSInteger                           intMarkKnow;
@property (nonatomic, strong) IBOutlet UITableView		*tblViewLevel;
@property (nonatomic, strong) IBOutlet UITableView		*tblView;
@property (nonatomic, strong) IBOutlet UIView			*viewLevel;
@property (nonatomic, strong) IBOutlet UIView			*viewLevelHeader;
@property (nonatomic, strong) IBOutlet UIView			*viewTable;
@property (nonatomic, strong) IBOutlet UIView			*btnBackwordInTable;
@property (nonatomic, strong) IBOutlet UIView			*btnForwordInTable;
@property (nonatomic, strong) IBOutlet UIView                 *viewTblSearchWord;
@property (nonatomic, strong) IBOutlet UILabel			*lblLevelHeader;
@property (nonatomic, strong) IBOutlet UITextView             *txtViewUserLevel;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem		*barBtnBack;
@property (nonatomic, strong) NSString					*strScriptFileName;
//@property (nonatomic, strong) NSString								*strBookTblName;
@property (nonatomic) NSInteger						intSelLevel;
@property (nonatomic) NSInteger								intBookTblNo;
@property (nonatomic) BOOL									blnFirstOpen;
@property (nonatomic) BOOL									blnAscendingName;
@property (nonatomic) BOOL									blnAscendingCount;
@property (nonatomic) BOOL									blnAscendingWordOrder;
@property (nonatomic) BOOL									blnAscendingKnow;
@property (nonatomic) BOOL                            blnQuickSettingInBookMode;
@property (nonatomic) BOOL                            blnChangedInQuickSetting;
@property (nonatomic) NSInteger								intBeforeSegSelectedIndex;
@property (nonatomic) NSInteger								intBeforeTabbarSelectedIndex;
@property (nonatomic) NSInteger                             _cntOfExcludeWords;
@property (nonatomic) NSInteger								_cntOfKnowWords;
@property (nonatomic) NSInteger								_cntOfNotSureWords;
@property (nonatomic) NSInteger								_cntOfUnKnownWords;
@property (nonatomic) NSInteger						_cntOfNotRatedWords;    
@property (nonatomic) NSInteger								noOfUniqueWords;
@property (nonatomic) NSInteger								_cntOfAllWords;
//@property (nonatomic) NSInteger								_cntOfAllIdioms;
@property (nonatomic) NSUInteger							pageNumber;
@property (nonatomic) NSUInteger							pageNumberMax;
@property (nonatomic, strong) IBOutlet UISlider				*sliderWordInTable;
@property (nonatomic, strong) IBOutlet UITabBar               *tabBarAllDic;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarItemSearch;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarItemSort;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarItemQuickSetting;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarItemStudyWords;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarItemBackup;    
@property (nonatomic, strong) IBOutlet UITabBar               *tabBarOneBook;
@property (nonatomic, strong) IBOutlet UITabBarItem               *tabBarItemOneBookSearch;
@property (nonatomic, strong) IBOutlet UITabBarItem               *tabBarItemOneBookSort;
@property (nonatomic, strong) IBOutlet UITabBarItem               *tabBarItemOneBookQuickSetting;
@property (nonatomic, strong) IBOutlet UITabBarItem               *tabBarItemOneBookStudyWords;
@property (nonatomic, strong) IBOutlet UITabBarItem               *tabBarItemOneBookExportAsText; 

@property (nonatomic, strong) IBOutlet UISearchBar            *searchBarWord;
@property (nonatomic, strong) IBOutlet UITableView            *tblSearchWord;
@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView					*progressViewInActionSheet;
@property (nonatomic, strong) UIAlertView                   *alertViewProgress;
@property (nonatomic) BOOL									blnSelRowInTbl;
@property (nonatomic, strong) NSString						*strSelWord;
@property (nonatomic) NSInteger								intSelWordRow;
@property (nonatomic) BOOL blnMark;
@property (nonatomic) BOOL                            blnBackup;
@property (nonatomic) NSInteger								intDicListType; //DicListType_TBL_EngDic 1, DicListType_TBL_EngDicEachBook 2, DicListType_TBL_EngDicBookTemp 3, DicListType_TBL_EngDicUserLevel 4, DicListType_TBL_EngDicWordGroup 5, DicListType_TBL_EngDicUserDic 6

@property (nonatomic) NSInteger								intDicWordOrIdiom;
@property (nonatomic, strong) NSString                      *strBeforeType;
@property (nonatomic, strong) UIButton                        *btnKnowNotRated;
@property (nonatomic, strong) UIButton                        *btnKnowUnknown;
@property (nonatomic, strong) UIButton                        *btnKnowNotSure;
@property (nonatomic, strong) UIButton                        *btnKnowKnown;
@property (nonatomic, strong) UIButton                        *btnKnowExclude;
@property (nonatomic) NSInteger                            intKnowNotRated;
@property (nonatomic) NSInteger                            intKnowUnknown;
@property (nonatomic) NSInteger                            intKnowNotSure;
@property (nonatomic) NSInteger                            intKnowKnown;
@property (nonatomic) NSInteger                            intKnowExclude;
@property (nonatomic)     BOOL                            blnOpenFlashCard;
@property (nonatomic)     BOOL                            blnUseKnowButton;

@property (nonatomic, strong)     NSString                        *strWhereClauseFldSQL;

- (IBAction) back;
- (void) callOpenWordDetail:(NSTimer*)sender;
//- (void) callRefreshWord;
- (void) callRefreshWords;
- (void) callCloseLevelView:(NSTimer*)sender;
- (void) closeLevelView;
//- (void) editWord;
- (void) getUnKnownWords;
//- (IBAction) onBtnBackWord;
- (IBAction) onBtnBackwordInTable;
- (IBAction) onBtnForwordInTable;
- (void) openBackup:(NSTimer*)sender;
- (IBAction) pickDicSort:(id)sender;
//- (void) refreshWords:(NSTimer*)sender;
- (void) refreshWords;
- (void) callRestoreStatusBeforeMark:(NSNumber*) param;
- (void) restoreStatusBeforeMark;
//- (void) saveMarkOri:(NSTimer*)sender;
- (void) saveMarkOri:(NSObject*)obj;
- (void) searchWord:(NSTimer*)sender;
- (void) selSwitchLevel:(id)sender event:(id)event;
//- (void) setSliderWord;
- (void) setSliderWordInTable;

//- (IBAction) sliderWordChanged : (id) sender;
//- (IBAction) sliderWordChanging : (id) sender;
- (IBAction) sliderWordInTableChanged : (id) sender;
- (IBAction) sliderWordInTableChanging : (id) sender;

- (void) updateProgress:(NSNumber*) param;
- (void) updateProgressTitle:(NSString*) param;

- (void) selBtnKnowNotRated;
- (void) selBtnKnowUnknown;
- (void) selBtnKnowNotSure;
- (void) selBtnKnowKnown;
- (void) selBtnKnowExclude;
- (void) saveKnowOfBtuuon;
- (void) setButton:(NSInteger)intSortType;
- (void) setButtonSelected;

- (void) getSentence:(NSMutableArray*)arrWords;

- (void) doActionSheet:(NSTimer*)sender;
@end
