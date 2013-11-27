//
//  MoviePlayerController.h
//  MyListPro
//
//  Created by 김형달 on 10. 9. 28..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CGColor.h>
#import <AudioToolBox/AudioServices.h>
#import "NCXNavigationDefinition.h"
#import "XMLHandler.h"
#import "EpubContent.h"
#import <MessageUI/MessageUI.h>
#import "ContentViewController.h"

enum  {
	prevWebView = 0,
	currWebView = 1,
	nextWebView = 2,
	currWebViewDup = 3,	

};

@interface BookViewController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,    UISearchBarDelegate, UIGestureRecognizerDelegate, UITabBarDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIWebViewDelegate, UITextViewDelegate,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UIPageViewControllerDataSource,UIPageViewControllerDelegate>{
    
    IBOutlet UIView                 *viewAnalyzeMain;
    IBOutlet UIView                 *viewAnalyzeSmall;    
    IBOutlet UIProgressView               *progressAnalyze;
    IBOutlet UILabel                *lblAnalyze;
    IBOutlet UIButton               *btnCancelAnalyze;
    
    IBOutlet UIView                 *viewCurPage;
    IBOutlet UILabel                *lblCurPage;
    IBOutlet UILabel                *lblShowMeaning;
    
    NSMutableArray                  *arrWebView;
    NSMutableArray                  *arrNextPages;
    NSMutableArray                  *arrExamPages;
    NSInteger                       PickerViewType;
    
    UIView                          *overlayView;

    int indexToCompare;
    
    NSFileManager *fm;
    ContentViewController *firstContentViewController;
    
	IBOutlet UIView					*viewBackLight;
	IBOutlet UIView					*viewPageNo;
	IBOutlet UILabel				*lblPageNoPercent;
	IBOutlet UISlider				*slideBackLight;
	IBOutlet UISlider				*slidePageNo;
	IBOutlet UITabBar				*tabBarFont;
    IBOutlet UITabBarItem           *tabBarFontSmaller;
    IBOutlet UITabBarItem           *tabBarFontBigger;    
	IBOutlet UITabBar				*tabBarViewModeBook;
    IBOutlet UITabBarItem           *tabBarViewModeBookItemPrepare;
    IBOutlet UITabBarItem           *tabBarViewModeBookItemDicInfo;
    IBOutlet UITabBarItem           *tabBarViewModeBookItemAdjust;
    IBOutlet UITabBarItem           *tabBarViewModeBookItemSetting;
	IBOutlet UITabBar				*tabBarViewModeWeb;
    IBOutlet UITabBarItem           *tabBarViewModeWebItemBack;
    IBOutlet UITabBarItem           *tabBarViewModeWebItemRefreshStop;
    IBOutlet UITabBarItem           *tabBarViewModeWebItemForward;
    IBOutlet UITabBarItem           *tabBarViewModeWebItemFavorites;
    IBOutlet UITabBarItem           *tabBarViewModeWebItemBook;    
    IBOutlet UIView                 *viewSearchWord;
    IBOutlet UISearchBar            *searchBarSearchWord;
    IBOutlet UITableView            *tblSearchWord;
	IBOutlet	UIPickerView		*pickerNextPrevPages;
    IBOutlet    UIView              *viewPickerNextPrevPages;
    IBOutlet    UIBarButtonItem     *barBtnItemSelectPickerNextPrevPages;
    IBOutlet    UIBarButtonItem     *barBtnItemCacnelPickerNextPrevPages;

    NSString                        *strNextPrevPages;
    NSMutableArray                  *arrSearchWord;
	NSString						*strBookFullFileName;
    NSString                        *strBookFileNameExtension;

	NSInteger						intBookTblNo;
	NSInteger					intUserLevel;
	NSString						*strBookFileNameInCachesWithPath;
	NSInteger						initialScrollPosition;
	NSInteger						fontSize;
	NSMutableDictionary				*dicAllWordsAllAttribute;
	NSMutableDictionary				*dicWordChangeAndOri;

	NSMutableDictionary				*dicSetting;

	NSMutableString						*_strMutableCopyWordOri;
	NSMutableString						*_strMutableCopyWord;
	NSInteger							maxPageNo;

	IBOutlet    UIView			*viewDic;
	IBOutlet    UITextField		*txtMeaning;
	IBOutlet	UILabel			*lblKnow;
	IBOutlet	UILabel			*lblCount;
	IBOutlet    UIButton		*btnTabBar;

	BOOL						blnWebStudy;
	BOOL						blnOpenBookmark;
	BOOL						blnLinkOff;                 //웹에서 링크를 해제하는 역활(차기업데이트]지금은 기능을 막아둠)
    BOOL                        blnFirstViewQA_IOS5;
	NSMutableString				*_strMutableURL;
	NSString					*strWebViewMode;            //Book에서 Study 와 Normal를 구분하는 구분자
	NSInteger					intStatusBarHeight;
	NSInteger					intViewHeight;
	NSInteger					intViewType;
	NSInteger                   intCSSVersion;
	IBOutlet	UINavigationBar *naviBarWebUrl;
	IBOutlet	UISearchBar		*searchBarWebUrl;
	IBOutlet	UIWebView		*webViewWeb;
	IBOutlet	UIBarItem		*barLinkOff;

    IBOutlet UIImageView                    *imgViewQA_Question;
    IBOutlet UIView                         *viewQA;
    IBOutlet UIView                         *viewQA_inside;
    IBOutlet UITextView                     *txtViewQA_Question;
    IBOutlet UIButton                       *btnQA_Answer1;
    IBOutlet UIButton                       *btnQA_Answer2;
    IBOutlet UIButton                       *btnQA_Answer3;
    IBOutlet UIButton                       *btnQA_Answer4;
    IBOutlet UIButton                       *btnQA_Close;
    IBOutlet UIButton                       *btnOpenQuiz;
    NSInteger                               intAnswer;
    NSInteger                               intWrongAnswer;
    NSMutableArray                          *arrWrongAnswers;
    NSMutableArray                          *arrWrongAnswers_IOS5;    
    BOOL                                    blnAnswerd;
    BOOL                                    blnBtnAnswer1Clicked;
    BOOL                                    blnBtnAnswer2Clicked;
    BOOL                                    blnBtnAnswer3Clicked;
    BOOL                                    blnBtnAnswer4Clicked;    
    BOOL                                    blnOnQAMode;
    BOOL                                    blnOnQA_Vibration;
    NSString                                *strQABeforeWord;
    
	UITextField					*txtBookName;
//	UIAlertView						*alertViewProgress;
	UIActionSheet					*actionSheetProgress;
	UIProgressView					*progressViewInActionSheet;
    NSString                        *strLatestBook;
    NSString                        *strBookSqliteName;
    NSInteger                       pageOfBookLines;
    BOOL scrollFeedbackFromOtherControl;
    NSMutableArray                          *arrPageInfo;
    NSInteger                       currPageNo;
    NSInteger                       currPageNoToGo;
    
    BOOL                            blnShowUnknowWords;
    BOOL                            blnHasShowMeaningUserDefault;
    NSString						*strBookFileNameCurrPageInCachesWithPath;
    NSString						*strBookFileNameCurrDupPageInCachesWithPath;
    NSString						*strBookFileNamePrevPageInCachesWithPath;
    NSString						*strBookFileNameNextPageInCachesWithPath;
    NSString                        *strAllContentsInFile;
    NSMutableDictionary *dicAllWordsInBook;
    BOOL                            blnFirstOpen;
    BOOL                            blnPageChanged;
    BOOL                            blnWebViewOneFront;     //webViewOne이 최상위 뷰이면 TRUE, webViewEBookDup가 최상위이면 FALSE
    BOOL                            blnDoSTHToChangeFront; //최상위 뷰가 바뀔행동(HTML을 다시부르는)을 했을때 ON
    BOOL                            blnNextPage;
    BOOL                            blnPrevPage;
    UIAlertView                     *alertViewProgress;
    BOOL                            blnSelWord;
    BOOL                           blnFirstOpenPage;    //페이지 계산을 하기위해서(맨처음 열었을때만 페이지계산이 필요하면 한다.)
    BOOL                            blnCancelReadTxt;   //readTxt를 중도에 멈추기 위한 플래그
    BOOL                               blnCancelCountingPage; //CountingPage를 멈추기 위한 플래그
    BOOL                            blnCountingPages;   //Counting Pages를 하고 있는지 파악하는 플래그(Analyze랑 Book Info등은 Counting Pages가 끝난뒤에 할려구)
    BOOL                            blnCountingPagesCheckingHeight; //Counting Pages를 하는 도중에 WebView의 한화면에 다 들어오는지 검사하는 플래그
    BOOL                            blnPressAdjust;
    BOOL                            blnBookDayMode; //책읽을때 주간/야간모드 구분 (TRUE이면 주간모드, FALSE이면 야간모드)
    BOOL                            blnShowQuizButton; //뜻을 보여줄때 그냥 보여줄지 퀴즈를 통해서 보여줄지 결정한다.
//    NSMutableDictionary          *dicWordsForQuiz;
    
    //동영상관련    
    IBOutlet UIView                 *viewMovie;
    IBOutlet UIView                 *viewOneInMovie;
    IBOutlet UIView                 *viewTwoInMovie;
    IBOutlet UIButton               *btnMoviePlayOrStop;
    IBOutlet UIButton               *btnRepeatStartPoint;
    IBOutlet UIButton               *btnRepeatEndPoint;    
    IBOutlet UIButton               *btnEndRepeat;
    IBOutlet UIButton               *btnResizeMovieView;
    IBOutlet UIButton               *btnMoviePlayRate;
    IBOutlet UIButton               *btnInfo;
    IBOutlet UIButton               *btnShowScript;
    IBOutlet UILabel               *lblStartTime;
    IBOutlet UILabel               *lblEndTime;
    IBOutlet UILabel                *lblMovieScript;
    IBOutlet UIWebView              *webMovieScript;
    IBOutlet UITextView             *txtViewMovieScript;
    NSMutableDictionary             *dicScript;    
    NSMutableArray                  *arrScript;
    NSMutableDictionary             *dicScript1;    
    NSMutableArray                  *arrScript1;
    
    NSTimer                         *timerScript;
    NSTimeInterval                  _currentPalyBackTime;    
    BOOL                            blnIsMoviePlaying;
    BOOL                            blnRepeating;
    BOOL                            blnMovieSwipe;
    BOOL                            blnResizeMovieBig;    
    BOOL                            blnShowScript;
    NSInteger                       intHideWordInScript;
    MPMoviePlayerController         *moviePlayer;
    NSString                        *strMovieFileName;
    NSString                        *strScriptFileName;
    NSString                        *strNextScript;
    NSInteger                       indexOfCurrentScript;    
    NSInteger                       playType;
    NSInteger                       intRepeatStartPoint;
    NSInteger                       intRepeatEndPoint; 
    NSInteger                       intMovieStartPoint;
    NSInteger                       intMovieEndPoint;
    
    
    //단어 찾기기능
    NSString                        *strWordSearch;
    NSString                        *strWordOriSearch;
    NSMutableArray                  *arrWordSearchFamily;
    NSMutableDictionary             *dicWordSearchFamilyDetail;
    NSInteger                       intOriPage;
    NSInteger                       intSelTblRow;       //테이블에서 선택한 Row
    NSInteger                       intIndexOfWordInSamePage; //한페이지내에서 선택한 단어의 순서
    NSInteger                       intPageNoOfWordSearch; //선택한 단어가 있는 페이지    
    NSInteger                       intAllSearchedWords;
    BOOL                            blnCaseSensitive;
    BOOL                            blnHeadword;
    BOOL                            blnWordSearchMode;
    UITableViewCell                 *customCell;
    
    UIView                          *viewWordSearchBackAndForward;
    UILabel                         *lblWordPage;
    UIButton                        *btnWordSearchBack;
    UIButton                        *btnWordSearchForward;
    UIButton                        *btnBackToPreviousPage;
    UIButton                        *btnCloseViewWordSearch;
    UIButton                        *btnReopenWordSearch;
    UIButton                        *btnCloseViewWordSearchBackAndForward;
    
    NSInteger                       intTableViewMode;
    //epub관련
//    NCXNavigationDefinition* navigationDefinition;
//    NCXNavigationPoint* navigationPoint;
	NSString* ePubDirName;
    NSString *ePubDirPath;
    
	XMLHandler *_xmlHandler;
	EpubContent *_ePubContent;
	NSString *_pagesPath;
	NSString *_rootPath;
	NSString *_strFileName;
    NSMutableArray *_arrEPubChapter;
	NSInteger _pageNumber;

    float lastScrollY;
    
    NSInteger                           _intKnowChanged;
    UIPageViewController                *pageViewController;
    IBOutlet UIActivityIndicatorView    *webIndicator;
}

@property (nonatomic) BOOL shouldDenyPageTurn;
@property (nonatomic) float lastScrollY;
@property (nonatomic, strong) IBOutlet UIView                 *viewAnalyzeMain;
@property (nonatomic, strong) IBOutlet UIView                 *viewAnalyzeSmall;    
@property (nonatomic, strong) IBOutlet UIProgressView         *progressAnalyze;
@property (nonatomic, strong) IBOutlet UILabel                *lblAnalyze;
@property (nonatomic, strong) IBOutlet UIButton               *btnCancelAnalyze;


@property (nonatomic, strong) IBOutlet UIView                 *viewCurPage;
@property (nonatomic, strong) IBOutlet UILabel                *lblCurPage;
@property (nonatomic, strong) IBOutlet UILabel                *lblShowMeaning;
@property (nonatomic, strong)     NSMutableArray                  *arrWebView;
@property (nonatomic, strong)     NSMutableArray              *arrNextPages;
@property (nonatomic, strong)     NSMutableArray              *arrExamPages;
@property (nonatomic)    NSInteger                              PickerViewType;

@property (nonatomic, strong)     UIView                          *overlayView;
@property (nonatomic) NSInteger                       pageOfBookLines;
@property (nonatomic, strong) NSFileManager *fm; 

@property (nonatomic, strong) IBOutlet UIView			*viewBackLight;
@property (nonatomic, strong) IBOutlet UIView			*viewPageNo;
@property (nonatomic, strong) IBOutlet UILabel			*lblPageNoPercent;

@property (nonatomic, strong) IBOutlet UISlider				*slideBackLight;
@property (nonatomic, strong) IBOutlet UISlider				*slidePageNo;

@property (nonatomic, strong) IBOutlet UITabBar			*tabBarFont;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarFontSmaller;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarFontBigger;    

@property (nonatomic, strong) IBOutlet UITabBar			*tabBarViewModeBook;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeBookItemPrepare;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeBookItemDicInfo;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeBookItemAdjust;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeBookItemSetting;
@property (nonatomic, strong) IBOutlet UITabBar			*tabBarViewModeWeb;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeWebItemBack;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeWebItemRefreshStop;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeWebItemForward;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeWebItemFavorites;
@property (nonatomic, strong) IBOutlet UITabBarItem           *tabBarViewModeWebItemBook;   

@property (nonatomic, strong) IBOutlet UIView                 *viewSearchWord;
@property (nonatomic, strong) IBOutlet UISearchBar            *searchBarSearchWord;
@property (nonatomic, strong) IBOutlet UITableView            *tblSearchWord;
@property (nonatomic, strong) IBOutlet	UIPickerView		*pickerNextPrevPages;
@property (nonatomic, strong) IBOutlet    UIView              *viewPickerNextPrevPages;
@property (nonatomic, strong) IBOutlet    UIBarButtonItem     *barBtnItemSelectPickerNextPrevPages;
@property (nonatomic, strong) IBOutlet    UIBarButtonItem     *barBtnItemCacnelPickerNextPrevPages;

@property (nonatomic, strong) NSString                        *strNextPrevPages;
@property (nonatomic, strong) NSMutableArray                  *arrSearchWord;
@property (nonatomic, strong) NSString					*strBookFullFileName;
@property (nonatomic, strong) NSString                        *strBookFileNameExtension;
@property (nonatomic, strong) NSString					*strBookFileNameInCachesWithPath;
@property (nonatomic) NSInteger							initialScrollPosition;
@property (nonatomic) NSInteger							fontSize;
@property (nonatomic) NSInteger							intUserLevel;
@property (nonatomic) NSInteger							maxPageNo;
@property (nonatomic) NSInteger                   intCSSVersion;
@property (nonatomic, strong) NSMutableDictionary			*dicAllWordsAllAttribute;
@property (nonatomic, strong) NSMutableDictionary			*dicWordChangeAndOri;
@property (nonatomic, strong) NSMutableDictionary			*dicSetting;

@property (nonatomic, strong) NSMutableString					*_strMutableCopyWordOri;
@property (nonatomic, strong) NSMutableString					*_strMutableCopyWord;
@property (nonatomic) NSInteger							intViewType;

@property (nonatomic, strong) IBOutlet UIView			*viewDic;
@property (nonatomic, strong) IBOutlet UITextField		*txtMeaning;
@property (nonatomic, strong) IBOutlet UILabel			*lblKnow;
@property (nonatomic, strong) IBOutlet UILabel			*lblCount;
@property (nonatomic, strong) IBOutlet UIButton			*btnTabBar;

@property (nonatomic, strong) IBOutlet	UINavigationBar *naviBarWebUrl;
@property (nonatomic, strong) IBOutlet	UISearchBar		*searchBarWebUrl;
@property (nonatomic, strong) IBOutlet	UIWebView		*webViewWeb;
@property (nonatomic, strong) IBOutlet	UIBarItem		*barLinkOff;

@property (nonatomic) NSInteger								intBookTblNo;
@property (nonatomic, strong) NSMutableString				*_strMutableURL;
@property (nonatomic, strong) NSString						*strWebViewMode;
@property (nonatomic) NSInteger		intStatusBarHeightPlus;
@property (nonatomic) NSInteger		intViewHeight;
@property (nonatomic) BOOL								blnWebStudy;
@property (nonatomic) BOOL								blnOpenBookmark;
@property (nonatomic) BOOL                              blnLinkOff;
@property (nonatomic) BOOL                              blnFirstViewQA_IOS5;
@property (nonatomic, strong) UITextField					*txtBookName;

@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView	*progressViewInActionSheet;
@property (nonatomic, strong) NSString                        *strLatestBook;
@property (nonatomic, strong) NSString                          *strBookSqliteName;
@property (nonatomic, strong)     NSMutableArray                          *arrPageInfo;
@property (nonatomic) NSInteger currPageNo;
@property (nonatomic) NSInteger currPageNoToGo;
@property (nonatomic)    BOOL                            blnShowPhrasalVerb;
@property (nonatomic)    BOOL                            blnShowUnknowWords;
@property (nonatomic, strong) NSString						*strBookFileNameCurrPageInCachesWithPath;
@property (nonatomic, strong) NSString						*strBookFileNameCurrDupPageInCachesWithPath;
@property (nonatomic, strong) NSString						*strBookFileNamePrevPageInCachesWithPath;
@property (nonatomic, strong) NSString						*strBookFileNameNextPageInCachesWithPath;
@property (nonatomic, strong) NSString                        *strNextScript;
@property (nonatomic, strong) IBOutlet UIImageView                    *imgViewQA_Question;
@property (nonatomic, strong) IBOutlet UIView                         *viewQA;
@property (nonatomic, strong)    IBOutlet UIView                         *viewQA_inside;
@property (nonatomic, strong) IBOutlet UITextView                     *txtViewQA_Question;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer1;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer2;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer3;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer4;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Close;
@property (nonatomic, strong) IBOutlet UIButton                       *btnOpenQuiz;
@property (nonatomic) NSInteger intAnswer;
@property (nonatomic) NSInteger intWrongAnswer;
@property (nonatomic, strong) NSMutableArray                          *arrWrongAnswers;
@property (nonatomic, strong) NSMutableArray                          *arrWrongAnswers_IOS5;    
@property (nonatomic) BOOL                                              blnAnswerd;
@property (nonatomic) BOOL                                    blnBtnAnswer1Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer2Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer3Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer4Clicked;    

@property (nonatomic) BOOL                                              blnOnQAMode;
@property (nonatomic) BOOL                                              blnOnQA_Vibration;
@property (nonatomic, strong) NSString                                *strQABeforeWord;

@property (nonatomic, strong)     NSString                        *strAllContentsInFile;
@property (nonatomic, strong)    NSMutableDictionary *dicAllWordsInBook;
@property (nonatomic)     BOOL                            blnFirstOpen;
@property (nonatomic)     BOOL                            blnPageChanged;
@property (nonatomic)     BOOL                            blnWebViewOneFront;
@property (nonatomic)     BOOL                            blnDoSTHToChangeFront;
@property (nonatomic)     BOOL                            blnNextPage;
@property (nonatomic)     BOOL                            blnPrevPage;
@property (nonatomic)    BOOL                            blnSelWord;
@property (nonatomic)    BOOL                           blnFirstOpenPage;
@property (nonatomic)    BOOL                            blnCancelReadTxt;
@property (nonatomic)    BOOL                               blnCancelCountingPage;
@property (nonatomic)    BOOL                            blnCountingPages;
@property (nonatomic)    BOOL                            blnCountingPagesCheckingHeight;
@property (nonatomic)        BOOL                            blnPressAdjust;
@property (nonatomic)    BOOL                            blnBookDayMode;
@property (nonatomic, strong)     UIAlertView                     *alertViewProgress;
@property (nonatomic)    BOOL                            blnShowQuizButton;
@property (nonatomic)        BOOL                            blnHasShowMeaningUserDefault;

//동영상관련
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) IBOutlet UIView           *viewMovie;
@property (nonatomic, strong) IBOutlet UIView                 *viewOneInMovie;
@property (nonatomic, strong) IBOutlet UIView                 *viewTwoInMovie;
@property (nonatomic, strong) IBOutlet UIButton               *btnMoviePlayOrStop;
@property (nonatomic, strong) IBOutlet UIButton               *btnResizeMovieView;
@property (nonatomic, strong) NSString                        *strMovieFileName;
@property (nonatomic, strong) NSString                        *strScriptFileName;
@property (nonatomic, strong) NSMutableDictionary             *dicScript;
@property (nonatomic, strong) NSMutableArray                    *arrScript;
@property (nonatomic, strong) NSMutableDictionary             *dicScript1;
@property (nonatomic, strong) NSMutableArray                    *arrScript1;

@property (nonatomic, strong) NSTimer                         *timerScript;
@property (nonatomic) NSTimeInterval                  _currentPalyBackTime;
@property (nonatomic)   NSInteger                       indexOfCurrentScript;
@property (nonatomic)   NSInteger                       playType;
@property (nonatomic)   NSInteger                       intRepeatStartPoint;
@property (nonatomic)   NSInteger                       intRepeatEndPoint;
@property (nonatomic)   NSInteger                       intMovieStartPoint;
@property (nonatomic)   NSInteger                       intMovieEndPoint;
@property (nonatomic, strong) IBOutlet UIButton               *btnRepeatStartPoint;
@property (nonatomic, strong) IBOutlet UIButton               *btnRepeatEndPoint;    
@property (nonatomic, strong) IBOutlet UIButton               *btnEndRepeat;
@property (nonatomic, strong) IBOutlet UIButton               *btnShowScript;
@property (nonatomic, strong) IBOutlet UIButton               *btnInfo;
@property (nonatomic, strong) IBOutlet UIButton               *btnMoviePlayRate;
@property (nonatomic, strong) IBOutlet UILabel               *lblStartTime;
@property (nonatomic, strong) IBOutlet UILabel               *lblEndTime;
@property (nonatomic, strong) IBOutlet UILabel                *lblMovieScript;
@property (nonatomic, strong) IBOutlet UIWebView              *webMovieScript;
@property (nonatomic, strong) IBOutlet UITextView             *txtViewMovieScript;
@property (nonatomic) BOOL                            blnRepeating;
@property (nonatomic) BOOL                            blnIsMoviePlaying;
@property (nonatomic) BOOL                                  blnMovieSwipe;
@property (nonatomic) BOOL                                  blnResizeMovieBig;
@property (nonatomic) BOOL                                  blnShowScript;
@property (nonatomic) NSInteger                       intHideWordInScript;

//단어 찾기기능
@property (nonatomic, strong) NSString                        *strWordSearch;
@property (nonatomic, strong) NSString                        *strWordOriSearch;
@property (nonatomic, strong) NSMutableArray                  *arrWordSearchFamily;
@property (nonatomic, strong) NSMutableDictionary             *dicWordSearchFamilyDetail;
@property (nonatomic) NSInteger                       intOriPage;
@property (nonatomic) NSInteger                       intSelTblRow;
@property (nonatomic) NSInteger                       intIndexOfWordInSamePage; //한페이지내에서 선택한 단어의 순서
@property (nonatomic) NSInteger                       intPageNoOfWordSearch; //선택한 단어가 있는 페이지
@property (nonatomic) NSInteger                       intAllSearchedWords;
@property (nonatomic) BOOL                            blnCaseSensitive;
@property (nonatomic) BOOL                            blnHeadword;
@property (nonatomic) BOOL                            blnWordSearchMode;
@property (nonatomic, strong) UITableViewCell                 *customCell;
@property (nonatomic, strong) IBOutlet UIView                          *viewWordSearchBackAndForward;
@property (nonatomic, strong) IBOutlet UILabel                         *lblWordPage;
@property (nonatomic, strong) IBOutlet UIButton                        *btnWordSearchBack;
@property (nonatomic, strong) IBOutlet UIButton                        *btnWordSearchForward;
@property (nonatomic, strong) IBOutlet UIButton                        *btnBackToPreviousPage;
@property (nonatomic, strong) IBOutlet UIButton                        *btnCloseViewWordSearch;
@property (nonatomic, strong) IBOutlet UIButton                        *btnReopenWordSearch;
@property (nonatomic, strong) IBOutlet UIButton                        *btnCloseViewWordSearchBackAndForward;
@property (nonatomic)     NSInteger                       intTableViewMode;
@property (nonatomic)     NSInteger                       _intKnowChanged;
- (void) aboutBook:(NSTimer *)sender;
- (void) back;
- (void) callBack:(NSTimer*)sender;
- (void) callOnOpenWordDetail;
- (void) callReadTxt:(NSString*) strType;
- (void) callThreadShowMeaning;

- (void) changeFontSize:(NSTimer *)sender;
- (void) changeWebStudy;
- (void) changeBookStudy;

- (BOOL) createBookSettingInTableIfNotExist;
- (void) GoOnePage:(NSNumber*)nsPageNo;
- (void) LoadCurrPage:(BOOL)blnLoadForDup;
- (void) LoadPrevPage;
- (void) LoadNextPage;
- (NSString*) getBookDifficulty1:(NSNumber*)param;

- (NSString*) HTMLFromWithKnowTag:(NSString*)strWordOrIdiom strWordOriToFind:(NSString*) strWordOriToFind;

-(void)Know1:(id)sender;
-(void)Know2:(id)sender;
-(void)Know3:(id)sender;
-(void)Know99:(id)sender;
- (void) onOpenPreviewOrReview;
#pragma mark -
#pragma mark UIWebViewDelegate methods   
- (void) gotoAddress:(id)sender;
- (void) goBack;
- (void) goForward;
- (void) reload;
- (void) stopWebLoading;

- (NSMutableString*)HTMLFromTextString:(NSMutableString *)originalText; 

- (void) onOpenWebDic:(id)sender;
- (IBAction)onOpenWordDetail:(NSTimer *)sender;
- (IBAction) onBarLinkOff;
- (void) openDicList:(NSTimer *)sender;
- (void) openDicListForBookTemp:(NSString*)param;
//- (void) readDicTable;
//- (void) readTxt:(NSObject*)obj;
//- (void) readTxtNew:(NSObject*)obj;
- (void) UpdateAnalyze:(NSObject*)obj;
- (void) previewReviewWords:(NSObject*)obj;

//- (void) readTxt;
- (BOOL) saveBookSetting;
- (void)selSegControl:(id)sender;
- (IBAction) slideBackLightValueChanging : (id) sender;
- (IBAction) slideBackLightValueChanged : (id) sender;

- (BOOL) isNumber:(NSString*)strInput;
- (void) openExam:(NSString*)param;
- (void) openTTS:(NSString*)param;

//페이지 이동에 관한 함수
- (IBAction) pageNoChanged : (id) sender;
- (IBAction) pageNoChanging : (id) sender;

- (void) smartWordList:(id)sender;
- (BOOL) makeNewBook;
- (void) updateProgress:(NSNumber*) param;
- (void) updateProgressTitle:(NSString*) param;
//- (void) insertWordOrderTbl:(NSMutableDictionary*) param;
- (void) selWordInWebView;
- (void) showMeaningSelTxt:(BOOL)FromWillAppear;
- (void) showViewTypeBook;
- (void) showViewTypeWeb;

- (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText webViewIndex:(NSInteger)webViewIndex writeHTML:(BOOL)blnWriteHTML;
//- (NSString*)HTMLFromHTML:(NSMutableString *)originalText webViewIndex:(NSInteger)webViewIndex writeHTML:(BOOL)blnWriteHTML;
- (NSString *)GetBodyTextFromHTML:(NSString *)html;
- (NSString *)GetBodyHTMLFromHTML:(NSString *)html;

- (void) callGetAllPagesInfo;
- (void) getAllPagesInfo:(NSObject*)obj;
- (void) getAllPagesInfoEPub:(NSObject*)obj;
- (void) savePageInfo:(NSMutableArray*)arrTemp;
- (NSMutableString*) HTMLMeaningOnePage:(NSInteger)webViewIndex;
- (void) updateGetAllPageInfo:(NSString*) param;

- (IBAction) onBarBtnItemCancelPicker;
- (IBAction) openViewQA:(id)sender;
- (IBAction) closeViewQA;
- (IBAction) onBtnQA_Answer1;
- (IBAction) onBtnQA_Answer2;
- (IBAction) onBtnQA_Answer3;
- (IBAction) onBtnQA_Answer4;
- (void) btnQACommonBtnColor;
- (void) btnQACommon;
- (void) onBtnQA_Vibration;

//단어찾기 기능
- (void) openSearchView:(NSString*)strWordToSearch;
- (void) callOpenSearchView:(id)sender;
- (void) searchText:(NSTimer*)sender;
- (void) cancelTblViewWordSearch;
- (void) closeTblViewWordSearch;
- (IBAction) onBtnWordSearchBack:(id)sender;
- (IBAction) onBtnWordSearchForward:(id)sender;
- (IBAction) onBtnWordSearchReopen:(id)sender;
- (IBAction) onBtnWordSearchBackToPreviousPage:(id)sender;
- (IBAction) onBtnWordSearchCloseViewWordSearch:(id)sender;

//동영상 모드
- (IBAction) onBtnMoviePlay : (id) sender;
- (IBAction) onBtnMovieRate:(id)sender;
- (void) moviePlayBackWillEnterFullscreen:(NSNotification*)notif;
- (void) moviePlayBackWillExitFullscreen:(NSNotification*)notif;
- (void) moviePlayBackDidFinish:(NSNotification*)notification;
- (IBAction) onBtnMovieRepeatStartPoint : (id) sender;
- (IBAction) onBtnMovieRepeatEndPoint : (id) sender;
- (IBAction) onBtnMovieRepeatStop : (id) sender;
- (IBAction) onResizeMovieView:(id)sender;
- (IBAction) onBtnShowScrip:(id)sender;
- (void) getScript;
- (void) showNextScript:(NSString*)strSubTitle;
- (NSInteger)positionFromPlaybackTime:(NSTimeInterval)playbackTime;

- (void) openSNS;
- (void) openMessage;
- (void) openMail;

#pragma mark -
#pragma mark 트위터 관련기능
- (void) openTwitter;

@property (nonatomic, strong) NSString* ePubDirName;
@property (nonatomic, strong) NSString* ePubDirPath;

@property (nonatomic, strong)XMLHandler *_xmlHandler;
@property (nonatomic, strong)EpubContent *_ePubContent;
@property (nonatomic, strong)NSString *_pagesPath;
@property (nonatomic, strong)NSString *_rootPath;
@property (nonatomic, strong)NSString *_strFileName;
@property (nonatomic, strong) NSMutableArray *_arrEPubChapter;
@property (nonatomic) NSInteger _pageNumber;

//- (void)unzipAndSaveFile;
- (void)loadPage;
- (NSString*)getRootFilePath;

@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic, retain) NSMutableArray *htmlPages;


//Analyze관련
- (void) analyzeTxtEnglish:(NSObject*)obj;
- (void) analyzeTxtChinese:(NSObject*)obj;
@end


