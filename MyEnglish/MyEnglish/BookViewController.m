//
//  MoviePlayerController.m
//  MyListPro
//
//  Created by 김형달 on 10. 9. 28..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import "BookViewController.h"
#import "DicListController.h"
#import "ExamViewController.h"
#import "MoviePlayerSettingController.h"
#import "myCommon.h"
#import "WebDicController.h"
#import "WebURL.h"
#import "WordDetail.h"
#import "FlashCardController.h"
#import "WordSearchCell.h"
#import "DicListCellMark.h"
#import "MakeABook.h"
#import "HCYoutubeParser.h"
#import "TTSWordViewController.h"
#import "UIMenuItem+CXAImageSupport.h"

#import "ZipArchive.h"

#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigesterSetNextRule.h"
#import "XMLDigesterCallMethodWithAttributeRule.h"
#import "OCFContainer.h"
#import "OCFRootFile.h"
#import "NCXNavigationDefinition.h"
#import "NCXNavigationPoint.h"

#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"

#define charInPage (320/10 * 13)
#define sentenceMax 512

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

dispatch_queue_t queue;

@implementation BookViewController

@synthesize _ePubContent;
@synthesize _rootPath;
@synthesize _strFileName;
@synthesize _xmlHandler;
@synthesize _pagesPath, _arrEPubChapter;
@synthesize _pageNumber;


@synthesize     viewAnalyzeMain, viewAnalyzeSmall, progressAnalyze, lblAnalyze, btnCancelAnalyze;
@synthesize ePubDirName, ePubDirPath;

@synthesize intMovieStartPoint, intMovieEndPoint, alertViewProgress, fm;

@synthesize  blnWebViewOneFront, blnDoSTHToChangeFront, strBookFullFileName, strBookFileNameInCachesWithPath, initialScrollPosition, fontSize;
@synthesize tabBarViewModeBook, tabBarViewModeWeb, tabBarFont, dicAllWordsAllAttribute, dicWordChangeAndOri;
@synthesize dicSetting, _strMutableCopyWordOri, _strMutableCopyWord, maxPageNo;
@synthesize viewDic, viewPageNo, txtMeaning, lblKnow, lblCount, btnTabBar, slideBackLight, slidePageNo;
@synthesize intBookTblNo,  viewBackLight, intUserLevel, strWebViewMode;
@synthesize intStatusBarHeightPlus, intViewHeight, blnWebStudy;
@synthesize naviBarWebUrl, searchBarWebUrl, webViewWeb, intViewType, _strMutableURL;
@synthesize blnOpenBookmark;
@synthesize	txtBookName, lblPageNoPercent, barLinkOff, blnLinkOff;
@synthesize actionSheetProgress, progressViewInActionSheet, strLatestBook, strBookSqliteName;
@synthesize pageOfBookLines, arrPageInfo, currPageNo, currPageNoToGo, blnShowUnknowWords, strBookFileNameCurrPageInCachesWithPath, strAllContentsInFile, dicAllWordsInBook, blnFirstOpen, blnPageChanged;
@synthesize arrWebView;
@synthesize strBookFileNameCurrDupPageInCachesWithPath, strBookFileNamePrevPageInCachesWithPath, strBookFileNameNextPageInCachesWithPath;
@synthesize blnNextPage, blnPrevPage, overlayView, blnSelWord, blnFirstOpenPage, blnCancelReadTxt, blnCountingPages, blnCountingPagesCheckingHeight;
@synthesize viewCurPage, lblCurPage, lblShowMeaning, intCSSVersion;
@synthesize viewSearchWord, searchBarSearchWord, tblSearchWord, arrSearchWord, blnPressAdjust, blnCancelCountingPage;
@synthesize pickerNextPrevPages, viewPickerNextPrevPages, barBtnItemSelectPickerNextPrevPages, barBtnItemCacnelPickerNextPrevPages, arrNextPages, arrExamPages, PickerViewType;
@synthesize strNextPrevPages, blnBookDayMode;
@synthesize imgViewQA_Question, viewQA, viewQA_inside, txtViewQA_Question, btnQA_Answer1, btnQA_Answer2,btnQA_Answer3,btnQA_Answer4, btnQA_Close, intAnswer, intWrongAnswer, btnOpenQuiz, arrWrongAnswers, arrWrongAnswers_IOS5, blnAnswerd, blnOnQAMode, blnOnQA_Vibration, strQABeforeWord, blnBtnAnswer1Clicked, blnBtnAnswer2Clicked, blnBtnAnswer3Clicked, blnBtnAnswer4Clicked;
@synthesize blnShowQuizButton, blnFirstViewQA_IOS5, blnHasShowMeaningUserDefault;
@synthesize moviePlayer, viewMovie, btnMoviePlayOrStop, strMovieFileName, playType, btnRepeatStartPoint, btnRepeatEndPoint, btnEndRepeat, blnRepeating, intRepeatStartPoint, intRepeatEndPoint, blnMovieSwipe, blnResizeMovieBig, btnResizeMovieView, viewOneInMovie, viewTwoInMovie, lblStartTime, lblEndTime, btnInfo, btnMoviePlayRate, lblMovieScript, btnShowScript, blnShowScript, intHideWordInScript, webMovieScript, txtViewMovieScript, strScriptFileName, dicScript, arrScript,dicScript1, arrScript1, _currentPalyBackTime, indexOfCurrentScript, blnIsMoviePlaying, timerScript;

@synthesize strWordSearch, strWordOriSearch, blnCaseSensitive, blnHeadword, blnWordSearchMode, viewWordSearchBackAndForward, btnWordSearchBack, btnWordSearchForward, btnBackToPreviousPage, btnCloseViewWordSearch, btnReopenWordSearch, btnCloseViewWordSearchBackAndForward, intOriPage, intSelTblRow, lblWordPage, intIndexOfWordInSamePage, intPageNoOfWordSearch, intAllSearchedWords, arrWordSearchFamily, dicWordSearchFamilyDetail;
@synthesize customCell;
@synthesize tabBarViewModeBookItemPrepare, tabBarViewModeBookItemDicInfo, tabBarViewModeBookItemAdjust, tabBarViewModeBookItemSetting;
@synthesize tabBarFontSmaller, tabBarFontBigger;    
@synthesize tabBarViewModeWebItemBack, tabBarViewModeWebItemRefreshStop, tabBarViewModeWebItemForward, tabBarViewModeWebItemFavorites, tabBarViewModeWebItemBook;   
@synthesize strNextScript, strBookFileNameExtension;
@synthesize intTableViewMode;
@synthesize lastScrollY;
@synthesize _intKnowChanged;
@synthesize pageViewController;
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

-(void)createHtmlPages{

    [self.htmlPages removeAllObjects];
    if (!self.htmlPages) {
        
        self.htmlPages = [[NSMutableArray alloc] init];
    }

    if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
        
        float total     = [arrPageInfo count];
        __block float totalProgress   = 0.0;
        __block float progressTick    = 1.0 / total;
        
        [arrPageInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
            NSDictionary *dicOne = (NSDictionary*)obj;
            NSInteger offsetStart = [[dicOne objectForKey:@"OffsetStart"] integerValue];
            NSInteger offsetEnd = [[dicOne objectForKey:@"OffsetEnd"] integerValue];
            
            NSInteger offsetAll = offsetEnd - offsetStart;
            NSString *strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
            NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:idx writeHTML:TRUE];
            
            [self.htmlPages addObject:strContentForOnePageHTML];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                totalProgress += progressTick;
                [SVProgressHUD showProgress:totalProgress status: @"Loading"];
                if (idx == [arrPageInfo count]-1) [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:0.4f];
            });
        }];
        
    }else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        
        float total     = [arrPageInfo count];
        __block float totalProgress   = 0.0;
        __block float progressTick    = 1.0 / total;
        
        [arrScript enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSDictionary *dicOne = (NSDictionary*)obj;
            
            NSString *strContentForOnePage = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];
            if (currPageNo < [arrScript1 count]) {
        
                NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
                NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
                
                if (dicScript1OneScript != NULL) {
                    strContentForOnePage = [NSString stringWithFormat:@"%@\n\n%@",strContentForOnePage, [[arrScript1 objectAtIndex:currPageNo] objectForKey:SMI_DIC_KEY_SCRIPT]];
                }
            }
            
            NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:idx writeHTML:TRUE];
            
            [self.htmlPages addObject:strContentForOnePageHTML];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                totalProgress += progressTick;
                [SVProgressHUD showProgress:totalProgress status: @"Loading"];
                if (idx == [arrScript1 count]-1) [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:0.4f];
            });
        }];
    }
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.htmlPages count] == 0) || (index >= [self.htmlPages count])) {
        return nil;
    }
    ContentViewController *dataViewController = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    
    NSString *contentHTML = [self.htmlPages objectAtIndex:index];
    if (blnShowUnknowWords) {
        NSMutableString *strContentForOnePageHTMLMeaning = [self scanForMeaningWords:[NSMutableString stringWithString:contentHTML]];
        dataViewController.dataObject = strContentForOnePageHTMLMeaning;
    } else {
        dataViewController.dataObject = contentHTML;
    }
    dataViewController.displayingPage = index;
    dataViewController.parentVC = self;
    
    return dataViewController;
}

-(void)setUpPageViewController{

    if (![self.htmlPages count]) {
        [SVProgressHUD showErrorWithStatus:@"No Page Found, Please try again"];
        return;
    }
    
    if (! self.pageViewController) {
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
    }
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    ContentViewController *contentViewController = [self viewControllerAtIndex:currPageNo];
    
    NSArray *viewControllers = [NSArray arrayWithObject:contentViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];

    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGRect pageViewRect = self.view.bounds;
//    pageViewRect = CGRectInset(pageViewRect, 0.0, 44.0);
    pageViewRect.size.height -= tabBarViewModeBook.frame.size.height + viewCurPage.frame.size.height;
    self.pageViewController.view.frame = pageViewRect;
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    [self.view bringSubviewToFront:tabBarViewModeBook];
    [self.view bringSubviewToFront:self.viewCurPage];
    
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        
        if ([gR isMemberOfClass:[UITapGestureRecognizer class]]) {
            gR.delegate = self;
        }
    }
    
//    [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.05f];
}

-(void) flipToPage:(int)index {
    
//    if (currPageNo == index) return;
    self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", index+1, (NSInteger) slidePageNo.maximumValue];
    currPageNo = index;
    
    ContentViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    
    NSUInteger retreivedIndex = [(ContentViewController *)theCurrentViewController displayingPage];;
    
    ContentViewController *firstViewController = [self viewControllerAtIndex:index];
    ContentViewController *secondViewController = [self viewControllerAtIndex:index+1 ];
    
    NSArray *viewControllers = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        viewControllers = [NSArray arrayWithObjects:firstViewController, secondViewController, nil];
    }else{
        viewControllers = [NSArray arrayWithObjects:firstViewController, nil];
    }
    
    if (retreivedIndex < index){
        
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
    } else {
        
        if (retreivedIndex > index ){
            
            [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
        }
    }
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [(ContentViewController *)viewController displayingPage];
    
    UIPanGestureRecognizer *recognizer = [self.pageViewController.gestureRecognizers objectAtIndex:0];
    CGPoint translation = [recognizer translationInView:viewController.view];
    if (fabs(translation.y) > fabs(translation.x)) return nil;
   
    if(currentIndex == 0)
    {
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"First Page", @"")];
        return nil;
    }
    
    self.shouldDenyPageTurn = YES;
    ContentViewController *contentViewController = [self viewControllerAtIndex:currentIndex-1];
    indexToCompare = contentViewController.displayingPage;
    
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [(ContentViewController *)viewController displayingPage];
    
    UIPanGestureRecognizer *recognizer = [self.pageViewController.gestureRecognizers objectAtIndex:0];
    CGPoint translation = [recognizer translationInView:viewController.view];
    if (fabs(translation.y) > fabs(translation.x)) return nil;
    
    if(currentIndex == self.htmlPages.count-1)
    {
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"Last Page", @"")];
        return nil;
    }
    
    self.shouldDenyPageTurn = YES;
    ContentViewController *contentViewController = [self viewControllerAtIndex:currentIndex+1];
    indexToCompare = contentViewController.displayingPage;
    
    return contentViewController;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
//    if(UIInterfaceOrientationIsPortrait(orientation))
//    {
        //Set the array with only 1 view controller
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        //Important- Set the doubleSided property to NO.
        self.pageViewController.doubleSided = NO;
        //Return the spine location
        return UIPageViewControllerSpineLocationMin;
//    }
//    else {
//       
//        return (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
//        
//        NSArray *viewControllers = nil;
//        ContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
//        
//        NSUInteger currentIndex = [self.htmlPages indexOfObject:[(ContentViewController *)currentViewController dataObject]];
//        if(currentIndex == 0 || currentIndex %2 == 0)
//        {
//            UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
//            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
//        }
//        else
//        {
//            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
//            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
//        }
//        //Now, set the viewControllers property of UIPageViewController
//        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//        
//        return UIPageViewControllerSpineLocationMid;
//    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{

    if (completed) {

        self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", indexToCompare+1, (NSInteger) slidePageNo.maximumValue];
        currPageNo = indexToCompare;
        self.shouldDenyPageTurn = NO;
        
    }else{
        
        return;
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([super respondsToSelector:aSelector])
        return YES;
    else if ([self.pageViewController respondsToSelector:aSelector])
        return YES;
    else
        return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return nil;
    } else if ([self.pageViewController respondsToSelector:aSelector]) {
        return self.pageViewController;
    }
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (([touch.view isKindOfClass:[UIControl class]]) || ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]])) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return ! self.shouldDenyPageTurn; // handle the touch
}

-(void)dismissProgress{

    [SVProgressHUD dismiss];
    [self setUpPageViewController];

    firstContentViewController.displayingPage = currPageNo+1;
    for(UIView *view in self.pageViewController.view.subviews)
    {
        if (view.class == [ContentViewController class]) {
            [(ContentViewController*)view setDisplayingPage:currPageNo+1];
        }
    }
}

-(void)reloadCurrentPage{

    ContentViewController *dataViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    dataViewController.lastScrollY = [[dataViewController.webView stringByEvaluatingJavaScriptFromString:@"scrollY"] floatValue];
    
    NSString *contentHeight = [dataViewController.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    dataViewController.lastContentHeight = [contentHeight floatValue];
    
    NSString *contentHTML = [self.htmlPages objectAtIndex:currPageNo];
    [dataViewController.webView stopLoading];
    if (blnShowUnknowWords) {
        NSMutableString *strContentForOnePageHTMLMeaning = [self scanForMeaningWords:[NSMutableString stringWithString:contentHTML]];
        
        [dataViewController.webView loadHTMLString:strContentForOnePageHTMLMeaning baseURL:[NSURL URLWithString:@""]];
    } else {
        
        [dataViewController.webView loadHTMLString:contentHTML baseURL:[NSURL URLWithString:@""]];
    }
    [SVProgressHUD dismiss];
}

-(void)willShowMenuController:(NSNotification *)notif{
    
    self.shouldDenyPageTurn = YES;
}

-(void)didHideMenuController:(NSNotification *)notif{
    
    //    self.shouldDenyPageTurn = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    queue = dispatch_queue_create("droidBD_queue", nil);
    
    [myCommon closeDB:true];
    [myCommon openDB:true];
    
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;

    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 120, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"StudyMode", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Word", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive:) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowMenuController:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideMenuController:) name:UIMenuControllerDidHideMenuNotification object:nil];

    txtBookName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
    txtBookName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtBookName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view sendSubviewToBack:viewQA];
    self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);
    self.viewWordSearchBackAndForward.hidden = TRUE;
    [self.view addSubview:viewWordSearchBackAndForward];
    
    fm = [NSFileManager defaultManager]; 
    scrollFeedbackFromOtherControl = YES;
	
    blnShowQuizButton = TRUE;
    blnOnQA_Vibration = TRUE;
	blnOpenBookmark = TRUE;
//    blnShowMeaning = TRUE;
	blnFirstOpen = TRUE;
    blnPageChanged = TRUE;
    blnWebViewOneFront = TRUE;
    blnDoSTHToChangeFront = FALSE;
    blnNextPage = FALSE;
    blnPrevPage = FALSE;
    blnSelWord = FALSE;
    blnFirstOpenPage = TRUE;
    blnCountingPages = FALSE;
    blnCountingPagesCheckingHeight = FALSE;
    blnPressAdjust = FALSE;
    blnCancelCountingPage = FALSE;
    blnBookDayMode = TRUE;
    blnOnQAMode = FALSE;
    blnAnswerd = FALSE;
    blnFirstViewQA_IOS5 = FALSE;
    blnResizeMovieBig = TRUE;
    blnCaseSensitive = FALSE;
    blnHeadword = FALSE;
    blnWordSearchMode = FALSE;
    
    self.viewPickerNextPrevPages.hidden = YES;

    self.strQABeforeWord = @"";
	self.lblKnow.text = @"";
	self.lblCount.text = @"";
	self.txtMeaning.text = @"";
    self.lblShowMeaning.text = @"";
    self.lblShowMeaning.textColor = [UIColor blackColor];

    self.viewQA_inside.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"FlashCard_Back_6.jpg"]];
    
    arrWrongAnswers = [[NSMutableArray alloc] init];
    arrWrongAnswers_IOS5 = [[NSMutableArray alloc] init];
	_strMutableCopyWord = [[NSMutableString alloc] initWithString:@""];
    _strMutableCopyWordOri = [[NSMutableString alloc] initWithString:@""];
    dicAllWordsInBook = [[NSMutableDictionary alloc] init];
    arrSearchWord = [[NSMutableArray  alloc] init];
    arrNextPages = [[NSMutableArray alloc] init];
    arrExamPages = [[NSMutableArray alloc] init];
    _arrEPubChapter = [[NSMutableArray alloc] init];
    
    lastScrollY = 0.0f;
    NSInteger i = 16;
    while (i > -15) {
            i--;        
        if (i == 0) {
            continue;
        }
        [arrNextPages addObject:[NSNumber numberWithInt:i]];
    }
    
    [arrExamPages addObject:[NSNumber numberWithInt:20]];
    [arrExamPages addObject:[NSNumber numberWithInt:15]];
    [arrExamPages addObject:[NSNumber numberWithInt:10]];
    [arrExamPages addObject:[NSNumber numberWithInt:5]];
    [arrExamPages addObject:[NSNumber numberWithInt:0]];
    [arrExamPages addObject:[NSNumber numberWithInt:-5]];
    [arrExamPages addObject:[NSNumber numberWithInt:-10]];
    [arrExamPages addObject:[NSNumber numberWithInt:-15]];
    [arrExamPages addObject:[NSNumber numberWithInt:-20]];

    self.strNextPrevPages = @"1";//[NSString stringWithFormat:@"%@", [arrNextPages objectAtIndex:0]];
//    DLog(@"arrNextPages : %@", arrNextPages);
	intUserLevel = 4; //UserLevel을 안정했을때를 대비해서...
    intCSSVersion = 0;
	self.slideBackLight.minimumValue = 0;
	self.slideBackLight.maximumValue = 1;
	self.slidePageNo.minimumValue = 1;
	self.slidePageNo.maximumValue = 100000000;

    intAllSearchedWords = 0;
    intIndexOfWordInSamePage = 0;
    intPageNoOfWordSearch = 0;
    
    intAnswer = 1;
    intWrongAnswer = -1;
//    self.webViewOne.tag = 1;
//	self.webViewOne.hidden = TRUE;	
	self.tabBarViewModeBook.hidden = TRUE;	
	self.tabBarFont.hidden = TRUE;
	self.viewBackLight.hidden = TRUE;
	self.viewPageNo.hidden = TRUE;	
	self.viewDic.hidden = TRUE;
    self.viewCurPage.hidden = TRUE;
    self.btnResizeMovieView.hidden = TRUE;
    
    
	self.webViewWeb.tag = 2;
	self.webViewWeb.hidden = TRUE;
	self.tabBarViewModeWeb.hidden = TRUE;
    
    barBtnItemCacnelPickerNextPrevPages.title = NSLocalizedString(@"Cancel", @"");
    barBtnItemSelectPickerNextPrevPages.title = NSLocalizedString(@"Open", @"");
//    self.viewWordSearchBackAndForward.hidden = TRUE;
    tabBarViewModeBookItemPrepare.title = NSLocalizedString(@"Prepare", @"");
    tabBarViewModeBookItemDicInfo.title = NSLocalizedString(@"Dic&Info", @"");
    tabBarViewModeBookItemAdjust.title = NSLocalizedString(@"Adjust", @"");
    tabBarViewModeBookItemSetting.title = NSLocalizedString(@"Setting", @"");
    
    tabBarFontSmaller.title = NSLocalizedString(@"Smaller", @"");                          
    tabBarFontBigger.title = NSLocalizedString(@"Bigger", @"");   
    tabBarViewModeWebItemBack.title = NSLocalizedString(@"Back", @"");
    tabBarViewModeWebItemRefreshStop.title = NSLocalizedString(@"RefreshStop", @"");
    tabBarViewModeWebItemForward.title   = NSLocalizedString(@"Forward", @"");
    tabBarViewModeWebItemFavorites.title = NSLocalizedString(@"Favorites", @"");
    tabBarViewModeWebItemBook.title = NSLocalizedString(@"Make a Book", @"");
    
//    btnOpenQuiz.titleLabel.text = NSLocalizedString(@"Setting", @"");
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];  
    //맨처음앱을 시작했을때는 blnShowMeaning을 True로 하기위해서. 
    blnHasShowMeaningUserDefault = [defs boolForKey:@"HasShowMeaningUserDefault"];
    if (blnHasShowMeaningUserDefault == TRUE) {
        blnShowUnknowWords = [defs boolForKey:KEY_DIC_ShowMeaning];
    } else {
        blnShowUnknowWords = TRUE;
        [defs setBool:TRUE forKey:KEY_DIC_ShowMeaning];
        [defs setBool:TRUE forKey:@"HasShowMeaningUserDefault"];
    }

    fontSize = [defs integerForKey:KEY_DIC_FontSize];
    if (fontSize < Font_Size_MIN) {
        fontSize = Font_Size_NORMAL;
    } else if (fontSize > Font_Size_MAX) {
        fontSize = Font_Size_NORMAL;
    }

    
    UIWebView *webViewEBook1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIWebView *webViewEBook2 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIWebView *webViewEBookOne  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIWebView *webViewEBookOneDup = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    arrWebView  = [[NSMutableArray alloc] init];
    [arrWebView addObject:webViewEBook1];
    [arrWebView addObject:webViewEBookOne];    
    [arrWebView addObject:webViewEBook2];
    [arrWebView addObject:webViewEBookOneDup];
    
//    [self setUpPageViewController];
    
	dicAllWordsAllAttribute = [[NSMutableDictionary alloc] init];
	dicSetting = [[NSMutableDictionary alloc] init];	
	arrPageInfo = [[NSMutableArray alloc] init];
    arrWordSearchFamily = [[NSMutableArray alloc] init];
    dicWordSearchFamilyDetail = [[NSMutableDictionary alloc] init];
    dicScript = [[NSMutableDictionary alloc] init];
    arrScript = [[NSMutableArray alloc] init];
    dicScript1 = [[NSMutableDictionary alloc] init];
    arrScript1 = [[NSMutableArray alloc] init];
    timerScript = [[NSTimer alloc] init];
	currPageNo = 0;
    currPageNoToGo = 0;
    
    intTableViewMode = INT_TABLEVIEW_MODE_SEARCH;

    if (playType == PlayTypeMovie) {
        btnResizeMovieView.hidden = FALSE;
        blnRepeating = FALSE;
        blnMovieSwipe = FALSE;
        intRepeatStartPoint = 0;
        intRepeatEndPoint = 0;
        intMovieStartPoint = 0;
        intMovieEndPoint = 0;
        self.strNextScript = @""; 
        [self.view bringSubviewToFront:viewMovie];

        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",[myCommon getDocPath], strMovieFileName];
       
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        [self getScript];

        moviePlayer = [[MPMoviePlayerController alloc] init];// initWithContentURL:url];
        
        [moviePlayer setContentURL:url];
        moviePlayer.scalingMode = MPMovieScalingModeFill;
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        moviePlayer.fullscreen = YES;
        moviePlayer.shouldAutoplay = FALSE;
        
        
        moviePlayer.initialPlaybackTime = 0.0;
        
        [moviePlayer.view setFrame: CGRectMake(0 , 190, self.view.frame.size.width, self.viewMovie.frame.size.height)]; 
        [self.view addSubview:moviePlayer.view];        
        self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
        
        btnMoviePlayOrStop.hidden = TRUE;
        btnRepeatStartPoint.hidden = TRUE;
        btnRepeatEndPoint.hidden = TRUE;
        btnEndRepeat.hidden = TRUE;
        btnShowScript.hidden = TRUE;
        blnShowScript = TRUE;
        viewTwoInMovie.hidden = TRUE;
        intHideWordInScript = SMI_HIDE_WORD_KNOWN;

        //==============================================
        //웹뷰를 세로로 움직이지 않게 고정시킨다.
        for (id subview in webMovieScript.subviews) {
        
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            
                ((UIScrollView *)subview).bounces = NO;
                ((UIScrollView *)subview).showsVerticalScrollIndicator = NO;                
                ((UIScrollView *)subview).showsHorizontalScrollIndicator = NO;                                
            }
        }        

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayBackDidFinish:) 
                                                     name:MPMoviePlayerPlaybackDidFinishNotification 
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayBackWillEnterFullscreen:) 
                                                     name:MPMoviePlayerWillEnterFullscreenNotification
                                                   object:nil];        

        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayBackWillExitFullscreen:) 
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];               
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayBackStateDidChanged:) 
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                                   object:nil];        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(movieNowPlayingMovieDidChange:) 
                                                     name:MPMoviePlayerNowPlayingMovieDidChangeNotification 
                                                   object:nil];
        
        UISwipeGestureRecognizer *swipeRightMovie = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMovieAction:)];
        swipeRightMovie.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRightMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:swipeRightMovie];

        
        UISwipeGestureRecognizer *swipeRightInMovieScript = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMovieAction:)];
        swipeRightInMovieScript.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRightInMovieScript.delegate = self;
        [webMovieScript addGestureRecognizer:swipeRightInMovieScript];
        
        UISwipeGestureRecognizer *swipeLeftMovie = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMovieAction:)];
        swipeLeftMovie.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeftMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:swipeLeftMovie];
        
        UISwipeGestureRecognizer *swipeLeftInMovieScript = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMovieAction:)];
        swipeLeftInMovieScript.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeftInMovieScript.delegate = self;
        [webMovieScript addGestureRecognizer:swipeLeftInMovieScript];

        UISwipeGestureRecognizer *swipeUpMovie = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpMovieAction:)];
        swipeUpMovie.direction = UISwipeGestureRecognizerDirectionUp;
        swipeUpMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:swipeUpMovie];

        
        UISwipeGestureRecognizer *swipeUpInMovieScript = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpMovieAction:)];
        swipeUpInMovieScript.direction = UISwipeGestureRecognizerDirectionUp;
        swipeUpInMovieScript.delegate = self;
        [webMovieScript addGestureRecognizer:swipeUpInMovieScript];

        
        UISwipeGestureRecognizer *swipeDownMovie = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownMovieAction:)];
        swipeDownMovie.direction = UISwipeGestureRecognizerDirectionDown;
        swipeDownMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:swipeDownMovie];

        
        UISwipeGestureRecognizer *swipeDownInMovieScript = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownMovieAction:)];
        swipeDownInMovieScript.direction = UISwipeGestureRecognizerDirectionDown;
        swipeDownInMovieScript.delegate = self;
        [webMovieScript addGestureRecognizer:swipeDownInMovieScript];

        UITapGestureRecognizer *tapMovie = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMovieAction:)];
        tapMovie.numberOfTapsRequired = 1;
        tapMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:tapMovie];

        //지우지말것 tab을 두번할때
        UITapGestureRecognizer *tapMovie2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2MovieAction:)];
        tapMovie2.numberOfTapsRequired = 2;
        tapMovie2.delegate = self;
        [moviePlayer.view addGestureRecognizer:tapMovie2];   
        //tapMovie2가 실행될때 tapMovie는 안되게 하는것
        [tapMovie requireGestureRecognizerToFail: tapMovie2];

        UITapGestureRecognizer *twoTapMovie = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBtnShowScrip:)];
        twoTapMovie.numberOfTouchesRequired = 2;
        twoTapMovie.numberOfTapsRequired = 1;
        twoTapMovie.delegate = self;
        [moviePlayer.view addGestureRecognizer:twoTapMovie];        
        //twoTapMovie가 실행될때 tapMovie는 안되게 하는것
        [tapMovie requireGestureRecognizerToFail:twoTapMovie];
    }


	if (intViewType == viewTypeBook) {
        //북모드이면...
        self.viewCurPage.hidden = FALSE;
        
        DLog(@"strScriptFileName : %@", strBookFullFileName);
        NSString *strFileName = [strBookFullFileName lastPathComponent];
        DLog(@"strFileName : %@", strFileName);        
        intBookTblNo = [myCommon getOrCreateBoookTblNoFromTblBookSetting:strFileName];
        DLog(@"intBookTblNo : %d", intBookTblNo);
        
        NSString	*strFileNameInCaches = [NSString stringWithFormat:@"%@.htm", [strFileName stringByDeletingPathExtension]];
        self.strBookFileNameInCachesWithPath = [[myCommon getCachePath] stringByAppendingPathComponent:strFileNameInCaches];
        NSString	*strFileNameCurrPageInCaches = [NSString stringWithFormat:@"%@_CurrPage.htm", [strFileName stringByDeletingPathExtension]];
        NSString	*strFileNameCurrDupPageInCaches = [NSString stringWithFormat:@"%@_CurrDupPage.htm", [strFileName stringByDeletingPathExtension]];
        NSString	*strFileNamePrevPageInCaches = [NSString stringWithFormat:@"%@_PrevPage.htm", [strFileName stringByDeletingPathExtension]];
        NSString	*strFileNameNextPageInCaches = [NSString stringWithFormat:@"%@_NextPage.htm", [strFileName stringByDeletingPathExtension]];        
        self.strBookFileNameCurrPageInCachesWithPath = [[myCommon getCachePath] stringByAppendingPathComponent:strFileNameCurrPageInCaches]; 
        self.strBookFileNameCurrDupPageInCachesWithPath = [[myCommon getCachePath] stringByAppendingPathComponent:strFileNameCurrDupPageInCaches]; 
        self.strBookFileNamePrevPageInCachesWithPath = [[myCommon getCachePath] stringByAppendingPathComponent:strFileNamePrevPageInCaches]; 
        self.strBookFileNameNextPageInCachesWithPath = [[myCommon getCachePath] stringByAppendingPathComponent:strFileNameNextPageInCaches];         
        
        self.strBookSqliteName = [NSString stringWithFormat:@"%@/%@.sqlite", [myCommon getDocPath], [strFileName stringByDeletingPathExtension]];
        [myCommon setDBBookPath:strBookSqliteName];
        
        //책에 해당되는 SQLite가 없으면 Default를 복사해서 쓴다.
        [myCommon copyBookSQLiteFromDefault:strBookSqliteName];
        [myCommon openDB:false];
        
        self.strAllContentsInFile = [myCommon readTxtWithEncoding:strBookFullFileName];
        self.strBookFileNameExtension = [[strBookFullFileName pathExtension] uppercaseString];
        
		if ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES){						
            //책의 정보를 가져온다.
            [self createBookSettingInTableIfNotExist];            
            self.lblCurPage.text = @"";
            self.navigationItem.title = NSLocalizedString(@"Book Mode", @"");            
        } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
            
            //책의 정보를 가져온다.
            [self createBookSettingInTableIfNotExist];            
            
            blnFirstOpenPage = FALSE;   //이미 페이지가 있으면 다시 페이지를 안읽렬구...
            self.slidePageNo.maximumValue = [arrScript count];
            currPageNo = [[self.dicSetting objectForKey:@"LastPage"] integerValue];            
            if (currPageNo > [arrScript count]) {
                currPageNo = 0;
            }
            self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo + 1, [arrScript count]];

            if ((playType == PlayTypeMovie) && (currPageNo > 0)) {
                if (currPageNo < [arrScript count]) {
                    NSMutableDictionary *dicOne = [arrScript objectAtIndex:currPageNo];
                    
                    NSInteger timeScript = [[dicOne objectForKey:@"TIME"] integerValue];
                    double fTimeScript = (double)timeScript/1000;

                    DLog(@"fTimeScript : %f", fTimeScript);
                    
                    if (fTimeScript > 0.0f) {
                        moviePlayer.initialPlaybackTime = fTimeScript; 
                    }
                }
            }
            self.navigationItem.title = NSLocalizedString(@"Book Mode", @""); 
        } else if ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES){
            //epub파일일때
            [self createBookSettingInTableIfNotExist];            
            self.lblCurPage.text = @"";
            self.navigationItem.title = NSLocalizedString(@"Book Mode", @"");            
            
            //epub를 풀어놓은 폴더가 없으면 만든다.
            ePubDirPath = [NSString stringWithFormat: @"%@/%@", 
                                       [myCommon getCachePath], 
                                       [strFileName stringByDeletingPathExtension]];
            DLog(@"ePubDirPath : %@", ePubDirPath);
            
            
            NSString* ePubFilePath = [NSString stringWithFormat: @"%@/%@", 
                                      [myCommon getDocPath],  
                                      strFileName];
            DLog(@"===writeToFile : %@", ePubFilePath);
            self.ePubDirName = [strFileName stringByDeletingPathExtension];
         
            if ([fm fileExistsAtPath:ePubDirPath] == FALSE) {
                // Create a directory and then unzip it		
                [fm createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
                
                ZipArchive* za = [ZipArchive new];
                [za UnzipOpenFile: ePubFilePath];
                [za UnzipFileTo:ePubDirPath overWrite: YES];
                
                DLog(@"UnzipFileTo: %@", ePubDirPath);
                self.strAllContentsInFile = @"";
//                 [myCommon setIntBookFileSizeFromSQLFile:intBookTblNo intFileSize:[attrs fileSize]];
            } else {
                //이미 같은 이름의 폴더가 있으면 압축푼 폴더밑에 epub의 내용을 합쳐둔 txt가 있는지 살펴본다.
                NSString *strEPubTxtFullFileName = [NSString stringWithFormat:@"%@/%@/%@.%@", [myCommon getCachePath], self.ePubDirName,self.ePubDirName, fileExtension_TXT];
                DLog(@"strEPubTxtFullFileName : %@", strEPubTxtFullFileName);
                
                if ([fm fileExistsAtPath:strEPubTxtFullFileName] == FALSE) {
                    //압축푼 폴더밑에 epub의 내용을 합쳐둔 txt가 없으면 다른 EPUB로 보고  압축해제한 폴더를 지우고 다시 만든다.
                    [fm removeItemAtPath:ePubDirPath error:nil];
                    // Create a directory and then unzip it		
                    [fm createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
                    
                    ZipArchive* za = [ZipArchive new];
                    [za UnzipOpenFile: ePubFilePath];
                    [za UnzipFileTo:ePubDirPath overWrite: YES];
                    
                    DLog(@"UnzipFileTo: %@", ePubDirPath);
                    self.strAllContentsInFile = @"";
//                    [myCommon setIntBookFileSizeFromSQLFile:intBookTblNo intFileSize:[attrs fileSize]];
                } else {
                    //txt가 있으면... 내용을 읽는다.
                    self.strAllContentsInFile = [myCommon readTxtWithEncoding:strEPubTxtFullFileName]; 
                    self._arrEPubChapter = [myCommon getChapterInfoIntable];
                }

            }
            
            _xmlHandler=[[XMLHandler alloc] init];
            _xmlHandler.delegate = (id)self;
            [_xmlHandler parseXMLFileAt:[self getRootFilePath]];
            
            for (NSInteger i = 0; i < [_ePubContent._spine count]; i++) {
//                DLog(@"[_ePubContent._spine objectAtIndex:%d] : %@", i, [_ePubContent._spine objectAtIndex:i]);    
            }
        }
	} else{
        //웹모드이면...
        [myCommon setLatestBook:@""];
        [webViewWeb setOpaque:NO];
        blnWebStudy = TRUE;
        self.viewDic.hidden = FALSE;
        self.navigationItem.title = NSLocalizedString(@"Web Mode", @"");
        
		[segControl setTitle:NSLocalizedString(@"Web Mode", @"") forSegmentAtIndex:0];
    }

    
    //iPhone5이상에서는 Search뷰의 길이를 조정해준다.
    if (appHeight == heightiPhone5) {
        if ([myCommon getIOSVersion] >= IOSVersion_6_0) {
            
            viewSearchWord.frame = CGRectMake(viewSearchWord.frame.origin.x, viewSearchWord.frame.origin.y, viewSearchWord.frame.size.width, appHeight - naviBarHeight);
        }
    }

    self.strWebViewMode = @"NORMAL";
    
	UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(myPanGR:)];
	panGR.delegate = self;
	[[arrWebView objectAtIndex:currWebView] addGestureRecognizer:panGR];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    [[self.arrWebView objectAtIndex:prevWebView] addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap1.numberOfTapsRequired = 2;
    tap1.delegate = self;
    [[self.arrWebView objectAtIndex:currWebView] addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap2.numberOfTapsRequired = 2;
    tap2.delegate = self;
    [[self.arrWebView objectAtIndex:nextWebView] addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap3.numberOfTapsRequired = 2;
    tap3.delegate = self;
    [[self.arrWebView objectAtIndex:currWebViewDup] addGestureRecognizer:tap3];
    
	NSString *savedURL = [defs valueForKey:@"LastWebURL"];

	if (savedURL == NULL) {
        
		self._strMutableURL = [[NSMutableString alloc] initWithString:@"http://www.breakingnewsenglish.com/"];
#ifdef CHINESE
        
        self._strMutableURL = [[NSMutableString alloc] initWithString:@"http://www.peopledaily.com.cn/"];
#endif
        
	} else {
		self._strMutableURL = [[NSMutableString alloc] initWithFormat:@"%@", savedURL];
	}
    
	self.searchBarWebUrl.keyboardType = UIKeyboardTypeURL;
    
	blnLinkOff = FALSE;
    strLatestBook = @"";// [[NSString alloc] initWithString:@""];
    [self.view bringSubviewToFront:viewCurPage];
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
    
    blnDoSTHToChangeFront = TRUE;
	if (blnFirstOpen == FALSE) {
        blnPageChanged = FALSE;
    }
    
    //옵션은 sqlite에 저장되나 NSUserDefaults에 저장되나?
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];    
    blnShowUnknowWords = [defs boolForKey:@"ShowMeaning"];
    if (blnShowUnknowWords == TRUE) {
        self.lblShowMeaning.text = NSLocalizedString(@"Show unknown words", @"");
    } else {
        self.lblShowMeaning.text = @"";
    }
    [self.view bringSubviewToFront:btnOpenQuiz];
    btnOpenQuiz.hidden = TRUE;
    

    NSString *strOpt_ShowPhrasalVerb_Enable = [defs stringForKey:Defs_SHOW_PhrasalVerb];
    if ([strOpt_ShowPhrasalVerb_Enable isEqualToString:@"ON"]) {
        self.blnShowPhrasalVerb = TRUE;
    } else {
        self.blnShowPhrasalVerb = FALSE;
    }

    NSString *strOpt_QUIZ_Enable = [defs stringForKey:Defs_QUIZ_ENABLE];
    if ([strOpt_QUIZ_Enable isEqualToString:@"ON"]) {
        blnShowQuizButton = TRUE;
    } else {
        blnShowQuizButton = FALSE;
    }
    
    NSString *strOpt_QUIZ_Vibration = [defs stringForKey:Defs_QUIZ_VIBRATION];
    if ([strOpt_QUIZ_Vibration isEqualToString:@"ON"]) {
        blnOnQA_Vibration = TRUE;
    } else {
        blnOnQA_Vibration = FALSE;
    }

    
	if (blnLinkOff == TRUE) {
		self.barLinkOff.title = @"LinkOn";
	} else {
		self.barLinkOff.title = @"LinkOff";
	}
    
	if (intViewType == viewTypeBook) {
        [self createBookSettingInTableIfNotExist];
        
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSInteger BackLight = [defs integerForKey:@"BackLight"];
        if (BackLight < 30) {
            BackLight = 255;
        }
        UIColor *color = [UIColor colorWithRed:BackLight/255.0 green:BackLight/255.0 blue:BackLight/255.0 alpha:1];
        
        [[arrWebView objectAtIndex:prevWebView] setBackgroundColor:color];
        [[arrWebView objectAtIndex:currWebView] setBackgroundColor:color];
        [[arrWebView objectAtIndex:nextWebView] setBackgroundColor:color];
        [[arrWebView objectAtIndex:currWebViewDup] setBackgroundColor:color];
        
        [self.viewCurPage setBackgroundColor:color];    
        
		[self showViewTypeBook];

	} else if (intViewType == viewTypeWeb) {
		[self showViewTypeWeb];

	}

    if ((blnOnQAMode == TRUE) &&  ([arrWrongAnswers count] > 0) ){
        [self.view bringSubviewToFront:viewQA];

        for (NSInteger i = 0; i < [arrWrongAnswers count]; i++) {
            NSString *strWord = [[arrWrongAnswers objectAtIndex:i] objectForKey:@"Word"];            
            NSString    *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
            NSString    *strMeaning = [myCommon getMeaningFromTbl:strWordForSQL];
            
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strWord forKey:@"Word"];
            [dicOne setValue:strMeaning forKey:@"Meaning"];            
            [arrWrongAnswers replaceObjectAtIndex:i withObject:dicOne];
        }

        [self btnQACommon];
        blnBtnAnswer1Clicked = FALSE;
        blnBtnAnswer2Clicked = FALSE;
        blnBtnAnswer3Clicked = FALSE;
        blnBtnAnswer4Clicked = FALSE;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    overlayView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.7f;
    self.overlayView.hidden = true;
    [self.view.window addSubview:self.overlayView];
    UILabel *activityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    activityLabel.text = @"Loading...";
    [activityLabel sizeToFit];
    activityLabel.center = CGPointMake(self.overlayView.center.x, self.overlayView.center.y);
    [self.overlayView addSubview:activityLabel];
    
    UIButton *btnOne = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 50, 31)];
    [btnOne setTitle:@"Setting X?!" forState:UIControlStateNormal];
    btnOne.backgroundColor = [UIColor blueColor];
    btnOne.titleLabel.text = @"Change";
    
    [btnOne addTarget:self action:@selector(dismissOverlayView) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:btnOne];
                     
    if ( (blnFirstOpenPage == TRUE) && (intViewType == viewTypeBook) ) {
        DLog(@"strAllContentsInFile length : %d", [strAllContentsInFile length]);
        self.arrPageInfo = [myCommon getPageInfoIntable:[strAllContentsInFile length] intBookTblNo:intBookTblNo];
        NSInteger allPage = [myCommon getIntPageNoFromSQLFile:intBookTblNo];
        if (([arrPageInfo count] == 0) || ([arrPageInfo count] != allPage)) { 
            
            [self callGetAllPagesInfo];
            
        } else {
            self.slidePageNo.maximumValue = [arrPageInfo count];
            currPageNo = [[self.dicSetting objectForKey:@"LastPage"] integerValue];
            DLog(@"dicSetting : %@", dicSetting);
            
            if (currPageNo > [arrPageInfo count]) {
                currPageNo = 0;
            }

            intCSSVersion++;
            
                self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo + 1, (NSInteger) slidePageNo.maximumValue];
            [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
        }
        blnFirstOpenPage = FALSE;
    }
    
    if ((blnOnQAMode == TRUE) && ([arrWrongAnswers count] > 0)){
        [self.view bringSubviewToFront:viewQA];
    }
    
    [SVProgressHUD dismiss];
    if ([self.htmlPages count])    return;

    if ((intViewType == viewTypeBook) && [arrPageInfo count]) {
        
        [SVProgressHUD showProgress:0 status:@"Loading"];
        dispatch_async(queue, ^{
            [self createHtmlPages];
        });
    }
}

- (void) dismissOverlayView
{
    overlayView.hidden = TRUE;
}

- (void) showMeaningSelTxt:(BOOL)FromWillAppear
{
	if ((_strMutableCopyWord == NULL) || ([_strMutableCopyWord isEqualToString:@""] == TRUE)) {
		return;
	}
    
    txtMeaning.text = @"";
    lblKnow.text = @"";
    lblCount.text = @"";
    
	//단어로 부터 뜻을 가져온다... (웹이나 analyze를 안했을경우때문에 TBL_EngDic에서 가져온다.)	
	NSMutableString		*strMeaning = [NSMutableString stringWithFormat:@""];
	NSMutableString		*strKnow = [NSMutableString stringWithFormat:@""];
	NSMutableString		*strCount = [NSMutableString stringWithFormat:@""];
	NSMutableString		*wordOri = [NSMutableString stringWithFormat:@""];
    
    NSString *strCopyForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];
    NSString* strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strCopyForSQL];
    NSMutableArray *arrWordInfos = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
    DLog(@"dicIdiom : %@", dicIdiom);
    if ([myCommon getWordAndWordoriInSelected:_strMutableCopyWord dicWordWithOri:dicIdiom] == TRUE) {
        //단어또는 숙어가 사전에 존재하면...
        strCopyForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", [dicIdiom objectForKey:KEY_DIC_StrOverOneWord]]];
        strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strCopyForSQL];
    }
    
    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWordInfos byDic:nil openMyDic:OPEN_DIC_DB];
    BOOL blnHasWordInTheDic = TRUE;
    if ([arrWordInfos count] == 0) {
        //전체사전에서 없으면 현재사전에서만 가져온다.
        blnHasWordInTheDic = FALSE;
        strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strCopyForSQL];        
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWordInfos byDic:nil openMyDic:OPEN_DIC_DB_BOOK];
        if ([arrWordInfos count] == 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"[X]%@", _strMutableCopyWord];
            return;
        }
    }
    //단어의 정보를 가져온다.
    NSMutableDictionary *dicOne = [arrWordInfos objectAtIndex:0];	
    
    DLog(@"dicOne : %@", dicOne);
    wordOri = [dicOne objectForKey:@"WordOri"];
    strCount = [NSMutableString stringWithFormat:@"%d", [[dicOne objectForKey:@"Count"] integerValue]];
    strKnow = [dicOne objectForKey:@"Know"];
    strMeaning = [dicOne objectForKey:@"Meaning"];
    NSString *strPronounce = [dicOne objectForKey:@"Pronounce"];
    NSInteger intKnowPronounce = [[dicOne objectForKey:@"KnowPronounce"] integerValue];
   
    if ([wordOri isEqualToString:@""] == TRUE) {
        [self._strMutableCopyWordOri setString:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];
    } else {
        [self._strMutableCopyWordOri setString:wordOri];
    }
	DLog(@"strCount : %@", strCount);

	NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];

    if ([dicIdiom count] > 0) {
        strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[dicIdiom objectForKey:KEY_DIC_StrOverOneWord]];
    }
    NSString	*strQuery0 = [NSString	stringWithFormat:@"SELECT %@ FROM %@ where %@ = '%@'", FldName_TBL_EngDic_COUNT, TBL_EngDic, FldName_TBL_EngDic_WORD, strWordForSQL];
	int cntOfWord = [myCommon getIntFldValueFromTbl:strQuery0 openMyDic:FALSE];

    NSInteger cntTheWord = 0;
    NSInteger cntAllWord = 0;
    NSMutableArray *arrOne = [myCommon GetWordsCountFromTbl:[NSString stringWithFormat:@"%@", _strMutableCopyWordOri]];
    DLog(@"arrOne : %@", arrOne);
    for (NSDictionary *dicOne in arrOne) {
        NSString *strWord = [dicOne objectForKey:@"Word"];
        NSInteger intCnt = [[dicOne objectForKey:@"Count"] integerValue];
        cntAllWord += intCnt;

        DLog(@"strWord : %@", strWord);
        DLog(@"intCnt : %d", intCnt);            

        if ([[_strMutableCopyWord lowercaseString] isEqualToString:strWord]) {
            cntTheWord = intCnt;
        }
    }        
    if (blnHasWordInTheDic == TRUE) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"[X]%@", _strMutableCopyWord];
    }
    
    if (cntAllWord == cntTheWord) {
        if (cntTheWord == 0) {
            if (cntOfWord > 0) {
                self.lblCount.text = [NSString stringWithFormat:@"%d", cntOfWord];    
            } else {
                self.lblCount.text = @"";
            }
        } else {
            self.lblCount.text = [NSString stringWithFormat:@"%d", cntTheWord];
        }
    } else {
        self.lblCount.text = [NSString stringWithFormat:@"%d[%d]", cntTheWord, cntAllWord];
    }
    
	//뜻이 없고 지금 단어가 원형이 아니면... 원형으로 부터 뜻을 가져온다.
	if (([strMeaning isEqualToString:@""] == TRUE) && ([_strMutableCopyWordOri isEqualToString:[_strMutableCopyWord lowercaseString]] == FALSE)) {		
        strMeaning = [NSMutableString  stringWithString:[myCommon getMeaningFromTbl:[NSString stringWithFormat:@"%@", _strMutableCopyWordOri]]];
	}
	
    btnOpenQuiz.hidden = TRUE;
    if (([strMeaning isEqualToString:@""] == FALSE) && (blnShowQuizButton == TRUE)) {        
        btnOpenQuiz.hidden = FALSE;
    }
	self.txtMeaning.text = strMeaning;
    
    //모르는 발음이면 같이 표시하여준다.
    if ( (intKnowPronounce == 1) || (intKnowPronounce == 2) ) {
        if ([strPronounce isEqualToString:@""] == FALSE) {
            self.txtMeaning.text = [NSString stringWithFormat:@"%@[%@]", strMeaning, strPronounce];
        }
    }
        
	NSInteger intKnow = [strKnow intValue];
    self.lblKnow.text = [myCommon getStrKnowFromIntKnow:intKnow];

	//TBL_EngDic의 word로 가서 Know를 가져와서 Know!가 아니면 중요단어로 보고 중요수를 1 올린다.
	//현재 선택한 단어가 Know가 아니고 공백이 없으면(하나의 단어일때만)중요단어로 보고 중요수를 1 올린다.
	if ((FromWillAppear == false) && (intKnow < 3)) {
		//왜 TBL_EngDic에는 wordOri를 사용했을까?
		//[myCommon updateCountOfCheckedWord:intBookTblNo word:[strCopy lowercaseString] wordOri:[wordOri lowercaseString]];
		NSRange rangeOne = [_strMutableCopyWord rangeOfString:@" "];
		if (rangeOne.location == NSNotFound) {			
			[myCommon updateCountOfCheckedWord:intBookTblNo word:[_strMutableCopyWord lowercaseString] wordOri:[_strMutableCopyWord lowercaseString]];
		}
	}
}

- (void) LoadCurrPage:(BOOL)blnLoadForDup
{
    if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
        DLog(@"currPageNoToGo : %d",currPageNoToGo);
        DLog(@"[arrPageInfo count] : %d", [arrPageInfo count]);
        if (currPageNoToGo >= [arrPageInfo count]) {
            return;
        }
          
        NSDictionary *dicOne = [arrPageInfo objectAtIndex:currPageNoToGo];
        NSInteger offsetStart = [[dicOne objectForKey:@"OffsetStart"] integerValue];
        NSInteger offsetEnd = [[dicOne objectForKey:@"OffsetEnd"] integerValue];
        
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        if ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES){
            myBaseURL = [NSURL fileURLWithPath:ePubDirPath];
            DLog(@"ePubDirName : %@", ePubDirPath);
        }

        NSInteger offsetAll = offsetEnd - offsetStart;
        NSString *strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
        currPageNoToGo = currPageNo;
        NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:currWebView writeHTML:TRUE];
        if (blnShowUnknowWords == TRUE) {
            NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:currWebView];
            [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
        } else {
            [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];
        }
    } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        if (currPageNoToGo >= [arrScript count]) {
            return;
        }
        
        NSDictionary *dicOne = [arrScript objectAtIndex:currPageNoToGo];
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];

        NSString *strContentForOnePage = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];
        if (currPageNo < [arrScript1 count]) {

            NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
            NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
            
            if (dicScript1OneScript != NULL) {
                strContentForOnePage = [NSString stringWithFormat:@"%@\n\n%@",strContentForOnePage, [[arrScript1 objectAtIndex:currPageNo] objectForKey:SMI_DIC_KEY_SCRIPT]];          
            }
        }
        
        if (blnLoadForDup == TRUE) {
            NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:currWebView writeHTML:TRUE];

            DLog(@"strContentForOnePageHTML : %@", strContentForOnePageHTML);
            if (blnShowUnknowWords == TRUE) {
                NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:currWebView];
                DLog(@"strContentForOnePageHTMLMeaning : %@", strContentForOnePageHTMLMeaning);
                [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
            } else {
                [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];
            }
        } else {
            NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:currWebView writeHTML:TRUE];
            
             DLog(@"strContentForOnePageHTML : %@", strContentForOnePageHTML);
            if (blnShowUnknowWords == TRUE) {
                NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:currWebView];
                DLog(@"strContentForOnePageHTMLMeaning : %@", strContentForOnePageHTMLMeaning);
                [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
            } else {
                [[arrWebView objectAtIndex:currWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];    
            }
        }
    }
}

- (void) LoadPrevPage
{

    if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
        DLog(@"currPageNoToGo : %d",currPageNoToGo);
        DLog(@"[arrPageInfo count] : %d", [arrPageInfo count]);
        if ( ! ( (currPageNoToGo >= 0) &&  ( currPageNoToGo < [arrPageInfo count])) ) {
            return;
        }
        NSDictionary *dicOne = [arrPageInfo objectAtIndex:currPageNoToGo];
        NSInteger offsetStart = [[dicOne objectForKey:@"OffsetStart"] integerValue];
        NSInteger offsetEnd = [[dicOne objectForKey:@"OffsetEnd"] integerValue];
        
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        if ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES){
            myBaseURL = [NSURL fileURLWithPath:ePubDirName];
        }        
        
        NSInteger offsetAll = offsetEnd - offsetStart;
        NSString *strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
        
        NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:prevWebView writeHTML:TRUE];
        
        if (blnShowUnknowWords == TRUE) {
            NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:prevWebView];
            
            [[arrWebView objectAtIndex:prevWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
        } else {
            [[arrWebView objectAtIndex:prevWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];   
        }
    } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        if ( ((currPageNoToGo - 1) >= [arrScript count]) || ( (currPageNoToGo - 1) < 0) ) {
            return;
        }
        NSDictionary *dicOne = [arrScript objectAtIndex:currPageNoToGo-1];
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        
        NSString *strContentForOnePage = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];     
        if ((currPageNo-1) < [arrScript1 count]) {
            NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
            NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
            if (dicScript1OneScript != NULL) {

                strContentForOnePage = [NSString stringWithFormat:@"%@\n\n%@",strContentForOnePage, [[arrScript1 objectAtIndex:(currPageNoToGo-1)] objectForKey:SMI_DIC_KEY_SCRIPT]];  
            }
        }
        
        NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:prevWebView writeHTML:TRUE];
       
        if (blnShowUnknowWords == TRUE) {
            NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:prevWebView];
            DLog(@"strContentForOnePageHTMLMeaning : %@", strContentForOnePageHTMLMeaning);                    
            [[arrWebView objectAtIndex:prevWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
        } else {
            [[arrWebView objectAtIndex:prevWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];   
        }        
    } 
}

- (void) LoadNextPage
{      
    if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
        DLog(@"currPageNoToGo : %d",currPageNoToGo);
        DLog(@"[arrPageInfo count] : %d", [arrPageInfo count]);
        if ( ! ( (currPageNoToGo >= 0) &&  ( currPageNoToGo < [arrPageInfo count])) ) {
            return;
        }
        NSDictionary *dicOne = [arrPageInfo objectAtIndex:currPageNoToGo];
        NSInteger offsetStart = [[dicOne objectForKey:@"OffsetStart"] integerValue];
        NSInteger offsetEnd = [[dicOne objectForKey:@"OffsetEnd"] integerValue];
        
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        if ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES){
            myBaseURL = [NSURL fileURLWithPath:ePubDirName];
        }        
        
        NSInteger offsetAll = offsetEnd - offsetStart;
        DLog(@"offsetStart : %d", offsetStart);        
        DLog(@"offsetEnd : %d", offsetEnd);        
        DLog(@"offsetAll : %d", offsetAll);                
        DLog(@"strAllContentsInFile length : %d", [strAllContentsInFile length]);
        NSString *strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
        
        NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:nextWebView writeHTML:TRUE];
        
        if (blnShowUnknowWords == TRUE) {
            NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:nextWebView];
            [[arrWebView objectAtIndex:nextWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
        } else {
            [[arrWebView objectAtIndex:nextWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];  
        }  
    } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        if ( ((currPageNoToGo + 1) >= [arrScript count]) || ( (currPageNoToGo + 1) < 0) ) {
            return;
        }
        NSDictionary *dicOne = [arrScript objectAtIndex:currPageNoToGo+1];
        NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        
        NSString *strContentForOnePage = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];  
        if ((currPageNo+1) < [arrScript1 count]) {
            NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
            NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
            if (dicScript1OneScript != NULL) {

                strContentForOnePage = [NSString stringWithFormat:@"%@\n\n%@",strContentForOnePage, [[arrScript1 objectAtIndex:(currPageNoToGo+1)] objectForKey:SMI_DIC_KEY_SCRIPT]];   
                DLog(@"strNextScript : %@", strNextScript);
            }
        }
        
        NSString *strContentForOnePageHTML = [self HTMLFromTextStringPage: [NSMutableString stringWithString:strContentForOnePage] webViewIndex:nextWebView writeHTML:TRUE];
        
        if (blnShowUnknowWords == TRUE) {
            NSString *strContentForOnePageHTMLMeaning = [self HTMLMeaningOnePage:nextWebView];
            [[arrWebView objectAtIndex:nextWebView] loadHTMLString:strContentForOnePageHTMLMeaning baseURL:myBaseURL];
        } else {
            [[arrWebView objectAtIndex:nextWebView] loadHTMLString:strContentForOnePageHTML baseURL:myBaseURL];  
        }
    }
}

- (NSString *)GetBodyTextFromHTML:(NSString *)html { 
    
    NSScanner *thescanner;
    NSString *temp = nil;	
    thescanner = [NSScanner scannerWithString:html];

    NSString *strOriHTMLBody = @"";
    
    NSString *strTag = @"<BODY";
    [thescanner scanUpToString:strTag intoString:&temp];

    if ( (temp == NULL) || (thescanner.scanLocation == [html length]) )  {
        return @"";
    }
   
    thescanner.scanLocation = [thescanner scanLocation] + [strTag length];
    strTag = @"</BODY>";
    
    [thescanner scanUpToString:strTag intoString:&strOriHTMLBody];
    
    NSMutableString *strMutableBody = [NSMutableString stringWithString:strOriHTMLBody];

    NSMutableString *strResult = [[NSMutableString alloc] init]; //[NSString stringWithFormat:@"%@", strMutableBody];
    thescanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%@", strMutableBody]]; 
    NSInteger offsetScanner;
    while ([thescanner isAtEnd] == NO) { 
        
        while ([thescanner isAtEnd] == NO) {
            
            // find start of tag
            [thescanner scanUpToString:@">" intoString:&temp];
            offsetScanner = [thescanner scanLocation];
        
            BOOL blnAddString = FALSE;
            if ([[temp uppercaseString] isEqualToString:@"</P"]) {
                 [strResult appendString:[NSString stringWithFormat:@"\r\r"]];
                blnAddString = TRUE;

            } else if ([[temp uppercaseString] isEqualToString:@"</DIV"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</TR"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"<BR"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"<BR/"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</BR"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H1"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H2"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H3"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H4"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H5"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            } else if ([[temp uppercaseString] isEqualToString:@"</H6"]) {
                [strResult appendString:[NSString stringWithFormat:@"\r"]];                
                blnAddString = TRUE;
            }
//            DLog(@"\n\n======strResult======\n'%@'\n======strResult=====\n", strResult);
            if (blnAddString == TRUE) {

            }
            
            [thescanner scanUpToString:@"<" intoString:&temp];
            temp = [temp substringWithRange: NSMakeRange(1, [temp length] - 1)];
            
            if (temp == NULL) {
                continue;
            }
            
            if ([temp isEqualToString:@""] == TRUE) {
                continue;               
            }
            
            NSRange rngOne = [temp rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
            //        DLog(@"rngOne.location : %d, rngOne.length : %d", rngOne.location, rngOne.length );
            if  (rngOne.length == 0)
            {
                continue;
            }
//            DLog(@"\n\n\n======temp=====\n'%@'", temp);
            NSMutableString *strTemp = [NSMutableString stringWithString:temp];
            NSRange fullRange = NSMakeRange(0, [strTemp length]);
            
            [strTemp replaceOccurrencesOfString:@"\r\n" withString:@" "
                                             options:NSLiteralSearch range:fullRange];
            fullRange = NSMakeRange(0, [strTemp length]);

            
            [strTemp replaceOccurrencesOfString:@"\r" withString:@" "
                                               options:NSLiteralSearch range:fullRange];
            fullRange = NSMakeRange(0, [strTemp length]);

             
            [strTemp replaceOccurrencesOfString:@"\n" withString:@" "
                                               options:NSLiteralSearch range:fullRange];
            fullRange = NSMakeRange(0, [strTemp length]);
            temp = [NSString stringWithFormat:@"%@", strTemp];

            [strResult appendString:[NSString stringWithFormat:@"%@", temp]];
        }
    }

    return [NSString stringWithFormat:@"%@", strResult];
}

- (NSString *)GetBodyHTMLFromHTML:(NSString *)html { 
    
    NSScanner *thescanner;
    NSString *temp = nil;	
    thescanner = [NSScanner scannerWithString:html];
    
    NSString *strOriHTMLBody = @"";
    
    
    NSString *strTag = @"<BODY";
    [thescanner scanUpToString:strTag intoString:&temp];
    //    DLog(@"<BODY>temp : %@", temp);    
    if ( (temp == NULL) || (thescanner.scanLocation == [html length]) )  {
        return @"";
    }
    
    thescanner.scanLocation = [thescanner scanLocation] + [strTag length];
    strTag = @"</BODY>";
    
    [thescanner scanUpToString:strTag intoString:&strOriHTMLBody];
    DLog(@"strOriHTMLBody : %@", strOriHTMLBody);
        
    NSRange rangeResult = [strOriHTMLBody rangeOfString:@">"];
    NSString *strResult = @"";
	if( rangeResult.location != NSNotFound) {    
        NSInteger indexOfBraket = rangeResult.location + rangeResult.length;
        strResult = [strOriHTMLBody substringWithRange:NSMakeRange(indexOfBraket, [strOriHTMLBody length] - indexOfBraket)];
        DLog(@"strResult : %@", strResult);
    }                       
    return strResult;
}


- (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText webViewIndex:(NSInteger)webViewIndex writeHTML:(BOOL)blnWriteHTML 
{
	NSString *header;


	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css?time=%@\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], [myCommon getCurrentDatAndTimeForBackup]];
	
	NSRange fullRange = NSMakeRange(0, [originalText length]);
    
	unsigned int i,j;
	j=0;
    if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
        
        //아래 3개는 원래 문장에서 &amp;  &lt;   &gt;등이 있을때 이를 원래대로 한번 바꾸어준다.
        i = [originalText replaceOccurrencesOfString:@"&amp;" withString:@"&"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d &s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        i = [originalText replaceOccurrencesOfString:@"&lt;" withString:@"<"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d &s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        
        i = [originalText replaceOccurrencesOfString:@"&gt;" withString:@">"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d &s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        
        i = [originalText replaceOccurrencesOfString:@"&" withString:@"&amp;"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d &s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        i = [originalText replaceOccurrencesOfString:@"<" withString:@"&lt;"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d <s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        i = [originalText replaceOccurrencesOfString:@">" withString:@"&gt;"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d >s\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        // Argh, bloody MS line breaks!  Change them to UNIX, then...
        i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@"<br>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d carriage return/newlines\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        //Change newlines to </p><p>.
        i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@"</p>\n<p>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d double-newlines\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        //Change double-newlines to </p><p>.
        i = [originalText replaceOccurrencesOfString:@"\n" withString:@"</p>\n<p>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d double-newlines\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        // And just in case someone has a Classic MacOS textfile...
        i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@"</p>\n<p>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d double-carriage-returns\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        // Lots of text files start new paragraphs with newline-space-space or newline-tab
        i = [originalText replaceOccurrencesOfString:@"\n  " withString:@"</p>\n<p>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d double-spaces\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@"</p>\n<p>"
                                             options:NSLiteralSearch range:fullRange];
        //DLog(@"replaced %d double-spaces\n", i);
        j += i;
        fullRange = NSMakeRange(0, [originalText length]);
        
        //\r일경우...
        i = [originalText replaceOccurrencesOfString:@"\r" withString:@"<br>"
                                             options:NSLiteralSearch range:fullRange];
        j += i;
    }

    NSMutableString *outputHTMLImsi = [NSMutableString stringWithFormat:@"%@%@\n</body>\n</html>\n", header, originalText];
    NSRange fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br><br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
    fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
    
    NSString *outputHTML = [NSString stringWithFormat:@"%@", outputHTMLImsi];
    
    if (blnWriteHTML) {
        NSString *strFileName = strBookFileNameCurrPageInCachesWithPath;
        if (webViewIndex == currWebViewDup) {
            strFileName = strBookFileNameCurrDupPageInCachesWithPath;
        } else if (webViewIndex == prevWebView) {
            strFileName = strBookFileNamePrevPageInCachesWithPath;
        } else if (webViewIndex == nextWebView) {
            strFileName = strBookFileNameNextPageInCachesWithPath;
        }
        NSError *error;	
        BOOL ok=[outputHTML writeToFile:strFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];	
        if(!ok)		
        {		
            DLog(@"Error when writing %@ : %@", strFileName, [error description]);		
        }
    }
	return outputHTML;  
}

- (NSString*) HTMLMeaningOnePage:(NSInteger)webViewIndex
{
    if ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES){
        if (currPageNo >= [arrPageInfo count]) {
            return @"";
        }
    } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        if (currPageNo >= [arrScript count]) {
            return @"";
        }
        
        //자막에서 모든단어를 안보여주기를 할때
        if (intHideWordInScript == SMI_HIDE_WORD_ALL) {
            return @"";
        }
    } else if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        
    }
    NSDate		*startTime1 = [NSDate date];
    
    NSString *strFileName = strBookFileNameCurrPageInCachesWithPath;
    if (webViewIndex == currWebViewDup) {
        strFileName = strBookFileNameCurrDupPageInCachesWithPath;
    } else if (webViewIndex == prevWebView) {
        strFileName = strBookFileNamePrevPageInCachesWithPath;
    } else if (webViewIndex == nextWebView) {
        strFileName = strBookFileNameNextPageInCachesWithPath;
    }
    
	NSMutableString *strFileContents = [myCommon readTxtWithEncoding:strFileName];
    
    NSMutableString  *outputHTML = [self scanForMeaningWords:strFileContents];
    
    //    DLog(@"END outputHTML : %@", outputHTML);
#ifdef DEBUG
    //디버그 모드에서는 Document에 단어뜻을 적어준것을 적어준다.
    NSError *error;
    NSString *strMeaningHtmName = [NSString stringWithFormat:@"%@/%@_OnePage_Meaning.htm",[myCommon getDocPath], [[strBookFullFileName lastPathComponent] stringByDeletingPathExtension]];
    //	DLog(@"strMeaningHtmName : %@", strMeaningHtmName);
    BOOL ok= [outputHTML writeToFile:strMeaningHtmName atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if(!ok)
	{
		DLog(@"Error when writing %@ : %@", strMeaningHtmName, [error description]);
	}
#endif
    
    
    //webView에 적는다.
    NSURL *baseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
    
    //    DLog(@"outputHTML : %@", outputHTML);
    if (webViewIndex == nextWebView) {
        [[arrWebView objectAtIndex:nextWebView] loadHTMLString:outputHTML baseURL:baseURL];
    } else if (webViewIndex == prevWebView) {
        [[arrWebView objectAtIndex:prevWebView] loadHTMLString:outputHTML baseURL:baseURL];
    } else {
        [[arrWebView objectAtIndex:currWebViewDup] loadHTMLString:outputHTML baseURL:baseURL];
    }
    
    NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
	NSInteger minutes = elapsedTime/60;
	NSInteger seconds = round(elapsedTime - minutes * 60);
	NSString	*strElapsedTime  = nil;
	if (elapsedTime >= 60) {
		strElapsedTime = [NSString stringWithFormat:@"%d분 %d초 소요", minutes, seconds];
	} else {
		strElapsedTime = [NSString stringWithFormat:@"%d초 소요", seconds];
	}
    //	DLog(@"%@", [NSString stringWithFormat:@"Elapsed time: %.0f, %@", elapsedTime, strElapsedTime]);
    
    NSString *strResult = [NSString stringWithFormat:@"%@", outputHTML];
    if (blnWordSearchMode == TRUE) {
        [self.view bringSubviewToFront:viewWordSearchBackAndForward];
    }
    return strResult;
}

-(NSMutableString*)scanForMeaningWords:(NSMutableString*)strFileContents{
    
    NSScanner *thescanner;
    NSString *temp = nil;
    NSInteger offsetScanner = 0;
    thescanner = [NSScanner scannerWithString:strFileContents];
    
    NSMutableString  *outputHTML = [[NSMutableString alloc] initWithFormat:@""];
    
    while ([thescanner isAtEnd] == NO) {
        
        // find start of tag
		[thescanner scanUpToString:@">" intoString:&temp];
        offsetScanner = [thescanner scanLocation];
        //        DLog(@"temp : '%@'", temp);
        //        DLog(@"[thescanner scanLocation] : %d", [thescanner scanLocation]);
        [outputHTML appendString:[NSString stringWithFormat:@"%@>", temp]];
        //       DLog(@"outputHTML1 : %@", outputHTML);
        
        [thescanner scanUpToString:@"<" intoString:&temp];
        temp = [temp substringWithRange: NSMakeRange(1, [temp length] - 1)];
        //        DLog(@"temp : '%@'", temp);
        //        DLog(@"[thescanner scanLocation] : %d", [thescanner scanLocation]);
        if (temp == NULL) {
            continue;
        }
        
        if ([temp isEqualToString:@""] == TRUE) {
            continue;
        }
        
        NSRange rngOne = [temp rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        //        DLog(@"rngOne.location : %d, rngOne.length : %d", rngOne.location, rngOne.length );
        if  (rngOne.length == 0)
        {
            //길이는 0라도 엔터키등은 들어가야 한다.
            [outputHTML appendString:[NSString stringWithFormat:@"%@", temp]];
            //            DLog(@"outputHTML rngOne.len = 0: %@", outputHTML);
            continue;
        }
        
        NSArray *arrTemp11 = [temp componentsSeparatedByString:@" "];
        //        DLog(@"arrTemp11 : %@", arrTemp11);
        
        NSMutableArray *arrMutableTemp11 = [[NSMutableArray alloc] initWithArray:arrTemp11];
        
#ifdef CHINESE
        //중국어에서는 단어를 한글자씩 분리한다.
        [arrMutableTemp11 removeAllObjects];
        for (NSInteger i = 0; i < [temp length]; ++i) {
            NSString *strOneInTemp11 = [temp substringWithRange:NSMakeRange(i, 1)];
            //            DLog(@"strOneInTemp11 : %@", strOneInTemp11);
            [arrMutableTemp11 addObject:strOneInTemp11];
        }
#endif
        //        DLog(@"arrMutableTemp11 : %@", arrMutableTemp11);
        
        
        
        //        DLog(@"arrMutableTemp11 : %@", arrMutableTemp11);
        NSMutableString *strPunctuationEndOfString = [NSMutableString stringWithFormat:@""];
        for (int i = 0; i < [arrMutableTemp11 count]; i++) {
            [strPunctuationEndOfString setString:@""];
            
            NSString *strOneWordWithAlphabetAndPunctuation = [arrMutableTemp11 objectAtIndex:i];
            //            DLog(@"strOneWordWithAlphabetAndPunctuation : [%@]", strOneWordWithAlphabetAndPunctuation);
            
            NSString *strOneWordResultTrimmed = [strOneWordWithAlphabetAndPunctuation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            BOOL blnSkip = FALSE;
            
            if ( ([[strOneWordResultTrimmed lowercaseString] isEqualToString:@"&amp;"]) || ([[strOneWordResultTrimmed lowercaseString] isEqualToString:@"&lt;"]) || ([[strOneWordResultTrimmed lowercaseString] isEqualToString:@"&gt;"]) ) {
                blnSkip = TRUE;
            }
            
            strOneWordResultTrimmed = [strOneWordResultTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            
            if ( [strOneWordResultTrimmed isEqualToString:@""] == TRUE) {
                blnSkip = TRUE;
            }
            
            NSMutableString *strMutableOneWordResult = [[NSMutableString alloc] init];
            
            //제대로된 단어일때만 단어에 HTML Tag를 붙인다.
            if ( blnSkip == FALSE) {
                //뉴라인을 없애고 &amp;등인지 확인하고 나서 아닐때 구두점을 없앤다.
                //                strOneWordResultTrimmed = [strOneWordResultTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                
                
                //아래는 임시로 특정문장에서 디버깅하기 위한것이다.
                if ([[strOneWordWithAlphabetAndPunctuation lowercaseString] hasPrefix:@"他"] == TRUE) {
                    //                DLog(@"strOneWordWithAlphabetAndPunctuation : %@", strOneWordWithAlphabetAndPunctuation);
                }
                
                //문자열이 속한것의 range를 가져오는것
                NSRange rngStringInTrimmed = [strOneWordWithAlphabetAndPunctuation rangeOfString:strOneWordResultTrimmed];
                
                //단어앞에 구둣점이 있으면 가져온다.
                NSString *strStartPunctuation = @"";
                //단어뒤에 구둣점이 있으면 가져온다.
                NSString *strEndPunctuation = @"";
                
                //문자열이 속하면...
                if (rngStringInTrimmed.length > 0) {
                    strStartPunctuation = [strOneWordWithAlphabetAndPunctuation substringWithRange:NSMakeRange(0, rngStringInTrimmed.location)];
                    //                    DLog(@"strStartPunctuation : [%@]", strStartPunctuation);
                    
                    strEndPunctuation = [strOneWordWithAlphabetAndPunctuation substringWithRange:NSMakeRange(rngStringInTrimmed.location + rngStringInTrimmed.length, [strOneWordWithAlphabetAndPunctuation length] -  rngStringInTrimmed.location - rngStringInTrimmed.length)];
                    //                    DLog(@"strEndPunctuation : [%@]", strEndPunctuation);
                    
                }
                
                //앞뒤의 구둣점을 없앤 단어의 중간에 구둣점이 있는지 본다.(중간의 구둣점으로 단어를 나눈다.)
                NSArray *arrStrOneSeperatedByPunction = [strOneWordResultTrimmed componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                
#ifdef ENGLISH
                
                //                if ( ([arrStrOneSeperatedByPunction count] > 1) || ([strEndPunctuation isEqualToString:@""] == FALSE) ) {
                if ( ([arrStrOneSeperatedByPunction count] > 1) || (self.blnShowPhrasalVerb == FALSE) ) {
                    //옵션에서 숙어검사를 안한다고 했거나 끝과 중간에 구둣점이 있을때... 이때는 숙어검사를 하지 않는다.
                    //                    DLog(@"0");
                    //                    DLog(@"strOneWordWithAlphabetAndPunctuation : %@", strOneWordWithAlphabetAndPunctuation);
                    NSString *strOneWordWithAlphabetAndPunctuationConvertAmpersand = [strOneWordWithAlphabetAndPunctuation stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                    // < > 로는 바꾸면 punctuationCharacterSet 이 안먹네...
                    
                    NSMutableArray *arrAlphabetAndPunctuationInOneWord = [myCommon getWordsAndPunctuationInSelectedWord:strOneWordWithAlphabetAndPunctuationConvertAmpersand];
                    //                        DLog(@"arrAlphabetAndPunctuationInOneWord : %@", arrAlphabetAndPunctuationInOneWord);
                    //                NSString *strOneWord = [NSString stringWithString:strOneWordResultTrimmed];
                    for (NSString __strong *strOneWord in arrAlphabetAndPunctuationInOneWord) {
                        //                        DLog(@"strOneWord : [%@]", strOneWord);
                        NSString *strOneWordTrimmed = [strOneWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        strOneWordTrimmed = [strOneWordTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                        if ([strOneWordTrimmed isEqualToString:@""]) {
                            //구둣점이면 그냥 넘어간다.
                            if ([strOneWord isEqualToString:@"&"]) {
                                strOneWord = @"&amp;";
                            }
                            [strMutableOneWordResult appendString:strOneWord];
                            continue;
                        }
                        NSString *strOneWordResult = [self HTMLFromWithKnowTag:strOneWord strWordOriToFind:@""];
                        strOneWordResult = [strOneWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        strOneWordResult = [strOneWordResult stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"&lt;"];
                        strOneWordResult = [strOneWordResult stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@"&gt;"];
                        //                        DLog(@"strOneWordResult : [%@]", strOneWordResult);
                        [strMutableOneWordResult appendString:strOneWordResult];
                    }
                    //                    DLog(@"strMutableOneWordResult : [%@]", strMutableOneWordResult);
                    [strMutableOneWordResult setString:[strMutableOneWordResult stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"&lt;"]];
                    [strMutableOneWordResult setString:[strMutableOneWordResult stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@"&gt;"]];
                    //                    DLog(@"strMutableOneWordResult : [%@]", strMutableOneWordResult);
                    
                    //지우지말것 아래는 It's가 있을때 It'sit's로 된다.(수정필요함)  up-to-date같은 경우에 전체의 뜻을 달려면 아래가 필요하다.
                    //단어뒤에 구둣점이 없을때는 전체 단어로도 뜻이 있는지 한번더 본다.
                    //                    if ( ([strEndPunctuation isEqualToString:@""] == TRUE) && ([arrAlphabetAndPunctuationInOneWord count] > 1) ) {
                    if ([arrAlphabetAndPunctuationInOneWord count] > 1) {
                        NSString    *strOneWordWithAlphabetAndPunctuationForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWordWithAlphabetAndPunctuation];
                        NSString    *strMeaning = [myCommon getMeaningFromTbl:strOneWordWithAlphabetAndPunctuationForSQL];
                        
                        //전체단어로도 뜻이 있으면 가운데 단어의 뜻은 안보여준다.
                        if ( !( (strMeaning == NULL) || ([strMeaning isEqualToString:@""]) ) ) {
                            NSString *strOneWordResult = [self HTMLFromWithKnowTag:strOneWordWithAlphabetAndPunctuation strWordOriToFind:@""];
                            strOneWordResult = [strOneWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            strOneWordResult = [strOneWordResult stringByReplacingOccurrencesOfString:strOneWordWithAlphabetAndPunctuation withString:@""];
                            //                            DLog(@"strOneWordResult : [%@]", strOneWordResult);
                            [strMutableOneWordResult setString:strOneWordResult];
                        }
                    }
                    
                } else {
                    //숙어검사를 한다(중간에 구둣점이 없을때...) 구둣점으로 시작하거나 끝나는 것도 여기서 한다.
                    //                    NSString *strOneWord = [NSString stringWithString:strOneWordWithAlphabetAndPunctuation];
                    NSString *strOneWord = [NSString stringWithString:strOneWordResultTrimmed];
                    //                    DLog(@"strOneWord : [%@]", strOneWord);
                    NSMutableString *strOverOneWordOri = [NSMutableString stringWithString:@""];
                    NSMutableString *strOverOneWordOriWhenHasIdiom = [NSMutableString stringWithString:@""];
                    
                    
                    //맨마지막 단어가 아니면...(다음단어가 전체문장을 벗어나지 않으면..)
                    //TODO : 여기서 arrMutableTemp11은 전체 문장이 아니고 HTML Tag로 구분된 문장이다. 다음 문장과 이어진 숙어는 구분하지 못하네...
                    //                    DLog(@"arrMutableTemp11 : %@", arrMutableTemp11);
                    if ( (i + 1) < ([arrMutableTemp11 count]) ){
                        NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
                        
                        NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWordResultTrimmed];
                        NSString *strOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneOri];
                        
                        NSString *strNextOne = [arrMutableTemp11 objectAtIndex:i+1];
                        NSString *strNextOneTrimmed = [strNextOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        strNextOneTrimmed = [strNextOneTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                        
                        NSString *strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneTrimmed];
                        NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOneTrimmed];
                        NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
                        
                        if ([[strOneWordWithAlphabetAndPunctuation lowercaseString] isEqualToString:@"driving"] == TRUE) {
                            //                            DLog(@"strOneWord : %@", strOneWord);
                            //                            DLog(@"arrMutableTemp11 : %@", arrMutableTemp11);
                        }
                        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@ %@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, strNextOneOriForSQL, FldName_WordLength];
                        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                        
                        
                        if ([arrAllOne count] > 0) {
                            //숙어나 문장의 경우... (두단어 이상으로 이루어진다.)
                            
                            //아래는 숙어등이 많을때(100개)를 생각해서 3번째 단어로도 숙어등을 확ㅣㅇ해본다.
                            if ( ([arrAllOne count] > 100) && ( (i + 3) < ([arrMutableTemp11 count])) ){
                                
                                NSString *strNextOne2 = [arrMutableTemp11 objectAtIndex:i+2];
                                NSString *strNextOne3 = [arrMutableTemp11 objectAtIndex:i+3];
                                //                                strNextOneTrimmed = [strNextOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                NSString *strNextOne2Trimmed = [strNextOne2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                strNextOne2Trimmed = [strNextOne2Trimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                NSString *strNextOne3Trimmed = [strNextOne3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                strNextOne3Trimmed = [strNextOne3Trimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                
                                NSString *strNextOne2Ori = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne2Trimmed];
                                NSString *strNextOne2OriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne2Ori];
                                
                                NSString *strNextOne3Ori = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne3Trimmed];
                                NSString *strNextOne3OriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne3Ori];
                                
                                strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@,%@,%@,%@%%' COLLATE NOCASE ORDER BY %@ ASC", TBL_EngDic, FldName_WORDORI, strOneOriForSQL, strNextOneOriForSQL, strNextOne2OriForSQL, strNextOne3OriForSQL, FldName_WordLength];
                                NSMutableArray *arrAllOne2 = [[NSMutableArray alloc] init];
                                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne2 byDic:nil openMyDic:OPEN_DIC_DB];
                                
                                if ([arrAllOne2 count] > 0) {
                                    //                                    DLog(@"arrAllOne : %@", arrAllOne);
                                    //                                    DLog(@"arrAllOne2 : %@", arrAllOne2);
                                    [arrAllOne setArray:arrAllOne2];
                                    //                                    DLog(@"arrAllOne : %@", arrAllOne);
                                    
                                }
                            }
                            NSMutableString *strOverOneWord = [NSMutableString stringWithString:strOneWord];
                            NSMutableString *strOverOneWordInText = [NSMutableString stringWithString:strOneWordWithAlphabetAndPunctuation];
                            NSMutableString *strOverOneWordInTextWhenHasIdiom = [NSMutableString stringWithString:strOneWordWithAlphabetAndPunctuation];
                            //                            DLog(@"strOverOneWord : %@", strOverOneWord);
                            //                            DLog(@"strOverOneWordInText : %@", strOverOneWordInText);
                            
                            BOOL blnHasWordInDic = FALSE;
                            
                            //Todo : agree to와 agree to with등은 1개만 찾는다. 아마 제일긴것만 나올거 같음.
                            for (NSDictionary *dicOne in arrAllOne) {
                                [strPunctuationEndOfString setString:@""];
                                NSMutableString *strOverOneWordOriInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@,", strOneOriForSQL]];
                                NSMutableString *strOverOneWordInTextInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", strOneWord]];
                                [strOverOneWordOri setString:[NSString stringWithFormat:@"%@,", strOneOriForSQL]];
                                [strOverOneWordInText setString:strOneWord];
                                
                                NSString *strWordOriInDicOne = [dicOne objectForKey:KEY_DIC_WORDORI];
                                //                                DLog(@"strWordOriInDicOne : %@", strWordOriInDicOne);
                                NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
                                //                                DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                                //아래의 if문은 왜 존재하나?
                                //                                    if (indexWordLength != intWordLengthInDicOne) {
                                for (int j = 1; j < intWordLengthInDicOne; ++j) {
                                    // 문장내의 다음단어까지 다시 한번 읽는다.
                                    //다음단어를 찾는데... 이것이 현재 문장 arrMutableTemp11을 넘어면... 찾지 않는다.
                                    //ToDo : 향후에는 다음단어를 arrMutableTemp11를 넘어서드라도 찾아야 함.
                                    if (i+j >= [arrMutableTemp11 count]) {
                                        break;
                                    }
                                    
                                    strNextOne = [arrMutableTemp11 objectAtIndex:i+j];
                                    //                                    DLog(@"strNextOne : %@", strNextOne);
                                    
                                    //아래는 임시로 특정문장에서 디버깅하기 위한것이다.
                                    if ([[strNextOne lowercaseString] isEqualToString:@"distant,"] == TRUE) {
                                        //                                            DLog(@"strNextOne : %@", strNextOne);
                                    }
                                    //                                        strNextOne = [arrAlphabetAndPunctuationInOneWordNext_1 objectAtIndex:0];
                                    
                                    strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
                                    NSString *strNextOneTrimmed = [strNextOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                    strNextOneTrimmed = [strNextOneTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    //                                    DLog(@"strNextOneTrimmed : %@", strNextOneTrimmed);
                                    strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOneTrimmed];
                                    NSString *strNextOneOriTrimmed = [strNextOneOri stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                    strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOriTrimmed];
                                    
                                    [strOverOneWordOriInForState appendFormat:@"%@,",strNextOneOri];
                                    [strOverOneWordInTextInForState appendFormat:@" %@",strNextOne];
                                    
                                }
                                
                                //해당숙어가 존재하면... (하지만 더 긴 숙어가 존재할수 있어서 For문은 계속 돈다.
                                if ([strWordOriInDicOne isEqualToString:strOverOneWordOriInForState] == TRUE) {
                                    blnHasWordInDic = TRUE;
                                    //                                    DLog(@"dicOne : %@", dicOne);
                                    strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
                                    [strOverOneWordOri setString:[NSString stringWithFormat:@"%@", strOverOneWordOriInForState]];
                                    [strOverOneWordOriWhenHasIdiom setString:strOverOneWordOriInForState];
                                    [strOverOneWordInText setString:[NSString stringWithFormat:@"%@", strOverOneWordInTextInForState]];
                                    [strOverOneWordInTextWhenHasIdiom setString:strOverOneWordInTextInForState];
                                }
                            }
                            
                            
                            //                            DLog(@"strOverOneWordInText After: [%@]", strOverOneWordInText);
                            //                            DLog(@"strOverOneWordOri After: [%@]", strOverOneWordOri);
                            //                            DLog(@"strOverOneWord After: [%@]", strOverOneWord);
                            
                            NSArray *arrBlankInstrOverOneWordInText = [[strOverOneWordInTextWhenHasIdiom lowercaseString] componentsSeparatedByString:@" "];
                            
                            if  (blnHasWordInDic == TRUE) {
                                //                            if ([arrBlankInstrOverOneWord count] == [arrBlankInstrOverOneWordInText count]) {
                                //숙어가 존재할때 숙어를 strOneWord로 넣어준다.
                                strOneWord = strOverOneWordInTextWhenHasIdiom;// strOverOneWordInText;
                                [strOverOneWordOri setString:strOverOneWordOriWhenHasIdiom];
                                i += [arrBlankInstrOverOneWordInText count] - 1;
                            } else {
                                //숙어가 존재하지 않을때...
                                [strOverOneWordInText setString:@""];
                                [strOverOneWordOri setString:@""];
                            }
                        }
                        
                        //                DLog(@"strOneWord : [%@]", strOneWord);
                        //                DLog(@"strOverOneWordOri : [%@]", strOverOneWordOri);
                        NSString *strOneWordResult = strOneWord;
                        //                if ([strOneWord isEqualToString:@" "] == FALSE) {
                        //                        DLog(@"strOneWordResult : [%@]", strOneWordResult);
                        //단어가 공백, 엔터, 구둣점등으로만 이루어지지 않았으면 HTML Tag를 붙힌다.
                        strOneWordResult = [self HTMLFromWithKnowTag:strOneWord strWordOriToFind:strOverOneWordOri];
                        strOneWordResult = [strOneWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        //                        DLog(@"strOneWordResult : [%@]", strOneWordResult);
                        //                        [strMutableOneWordResult appendString:strOneWordResult];
                        [strMutableOneWordResult appendFormat:@"%@%@%@", strStartPunctuation, strOneWordResult, strEndPunctuation];
                        //                DLog(@"strMutableOneWordResult : [%@]", strMutableOneWordResult);
                    } else {
                        NSString *strOneWordResult = [self HTMLFromWithKnowTag:strOneWord strWordOriToFind:@""];
                        strOneWordResult = [strOneWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        strOneWordResult = [NSString stringWithFormat:@"%@%@%@", strStartPunctuation, strOneWordResult, strEndPunctuation];
                        //                        DLog(@"strOneWordResult : [%@]", strOneWordResult);
                        [strMutableOneWordResult appendString:strOneWordResult];
                        
                    }
                }
#elif CHINESE
                //중국어는 문자만이 아니라 단어일수 있어서 해당되는 단어가 있는지 확인해서 단어가 있으면 단어를 넘긴다.
                //일단 본문에서 4자 이상이 있는지 본다.
                NSString *strOneWord = strOneWordWithAlphabetAndPunctuation;
                NSMutableString *strOverOneWord = [NSMutableString stringWithString:@""];
                NSInteger indexWordLength = 1;
                NSInteger indexWordLengthTRUE = 1;
                BOOL blnHasWordInDic = FALSE;
                
                NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
                
                if ((i + 4) <= [arrMutableTemp11 count] ) {
                    strOverOneWord = [NSMutableString stringWithFormat:@""];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 2)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 3)]];
                    //                    DLog(@"strOverOneWord : [%@]", strOverOneWord);
                    indexWordLength = 4;
                    indexWordLengthTRUE = 4;
                    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOverOneWord, FldName_WordLength];
                    
                    //            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
                    
                    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                    //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                    
                    
                    if ([arrAllOne count] >= 1) {
                        //                        DLog(@"arrAllOne : %@", arrAllOne);
                        for (NSDictionary *dicOne in arrAllOne) {
                            //                        //                    NSDictionary *dicOne = [dicAllOne objectForKey:strWordKey];
                            //                            DLog(@"dicOne : %@", dicOne);
                            //                    DLog(@"strWordKey : %@", strWordKey);
                            NSString *strWordInDicOne = [dicOne objectForKey:KEY_DIC_WORD];
                            //                            DLog(@"strWordInDicOne : %@", strWordInDicOne);
                            NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
                            //                            DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                            if ((i + indexWordLength) >= [arrMutableTemp11 count] ) {
                                break;
                            }
                            
                            if (indexWordLength != intWordLengthInDicOne) {
                                
                                [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + indexWordLength)]];
                                //                                DLog(@"strOverOneWord : %@", strOverOneWord);
                                indexWordLength++;
                                //                                DLog(@"AFTER indexWordLength : %d", indexWordLength);
                            }
                            
                            if ([strWordInDicOne isEqualToString:strOverOneWord] == TRUE) {
                                strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                                blnHasWordInDic = TRUE;
                                indexWordLengthTRUE = indexWordLength;
                                //                            DLog(@"strOneWord : %@", strOneWord);
                            }
                            
                        }
                    }
                }
                
                //본문의 3글자에 해당되는 단어가 사전에 있는지 본다.
                if ( ( blnHasWordInDic == FALSE) && ((i + 3) <= [arrMutableTemp11 count] ) ){
                    strOverOneWord = [NSMutableString stringWithFormat:@""];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 2)]];
                    //                DLog(@"strOverOneWord : %@", strOverOneWord);
                    indexWordLength = 3;
                    indexWordLengthTRUE = 3;
                    
                    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                    //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                    if ([arrAllOne count] >= 1) {
                        blnHasWordInDic = TRUE;
                        strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                    }
                }
                
                //본문의 2글자에 해당되는 단어가 사전에 있는지 본다.
                if ( ( blnHasWordInDic == FALSE) && ((i + 2) <= [arrMutableTemp11 count] ) ){
                    strOverOneWord = [NSMutableString stringWithFormat:@""];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
                    //                    DLog(@"strOverOneWord : %@", strOverOneWord);
                    indexWordLength = 2;
                    indexWordLengthTRUE = 2;
                    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                    //                    DLog(@"arrAllOne : %@", arrAllOne);
                    if ([arrAllOne count] >= 1) {
                        DLog(@"Word : %@", [[arrAllOne objectAtIndex:0] objectForKey:KEY_DIC_WORD]);
                        DLog(@"WordOri : %@", [[arrAllOne objectAtIndex:0] objectForKey:KEY_DIC_WORDORI]);
                        
                        blnHasWordInDic = TRUE;
                        strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                    }
                    
                }
                
                //본문의 1글자에 해당되는 단어가 사전에 있는지 본다.
                if ( ( blnHasWordInDic == FALSE) && ((i + 1) <= [arrMutableTemp11 count] ) ){
                    strOverOneWord = [NSMutableString stringWithFormat:@""];
                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
                    //                DLog(@"strOverOneWord : %@", strOverOneWord);
                    indexWordLength = 1;
                    indexWordLengthTRUE = 1;
                    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                    [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                    //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                    if ([arrAllOne count] >= 1) {
                        blnHasWordInDic = TRUE;
                        strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                    }
                    
                }
                
                i = i + indexWordLengthTRUE - 1;
                
                NSString *strOneWordResult = [self HTMLFromWithKnowTag:strOneWord strWordOriToFind:@""];
                strOneWordResult = [strOneWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                DLog(@"strOneWordResult : [%@]", strOneWordResult);
                [strMutableOneWordResult appendString:strOneWordResult];
#endif
                
            } else {
                //단어가 공백, 구둣점등으로만 이루어졌을때는 그냥 그걸 그대로 쓴다.
                [strMutableOneWordResult setString:strOneWordWithAlphabetAndPunctuation];
            }
            
#ifdef ENGLISH
            
            if  (i == 0) {
                [outputHTML appendString:[NSString stringWithFormat:@"%@%@ ", strMutableOneWordResult, strPunctuationEndOfString]];
            } else {
                [outputHTML appendString:[NSString stringWithFormat:@" %@%@", strMutableOneWordResult, strPunctuationEndOfString]];
            }
            //            DLog(@"outputHTML : %@", outputHTML);
#elif CHINESE
            [outputHTML appendString:[NSString stringWithFormat:@"%@%@", strMutableOneWordResult, strPunctuationEndOfString]];
#endif
            
        }
    }
    
    //단어 찾기일때는 한 페이지내에서 해당되는 순서의 단어색은 노란색이 아닌 gold색으로 보여준다.
    if (blnWordSearchMode){
        NSString *strToBeReplaced = @"<span style=\"background-color:yellow\">";
        NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@", strToBeReplaced] options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray *matches = [regEx matchesInString:outputHTML
                                          options:0
                                            range:NSMakeRange(0, [outputHTML length])];
        NSInteger cntOfWordSearch = 0;
        for (NSTextCheckingResult *match in matches) {
            cntOfWordSearch++;
            
            NSRange matchRange = [match range];
            
            if (cntOfWordSearch == intIndexOfWordInSamePage) {
                [regEx replaceMatchesInString:outputHTML options:NSRegularExpressionCaseInsensitive range:NSMakeRange(matchRange.location, [strToBeReplaced length]) withTemplate:@"<span style=\"background-color:gold\">"];
                break;
            }
        }
    }
    
    return outputHTML;
}

//영어단어를 Know Tag를 추가한다.
- (NSString*) HTMLFromWithKnowTag:(NSString*)strWordOrIdiom strWordOriToFind:(NSString*) strWordOriToFind
{
    //    DLog(@"strWordOri : %@", strWordOri);
    
    NSString *strBraceBeforeMeaning = @"[";
    NSString *strBraceAfterMeaning = @"]";
    
    
    //strWordOrIdiom의 앞뒤구두점을 없앤다.
    NSString *strWordOrIdiomTrimmed = [strWordOrIdiom stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strWordOrIdiomTrimmed = [strWordOrIdiomTrimmed stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];    
    
    //문자열이 속한것의 range를 가져오는것
    NSRange rngStringInTrimmed = [strWordOrIdiom rangeOfString:strWordOrIdiomTrimmed];

    //단어앞에 구둣점이 있으면 가져온다.
    NSString *strStartPunctuation = @"";
    //단어뒤에 구둣점이 있으면 가져온다.
    NSString *strEndPunctuation = @"";

    if (rngStringInTrimmed.length > 0) {
        strStartPunctuation = [strWordOrIdiom substringWithRange:NSMakeRange(0, rngStringInTrimmed.location)];
//        DLog(@"strStartPunctuation : [%@]", strStartPunctuation);
        
        strEndPunctuation = [strWordOrIdiom substringWithRange:NSMakeRange(rngStringInTrimmed.location + rngStringInTrimmed.length, [strWordOrIdiom length] -  rngStringInTrimmed.location - rngStringInTrimmed.length)];
//        DLog(@"strEndPunctuation : [%@]", strEndPunctuation);

    }

    BOOL blnIsOneWord = [strWordOriToFind isEqualToString:@""] ? TRUE : FALSE;
    NSMutableArray *arrOne = [[NSMutableArray alloc] initWithArray:[strWordOrIdiomTrimmed componentsSeparatedByString:@" "]];
    if (blnIsOneWord == FALSE) {
        [arrOne addObject:strWordOriToFind];
    }
    
    BOOL blnLastWord = FALSE;
    NSMutableString *strMutableWordResult = [[NSMutableString alloc] init];
    for(NSString __strong *strWord in arrOne) {
        
        if ([strWordOriToFind isEqualToString:strWord]) {
            blnLastWord = TRUE;
            strWord = @"";
        }
        NSMutableString *strMutableOneWordInWordOrIdiom = [NSMutableString stringWithString:strWord];
     
        NSString *strWordTrimmingPunctuation = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        strWordTrimmingPunctuation = [strWordTrimmingPunctuation stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        strWordTrimmingPunctuation = [strWordTrimmingPunctuation lowercaseString];
        
        if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
            if (intHideWordInScript == SMI_HIDE_WORD_KNOWN) {
                //아는단어는 표시하지 않는다.
                NSRegularExpression *regEx1 = [NSRegularExpression regularExpressionWithPattern:@"([0-9_?!/\\'.,;])" options:NSRegularExpressionCaseInsensitive error:nil];
                NSString  *strValueToChange11 = [NSString stringWithFormat:@"<font color=#FFFFFF>"];
                NSString  *strValueToChange12 = [NSString stringWithFormat:@"</font>"];
                [regEx1 replaceMatchesInString:strMutableOneWordInWordOrIdiom options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strMutableOneWordInWordOrIdiom length]) withTemplate:[NSString stringWithFormat:@"%@$1%@", strValueToChange11, strValueToChange12]];
                //            DLog(@"strMutableWordOri : %@", strMutableWordOri);
            }
        }
        

        NSDictionary *dicOne = [[NSDictionary alloc] init];
        
        
        if ( (blnIsOneWord == FALSE) && (blnLastWord == TRUE) ) {

            NSString *strWordOriToFindForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOriToFind];
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriToFindForSQL];
            
            NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
        
            if ([arrAllOne count] < 1) {
                [strMutableWordResult appendFormat:@"%@", strWord];
                continue;
            }
            
            dicOne = [arrAllOne objectAtIndex:0];
            
            if (dicOne == NULL) {
                [strMutableWordResult appendFormat:@"%@", strWord];
                continue;
            }
            
            strBraceBeforeMeaning = @"(";
            strBraceAfterMeaning = @")";

        } else {

            NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordTrimmingPunctuation];
            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWordForSQL];
            
            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
            
            dicOne = [dicAllOne objectForKey:strWordTrimmingPunctuation];
            
            if (dicOne == NULL) {

                [strMutableWordResult appendFormat:@"%@ ", strWord];
                continue;
            }
            strBraceBeforeMeaning = @"[";
            strBraceAfterMeaning = @"]";
        }
        
        NSString *strKnow = [dicOne objectForKey:@"Know"];

        NSString *strWordOri = [dicOne objectForKey:@"WordOri"];
        
        NSString *strPronounce = [dicOne objectForKey:@"Pronounce"];
        NSInteger intKnowPronounce = [[dicOne objectForKey:@"KnowPronounce"] integerValue];

        NSInteger intKnow = [strKnow integerValue];

        //단어 찾기 모드가 아닐때(단어찾기에서는 아는단어와 상관없이 단어의 색을 바꿀려면 아래를 타야한다.)
        if (blnWordSearchMode == FALSE) {
            if ( (intKnow >= KnowWord_Known) && (intKnowPronounce >= KnowWord_Known) ) {
                //아는단어와 아는발음이면 더이상 하지 않는다.
                [strMutableWordResult appendFormat:@"%@ ", strWord];
                continue;
            }
        }
        
        NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
        if (strMeaning == NULL){
            strMeaning = @"";
        }
        BOOL ShowMeaning = [[self.dicSetting objectForKey:@"Show Meaning"] boolValue];
        NSString *MeaningHtml = @"";

        //뜻을 보여줄때는...
        if (ShowMeaning == TRUE) {
            
            if ( (intKnow >= KnowWord_Known) && (intKnowPronounce >= KnowWord_Known) ){
                //아는 단어에 아는 발음이면 더이상 하지 않는다.
                [strMutableWordResult appendFormat:@"%@ ", strWord];
                continue;
            }
            
            if ( (intKnow >= KnowWord_Known) && (intKnowPronounce == KnowWord_NotRated) ){
                //아는 단어에 발음의 아는정도를 선택하지 않았으면 더이상 하지 않는다.
                [strMutableWordResult appendFormat:@"%@ ", strWord];
                continue;
            }
            
            if ( (intKnow >= KnowWord_Known) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
                //아는 단어에 모르는 발음이고 발음이 있으면 발음만 표시한다.
                MeaningHtml = [NSString stringWithFormat:@"<small>%@</small><big>%@</big><small>%@</small>", strBraceBeforeMeaning, strPronounce, strBraceAfterMeaning];
            } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == TRUE) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
                //모르는 단어에 뜻이 없고 모르는 발음이고 발음이 있으면 발음만 표시한다.
                MeaningHtml = [NSString stringWithFormat:@"<small>%@</small><big>%@</big><small>%@</small>", strBraceBeforeMeaning, strPronounce, strBraceAfterMeaning];
            } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == FALSE) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
                //모르는 단어에 뜻이 있고 모르는 발음이고 발음이 있으면 뜻과 발음만 표시한다.
    #ifdef ENGLISH
                MeaningHtml = [NSString stringWithFormat:@"<small>%@%@, %@%@</small>", strBraceBeforeMeaning, strPronounce, strMeaning, strBraceAfterMeaning];
    #else
                MeaningHtml = [NSString stringWithFormat:@"<small>%@</small><big>%@</big>, <small>%@%@</small>", strBraceBeforeMeaning, strPronounce, strMeaning, strBraceAfterMeaning];
    #endif
                ;
            } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == FALSE) ){
                //모르는 단어에 뜻이 있으면 뜻만 표시한다.
                MeaningHtml = [NSString stringWithFormat:@"<small>%@%@%@</small>", strBraceBeforeMeaning, strMeaning, strBraceAfterMeaning];
            }
        }
        
        if (dicOne == NULL) {
            intKnow = -1;
        }
        NSString *showColorOccur = @"";
        if (intKnow == 0) {
            if ( (blnIsOneWord == FALSE) && (blnLastWord == TRUE) ) {
                //숙어일때 (맨마지막이 숙어이다.)
                
                showColorOccur = KEY_CSS_WORDNotRatedIdiom;
            } else {
                showColorOccur = KEY_CSS_WORDNotRated;
            }
        } else if (intKnow == 1) {
            if ( (blnIsOneWord == FALSE) && (blnLastWord == TRUE) ) {
                //숙어일때 (맨마지막이 숙어이다.)
                
                showColorOccur = KEY_CSS_WORDUnknownIdiom;
            } else {
                showColorOccur = KEY_CSS_WORDUnknown;
            }
        } else if   (intKnow == 2) {
            if ( (blnIsOneWord == FALSE) && (blnLastWord == TRUE) ) {
                //숙어일때 (맨마지막이 숙어이다.)
                
                showColorOccur = KEY_CSS_WORDNotSureIdiom;
            } else {
                showColorOccur = KEY_CSS_WORDNotSure;
            }
        }
        
        BOOL blnStrWordInWordSearch = FALSE;
        if (blnWordSearchMode == TRUE) {
            
            if (blnHeadword == TRUE) {
                if ([[strWordOriSearch lowercaseString] isEqualToString:[strWordOri lowercaseString]] == TRUE) {
                    showColorOccur = KEY_CSS_WORDNotSure;
                    blnStrWordInWordSearch = TRUE;
                }
            } else {
                if ([[strWord lowercaseString] isEqualToString:[strWordSearch lowercaseString]] == TRUE) {
                    showColorOccur = KEY_CSS_WORDNotSure;
                    blnStrWordInWordSearch = TRUE;
                }
            }
        }
        
        NSString  *strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        NSString  *strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        if (blnStrWordInWordSearch == TRUE) {
            strValueToChange1 = [NSString stringWithFormat:@"<span style=\"background-color:yellow\">"];
            strValueToChange2 = [NSString stringWithFormat:@"</span>%@", MeaningHtml];
        }
        
        if ( (blnIsOneWord == FALSE) && (blnLastWord == TRUE) ) {

            [strMutableWordResult setString:[NSString stringWithFormat:@"%@%@%@%@%@", strStartPunctuation, strValueToChange1, [strMutableWordResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], strValueToChange2, strEndPunctuation]];

        } else {
            NSError *err = nil;
            NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordTrimmingPunctuation] options:NSRegularExpressionCaseInsensitive error:&err];
            
            //책과 EPub일때
            if ( ([strBookFileNameExtension isEqualToString:fileExtension_TXT] == YES) || ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES) ) {
//                DLog(@"strMutableOneWordInWordOrIdiom : %@", strMutableOneWordInWordOrIdiom);
                [regEx2 replaceMatchesInString:strMutableOneWordInWordOrIdiom options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strMutableOneWordInWordOrIdiom length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
//                DLog(@"strMutableOneWordInWordOrIdiom : %@", strMutableOneWordInWordOrIdiom);
                
            } else {
                //책과 EPub가 아닐때
                if (intHideWordInScript == SMI_HIDE_WORD_NONE) {
                    [regEx2 replaceMatchesInString:strMutableOneWordInWordOrIdiom options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strMutableOneWordInWordOrIdiom length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
                } else if (intHideWordInScript == SMI_HIDE_WORD_KNOWN) {
                    if (intKnow >= 3) {
                        //아는단어는 표시하지 않는다.
                        NSString *strWordBlank = @"";
                        for (NSInteger i = 0; i < [strWord length]; ++i) {
                            strWordBlank = [NSString stringWithFormat:@"%@ ", strWordBlank];
                        }
                        [regEx2 replaceMatchesInString:strMutableOneWordInWordOrIdiom options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strMutableOneWordInWordOrIdiom length]) withTemplate:[NSString stringWithFormat:@"$1%@%@%@$3", strValueToChange1, strWordBlank, strValueToChange2]];
                        
                    } else {
                        [regEx2 replaceMatchesInString:strMutableOneWordInWordOrIdiom options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strMutableOneWordInWordOrIdiom length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
                    }
                }
            }

            [strMutableWordResult appendFormat:@"%@ ", strMutableOneWordInWordOrIdiom];
        }
    }
//    DLog(@"strMutableWordResult : %@", strMutableWordResult);
    
    return [NSString stringWithFormat:@"%@",strMutableWordResult];
}

- (void) back {
    
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(callBack:)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void) callBack:(NSTimer*)sender
{
    if (blnCountingPages == TRUE) {
        blnCancelCountingPage = TRUE;
    }
    [searchBarWebUrl resignFirstResponder];
    [txtMeaning resignFirstResponder];
    [txtBookName resignFirstResponder];
   
	[self.navigationController popViewControllerAnimated:YES];
    
    blnIsMoviePlaying = FALSE;
    self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
    [moviePlayer pause];
}

- (void) willEnterForeground:(NSNotification *) notif
{

}

#pragma mark -
#pragma mark WebStudyMode
- (void)selSegControl:(id)sender
{	
	UISegmentedControl *sel = (UISegmentedControl *)sender;
    if (sel.tag == 1) {
        //책읽기에서 Study, Word를 선택했을때...
        if( [sel selectedSegmentIndex] == 0 ){
            if (intViewType == viewTypeBook) {
                [self changeBookStudy];
            } else if (intViewType == viewTypeWeb) {
                [self changeWebStudy];
            }
        } else 	if( [sel selectedSegmentIndex] == 1 ){
            [self callOnOpenWordDetail];
        }
        
    } else if (sel.tag == 2) {
        //단어찾기에서 옵션을 선택했을때...
        if( [sel selectedSegmentIndex] == 0 ){
            //대소문자를 구분할지를 선택한다...
            blnCaseSensitive = !blnCaseSensitive;
            [sel setTitle:NSLocalizedString(@"CaseInsensitive", @"") forSegmentAtIndex:0];
            NSString *strMsg = NSLocalizedString(@"Search word in CaseInsensitive.", @"");
            if (blnCaseSensitive == TRUE) {
                [sel setTitle:NSLocalizedString(@"CaseSensitive", @"") forSegmentAtIndex:0];
                strMsg = NSLocalizedString(@"Search word in CaseSensitive.", @"");
            }
            
        } else 	if( [sel selectedSegmentIndex] == 1 ){
            //Headword를 포함할지를 선택한다.
            blnHeadword = !blnHeadword;
            [sel setTitle:NSLocalizedString(@"Word", @"") forSegmentAtIndex:1];
            NSString *strMsg = NSLocalizedString(@"Search exact same word", @"");
            if (blnHeadword == TRUE) {
                [sel setTitle:NSLocalizedString(@"Headword", @"") forSegmentAtIndex:1];
                strMsg = NSLocalizedString(@"Search with Headword", @"");
            }

        }
    }
}

-(void)hideViewDic
{
    self.viewDic.hidden = TRUE;
}

- (void) changeBookStudy
{

	if (intViewType == viewTypeBook ) {

		UIBarButtonItem *toAdd = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
		UISegmentedControl* segControl = (UISegmentedControl*)toAdd.customView;		
        
        self.tabBarViewModeBook.hidden = FALSE;
        [self.view bringSubviewToFront:tabBarViewModeBook];
        
		if ([strWebViewMode isEqualToString:@"STUDY"] == TRUE) {
			
            //일반모드로 들어올때...
            CGRect pageViewRect = self.view.bounds;
//            pageViewRect = CGRectInset(pageViewRect, 0.0, 44.0);
            pageViewRect.size.height -= (tabBarViewModeBook.frame.size.height + viewCurPage.frame.size.height);
            self.pageViewController.view.frame = pageViewRect;
            
			self.strWebViewMode = @"NORMAL";
			[segControl setTitle:NSLocalizedString(@"StudyMode", @"") forSegmentAtIndex:0];
			
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
            self.navigationItem.leftBarButtonItem = backButton;

            NSInteger intWebViewHeight = appHeight - naviBarHeight - self.tabBarViewModeBook.frame.size.height - self.viewCurPage.frame.size.height;
            if (playType == PlayTypeMovie) {
                if (blnResizeMovieBig == TRUE) {
                    intWebViewHeight -= self.viewMovie.frame.size.height;
                }
            }
            
            //애니메이션을 시작한다.
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];  
            
//			CGRect webViewFrame1 = CGRectMake(0.0, viewDic.frame.size.height, self.view.frame.size.width, intWebViewHeight);
//            [[arrWebView objectAtIndex:currWebView] setFrame:webViewFrame1];
            
            CGRect viewCurPageFrame = self.viewCurPage.frame;
            viewCurPageFrame.origin.y = self.view.bounds.size.height - self.viewCurPage.frame.size.height - self.tabBarViewModeBook.frame.size.height;
            self.viewCurPage.frame = viewCurPageFrame;	

            CGRect viewDicFrame = CGRectMake(0.0, -self.viewDic.frame.size.height, self.view.frame.size.width, self.viewDic.frame.size.height);
            self.viewDic.frame = viewDicFrame;
            
            [self performSelector:@selector(hideViewDic) withObject:self afterDelay:0.3];

            CGRect webViewFrame = CGRectMake(0.0, viewDic.frame.size.height, self.view.frame.size.width, intWebViewHeight);
            for (int i = 0; i < [arrWebView count]; ++i) {
                [[arrWebView objectAtIndex:i] setFrame:webViewFrame];
            }
        
            if (playType == PlayTypeMovie) {
                CGRect btnResizeMovieViewFrame = CGRectMake(self.view.frame.size.width - self.btnResizeMovieView.frame.size.width, viewCurPage.frame.origin.y, self.btnResizeMovieView.frame.size.width, self.btnResizeMovieView.frame.size.height);
                self.btnResizeMovieView.frame = btnResizeMovieViewFrame;	
                CGRect viewMovieFrame = CGRectMake(0.0, intWebViewHeight + viewCurPageFrame.size.height, self.view.frame.size.width, self.viewMovie.frame.size.height);
                self.viewMovie.frame = viewMovieFrame; 
                if (blnResizeMovieBig == TRUE) {
                    intWebViewHeight += self.viewMovie.frame.size.height;
                }
            }

            CGRect tabBarViewModeBookFrame = CGRectMake(0.0, self.view.frame.size.height-self.tabBarViewModeBook.frame.size.height, self.view.frame.size.width, self.tabBarViewModeBook.frame.size.height);
            self.tabBarViewModeBook.frame = tabBarViewModeBookFrame;
            
            if (blnWordSearchMode == TRUE) {
                [self.view bringSubviewToFront:viewWordSearchBackAndForward];
            }            
            if (viewWordSearchBackAndForward.hidden == FALSE) {
                [self.view bringSubviewToFront:viewWordSearchBackAndForward];
                self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight - naviBarHeight - viewWordSearchBackAndForward.frame.size.height - viewCurPage.frame.size.height - tabBarViewModeBook.frame.size.height, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);        
                
            }
            [UIView commitAnimations];
			
		} else {
			//스터디뷰모드로 들어올때...
            
            CGRect pageViewRect = self.view.bounds;
//            pageViewRect = CGRectInset(pageViewRect, 0.0, 0.0);
            pageViewRect.size.height -= (viewCurPage.frame.size.height + tabBarViewModeBook.frame.size.height);
            pageViewRect.origin.y = pageViewRect.origin.y + tabBarViewModeBook.frame.size.height;
            self.pageViewController.view.frame = pageViewRect;
            
            self.strWebViewMode = @"STUDY";
			[self showMeaningSelTxt:false];
			[segControl setTitle:NSLocalizedString(@"NormalMode", @"") forSegmentAtIndex:0];

            self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.hidesBackButton = TRUE;

            NSInteger intWebViewHeight = appHeight - naviBarHeight - viewDic.frame.size.height - self.viewCurPage.frame.size.height;
            DLog(@"appHeight : %d WEB HEIGHT %d", appHeight,intWebViewHeight);

            //애니메이션을 시작한다.
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f]; 
            
            if (playType == PlayTypeMovie) {
                if (blnResizeMovieBig == TRUE) {
                    intWebViewHeight -= self.viewMovie.frame.size.height;
                }
                CGRect viewMovieFrame = CGRectMake(0.0, self.viewDic.frame.size.height + intWebViewHeight + self.viewCurPage.frame.size.height, self.view.frame.size.width, self.viewMovie.frame.size.height);
                self.viewMovie.frame = viewMovieFrame;
            }

//            CGRect viewCurPageFrame = CGRectMake(0.0, self.viewDic.frame.size.height + intWebViewHeight, self.view.frame.size.width, self.viewCurPage.frame.size.height);
            
            CGRect viewCurPageFrame = self.viewCurPage.frame;
            viewCurPageFrame.origin.y = self.view.bounds.size.height - self.viewCurPage.frame.size.height;
            self.viewCurPage.frame = viewCurPageFrame;
            
//            self.viewCurPage.frame = viewCurPageFrame;
//            [self.view bringSubviewToFront:viewCurPage];
            CGRect btnResizeMovieViewFrame = CGRectMake(self.view.frame.size.width - self.btnResizeMovieView.frame.size.width, viewCurPage.frame.origin.y, self.btnResizeMovieView.frame.size.width, self.btnResizeMovieView.frame.size.height);
            self.btnResizeMovieView.frame = btnResizeMovieViewFrame;
//
//			CGRect webViewFrame1 = CGRectMake(0.0, 0, self.view.frame.size.width, intWebViewHeight);
//            [[arrWebView objectAtIndex:currWebView] setFrame:webViewFrame1];            

			self.viewDic.hidden = FALSE;
			CGRect viewDicFrame = CGRectMake(0.0,0, self.view.frame.size.width, self.viewDic.frame.size.height);
			self.viewDic.frame = viewDicFrame;			

            CGRect webViewFrame = CGRectMake(0.0, viewDic.frame.size.height, self.view.frame.size.width, intWebViewHeight);

            for (int i = 0; i < [arrWebView count]; ++i) {
                [[arrWebView objectAtIndex:i] setFrame:webViewFrame];                
            }
            
            viewPageNo.hidden = TRUE;		
			tabBarFont.hidden = TRUE;
			viewBackLight.hidden = TRUE;

            CGRect tabBarViewModeBookFrame = CGRectMake(0.0, appHeight, self.view.frame.size.width, self.tabBarViewModeBook.frame.size.height);
            self.tabBarViewModeBook.frame = tabBarViewModeBookFrame;			

            if (blnWordSearchMode == TRUE) {
                [self.view bringSubviewToFront:viewWordSearchBackAndForward];
            }
            
            if (viewWordSearchBackAndForward.hidden == FALSE) {
                [self.view bringSubviewToFront:viewWordSearchBackAndForward];
                self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight - naviBarHeight - viewWordSearchBackAndForward.frame.size.height - viewCurPage.frame.size.height, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);                
                
            }

            [UIView commitAnimations]; 
		}
	}
    [SVProgressHUD dismiss];
}

- (void) changeWebStudy
{
	UIBarButtonItem *toAdd = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
	UISegmentedControl* segControl = (UISegmentedControl*)toAdd.customView;	

	CATransition *ani = [CATransition animation];
	[ani setDelegate:self];
	[ani setDuration:0.5f];
	
	if (blnWebStudy == TRUE) {
        
		[segControl setTitle:NSLocalizedString(@"StudyMode", @"") forSegmentAtIndex:0];
		
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[ani setType:kCATransitionPush];
		[ani setSubtype:kCATransitionFromBottom];
		
        CGRect naviBarWebUrlFrame = CGRectMake(0.0, 0, self.view.frame.size.width, self.naviBarWebUrl.frame.size.height);
		self.naviBarWebUrl.frame = naviBarWebUrlFrame;						
		
		CGRect searchBarWebUrlFrame = CGRectMake(searchBarWebUrl.frame.origin.x, 0, self.view.frame.size.width , searchBarWebUrl.frame.size.height);
		self.searchBarWebUrl.frame = searchBarWebUrlFrame;
		
		[[naviBarWebUrl layer] addAnimation:ani forKey:@"transitionViewAnimation"];
		[[searchBarWebUrl layer] addAnimation:ani forKey:@"transitionViewAnimation"];
		self.viewDic.hidden = TRUE;
		[[viewDic layer] addAnimation:ani forKey:@"transitionViewAnimation"];

		NSInteger intWebViewHeight = appHeight - naviBarHeight - tabBarViewModeWeb.frame.size.height - naviBarWebUrl.frame.size.height;

		CGRect webViewFrame = CGRectMake(0.0, 0+naviBarWebUrl.frame.size.height, self.view.frame.size.width, intWebViewHeight);
		self.webViewWeb.frame = webViewFrame;
        
        DLog(@"webViewWeb.frame : %@", [NSValue valueWithCGRect:webViewWeb.frame]);
        DLog(@"tabBarViewModeWeb.frame : %@", [NSValue valueWithCGRect:tabBarViewModeWeb.frame]);
        
	} else {
    
		[segControl setTitle:NSLocalizedString(@"Web Mode", @"") forSegmentAtIndex:0];
        
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[ani setType:kCATransitionPush];
		[ani setSubtype:kCATransitionFromTop];
        CGRect naviBarWebUrlFrame = CGRectMake(0.0, -self.naviBarWebUrl.frame.size.height, self.view.frame.size.width, self.naviBarWebUrl.frame.size.height);
		self.naviBarWebUrl.frame = naviBarWebUrlFrame;	
        
        CGRect searchBarWebUrlFrame = CGRectMake(searchBarWebUrl.frame.origin.x, -searchBarWebUrl.frame.size.height, self.view.frame.size.width , searchBarWebUrl.frame.size.height);
		self.searchBarWebUrl.frame = searchBarWebUrlFrame;
	
		[[naviBarWebUrl layer] addAnimation:ani forKey:@"transitionViewAnimation"];
		[[searchBarWebUrl layer] addAnimation:ani forKey:@"transitionViewAnimation"];
		self.viewDic.hidden = FALSE;
		[[viewDic layer] addAnimation:ani forKey:@"transitionViewAnimation"];
		
		NSInteger intWebViewHeight = appHeight - naviBarHeight - tabBarViewModeWeb.frame.size.height - viewDic.frame.size.height;		
		CGRect webViewFrame = CGRectMake(0.0, viewDic.frame.size.height, self.view.frame.size.width, intWebViewHeight);
		self.webViewWeb.frame = webViewFrame;	
	}
	blnWebStudy = !blnWebStudy;
}

#pragma mark -
#pragma mark ShowAndHideControl
- (void) showViewTypeBook
{
    self.viewPageNo.hidden = TRUE;
    self.tabBarFont.hidden = TRUE;
    self.viewBackLight.hidden = TRUE;
    self.tabBarViewModeBook.hidden = FALSE;
    searchBarSearchWord.hidden = YES;
    
    for (int i = 0; i < [arrWebView count]; ++i) {
        [self.view bringSubviewToFront:[arrWebView objectAtIndex:i]];
    }
    
	[self.view bringSubviewToFront:tabBarFont];
	[self.view bringSubviewToFront:viewBackLight];
	[self.view bringSubviewToFront:viewPageNo];
	[self.view bringSubviewToFront:viewDic];
	
	NSInteger intViewDicHeight = 0;
    NSInteger intWebHeightMinusViewMovieHeight = 0;
    NSInteger intTabBarHeight = 0;
    
    if ([strWebViewMode isEqualToString:@"NORMAL"] == TRUE) {
        //Normal모드이면...
        intViewDicHeight = 0;
        intTabBarHeight = tabBarViewModeBook.frame.size.height;
        
		self.tabBarViewModeBook.hidden = FALSE;
    } else {
        //스터디 모드이면...
        intViewDicHeight = viewDic.frame.size.height;
        intTabBarHeight = 0;
        
        self.tabBarViewModeBook.hidden = TRUE;
        self.viewDic.hidden = FALSE;
    }
    
    //영화보기 모드이면 web의 세로길이를 viewMovie.frame.size.height만큼 빼준다.
    if ((playType == PlayTypeMovie) && (blnResizeMovieBig == TRUE)) {
        //Movie가 보이면...
        intWebHeightMinusViewMovieHeight = viewMovie.frame.size.height;
    }
    
    CGRect viewDicFrame = CGRectMake(0.0, 0, self.view.frame.size.width, self.viewDic.frame.size.height);
    self.viewDic.frame = viewDicFrame;	
    
    NSInteger intWebViewHeight = appHeight - naviBarHeight - intTabBarHeight - intViewDicHeight - intWebHeightMinusViewMovieHeight -self.viewCurPage.frame.size.height;
    
    CGRect webViewFrame = CGRectMake(0.0, intViewDicHeight, self.view.frame.size.width, self.view.frame.size.height-intTabBarHeight);
    for (int i = 0; i < [arrWebView count]; ++i) {
        [[arrWebView objectAtIndex:i] setFrame:webViewFrame];
    }
    [webViewWeb setFrame:webViewFrame];
    
//    CGRect viewCurPageFrame = CGRectMake(0.0, intViewDicHeight + intWebViewHeight, self.view.frame.size.width, self.viewCurPage.frame.size.height);
//    self.viewCurPage.frame = viewCurPageFrame;	
    
    CGRect viewBtnReisizeMovieFrame = CGRectMake(self.view.frame.size.width - btnResizeMovieView.frame.size.width, intViewDicHeight + intWebViewHeight, btnResizeMovieView.frame.size.width, btnResizeMovieView.frame.size.height);
    self.btnResizeMovieView.frame = viewBtnReisizeMovieFrame;
    [self.view bringSubviewToFront:btnResizeMovieView];
    
    CGRect viewMovieFrame = CGRectMake(0.0, intViewDicHeight + intWebViewHeight + viewCurPage.frame.size.height, self.view.frame.size.width, self.viewMovie.frame.size.height);
    self.viewMovie.frame = viewMovieFrame;

    CGRect tabBarViewModeBookFrame = CGRectMake(0.0, self.view.frame.size.height - tabBarViewModeBook.frame.size.height, self.view.frame.size.width, self.tabBarViewModeBook.frame.size.height);
    
    self.tabBarViewModeBook.frame = tabBarViewModeBookFrame;
    [self.view bringSubviewToFront:tabBarViewModeBook];
    
    //Frame of viewCurPageFrame *********************
    CGRect viewCurPageFrame = self.viewCurPage.frame;
    if ([strWebViewMode isEqualToString:@"NORMAL"]) {
        viewCurPageFrame.origin.y = self.view.bounds.size.height - self.viewCurPage.frame.size.height - self.tabBarViewModeBook.frame.size.height;
    }else{
    
        viewCurPageFrame.origin.y = self.view.bounds.size.height - self.viewCurPage.frame.size.height;
    }
    self.viewCurPage.frame = viewCurPageFrame;
    
//    CGRect tabBarFontFrame1 = CGRectMake(0.0, naviBarHeight + intWebViewHeight + viewCurPage.frame.size.height - self.tabBarFont.frame.size.height, self.view.frame.size.width, self.tabBarFont.frame.size.height);
//    CGRect tabBarFontFrame = CGRectMake(0.0, appHeight - naviBarHeight - tabbarHeight - tabBarFont.frame.size.height, self.view.frame.size.width, self.tabBarFont.frame.size.height);
//	DLog(@"tabBarFontFrame1 : %@", [NSValue valueWithCGRect:tabBarFontFrame1]);
//	DLog(@"tabBarFontFrame : %@", [NSValue valueWithCGRect:tabBarFontFrame]);    

    
    //Frame of tabBarFontFrame *********************
    CGRect tabBarFontFrame = self.tabBarFont.frame;
    tabBarFontFrame.origin.y = self.view.bounds.size.height - tabBarFontFrame.size.height - self.tabBarViewModeBook.frame.size.height;
    self.tabBarFont.frame = tabBarFontFrame;
    
//    CGRect viewBackLightFrame = CGRectMake(0.0, intWebViewHeight + viewCurPage.frame.size.height - self.tabBarFont.frame.size.height - self.viewBackLight.frame.size.height, self.view.frame.size.width, self.viewBackLight.frame.size.height);
//    self.viewBackLight.frame = viewBackLightFrame;
    
    CGRect viewBackLightFrame = self.viewBackLight.frame;
    viewBackLightFrame.origin.y = tabBarFontFrame.origin.y - viewBackLightFrame.size.height;
    self.viewBackLight.frame = viewBackLightFrame;

    CGRect viewPageNoFrame = CGRectMake(0.0, 0, self.view.frame.size.width, self.viewPageNo.frame.size.height);
    self.viewPageNo.frame = viewPageNoFrame;
    
//    CGRect viewPreviewReviewFrame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewPickerNextPrevPages.frame.size.height);
//    self.viewPickerNextPrevPages.frame = viewPreviewReviewFrame;
    
    //웹URL은 웹모드시에만 보여준다.
    naviBarWebUrl.hidden = TRUE;
    searchBarWebUrl.hidden = true;
    
    
    [self.view bringSubviewToFront:[arrWebView objectAtIndex:currWebView]];
    
	[self showMeaningSelTxt:TRUE];	
    
    //맨처음연것이 아니고 뜻을 달때는 아래를 한다.
    if ( (blnFirstOpen == FALSE) && (blnShowUnknowWords == TRUE) ) {
        //페이지를 세는중에는 안한다.
        if (blnCountingPages == FALSE) {
            
            intCSSVersion++;
            blnDoSTHToChangeFront = TRUE;
            [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
        }
    }    
    blnFirstOpen = FALSE;
}

- (void) showViewTypeWeb
{
	[self.view bringSubviewToFront:webViewWeb];
	[self.view bringSubviewToFront:viewDic];
	[self.view bringSubviewToFront:naviBarWebUrl];	
	[self.view bringSubviewToFront:searchBarWebUrl];
	[self.view bringSubviewToFront:tabBarViewModeWeb];
    [self.view bringSubviewToFront:webIndicator];
	
	self.searchBarWebUrl.text = _strMutableURL;
	if (blnOpenBookmark == TRUE) {
		[self gotoAddress:nil];
	}
	blnOpenBookmark = FALSE;
	
	NSInteger intWebViewHeight = appHeight - naviBarHeight - tabBarViewModeWeb.frame.size.height - naviBarWebUrl.frame.size.height;
	if (viewDic.hidden == TRUE) {
		
		intWebViewHeight = appHeight - naviBarHeight - tabBarViewModeWeb.frame.size.height - naviBarWebUrl.frame.size.height;
		CGRect webViewFrame = CGRectMake(0.0, 0+naviBarWebUrl.frame.size.height, self.view.frame.size.width, intWebViewHeight);
		self.webViewWeb.frame = webViewFrame;				
		
		CGRect tabBarViewModeWebFrame = CGRectMake(0.0, self.view.frame.size.height-tabBarViewModeWeb.frame.size.height, self.view.frame.size.width, self.tabBarViewModeWeb.frame.size.height);
		self.tabBarViewModeWeb.frame = tabBarViewModeWebFrame;	
		
        DLog(@"tabBarViewModeWeb.frame : %@", [NSValue valueWithCGRect:tabBarViewModeWeb.frame]);
        
		CGRect naviBarWebUrlFrame = CGRectMake(0.0, 0, self.view.frame.size.width, self.naviBarWebUrl.frame.size.height);
		self.naviBarWebUrl.frame = naviBarWebUrlFrame;						
		
		CGRect searchBarWebUrlFrame = CGRectMake(searchBarWebUrl.frame.origin.x, 0, self.view.frame.size.width , searchBarWebUrl.frame.size.height);
		self.searchBarWebUrl.frame = searchBarWebUrlFrame;
		naviBarWebUrl.hidden = FALSE;
		searchBarWebUrl.hidden = FALSE;
		
	} else {
		
		CGRect viewDicFrame = CGRectMake(0.0, 0, self.view.frame.size.width, self.viewDic.frame.size.height);
		self.viewDic.frame = viewDicFrame;	
        
    DLog(@"intWebViewHeight : %d", intWebViewHeight);
		intWebViewHeight = appHeight - naviBarHeight - viewDic.frame.size.height - tabBarViewModeWeb.frame.size.height;
    DLog(@"intWebViewHeight : %d", intWebViewHeight);        
		CGRect webViewFrame = CGRectMake(0.0, viewDic.frame.size.height, self.view.frame.size.width, intWebViewHeight);
		self.webViewWeb.frame = webViewFrame;				
		
        CGRect tabBarViewModeWebFrame = CGRectMake(0.0, self.view.frame.size.height-tabBarViewModeWeb.frame.size.height, self.view.frame.size.width, self.tabBarViewModeWeb.frame.size.height);
		self.tabBarViewModeWeb.frame = tabBarViewModeWebFrame;
        DLog(@"tabBarViewModeWeb.frame : %@", [NSValue valueWithCGRect:tabBarViewModeWeb.frame]);
        
        
        CGRect naviBarWebUrlFrame = CGRectMake(0.0, -self.naviBarWebUrl.frame.size.height, self.view.frame.size.width, self.naviBarWebUrl.frame.size.height);
		self.naviBarWebUrl.frame = naviBarWebUrlFrame;	
        
        CGRect searchBarWebUrlFrame = CGRectMake(0.0, -searchBarWebUrl.frame.size.height, self.view.frame.size.width , searchBarWebUrl.frame.size.height);

		self.searchBarWebUrl.frame = searchBarWebUrlFrame;
        
		self.viewDic.hidden = FALSE;

    DLog(@"viewDicFrame : %@", [NSValue valueWithCGRect:viewDicFrame]);
    DLog(@"webViewFrame : %@", [NSValue valueWithCGRect:webViewFrame]);
    DLog(@"tabBarViewModeWebFrame : %@", [NSValue valueWithCGRect:tabBarViewModeWebFrame]);
    DLog(@"naviBarWebUrlFrame : %@", [NSValue valueWithCGRect:naviBarWebUrlFrame]);
    DLog(@"searchBarWebUrlFrame : %@", [NSValue valueWithCGRect:searchBarWebUrlFrame]);

	}
	webViewWeb.hidden = FALSE;
	tabBarViewModeWeb.hidden = FALSE;
    
	[self showMeaningSelTxt:TRUE];	
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void) tapMovieAction:(id)ignored
{
    DLog(@"tapMovieAction");
    DLog(@"id : %@", ignored);

    [self onBtnMoviePlay:nil];
}

- (void) tap2MovieAction:(id)ignored
{
    DLog(@"tap2MovieAction");
    DLog(@"id : %@", ignored);
    if (intHideWordInScript == SMI_HIDE_WORD_ALL) {
        intHideWordInScript = SMI_HIDE_WORD_NONE;
    } else if (intHideWordInScript == SMI_HIDE_WORD_NONE) {
        intHideWordInScript = SMI_HIDE_WORD_KNOWN;
    } else if (intHideWordInScript == SMI_HIDE_WORD_KNOWN) {
        intHideWordInScript = SMI_HIDE_WORD_ALL;
    }
    [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
}

- (void) twoTapMovieAction:(id)ignored
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    DLog(@"twoTapMovieAction");
    DLog(@"id : %@", ignored);
    
    viewOneInMovie.hidden = !viewOneInMovie.hidden;
    viewTwoInMovie.hidden = !viewTwoInMovie.hidden;
    btnMoviePlayOrStop.hidden = !btnMoviePlayOrStop.hidden;
    btnRepeatStartPoint.hidden = !btnRepeatStartPoint.hidden;
    btnRepeatEndPoint.hidden = !btnRepeatEndPoint.hidden;
    btnEndRepeat.hidden = !btnEndRepeat.hidden;
    btnMoviePlayRate.hidden = !btnMoviePlayRate.hidden;     
    btnInfo.hidden = !btnInfo.hidden;
    btnShowScript.hidden = !btnShowScript.hidden;
}

- (void)swipeRightMovieAction:(id)ignored
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    DLog(@"moviePlayer.currentPlaybackTim : %f", moviePlayer.currentPlaybackTime);    
    DLog(@"moviePlayer.currentPlaybackTim - 10 : %f", moviePlayer.currentPlaybackTime - 10);        
    if ((moviePlayer.currentPlaybackTime - 10) <= 0 ) {
        moviePlayer.currentPlaybackTime = 0.0001f;
        DLog(@"moviePlayer.currentPlaybackTime 0 : %f", moviePlayer.currentPlaybackTime);        
    } else {
        moviePlayer.currentPlaybackTime -= 10;
    }

    blnMovieSwipe = TRUE;
}

- (void)swipeLeftMovieAction:(id)ignored
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    
    DLog(@"moviePlayer.currentPlaybackTim : %f", moviePlayer.currentPlaybackTime);      
    moviePlayer.currentPlaybackTime += 10;    
    self._currentPalyBackTime = moviePlayer.currentPlaybackTime;

    blnMovieSwipe = TRUE;    
}

- (void)swipeUpMovieAction:(id)ignored
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    

    moviePlayer.currentPlaybackTime -= 360;   
    self._currentPalyBackTime = moviePlayer.currentPlaybackTime;

    blnMovieSwipe = TRUE;    
}

- (void)swipeDownMovieAction:(id)ignored
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    moviePlayer.currentPlaybackTime += 360;      
}
- (void)swipeRightAction:(id)ignored
{

}
- (void)swipeLeftAction:(id)ignored
{

}

- (void)myPanGR:(UIPanGestureRecognizer*)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    if ((playType == PlayTypeMovie) && (blnResizeMovieBig == TRUE)) {
        return;
    }
    [self changeBookStudy];
}
- (void) someReceiver:(id)theObject
{
    NSString *strTap = theObject;
    
    if (blnSelWord == TRUE) {
        blnSelWord = FALSE;
    } else {
        CGPoint p = CGPointFromString(strTap);
        NSString *pos = nil;
        DLog(@"%@ tapped1", NSStringFromCGPoint(p));
        DLog(@"p.x : %f", p.x);
        DLog(@"self.view.frame.size.width  : %f", (float)self.view.frame.size.width);    
        DLog(@"(2/3) : %f", 2/3.0);    
        DLog(@"self.view.frame.size.width * (2/3) : %f", (float)((float)self.view.frame.size.width) * (float)(2/3));
        DLog(@"self.view.frame.size.width * (1/3) : %f", (float)((float)self.view.frame.size.width) * (float)(1/3));    
        if (p.x > (self.view.frame.size.width * (2/3.0)) ) {
            pos = @"Right";
        } else if (p.x < (self.view.frame.size.width * (1/3.0)) ) {
            pos = @"Left";
        } else {
            pos = @"Center";
        }

        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@",pos]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];

    }
}

-(void) handleLongPress:(UILongPressGestureRecognizer *)recognizer  {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(someReceiver:) object:nil];
}

#pragma mark -
#pragma mark 페이지 정보 가져오기
- (void) callGetAllPagesInfo
{
    lblShowMeaning.hidden = TRUE;
    
        if ([strBookFileNameExtension isEqualToString:fileExtension_EPUB] == YES){
            [NSThread detachNewThreadSelector:@selector(getAllPagesInfoEPub:) toTarget:self withObject:nil];
        } else {
            [NSThread detachNewThreadSelector:@selector(getAllPagesInfo:) toTarget:self withObject:nil];            
        }
    return;    
}

- (void) getAllPagesInfo:(NSObject*)obj
{
    @autoreleasepool {

    lblCurPage.hidden = FALSE;
	blnCountingPages = TRUE;
    blnCancelCountingPage = FALSE;
    
    [arrPageInfo removeAllObjects];
        
    //현재 책의 페이지 정보를 저장하는 테이블을 만든다.
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_PageInfoTbl];
    [myCommon changeRec:strQuery openMyDic:FALSE];
    
    NSMutableArray *arrPageTemp = [[NSMutableArray alloc] init];
    NSUInteger maxLength = [strAllContentsInFile length];   
    NSUInteger len = 38 * 13;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        len = 38 * 13 * 3;
    }

#ifdef CHINESE
        len = 38 * 5;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            len = 38 * 5 * 3;
        }
        
#endif
        
    if (len > maxLength) {
        len = maxLength;
    }
    //    len *= 3;
    NSInteger stringOffset = 0;
    NSInteger pageNo = 0;
    NSInteger start = 0;
    do {
        if (blnCancelCountingPage == TRUE) {
//            [pool release];
            return;
        }
        
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
        [dicOne setObject:[NSNumber numberWithInt:pageNo++] forKey:@"PageNo"];
        [dicOne setObject:[NSNumber numberWithInt:stringOffset] forKey:@"OffsetStart"];        
        start = stringOffset;
            
        stringOffset += len;
        
        if (stringOffset >= maxLength) {        
            //offset이 책 전체를 뛰어넘지 않게...
            stringOffset = maxLength;
        }

            NSString *strContentForOnePage = nil;
            if ((maxLength - stringOffset) > (len/2)) {
                strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(stringOffset, len/2)];                
            } else {
                NSInteger lenTemp = maxLength - stringOffset;
                strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(stringOffset, lenTemp)];
            }
        
            NSInteger offsetFirstNewLine = 0;
            NSRange rangeNewLine1 = [strContentForOnePage rangeOfString:@"\n"];
            if( rangeNewLine1.location != NSNotFound) {
                offsetFirstNewLine = rangeNewLine1.location;
            }
            NSRange rangeNewLine3 = [strContentForOnePage rangeOfString:@"\r"];
            if( rangeNewLine3.location != NSNotFound) {
                offsetFirstNewLine = rangeNewLine3.location;
            }
            NSRange rangeNewLine2 = [strContentForOnePage rangeOfString:@"\r\n"];
            if( rangeNewLine2.location != NSNotFound) {
                offsetFirstNewLine = rangeNewLine2.location;
            }

            
            if (offsetFirstNewLine == 0) {
                NSRange rangeDot = [strContentForOnePage rangeOfString:@". "];
                if( rangeDot.location != NSNotFound) {
                    stringOffset += rangeDot.location+2;
                } else {                        
                    NSRange rangeTemp = [strContentForOnePage rangeOfString:@"\" "];
                    if( rangeTemp.location != NSNotFound) {
                        stringOffset += rangeTemp.location + 2;
                    } else {     
                        NSRange rangeTemp1 = [strContentForOnePage rangeOfString:@", "];
                        if( rangeTemp1.location != NSNotFound) {
                            stringOffset += rangeTemp1.location + 2;
                        } else {                   
                            NSRange rangeBlank = [strContentForOnePage rangeOfString:@" "];
                            if( rangeBlank.location != NSNotFound) {
                                stringOffset += rangeBlank.location + 1;
                            }       
                        }
                    }
                }
                
            } else {
                //연속되는 뉴라인은 앞장에서 처리할려구...
                stringOffset += offsetFirstNewLine;
//                DLog(@"offsetFirstNewLine : %d", offsetFirstNewLine);
                for (int i = 0; i < ((len/2) - offsetFirstNewLine); ++i) {
                    if ([strContentForOnePage length] <= (offsetFirstNewLine + i + 1)) {
                        break;
                    }
                    NSString *strChar = [strContentForOnePage substringWithRange:NSMakeRange(offsetFirstNewLine+i, 1)];
                    if ( ([strChar isEqualToString:@"\r"]) || ([strChar isEqualToString:@"\n"]) || ([strChar isEqualToString:@"\r\n"]) ) {
                        stringOffset++;
                    } else {
                        break;                                                                    
                    }
                }
                
            }

        [dicOne setObject:[NSNumber numberWithInt:stringOffset] forKey:@"OffsetEnd"];  
     
        [arrPageInfo addObject:dicOne];
        [arrPageTemp addObject:dicOne];
        
        float	fVal = stringOffset / ((float)maxLength);
        if ( (fVal <= 0) || (fVal >= 1) ) {
            fVal = 1.0f;
        }
        NSString *strFVal = [NSString stringWithFormat:@"%.1f%%", (fVal*100)];
        NSString *strMsg = [NSString stringWithFormat:@"Counting pages... %@", strFVal];
//        lblShowMeaning.hidden = TRUE;
        [self performSelectorOnMainThread:@selector(updateGetAllPageInfo:) withObject:strFVal waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];
        if ((pageNo % 2) == 0) {
//            DLog(@"arrPageTemp : %@", arrPageTemp);
            self.slidePageNo.maximumValue = pageNo;
            [self performSelectorOnMainThread:@selector(savePageInfo:) withObject:arrPageTemp waitUntilDone:YES];
            [arrPageTemp removeAllObjects];
        }

        if (stringOffset >= maxLength) {        
            stringOffset = maxLength;
            break;
        }        
        
        if (pageNo == 2) {
            currPageNo = 0;
            currPageNoToGo = currPageNo;

            [self performSelectorOnMainThread:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] waitUntilDone:NO];
        }
    } while (TRUE);
    DLog(@"pageNo : %d",  pageNo);
    //만약 2페이지 이하 짜리이면 여기서 다시 한번 읽어준다.
    if (pageNo <= 2) {
        currPageNo = 0;
        currPageNoToGo = currPageNo;

        [self performSelectorOnMainThread:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(savePageInfo:) withObject:arrPageTemp waitUntilDone:YES];

    NSString	*strUpdateQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_AllPage, pageNo, FldName_BOOK_LIST_BookLength, [strAllContentsInFile length], FldName_BOOK_LIST_ID, intBookTblNo];         
 
    [myCommon changeRec:strUpdateQuery openMyDic:TRUE];

    
    self.slidePageNo.maximumValue = [arrPageInfo count];
    lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];

        self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo + 1, (NSInteger) slidePageNo.maximumValue];        

    lblShowMeaning.hidden = FALSE;

    [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
	actionSheetProgress = nil;
	progressViewInActionSheet = nil;
    DLog(@"currPageNo : %d", currPageNo);
    self.navigationItem.title = NSLocalizedString(@"Book Mode", @"");
    
    blnCountingPages = FALSE;
        
    }
    [SVProgressHUD dismiss];
    
    if ([self.htmlPages count])    return;
    
    if ([arrPageInfo count]) {
        [SVProgressHUD showProgress:0 status:@"Loading"];
        dispatch_async(queue, ^{
            [self createHtmlPages];
        });
    }
    
    return;
}

//HTML형식의 BODY를 가져오게 하는것.... 아직 수정중임....
- (void) getAllPagesInfoEPub1:(NSObject*)obj
{
    @autoreleasepool {
        
        lblCurPage.hidden = FALSE;
        blnCountingPages = TRUE;
        blnCancelCountingPage = FALSE;
        
        [arrPageInfo removeAllObjects];
        
        //현재 책의 페이지 정보를 저장하는 테이블을 만든다.
        NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_PageInfoTbl];
        [myCommon changeRec:strQuery openMyDic:FALSE];
        strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_ChapterInfo];
        [myCommon changeRec:strQuery openMyDic:FALSE];
        
        //    [myCommon createSavePageInfoTableIfNotExist];
        
        NSInteger pageNo = 0;
        
        //EPub파일일때는 모든내용을 합쳐서 하나의 txt(HTML Tag가 존재하는)로 만든다.
        NSMutableString *strBodyAll = [[NSMutableString alloc] init];
        [_arrEPubChapter removeAllObjects];
        
        for (NSInteger i = 0; i < [_ePubContent._spine count]; i++) {
            self._pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:i]]];
            NSMutableString *strAllTemp  = [myCommon readTxtWithEncoding:_pagesPath];            
            DLog(@"strAllTemp : %@", strAllTemp);
            NSString *str1 = [self GetBodyHTMLFromHTML:strAllTemp];
            DLog(@"str1 length : %d", [str1 length]);
            DLog(@"\n\n====str1====\n'%@'", str1);

            [strBodyAll appendString:[NSString stringWithFormat:@"%@\r", str1]];
          
        }
        strAllContentsInFile = [NSString stringWithFormat:@"%@", strBodyAll];
        [self performSelectorOnMainThread:@selector(savePageInfo:) withObject:arrPageInfo waitUntilDone:YES];          
        
        //여기서 strBookFileName을 epub에서 txt로 바꾸어준다. (경로도 Documents폴더에서 압축을 푼 폴더로 들어간다.)
        DLog(@"strBookFileName : %@", strBookFullFileName);
        strBookFullFileName = [NSString stringWithFormat:@"%@/%@/%@.%@", [myCommon getDocPath], self.ePubDirName,self.ePubDirName, fileExtension_TXT];
        DLog(@"strBookFileName : %@", strBookFullFileName);
        
        
        //페이지를 다시 읽기 시작하면 일단 기존책을 지우고 다시 만든다.
        [fm removeItemAtPath:strBookFullFileName error:nil];
        [strAllContentsInFile writeToFile:strBookFullFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];	
        
        //BOOK_LIST에 전체페이지의 수를 업데이트 한다.
        NSString	*strUpdateQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_AllPage, pageNo, FldName_BOOK_LIST_ID, intBookTblNo]; 
        [myCommon changeRec:strUpdateQuery openMyDic:TRUE];
        
        
        self.slidePageNo.maximumValue = [arrPageInfo count];
        lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];
        self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];
        lblShowMeaning.hidden = FALSE;
        //    
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;
        DLog(@"currPageNo : %d", currPageNo);
        self.navigationItem.title = NSLocalizedString(@"Book Mode", @"");
        
        blnCountingPages = FALSE;
        [SVProgressHUD dismiss];
        
        return;  
    }
    [SVProgressHUD dismiss];
}


// 페이지 제대로 나누어 주는것, 지우지말것
- (void) getAllPagesInfoEPub:(NSObject*)obj
{
    @autoreleasepool {
        
        lblCurPage.hidden = FALSE;
        blnCountingPages = TRUE;
        blnCancelCountingPage = FALSE;
        
        [arrPageInfo removeAllObjects];
        
        //현재 책의 페이지 정보를 저장하는 테이블을 만든다.
        NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_PageInfoTbl];
        [myCommon changeRec:strQuery openMyDic:FALSE];
        strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_ChapterInfo];
        [myCommon changeRec:strQuery openMyDic:FALSE];
        
        //    [myCommon createSavePageInfoTableIfNotExist];
        
        
        
        NSInteger stringOffsetAllText = 0;
        NSInteger pageNo = 0;
        NSUInteger maxLength = 0;
        
        NSInteger chapterStartPage = 0;
        NSInteger chapterEndPage = 0;
        //EPub파일일때는 모든내용을 합쳐서 하나의 txt로 만든다.
        NSMutableArray *arrBodyAll = [[NSMutableArray alloc] init];
        NSMutableString *strBodyAll = [[NSMutableString alloc] init];
        [_arrEPubChapter removeAllObjects];
        
        for (NSInteger i = 0; i < [_ePubContent._spine count]; i++) {
            self._pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:i]]];
//            DLog(@"_pagesPath : %@", _pagesPath);
            NSMutableString *strMutablePagePth = [NSMutableString stringWithString:_pagesPath];
            [strMutablePagePth replaceOccurrencesOfString:@"%20" withString:@" "
                                                                  options:NSLiteralSearch range:NSMakeRange(0, [strMutablePagePth length])];
//            DLog(@"_pagesPath : %@", strMutablePagePth);
            
            NSMutableString *strAllTemp  = [myCommon readTxtWithEncoding:[NSString stringWithFormat:@"%@", strMutablePagePth]];            
//            DLog(@"strAllTemp : %@", strAllTemp);
            NSString *strBody = [self GetBodyTextFromHTML:strAllTemp];
            NSMutableString *strMutableBody = [NSMutableString stringWithString:strBody];
            int cntTemp = 0;
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#233;" withString:@"é"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
//            DLog(@"cntTemp : %d", cntTemp);

            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8211;" withString:@"–"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8212;" withString:@"—"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8216;" withString:@"‘"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8217;" withString:@"’"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8218;" withString:@"‚"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8220;" withString:@"“"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8221;" withString:@"”"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8222;" withString:@"„"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8224;" withString:@"†"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8225;" withString:@"‡"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8226;" withString:@"•"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8230;" withString:@"…"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8240;" withString:@"‰"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8264;" withString:@"€"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#8282;" withString:@"™"
                                                         options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
            
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&#169;" withString:@"©"
                                               options:NSLiteralSearch range:NSMakeRange(0, [strMutableBody length])];
//            DLog(@"cntTemp : %d", cntTemp);
            
            cntTemp = [strMutableBody replaceOccurrencesOfString:@"&nbsp;" withString:@" "
                                               options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strMutableBody length])];
//            DLog(@"cntTemp : %d", cntTemp);
            
            strBody = [NSString stringWithFormat:@"%@", strMutableBody];
            
            [arrBodyAll addObject:strBody];
            
//            DLog(@"strBody length : %d", [strBody length]);
//            DLog(@"\n\n====strBody====\n'%@'", strBody);
            [strBodyAll appendString:[NSString stringWithFormat:@"%@\r", strBody]];
            
            
            chapterEndPage = chapterStartPage + [strBody length];
            
            //ChapterInfo테이블에 챕터의 정보(시작 페이지와 끝페이지정보)를 넣어준다.
            NSString *strChapterNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:[self._ePubContent._spine objectAtIndex:i]];
            NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@) VALUES(%d,'%@',%d,%d)", TBL_ChapterInfo, FldName_Chapter, FldName_ChapterName, FldName_START, FldName_END, i, strChapterNameForSQL, chapterStartPage, chapterEndPage];
            [myCommon changeRec:strQuery openMyDic:FALSE];
            NSMutableDictionary *dicOneChapterInfo = [[NSMutableDictionary alloc] init];
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:i] forKey:@"CHAPTER"];
            [dicOneChapterInfo setValue:[_ePubContent._spine objectAtIndex:i] forKey:@"CHAPTER_NAME"];            
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:chapterStartPage] forKey:@"START"];
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:chapterEndPage] forKey:@"END"];
            [_arrEPubChapter addObject:dicOneChapterInfo];
            
            chapterStartPage = chapterEndPage;
            
        }
                            
        strAllContentsInFile = [NSString stringWithFormat:@"%@", strBodyAll];
        
            
            //각 채터의 Txt를 돌면서 페이지를 나눈다.
            NSMutableArray *arrPageTemp = [[NSMutableArray alloc] init];
            NSInteger stringOffset = 0;
            maxLength = [strAllContentsInFile length]; 
            NSUInteger len = 38 * 13;
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                len = 38 * 13 * 3;
            }
#ifdef CHINESE
        len = 38 * 5;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            len = 38 * 5 * 3;
        }
#endif
        
            if (len >= maxLength) {
                len = maxLength;
            }
            
            do {
                if (blnCancelCountingPage == TRUE) {
                    return;
                }
                
                NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
                [dicOne setObject:[NSNumber numberWithInt:pageNo++] forKey:@"PageNo"];
                [dicOne setObject:[NSNumber numberWithInt:stringOffset] forKey:@"OffsetStart"];        

                stringOffset += len;
                
                if (stringOffset >= maxLength) {        
                    //offset이 책 전체를 뛰어넘지 않게...
                    stringOffset = maxLength;
                }

                    NSString *strContentForOnePage = nil;
                    if ((maxLength - stringOffset) > (len/2)) {
                        strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(stringOffset, len/2)];                
                    } else {
                        NSInteger lenTemp = maxLength - stringOffset;
                        strContentForOnePage = [strAllContentsInFile substringWithRange: NSMakeRange(stringOffset, lenTemp)];
                    }
                    
                    NSInteger offsetFirstNewLine = 0;
                    NSRange rangeNewLine1 = [strContentForOnePage rangeOfString:@"\n"];
                    if( rangeNewLine1.location != NSNotFound) {
                        offsetFirstNewLine = rangeNewLine1.location;
                    }
                    NSRange rangeNewLine3 = [strContentForOnePage rangeOfString:@"\r"];
                    if( rangeNewLine3.location != NSNotFound) {
                        offsetFirstNewLine = rangeNewLine3.location;
                    }
                    NSRange rangeNewLine2 = [strContentForOnePage rangeOfString:@"\r\n"];
                    if( rangeNewLine2.location != NSNotFound) {
                        offsetFirstNewLine = rangeNewLine2.location;
                    }
                    
                    
                    if (offsetFirstNewLine == 0) {
                        NSRange rangeDot = [strContentForOnePage rangeOfString:@". "];
                        if( rangeDot.location != NSNotFound) {
                            stringOffset += rangeDot.location+2;
                        } else {                        
                            NSRange rangeTemp = [strContentForOnePage rangeOfString:@"\" "];
                            if( rangeTemp.location != NSNotFound) {
                                stringOffset += rangeTemp.location + 2;
                            } else {     
                                NSRange rangeTemp1 = [strContentForOnePage rangeOfString:@", "];
                                if( rangeTemp1.location != NSNotFound) {
                                    stringOffset += rangeTemp1.location + 2;
                                } else {                   
                                    NSRange rangeBlank = [strContentForOnePage rangeOfString:@" "];
                                    if( rangeBlank.location != NSNotFound) {
                                        stringOffset += rangeBlank.location + 1;
                                    }       
                                }
                            }
                        }
                        
                    } else {
                        //연속되는 뉴라인은 앞장에서 처리할려구...
                        stringOffset += offsetFirstNewLine;
                        //                DLog(@"offsetFirstNewLine : %d", offsetFirstNewLine);
                        for (int i = 0; i < ((len/2) - offsetFirstNewLine); ++i) {
                            if ([strContentForOnePage length] <= (offsetFirstNewLine + i + 1)) {
                                break;
                            }
                            NSString *strChar = [strContentForOnePage substringWithRange:NSMakeRange(offsetFirstNewLine+i, 1)];
                            if ( ([strChar isEqualToString:@"\r"]) || ([strChar isEqualToString:@"\n"]) || ([strChar isEqualToString:@"\r\n"]) ) {
                                stringOffset++;
                            } else {
                                break;                                                                    
                            }
                        }
                        
                    }

                [dicOne setObject:[NSNumber numberWithInt:(stringOffsetAllText+stringOffset)] forKey:@"OffsetEnd"];  
                
                [arrPageInfo addObject:dicOne];
                [arrPageTemp addObject:dicOne];                
                
                float	fVal = stringOffset / ((float)maxLength);
                if ( (fVal <= 0) || (fVal >= 1) ) {
                    fVal = 1.0f;
                }
                NSString *strFVal = [NSString stringWithFormat:@"%.1f%%", (fVal*100)];
                NSString *strMsg = [NSString stringWithFormat:@"Counting pages... %@", strFVal];
                //        lblShowMeaning.hidden = TRUE;
                [self performSelectorOnMainThread:@selector(updateGetAllPageInfo:) withObject:strFVal waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];
                
                //페이지정보를 매 2번째 페이지마다 저장한다.(실시간 저장으로 할려고...)
                if ((pageNo % 2) == 0) {            
                    //                    DLog(@"arrPageTemp : %@", arrPageTemp);
                    self.slidePageNo.maximumValue = pageNo;
                    [self performSelectorOnMainThread:@selector(savePageInfo:) withObject:arrPageTemp waitUntilDone:YES];
                    [arrPageTemp removeAllObjects];
                }
                
                if (stringOffset >= maxLength) {        
                    stringOffset = maxLength;
                    break;
                }        
                
                if (pageNo == 2) {
                    currPageNo = 0;
                    currPageNoToGo = currPageNo;
                    [self performSelectorOnMainThread:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] waitUntilDone:NO];
                }
            } while (TRUE);            

        
        //만약 2페이지 이하 짜리이면 여기서 다시 한번 읽어준다.
        if (pageNo <= 2) {
            currPageNo = 0;
            currPageNoToGo = currPageNo;
            [self performSelectorOnMainThread:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] waitUntilDone:NO];
        }
        
        [self performSelectorOnMainThread:@selector(savePageInfo:) withObject:arrPageInfo waitUntilDone:YES];          
        
        //여기서 strBookFileName을 epub에서 txt로 바꾸어준다. (경로도 Caches폴더에서 압축을 푼 폴더로 들어간다.)
        DLog(@"strBookFileName : %@", strBookFullFileName);
        strBookFullFileName = [NSString stringWithFormat:@"%@/%@/%@.%@", [myCommon getCachePath], self.ePubDirName,self.ePubDirName, fileExtension_TXT];
        DLog(@"strBookFileName : %@", strBookFullFileName);
        
        
        //페이지를 다시 읽기 시작하면 일단 기존책을 지우고 다시 만든다.
        [fm removeItemAtPath:strBookFullFileName error:nil];
        [strAllContentsInFile writeToFile:strBookFullFileName atomically:NO encoding:NSUTF8StringEncoding error:nil];	
        
        //BOOK_LIST에 전체페이지의 수 및 파일용량을 업데이트 한다.
        NSString	*strUpdateQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_AllPage, pageNo, FldName_BOOK_LIST_BookLength, [strAllContentsInFile length], FldName_BOOK_LIST_ID, intBookTblNo]; 
        [myCommon changeRec:strUpdateQuery openMyDic:TRUE];
        
        self.slidePageNo.maximumValue = [arrPageInfo count];
        lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];

            self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo + 1, (NSInteger) slidePageNo.maximumValue];

        lblShowMeaning.hidden = FALSE;
        
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;
        DLog(@"currPageNo : %d", currPageNo);
        self.navigationItem.title = NSLocalizedString(@"Book Mode", @"");
        
        blnCountingPages = FALSE;
        
        [SVProgressHUD dismiss];
        
        return;  
    }
    [SVProgressHUD dismiss];
}

- (void) updateGetAllPageInfo:(NSString*) param  {
    self.lblCurPage.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Counting Pages", @""), param];
}

- (void) savePageInfo:(NSMutableArray*)arrTemp {
    
    [myCommon savePageInfoIntable:arrTemp fontName:@"s" fontSize:12 jsFontSize:120];
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods   
//피커뷰에 보이는 글자...
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *strReturn = @"";
    if ((PickerViewType == intPickerViewTypeInBook_NextPages)  || (PickerViewType == intPickerViewTypeInBook_TTSPages)) {
        NSInteger pages = [[arrNextPages objectAtIndex:row] integerValue];
        DLog(@"pages : %d", pages);
        if ((pages > 1) || (pages < -1)) {
            strReturn = [NSString stringWithFormat:@"%d Pages", pages];
        } else {
            strReturn = [NSString stringWithFormat:@"%d Page", pages];
        }
    } else if (PickerViewType == intPickerViewTypeInBook_ExamPages) {
        NSInteger pages = [[arrExamPages objectAtIndex:row] integerValue];
        
        if (pages > 0) {
            strReturn = [NSString stringWithFormat:@"Next %d Pages", pages];            
        } else if (pages == 0) {
            strReturn = [NSString stringWithFormat:@"All Pages"];
        } else if (pages < 0) {
            strReturn = [NSString stringWithFormat:@"Previous %d Pages", pages];            
        }
    }
	return strReturn;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ((PickerViewType == intPickerViewTypeInBook_NextPages) || (PickerViewType == intPickerViewTypeInBook_TTSPages)) {
        return [arrNextPages count];
    }
    return [arrExamPages count];
}

//피커뷰에서 선택한것을 적는다.
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ((PickerViewType == intPickerViewTypeInBook_NextPages)  || (PickerViewType == intPickerViewTypeInBook_TTSPages)) {
        DLog(@"[arrNextPages objectAtIndex:row] : %@", [arrNextPages objectAtIndex:row]);
        self.strNextPrevPages = [NSString stringWithFormat:@"%@", [arrNextPages objectAtIndex:row]];
        DLog(@"self.strNextPrevPages : %@", self.strNextPrevPages);    
    } else {
        DLog(@"[arrExamPages objectAtIndex:row] : %@", [arrExamPages objectAtIndex:row]);
         DLog(@"self.arrExamPages : %@", self.arrExamPages); 
        self.strNextPrevPages = [NSString stringWithFormat:@"%@", [arrExamPages objectAtIndex:row]];
        DLog(@"self.strNextPrevPages : %@", self.strNextPrevPages);   
    }
}

- (IBAction) onBarBtnItemSelectPicker{
    [self onBarBtnItemCancelPicker];
    DLog(@"self.strNextPrevPages : %@", self.strNextPrevPages);
    
    if ((PickerViewType == intPickerViewTypeInBook_NextPages)  || (PickerViewType == intPickerViewTypeInBook_TTSPages)) {
        [self callReadTxt:self.strNextPrevPages];        
    } else {
        if ([self.strNextPrevPages isEqualToString:@"0"] == TRUE) {
            NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@", TBL_EngDic];
            int cntOfWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];
            if (cntOfWords == 0) {
                //단어가 없으면 먼저 단어추출을 하라고 한다.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First, you have to analyze the book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];
            } else {
                [self openExam:@""];
            }

        } else {
            [self callReadTxt:self.strNextPrevPages];                    
        }
    }
}

- (IBAction) onBarBtnItemCancelPicker {
    CGRect viewPreviewReviewFrame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewPickerNextPrevPages.frame.size.height);
    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.4f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromBottom];
    self.viewPickerNextPrevPages.hidden = TRUE;    
//    self.viewPickerNextPrevPages.frame = viewPreviewReviewFrame;
    
    [[viewPickerNextPrevPages layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    
}

#pragma mark -
#pragma mark ViewPreviewReview
- (void) onOpenPreviewOrReview
{
    if (blnCountingPages == TRUE) {
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Wait until finishing counting pages.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
    } else {
        
        [self.pickerNextPrevPages reloadAllComponents];
        if ((PickerViewType == intPickerViewTypeInBook_NextPages)  || (PickerViewType == intPickerViewTypeInBook_TTSPages)) {
            self.strNextPrevPages = @"1";
            [self.pickerNextPrevPages selectRow:(([arrNextPages count]/2)-1) inComponent:0 animated:NO];
        } else {
            self.strNextPrevPages = @"5";
            [self.pickerNextPrevPages selectRow:(([arrExamPages count]/2)-1) inComponent:0 animated:NO];
        }
        [self.view bringSubviewToFront:viewPickerNextPrevPages];
        
        CGRect viewPreviewReviewFrame = CGRectMake(0.0, appHeight - viewPickerNextPrevPages.frame.size.height - naviBarHeight, self.view.frame.size.width, viewPickerNextPrevPages.frame.size.height);
        //
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.4f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [ani setType:kCATransitionPush];
        [ani setSubtype:kCATransitionFromTop];

        self.viewPickerNextPrevPages.hidden = FALSE;
//        self.viewPickerNextPrevPages.frame = viewPreviewReviewFrame;
        [[viewPickerNextPrevPages layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    }
}

#pragma mark -
#pragma mark 다른것들
- (void) aboutBook:(NSTimer *)sender
{
	
//	//현재 책의 단어를 알고 있는 현황을 bookSetting에 추가한다.
//	[myCommon updateBookSettingEachBookKnow:intBookTblNo] ;    
    [self saveBookSetting];

    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [myCommon getBookInfoFormTbl:dicOne fileName:[strBookFullFileName lastPathComponent]];
            
	NSMutableString *strDifficult = [NSMutableString stringWithFormat:@""];
    DLog(@"dicOne : %@", dicOne);
    NSInteger cntOfAllWords = [[dicOne objectForKey:@"AllWords"] integerValue];
	NSInteger cntOfUniqueWords = [[dicOne objectForKey:@"UniqueWords"] integerValue];
	NSInteger cntOfKnownWords = [[dicOne objectForKey:@"KnownWords"] integerValue];
	NSInteger cntOfUnKnownWords = [[dicOne objectForKey:@"UnKnownWords"] integerValue] + [[dicOne objectForKey:@"HalfKnownWords"] integerValue];
	NSInteger cntOfWordsNotInBook = [[dicOne objectForKey:@"WordsNotInBook"] integerValue];
    
	if (cntOfUniqueWords != 0) {
		float score = ((float)cntOfKnownWords/cntOfUniqueWords) * 100;
		[strDifficult setString:[self getBookDifficulty1:[NSNumber numberWithFloat:score]]];
	} else {
		[strDifficult setString:@"?"];
	}

    float	precentageOfKnownWords = 0;
    float	precentageOfUnKnownWords = 0;
    if (cntOfUniqueWords > 0) {
        precentageOfKnownWords = ((float)cntOfKnownWords / cntOfUniqueWords) * 100;
        precentageOfUnKnownWords = ((float)cntOfUnKnownWords / cntOfUniqueWords) * 100;
    }


    //TODO) locale는 사용자에게 맞게 맞추어 주어야한다.
	NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
    NSDecimalNumber *someAmount = nil;
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setLocale:locale];
	
    DLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
	
	someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfAllWords]];
	NSString *strCntOfAllWords = [currencyFormatter stringFromNumber:someAmount];
	someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUniqueWords]];
	NSString *strCntOfUniqueWords = [currencyFormatter stringFromNumber:someAmount];
	someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfKnownWords]];
	NSString *strCntOfKnownWords = [currencyFormatter stringFromNumber:someAmount];
	someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUnKnownWords]];
	NSString *strCntOfUnKnownWords = [currencyFormatter stringFromNumber:someAmount];	
	someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfWordsNotInBook]];
	NSString *strCntOfWordsNotInBook = [currencyFormatter stringFromNumber:someAmount];	

    NSString *strMsg = [NSString stringWithFormat:@"%@\n\n( %@ : %@ )\n%@ : %@\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@", [strBookFullFileName lastPathComponent],NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"All Words", @""),strCntOfAllWords, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];

    [SVProgressHUD dismiss];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Book Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
	[alert show];
}

- (NSString*) getBookDifficulty1:(NSNumber*)param
{
	float score = [param floatValue];
	if (score > 90) {
		return NSLocalizedString(@"Very Easy in book difficulty", @"");
	} else if (score > 80) {
		return NSLocalizedString(@"Easy in book difficulty", @"");
	} else if (score > 70) {
		return NSLocalizedString(@"Good in book difficulty", @"");
	} else if (score > 60) {
		return NSLocalizedString(@"Hard in book difficulty", @"");
	} else if (score > 0) {
		return NSLocalizedString(@"Very Hard in book difficulty", @"");
	} 

	return @"?";
}


//책의 정보를 가져온다.
- (BOOL) createBookSettingInTableIfNotExist
{
    [myCommon createBookSettingInTableIfNotExist:dicSetting fileName:[strBookFullFileName lastPathComponent]];
	return TRUE;
}

- (BOOL)saveBookSetting
{
    //마지막 페이지도 저장한다.(이것도 updateBookSettingEachBookKnow에서 처리해야 한다.)     
	[self.dicSetting removeObjectForKey:@"LastPage"];
    DLog(@"currPageNo : %d", currPageNo);
	[self.dicSetting setValue:[NSNumber numberWithInt:currPageNo] forKey:@"LastPage"];
	DLog(@"dicSetting : %@", dicSetting);
    
    NSString	*strUpdateQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_LASTPAGE, currPageNo, FldName_BOOK_LIST_ID, intBookTblNo];    
    [myCommon changeRec:strUpdateQuery openMyDic:TRUE];
	
	//현재 책의 단어를 알고 있는 현황을 bookSetting에 추가한다.
	[myCommon updateBookSettingEachBookKnow:intBookTblNo] ;
	return TRUE;
}

//미해결질문) 왜 같은것이 두번 불릴까?텍스트박스와 웹뷰에서 서로 다른 메뉴를 보여주고 싶다. 또 ... 대신 바로메뉴를 추가할수 없나?
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    ContentViewController *theCurrentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    [theCurrentViewController.webView copy:sender];
    
 	if (action == @selector(select:) ) {
        blnSelWord = TRUE;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(someReceiver:) object:@""];    
        DLog(@"action ALL");
        [self selWordInWebView];            
        NSRange rSpace = [_strMutableCopyWord rangeOfString:@" "];
        UIMenuController *mc = [UIMenuController sharedMenuController];	

        if (rSpace.location != NSNotFound) {
            UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"X" action:@selector(Know1:)];

            UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"?" action:@selector(Know2:)];
            UIMenuItem *customMenuItem3 = [[UIMenuItem alloc] initWithTitle:@"!" action:@selector(Know3:)];
            UIMenuItem *customMenuItem4 = [[UIMenuItem alloc] initWithTitle:@"-" action:@selector(Know99:)];
            UIMenuItem *customMenuItem5 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"WebDic", @"") action:@selector(onOpenWebDic:)];
            UIMenuItem *customMenuItem6 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Search", @"") action:@selector(callOpenSearchView:)];
            UIMenuItem *customMenuItem7 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"SNS", @"") action:@selector(openSNS)];
            
            //현재 사전에 없는 단어이면 추가할것이냐고 물어보고 한다.
            NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
            BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:_strMutableCopyWord dicWordWithOri:dicIdiom];
            DLog(@"_strMutableCopyWord : %@", _strMutableCopyWord);
            DLog(@"dicIdiom : %@", dicIdiom);
            if (blnWordOrIdiomExistInDic == TRUE) {
                //해당되는 단어가 사전에 있으면 바로 아는정도를 바꿀수 있게 해준다.
#ifdef DEBUG
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5,customMenuItem6,customMenuItem7, nil]];
#else
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5,customMenuItem6, nil]];
#endif
            } else {
                //해당되는 단어가 사전에 없으면 아는정도를 바꾸지 못하게 한다.
#ifdef DEBUG
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem5,customMenuItem6,customMenuItem7, nil]];
#else
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem5,customMenuItem6, nil]];
#endif
            }

        } else  {
            UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"X" action:@selector(Know1:)];

            UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"?" action:@selector(Know2:)];
            UIMenuItem *customMenuItem3 = [[UIMenuItem alloc] initWithTitle:@"!" action:@selector(Know3:)];
            UIMenuItem *customMenuItem4 = [[UIMenuItem alloc] initWithTitle:@"-" action:@selector(Know99:)];
            UIMenuItem *customMenuItem5 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"WebDic", @"") action:@selector(onOpenWebDic:)];
            

            if (intViewType != viewTypeWeb)
            {
                //WebMode가 아니면
                UIMenuItem *customMenuItem6 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Search", @"") action:@selector(callOpenSearchView:)];

                
#ifdef DEBUG
                //DEBUG모드일때만 트위터메뉴를 보여준다.
                UIMenuItem *customMenuItem7 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"SNS", @"") action:@selector(openSNS)];
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5,customMenuItem6,customMenuItem7, nil]];
#else
                //Release모드이면 트위터메뉴를 보여주지 않는다.
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5,customMenuItem6, nil]];
                
#endif
                                 
            } else {
                //WebMode일때는 Search를 보여주지 않는다.
#ifdef DEBUG
                //DEBUG모드일때만 트위터메뉴를 보여준다.                    
                UIMenuItem *customMenuItem7 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"SNS", @"") action:@selector(openSNS)];
                
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5,customMenuItem7, nil]];
#else
                //Release모드이면 트위터메뉴를 보여주지 않는다.
                [mc setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, customMenuItem3, customMenuItem4,customMenuItem5, nil]];
#endif
            }
        }
		return NO;
	}
	
	return [super canPerformAction:action withSender:sender];	
}

-(void)Know1:(id)sender
{
    _intKnowChanged = KnowWord_Unknown;
    [self askSetKnowingOrNot];
}
-(void)Know2:(id)sender
{
    _intKnowChanged = KnowWord_NotSure;
    [self askSetKnowingOrNot];
}

//메뉴에서 안다고 선택했을때...
-(void)Know3:(id)sender
{
    _intKnowChanged = KnowWord_Known;
    [self askSetKnowingOrNot];
}

//메뉴에서 쓸데없다고 선택했을때...
-(void)Know99:(id)sender
{
    _intKnowChanged = KnowWord_Exclude;
    [self askSetKnowingOrNot];
}

- (void) askSetKnowingOrNot
{
    //현재 사전에 없는 단어이면 추가할것이냐고 물어보고 한다.
    NSString *strOne = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
    
    BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:_strMutableCopyWord dicWordWithOri:dicIdiom];
    
        strOne = [dicIdiom objectForKey:KEY_DIC_StrOverOneWord];

    if (blnWordOrIdiomExistInDic == TRUE) {
        //해당되는 단어가 사전에 있으면 바로 아는정도를 바꾼다.
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(setKnowing:)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        //해당되는 단어가 사전에 없으면 사전에 추가할지를 먼저 물어보고 사전에 추가하고 나서 아는정도를 바꾼다.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The word is not in the dictionary. Do you want to add it?", @"")
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                              otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        
        alert.tag = 5;
        [alert show];
    }
}

- (void) setKnowing:(NSTimer*)sender
{
    [sender invalidate];
    
    [SVProgressHUD showProgress:-1 status:@""];
    lblKnow.text = [myCommon getStrKnowFromIntKnow:_intKnowChanged];//  @"X";
    NSString *strKnowBefore = nil;
      
    [myCommon closeDB:true];
    [myCommon openDB:true];
    if (intViewType == viewTypeBook) {
        [myCommon closeDB:FALSE];
        [myCommon openDB:FALSE];
    }
    
    NSString *strWord = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    //WordOri가 없을때를 대비해서 Word를 사용한다. (밑에서 wordOri가 있을경우 바꾸어준다.)
    NSString *strWordOri = [NSString stringWithFormat:@"%@", strWord];

    NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
    
    BOOL blnWordOrIdiomExistInDic =[myCommon getWordAndWordoriInSelected:_strMutableCopyWord dicWordWithOri:dicIdiom];
    
    strWord = [dicIdiom objectForKey:KEY_DIC_StrOverOneWord];
    strWordOri = [dicIdiom objectForKey:KEY_DIC_StrOverOneWordOri];
    NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", strWordOri]];

    if (blnWordOrIdiomExistInDic == FALSE) {
        [myCommon insertWordIfNotExist:strWord wordOriForSQL:strWordOri know:KnowWord_StrNotRated];
    }
    NSString *strQuery = @"";
    
    self.navigationItem.title = _strMutableCopyWord;

    NSInteger intKnowBefore = [strKnowBefore integerValue];
    
    //단어의 변경사항을 ENG_DIC에 바꿔준다.
    //현재단어의 아는정도가 바뀐것을 History에 업데이트 한다.
    [myCommon changeKnow:strWord know:_intKnowChanged knowBefore:intKnowBefore tblName:TBL_EngDic bookTblNo:intBookTblNo openMyDic:OPEN_DIC_DB];

#ifdef ENGLISH
    //현재단어의 원형에 해당되는 단어를 업데이트 한다.
    strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and %@ = 0",TBL_EngDic, FldName_Know, _intKnowChanged, FldName_WORDORI, strWordOriForSQL, FldName_Know];
    [myCommon changeRec:strQuery openMyDic:TRUE];
#endif
    
    //단어의 변경사항을 각 책의 ENG_DIC에 바꿔준다.
    if (intBookTblNo > 0) {
        //현재단어의 아는정도가 바뀐것을 History에 업데이트 한다.
        [myCommon changeKnow:strWord know:_intKnowChanged knowBefore:intKnowBefore tblName:TBL_EngDic bookTblNo:intBookTblNo openMyDic:OPEN_DIC_DB_BOOK];

#ifdef ENGLISH
        //현재단어의 원형에 해당되는 단어를 업데이트 한다.
        strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and %@ = 0",TBL_EngDic, FldName_Know, _intKnowChanged, FldName_WORDORI, strWordOriForSQL, FldName_Know];
        [myCommon changeRec:strQuery openMyDic:FALSE];
#endif
    }
    
    blnPageChanged = FALSE;
    blnDoSTHToChangeFront = TRUE;
//    [self currPageLoadAndGoFront];

    //아는정도를 바꾸었을때 화면갱신이 필요한지...
    BOOL blnRefreshContents = TRUE;
    if (_intKnowChanged == intKnowBefore) {
        blnRefreshContents = false;
    }

    if ((_intKnowChanged >=3) && (intKnowBefore >= 3)) {
        blnRefreshContents = false;
    }

    if ( (blnShowUnknowWords == TRUE) && (blnRefreshContents == TRUE) ) {
        lastScrollY = [[[arrWebView objectAtIndex:currWebView] stringByEvaluatingJavaScriptFromString:@"scrollY"] floatValue];
        [self reloadCurrentPage];
    }else{
    
        [SVProgressHUD dismiss];
    }
}

- (void) onOpenWebDic:(id)sender
{
    //==============================================
    //버전1.1_업데이트] 단어상세로 갈때 최대 문자수를 512개로 하자....
    if ([_strMutableCopyWord length] > sentenceMax) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"Too Long word.Over %d characters\nSelected %d characters", sentenceMax, [_strMutableCopyWord length]]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        return;	
    }
    //==============================================
    if (playType == PlayTypeMovie) {
        blnIsMoviePlaying = FALSE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
        [moviePlayer pause];
    }

    
	WebDicController *webDicController = [[WebDicController alloc] initWithNibName:@"WebDicController" bundle:nil];
	webDicController.strWord = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
	[self.navigationController pushViewController:webDicController animated:YES];			
}


- (void) openSNS
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SNS", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Message",@""), NSLocalizedString(@"Twitter",@""), NSLocalizedString(@"Mail",@""), nil];
    actionSheet.tag = ActionSheet_Tag_OpenSNS;
    [actionSheet showInView:self.view];
}

- (void) openMessage
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", _strMutableCopyWord];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
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
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void) openMail
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller != NULL) {
        controller.mailComposeDelegate = self;
        
        [controller setSubject:[NSString stringWithFormat: NSLocalizedString(@"SNS", @"")]];
        NSString *body = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", _strMutableCopyWord];
        [controller setMessageBody:body isHTML:YES];
        
        [self presentModalViewController:controller animated:YES];
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
}

#pragma mark -
#pragma mark 트위터 관련기능
-(void) openTwitter
{
    NSString *strPost = [NSString stringWithFormat:@"What is the meaning of \"%@\"?", _strMutableCopyWord];
    DLog(@"strPost : %@", strPost);
    [myCommon PostTwitter:strPost image:nil strURL:nil sender:self];
}

#pragma mark -
#pragma mark 동영상 모드
- (IBAction) onResizeMovieView:(id)sender
{
    NSInteger intWebViewHeight = webViewWeb.frame.size.height ;
    NSInteger intDocHeight = 0;
    DLog(@"strWebViewMode : %@", strWebViewMode);
    if ([strWebViewMode isEqualToString:@"STUDY"] == TRUE) {
        intDocHeight = viewDic.frame.size.height;        
    } else {
        
    }
    
    if (blnResizeMovieBig == TRUE) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.4f];
        intWebViewHeight += viewMovie.frame.size.height;
        //        NSInteger intWebViewHeight = webViewWeb.frame.size.height + viewMovie.frame.size.height;
        CGRect webViewFrame = CGRectMake(0.0, intDocHeight, self.view.frame.size.width, intWebViewHeight);
        for (int i = 0; i < [arrWebView count]; ++i) {
            [[arrWebView objectAtIndex:i] setFrame:webViewFrame];
        }
        [webViewWeb setFrame:webViewFrame];
        CGRect viewCurPageFrame = CGRectMake(0.0, intDocHeight + intWebViewHeight, self.view.frame.size.width, self.viewCurPage.frame.size.height);
		self.viewCurPage.frame = viewCurPageFrame;	
        CGRect btnResizeMovieViewFrame = CGRectMake(self.view.frame.size.width - self.btnResizeMovieView.frame.size.width, intDocHeight + intWebViewHeight, self.btnResizeMovieView.frame.size.width, self.btnResizeMovieView.frame.size.height);
		self.btnResizeMovieView.frame = btnResizeMovieViewFrame;	
        
        
        CGRect viewMovieFrame = CGRectMake(0.0, appHeight, self.view.frame.size.width, self.viewMovie.frame.size.height);
        self.viewMovie.frame = viewMovieFrame;
        
        [UIView commitAnimations];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.4f];
        intWebViewHeight -= viewMovie.frame.size.height;
        //        NSInteger intWebViewHeight = webViewWeb.frame.size.height - viewMovie.frame.size.height;
        CGRect webViewFrame = CGRectMake(0.0, intDocHeight, self.view.frame.size.width, intWebViewHeight);
        for (int i = 0; i < [arrWebView count]; ++i) {
            [[arrWebView objectAtIndex:i] setFrame:webViewFrame];
        }
        [webViewWeb setFrame:webViewFrame];
        CGRect viewCurPageFrame = CGRectMake(0.0, intDocHeight + intWebViewHeight, self.view.frame.size.width, self.viewCurPage.frame.size.height);
		self.viewCurPage.frame = viewCurPageFrame;	
        CGRect btnResizeMovieViewFrame = CGRectMake(self.view.frame.size.width - self.btnResizeMovieView.frame.size.width, intDocHeight + intWebViewHeight, self.btnResizeMovieView.frame.size.width, self.btnResizeMovieView.frame.size.height);
		self.btnResizeMovieView.frame = btnResizeMovieViewFrame;	
        
        CGRect viewMovieFrame = CGRectMake(0.0, viewCurPage.frame.origin.y + viewCurPage.frame.size.height, self.view.frame.size.width, self.viewMovie.frame.size.height);
        self.viewMovie.frame = viewMovieFrame;
        
        [UIView commitAnimations];
        
    }
    tabBarViewModeBook.hidden = FALSE;
    [self.view bringSubviewToFront:tabBarViewModeBook];
    blnResizeMovieBig = !blnResizeMovieBig;
}

//Movie를 플레이 한다.
- (IBAction) onBtnMoviePlay : (id) sender
{
    blnRepeating = FALSE;
    NSString *strTitle = btnMoviePlayOrStop.titleLabel.text;
    DLog(@"strTitle : %@", strTitle);
    if ([strTitle isEqualToString:@">"] == TRUE) {
//                moviePlayer.fullscreen = TRUE;
        blnIsMoviePlaying = TRUE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;
        DLog(@"_currentPalyBackTime : %f", _currentPalyBackTime);
        if (_currentPalyBackTime == NAN) {
            DLog(@"_currentPalyBackTime = nan");            
            self._currentPalyBackTime = 0.0f;
        }
        
        [moviePlayer play];
   
    } else {
        
        blnIsMoviePlaying = FALSE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;  

        timerScript = nil;
        [moviePlayer pause];

    }
}

- (IBAction) onBtnShowScrip:(id)sender
{
    blnShowScript = TRUE;
    if ([[btnShowScript.titleLabel.text uppercaseString] isEqualToString:@"SCRIPT"]) {
        [btnShowScript setTitle:@"Hide" forState:UIControlStateNormal];
    } else {
        blnShowScript = FALSE;
        [btnShowScript setTitle:@"Script" forState:UIControlStateNormal];
    }
    if (blnShowScript == TRUE) {
        lblMovieScript.hidden = FALSE;
        webMovieScript.hidden = FALSE;
    } else {
        lblMovieScript.hidden = TRUE;
        webMovieScript.hidden = TRUE;        
    }
}

- (IBAction) onBtnMovieRate:(id)sender
{
    if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"0.7x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 0.8f;
        [btnMoviePlayRate setTitle:@"0.8x" forState:UIControlStateNormal];
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"0.8x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 0.9f;
        [btnMoviePlayRate setTitle:@"0.9x" forState:UIControlStateNormal];        
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"0.9x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 1.0f;
        [btnMoviePlayRate setTitle:@"1.0x" forState:UIControlStateNormal];        
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"1.0x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 1.1f;
        [btnMoviePlayRate setTitle:@"1.1x" forState:UIControlStateNormal];                
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"1.1x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 1.2f;
        [btnMoviePlayRate setTitle:@"1.2x" forState:UIControlStateNormal];                
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"1.2x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 1.3f;
        [btnMoviePlayRate setTitle:@"1.3x" forState:UIControlStateNormal];                
    } else if ([btnMoviePlayRate.titleLabel.text isEqualToString:@"1.3x"] == TRUE) {
        moviePlayer.currentPlaybackRate = 0.7f;
        [btnMoviePlayRate setTitle:@"0.7x" forState:UIControlStateNormal];                
    }
}
- (IBAction) onBtnMovieRepeatStartPoint : (id) sender
{
    blnRepeating = FALSE;
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    intRepeatStartPoint = moviePlayer.currentPlaybackTime;
}

- (IBAction) onBtnMovieRepeatEndPoint : (id) sender
{
    blnRepeating = TRUE;
    
    intRepeatEndPoint = moviePlayer.currentPlaybackTime;
    moviePlayer.initialPlaybackTime = intRepeatStartPoint;
    moviePlayer.endPlaybackTime = intRepeatEndPoint;
    moviePlayer.currentPlaybackTime = intRepeatStartPoint;
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [moviePlayer pause];
    [moviePlayer play];
}

- (IBAction) onBtnMovieRepeatStop : (id) sender
{
    blnRepeating = FALSE;
    [moviePlayer stop];
    
    //    moviePlayer.repeatMode = MPMovieRepeatModeNone;
    moviePlayer.initialPlaybackTime = -1;
    moviePlayer.endPlaybackTime = -1;
    moviePlayer.currentPlaybackTime = intRepeatEndPoint;
    [moviePlayer play];
    
    [btnMoviePlayOrStop setTitle:@"||" forState:UIControlStateNormal];
}

- (void) getScript
{
    [dicScript removeAllObjects];
    [arrScript removeAllObjects];
    [dicScript1 removeAllObjects];
    [arrScript1 removeAllObjects];
    
    NSString *strFileName = [NSString stringWithFormat:@"%@/%@",[myCommon getDocPath], strScriptFileName];
	NSMutableString *strFileContents = [myCommon readTxtWithEncoding:strFileName];

    NSScanner *thescanner;
    thescanner = [NSScanner scannerWithString:strFileContents];
    [thescanner scanUpToString:@"<SYNC START=" intoString:NULL];    
    while ([thescanner isAtEnd] == NO) {
        NSMutableString *strMutableTime = [[NSMutableString alloc] init];
        NSMutableString *strMutableLang = [[NSMutableString alloc] init];
        NSString *strTimeWithTag = nil;
        [thescanner scanUpToString:@">" intoString:&strTimeWithTag];
        //        DLog(@"strTimeWithTag : %@", strTimeWithTag);
        if ((strTimeWithTag != NULL) && ([strTimeWithTag length] > 0)) {
            [strMutableTime setString:strTimeWithTag];
            [strMutableTime replaceOccurrencesOfString:@"<SYNC START=" withString:@""
                                               options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strMutableTime length])];                
            
        }
        NSString *strScriptLangWithTag = nil;
        [thescanner scanUpToString:@"<P CLASS=" intoString:NULL];
        
        [thescanner scanUpToString:@">" intoString:&strScriptLangWithTag];
        //        DLog(@"strScriptLangWithTag : %@", strScriptLangWithTag);
        if ((strScriptLangWithTag != NULL) && ([strScriptLangWithTag length] > 0)) {
            [strMutableLang setString:strScriptLangWithTag];
            [strMutableLang replaceOccurrencesOfString:@"<P CLASS=" withString:@""
                                               options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strMutableLang length])];
            //            DLog(@"strMutableLang : %@", strMutableLang);                
        }
        //        NSInteger newScanLocation = [thescanner scanLocation] 
        [thescanner setScanLocation:([thescanner scanLocation] + 1)];
        NSString *strScript = nil;
        [thescanner scanUpToString:@"<SYNC START=" intoString:&strScript]; 
        //        DLog(@"strScript : '%@'", strScript);
        NSMutableString *strMutableScript = [NSMutableString stringWithString:strScript];
        
        if ([[strMutableScript uppercaseString] hasPrefix:@"&NBSP"]) {
            continue;
        }
        
        if ([[strMutableScript uppercaseString] hasPrefix:@"&NBSP;"]) {
            continue;
        }
        
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
        [dicOne setObject:strMutableTime forKey:strMutableTime];
 
        
        if ([[strMutableLang uppercaseString] isEqualToString:SMI_LANG_ENCC]) { 
//            DLog(@"strMutableScript : %@", strMutableScript);
            [dicOne setObject:strMutableScript forKey:SMI_DIC_KEY_SCRIPT];    
            [dicOne setObject:[strMutableLang uppercaseString] forKey:SMI_DIC_KEY_LANGUAGE];
            [dicOne setObject:[NSNumber numberWithInt:[strMutableTime integerValue]] forKey:SMI_DIC_KEY_TIME];                        
            [dicScript setObject:dicOne forKey:strMutableTime];
            [arrScript addObject:dicOne];
        } else if ([[strMutableLang uppercaseString] isEqualToString:SMI_LANG_KRCC]) {
            //지우지 말것 : 이건 내중에 다국어 자막을 지원할때 쓰게 한다.
//            DLog(@"strMutableScript : %@", strMutableScript);
            [dicOne setObject:strMutableScript forKey:SMI_DIC_KEY_SCRIPT];    
            [dicOne setObject:[strMutableLang uppercaseString] forKey:SMI_DIC_KEY_LANGUAGE];
            [dicOne setObject:[NSNumber numberWithInt:[strMutableTime integerValue]] forKey:SMI_DIC_KEY_TIME];                        
            [dicScript setObject:dicOne forKey:strMutableTime];
            [arrScript addObject:dicOne];
        }

    }    
    DLog(@"\n\n===dicScript\n%@", dicScript);
}

- (void) showNextScript:(NSString*)strSubTitle
{
    if (blnIsMoviePlaying == TRUE) {
        lblMovieScript.textColor = [UIColor whiteColor];
        lblMovieScript.text = strSubTitle;
        NSMutableString *strHtmlSentence = [NSMutableString stringWithFormat:@"<html><body  topmargin=\"0\"><span style=\"text-shadow: 2px 2px 5px #000000; FONT-SIZE: 15pt\"><font color=white><center>%@</center></font></span></body></html>", strSubTitle];
        NSString *strWordTemp = @"script";
        NSString *strWordBold = [NSString stringWithFormat:@"<FONT style=\"BACKGROUND-COLOR: blue\">%@</font>", strWordTemp];
        NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordTemp] options:NSRegularExpressionCaseInsensitive error:nil];
        
        [regEx2 replaceMatchesInString:strHtmlSentence options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strHtmlSentence length]) withTemplate:[NSString stringWithFormat:@"$1%@$3", strWordBold]];
//        DLog(@"strHtmlSentence : %@", strHtmlSentence);
        
        
        [webMovieScript loadHTMLString:strHtmlSentence baseURL:nil];
        
        currPageNo = indexOfCurrentScript;

        [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];

        DLog(@"Script : %@", strSubTitle);
        DLog(@"indexOfCurrentScript : %d", indexOfCurrentScript);
        indexOfCurrentScript++;
        if ((indexOfCurrentScript >= 0) && (indexOfCurrentScript < [arrScript count])) {
            NSMutableDictionary *dicOne = [arrScript objectAtIndex:indexOfCurrentScript];
            DLog(@"dicOne : %@", dicOne);
            NSInteger timeScript = [[dicOne objectForKey:@"TIME"] integerValue];
            double currentPlaybackTime = (moviePlayer.currentPlaybackTime);
            double fTimeScript = (double)timeScript/1000;
            double scriptTimeToShow = fTimeScript - currentPlaybackTime;
            DLog(@"currentPlaybackTime : %f", currentPlaybackTime);
            DLog(@"moviePlayer.currentPlaybackTime %%f : %f", moviePlayer.currentPlaybackTime);
            DLog(@"fTimeScript : %f", fTimeScript);
            DLog(@"scriptTimeToShow : %f", scriptTimeToShow);            
            
            if (scriptTimeToShow > 0.0f) {
                DLog(@"scriptTimeToShow > 0.0");
                self.strNextScript = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];
                if (indexOfCurrentScript < [arrScript1 count]) {
                    NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
                    NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
                    if (dicScript1OneScript != NULL) {
                        self.strNextScript = [NSString stringWithFormat:@"%@\n\n%@",strNextScript, [[arrScript1 objectAtIndex:indexOfCurrentScript] objectForKey:SMI_DIC_KEY_SCRIPT]];        
                    }
                }
                
                DLog(@"Script : %@", strNextScript);
                [self performSelector:@selector(showNextScript:) withObject:strNextScript afterDelay:scriptTimeToShow];
            } else {
                DLog(@"scriptTimeToShow <= 0.0");
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;
                DLog(@"_currentPalyBackTime : %f", _currentPalyBackTime);    
                DLog(@"indexOfCurrentScript Before : %d", indexOfCurrentScript);    
                indexOfCurrentScript = [self positionFromPlaybackTime:_currentPalyBackTime];
                DLog(@"indexOfCurrentScript After : %d", indexOfCurrentScript);        
                if ( ((indexOfCurrentScript - 1) >= 0) && (indexOfCurrentScript < [arrScript count]) ){
                    timerScript = nil;
                    self.strNextScript = [[arrScript objectAtIndex:(indexOfCurrentScript)] objectForKey:SMI_DIC_KEY_SCRIPT];
                    if (indexOfCurrentScript < [arrScript1 count]) {
                        NSNumber *scriptTime = [[arrScript objectAtIndex:(indexOfCurrentScript)] objectForKey:SMI_DIC_KEY_TIME];
                        NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
                        if (dicScript1OneScript != NULL) {
                            self.strNextScript = [NSString stringWithFormat:@"%@\n\n%@",strNextScript, [[arrScript1 objectAtIndex:indexOfCurrentScript] objectForKey:SMI_DIC_KEY_SCRIPT]];        
                        }
                    }
                    
                    [UIView cancelPreviousPerformRequestsWithTarget:self];
                    [self performSelector:@selector(showNextScript:) withObject:strNextScript afterDelay:0.0f];
                }  
            }
        }
    }
}

- (NSInteger)positionFromPlaybackTime:(NSTimeInterval)playbackTime
{
    NSInteger position = 0;
    
    NSMutableDictionary *dicOneFirst = [arrScript objectAtIndex:0];
    NSInteger timeScriptFirst = [[dicOneFirst objectForKey:@"TIME"] integerValue];
    float fTimeScriptFirst = (float)timeScriptFirst/1000;
    
    if (playbackTime <= fTimeScriptFirst){
        DLog(@"indexOfCurrentScript : %d", indexOfCurrentScript);
        DLog(@"position : %d", position);
        DLog(@"return at position : 0");
        return position;
    }
    
    NSInteger begin = 0;
//    NSInteger mid = 0;
    NSInteger end = [arrScript count] - 1;
    
	while (begin<=end) {
        DLog(@"position Before : %d", position);
		position = (begin+end)/2;
        DLog(@"position After : %d", position);   
        DLog(@"begin : %d", begin);
        DLog(@"end : %d", end);
        NSMutableDictionary *dicOne = [arrScript objectAtIndex:position];
        NSInteger timeScript = [[dicOne objectForKey:@"TIME"] integerValue];
        float fTimeScript = (float)timeScript / 1000;

        DLog(@"moviePlayer.currentPlaybackTime : %f", moviePlayer.currentPlaybackTime); 
        DLog(@"playbackTime : %f", playbackTime);        
        DLog(@"fTimeScript : %f", fTimeScript);         
        //같으면 나간다.
        if (playbackTime == fTimeScript) {
            DLog(@"Same");
            break;
        }
        
        //맨처음이면 나간다.
        if ((playbackTime < fTimeScript) && (position == 1)){
            DLog(@"First");            
            break;            
        }
        
        //맨마지막이면 나간다.
        if ((playbackTime > fTimeScript) && (position == [arrScript count])) {
            DLog(@"Last");            
            break;
        }
        
        //플레이시간이 현재 자막의 시간보다는 늦고
        if (playbackTime < fTimeScript) {
            //바로 직전의 시간보다는 빠르면 해당 자막이 맞다.
            NSMutableDictionary *dicOne1 = [arrScript objectAtIndex:position - 1];
            NSInteger timeScript1 = [[dicOne1 objectForKey:@"TIME"] integerValue];
            float fTimeScript1 = (float)timeScript1 / 1000;
            if (playbackTime >= fTimeScript1) {
                position--;                
                break;
            }
            end = position-1;
            
        } else {
            begin = position+1;           
        }
        fTimeScriptFirst = fTimeScript;
	}
    DLog(@"return at position : %d", position);   
    return position;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{       
#ifdef DEBUG
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:@"moviePlayBackDidFinish" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert2 show];
#endif
    DLog(@"moviePlayBackDidFinish");
}

- (void) moviePlayBackWillEnterFullscreen:(NSNotification*)notif
{
    [webMovieScript removeFromSuperview];
    [moviePlayer.view addSubview:webMovieScript];
    [self.view bringSubviewToFront:webMovieScript];
    webMovieScript.frame = CGRectMake(100 , 100, self.view.frame.size.width, 50);
}

- (void) moviePlayBackWillExitFullscreen:(NSNotification*)notif
{
    [webMovieScript removeFromSuperview];
    [moviePlayer.view addSubview:webMovieScript];
    [moviePlayer.view addSubview:btnInfo];
    webMovieScript.frame = CGRectMake(0 , 50, self.view.frame.size.width, 50);
}

- (void) moviePlayBackExitFullscreen:(NSNotification*)notification
{
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:@"moviePlayBackExitFullscreen" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert2 show];    
}

- (void) moviePlayBackStateDidChanged:(NSNotification*)notification
{
    
    MPMoviePlayerController *mpv = (MPMoviePlayerController *)notification.object;
    DLog(@"mpv.playbacState : %d", mpv.playbackState);
    if (mpv.playbackState == MPMoviePlaybackStatePlaying) {
        [btnMoviePlayOrStop setTitle:@"||" forState:UIControlStateNormal];
        DLog(@"mpv.playbacState : MPMoviePlaybackStatePlaying");
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;
        DLog(@"_currentPalyBackTime : %f", _currentPalyBackTime);
        indexOfCurrentScript = [self positionFromPlaybackTime:_currentPalyBackTime];
        DLog(@"indexOfCurrentScript : %d", indexOfCurrentScript);
        
        if ( ((indexOfCurrentScript) >= 0) && (indexOfCurrentScript < [arrScript count]) ){
            self.strNextScript = [[arrScript objectAtIndex:(indexOfCurrentScript)] objectForKey:SMI_DIC_KEY_SCRIPT];    
            if (indexOfCurrentScript < [arrScript1 count]) {
                NSNumber *scriptTime = [[arrScript objectAtIndex:(indexOfCurrentScript)] objectForKey:SMI_DIC_KEY_TIME];
                NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
                if (dicScript1OneScript != NULL) {
                    self.strNextScript = [NSString stringWithFormat:@"%@\n\n%@",strNextScript, [[arrScript1 objectAtIndex:(indexOfCurrentScript)] objectForKey:SMI_DIC_KEY_SCRIPT]];  
                    DLog(@"strNextScript : %@", strNextScript);                
                }
            }
            [self performSelector:@selector(showNextScript:) withObject:strNextScript afterDelay:0.0f];        
        }  
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [btnMoviePlayOrStop setTitle:@">" forState:UIControlStateNormal];
        DLog(@"mpv.playbacState : MPMoviePlaybackStateStopped");         
    }
    
    if (mpv.playbackState == MPMoviePlaybackStatePaused){
        DLog(@"mpv.playbacState : MPMoviePlaybackStatePaused");
    } else if (mpv.playbackState == MPMoviePlaybackStateStopped){
        DLog(@"mpv.playbacState : MPMoviePlaybackStateStopped");
    } else if (mpv.playbackState == MPMoviePlaybackStateSeekingBackward){
        DLog(@"mpv.playbacState : MPMoviePlaybackStateSeekingBackward");
    } else if (mpv.playbackState == MPMoviePlaybackStateSeekingForward){
        DLog(@"mpv.playbacState : MPMoviePlaybackStateSeekingForward");
    } else if (mpv.playbackState == MPMoviePlaybackStateInterrupted){        
        DLog(@"mpv.playbacState : MPMoviePlaybackStateInterrupted");
    }
}

- (void) movieNowPlayingMovieDidChange:(NSNotification*)notification
{   
    MPMoviePlayerController *mpv = (MPMoviePlayerController *)notification.object;
    DLog(@"mpv.playbacState : %d", mpv.playbackState);
    DLog(@"moviePlayer.currentPlaybackTime : %f", moviePlayer.currentPlaybackTime);
}

#pragma mark -
#pragma mark 단어 퀴즈모드
- (IBAction) openViewQA:(id)sender
{
    viewQA.center = self.view.center;
    blnAnswerd = FALSE;
    intWrongAnswer = -1;
    NSString *strMeaning = [myCommon getMeaningFromTbl:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];
    DLog(@"strMeaning : %@", strMeaning);
    DLog(@"strQABeforeWord : %@", strQABeforeWord);

    if ([strMeaning isEqualToString:@""]) {
        return;
    }
    
    if ([strQABeforeWord isEqualToString:_strMutableCopyWord] == FALSE)  {
        self.txtViewQA_Question.text = [NSString stringWithFormat:@"\n%@", _strMutableCopyWord];    
        //1~4사이의 난수 생성
        srandom(time(NULL));
        intAnswer = (random() % (4-1+1)) + 1;
        btnQA_Answer1.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer2.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer3.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer4.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];
    }
    
    btnQA_Answer1.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    btnQA_Answer2.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    btnQA_Answer3.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    btnQA_Answer4.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    btnQA_Answer1.titleLabel.text = @"Wrong Answer1";
    btnQA_Answer2.titleLabel.text = @"Wrong Answer2";
    btnQA_Answer3.titleLabel.text = @"Wrong Answer3";
    btnQA_Answer4.titleLabel.text = @"Wrong Answer4";
    [self btnQACommonBtnColor];
    
    [btnQA_Answer1 setBackgroundImage:[UIImage imageNamed:@"240_37_d.png"] forState:UIControlStateNormal];
    [btnQA_Answer2 setBackgroundImage:[UIImage imageNamed:@"240_37_d.png"] forState:UIControlStateNormal];
    [btnQA_Answer3 setBackgroundImage:[UIImage imageNamed:@"240_37_d.png"] forState:UIControlStateNormal];
    [btnQA_Answer4 setBackgroundImage:[UIImage imageNamed:@"240_37_d.png"] forState:UIControlStateNormal];    
    
    if (intAnswer == 1) {
        [btnQA_Answer1 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:strMeaning forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
    } else if (intAnswer == 2) {
        [btnQA_Answer2 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
    } else if (intAnswer == 3) {
        [btnQA_Answer3 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
    } else if (intAnswer == 4) {     
        [btnQA_Answer4 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:[[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"] forState:UIControlStateSelected];        
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.3f];
    [self.view bringSubviewToFront:viewQA];
    viewQA.hidden = NO;
	[UIView commitAnimations];
    
    self.strQABeforeWord = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    blnOnQAMode = TRUE;
}

- (IBAction) closeViewQA
{
    [NSThread sleepForTimeInterval:.0f];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.3f];
    [self.view sendSubviewToBack:viewQA];
    viewQA.hidden = YES;
	[UIView commitAnimations];
    btnOpenQuiz.hidden = TRUE;
    blnOnQAMode = FALSE;
}

- (void) onBtnQA_Vibration
{
    if (blnOnQA_Vibration == TRUE) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}

- (IBAction) onBtnQA_Answer1
{
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];    
        if (intAnswer != 1) {
            [btnQA_Answer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration]; 
        }
        blnAnswerd = TRUE;
    } else {
        intWrongAnswer = 1;
        if (intAnswer == intWrongAnswer) {
            intWrongAnswer = -1;
        }
        
        NSString *strWordTemp = [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"];
        if (intAnswer == 1) {
            blnBtnAnswer1Clicked = TRUE;
            strWordTemp = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
        } else if (intAnswer == 2) {
            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
        } else if (intAnswer == 3) {
            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
        } else if (intAnswer == 4) {
            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
        }
        if (blnBtnAnswer1Clicked == TRUE) {
            if (playType == PlayTypeMovie) {
                blnIsMoviePlaying = FALSE;
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
                [moviePlayer pause];
            }

            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            wordDetail.intBookTblNo = intBookTblNo;
//            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
            blnBtnAnswer1Clicked = FALSE;            
        } else {
            blnBtnAnswer1Clicked = TRUE;
        }
    }     
}

- (IBAction) onBtnQA_Answer2
{
    if (blnAnswerd == FALSE) {
        [self   btnQACommonBtnColor];
        [self btnQACommon];    
        if (intAnswer != 2) {
            [btnQA_Answer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
        }
        blnAnswerd = TRUE;
    } else {
        intWrongAnswer = 2;
        if (intAnswer == intWrongAnswer) {
            intWrongAnswer = -1;
        }
            
        NSString *strWordTemp = [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"];
        if (intAnswer == 1) {
            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
            [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateSelected]; 
        } else if (intAnswer == 2) {
            blnBtnAnswer2Clicked = TRUE;
            strWordTemp = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
        } else if (intAnswer == 3) {
            strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"];
            NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"]];
            [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected]; 
        } else if (intAnswer == 4) {
            strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"];
            NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"]];
            [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected]; 
        }
        if (blnBtnAnswer2Clicked == TRUE) {
            if (playType == PlayTypeMovie) {
                blnIsMoviePlaying = FALSE;
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
                [moviePlayer pause];
            }


            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            wordDetail.intBookTblNo = intBookTblNo;
//            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;            
            [self.navigationController pushViewController:wordDetail animated:YES];
            blnBtnAnswer2Clicked = FALSE;
        } else {
            blnBtnAnswer2Clicked = TRUE;
        }        
    }          
}

- (IBAction) onBtnQA_Answer3
{
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];    
        if (intAnswer != 3) {
            [btnQA_Answer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
        }
        blnAnswerd = TRUE;
    } else {
        intWrongAnswer = 3;
        if (intAnswer == intWrongAnswer) {
            intWrongAnswer = -1;
        }


        NSString *strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"];
        if (intAnswer == 1) {
            NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"]];
            [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected]; 

        } else if (intAnswer == 2) {
            NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"]];
            [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected]; 
        } else if (intAnswer == 3) {
            blnBtnAnswer3Clicked = TRUE;
            strWordTemp = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
        } else if (intAnswer == 4) {
            strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"];
            NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"]];
            [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateSelected]; 
        }
        if (blnBtnAnswer3Clicked == TRUE) {
            if (playType == PlayTypeMovie) {
                blnIsMoviePlaying = FALSE;
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
                [moviePlayer pause];
            }


            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            wordDetail.intBookTblNo = intBookTblNo;
//            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;            
            [self.navigationController pushViewController:wordDetail animated:YES];
            blnBtnAnswer3Clicked = FALSE;
        } else {
            blnBtnAnswer3Clicked = TRUE;
        }
    }          
}

- (IBAction) onBtnQA_Answer4
{
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];
        if (intAnswer != 4) {
            [btnQA_Answer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
        }
        blnAnswerd = TRUE;
    } else {
        intWrongAnswer = 4;
        if (intAnswer == intWrongAnswer) {
            intWrongAnswer = -1;
        }
        
        NSString *strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"];
        if (intAnswer == 1) {
            NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"]];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
        } else if (intAnswer == 2) {
            NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"]];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
        } else if (intAnswer == 3) {
            NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"]];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
            [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
        } else if (intAnswer == 4) {
            blnBtnAnswer4Clicked = TRUE;
            strWordTemp = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
//            strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"];
        }
        if (blnBtnAnswer4Clicked == TRUE) {
            if (playType == PlayTypeMovie) {
                blnIsMoviePlaying = FALSE;
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
                [moviePlayer pause];
            }


            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            wordDetail.intBookTblNo = intBookTblNo;
//            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
            blnBtnAnswer4Clicked = FALSE;    
        } else {
            blnBtnAnswer4Clicked = TRUE;    
        }
        
    }    
}

- (void) btnQACommonBtnColor
{
    [btnQA_Answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnQA_Answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnQA_Answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnQA_Answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];    
}
- (void) btnQACommon
{    
    
    NSString *strMeaning = [myCommon getMeaningFromTbl:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];

    strMeaning = [NSString stringWithFormat:@"(O) %@", strMeaning];

    NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → ?",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"]];
    NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → ?", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"]];
    NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → ?", [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"]];
    
    if (intAnswer == 1) {
        [btnQA_Answer1 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:strMeaning forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];  
    } else if (intAnswer == 2) {
        [btnQA_Answer2 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];    
    } else if (intAnswer == 3) {
        [btnQA_Answer3 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected];        
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];  
    } else if (intAnswer == 4) {     
        [btnQA_Answer4 setTitle:strMeaning forState:UIControlStateNormal];
        [btnQA_Answer4 setTitle:strMeaning forState:UIControlStateSelected];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
        [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected];        
        [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
        [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected];        
        [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateNormal];
        [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateSelected];        
    }
    
    if (intAnswer == 1) {
        [btnQA_Answer1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnQA_Answer1 setBackgroundImage:[UIImage imageNamed:@"240_37_down_2.png"] forState:UIControlStateNormal];
        btnQA_Answer1.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (intAnswer == 2) {
        [btnQA_Answer2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnQA_Answer2 setBackgroundImage:[UIImage imageNamed:@"240_37_down_2.png"] forState:UIControlStateNormal];
        btnQA_Answer2.titleLabel.font = [UIFont systemFontOfSize:14];
    } else if (intAnswer == 3) {
        [btnQA_Answer3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnQA_Answer3 setBackgroundImage:[UIImage imageNamed:@"240_37_down_2.png"] forState:UIControlStateNormal];
        btnQA_Answer3.titleLabel.font = [UIFont systemFontOfSize:14];            
    } else if (intAnswer == 4) {
        [btnQA_Answer4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnQA_Answer4 setBackgroundImage:[UIImage imageNamed:@"240_37_down_2.png"] forState:UIControlStateNormal];
        btnQA_Answer4.titleLabel.font = [UIFont systemFontOfSize:14]; 
    }
}

- (void) smartWordList:(id)sender
{
	if (intViewType == viewTypeBook) {		
		[[arrWebView objectAtIndex:currWebView] copy:sender];
	} else if (intViewType == viewTypeWeb) {		
		[webViewWeb copy:sender];
	}
	
	UIPasteboard *board = [UIPasteboard generalPasteboard];
    DLog(@"board.string :%@", board.string);
	DLog(@"board.string count : %d", [board.string length]);

    [self callReadTxt:@"smartWordList"];
}

- (NSMutableString*)HTMLFromTextString:(NSMutableString *)originalText 
{
	NSString *header;
	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath]];			
            
	NSMutableString *outputHTML;
	NSRange fullRange = NSMakeRange(0, [originalText length]);

	unsigned int i,j;
	j=0;
	i = [originalText replaceOccurrencesOfString:@"&" withString:@"&amp;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d &s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	i = [originalText replaceOccurrencesOfString:@"<" withString:@"&lt;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d <s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	i = [originalText replaceOccurrencesOfString:@">" withString:@"&gt;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d >s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	// Argh, bloody MS line breaks!  Change them to UNIX, then...
	i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@"<br>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d carriage return/newlines\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);

    //Change newlines to </p><p>.
	i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-newlines\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
    
	//Change double-newlines to </p><p>.
	i = [originalText replaceOccurrencesOfString:@"\n" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-newlines\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	// And just in case someone has a Classic MacOS textfile...
	i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-carriage-returns\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	// Lots of text files start new paragraphs with newline-space-space or newline-tab
	i = [originalText replaceOccurrencesOfString:@"\n  " withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-spaces\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-spaces\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
    //\r일경우...
    i = [originalText replaceOccurrencesOfString:@"\r" withString:@"<br>"
										 options:NSLiteralSearch range:fullRange];
    j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	outputHTML = [NSMutableString stringWithFormat:@"%@%@\n</p><br/><br/>\n</body>\n</html>\n", header, originalText];    
	NSError *error;	
	BOOL ok=[outputHTML writeToFile:strBookFileNameInCachesWithPath atomically:YES encoding:NSUTF8StringEncoding error:&error];	
	if(!ok)		
	{		
		DLog(@"Error when writing %@ : %@", strBookFileNameInCachesWithPath, [error description]);		
	}
    
    DLog(@"outputHTML : %@", outputHTML);
	return outputHTML;  
}

#pragma mark -
#pragma mark UITabBarDelegate methods   
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

    [self.view	bringSubviewToFront:tabBarFont];
    [self.view	bringSubviewToFront:viewBackLight];
    [self.view	bringSubviewToFront:viewPageNo];
	if (tabBar.tag == 0) {		
		if (viewWordSearchBackAndForward.hidden == FALSE) {
            [self onBtnWordSearchCloseViewWordSearch:nil];
        }
		if (item.tag == 11) {
			//뷰 모드...	
			//단어추출및 뜻달기...
            if (blnCountingPages == TRUE) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Wait until finishing counting pages.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
            } else {
                tabBarFont.hidden = TRUE;
                viewBackLight.hidden = TRUE;
                viewPageNo.hidden = TRUE;
                NSString *strShowUknownWordColor = NSLocalizedString(@"Show unknown words", @"");
                if (blnShowUnknowWords == TRUE) {
                    strShowUknownWordColor = NSLocalizedString(@"Hide unknown words", @"");
                } else {
                    
                }
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Prepare to read.\nIt may take a long time.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Analyze",@""), [NSString stringWithFormat:@"%@", strShowUknownWordColor],nil];
                actionSheet.tag = 1;
                [actionSheet showInView:self.view];
            }
			
        }else if (item.tag == 12) {		
			//단어장 및 단어공부...
            if (blnCountingPages == TRUE) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info",@"")	message:NSLocalizedString(@"Wait until finishing counting pages.",@"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
                [alert2 show];
            } else {
                tabBarFont.hidden = TRUE;
                viewBackLight.hidden = TRUE;
                viewPageNo.hidden = TRUE;


                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Words & Book Info",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Words in this book",@""), NSLocalizedString(@"Pre/Review Words",@""), NSLocalizedString(@"Exam", @""), NSLocalizedString(@"Text to Speech", @""), NSLocalizedString(@"Book Info",@""), nil];
                
                actionSheet.tag = 2;
                [actionSheet showInView:self.view];			
 

            }
		}else if (item.tag == 13) {		

            
			tabBarFont.hidden = !tabBarFont.hidden;
			viewBackLight.hidden = !viewBackLight.hidden;
			viewPageNo.hidden = !viewPageNo.hidden;
            if (viewPageNo.hidden == FALSE) {
                blnPressAdjust = TRUE;
            } else {
                blnPressAdjust = FALSE;
            }

			if (tabBarFont.hidden == TRUE) {
				[self.dicSetting removeObjectForKey:@"Font"];
				[self.dicSetting setValue:[NSNumber numberWithInt:fontSize] forKey:@"Font"];
				[self saveBookSetting];				
			}			
			
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            if (blnBookDayMode == TRUE) {
                float BackLight = [defs floatForKey:@"BackLight"];
                if (BackLight < 0.1f) {
                    BackLight = 0.1f;
                } else if (BackLight >= 1.0f) {
                    BackLight = 1.0f;
                }

                slideBackLight.value = BackLight;				
            } else {			
                
            }
			NSInteger pageToGo = [[self.dicSetting objectForKey:@"LastPage"] integerValue];
            DLog(@"pageToGo : %d", pageToGo);
			slidePageNo.value = pageToGo + 1;	
            lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];
            DLog(@"slidePageNo.value : %f", slidePageNo.value);            
		} else if (item.tag == 14) {		
            //Setting을 선택했을때...            
			tabBarFont.hidden = TRUE;
			viewBackLight.hidden = TRUE;
                
            if (playType == PlayTypeMovie) {
                blnIsMoviePlaying = FALSE;
                self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
                [moviePlayer pause];
            }

			MoviePlayerSettingController *settingController = [[MoviePlayerSettingController alloc] initWithNibName:@"MoviePlayerSettingController" bundle:nil];
			settingController.strScriptFileName = self.strBookFullFileName;
            settingController.blnBookDayMode = blnBookDayMode;
			[self.navigationController pushViewController:settingController animated:YES];
		}
	} else if (tabBar.tag == 1) {
		if ((item.tag == 21) || (item.tag == 22) ){
            if (item.tag == 21) {
                //문자 작게...
                fontSize -= 20;
                if (fontSize < Font_Size_MIN) {
                    fontSize = Font_Size_MIN;
                }					
            } else if (item.tag == 22) {
                //문자 크게...
                fontSize += 20;
                if (fontSize > Font_Size_MAX) {
                    fontSize = Font_Size_MAX;
                }
            }
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            [defs setInteger:fontSize forKey:KEY_DIC_FontSize];
            
            // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
            [SVProgressHUD showProgress:-1 status:@""];
            [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                             target:self
                                           selector:@selector(changeFontSize:)
                                           userInfo:[NSNumber numberWithInt:fontSize]
                                            repeats:NO];

		} else if (item.tag == 23) {
            //주간 모드, 야간모드이면...
            //야간모드이면 폰트색을 조정한다.
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];

            //주간모드이면...
            if ([item.title isEqualToString:NSLocalizedString(@"Day Mode", @"")]) {
                blnBookDayMode = FALSE;
                item.title = NSLocalizedString(@"Night Mode", @"");   
                NSInteger fontLight = [defs floatForKey:@"FontLight"];
                if ((fontLight >= slideBackLight.minimumValue) && (fontLight <= slideBackLight.maximumValue)) {
                    slideBackLight.value = fontLight;
                }
                
                
                NSDictionary *dicBODYTemp = [defs dictionaryForKey:KEY_CSS_BODY];
                NSDictionary *dicWORDNotRated = [defs dictionaryForKey:KEY_CSS_WORDNotRated];
                NSDictionary *dicWORDUnknown = [defs dictionaryForKey:KEY_CSS_WORDUnknown];
                NSDictionary *dicWORDNotSure = [defs dictionaryForKey:KEY_CSS_WORDNotSure];
                NSDictionary *dicWORDNotRatedIdiom = [defs dictionaryForKey:KEY_CSS_WORDNotRatedIdiom];
                NSDictionary *dicWORDUnknownIdiom = [defs dictionaryForKey:KEY_CSS_WORDUnknownIdiom];
                NSDictionary *dicWORDNotSureIdiom = [defs dictionaryForKey:KEY_CSS_WORDNotSureIdiom];
                
                NSMutableDictionary *dicBodyMutable = [NSMutableDictionary dictionaryWithDictionary:dicBODYTemp];
                [dicBodyMutable setValue:[dicBODYTemp objectForKey:@"FontSize"] forKey:@"FontSize"];
                
                
                
                [dicBodyMutable setValue:[NSNumber numberWithInt:fontLight] forKey:@"FontColor_Red"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:fontLight] forKey:@"FontColor_Green"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:fontLight] forKey:@"FontColor_Blue"];
                [dicBodyMutable setValue:[dicBODYTemp objectForKey:@"FontColor_Alpha"] forKey:@"FontColor_Alpha"];    
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Red"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Green"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Blue"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:255] forKey:@"BackColor_Alpha"];

                
                NSDictionary *dicBODY = [NSDictionary dictionaryWithDictionary:dicBodyMutable];  
                
                NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init];
                [dicCSS setValue:dicBODY forKey:KEY_CSS_BODY];
                [dicCSS setValue:dicWORDNotRated forKey:KEY_CSS_WORDNotRated];
                [dicCSS setValue:dicWORDUnknown forKey:KEY_CSS_WORDUnknown];
                [dicCSS setValue:dicWORDNotSure forKey:KEY_CSS_WORDNotSure];
                [dicCSS setValue:dicWORDNotRatedIdiom forKey:KEY_CSS_WORDNotRatedIdiom];
                [dicCSS setValue:dicWORDUnknownIdiom forKey:KEY_CSS_WORDUnknownIdiom];
                [dicCSS setValue:dicWORDNotSureIdiom forKey:KEY_CSS_WORDNotSureIdiom];
                [myCommon CreateCSS:dicCSS option:CSS_Option_Day];
                
                UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];        
                [self.viewCurPage setBackgroundColor:color];
                UIColor *colorPage = [UIColor colorWithRed:fontLight/255.0 green:fontLight/255.0 blue:fontLight/255.0 alpha:1];
                lblCurPage.textColor = colorPage;
                lblShowMeaning.textColor = colorPage;
                txtMeaning.textColor = colorPage;
                lblKnow.textColor = colorPage;
                lblCount.textColor = colorPage;
                viewDic.backgroundColor = color;
            } else {
                //야간모드이면...
                blnBookDayMode = TRUE;
                item.title = NSLocalizedString(@"Day Mode", @""); 
                NSInteger backLight = [defs floatForKey:@"BackLight"];
                if ((backLight >= slideBackLight.minimumValue) && (backLight <= slideBackLight.maximumValue)) {
                    slideBackLight.value = backLight;
                }
                
                NSDictionary *dicBODYTemp = [defs dictionaryForKey:@"CSS_NightBODY"];
                NSDictionary *dicWORDNotRated = [defs dictionaryForKey:@"CSS_NightWORDNotRated"];
                NSDictionary *dicWORDUnknown = [defs dictionaryForKey:@"CSS_NightWORDUnknown"];
                NSDictionary *dicWORDNotSure = [defs dictionaryForKey:@"CSS_NightWORDNotSure"];
                
                NSMutableDictionary *dicBodyMutable = [NSMutableDictionary dictionaryWithDictionary:dicBODYTemp];
                [dicBodyMutable setValue:[dicBODYTemp objectForKey:@"FontSize"] forKey:@"FontSize"];
                
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Red"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Green"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Blue"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:255] forKey:@"FontColor_Alpha"];
                
                [dicBodyMutable setValue:[NSNumber numberWithInt:backLight] forKey:@"BackColor_Red"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:backLight] forKey:@"BackColor_Green"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:backLight] forKey:@"BackColor_Blue"];
                [dicBodyMutable setValue:[NSNumber numberWithInt:255] forKey:@"BackColor_Alpha"];
                
                NSDictionary *dicBODY = [NSDictionary dictionaryWithDictionary:dicBodyMutable];  
                
                NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init];
                [dicCSS setValue:dicBODY forKey:@"NightBODY"];
                [dicCSS setValue:dicWORDNotRated forKey:@"NightWORDNotRated"];
                [dicCSS setValue:dicWORDUnknown forKey:@"NightWORDUnknown"];
                [dicCSS setValue:dicWORDNotSure forKey:@"NightWORDNotSure"];        
                [myCommon CreateCSS:dicCSS option:CSS_Option_Night];

                
                UIColor *color = [UIColor colorWithRed:backLight/255.0 green:backLight/255.0 blue:backLight/255.0 alpha:1];        
                [self.viewCurPage setBackgroundColor:color];
                lblCurPage.textColor = [UIColor blackColor];
                lblShowMeaning.textColor = [UIColor blackColor];                
                txtMeaning.textColor = [UIColor blackColor];
                lblKnow.textColor = [UIColor blackColor];
                lblCount.textColor = [UIColor blackColor];                
//                viewDic.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];                
            }

            [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
        }
	} else if (tabBar.tag == 2) {
        if (item.tag == 1) {
            [self goBack];
        } else if (item.tag == 2) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Web Menu", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Refresh", @""), NSLocalizedString(@"Stop", @""), nil];
			actionSheet.tag = 4;
			[actionSheet showInView:self.view];	
        } else if (item.tag == 3) {
            [self goForward];
        } else if (item.tag == 4) {
            //BookMark....
			WebURL *webURLController = [[WebURL alloc] initWithNibName:@"WebURL" bundle:nil];
			webURLController.strURL = _strMutableURL;
			[self.navigationController pushViewController:webURLController animated:YES];
			blnOpenBookmark = TRUE;	
		} else if (item.tag == 5) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Book", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Make a Book", @""),NSLocalizedString(@"Latest Book", @""),nil];
			actionSheet.tag = 5;
			[actionSheet showInView:self.view];           			
		} 
	}
}


- (IBAction) onBarLinkOff
{
	blnLinkOff = !blnLinkOff;
	if (blnLinkOff == TRUE) {
		self.barLinkOff.title = @"LinkOn";
	} else {
		self.barLinkOff.title = @"LinkOff";
	}
}

- (void) callOnOpenWordDetail
{
    [SVProgressHUD showProgress:-1 status:@""];
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(onOpenWordDetail:)
                                   userInfo:nil
                                    repeats:NO];
}
- (IBAction)onOpenWordDetail:(NSTimer *)sender
{    
    //문자가 null이거나 글자가 없으면
    [SVProgressHUD dismiss];
	if ((_strMutableCopyWord == NULL) || ([_strMutableCopyWord isEqualToString:@""] == TRUE)) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need to select more than one word.",@"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert show];
		return;
	}

    //알파벳이 하나라도 들어가야 한다.
#ifdef ENGLISH
    NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches = [regEx numberOfMatchesInString:[NSString stringWithFormat:@"%@", _strMutableCopyWord]
                                                        options:0
                                                          range:NSMakeRange(0, [_strMutableCopyWord length])];
    if (numberOfMatches == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need to select at least one alphabet.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert show];
		return;
    }
#endif

    if (viewWordSearchBackAndForward.hidden == FALSE) {
        [self onBtnWordSearchCloseViewWordSearch:nil];
    }
    
    DLog(@"_strMutableCopyWord : %@", _strMutableCopyWord);

    //앞뒤의 공백및 뉴라인을을 제거한다...
	NSString *strOne = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    strOne = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strSentence = [myCommon getSentenceWithWord:strOne strFullContents:strAllContentsInFile];

    strSentence = [strSentence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    

    
    if (playType == PlayTypeMovie) {
        blnIsMoviePlaying = FALSE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
        [moviePlayer pause];
    }
    
    NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
    DLog(@"dicIdiom : %@", dicIdiom);
    if ([myCommon getWordAndWordoriInSelected:_strMutableCopyWord dicWordWithOri:dicIdiom] == TRUE) {
        //단어또는 숙어가 사전에 존재하면...
        strOne = [dicIdiom objectForKey:KEY_DIC_StrOverOneWord];
//        [_strMutableCopyWord setString:[dicIdiom objectForKey:KEY_DIC_StrOverOneWord]];
    }
    DLog(@"strOne : %@", strOne);
    DLog(@"strSentence : %@", strSentence);
    DLog(@"_strMutableCopyWord : %@", _strMutableCopyWord);
    WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
    wordDetail._strWord = strOne;
    wordDetail._strWordFirst = strOne;
    wordDetail._strWordFirstSampleText = strSentence;
    wordDetail.intBookTblNo = intBookTblNo;
//    wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
    [self.navigationController pushViewController:wordDetail animated:YES];
    [SVProgressHUD dismiss];
}

- (void) changeFontSize:(NSTimer *)sender
{
	NSNumber *number = (NSNumber*)[sender userInfo];
	NSInteger fontSizeToChange =  [number integerValue];

	if (fontSizeToChange < Font_Size_MIN) {
		fontSizeToChange = Font_Size_MIN;
	}					
	if (fontSizeToChange > Font_Size_MAX) {
		fontSizeToChange = Font_Size_MAX;
	}
    
    DLog(@"\n\n\nfontSize : %d", fontSize);
    fontSize = fontSizeToChange;

    UIWebView *webView = [[self.pageViewController.viewControllers objectAtIndex:0] webView];
    
    webView.scrollView.scrollEnabled = (fontSize >= Font_Size_NORMAL);
    webView.scrollView.bounces = (fontSize >= Font_Size_NORMAL);
    
//    NSString *documentheight1 = 	[webView stringByEvaluatingJavaScriptFromString:@"document.height"];
//    DLog(@"documentheight1 : %f", [documentheight1 floatValue]);
	[dicSetting setObject:[NSNumber numberWithInt:fontSizeToChange] forKey:@"Font"];
	NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 
						  fontSizeToChange];
//    for (int i = 0; i < [arrWebView count]; ++i) {
        [webView stringByEvaluatingJavaScriptFromString:jsString];
//    }
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:fontSize forKey:KEY_DIC_FontSize];
    
	[SVProgressHUD dismiss];
}

- (IBAction) slideBackLightValueChanging : (id) sender
{
    float valF = slideBackLight.value;
    [[UIScreen mainScreen] setBrightness:valF]; 
}
- (IBAction) slideBackLightValueChanged : (id) sender
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setFloat:slideBackLight.value forKey:@"BackLight"];
}

#pragma mark -
#pragma mark 페이지 이동에 관한 함수
- (IBAction) pageNoChanged : (id) sender
{
    NSInteger currPageNoTemp = slidePageNo.value - 1;
    [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNoTemp] afterDelay:0.0f];

}


- (IBAction) pageNoChanging : (id) sender
{
    NSInteger currPageNoTemp = slidePageNo.value - 1;
    lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNoTemp+1, (NSInteger) slidePageNo.maximumValue];
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        self.lblCurPage.text = [NSString stringWithFormat:@"%d/%d", currPageNo + 1, (NSInteger) slidePageNo.maximumValue];
}

- (void) GoOnePage:(NSNumber*)nsPageNo
{
//    NSInteger pageNo = [nsPageNo integerValue];
    currPageNoToGo = [nsPageNo integerValue];
    [SVProgressHUD showProgress:-1 status:@""];
    
    blnPageChanged = TRUE;
    blnWebViewOneFront = TRUE;
    blnDoSTHToChangeFront = FALSE;
    //다음장으로 넘어가면
//    if (currPageNoToGo > currPageNo) {
//        [self LoadNextPage];
//    } else if (currPageNoToGo < currPageNo) {
//        [self LoadPrevPage];
//    } else if (currPageNoToGo == currPageNo) {
//        [self LoadCurrPage:FALSE];
//    }
    
    [self flipToPage:currPageNoToGo];

    if (viewWordSearchBackAndForward.hidden == FALSE) {
        [self.view bringSubviewToFront:viewWordSearchBackAndForward];
    }

    blnNextPage = TRUE;

    if ([strBookFileNameExtension isEqualToString:fileExtension_SMI] == YES){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNextScript:) object:strNextScript];
        
        NSDictionary *dicOne = [arrScript objectAtIndex:currPageNo-1];
        self.strNextScript = [dicOne objectForKey:SMI_DIC_KEY_SCRIPT];
        if ((currPageNo -1) < [arrScript1 count]) {
            NSNumber *scriptTime = [dicOne objectForKey:SMI_DIC_KEY_TIME];
            NSMutableDictionary *dicScript1OneScript = [dicScript1 objectForKey:[NSString stringWithFormat:@"%@",scriptTime]];
            if (dicScript1OneScript != NULL) {
                self.strNextScript = [NSString stringWithFormat:@"%@\n\n%@",strNextScript, [[arrScript1 objectAtIndex:(currPageNo-1)] objectForKey:SMI_DIC_KEY_SCRIPT]];
            }
        }
        
        NSInteger timeScript = [[dicOne objectForKey:@"TIME"] integerValue];
        double fTimeScript = (double)timeScript/1000;
        
        moviePlayer.currentPlaybackTime = fTimeScript * 1.0f;
        [self performSelector:@selector(showNextScript:) withObject:strNextScript afterDelay:0.0f];
    }
    [SVProgressHUD dismiss];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (intTableViewMode == INT_TABLEVIEW_MODE_EPUB_CONTENTS) {
        return 1;
    }
    
    if (intAllSearchedWords == 0) {
        return 0;
    }

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (intTableViewMode == INT_TABLEVIEW_MODE_EPUB_CONTENTS) {
        return [_arrEPubChapter count];
    }
	// Return the number of rows in the section.	
    DLog(@"strWordSearch : %@", strWordSearch);    
    DLog(@"dicWordSearchFamilyDetail : %@", dicWordSearchFamilyDetail);
    NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
    DLog(@"arrOne count : %d", [arrOne count]);
    
    if (section == 0) {
        return [arrWordSearchFamily count];
    } else if (section == 1) {
        if ([arrOne count] > 1) {
            return 2;
        } else if ([arrOne count] == 1) {
            return 1;
        } else {
            return 0;
        }
    }
    return [arrOne count];
}


static NSString *CellIdentifier = @"Cell";
static NSString *CellIdentifier1 = @"Cell1";
//static NSString *CellIdentifier2 = @"Cell2";
static NSString *CellIdentifierEPub = @"CellEPub";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (intTableViewMode == INT_TABLEVIEW_MODE_EPUB_CONTENTS) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierEPub];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierEPub];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        NSMutableDictionary *dicOne = [_arrEPubChapter objectAtIndex:indexPath.row];
   
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"CHAPTER_NAME"]];
        return cell;
    } else {
        if (intAllSearchedWords == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            return cell;
        }

        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

            DLog(@"indexPath.row : %d", indexPath.row);
            DLog(@"arrWordSearchFamily : %@", arrWordSearchFamily);
            NSMutableDictionary *dicOne = [arrWordSearchFamily objectAtIndex:indexPath.row];
            NSString *strWordSearchTemp = [dicOne objectForKey:@"Word"]; 
            NSInteger intKnow = [[dicOne objectForKey:@"Know"] integerValue];         
            NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
            NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearchTemp];
            
            if ([strWordSearch isEqualToString:strWordSearchTemp] == TRUE) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;                
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
#ifdef CHINESE
            cell.accessoryType = UITableViewCellAccessoryNone;
#endif
            if ([arrOne count] > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@  %d",strKnow, strWordSearchTemp, [arrOne count]];            
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@  0",strKnow, strWordSearchTemp];            
            }
            return cell;
        } else if ( (indexPath.section == 1) || (indexPath.section == 2) ) {
            WordSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"WordSearchCell" owner:nil options:nil];
                cell = [arr	objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
            if ([arrOne count] > 0) {
                DLog(@"strWordSearch : %@", strWordSearch);
                DLog(@"[arrOne count] : %d", [arrOne count]);
                NSMutableDictionary *dicOne = [arrOne objectAtIndex:indexPath.row];
                DLog(@"dicOne : %@", dicOne);            
                if ((indexPath.section == 1) && (indexPath.row > 0)) {
                    dicOne = [arrOne objectAtIndex:([arrOne count] - 1)];            
                }
                cell.lblPage.text = [NSString stringWithFormat:@"%d Page", [[dicOne objectForKey:@"PageNo"] integerValue] + 1];
                cell.lblWord.text = [dicOne objectForKey:@"Word"];
                [cell.webOne loadHTMLString:[dicOne objectForKey:@"HtmlSentence"] baseURL:nil];

            }
            return cell;
            
        }
    }
    return nil;
}

#pragma mark -
#pragma mark Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (intTableViewMode == INT_TABLEVIEW_MODE_SEARCH) {
        if (indexPath.section == 0) {
            NSMutableDictionary *dicOne = [arrWordSearchFamily objectAtIndex:indexPath.row];        
            NSString *strWordSearchTemp = [dicOne objectForKey:@"Word"];
            NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearchTemp];
            if ([arrOne count] > 0) {
                return indexPath;            
            } else {
                NSString *strMsg = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Not searched sentences with", @""),strWordSearchTemp];
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];           
                return nil;
            }
        }
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    intSelTblRow = indexPath.row;
    if (intTableViewMode == INT_TABLEVIEW_MODE_EPUB_CONTENTS) {

        NSMutableDictionary *dicOne = [_arrEPubChapter objectAtIndex:indexPath.row];
        [self closeTblViewWordSearch];
        
        NSInteger pageNo = [myCommon getPageNoWithIndex:[[dicOne objectForKey:@"START"] integerValue]];
        [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:pageNo] afterDelay:0.0f];
        
    } else {
        if (indexPath.section == 0) {
            NSMutableDictionary *dicOne = [arrWordSearchFamily objectAtIndex:indexPath.row];        
            self.strWordSearch = [dicOne objectForKey:@"Word"];
            DLog(@"strWordSearch : %@", strWordSearch);
            if ([strWordSearch isEqualToString:@"[all words]"] == TRUE) {
                blnHeadword = TRUE;
            } else {
                blnHeadword = FALSE;
            }
            [self.tblSearchWord reloadData];
            //맨위로 스크롤한다...
            [self.tblSearchWord scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES]; 
            return;
        }


        tabBarFont.hidden = TRUE;
        viewBackLight.hidden = TRUE;
        viewPageNo.hidden = TRUE;
        
        DLog(@"strWordSearch : %@", strWordSearch);
        NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
        DLog(@"arrOne count : %d", [arrOne count]);

        if (indexPath.section == 1) {                
            if (indexPath.row == 1) {
                intSelTblRow = [arrOne count] - 1;
            }
        }

        
        NSMutableDictionary *dicOne = [arrOne objectAtIndex:intSelTblRow];
        NSInteger pageNoCurr = [[dicOne objectForKey:@"PageNo"] integerValue];
        intPageNoOfWordSearch = pageNoCurr;
        currPageNo = pageNoCurr;
        
        lblWordPage.text = [NSString stringWithFormat:@"%d/%d", intSelTblRow + 1, [arrOne count]];
        
        if (intSelTblRow == 0) {
            intIndexOfWordInSamePage = 1;
        } else {
            NSInteger intSelTblRowTemp = intSelTblRow;
            do {
                dicOne = [arrOne objectAtIndex:intSelTblRowTemp];
                NSInteger pageNo = [[dicOne objectForKey:@"PageNo"] integerValue]; 
                DLog(@"pageNoCurr : %d Page", pageNoCurr);
                DLog(@"pageNo : %d Page", pageNo);        
                DLog(@"intSelTblRow : %d", intSelTblRow);
                DLog(@"intSelTblRowTemp : %d", intSelTblRowTemp);                    
                intIndexOfWordInSamePage = intSelTblRow - intSelTblRowTemp;
                DLog(@"intIndexOfWordInSamePage : %d", intIndexOfWordInSamePage);                 
                //한페이지 뒤로 가거나 intSelTblRowTemp가 0이면 나간다.
                if ((pageNoCurr > pageNo) || (intSelTblRowTemp == 0)) {
                    break;
                }
            } while (intSelTblRowTemp--);
        }
        
        [self closeTblViewWordSearch];
        
        [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:pageNoCurr] afterDelay:0.0f];
        
        [self.view bringSubviewToFront:viewMovie];
        

        self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.5f];
        if ([strWebViewMode isEqualToString:@"STUDY"] == TRUE) {
            //일반모드로 일때...
            self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight - naviBarHeight - viewWordSearchBackAndForward.frame.size.height - viewCurPage.frame.size.height, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);                
        } else {
            //STUDY모드 일때...
            self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight - naviBarHeight - viewWordSearchBackAndForward.frame.size.height - viewCurPage.frame.size.height - tabBarViewModeBook.frame.size.height, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);        
        }
        self.viewWordSearchBackAndForward.hidden = FALSE;
        [self.view bringSubviewToFront:viewWordSearchBackAndForward];
        [UIView commitAnimations];
    }      
}
//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 100;
}


//헤더의 내용을 적는다.
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strReturn = @"";
    NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
    if (section == 0) {

    } else if (section == 1) {
        strReturn = NSLocalizedString(@"First and Last Sentence", @"");
        if ([arrOne count] == 0) {
            strReturn = @"";
        } else if ([arrOne count] == 1) {
            strReturn = NSLocalizedString(@"First Sentence", @"");
        }
    } else if (section == 2) { 
        NSString *strSentence = NSLocalizedString(@"Sentence", @"");
        if ([arrOne count] > 1) {
            strSentence = NSLocalizedString(@"Sentences", @"");
        }
        strReturn = [NSString stringWithFormat:@"%d %@", [arrOne count], strSentence];
    }
    return strReturn;        
}



#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
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
    self.strWordSearch = @"";
	DLog(@"searchBarCancelButtonClicked:");
	[searchBar resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
	DLog(@"searchBarBookmarkButtonClicked:");
	[searchBar resignFirstResponder];	
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];	
    if (searchBar == searchBarWebUrl) {
        if ([[searchBar.text lowercaseString] hasPrefix:@"http://"] == FALSE) {
            searchBar.text = [NSString stringWithFormat:@"http://%@", searchBarWebUrl.text];
        }
        
        //==============================================
        //버전1.2_업데이트] 웹URL추가로 갈때 searchbar의 내용을 바꾸어도 적용안되든거 수정함.
        [self._strMutableURL setString:searchBar.text];
        //==============================================
        
        [self gotoAddress:nil];
    } else if (searchBar == searchBarSearchWord) {
        [SVProgressHUD showProgress:-1 status:@""];
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(searchText:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)makeAnalysisNow{

    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to analyze", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
    [actionSheetProgress showInView:self.view];
    
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
    [actionSheetProgress addSubview:progressViewInActionSheet];
    
    UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);
    [aiv1 startAnimating];
    [actionSheetProgress addSubview:aiv1];
    
    blnCancelReadTxt = FALSE;
    
    [NSThread detachNewThreadSelector:@selector(UpdateAnalyze:) toTarget:self withObject:nil];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
//            [self callReadTxt:@""];
            [self performSelector:@selector(callReadTxt:) withObject:@"" afterDelay:0.1];
        }
    } else if (alertView.tag == 3) {
		if (buttonIndex == 1) {
//			[self callReadTxt:@"smartWordList"];
            [self performSelector:@selector(callReadTxt:) withObject:@"smartWordList" afterDelay:0.1];
		}
    } else if (alertView.tag == 4) {
        //분석하기를 눌렀을때 이미 분석하기가 있을때
        if (buttonIndex == 1) {
            //기존단어의 아는정도만 업데이트를 한다.
            [self performSelector:@selector(makeAnalysisNow) withObject:nil afterDelay:0.1];
            
        } else if (buttonIndex == 2) {
            //분석하기를 새로 만든다.
//            [self callReadTxt:@""];
            [self performSelector:@selector(callReadTxt:) withObject:@"" afterDelay:0.1];
        }
    } else if (alertView.tag == 5) {
        //사전에 없는 단어의 아는정도를 바꾸는것을 물어보았을때... 바꾸겠다고 할때만 바꾼다.
        if (buttonIndex == 1) {

            [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                             target:self
                                           selector:@selector(setKnowing:)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

-(BOOL) makeNewBook
{
	NSString *strFileName = [txtBookName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if ([board.string isEqualToString:@""] == FALSE) {
        if ([strFileName hasSuffix:@".txt"] == FALSE) {
            strFileName = [NSString stringWithFormat:@"%@.txt", strFileName];
        }
        strFileName = [[myCommon getDocPath] stringByAppendingPathComponent:strFileName];
        DLog(@"strFileName : %@", strFileName);
        
        
        NSError *error;	
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        NSString *strContents = board.string;

        BOOL ok=[strContents writeToFile:strFileName atomically:NO encoding:NSUTF8StringEncoding error:&error];	
        if(!ok)		
        {		
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:@"Can't make a book file. Check file name or memory's space!!!"  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
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
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"actionSheet.tag: %d", actionSheet.tag);
	if (actionSheet.tag == 11) {
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
            actionSheetProgress = nil;
            progressViewInActionSheet = nil;
            DLog(@"button click : %d", buttonIndex);
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (actionSheet.tag == 1) {

		if (buttonIndex == 0) {
            //이미 분석하기를 했으면 업데이트를 할지 다시 만들지를 물어보고
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [myCommon getBookInfoFormTbl:dicOne fileName:[strBookFullFileName lastPathComponent]];
            NSInteger intBookLength = [[dicOne objectForKey:@"BookLength"] integerValue];
            DLog(@"intBookLength : %d", intBookLength);
            DLog(@"[strAllContentsInFile length] : %d", [strAllContentsInFile length]); 
            
            NSString	*strQuery = [NSString	stringWithFormat:@"SELECT COUNT(*) FROM %@ ", TBL_EngDic];
            int cntOfWord = [myCommon getIntFldValueFromTbl:strQuery openMyDic:FALSE];
            
            if ((intBookLength == [strAllContentsInFile length]) && (cntOfWord > 0)) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You have already analyzed this book.\nDo you want to update it or analyze again?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Update", @""), NSLocalizedString(@"Analyze again" , @""), nil];
                [alert show];
                alert.tag = 4;
            } else {
                //저장된 단어수와 현재책의 단어수가 다르면 새로 단어를 추출하여 분석하기를 시행한다.
                [self callReadTxt:@""];                
            }
            
            
				
		} else if (buttonIndex == 1) {
            blnShowUnknowWords = !blnShowUnknowWords;
            if (!blnShowUnknowWords) {
                //원본(뜻 안달린거) 읽기
                self.lblShowMeaning.text = @"";            
                blnDoSTHToChangeFront = TRUE;
//                [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
            } else {
                self.lblShowMeaning.text = NSLocalizedString(@"Show unknown words", @"");
                blnDoSTHToChangeFront = TRUE;
                
//                [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNo] afterDelay:0.0f];
            }
            
            [SVProgressHUD showProgress:-1 status:@""];
            [self reloadCurrentPage];
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];    
            [defs setBool:blnShowUnknowWords forKey:@"ShowMeaning"];
            [defs synchronize];
        }	
	} else if (actionSheet.tag == 2) {
		if (buttonIndex == 0) {			
			//단어장을 표시한다.            
            NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@", TBL_EngDic];
            int cntOfWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];
            if (cntOfWords == 0) {
                //단어가 없으면 먼저 단어추출을 하라고 한다.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First, you have to analyze the book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                alert.tag = 1;
                [alert show];
            } else {
                [SVProgressHUD showProgress:-1 status:@""];
                // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
                [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                                 target:self
                                               selector:@selector(openDicList:)
                                               userInfo:nil
                                                repeats:NO];	
            }
        } else if (buttonIndex == 1) {
            PickerViewType = intPickerViewTypeInBook_NextPages;
            [self onOpenPreviewOrReview];
		} else if (buttonIndex == 2) {
            
            PickerViewType = intPickerViewTypeInBook_ExamPages;
            [self onOpenPreviewOrReview];

        } else if (buttonIndex == 3) {
            PickerViewType = intPickerViewTypeInBook_TTSPages;
            [self onOpenPreviewOrReview];

        } else if (buttonIndex == 4) {
            //책의 정보를 표시한다.
            [SVProgressHUD showProgress:-1 status:@""];
			// 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
			[NSTimer scheduledTimerWithTimeInterval: 0.0f
											 target:self
										   selector:@selector(aboutBook:)
										   userInfo:nil
											repeats:NO];
        }
            

	} else if (actionSheet.tag == 3) {		
		//ViewMode를 바꿔준다....
		if (buttonIndex == 0) {			
			//BookMode....
            UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TextName", @"") 						
                                                            message:@"\n\n" // 중요!! 칸을 내려주는 역할을 합니다.		   
                                                           delegate:self                                 
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")	   
                                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
			prompt.tag = 4;	
			txtBookName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
            NSString *strDateAndTime = [myCommon getCurrentDatAndTimeForBackup];
            NSString *strYearMonthDay =  [strDateAndTime substringWithRange:NSMakeRange (2, 6)];
            NSString *strHourMinute =  [strDateAndTime substringWithRange:NSMakeRange (8, 4)];
            txtBookName.text = [NSString stringWithFormat:@"%@_%@_web.txt", strYearMonthDay, strHourMinute];
			[txtBookName setBackgroundColor:[UIColor whiteColor]];	
			[prompt addSubview:txtBookName]; 	
			[txtBookName becomeFirstResponder]; 
			[prompt show];				
		} else if (buttonIndex == 1) {
			//WebMode...
			intViewType = viewTypeWeb;
			[self showViewTypeWeb];
		}			
	} else if (actionSheet.tag == 4) {
        //웹뷰에서 리로드, 스탑을 눌렀을때...
        if (buttonIndex == 0) {
            [self reload];
        } else if (buttonIndex == 1) {
            [self stopWebLoading];
        }
    } else if (actionSheet.tag == 5) {
        //웹뷰에서 book탭바를 선택했을때...
        if (buttonIndex == 0) {
            MakeABook *makeABook = [[MakeABook alloc] initWithNibName:@"MakeABook" bundle:nil];
            [self.navigationController pushViewController:makeABook animated:YES];
        } else if (buttonIndex == 1) {
            //최근 북을 선택했을때...
            DLog(@"[myCommon getLatestBook] : %@", [myCommon getLatestBook]);
            if ([fm fileExistsAtPath:[myCommon getLatestBook]]) {
                BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
                bookVC.strBookFullFileName = [myCommon getLatestBook];
                bookVC.intViewType = viewTypeBook;
                bookVC.title = [[myCommon getLatestBook] lastPathComponent];
                [self.navigationController pushViewController:bookVC animated:YES];
            } else  {
                if ([[myCommon getLatestBook] isEqualToString:@""]) {
                    
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"There is no latest book.", @"")];
                } else {
                   
                    NSString *strFileNameOnly = [[myCommon getLatestBook] lastPathComponent];
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"There is no book : \"%@\"", strFileNameOnly]];
                }
            }
        }
    } else if (actionSheet.tag == ActionSheet_Tag_OpenSNS) {
        if (buttonIndex == 0) {
            [self openMessage];
        } else if (buttonIndex == 1) {
            [self openTwitter];
        } else if (buttonIndex == 2) {
            [self openMail];
        }
    }
}

- (void) openTTS:(NSString*)param
{
    TTSWordViewController *ttsWordViewCon = [[TTSWordViewController alloc] initWithNibName:@"TTSWordViewController" bundle:nil];
    ttsWordViewCon.strFullContents = param;
    [self.navigationController pushViewController:ttsWordViewCon animated:YES];
}

- (void) openExam:(NSString*)param
{
    ExamViewController *examViewCon = [[ExamViewController alloc] initWithNibName:@"ExamViewController" bundle:nil];
    
    NSInteger pages = [strNextPrevPages intValue];
    if (pages < 0) {
        pages++;
        DLog(@"obj : %d", pages);
        
        NSInteger realPage = 0 - currPageNo;
        if (realPage < pages) {
            realPage = pages;
        }
        DLog(@"realPage : %d", realPage);
        NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo+realPage];
        NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
        
        NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo];
        NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];

        NSInteger offsetAll = offsetEnd - offsetStart;
        examViewCon._strFullFileContents = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
    } else if (pages > 0) {
        pages--;
        DLog(@"obj : %d", pages);
        
        NSInteger realPage = [arrPageInfo count] - currPageNo - 1;
        if (realPage > pages) {
            realPage = pages;
        }
        NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo];
        NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
        
        NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo+realPage];
        NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];
        
        
        //            NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
        NSInteger offsetAll = offsetEnd - offsetStart;
        examViewCon._strFullFileContents = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
    } else {
        examViewCon._strFullFileContents = strAllContentsInFile;
    }
    
    [self.navigationController pushViewController:examViewCon animated:YES];
}

#pragma mark -
#pragma mark 단어찾기 기능
- (void) callOpenSearchView:(id)sender
{
    searchBarSearchWord.hidden = NO;
    searchBarSearchWord.text = [NSString stringWithFormat:@"%@", _strMutableCopyWord];
    [self openSearchView:[NSString stringWithFormat:@"%@", _strMutableCopyWord]];
}

- (void) openSearchView:(NSString*)strWordSearchTemp
{

    [self openTblViewWordSearch];
    [SVProgressHUD showProgress:-1 status:@""];
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(searchText:)
                                       userInfo:nil
                                        repeats:NO];
}

- (void) openTblViewWordSearch
{
    blnWordSearchMode = TRUE;
   [SVProgressHUD showProgress:-1 status:@""];
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelTblViewWordSearch)];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    self.navigationItem.rightBarButtonItem = nil;
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 100, 30)];
    if (blnCaseSensitive == TRUE) {
        [segControl insertSegmentWithTitle:NSLocalizedString(@"CaseSensitive", @"") atIndex:0 animated:YES];
    } else {
        [segControl insertSegmentWithTitle:NSLocalizedString(@"CaseInsensitive", @"") atIndex:0 animated:YES];
    }
    
	segControl.tag = 2;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		

    [self.view bringSubviewToFront:viewSearchWord];
    
    CGRect viewSearchWordFrame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewSearchWord.frame.size.height);
    self.viewSearchWord.frame = viewSearchWordFrame;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.5f];
    CGRect viewSearchWordFrame1 = CGRectMake(0.0, 0, self.view.frame.size.width, viewSearchWord.frame.size.height);
    self.viewSearchWord.frame = viewSearchWordFrame1;
    //    self.viewWordSearchBackAndForward.hidden = FALSE;
    [UIView commitAnimations];
}

- (void) cancelTblViewWordSearch
{
    [arrWordSearchFamily    removeAllObjects];
    [dicWordSearchFamilyDetail  removeAllObjects];
    intAllSearchedWords = 0;
    blnWordSearchMode = FALSE;    
    self.strWordSearch = @"";
    self.strWordOriSearch = @"";
    
    [self closeTblViewWordSearch];
}
- (void) closeTblViewWordSearch
{
    intTableViewMode = INT_TABLEVIEW_MODE_SEARCH;
    
    [self.view bringSubviewToFront:viewSearchWord];
    
    DLog(@"strWebViewMode : %@", strWebViewMode);
    if ([strWebViewMode isEqualToString:@"STUDY"] == FALSE) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = TRUE;
    }
    UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 90, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Study", @"") atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Word", @"") atIndex:1 animated:NO];
	segControl.tag = 1;
	segControl.momentary = TRUE;
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;		
    
    [searchBarSearchWord resignFirstResponder];
	
    CGRect viewSearchWordFrame = CGRectMake(0.0, 0, self.view.frame.size.width, viewSearchWord.frame.size.height);
    self.viewSearchWord.frame = viewSearchWordFrame;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.5f];
    CGRect viewSearchWordFrame1 = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewSearchWord.frame.size.height);
    self.viewSearchWord.frame = viewSearchWordFrame1;
	[UIView commitAnimations];
}

- (void) searchText:(NSTimer*)sender
{
    if (blnCaseSensitive == FALSE) {
        self.strWordSearch = [searchBarSearchWord.text lowercaseString];
    } else {
        self.strWordSearch = searchBarSearchWord.text;
    }
    DLog(@"strWordSearch : %@", strWordSearch);
    intAllSearchedWords = 0;
    if ([strWordSearch length] > 0) {
        [dicWordSearchFamilyDetail removeAllObjects];
        [arrWordSearchFamily removeAllObjects];
        
        NSMutableDictionary *dicIdiom = [[NSMutableDictionary alloc] init];
        
        DLog(@"dicIdiom : %@", dicIdiom);
        
        NSRange rSpace = [strWordSearch rangeOfString:@" "];
        
        //TODO : 두단어 이상일때도 원형을 가지고 찾게 만들어 줘야 한다.
        if (rSpace.location != NSNotFound) {
            //단어이면(공백이 없다.)
            DLog(@"단어 : %@", strWordSearch);
        } else {
            //숙어나 문장이면 (공백이 있다)
            DLog(@"숙어 : %@", strWordSearch);            
        }

        self.strWordOriSearch = [myCommon GetOriWordOnlyIfExistInTbl:[strWordSearch lowercaseString]];
        if ([strWordOriSearch isEqualToString:@""]) {
            self.strWordOriSearch = strWordSearch;
        }
        NSString *strWordOriSearchForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOriSearch];
        NSString* strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORDORI,  strWordOriSearchForSQL];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWordSearchFamily byDic:nil openMyDic:OPEN_DIC_DB];

        DLog(@"arrWordSearchFamily : %@", arrWordSearchFamily);
        DLog(@"strWordOriSearchForSQL : %@", strWordOriSearchForSQL);
        DLog(@"arrWordSearchFamily : %@", arrWordSearchFamily);
        if ([arrWordSearchFamily count] == 0) {
            NSString *strWordSearchForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordSearch];
            strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWordSearchForSQL];
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrWordSearchFamily byDic:nil openMyDic:OPEN_DIC_DB_BOOK];
            DLog(@"strWordSearchForSQL : %@", strWordSearchForSQL);
            DLog(@"arrWordSearchFamily : %@", arrWordSearchFamily);
           if ([arrWordSearchFamily count] == 0) {
               //현재책사전에도 없으면 그냥 하나 만든다.
               NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
               [dic1 setValue:strWordOriSearch forKey:@"Word"];
               [arrWordSearchFamily addObject:dic1];

           }
        }
        [arrSearchWord removeAllObjects];
        NSRegularExpressionOptions nsOpt = NSRegularExpressionCaseInsensitive;        
        if (blnCaseSensitive == TRUE) {
            nsOpt = 0;
        }
        
        NSInteger i = 0;
        NSInteger cntOfArrWordSearchFamily = 0;
        for (NSMutableDictionary *dicOne in arrWordSearchFamily)
        {
            DLog(@"dicOne : %@", dicOne);
            NSString *strWordTemp = [[dicOne objectForKey:@"Word"] lowercaseString];
//            //단어패밀리로 찾을때가 아니면 strWordSearch일때만 한다.
//            if (blnHeadword == FALSE) {
            if ([[strWordTemp lowercaseString] isEqualToString:[strWordSearch lowercaseString]] == TRUE) {
                intSelTblRow = i++;
                if (blnCaseSensitive == TRUE) {
                    strWordTemp = [NSString stringWithString:strWordSearch];
                    [dicOne setObject:strWordSearch forKey:@"Word"];
//                    [arrWordSearchFamily replaceObjectAtIndex:cntOfArrWordSearchFamily withObject:strWordSearch];
                }
            }
            cntOfArrWordSearchFamily++;
//            }
            NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordTemp] options:nsOpt error:nil];
//            NSUInteger numberOfMatches = [regEx numberOfMatchesInString:strAllContentsInFile
//                                                                options:0
//                                                                  range:NSMakeRange(0, [strAllContentsInFile length])];
//            DLog(@"numberOfMatches : %d", numberOfMatches);
            
            NSArray *matches = [regEx matchesInString:strAllContentsInFile
                                              options:0
                                                range:NSMakeRange(0, [strAllContentsInFile length])];            
            NSMutableArray *arrOne = [[NSMutableArray alloc] init];
            
            for (NSTextCheckingResult *match in matches) {
                NSRange matchRange = [match range];
//                DLog(@"matchRange location: %d", matchRange.location);
//                DLog(@"matchRange length: %d", matchRange.length);    
                NSInteger pageNo = [myCommon getPageNoWithIndex:matchRange.location];
                if (pageNo < 0) {
                    continue;
                }
                
//                NSInteger startSentence = matchRange.location - 20;
                NSInteger startSentence = matchRange.location - 60;
#ifdef CHINESE
                startSentence = matchRange.location - 20;
#endif
                
                while (startSentence--) {
                    if (startSentence < 0) {
                        startSentence = 0;
                        break;
                    }
                    NSString *strChar = [strAllContentsInFile substringWithRange:NSMakeRange(startSentence, 1)];
//                    DLog(@"strChar : %@", strChar);
                    if ( ([strChar isEqualToString:@" "]) || ([strChar isEqualToString:@"\r"]) || ([strChar isEqualToString:@"\n"]) || ([strChar isEqualToString:@"\r\n"]) ) {
                        break;
                    }                    
                    
                }
//                NSInteger lengthSentence = 40;
                NSInteger lengthSentence = 120;                
                if ((startSentence + lengthSentence) > [strAllContentsInFile length]) {
                    lengthSentence = [strAllContentsInFile length] - startSentence;
//                    DLog(@"lengthSentence : %d", lengthSentence);
                }
                
                NSString *strSentence = [strAllContentsInFile substringWithRange:NSMakeRange(startSentence, lengthSentence)];

                NSMutableDictionary *dicTwo = [[NSMutableDictionary alloc] init];
                [dicTwo setValue:strWordTemp forKey:@"Word"];                
                [dicTwo setValue:[dicOne objectForKey:@"Know"] forKey:@"Know"];                

                
                NSMutableString *strHtmlSentence = [NSMutableString stringWithFormat:@"<html><body style=\"background-color:white\" topmargin=\"0\">%@</body></html>", strSentence];

                NSString *strWordBold = [NSString stringWithFormat:@"<FONT style=\"BACKGROUND-COLOR: lightgray\">%@</font>", strWordTemp];
                NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordTemp] options:NSRegularExpressionCaseInsensitive error:nil];
                
                [regEx2 replaceMatchesInString:strHtmlSentence options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strHtmlSentence length]) withTemplate:[NSString stringWithFormat:@"$1%@$3", strWordBold]];

                [dicTwo setValue:strHtmlSentence forKey:@"HtmlSentence"];
                [dicTwo setValue:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
                [dicTwo setValue:[NSNumber numberWithInt:matchRange.location] forKey:@"WordStartIndex"]; 
                
                [arrOne addObject:dicTwo];
                [arrSearchWord addObject:dicTwo];  
            }
            NSSortDescriptor *publishedSorter = nil;
            publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"WordStartIndex" ascending:YES];
            [arrOne sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
            DLog(@"strWordTemp : %@", strWordTemp);
            [dicWordSearchFamilyDetail setObject:arrOne forKey:strWordTemp];
        }
        intAllSearchedWords = [arrSearchWord count];
        DLog(@"arrSearchWord : %@", arrSearchWord);
        NSSortDescriptor *publishedSorter = nil;
        publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"WordStartIndex" ascending:YES];
        [arrSearchWord sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];
//        DLog(@"arrSearchWord : %@", arrSearchWord);
        if ([arrWordSearchFamily count] > 1) {
            DLog(@"1");
            NSMutableDictionary *dicThree = [[NSMutableDictionary alloc] init];
            DLog(@"2");            
            [dicThree setValue:@"[all words]" forKey:@"Word"];            
            DLog(@"3");            
            [arrWordSearchFamily addObject:dicThree];
            DLog(@"4");

            [dicWordSearchFamilyDetail setObject:arrSearchWord forKey:@"[all words]"];
            DLog(@"5");            
        }
        DLog(@"dicWordSearchFamilyDetail : %@", dicWordSearchFamilyDetail);
        
        if ([arrSearchWord count] == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"The word is not in the book : %@", strWordSearch]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
            [self.tblSearchWord reloadData];
        } else {
            [self.tblSearchWord reloadData];                
            intOriPage = currPageNo;
        }
    }
    [self reloadCurrentPage];
    [SVProgressHUD dismiss];
}

- (IBAction) onBtnWordSearchBack:(id)sender
{
    intSelTblRow--;
    if (intSelTblRow < 0) {
        intSelTblRow = 0;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];       
        return;
    }
    
    NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
    DLog(@"arrOne : %@", arrOne);
    NSMutableDictionary *dicOne = [arrOne objectAtIndex:intSelTblRow];

    NSInteger pageNoCurr = [[dicOne objectForKey:@"PageNo"] integerValue];    
    
    intIndexOfWordInSamePage--;
    if (pageNoCurr != intPageNoOfWordSearch) {

        //페이지가 바뀌면 한페이지내에서 선택된 단어가 위치한곳을 나타내는 index를 맨마지막으로 바꾼다.
        NSInteger intSelTblRowTemp = intSelTblRow;
        NSInteger intCntOfWordSearchInPageTemp = 0;
        do {
            NSMutableDictionary *dicOneTemp = [arrOne objectAtIndex:intSelTblRowTemp];
            DLog(@"dicOneTemp : %@", dicOneTemp);
            NSInteger pageNoTemp = [[dicOneTemp objectForKey:@"PageNo"] integerValue];       
            //한페이지 뒤로 갈때까지 intSelTblRow를 증가시킨다.
            if (pageNoCurr != pageNoTemp) {                
                break;
            }
            intCntOfWordSearchInPageTemp++;
        } while (intSelTblRowTemp--);
        intIndexOfWordInSamePage = intCntOfWordSearchInPageTemp;
        intPageNoOfWordSearch = pageNoCurr;
    }
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(GotoWordSearchBackOrForward:)
                                   userInfo:[NSNumber numberWithInt:intSelTblRow]
                                    repeats:NO];
}

- (void) GotoWordSearchBackOrForward:(NSTimer*)sender
{
    intSelTblRow = [[sender userInfo] integerValue];
    NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];    
    lblWordPage.text = [NSString stringWithFormat:@"%d/%d", intSelTblRow + 1, [arrOne count]];
    NSMutableDictionary *dicOne = [arrOne objectAtIndex:intSelTblRow];
    NSInteger currPageNoTemp = [[dicOne objectForKey:@"PageNo"] integerValue];

    currPageNo = currPageNoTemp;

    [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:currPageNoTemp] afterDelay:0.0f];
}

- (IBAction) onBtnWordSearchForward:(id)sender
{
    NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
    DLog(@"arrOne : %@", arrOne);
    intSelTblRow += 1;
    if (intSelTblRow > ([arrOne count] - 1)) {
        intSelTblRow = [arrOne  count] - 1;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Last", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];

        return;
    }

    NSMutableDictionary *dicOne = [arrOne objectAtIndex:intSelTblRow];
//    NSMutableDictionary *dicOneLastOccur = [arrOne objectAtIndex:([arrOne count] - 1)];    
//    NSString *strWordSearchTemp = [[dicOne objectForKey:@"Word"] lowercaseString];
    NSInteger pageNoCurr = [[dicOne objectForKey:@"PageNo"] integerValue];
//    NSInteger pageLastOccur = [[dicOneLastOccur objectForKey:@"PageNo"] integerValue];    
    //한페이지내에서 선택된 단어가 위치한곳을 나타내는 index를 하나씩 줄인다.
    intIndexOfWordInSamePage++;
    if (pageNoCurr != intPageNoOfWordSearch) {
        //페이지가 바뀌면 한페이지내에서 선택된 단어가 위치한곳을 나타내는 index를 1로 바꾼다.
        intIndexOfWordInSamePage = 1;
        intPageNoOfWordSearch = pageNoCurr;
    }

    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(GotoWordSearchBackOrForward:)
                                   userInfo:[NSNumber numberWithInt:intSelTblRow]
                                    repeats:NO];  
}
- (IBAction) onBtnWordSearchReopen:(id)sender
{
    [self performSelector:@selector(GoOnePage:) withObject:[NSNumber numberWithInteger:intOriPage] afterDelay:0.0f];    
    [self onBtnWordSearchCloseViewWordSearch:nil];
}


- (IBAction) onBtnWordSearchBackToPreviousPage:(id)sender
{
    
}
- (IBAction) onBtnWordSearchCloseViewWordSearch:(id)sender
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.5f];
    self.viewWordSearchBackAndForward.frame = CGRectMake(0.0, appHeight, self.view.frame.size.width, viewWordSearchBackAndForward.frame.size.height);    
    [UIView commitAnimations];

    self.viewWordSearchBackAndForward.hidden = TRUE;
    
    [arrWordSearchFamily    removeAllObjects];
    [dicWordSearchFamilyDetail  removeAllObjects];
    intAllSearchedWords = 0;
    blnWordSearchMode = FALSE;    
    self.strWordSearch = @"";
    self.strWordOriSearch = @"";
}

- (void) hideLblShowMeaning
{
    self.lblShowMeaning.text = @"";
}
#pragma mark -
#pragma mark UITextFieldDelegate methods   
- (BOOL) textFieldShouldReturn:(UITextField*)textField
{

    NSString	*strText = textField.text;
    DLog(@"textField.text : %@", textField.text);
        
    NSString *ptn = @"[*&^%$#@!<>\\[]=+,:;\"]";
    
    NSRange range = [strText rangeOfString:ptn options:NSRegularExpressionSearch];
    if (range.length > 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@ : *&^%%$#@!<>\\[]=+,:;\"",NSLocalizedString(@"Not allowed", @"")]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];        
    }
    
    NSError *err;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:ptn options:NSRegularExpressionCaseInsensitive error:&err];		
    strText = [regEx stringByReplacingMatchesInString:strText options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strText length]) withTemplate:@""];
    //연속되는 공백을 찾는 표현식
    NSRegularExpression *regE1 = [NSRegularExpression regularExpressionWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&err];
    strText = [regE1 stringByReplacingMatchesInString:strText options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strText length]) withTemplate:@""];
            
    textField.text = strText;

    DLog(@"textField.text : %@", textField.text);
	
	[textField resignFirstResponder];
	return YES;
}

- (void) openDicList:(NSTimer *)sender
{
    if (playType == PlayTypeMovie) {
        blnIsMoviePlaying = FALSE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
        [moviePlayer pause];
    }

	DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
    dicListController.intDicWordOrIdiom = DicWordOrIdiom_Word;
	dicListController.intDicListType = DicListType_TBL_EngDicEachBook;
	dicListController.intBookTblNo = self.intBookTblNo;
    dicListController.strAllContentsInFile = strAllContentsInFile;
    dicListController.strWhereClauseFldSQL = @"";
    dicListController.blnUseKnowButton = TRUE;
	[self.navigationController pushViewController:dicListController animated:YES];
		
	[SVProgressHUD dismiss];
}

- (void) openDicListForBookTemp:(NSString*)param
{	
    if (playType == PlayTypeMovie) {
        blnIsMoviePlaying = FALSE;
        self._currentPalyBackTime = moviePlayer.currentPlaybackTime;      
        [moviePlayer pause];
    }

    
	DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
    dicListController.intDicWordOrIdiom = DicWordOrIdiom_Word;    
	dicListController.intDicListType = DicListType_TBL_EngDicBookTemp;
	dicListController.intBookTblNo = -1;
//	dicListController.strBookTblName = @"BookTemp";
    DLog(@"param :%@", param);

    dicListController.strAllContentsInFile = param;	
    dicListController.strWhereClauseFldSQL = @"";
    dicListController.blnUseKnowButton = TRUE;
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:dicListController animated:YES];
	[SVProgressHUD dismiss];
}

- (void) callThreadShowMeaning
{ 
	actionSheetProgress = [[UIActionSheet alloc] initWithTitle:@"Prepare to write meaning...\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
    
    [actionSheetProgress showInView:self.view];
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
	progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, width-80, 20.0f)];
    progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
			
	[actionSheetProgress addSubview:progressViewInActionSheet];
    
    UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 40.0f);
	[aiv1 startAnimating];
	[actionSheetProgress addSubview:aiv1];
    
    [NSThread detachNewThreadSelector:@selector(threadShowMeaningNew:) toTarget:self withObject:nil];
}

- (void) updateProgress:(NSNumber*) param  {
	progressViewInActionSheet.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	actionSheetProgress.title = [NSString stringWithFormat:@"%@\n\n",  param];
}

- (void) callReadTxt:(NSString*) strType
{
    DLog(@"fileName : %@", strBookFullFileName);
    //테이블을 먼저 만들고 readTxt를 실행한다. sample일때는 처리를 안했다.(나중에 sample를 주석을 풀때 고려할것)
    DLog(@"intBookTblNo : %d", intBookTblNo);


    
    //ENG_DIC의 내용을 지운다.(blnMyDic에 따라서 MyEnglish.sqlite또는 각책의 sqlite에서 지운다.)
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_EngDic_BookTemp];
    NSInteger intOpenMyDic = OPEN_DIC_DB;    
    bool blnMyDic = TRUE;    
    if ( (intBookTblNo > 0) && ([[strType lowercaseString] isEqualToString:@""]) )  {
        strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TBL_EngDic];
        intOpenMyDic = OPEN_DIC_DB_BOOK;
        blnMyDic = FALSE;
    }
    [myCommon changeRec:strQuery openMyDic:blnMyDic];
    
        //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
        actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to analyze", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
        
//        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
//            //;
//            [actionSheetProgress showFromRect:CGRectMake(0 , 10, 500, 200) inView:self.view animated:YES];
//        } else {
            [actionSheetProgress showInView:self.view];
//        }

        actionSheetProgress.tag = 11;
        
        float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
        progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
        progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
        [actionSheetProgress addSubview:progressViewInActionSheet];
        
        UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);            
        [aiv1 startAnimating];
        [actionSheetProgress addSubview:aiv1];
        
        blnCancelReadTxt = FALSE;
#ifdef ENGLISH
        [NSThread detachNewThreadSelector:@selector(analyzeTxtEnglish:) toTarget:self withObject:strType];
#elif CHINESE
        [NSThread detachNewThreadSelector:@selector(analyzeTxtChinese:) toTarget:self withObject:strType];
#endif 
//    }

}

- (void) analyzeTxtEnglish:(NSObject*)obj
{
    @autoreleasepool {
        
        NSInteger  intReadTextType = intReadTextType_Book;
        DLog(@"obj : %@", (NSString*)obj);
        NSString *strTemp = nil;
        
        if ([(NSString*)obj isEqualToString:@""] == TRUE) {
            //HD.KIM 2013 May 3 : If obj is "", analyze the book entirely.
            intReadTextType = intReadTextType_Book;
            //HD.KIM 2013 May 3 : set strTemp with all texts in the book.
            strTemp = [NSString stringWithString:strAllContentsInFile];
            
        } else if ([(NSString*)obj isEqualToString:@"smartWordList"] == TRUE) {
            ////HD.KIM 2013 May 3 : This is no longer used
            intReadTextType = intReadTextType_SmartWordList;
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            DLog(@"board.string readTxt : %@", board.string);
            if ((board.string == NULL) || ([board.string isEqualToString:@""] == TRUE)) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First, You have to copy text.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            strTemp = [NSString stringWithString:board.string];
        } else {
            //HD.KIM 2013 May 3 : Analyze some amount of pages in the book.
            intReadTextType = intReadTextType_SmartWordList;
            NSInteger pages = [(NSString*)obj integerValue];
            if (pages < 0) {
                //HD.KIM 2013 May 3 : When you analyze previous pages from the current page
                pages++;
                //                DLog(@"obj : %d", pages);
                
                NSInteger realPage = 0 - currPageNo;
                if (realPage < pages) {
                    realPage = pages;
                }
                //                DLog(@"realPage : %d", realPage);
                NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo+realPage];
                NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
                
                NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo];
                NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];
                
                //            NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
                NSInteger offsetAll = offsetEnd - offsetStart;
                //HD.KIM 2013 May 3 : Get the selected page's text and set them to the variable(StrTemp)
                strTemp = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
                DLog(@"strTemp : %@", strTemp);
                DLog(@"offsetAll : %d", offsetAll);
            } else if (pages > 0) {
                //HD.KIM 2013 May 3 : When you analyze next pages from the current page.
                pages--;
                DLog(@"obj : %d", pages);
                
                NSInteger realPage = [arrPageInfo count] - currPageNo - 1;
                if (realPage > pages) {
                    realPage = pages;
                }
                NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo];
                NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
                
                NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo+realPage];
                NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];
                
                NSInteger offsetAll = offsetEnd - offsetStart;
                //HD.KIM 2013 May 3 : Get the selected page's text and set them to the variable(StrTemp)
                strTemp = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
                DLog(@"strTemp : %@", strTemp);
                DLog(@"offsetAll : %d", offsetAll);
            }
        }
        
        NSString *strContentForDicList = [NSString stringWithString:strTemp];
        
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Preparing to analyze", @"")] waitUntilDone:YES];
        
        NSDate		*startTime1 = [NSDate date];
        //	DLog(@"startTime1 : %@", startTime1);
        
        
        NSString *regStrExceptEnglish = @"[^a-zA-Z]";
        
        //HD.KIM 2013 May 3 : delete all characters except alphabet with regular expression (Capital and non-capital)
        //정규표현식으로 영어 대소문자를 제외하고 모두 지운다.
        NSError *err = nil;
        NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regStrExceptEnglish options:NSRegularExpressionCaseInsensitive error:&err];
        //        //연속되는 공백을 찾는 표현식
        //        NSRegularExpression *regEx5 = [NSRegularExpression regularExpressionWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&err];
        NSString  *strTemp1 = [regEx stringByReplacingMatchesInString:strTemp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strTemp length]) withTemplate:@" "];

        NSArray *arrAllWordsInBook = [[strTemp1 lowercaseString] componentsSeparatedByString:@" "];
        [self performSelectorOnMainThread:@selector(addCancelButton:) withObject:nil waitUntilDone:YES];
        
        NSInteger	wordCnt = 0;
        NSInteger	wordAppearOrder = 0;
        //	NSInteger sampleCnt = [arrAllWordsInBook count];
        
        //HD.KIM 2013 May 3 : close and reopen MyEnglish.sqlite and use transaction (parameter true means MyEnglish.sqlite)
        [myCommon closeDB:true];
        [myCommon openDB:true];
        [myCommon transactionBegin:true];
        
        if (intViewType == viewTypeBook) {
            //HD.KIM 2013 May 3 : if you are in a book mode you need to update the book's sqlite too and use transaction.
            [myCommon closeDB:false];
            [myCommon openDB:false];
            [myCommon transactionBegin:FALSE];
        }
        
        //HD.KIM 2013 May 3 : dictionay has each word and each word's count
        //단어들을 빈도를 합하여 dicWordsInTxt로 저장한다.
        NSMutableDictionary *dicWordsInTxt = [[NSMutableDictionary alloc] init];
        
        
        //HD.KIM 2013 May 3 : arrAllWordsInbook has all words in the book and get unique words list and count of the words.
        //단어들을 돌면서 유일한 단어를 뽑아낸다.
        for (int i = 0; i < [arrAllWordsInBook count]; ++i) {
            NSString *strOne = [arrAllWordsInBook objectAtIndex:i];
            
            float	fVal = wordCnt++ / ((float)[arrAllWordsInBook count]);
            NSString *strMsg = [NSString stringWithFormat:@"(1/2) %@... %@", NSLocalizedString(@"Extracting words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            //            DLog(@"strOne : %@", strOne);
            if ([strOne isEqualToString:@""] == TRUE) {
                continue;
            }

            if (blnCancelReadTxt == TRUE) {

                [SVProgressHUD showErrorWithStatus:@"Analyzing Canceled"];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
            
                return;
            }
            
            NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
            
            NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOne];
            //HD.KIM 2013 May 3 : get the basic form of the word in the MyEnglish.sqilte. (If strOne is "went", strOneOri should be "go")
            NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strOne];
            NSString *strOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneOri];
            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, FldName_WordLength];
            
            NSString *strNextOne = @"";
            if ( (i + 1) < ([arrAllWordsInBook count]) ){
                strNextOne = [arrAllWordsInBook objectAtIndex:i+1];
                NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
                NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
                
                strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@ %@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, strNextOneOriForSQL, FldName_WordLength];

            }
            //HD.KIM 2013 May 3 : Get all "WORD" field's word if FldName_FirstWord has word it means "WORD" is not just ONE word but made with 2 ore more words
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
            
            NSMutableString *strOverOneWord = [NSMutableString stringWithString:strOneForSQL];
            NSMutableString *strOverOneWordInText = [NSMutableString stringWithString:@""];
            NSMutableString *strOverOneWordOri = [NSMutableString stringWithString:@""];

            

            //HD.KIM 2013 May 3 : Put a word in the dicWordsInTxt with count of the word.
            //한글자를 저장한다.
            BOOL containsKey = ([dicWordsInTxt objectForKey:strOne] != nil);
            if (containsKey == FALSE) {
                //HD.KIM 2013 May 3 : When you meet the word first time in the book.
                NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrder++],[NSNumber numberWithInt:1], nil];
                
                //DLog(@"arrOne %@ : %@", strOne, arrOne);
                //[dicWordsInTxt setValue:[NSNumber numberWithInt:1] forKey:strOne];
                [dicWordsInTxt setObject:arrOne forKey:strOne];
            } else {
                //HD.KIM 2013 May 3 : When you meet the word more than one time. (you plus 1 to the COUNT of the word)
                NSArray *arrTemp1 =  [dicWordsInTxt objectForKey:strOne];
                NSInteger wordAppearOrderTemp = [[arrTemp1 objectAtIndex:0] intValue];
                NSInteger countSum = [[arrTemp1 objectAtIndex:1] intValue] + 1;
                
                //NSInteger countSum = [[dicWordsInTxt objectForKey:strOne] intValue] + 1;
                NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrderTemp],[NSNumber numberWithInt:countSum], nil];
        
                [dicWordsInTxt setObject:arrOne forKey:strOne];
            }
            if ([arrAllOne count] > 0) {
                //HD.KIM 2013 May 3 : if pharasal verb or idiom's case
                //숙어나 문장의 경우... (두단어 이상으로 이루어진다.)
                 NSInteger indexWordLength = 1;
                BOOL blnHasWordInDic = FALSE;
                NSInteger indexITemp = i;
                
                //HD.KIM 2013 May 3 : make sure the pharasal verb is in the book.
                //2단어 이상으로 이루어진것부터 찾는다.
                if ((indexITemp + 2) < [arrAllWordsInBook count]) {
                    [strOverOneWordOri appendFormat:@"%@,", strOneOriForSQL];
                    [strOverOneWordInText appendFormat:@"%@", strOneForSQL];                    
                    
                    
//                    DLog(@"arrAllOne : %@", arrAllOne);
                    for (NSDictionary *dicOne in arrAllOne) {
//                        DLog(@"dicOne : %@", dicOne);
                        NSString *strWordOriInDicOne = [dicOne objectForKey:KEY_DIC_WORDORI];
//                        DLog(@"strWordOriInDicOne : %@", strWordOriInDicOne);
                        //HD.KIM 2013 May 3 : get the word's length in the dicOne
                        NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
//                        DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                        if ((indexITemp + intWordLengthInDicOne) >= [arrAllWordsInBook count] ) {
                            break;
                        }
                        
                        //HD.KIM 2013 May 3 : Get the next word in the book. if this first time in the "for loop" must get second word (You know here is pharal verb(over 2 words)
                        if (indexWordLength != intWordLengthInDicOne) {                            
                            for (int j = 1; j < intWordLengthInDicOne; ++j) {
                                
                                NSString *strNextOne = [arrAllWordsInBook objectAtIndex:indexITemp+j];
                                NSString *strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
                                NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
                                NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
                                
                                [strOverOneWordOri appendFormat:@"%@,",strNextOneOriForSQL];
                                [strOverOneWordInText appendFormat:@" %@",strNextOneForSQL];                               
                            }
                            indexWordLength = intWordLengthInDicOne;
                        }
                        if ([strWordOriInDicOne isEqualToString:strOverOneWordOri] == TRUE) {
                            blnHasWordInDic = TRUE;
//                            DLog(@"dicOne : %@", dicOne);
                            strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
                            indexITemp += indexWordLength - 1;
                        }
                    }                
                }
                //숙어를 저장한다. be absorbed in등
                BOOL containsKey = ([dicWordsInTxt objectForKey:strOverOneWord] != nil);
                if (containsKey == FALSE) {
                    NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt:(wordAppearOrder - 1)],[NSNumber numberWithInt:1], nil];
                    [dicWordsInTxt setObject:arrOne forKey:strOverOneWord];
                } else {
                    NSArray *arrTemp1 =  [dicWordsInTxt objectForKey:strOverOneWord];
                    NSInteger wordAppearOrderTemp = [[arrTemp1 objectAtIndex:0] intValue];
                    NSInteger countSum = [[arrTemp1 objectAtIndex:1] intValue] + 1;
                    NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrderTemp],[NSNumber numberWithInt:countSum], nil];
                    [dicWordsInTxt setObject:arrOne forKey:strOverOneWord];
                }
            }
        }
    
        NSString *strMeaning = @"";
        NSString *strKnow = @"";
        NSInteger       levelOfWord = 0;
        NSInteger       countOfWord = 0;
        NSString *strWordOri = @"";
        
        NSInteger cntKnow = 0;
        NSInteger cntKnowAlmost = 0;
        NSInteger cntWordNotInTbl = 0;
        NSInteger cntOfWordLength = 0;
        NSString *strFirstTwoWord = @"";
        int i = 0;
        int maxDicWordsInTxt = [dicWordsInTxt count];
        BOOL blnWordOriExist = FALSE;
        
        for (NSString __strong *strOne in dicWordsInTxt)
        {
            DLog(@"strOne : %@", strOne);
            if (blnCancelReadTxt == TRUE) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Cancelled analyzing the book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            
            blnWordOriExist = FALSE;
            strOne = [strOne lowercaseString];
            float fVal = (float)i++ / maxDicWordsInTxt;
            NSString *strMsg = [NSString stringWithFormat:@"(2/2) %@... %@", NSLocalizedString(@"Finding unknown words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            
            NSInteger countSum = [[[dicWordsInTxt objectForKey:strOne] objectAtIndex:1] intValue]; //빈도를 가져온다.
            wordAppearOrder = [[[dicWordsInTxt objectForKey:strOne] objectAtIndex:0] intValue]; //단어가 나타난 순서를 가져온다.
            
            NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOne];
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strOneForSQL];
            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
            
            NSDictionary *dicOne = [dicAllOne objectForKey:[strOne lowercaseString]];

            
            strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
            strKnow = [dicOne objectForKey:KEY_DIC_KNOW];
            strWordOri = [dicOne objectForKey:KEY_DIC_WORDORI];
            countOfWord = [[dicOne objectForKey:@"Count"] integerValue];
            levelOfWord = [[dicOne objectForKey:@"Level"] integerValue];
            cntOfWordLength = [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
            strFirstTwoWord = [dicOne objectForKey:KEY_DIC_FirstWord];
            
            
            NSString *strMeaningForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strMeaning];
            
            NSString *strFirstTwoWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstTwoWord];
            
            NSString *strWordOriForSQL = @"";
            if ((strWordOri == NULL) || ([strWordOri isEqualToString:@""])) {
                //원형이 없으면 원형을 현재단어로 한다.
                strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOne];
                strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_WORDORI, strWordOriForSQL, FldName_Word, strOneForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            } else {
                strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
            }
            
            //사전에 없는 단어일때는
            if (dicOne == NULL) {
                cntWordNotInTbl++;
                strKnow = @"-1";
                strMeaning = @"";
                
                //            continue;
            }
            strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_COUNT, countOfWord + countSum, FldName_Word, strOneForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            if (intReadTextType == intReadTextType_Book) {
                //ananyze일때...
                NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES('%@',%d, \"%@\",'%@', 0, %d, %d, '%@', %d, '%@')", TBL_EngDic, FldName_Word, FldName_COUNT, FldName_Know, FldName_Meaning, FldName_ToMemorize, FldName_WORDLEVEL1, FldName_WORDORDER, FldName_WORDORI, FldName_WordLength, FldName_FirstWord, strOneForSQL, countSum, strKnow, strMeaningForSQL, levelOfWord, wordAppearOrder, strWordOriForSQL, cntOfWordLength, strFirstTwoWordForSQL];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            } else {
                //analyze가 아닐때는 TBL_EngDic_BookTemp에 넣는다.
                NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES('%@',%d, \"%@\",'%@', 0, %d, %d, '%@', %d, '%@')", TBL_EngDic_BookTemp, FldName_Word, FldName_COUNT, FldName_Know, FldName_Meaning, FldName_ToMemorize, FldName_WORDLEVEL1, FldName_WORDORDER, FldName_WORDORI, FldName_WordLength, FldName_FirstWord, strOneForSQL, countSum, strKnow, strMeaningForSQL, levelOfWord, wordAppearOrder, strWordOriForSQL, cntOfWordLength, strFirstTwoWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
            
            NSInteger intKnow = [strKnow integerValue];
            if (intKnow >= 3) {
                cntKnow++;
            } else if (intKnow == 2) {
                cntKnowAlmost++;
            }
        }
        [myCommon transactionCommit:true];
        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        if (intViewType == viewTypeBook) {
            [myCommon transactionCommit:false];
            [myCommon closeDB:false];
            [myCommon openDB:false];
        }
        
        NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
        NSInteger minutes = elapsedTime/60;
        NSInteger seconds = round(elapsedTime - minutes * 60);
        NSString	*strElapsedTime  = nil;
        if (elapsedTime >= 60) {
            strElapsedTime = [NSString stringWithFormat:@"%d분 %d초 소요", minutes, seconds];
        } else {
            strElapsedTime = [NSString stringWithFormat:@"%d초 소요", seconds];
        }
        DLog(@"Elapsed time: %.0f, %@", elapsedTime, strElapsedTime);
        
        NSString *strDifficult = @"";
        NSString *strMsg = @"";
        
        //	if ((intReadTextType != intReadTextType_SmartWordList) && (maxDicWordsInTxt> 0)) {
        if ((intReadTextType == intReadTextType_Book) && (maxDicWordsInTxt> 0)) {
            float score = ((float)cntKnow/maxDicWordsInTxt) * 100;
            
            strDifficult = [self getBookDifficulty1:[NSNumber numberWithFloat: score]];
            
            NSInteger cntOfUnKnownWords = maxDicWordsInTxt - cntKnow - cntWordNotInTbl;
            float precentageOfKnownWords = ((float)cntKnow/maxDicWordsInTxt) * 100;
            float precentageOfUnKnownWords = ((float)cntOfUnKnownWords/maxDicWordsInTxt) * 100;
            //        float precentageOfWordNotInTbl = ((float)cntWordNotInTbl/maxDicWordsInTxt) * 100;
            
            //TODO) locale는 사용자에게 맞게 맞추어 주어야한다.
            NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
            NSDecimalNumber *someAmount = nil;
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [currencyFormatter setLocale:locale];
            
            DLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
            
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", [arrAllWordsInBook count]]];
            NSString *strCntOfAllWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", maxDicWordsInTxt]];
            NSString *strCntOfUniqueWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntKnow]];
            NSString *strCntOfKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUnKnownWords]];
            NSString *strCntOfUnKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntWordNotInTbl]];
            NSString *strCntOfWordsNotInBook = [currencyFormatter stringFromNumber:someAmount];
            
            
            strMsg = [NSString stringWithFormat:@"( %@ : %@ )\n%@ : %@\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@", NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"All Words", @""),strCntOfAllWords, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
            
#ifdef DEBUG
            strMsg = [NSString stringWithFormat:@"%@ : %@\n( %@ : %@ )\n%@ : %@\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@",NSLocalizedString(@"time", @""), strElapsedTime, NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"All Words", @""),strCntOfAllWords, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
#endif
            NSString	*strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_BOOK_LIST_BookLength, [strAllContentsInFile length], FldName_BOOK_LIST_WORD_COUNT_ALL,  [arrAllWordsInBook count], FldName_BOOK_LIST_WORD_COUNT_UNIQUE, maxDicWordsInTxt, FldName_BOOK_LIST_WORD_COUNT_UNKNOWN, cntOfUnKnownWords, FldName_BOOK_LIST_WORD_COUNT_NOTSURE, cntKnowAlmost, FldName_BOOK_LIST_WORD_COUNT_KNOWN, cntKnow, FldName_BOOK_LIST_WORD_COUNT_EXCLUDE, cntWordNotInTbl,   FldName_BOOK_LIST_ID, intBookTblNo];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
        NSString *strTitle = NSLocalizedString(@"Finish analyzing", @"");

        //	self.self.navigationItem.title = strTitle;
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;
        
        arrAllWordsInBook = nil;
        DLog(@"finish-1");
        
        if (intReadTextType != intReadTextType_Book) {
            if (PickerViewType == intPickerViewTypeInBook_NextPages) {
                [self performSelectorOnMainThread:@selector(openDicListForBookTemp:) withObject:strContentForDicList	waitUntilDone:YES];
            } else if (PickerViewType == intPickerViewTypeInBook_ExamPages) {
                [self performSelectorOnMainThread:@selector(openExam:) withObject:strContentForDicList	waitUntilDone:YES];
            } else if (PickerViewType == intPickerViewTypeInBook_TTSPages) {
                [self performSelectorOnMainThread:@selector(openTTS:) withObject:strContentForDicList	waitUntilDone:YES];
            }
        }
        
        if ([(NSString*)obj isEqualToString:@"smartWordList"] == TRUE) {
            if (intReadTextType != intReadTextType_Book) {
                [self performSelectorOnMainThread:@selector(openDicListForBookTemp:) withObject:strContentForDicList	waitUntilDone:YES];
            }
        }
        
        //책을 분석한 결과를 보여준다.
        if (intReadTextType == intReadTextType_Book) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", strTitle]	message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            //이건 그냥 Show를 하면 죽어서 performSelectorOnMainThread에서 처리를 했다...
//            [alert show];
            
        }
        
        DLog(@"finish");
	}
    
}
- (void) analyzeTxtChinese:(NSObject*)obj
{
    @autoreleasepool {
        
        NSInteger  intReadTextType = intReadTextType_Book;
        DLog(@"obj : %@", (NSString*)obj);
        NSString *strTemp = nil;
        if ([(NSString*)obj isEqualToString:@""] == TRUE) {
            intReadTextType = intReadTextType_Book;
            strTemp = [NSString stringWithString:strAllContentsInFile];
            
        } else if ([(NSString*)obj isEqualToString:@"smartWordList"] == TRUE) {
            intReadTextType = intReadTextType_SmartWordList;
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            DLog(@"board.string readTxt : %@", board.string);
            if ((board.string == NULL) || ([board.string isEqualToString:@""] == TRUE)) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First, You have to copy text.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            strTemp = [NSString stringWithString:board.string];
        } else {
            intReadTextType = intReadTextType_SmartWordList;
            NSInteger pages = [(NSString*)obj integerValue];
            if (pages < 0) {
                pages++;
                DLog(@"obj : %d", pages);
                
                NSInteger realPage = 0 - currPageNo;
                if (realPage < pages) {
                    realPage = pages;
                }
                DLog(@"realPage : %d", realPage);
                NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo+realPage];
                NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
                
                NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo];
                NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];
                
                NSInteger offsetAll = offsetEnd - offsetStart;
                strTemp = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
                DLog(@"strTemp : %@", strTemp);
                DLog(@"offsetAll : %d", offsetAll);
            } else if (pages > 0) {
                pages--;
                DLog(@"obj : %d", pages);
                
                NSInteger realPage = [arrPageInfo count] - currPageNo - 1;
                if (realPage > pages) {
                    realPage = pages;
                }
                NSDictionary *dicOneStart = [arrPageInfo objectAtIndex:currPageNo];
                NSInteger offsetStart = [[dicOneStart objectForKey:@"OffsetStart"] integerValue];
                
                NSDictionary *dicOneEnd = [arrPageInfo objectAtIndex:currPageNo+realPage];
                NSInteger offsetEnd = [[dicOneEnd objectForKey:@"OffsetEnd"] integerValue];
                
                
                //            NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
                NSInteger offsetAll = offsetEnd - offsetStart;
                strTemp = [strAllContentsInFile substringWithRange: NSMakeRange(offsetStart, offsetAll)];
                DLog(@"strTemp : %@", strTemp);
                DLog(@"offsetAll : %d", offsetAll);
            }
        }
        
        NSString *strContentForDicList = [NSString stringWithString:strTemp];
        
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Preparing to analyze", @"")] waitUntilDone:YES];
        
        NSDate		*startTime1 = [NSDate date];
        //	DLog(@"startTime1 : %@", startTime1);
        
        
        NSString *regStrExceptChinese = @"[^\u4e00-\u4eff\u4f00-\u4fff\u5000-\u50ff\u5100-\u51ff\u5200-\u52ff\u5300-\u53ff\u5400-\u54ff\u5500-\u55ff\u5600-\u56ff\u5700-\u57ff\u5800-\u58ff\u5900-\u59ff\u5a00-\u5aff\u5b00-\u5bff\u5c00-\u5cff\u5d00-\u5dff\u5e00-\u5eff\u5f00-\u5fff\u6000-\u60ff\u6100-\u61ff\u6200-\u62ff\u6300-\u63ff\u6400-\u64ff\u6500-\u65ff\u6600-\u66ff\u6700-\u67ff\u6800-\u68ff\u6900-\u69ff\u6a00-\u6aff\u6b00-\u6bff\u6c00-\u6cff\u6d00-\u6dff\u6e00-\u6eff\u6f00-\u6fff\u7000-\u70ff\u7100-\u71ff\u7200-\u72ff\u7300-\u73ff\u7400-\u74ff\u7500-\u75ff\u7600-\u76ff\u7700-\u77ff\u7800-\u78ff\u7900-\u79ff\u7a00-\u7aff\u7b00-\u7bff\u7c00-\u7cff\u7d00-\u7dff\u7e00-\u7eff\u7f00-\u7fff\u8000-\u80ff\u8100-\u81ff\u8200-\u82ff\u8300-\u83ff\u8400-\u84ff\u8500-\u85ff\u8600-\u86ff\u8700-\u87ff\u8800-\u88ff\u8900-\u89ff\u8a00-\u8aff\u8b00-\u8bff\u8c00-\u8cff\u8d00-\u8dff\u8e00-\u8eff\u8f00-\u8fff\u9000-\u90ff\u9100-\u91ff\u9200-\u92ff\u9300-\u93ff\u9400-\u94ff\u9500-\u95ff\u9600-\u96ff\u9700-\u97ff\u9800-\u98ff\u9900-\u99ff\u9a00-\u9aff\u9b00-\u9bff\u9c00-\u9cff\u9d00-\u9dff\u9e00-\u9eff\u9f00-\u9fff]";
        
        
        //정규표현식으로 중국어의 경우에는 한자를 제외하고 다 지운다.
        NSError *err = nil;
        NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regStrExceptChinese options:NSRegularExpressionCaseInsensitive error:&err];
        NSString  *strTemp1 = [regEx stringByReplacingMatchesInString:strTemp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strTemp length]) withTemplate:@" "];
        NSArray *arrAllWordsInBook = [[strTemp1 lowercaseString] componentsSeparatedByString:@" "];
//        DLog(@"\n\nstrTemp1 : %@", strTemp1);
//        DLog(@"\n\nstrTemp1 : %@", strTemp1);
        [self performSelectorOnMainThread:@selector(addCancelButton:) withObject:nil waitUntilDone:YES];
        
        NSInteger	wordAppearOrder = 0;
        NSInteger   intWordOffset = 0;
        //	NSInteger sampleCnt = [arrAllWordsInBook count];
        
        [myCommon closeDB:true];
        [myCommon openDB:true];
        [myCommon transactionBegin:true];
        
        if (intViewType == viewTypeBook) {
            [myCommon closeDB:false];
            [myCommon openDB:false];
            [myCommon transactionBegin:FALSE];
        }
        
        
        
        //단어들을 빈도를 합하여 dicWordsInTxt로 저장한다.
        NSMutableDictionary *dicWordsInTxt = [[NSMutableDictionary alloc] init];
        
//        NSMutableArray *arrWords = [[NSMutableArray alloc] init];
//        NSMutableArray *arrOffsets = [[NSMutableArray alloc] init];
        //단어들을 돌면서 유일한 단어를 뽑아낸다.
        for (int i = 0; i < [strTemp1 length]; i++) {
            float	fVal = i / ((float)[strTemp1 length]);
            NSString *strMsg = [NSString stringWithFormat:@"(1/2) %@... %@", NSLocalizedString(@"Extracting words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];

            
            NSString *strOneWord = [strTemp1 substringWithRange:NSMakeRange(i, 1)];// [arrMutableTemp11 objectAtIndex:i];// substringWithRange: NSMakeRange(i, 1)];
//            DLog(@"strOneWord : %@", strOneWord);

            if ( ([strOneWord isEqualToString:@""] == TRUE) || ([strOneWord isEqualToString:@" "] == TRUE) ) {
                intWordOffset++;
                continue;
            }

            if (blnCancelReadTxt == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled analyzing the book.", @"")];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            
            //일단 본문에서 4자 이상이 있는지 본다.
            NSMutableString *strOverOneWord = [NSMutableString stringWithString:@""];
            NSInteger indexWordLengthTRUE = 1;
            BOOL blnHasWordInDic = FALSE;
            
            NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
            
            if ((i + 4) < [strTemp1 length] ) {
                strOverOneWord = [NSMutableString stringWithFormat:@""];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+0, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+1, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+2, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+3, 1)]];
//                DLog(@"strOverOneWord : %@", strOverOneWord);
                NSInteger indexWordLength = 4;
                indexWordLengthTRUE = 4;
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOverOneWord, FldName_WordLength];
                
                //            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
                
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                
                //            NSInteger intMaxWordLength = [myCommon getIntFldValueFromTbl:strQuery openMyDic:TRUE];
                
                if ([arrAllOne count] >= 2) {
                    indexWordLength = 4;
//                    DLog(@"arrAllOne : %@", arrAllOne);
                }
                if ([arrAllOne count] >= 1) {
                    for (NSDictionary *dicOne in arrAllOne) {
                        //                    NSDictionary *dicOne = [dicAllOne objectForKey:strWordKey];
//                        DLog(@"dicOne : %@", dicOne);
                        //                    DLog(@"strWordKey : %@", strWordKey);
                        NSString *strWordInDicOne = [dicOne objectForKey:FldName_Word];
//                        DLog(@"strWordInDicOne : %@", strWordInDicOne);
                        NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_FirstWord] integerValue];
//                        DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                        if ((i + indexWordLength) >= [strTemp1 length] ) {
                            break;
                        }
                        
                        if (indexWordLength != intWordLengthInDicOne) {
                            
                            [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+indexWordLength, 1)]];
                            // [arrMutableTemp11 objectAtIndex:(i + indexWordLength)]];
//                            DLog(@"strOverOneWord : %@", strOverOneWord);
                            indexWordLength++;
//                            DLog(@"AFTER indexWordLength : %d", indexWordLength);
                        }
                        
//                        DLog(@"strWordInDicOne : %@", strWordInDicOne);
//                        DLog(@"strOverOneWord : %@", strOverOneWord);
                        if ([strWordInDicOne isEqualToString:strOverOneWord] == TRUE) {
                            strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                            blnHasWordInDic = TRUE;
                            indexWordLengthTRUE = indexWordLength;
//                            DLog(@"strOneWord : %@", strOneWord);
                        }
                        
                    }
                }
            }
            
            //본문의 3글자에 해당되는 단어가 사전에 있는지 본다.
            if ( ( blnHasWordInDic == FALSE) && ((i + 3) < [strTemp1 length] ) ){
                strOverOneWord = [NSMutableString stringWithFormat:@""];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+0, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+1, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+2, 1)]];
//                DLog(@"strOverOneWord : %@", strOverOneWord);
                indexWordLengthTRUE = 3;
                
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                if ([arrAllOne count] >= 1) {
                    blnHasWordInDic = TRUE;
                    strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                }
            }
            
            //본문의 2글자에 해당되는 단어가 사전에 있는지 본다.
            if ( ( blnHasWordInDic == FALSE) && ((i + 2) < [strTemp1 length] ) ){
                strOverOneWord = [NSMutableString stringWithFormat:@""];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+0, 1)]];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+1, 1)]];
//                DLog(@"strOverOneWord : %@", strOverOneWord);
                indexWordLengthTRUE = 2;
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                if ([arrAllOne count] >= 1) {
                    blnHasWordInDic = TRUE;
                    strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                }
                
            }
            
            //본문의 1글자에 해당되는 단어가 사전에 있는지 본다.
            if ( ( blnHasWordInDic == FALSE) && ((i + 1) < [strTemp1 length] ) ){
                strOverOneWord = [NSMutableString stringWithFormat:@""];
                [strOverOneWord appendString:[strTemp1 substringWithRange:NSMakeRange(i+0, 1)]];
//                DLog(@"strOverOneWord : %@", strOverOneWord);
                indexWordLengthTRUE = 1;
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
                if ([arrAllOne count] >= 1) {
                    blnHasWordInDic = TRUE;
                    strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
                }
                
            }

            i = i + indexWordLengthTRUE - 1;
//            DLog(@"AFTER i : %d", i);

            BOOL containsKey = ([dicWordsInTxt objectForKey:strOneWord] != nil);
            if (containsKey == FALSE) {
                NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrder++],[NSNumber numberWithInt:1], nil];
                
                //DLog(@"arrOne %@ : %@", strOne, arrOne);
                //[dicWordsInTxt setValue:[NSNumber numberWithInt:1] forKey:strOne];
                [dicWordsInTxt setObject:arrOne forKey:strOneWord];
            } else {
                NSArray *arrTemp1 =  [dicWordsInTxt objectForKey:strOneWord];
                NSInteger wordAppearOrderTemp = [[arrTemp1 objectAtIndex:0] intValue];
                NSInteger countSum = [[arrTemp1 objectAtIndex:1] intValue] + 1;
                
                //NSInteger countSum = [[dicWordsInTxt objectForKey:strOne] intValue] + 1;
                NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrderTemp],[NSNumber numberWithInt:countSum], nil];
            
                [dicWordsInTxt setObject:arrOne forKey:strOneWord];
            }
            
            //두글자 이상일때는 한글자 한글자를 다 dicWordsInTxt에 넣는다.
            if ([strOneWord length] > 1) {
                DLog(@"strOneWord : %@", strOneWord);
                for (NSInteger indexWord = 0; indexWord < [strOneWord length]; indexWord++) {
                    NSString *strOneCharInWord = [strOneWord substringWithRange:NSMakeRange(indexWord, 1)];
                    DLog(@"strOneCharInWord : %@", strOneCharInWord);
                    BOOL containsKey = ([dicWordsInTxt objectForKey:strOneCharInWord] != nil);
                    if (containsKey == FALSE) {
                        NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrder++],[NSNumber numberWithInt:1], nil];
                        
                        [dicWordsInTxt setObject:arrOne forKey:strOneCharInWord];
                    } else {
                        NSArray *arrTemp1 =  [dicWordsInTxt objectForKey:strOneCharInWord];
                        NSInteger wordAppearOrderTemp = [[arrTemp1 objectAtIndex:0] intValue];
                        NSInteger countSum = [[arrTemp1 objectAtIndex:1] intValue] + 1;
                        
                        NSArray *arrOne = [NSArray arrayWithObjects:[NSNumber numberWithInt: wordAppearOrderTemp],[NSNumber numberWithInt:countSum], nil];
                    
                        [dicWordsInTxt setObject:arrOne forKey:strOneCharInWord];
                    }
                }
            }
            
            
            intWordOffset += [strOneWord length];
            
            intWordOffset++;
        }
        
        NSString *strMeaning = @"";
        NSString *strKnow = @"";
        NSInteger       levelOfWord = 0;
        NSInteger       countOfWord = 0;
        NSString *strWordOri = @"";
        
        NSInteger cntKnow = 0;
        NSInteger cntKnowAlmost = 0;
        NSInteger cntWordNotInTbl = 0;
        int i = 0;
        int maxDicWordsInTxt = [dicWordsInTxt count];
        BOOL blnWordOriExist = FALSE;
        
        for (NSString __strong *strOne in dicWordsInTxt)
        {
            //        DLog(@"strOne : %@", strOne);
            if (blnCancelReadTxt == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled analyzing the book.", @"")];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            
            blnWordOriExist = FALSE;
            float fVal = (float)i++ / maxDicWordsInTxt;
            NSString *strMsg = [NSString stringWithFormat:@"(2/2) %@... %@", NSLocalizedString(@"Finding unknown words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];

            NSInteger countSum = [[[dicWordsInTxt objectForKey:strOne] objectAtIndex:1] intValue]; //빈도를 가져온다.
            wordAppearOrder = [[[dicWordsInTxt objectForKey:strOne] objectAtIndex:0] intValue]; //단어가 나타난 순서를 가져온다.
            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strOne];
            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
            
            NSDictionary *dicOne = [dicAllOne objectForKey:[strOne lowercaseString]];
            
            
            strMeaning = [dicOne objectForKey:@"Meaning"];
            strKnow = [dicOne objectForKey:@"Know"];
            strWordOri = [dicOne objectForKey:@"WordOri"];
            countOfWord = [[dicOne objectForKey:@"Count"] integerValue];
            levelOfWord = [[dicOne objectForKey:@"Level"] integerValue];
            
            //사전에 없는 단어일때는
            if (dicOne == NULL) {
                cntWordNotInTbl++;
                strKnow = @"-1";
                strMeaning = @"";
                DLog(@"strOne : %@", strOne);
                //            continue;
            }
            strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_COUNT, countOfWord + countSum, FldName_Word, strOne];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            
            if (intReadTextType == intReadTextType_Book) {
                //ananyze일때...
                NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@) VALUES('%@',%d, \"%@\",\"%@\", 0, %d, %d, \"%@\")", TBL_EngDic, FldName_Word, FldName_COUNT, FldName_Know, FldName_Meaning, FldName_ToMemorize, FldName_WORDLEVEL1, FldName_WORDORDER, FldName_WORDORI, strOne, countSum, strKnow, strMeaning, levelOfWord, wordAppearOrder, strOne];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            } else {
                //analyze가 아닐때는 TBL_EngDic_BookTemp에 넣는다.
                NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@) VALUES('%@',%d, \"%@\",\"%@\", 0, %d, %d, \"%@\")", TBL_EngDic_BookTemp, FldName_Word, FldName_COUNT, FldName_Know, FldName_Meaning, FldName_ToMemorize, FldName_WORDLEVEL1, FldName_WORDORDER, FldName_WORDORI, strOne, countSum, strKnow, strMeaning, levelOfWord, wordAppearOrder, strOne];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
            
            NSInteger intKnow = [strKnow integerValue];
            if (intKnow >= 3) {
                cntKnow++;
            } else if (intKnow == 2) {
                cntKnowAlmost++;
            }
        }
        [myCommon transactionCommit:true];
        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        if (intViewType == viewTypeBook) {
            [myCommon transactionCommit:false];
            [myCommon closeDB:false];
            [myCommon openDB:false];
        }
        
        NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
        NSInteger minutes = elapsedTime/60;
        NSInteger seconds = round(elapsedTime - minutes * 60);
        NSString	*strElapsedTime  = nil;
        if (elapsedTime >= 60) {
            strElapsedTime = [NSString stringWithFormat:@"%d분 %d초 소요", minutes, seconds];
        } else {
            strElapsedTime = [NSString stringWithFormat:@"%d초 소요", seconds];
        }
        DLog(@"Elapsed time: %.0f, %@", elapsedTime, strElapsedTime);
        
        NSString *strDifficult = @"";
        NSString *strMsg = @"";
        
        //	if ((intReadTextType != intReadTextType_SmartWordList) && (maxDicWordsInTxt> 0)) {
        if ((intReadTextType == intReadTextType_Book) && (maxDicWordsInTxt> 0)) {
            float score = ((float)cntKnow/maxDicWordsInTxt) * 100;
            
            strDifficult = [self getBookDifficulty1:[NSNumber numberWithFloat: score]];
            
            NSInteger cntOfUnKnownWords = maxDicWordsInTxt - cntKnow - cntWordNotInTbl;
            float precentageOfKnownWords = ((float)cntKnow/maxDicWordsInTxt) * 100;
            float precentageOfUnKnownWords = ((float)cntOfUnKnownWords/maxDicWordsInTxt) * 100;
            //        float precentageOfWordNotInTbl = ((float)cntWordNotInTbl/maxDicWordsInTxt) * 100;
            
            //TODO) locale는 사용자에게 맞게 맞추어 주어야한다.
            NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
            NSDecimalNumber *someAmount = nil;
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [currencyFormatter setLocale:locale];
            
            DLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
            
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", [arrAllWordsInBook count]]];
            NSString *strCntOfAllWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", maxDicWordsInTxt]];
            NSString *strCntOfUniqueWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntKnow]];
            NSString *strCntOfKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUnKnownWords]];
            NSString *strCntOfUnKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntWordNotInTbl]];
            NSString *strCntOfWordsNotInBook = [currencyFormatter stringFromNumber:someAmount];
            
            
            strMsg = [NSString stringWithFormat:@"( %@ : %@ )\n%@ : %@\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@", NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"All Words", @""),strCntOfAllWords, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
            
#ifdef DEBUG
            strMsg = [NSString stringWithFormat:@"%@ : %@\n( %@ : %@ )\n%@ : %@\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@",NSLocalizedString(@"time", @""), strElapsedTime, NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"All Words", @""),strCntOfAllWords, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
#endif
            
            NSString	*strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d, %@ = %d WHERE %@ = %d",TBL_BOOK_LIST, FldName_BOOK_LIST_BookLength, [strAllContentsInFile length], FldName_BOOK_LIST_WORD_COUNT_ALL,  [arrAllWordsInBook count], FldName_BOOK_LIST_WORD_COUNT_UNIQUE, maxDicWordsInTxt, FldName_BOOK_LIST_WORD_COUNT_UNKNOWN, cntOfUnKnownWords, FldName_BOOK_LIST_WORD_COUNT_NOTSURE, cntKnowAlmost, FldName_BOOK_LIST_WORD_COUNT_KNOWN, cntKnow, FldName_BOOK_LIST_WORD_COUNT_EXCLUDE, cntWordNotInTbl,   FldName_BOOK_LIST_ID, intBookTblNo];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
        NSString *strTitle = NSLocalizedString(@"Finish analyzing", @"");
        if (intReadTextType == intReadTextType_Book) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", strTitle]	message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//            [alert show];

        }
        DLog(@"4");
        //	self.self.navigationItem.title = strTitle;
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;
        
        arrAllWordsInBook = nil;
        
        if (intReadTextType != intReadTextType_Book) {
            if (PickerViewType == intPickerViewTypeInBook_NextPages) {
                [self performSelectorOnMainThread:@selector(openDicListForBookTemp:) withObject:strContentForDicList	waitUntilDone:YES];
            } else if (PickerViewType == intPickerViewTypeInBook_ExamPages) {
                [self performSelectorOnMainThread:@selector(openExam:) withObject:strContentForDicList	waitUntilDone:YES];
            } else if (PickerViewType == intPickerViewTypeInBook_TTSPages) {
                [self performSelectorOnMainThread:@selector(openTTS:) withObject:strContentForDicList	waitUntilDone:YES];
            }
        }
        
        if ([(NSString*)obj isEqualToString:@"smartWordList"] == TRUE) {
            if (intReadTextType != intReadTextType_Book) {
                [self performSelectorOnMainThread:@selector(openDicListForBookTemp:) withObject:strContentForDicList	waitUntilDone:YES];
            }
        }
        
	}
    
}

- (void) UpdateAnalyze:(NSObject*)obj
{
    @autoreleasepool {	
        NSMutableArray  *AllWords = [[NSMutableArray alloc] init];
        
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Preparing to analyze", @"")] waitUntilDone:YES];
        
        [self performSelectorOnMainThread:@selector(addCancelButton:) withObject:nil waitUntilDone:YES];

        
        [myCommon getAllWordsArrayFromBookTable:@"" arrOne:AllWords useKnowButton:FALSE sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:0 whereClauseFld:@"" orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];	
        
        NSInteger i = 0;

        NSInteger cntUnknown = 0;
        NSInteger cntKnowAlmost = 0;
        NSInteger cntKnow = 0;

        NSInteger cntWordNotInTbl = 0;
        
        [myCommon closeDB:true];
        [myCommon openDB:true];
        [myCommon transactionBegin:true];	
        
        if (intViewType == viewTypeBook) {
            [myCommon closeDB:false];
            [myCommon openDB:false];    
            [myCommon transactionBegin:FALSE];
        }
        for (NSMutableDictionary *dicOne in AllWords)
        {
            //        DLog(@"strOne : %@", strOne);
            if (blnCancelReadTxt == TRUE) {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Cancelled updating the book.", @"")];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            float fVal = (float)i++ / [AllWords count];
            NSString *strMsg = [NSString stringWithFormat:@"%@... %@", NSLocalizedString(@"Updating unknown words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];


            DLog(@"dicOne : %@", dicOne);
            NSString *strOne = [dicOne objectForKey:@"Word"];
            DLog(@"strOne : %@", strOne);
            
            NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOne];

            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strOneForSQL];
            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];                                               
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
            
            NSDictionary *dicOne = [dicAllOne objectForKey:[strOne lowercaseString]];

            NSString *strKnow = [dicOne objectForKey:@"Know"];
            NSString *strMeanging = [dicOne objectForKey:@"Meanging"];
            if (strMeanging == NULL) {
                strMeanging = @"";
            }
            NSString *strMeangingForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strMeanging];
            
            //사전에 없는 단어일때는
            if (dicOne == NULL) {
                cntWordNotInTbl++;
                strKnow = @"-1";
            }
            NSInteger intKnow = [strKnow integerValue];
            
            

            //책의 engDic에 해당단어가 나타난 횟수를 업데이트 한다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = '%@' WHERE %@= '%@';", TBL_EngDic, FldName_Know, intKnow, FldName_Meaning,  strMeangingForSQL, FldName_Word, strOneForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];  

            if (intKnow >= 3) {
                cntKnow++;
            } else if (intKnow == 2) {
                cntKnowAlmost++;
            } else if ( (intKnow == 1) || (intKnow == 0) ) {
                cntUnknown = 0;
            }
        }
        [myCommon transactionCommit:true];
        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        if (intViewType == viewTypeBook) {
            [myCommon transactionCommit:false];
            [myCommon closeDB:false];
            [myCommon openDB:false];    
        }
        NSString *strFileName = [strBookFullFileName lastPathComponent];
        //	maxDicWordsInTxt -= cntWordNotInTbl;
        
        //BookSetting에 단어관련정보를 넣는다.        
        NSString *strFileNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strFileName];
        NSString	*strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %d, %@ = %d WHERE %@ = '%@'",TBL_BOOK_LIST, FldName_BOOK_LIST_WORD_COUNT_UNKNOWN, cntUnknown, FldName_BOOK_LIST_WORD_COUNT_NOTSURE, cntKnowAlmost, FldName_BOOK_LIST_WORD_COUNT_KNOWN, cntKnow, FldName_BOOK_LIST_WORD_COUNT_EXCLUDE, cntWordNotInTbl, FldName_BOOK_LIST_FILENAME, strFileNameForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
            

        
        NSString *strDifficult = @"";
        NSString *strMsg = @"";
        
        if ([AllWords count]> 0) {    
            float score = ((float)cntKnow/[AllWords count]) * 100;
            
            strDifficult = [self getBookDifficulty1:[NSNumber numberWithFloat: score]];
            
            NSInteger cntOfUnKnownWords = [AllWords count] - cntKnow - cntWordNotInTbl;
            float precentageOfKnownWords = ((float)cntKnow/[AllWords count]) * 100;
            float precentageOfUnKnownWords = ((float)cntOfUnKnownWords/[AllWords count]) * 100;
            //        float precentageOfWordNotInTbl = ((float)cntWordNotInTbl/maxDicWordsInTxt) * 100;
            
            //TODO) locale는 사용자에게 맞게 맞추어 주어야한다.
            NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
            NSDecimalNumber *someAmount = nil;
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [currencyFormatter setLocale:locale];
            
            DLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
            
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", [AllWords count]]];
            NSString *strCntOfUniqueWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntKnow]];
            NSString *strCntOfKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUnKnownWords]];
            NSString *strCntOfUnKnownWords = [currencyFormatter stringFromNumber:someAmount];	
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntWordNotInTbl]];
            NSString *strCntOfWordsNotInBook = [currencyFormatter stringFromNumber:someAmount];	
            
            strMsg = [NSString stringWithFormat:@"( %@ : %@ )\n\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@", NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
        }
        NSString *strTitle = NSLocalizedString(@"Finish analyzing", @"");
            
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", strTitle]	message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//        [alert show];
        

        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];         
    }
}

- (void) previewReviewWords:(NSObject*)obj
{
    @autoreleasepool {	
        NSMutableArray  *AllWords = [[NSMutableArray alloc] init];
        
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Preparing to analyze", @"")] waitUntilDone:YES];
        
        [self performSelectorOnMainThread:@selector(addCancelButton:) withObject:nil waitUntilDone:YES];
        
        
        [myCommon getAllWordsArrayFromBookTable:@"" arrOne:AllWords useKnowButton:FALSE sqlType:getAllWordsSQLTypeNormal sortType:intSortType_Alphabet pageNumber:0 whereClauseFld:@"" orderByFld:@"Word" isAsc:TRUE openMyDic:OPEN_DIC_DB_BOOK];	
        
        NSInteger i = 0;
        NSInteger cntKnow = 0;
        NSInteger cntKnowAlmost = 0;
        NSInteger cntWordNotInTbl = 0;
        
        [myCommon closeDB:true];
        [myCommon openDB:true];
        [myCommon transactionBegin:true];	
        
        if (intViewType == viewTypeBook) {
            [myCommon closeDB:false];
            [myCommon openDB:false];    
            [myCommon transactionBegin:FALSE];
        }
        for (NSMutableDictionary *dicOne in AllWords)
        {
            //        DLog(@"strOne : %@", strOne);
            if (blnCancelReadTxt == TRUE) {
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Cancelled updating the book.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert2 show];
                [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                actionSheetProgress = nil;
                progressViewInActionSheet = nil;
                return;
            }
            float fVal = (float)i++ / [AllWords count];
            NSString *strMsg = [NSString stringWithFormat:@"%@... %@", NSLocalizedString(@"Updating unknown words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            
            
            DLog(@"dicOne : %@", dicOne);
            NSString *strOne = [dicOne objectForKey:@"Word"];
            DLog(@"strOne : %@", strOne);
            
            NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOne];
            
            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strOneForSQL];
            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];                                               
            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
            
            NSDictionary *dicOne = [dicAllOne objectForKey:[strOne lowercaseString]];
            
            NSString *strKnow = [dicOne objectForKey:@"Know"];
            NSString *strMeanging = [dicOne objectForKey:@"Meanging"];
            
            //사전에 없는 단어일때는
            if (dicOne == NULL) {
                cntWordNotInTbl++;
                strKnow = @"-1";
            }
            NSInteger intKnow = [strKnow integerValue];
            
            
            
            //책의 engDic에 해당단어가 나타난 횟수를 업데이트 한다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %@ WHERE %@=%@;", TBL_EngDic, FldName_Know, intKnow, FldName_Meaning,  strMeanging, FldName_Word, strOneForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];  
            
            if (intKnow >= 3) {
                cntKnow++;
            } else if (intKnow == 2) {
                cntKnowAlmost++;
            }
        }
        [myCommon transactionCommit:true];
        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        if (intViewType == viewTypeBook) {
            [myCommon transactionCommit:false];
            [myCommon closeDB:false];
            [myCommon openDB:false];    
        }
        NSString *strFileName = [strBookFullFileName lastPathComponent];
        //	maxDicWordsInTxt -= cntWordNotInTbl;
        NSString *strFileNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strFileName];
        //BookSetting에 단어관련정보를 넣는다.
        NSString	*strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %d WHERE %@ = '%@'",TBL_BOOK_LIST,  FldName_BOOK_LIST_WORD_COUNT_NOTSURE, cntKnowAlmost, FldName_BOOK_LIST_WORD_COUNT_KNOWN, cntKnow, FldName_BOOK_LIST_WORD_COUNT_UNIQUE, [AllWords count], FldName_BOOK_LIST_FILENAME, strFileNameForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        
        
        
        NSString *strDifficult = @"";
        NSString *strMsg = @"";
        
        if ([AllWords count]> 0) {    
            float score = ((float)cntKnow/[AllWords count]) * 100;
            
            strDifficult = [self getBookDifficulty1:[NSNumber numberWithFloat: score]];
            
            NSInteger cntOfUnKnownWords = [AllWords count] - cntKnow - cntWordNotInTbl;
            float precentageOfKnownWords = ((float)cntKnow/[AllWords count]) * 100;
            float precentageOfUnKnownWords = ((float)cntOfUnKnownWords/[AllWords count]) * 100;
            //        float precentageOfWordNotInTbl = ((float)cntWordNotInTbl/maxDicWordsInTxt) * 100;
            
            //TODO) locale는 사용자에게 맞게 맞추어 주어야한다.
            NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
            NSDecimalNumber *someAmount = nil;
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [currencyFormatter setLocale:locale];
            
            DLog(@"%@", [currencyFormatter stringFromNumber:someAmount]);
            
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", [AllWords count]]];
            NSString *strCntOfUniqueWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntKnow]];
            NSString *strCntOfKnownWords = [currencyFormatter stringFromNumber:someAmount];
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntOfUnKnownWords]];
            NSString *strCntOfUnKnownWords = [currencyFormatter stringFromNumber:someAmount];	
            someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", cntWordNotInTbl]];
            NSString *strCntOfWordsNotInBook = [currencyFormatter stringFromNumber:someAmount];	
            
            strMsg = [NSString stringWithFormat:@"( %@ : %@ )\n\n%@ : %@\n%@ : %@ (%.0f%%)\n%@ : %@ (%.0f%%)\n%@ : %@", NSLocalizedString(@"Difficulty", @""), strDifficult, NSLocalizedString(@"Uinque Words", @""),strCntOfUniqueWords, NSLocalizedString(@"Known Words", @""),strCntOfKnownWords, precentageOfKnownWords, NSLocalizedString(@"Unknown Words", @""),strCntOfUnKnownWords, precentageOfUnKnownWords, NSLocalizedString(@"Not in the Dictionary", @""),strCntOfWordsNotInBook];
        }
        NSString *strTitle = NSLocalizedString(@"Finish analyzing", @"");
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", strTitle]	message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        
        
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void) addCancelButton:(NSNumber*) param  {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(110, 55, 90, 37);
    btnCancel.center = CGPointMake(self.view.center.x, btnCancel.center.y);
    [btnCancel setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Cancel", @"")]  forState:UIControlStateNormal];

    //            btnCancel.backgroundColor = [UIColor blueColor];            
    [btnCancel addTarget:self action:@selector(dismissBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetProgress addSubview:btnCancel];
//    [btnCancel release];
}

- (void) dismissBtnCancel
{
    blnCancelReadTxt = TRUE;
}

- (BOOL) isNumber:(NSString*)strInput
{
	@try
	{
		NSInteger intInput = [strInput intValue];
		if (intInput == 0) {
			return	FALSE;
		}
	}
	@catch (NSException *exception)
	{
		return FALSE;
	}
	return TRUE;
}

- (void) becomeActive:(NSNotification *) notif 
{
}

#pragma mark -
#pragma mark UIWebViewDelegate methods   
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (blnCountingPages == FALSE) {

    }
    [SVProgressHUD dismiss];
    if (webViewWeb == webView) {
        [webIndicator startAnimating];
    }
    
    //가끔 화면에서 글자가 안보이는 버그때문에 설정한다... 화면에 안보일때 폰트를 바꾸어주니까 보여서 이걸 한다... TODO) 이유는 나중에 파악...
    if (fontSize < Font_Size_MIN) {
        DLog(@"fontSize : %d", fontSize);
        fontSize = Font_Size_NORMAL;
        DLog(@"fontSize : %d", fontSize);
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        [defs setInteger:fontSize forKey:KEY_DIC_FontSize];
        
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",
                          fontSize];
        [[arrWebView objectAtIndex:prevWebView] stringByEvaluatingJavaScriptFromString:jsString];
    }
}
    
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    if (webView == webViewWeb) {
        
        [webIndicator startAnimating];
    }

	if (intViewType == viewTypeBook) {

        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"java" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        [webView stringByEvaluatingJavaScriptFromString:jsCode];
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
        [webView stringByEvaluatingJavaScriptFromString:jsString];
        
        float lastScroll = [[webView stringByEvaluatingJavaScriptFromString:@"scrollY"] floatValue];
        
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0, %f);",lastScroll]];

        [self.view bringSubviewToFront:[arrWebView objectAtIndex:currWebView]];
        
        if (blnPressAdjust == TRUE) {
            [self.view	bringSubviewToFront:tabBarFont];
            [self.view	bringSubviewToFront:viewBackLight];
            [self.view	bringSubviewToFront:viewPageNo];
        }
        
        if (viewWordSearchBackAndForward.hidden == FALSE) {
            [self.view bringSubviewToFront:viewWordSearchBackAndForward];
        }
        currPageNo = currPageNoToGo;
        
        
        lblPageNoPercent.text = [NSString stringWithFormat:@"%d/%d", currPageNo+1, (NSInteger) slidePageNo.maximumValue];
        
        if (blnWordSearchMode == TRUE) {
            NSMutableArray *arrOne = [dicWordSearchFamilyDetail objectForKey:strWordSearch];
            NSMutableDictionary *dicOne = [arrOne objectAtIndex:intSelTblRow];
//            DLog(@"dicOne : %@", dicOne);
            NSInteger currPageNoTemp = [[dicOne objectForKey:@"PageNo"] integerValue];
            NSMutableString *strStarIndex = [NSMutableString stringWithString:@"0"];
            NSMutableString *strEndIndex = [NSMutableString stringWithString:@"0"];
            [myCommon getIndexWithPageNo:currPageNoTemp StartIndex:strStarIndex EndIndex:strEndIndex];
            NSInteger startIndex = [strStarIndex integerValue];
            NSInteger endIndex = [strEndIndex   integerValue];
            NSInteger startIndexOfWord = [[dicOne objectForKey:@"WordStartIndex"] integerValue];
           
            NSString *documentEleHeight = 	[[arrWebView objectAtIndex:currWebView] stringByEvaluatingJavaScriptFromString:@"document.documentElement.clientHeight"];
            NSString *documentBodyHeight = 	[[arrWebView objectAtIndex:currWebView] stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"];
            
            NSInteger endMinusFromStart = endIndex - startIndex;
            float fPercentOfPositionWordInPage = 0.0f;
            
            if (endMinusFromStart > 0) {
                
                fPercentOfPositionWordInPage = ((startIndexOfWord - startIndex) / (float)endMinusFromStart) * ([documentEleHeight floatValue]) - [documentBodyHeight floatValue];
                if (fPercentOfPositionWordInPage <= -100.0f) {
                    fPercentOfPositionWordInPage = 0.0f;
                } else if (fPercentOfPositionWordInPage <= 0.0f) {
                    fPercentOfPositionWordInPage = 50.0f;
                } else {
                    fPercentOfPositionWordInPage += 80.0f;
                }
//                DLog(@"fPercentOfPositionWordInPage : %f", fPercentOfPositionWordInPage);
            }
            
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0, %f);",fPercentOfPositionWordInPage]];
            
            [self.view bringSubviewToFront:viewWordSearchBackAndForward];
        }
	}
    
    if (webView == webViewWeb) {

    }
    if ((blnOnQAMode == TRUE) && ([arrWrongAnswers count] > 0)){
        [self.view bringSubviewToFront:viewQA];
    }
    [SVProgressHUD dismiss];
}

-(BOOL) webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (intViewType == viewTypeBook) {		
		[[arrWebView objectAtIndex:currWebView] setUserInteractionEnabled:TRUE];
	} else if (intViewType == viewTypeWeb) {		
		webViewWeb.userInteractionEnabled = TRUE;
	}
	
	if (blnLinkOff == TRUE) {
		return NO;
	}
	if (intViewType == viewTypeWeb) {
		if (navigationType == UIWebViewNavigationTypeLinkClicked) {
			NSURL *URL = [request URL];
			if ([[URL scheme] isEqualToString:@"http"]) {
				DLog(@"URL scheme : %@", [URL scheme]);
				searchBarWebUrl.text = [URL absoluteString];
				[self._strMutableURL setString:searchBarWebUrl.text];
				DLog(@"URL absoluteString : %@", [URL absoluteString]);
				
				NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
				[defs setValue:searchBarWebUrl.text forKey:@"LastWebURL"];
				DLog(@"searchBarWebUrl.text : %@", searchBarWebUrl.text);
				
	
                
				[self gotoAddress:nil];
			}
			return NO;
		}
		return YES;
	}
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	if ([error code] != -999) {
		if (error != NULL) {
			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle: [error localizedDescription]
									   message: [error localizedFailureReason]
									   delegate:nil
									   cancelButtonTitle:NSLocalizedString(@"OK", @"")
									   otherButtonTitles:nil];
			[errorAlert show];
		}
	}
    [SVProgressHUD dismiss];
}
-(void) gotoAddress:(id)sender
{
	[SVProgressHUD showProgress:-1 status:@""];
	NSString *urlAddress = searchBarWebUrl.text;
	
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	[defs setValue:urlAddress forKey:@"LastWebURL"];	
	
	NSURL *url = [NSURL URLWithString:urlAddress];	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];	
	webViewWeb.scalesPageToFit = YES;
	[webViewWeb loadRequest:request];
}
- (void) goBack
{
	if ([webViewWeb canGoBack]){
        [webViewWeb goBack];
    } else {
    
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"This is first page", @"")];
    }
}

- (void) goForward
{
    //Forward Mode...
    if ([webViewWeb canGoForward]) {
        [webViewWeb	goForward];

    } else {
        
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"This is last page", @"")];
    }
}
- (void) reload
{
    [SVProgressHUD showProgress:-1 status:@""];
	[webViewWeb	reload];

}

- (void) stopWebLoading {
    [webViewWeb stopLoading];
    [SVProgressHUD dismiss];
}

- (void) selWordInWebView
{
//	DLog(@"selword");
    [self._strMutableCopyWord setString:@""];
    
    
    [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    NSString *strTemp = board.string;
     DLog(@"strTemp : %@", strTemp);
    //board.string(strTemp)이 NULL일때는 strTemp를 다시 board.string로 넣을때는 죽기 때문에 @""으로 바꾸어 준다.
    if (strTemp == NULL) {
        strTemp = @"";
    }
	if (intViewType == viewTypeBook) {
        [[arrWebView objectAtIndex:currWebView] copy:nil];
	} else {
		[self.webViewWeb copy:nil];	
	}
    
    //미해결질문) copy하기전에 선택된것의 length를 알수 있나? 그리고 선택된후에 프로그램으로 선택을 취소하는것은?
    DLog(@"board.string length : %d", [board.string length]);
    DLog(@"board.string : %@", board.string);    
	NSString *strCopyTemp = @"";
	if (board.string != NULL) {
		strCopyTemp = board.string;
	}
    
	[self._strMutableCopyWord setString:[strCopyTemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    board.string = strTemp;
    DLog(@"strTemp : %@", strTemp);
	DLog(@"strTemp length : %d", [strTemp length]);
    	
	//선택된것이 없으면 나간다...
	if ((_strMutableCopyWord == NULL) || ([_strMutableCopyWord isEqualToString:@""] == TRUE)) {
		self.navigationItem.title = @"";
		self.txtMeaning.text = @"";
		self.lblKnow.text = @"";
		self.lblCount.text = @"";
		return;
	}
    DLog(@"_strMutableCopyWord : %@", _strMutableCopyWord);
	[self showMeaningSelTxt:FALSE];
}

 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

     return YES;
 }

-(BOOL) shouldAutorotate
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [myCommon closeDB:true];
    [myCommon openDB:true];
    if (intViewType == viewTypeBook) {
        [myCommon closeDB:FALSE];
        [myCommon openDB:FALSE];
    }   
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if (intViewType == viewTypeBook) {
        [myCommon closeDB:FALSE];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{	
	//[[NSUserDefaults standardUserDefaults] setInteger:scrollY forKey:@"currentScroll"];
	[self saveBookSetting];
    lastScrollY = [[[arrWebView objectAtIndex:currWebView] stringByEvaluatingJavaScriptFromString:@"scrollY"] floatValue];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerDidHideMenuNotification
                                                  object:nil];
    
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    [SVProgressHUD dismiss];
}

// Application is terminating.
- (void)applicationWillTerminate:(UIApplication *)application {
	
	//[[NSUserDefaults standardUserDefaults] setInteger:[[webView stringByEvaluatingJavaScriptFromString:@"scrollY"]intValue] forKey:@"currentScroll"];
}

// Application is loading.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
}


- (NSString*)getRootFilePath{
	
	//check whether root file path exists
	NSString *strFilePath=[NSString stringWithFormat:@"%@/%@/META-INF/container.xml",[myCommon getCachePath], self.ePubDirName];
    DLog(@"strFilePath : %@", strFilePath);
	if ([fm fileExistsAtPath:strFilePath]) {
		
		//valid ePub
		DLog(@"Parse now");

		
		return strFilePath;
	}
	else {
		
		//Invalid ePub file
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"Root File not Valid"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		alert=nil;
		
	}

	return @"";
}

#pragma mark XMLHandler Delegate Methods

- (void)foundRootPath:(NSString*)rootPath{
	
	//Found the path of *.opf file
	
	//get the full path of opf file
	NSString *strOpfFilePath=[NSString stringWithFormat:@"%@/%@/%@",[myCommon getCachePath], self.ePubDirName,rootPath];
	DLog(@"strOpfFilePath : %@", strOpfFilePath);
	DLog(@"[strOpfFilePath stringByDeletingLastPathComponent] : %@", [strOpfFilePath stringByDeletingLastPathComponent]);    
	self._rootPath=[strOpfFilePath stringByReplacingOccurrencesOfString:[strOpfFilePath lastPathComponent] withString:@""];
	DLog(@"_rootPath : %@", _rootPath);	
	if ([fm fileExistsAtPath:strOpfFilePath]) {
		
		//Now start parse this file
        DLog(@"strOpfFilePath : %@", strOpfFilePath);
        DLog(@"[strOpfFilePath stringByDeletingLastPathComponent] : %@", [strOpfFilePath stringByDeletingLastPathComponent]);    
		[_xmlHandler parseXMLFileAt:strOpfFilePath];
	}
	else {
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"OPF File not found"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		alert=nil;
	}
}

- (void)finishedParsing:(EpubContent*)ePubContents{
    
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[ePubContents._manifest valueForKey:[ePubContents._spine objectAtIndex:0]]];
    DLog(@"_pagesPath : %@", _pagesPath);
	self._ePubContent=ePubContents;
	_pageNumber=0;
}

- (void)loadPage{
	
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:_pageNumber]]];
}

@end