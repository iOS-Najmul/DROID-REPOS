//
//  ViewController.m
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 5. 13..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "ViewController.h"
#import "BookViewController.h"
#import "SelectorViewController.h"
#import "myCommon.h"
#import "DicListController.h"
#import "ShowAndSetLevel.h"
#import "FlashCardController.h"
#import "TwitterViewController.h"
#import "IdiomAndThemeViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "FacebookViewController.h"
#import "UIButton+Glossy.h"
#import "SVProgressHUD.h"
#import "Flurry.h"
#import "AppDelegate.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize progUpdate, lblUpdateMsg;

@synthesize btnIdiomAndTheme, btnOpenMovie, btnTwitter, btnFacebook, btnOpenLevel, btnOpenBook, btnOpenWeb, btnOpenDic, btnSendMail, btnExportWordList;
@synthesize alertViewProgress;
@synthesize imageView;
@synthesize dataiTunesRSS;

- (void)loadWebview {
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        // load your portrait view
        NSLog(@"Rportrait");
    }
    else {
        // load your landscape view
        NSLog(@"Rlandscape");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //iPhone5이상에서는 버튼의 배치를 좀 아래로 둔다.
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        DLog(@"appHeight : %d", appHeight);
        DLog(@"heightiPhone5 : %d", heightiPhone5);
        if (appHeight == heightiPhone5) {
            if ([myCommon getIOSVersion] >= IOSVersion_6_0) {
                
#ifdef ENGLISH
                imageView.image = [UIImage imageNamed:Main_Background_English_iPhone5];
#else
                imageView.image = [UIImage imageNamed:Main_Background_Chinese_iPhone5];
#endif
            }
        }
    }
    
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef DEBUG
//    DLog(@"DEBUG");
    
#else
//    DLog(@"Not DEBUG");
    btnOpenMovie.hidden = TRUE; 
//    btnSendMail.hidden = TRUE;
    btnTwitter.hidden = TRUE;
#endif 
    
    
#ifdef ENGLISH
    DLog(@"English Mode");
    #ifdef LITE
        //    DLog(@"LITE Version");
        
        //    // iAd 배너
        //    if( NSClassFromString(@"ADBannerView") )
        //    {
        //        iADBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
        //        [iADBanner setRequiredContentSizeIdentifiers:
        //         [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil]];
        //
        //        [iADBanner setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        //        [iADBanner setFrame:CGRectMake(0, 0, 320, 50)];
        //        [iADBanner setDelegate:self];
        //        [self.view addSubview:iADBanner];
        //    }
    


    
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"a14fc8d0e2dbb7b";
        bannerView_.rootViewController = self;
        GADRequest *request = [GADRequest request];
        request.testing = NO;

        [self.view addSubview:bannerView_];
        [bannerView_ loadRequest:request];
    #else
        //    DLog(@"FULL Version");
    #endif
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        imageView.image = [UIImage imageNamed:Main_Background_English];
    } else {
        imageView.image = [UIImage imageNamed:Main_Background_Chinese];
    }
    
#elif CHINESE
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        imageView.image = [UIImage imageNamed:Main_Background_Chinese];
    } else {
        imageView.image = [UIImage imageNamed:Main_Background_Chinese];
    }
    #ifdef LITE
        //    DLog(@"LITE Version");
        
        //    // iAd 배너
        //    if( NSClassFromString(@"ADBannerView") )
        //    {
        //        iADBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
        //        [iADBanner setRequiredContentSizeIdentifiers:
        //         [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil]];
        //
        //        [iADBanner setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        //        [iADBanner setFrame:CGRectMake(0, 0, 320, 50)];
        //        [iADBanner setDelegate:self];
        //        [self.view addSubview:iADBanner];
        //    }
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"a15086bd04a88f2";
        bannerView_.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testing = NO;
    
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:request];
    
//        [self.view addSubview:bannerView_];
//        [bannerView_ loadRequest:[GADRequest request]];
    #else
        //    DLog(@"FULL Version");
    #endif
    [btnTwitter setTitle:@"Twitter CHINESE" forState:UIControlStateNormal];
    DLog(@"CHINESE Mode");
#endif
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
        DLog(@"IOSVersion : %f", IOSVersion_6_0);
        btnIdiomAndTheme.hidden = TRUE;
    } else {
        btnIdiomAndTheme.hidden = TRUE;
    }
#endif

	[[self navigationController] setNavigationBarHidden:YES animated:NO];
    
//    //상태바를 숨긴다.
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];		

    
    //멀티태스킹을 지원하는지 확인한다.
    UIDevice* device = [UIDevice currentDevice];    
    BOOL backgroundSupported = NO;    
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])        
        backgroundSupported = device.multitaskingSupported;    
    DLog(@"backgroundSupported : %d", backgroundSupported);
    
	NSArray *docPathTemp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
	NSString *strDocPath = [docPathTemp objectAtIndex:0];
    NSArray *cachePathTemp = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *strCachePath = [NSString stringWithFormat:@"%@", [cachePathTemp objectAtIndex:0]];
    
	[myCommon setEnv];
	[myCommon setDocPath:strDocPath];
    [myCommon setCachePath:strCachePath];
#ifdef ENGLISH
	[myCommon setDBPath:[strDocPath stringByAppendingPathComponent:fileNameWithExt_MyEnglish]];
#elif CHINESE
    [myCommon setDBPath:[strDocPath stringByAppendingPathComponent:fileNameWithExt_MyChinese]];
#endif
    
    [myCommon setDBPathInBundle];

    [self copyMyEnglishIfNeeded];
    
    [self copyStyleCSSIfNeeded];
    //#ifndef LITE
    [self copyHowToUseFileIfNeeded];
    //#endif
	[myCommon openDB:true];
    
    alertViewProgress = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"\n\n", @"") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
	UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.frame = CGRectMake(140,30, 0, 0);
    //	aiv.center = CGPointMake(alertViewProgress.bounds.size.width / 2.0f, 30.0f);
	[aiv startAnimating];
	[alertViewProgress addSubview:aiv];

    progUpdate = [[UIProgressView alloc] initWithFrame:CGRectMake(15, 60, 250, 10)];
    [progUpdate setProgressViewStyle: UIProgressViewStyleDefault];	
	[alertViewProgress addSubview:progUpdate];   
    
    lblUpdateMsg = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 250, 50)];
    lblUpdateMsg.text = @"";
    lblUpdateMsg.textAlignment = NSTextAlignmentCenter;
    lblUpdateMsg.backgroundColor = [UIColor clearColor];
    lblUpdateMsg.textColor = [UIColor whiteColor];
    lblUpdateMsg.numberOfLines  = 2;
    lblUpdateMsg.text = [NSString stringWithFormat:@"%@...\n%@...%@", NSLocalizedString(@"Wait please",@""), NSLocalizedString(@"Updating App", @""), [NSString stringWithFormat:@"%.1f%%", 0.0f]];
    
    [alertViewProgress addSubview:lblUpdateMsg];
    
    [self checkSQLiteVersionAndDoSomething];
    
    //디바이스의 화면밝기는 저장해두고 앱의 화면밝기를 가져온다.
    [myCommon setBrightness:[[UIScreen mainScreen] brightness]];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    //현재 디바이스의 백라이트의 밝기를 그대로 적용한다. (저장해둔것을 적용하니 앱을 들어올때 갑자기 밝기가 바뀌니 더 이상하더라...)
    float BackLight = [defs floatForKey:@"BackLight"];
    BackLight = [[UIScreen mainScreen] brightness];

    
//    if (BackLight < 0.1f) {
//        BackLight = [[UIScreen mainScreen] brightness];
//    } else if (BackLight >= 1.0f) {
//        BackLight = 1.0f;
//    }
    [[UIScreen mainScreen] setBrightness:BackLight];
    [defs setFloat:BackLight forKey:@"BackLight"];

    

#ifdef ENGLISH
    NSString *strOpt_SHOW_PhrasalVerb = [defs stringForKey:Defs_SHOW_PhrasalVerb];
    
    if ( (strOpt_SHOW_PhrasalVerb == NULL) || ([strOpt_SHOW_PhrasalVerb isEqualToString:@""]) ) {
        //만약 숙어에 대한 설정이 없으면
        if (appHeight == heightiPhone5) {
            //아이폰 5이상이면 숙어를 기본으로 보여준다.
            [defs setValue:@"ON" forKey:Defs_SHOW_PhrasalVerb];
        }  else {
            //아이폰 5이하이면 숙어는 기본으로 보여주지 않고 옵션에서 설정하게 해준다.
            [defs setValue:@"OFF" forKey:Defs_SHOW_PhrasalVerb];
            
        }
    }
#endif
    
//    //아래는 원래 viewWillAppear에 있었는데 처음으로 올때마다 해서 이리로 옮겼다..
//    [self makeIndexOrNot];
    
    
    //버튼을 꾸미는것
//    http://mobile.tutsplus.com/tutorials/iphone/custom-uibutton_iphone/
    [btnOpenMovie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOpenMovie setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    [btnOpenMovie setBackgroundColor:[UIColor blackColor]];
    [btnOpenMovie makeGlossy];
    
    //btnTwitter
    [btnTwitter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTwitter setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnTwitter setBackgroundColor:[UIColor blackColor]];
    [btnTwitter makeGlossy];
    
    //btnFacebook
    [btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFacebook setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnFacebook setBackgroundColor:[UIColor blackColor]];
    [btnFacebook makeGlossy];
    
    //btnOpenIdiomAndTheme
    [btnIdiomAndTheme setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnIdiomAndTheme setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnIdiomAndTheme setBackgroundColor:[UIColor blackColor]];
    [btnIdiomAndTheme makeGlossy];
}

-(void)setPressedGradient:(id)sender
{
    UIButton *btnPressed = (UIButton *)sender;
    CAGradientLayer *btnLayer = [[btnPressed.layer sublayers] objectAtIndex:0];
    btnLayer.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:225.0f / 255.0f green:225.0f / 255.0f blue:225.0f / 255.0f alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:130.0f / 255.0f green:130.0f / 255.0f blue:130.0f / 255.0f alpha:1.0f] CGColor],
                       nil];
}

-(void)setUnpressedGradient:(id)sender
{
    UIButton *btnUnpressed = (UIButton *)sender;
    CAGradientLayer *btnLayer = [[btnUnpressed.layer sublayers] objectAtIndex:0];
    btnLayer.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                       nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void) makeIndexOrNot
{
    
    NSArray *arrIndex = [[NSArray alloc] initWithObjects:
//                         [NSString stringWithFormat:@"%@", FldName_COUNT],
//                         [NSString stringWithFormat:@"%@", FldName_Word],
//                         [NSString stringWithFormat:@"%@", FldName_Know], 
//                         [NSString stringWithFormat:@"%@", FldName_Meaning],
//                         [NSString stringWithFormat:@"%@", FldName_Word], 
//                         [NSString stringWithFormat:@"%@", FldName_WORDORI],                          
//                         [NSString stringWithFormat:@"%@", FldName_WORDLEVEL1],
//                         [NSString stringWithFormat:@"%@", FldName_ToMemorize],
                         [NSString stringWithFormat:@"%@", FldName_FirstWord],
                         [NSString stringWithFormat:@"%@", FldName_WordLength],nil];
    NSMutableArray *arrIndexToCreate = [[NSMutableArray alloc] initWithCapacity:0];
    DLog(@"arrIndex : %@",arrIndex);
    
    for (NSInteger i = 0; i < [arrIndex count]; ++i) {
        NSString	*strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='index' AND %@='%@%@';", TBL_sqlite_master, FldName_TYPE, FldName_NAME, TBL_INDEX_WithoutFldName, [arrIndex objectAtIndex:i]];
        if ([myCommon chkRecExist:strQuery openMyDic:OPEN_DIC_DB] == FALSE) {
            [arrIndexToCreate addObject:[arrIndex objectAtIndex:i]];
            DLog(@"arrindex : %@", [arrIndex objectAtIndex:i]);
        };
    }
    
    if ([arrIndexToCreate count] > 0) {
        //인덱스가 없는것이 있으면 추가한다.
        DLog(@"arrIndexToCreate : %@", arrIndexToCreate);
        //        [self.view addSubview:alertViewProgress];
        [alertViewProgress show];
        [NSThread detachNewThreadSelector:@selector(createIndex:) toTarget:self withObject:arrIndexToCreate];
        //        [self createIndex:arrIndexToCreate];
        
    }
}
//SQLite의 버전을 확인해서 해당버전에 맞는작업을 한다.
- (void) checkSQLiteVersionAndDoSomething
{
    //    [self.view bringSubviewToFront:viewUpdate];
    
    
    NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@", FldName_ENV_Version, TBL_APP_INFO];
    NSString *strVer = [myCommon getStringFldValueFromTbl:strQuery openMyDic:TRUE];
    DLog(@"strVer : %@", strVer);
    
//    [self doVersionJob:StrVer_1_0];
    if ([[strVer uppercaseString] isEqualToString:StrVer_1_0]) {
        [self doVersionJob:StrVer_1_0];
    }

}

- (void) changeVersion:(NSString*)strVer
{
    NSString	*strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@'",TBL_APP_INFO, FldName_ENV_Version, strVer];
    [myCommon changeRec:strQuery openMyDic:TRUE];            
}

- (void) doVersionJob:(NSString*)strVer
{
    if ([[strVer uppercaseString] isEqualToString:StrVer_1_0]) {
#ifdef ENGLISH        
        //Ver1.1로 업데이트할때는 숙어를 추가하여 준다.
//        [self makeIndexOrNot];
//        [alertViewProgress show];
        [NSThread detachNewThreadSelector:@selector(insertPronounceAndPhrasalVerb:) toTarget:self withObject:nil];

        NSString *strMsg = NSLocalizedString(@"You can add phrasal verb and pronounce in the menu\nMyLevel -> Update Dic", @"");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strMsg  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        
#elif CHINESE
        
#endif
    } else if ([[strVer uppercaseString] isEqualToString:StrVer_1_1]) {
        //Ver1.2로 업데이트할때는 ~~~
        

    }
}

//내장된 phrasal verb를 가져와서 사용자 사전에 넣어준다.
- (void) insertPronounceAndPhrasalVerb:(NSObject*)obj
{
    
    @autoreleasepool {
        
        NSArray *arrIndex = [[NSArray alloc] initWithObjects:
                             [NSString stringWithFormat:@"%@", FldName_FirstWord],
                             [NSString stringWithFormat:@"%@", FldName_WordLength],nil];
        NSMutableArray *arrIndexToCreate = [[NSMutableArray alloc] initWithCapacity:0];
        DLog(@"arrIndex : %@",arrIndex);
        
        for (NSInteger i = 0; i < [arrIndex count]; ++i) {
            NSString	*strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='index' AND %@='%@%@';", TBL_sqlite_master, FldName_TYPE, FldName_NAME, TBL_INDEX_WithoutFldName, [arrIndex objectAtIndex:i]];
            if ([myCommon chkRecExist:strQuery openMyDic:OPEN_DIC_DB] == FALSE) {
                [arrIndexToCreate addObject:[arrIndex objectAtIndex:i]];
                DLog(@"arrindex : %@", [arrIndex objectAtIndex:i]);
            };
        }

        if ([arrIndexToCreate count] > 0) {
            //인덱스가 없는것이 있으면 추가한다.
            DLog(@"arrIndexToCreate : %@", arrIndexToCreate);
            //        [self.view addSubview:alertViewProgress];
            
            NSMutableArray *arrIndexToCreate = (NSMutableArray*)obj;
            
            NSInteger intCnt = 1;
            float	fVal = 0.0f;
            NSString *strMsg = @"";
            
            
            //index를 만들어준다.
            for (NSInteger i = 0; i < [arrIndexToCreate count]; ++i) {
                DLog(@"arrIndexToCreate : %@", [arrIndexToCreate objectAtIndex:i]);
                fVal = intCnt++ / ((float)[arrIndexToCreate count]);
                strMsg = [NSString stringWithFormat:@"%@...\n%@...%@", NSLocalizedString(@"Wait please",@""), NSLocalizedString(@"Updating App", @""), [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
                [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];
                [myCommon createIndexInMyEnglish:[arrIndexToCreate objectAtIndex:i]];
            }            
        }
        
        NSInteger intCnt = 1;
        float	fVal = 0.0f;
        NSString *strMsg = @"";

        
        //index를 만들어준다.
        for (NSInteger i = 0; i < [arrIndexToCreate count]; ++i) {
            DLog(@"arrIndexToCreate : %@", [arrIndexToCreate objectAtIndex:i]);
            fVal = intCnt++ / ((float)[arrIndexToCreate count]);
            strMsg = [NSString stringWithFormat:@"%@...\n%@...%@", NSLocalizedString(@"Wait please",@""), NSLocalizedString(@"Updating index App", @""), [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
            [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
            [myCommon createIndexInMyEnglish:[arrIndexToCreate objectAtIndex:i]];
        }
    }
    
    [self changeVersion:StrVer_1_1];
    return;
}

- (void) createIndex:(NSObject*)obj
{
	    @autoreleasepool {
    NSMutableArray *arrIndexToCreate = (NSMutableArray*)obj;

    NSInteger intCnt = 1;
    float	fVal = 0.0f;
    NSString *strMsg = @"";

    
    //index를 만들어준다.
    for (NSInteger i = 0; i < [arrIndexToCreate count]; ++i) {
        DLog(@"arrIndexToCreate : %@", [arrIndexToCreate objectAtIndex:i]);
        fVal = intCnt++ / ((float)[arrIndexToCreate count]);
        strMsg = [NSString stringWithFormat:@"%@...\n%@...%@", NSLocalizedString(@"Wait please",@""), NSLocalizedString(@"Updating App", @""), [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];
        [myCommon createIndexInMyEnglish:[arrIndexToCreate objectAtIndex:i]];
    }
    
    [alertViewProgress dismissWithClickedButtonIndex:0 animated:NO];
    //    [self.view sendSubviewToBack:viewUpdate];
        }
}


- (void) updateProgress:(NSNumber*) param  {
    progUpdate.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	lblUpdateMsg.text = [NSString stringWithFormat:@"%@",  param];
}

//==============================================
//버전1.1_업데이트] /HowToUse.txt파일이 Documents 폴더에 있으면 그대로 쓰고, 없으면 Main Bundle에서 복사한다.
- (void) copyHowToUseFileIfNeeded
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];	
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];	
    //    DLog(@"lang : %@", languages);
    NSString *strOutputLang = [NSString stringWithFormat:@"%@", [languages objectAtIndex:0]];
    DLog(@"strOutputLang : %@", strOutputLang);
    
	DLog(@"locale : %@", [NSLocale currentLocale]);
    DLog(@"locale : %@", [[NSLocale currentLocale] localeIdentifier]);
    
    NSString *strFileName = @"1HowToUse.txt";
    
    if ([strOutputLang isEqualToString:@"ko"]) {
        //한국어
        strFileName = @"1_사용방법.txt";    
    }else if ([strOutputLang isEqualToString:@"es"]) {
        //Spanish [스페인어] : Español
        strFileName = @"1_Cómo se usa esta aplicación.txt";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        //프랑스어 français
        strFileName = @"1_Comment utiliser cette Application.txt";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        //독일어 Deutsch
        strFileName = @"1_Wie Sie diese Applikation nutzen.txt";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        //Japanese [일본어] : 日本語
        strFileName = @"1_このアプリの使い方.txt";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        //Dutch [네덜란드어] : Nederlands
        strFileName = @"1_Hoe gebruik je deze App.txt";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        //이탈리아어 italiano
        strFileName = @"1_Come usare questa applicazione.txt";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        //포르투칼어 português
        strFileName = @"1_Como utilizar esta aplicação.txt";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        //포르투칼어 português (Portugal)
        strFileName = @"1_Como utilizar esta aplicação.txt";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        //Swedish [스웨덴어] : Svenska
        strFileName = @"1_Hur du använder den här appen.txt";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        //중국어(간체) 中文（简体中文）
        strFileName = @"1_如何使用这个app.txt";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        //중국어(번체) 中文（繁體中文）
        strFileName = @"1_如何使用这个app.txt";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        //Russian [러시아어] : Русский язык
        strFileName = @"1_Как пользоваться приложением.txt";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        //Arabic [아랍어] : ﺔﻴﺑﺮﻌﻟﺍ
        strFileName = @"1_Arabic.txt";
    } else {
        strFileName = @"1_HowToUse.txt";
    }
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	BOOL dbExists = [fileManager fileExistsAtPath:[[myCommon getDocPath] stringByAppendingPathComponent:strFileName]];
	if(!dbExists)
	{
        NSString *strTxtPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strFileName];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:strTxtPath toPath:[[myCommon getDocPath] stringByAppendingPathComponent:strFileName] error:&error];
        if (!success) {
            
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")	message:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Can't copy file to Document folder", @""), strFileName]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert show];
        }
    }
    
#ifdef CHINESE
    //중국어버전에서는 중국어 책을 한권 넣어주기 위해서...
    strFileName = @"1_如何使用这个app.txt";
    NSString *strTxtPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strFileName];
    [fileManager copyItemAtPath:strTxtPath toPath:[[myCommon getDocPath] stringByAppendingPathComponent:strFileName] error:nil];
#endif
}
//==============================================

//MyEnglish.sqlite파일이 Documents 폴더에 있으면 그대로 쓰고, 없으면 Main Bundle에서 복사한다. 
- (void) copyMyEnglishIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL dbExists = [fileManager fileExistsAtPath:[myCommon getDBPath]];
	if(!dbExists)
	{
		NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileNameWithExt_MyEnglish];
#ifdef CHINESE
        defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileNameWithExt_MyChinese];
#endif
        
		DLog(@"defaultDBPath : %@", defaultDBPath);
		DLog(@"[myCommon getDBPath] : %@", [myCommon getDBPath]);        
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:[myCommon getDBPath] error:&error];
		if (!success) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Name of warning")	message:NSLocalizedString(@"Can't copy MyEnglish.sqlite(Dictionary file) to Document folder.", @"Name of CannotCopyMyDic")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert show];
		} else {
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                NSString *strMyEnglishFullPath = [myCommon getDBPath];
                DLog(@"strMyDicFullPath : %@", strMyEnglishFullPath);
                NSURL *pathURL= [NSURL fileURLWithPath:strMyEnglishFullPath];                
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }                
            }            
#endif            
        }
	}
}

//기존 style.css파일이 없으면 Main Bundle에서 복사한다. 
- (void) copyStyleCSSIfNeeded
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    float   cssVersion = [defs floatForKey:KEY_CSS_VERSION];
    
    NSDictionary *dicWordNotRated = [defs dictionaryForKey:@"CSS_WORDNotRated"];
//    DLog(@"defs : %@", defs);
//    DLog(@"dicWordNotRated : %@", dicWordNotRated);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strStyleCSS = [[myCommon getDocPath] stringByAppendingPathComponent:@"style.css"];
    BOOL dbExists = [fileManager fileExistsAtPath:strStyleCSS];
    
    if ( (cssVersion < CSS_VERSION_1_0) || (dicWordNotRated == nil) || (dbExists == FALSE) ){
        [defs setFloat:CSS_VERSION_1_0 forKey:KEY_CSS_VERSION];
       
        NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init]; 
        NSMutableDictionary *dicBODY = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSure = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotRatedIdiom = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknownIdiom = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSureIdiom = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicNightBODY = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicNightWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicNightWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicNightWORDNotSure = [[NSMutableDictionary alloc] init];  
        
        NSInteger backLight = [defs integerForKey:@"BackLight"];
        NSInteger fontLight = [defs integerForKey:@"fontLight"];
        if (backLight < 30) {
            backLight = 255;
        }
        if (fontLight < 30) {
            fontLight = 255;
        }
        if (cssVersion < CSS_VERSION_1_0) {
            cssVersion = CSS_VERSION_1_0;
        }
        
        [dicBODY setValue:[NSNumber numberWithFloat:CSS_VERSION_1_0] forKey:KEY_CSS_VERSION];
        [dicBODY setValue:[NSNumber numberWithInt:12] forKey:@"FontSize"];
        [dicBODY setValue:[NSNumber numberWithInt:backLight] forKey:@"FontColor_Red"];
        [dicBODY setValue:[NSNumber numberWithInt:backLight] forKey:@"FontColor_Green"];
        [dicBODY setValue:[NSNumber numberWithInt:backLight] forKey:@"FontColor_Blue"];
        [dicBODY setValue:[NSNumber numberWithInt:255] forKey:@"FontColor_Alpha"];         
        [dicBODY setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Red"];
        [dicBODY setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Green"];
        [dicBODY setValue:[NSNumber numberWithInt:0] forKey:@"BackColor_Blue"];
        [dicBODY setValue:[NSNumber numberWithInt:255] forKey:@"BackColor_Alpha"];
        
        [dicWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicWORDNotRated setValue:@"black" forKey:@"Color"];
        [dicWORDNotRated setValue:@"ON" forKey:@"Underline"];
        [dicWORDNotRated setValue:@"OFF" forKey:@"Bold"];
        [dicWORDNotRated setValue:@"OFF" forKey:@"Italic"];
        
        [dicWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicWORDUnknown setValue:@"black" forKey:@"Color"];
        [dicWORDUnknown setValue:@"OFF" forKey:@"Underline"];
        [dicWORDUnknown setValue:@"ON" forKey:@"Bold"];
        [dicWORDUnknown setValue:@"OFF" forKey:@"Italic"];
        
        [dicWORDNotSure setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:255] forKey:@"Color_Blue"];        
        [dicWORDNotSure setValue:@"blue" forKey:@"Color"];
        [dicWORDNotSure setValue:@"OFF" forKey:@"Underline"];
        [dicWORDNotSure setValue:@"ON" forKey:@"Bold"];
        [dicWORDNotSure setValue:@"OFF" forKey:@"Italic"];

        [dicWORDNotRatedIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDNotRatedIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDNotRatedIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicWORDNotRatedIdiom setValue:@"thin" forKey:@"border-width"];
        [dicWORDNotRatedIdiom setValue:@"none" forKey:@"border-style"];
        
        [dicWORDUnknownIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDUnknownIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDUnknownIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicWORDUnknownIdiom setValue:@"thin" forKey:@"border-width"];
        [dicWORDUnknownIdiom setValue:@"none" forKey:@"border-style"];
        
        [dicWORDNotSureIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicWORDNotSureIdiom setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicWORDNotSureIdiom setValue:[NSNumber numberWithInt:255] forKey:@"Color_Blue"];
        [dicWORDNotSureIdiom setValue:@"thin" forKey:@"border-width"];
        [dicWORDNotSureIdiom setValue:@"none" forKey:@"border-style"];
        
        
        [dicNightBODY setValue:[NSNumber numberWithInt:12] forKey:@"FontSize"];
        [dicNightBODY setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Red"];
        [dicNightBODY setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Green"];
        [dicNightBODY setValue:[NSNumber numberWithInt:0] forKey:@"FontColor_Blue"];
        [dicNightBODY setValue:[NSNumber numberWithInt:255] forKey:@"FontColor_Alpha"];        
        [dicNightBODY setValue:[NSNumber numberWithInt:fontLight] forKey:@"BackColor_Red"];
        [dicNightBODY setValue:[NSNumber numberWithInt:fontLight] forKey:@"BackColor_Green"];
        [dicNightBODY setValue:[NSNumber numberWithInt:fontLight] forKey:@"BackColor_Blue"];
        [dicNightBODY setValue:[NSNumber numberWithInt:255] forKey:@"BackColor_Alpha"];
        
        [dicNightWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicNightWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicNightWORDNotRated setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicNightWORDNotRated setValue:@"white" forKey:@"Color"];
        [dicNightWORDNotRated setValue:@"ON" forKey:@"Underline"];
        [dicNightWORDNotRated setValue:@"OFF" forKey:@"Bold"];
        [dicNightWORDNotRated setValue:@"OFF" forKey:@"Italic"];
        
        [dicNightWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Red"];
        [dicNightWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Green"];
        [dicNightWORDUnknown setValue:[NSNumber numberWithInt:0] forKey:@"Color_Blue"];
        [dicNightWORDUnknown setValue:@"white" forKey:@"Color"];
        [dicNightWORDUnknown setValue:@"OFF" forKey:@"Underline"];
        [dicNightWORDUnknown setValue:@"ON" forKey:@"Bold"];
        [dicNightWORDUnknown setValue:@"OFF" forKey:@"Italic"];
        
        [dicNightWORDNotSure setValue:[NSNumber numberWithInt:162] forKey:@"Color_Red"];
        [dicNightWORDNotSure setValue:[NSNumber numberWithInt:42] forKey:@"Color_Green"];
        [dicNightWORDNotSure setValue:[NSNumber numberWithInt:42] forKey:@"Color_Blue"];        
        [dicNightWORDNotSure setValue:@"brown" forKey:@"Color"];
        [dicNightWORDNotSure setValue:@"OFF" forKey:@"Underline"];
        [dicNightWORDNotSure setValue:@"ON" forKey:@"Bold"];
        [dicNightWORDNotSure setValue:@"OFF" forKey:@"Italic"];
        
        //style.css를 만든다.
        [dicCSS setValue:dicBODY forKey:KEY_CSS_BODY];
        [dicCSS setValue:dicWORDNotRated forKey:KEY_CSS_WORDNotRated];
        [dicCSS setValue:dicWORDUnknown forKey:KEY_CSS_WORDUnknown];
        [dicCSS setValue:dicWORDNotSure forKey:KEY_CSS_WORDNotSure];
        [dicCSS setValue:dicWORDNotRatedIdiom forKey:KEY_CSS_WORDNotRatedIdiom];
        [dicCSS setValue:dicWORDUnknownIdiom forKey:KEY_CSS_WORDUnknownIdiom];
        [dicCSS setValue:dicWORDNotSureIdiom forKey:KEY_CSS_WORDNotSureIdiom];
        [myCommon CreateCSS:dicCSS option:CSS_Option_Day];
        
    }
}

#pragma mark -
#pragma mark iAD Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:@"animateBannerAppear" context:nil];
//    [iADBanner setFrame:CGRectMake(0, 366, 320, 50)];
    [iADBanner setFrame:CGRectMake(0, 0, 320, 50)];
    [UIView commitAnimations];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:@"animateBannerOff" context:nil];
    [iADBanner setFrame:CGRectMake(0, 0, 320, 50)];
//    [iADBanner setFrame:CGRectMake(0, 416, 320, 50)];
    [UIView commitAnimations];
}

-(void)didSelectedOption:(OptionsViewController *)optionsVC{

    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    if ([allViewControllers count]>1) {
    
        self.navigationController.viewControllers = [NSArray arrayWithObjects:[allViewControllers objectAtIndex:0],[allViewControllers objectAtIndex:1], nil];
    }
    switch (optionsVC.selectedOption) {
        case 0:
            [self callOpenBook:nil];
            break;
          
        case 1:
            [self callOpenWeb:nil];
            break;
            
        case 2:
            [self callOpenDicList:nil];
            break;
            
        case 3:
            [self callOpenLevel:nil];
            break;
          
        case 4:
            [self callOpenMovie:nil];
            break;
            
        case 5:
            [self onBtnSendMail:nil];
            break;
            
        case 6:
            [self callOpenFacebook:nil];
            break;
            
        case 7:
            [self callOpenTwitter:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark 다른 뷰를 여는 함수들
- (IBAction) callOpenDicList:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"SELECTED_OPTION"];
    [SVProgressHUD showProgress:-1 status:@""];
    [self performSelector:@selector(openDicList) withObject:nil afterDelay:0.1];
}

- (void) openDicList
{
   [Flurry logEvent:Flurry_MENU_FullDictionary];
	DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
    dicListController.intDicWordOrIdiom = DicWordOrIdiom_Word;
	dicListController.intDicListType = DicListType_TBL_EngDic;
	dicListController.intBookTblNo = -1;
    dicListController.strWhereClauseFldSQL = @"";
    dicListController.blnUseKnowButton = TRUE;
	[self.navigationController pushViewController:dicListController animated:YES];
    [SVProgressHUD dismiss];
}

- (IBAction) callOpenBook:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SELECTED_OPTION"];
    [SVProgressHUD showProgress:-1 status:@""];
	[self performSelector:@selector(openBook) withObject:nil afterDelay:0.1];
}

- (void) openBook
{
   [Flurry logEvent:Flurry_MENU_OpenBookList];
	SelectorViewController *selectorVC = [[SelectorViewController alloc] initWithNibName:@"SelectorViewController" bundle:nil];
    selectorVC.intMovieSelectorSourceMode = MovieSelectorSourceModeBook;
	[self.navigationController pushViewController:selectorVC animated:YES];
    [SVProgressHUD dismiss];
}

- (IBAction)callOpenWeb:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SELECTED_OPTION"];
   [Flurry logEvent: Flurry_MENU_OpenWeb];
	BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
	bookVC.intViewType = 2;
	[self.navigationController pushViewController:bookVC animated:YES];
}

- (IBAction) callOpenLevel:(id)sender;
{
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"SELECTED_OPTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[SVProgressHUD showProgress:-1 status:@""];
	[self performSelector:@selector(openLevel) withObject:nil afterDelay:0.1];
}

- (void) openLevel
{
   [Flurry logEvent:Flurry_MENU_OpenMyLevel];
	ShowAndSetLevel *showAndSetLevel = [[ShowAndSetLevel alloc] initWithNibName:@"ShowAndSetLevel" bundle:nil];
	[self.navigationController pushViewController:showAndSetLevel animated:YES];
    [SVProgressHUD dismiss];
}

- (IBAction)callOpenMovie:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"SELECTED_OPTION"];
   [Flurry logEvent:Flurry_MENU_OpenMovieList];
    SelectorViewController *selectorVC = [[SelectorViewController alloc] initWithNibName:@"SelectorViewController" bundle:nil];
    selectorVC.intMovieSelectorSourceMode = MovieSelectorSourceModeMovie;
	[self.navigationController pushViewController:selectorVC animated:YES];
}

- (IBAction) onBtnIdiomAndTheme:(id)sender
{
    IdiomAndThemeViewController *idiomAndThemeViewController = [[IdiomAndThemeViewController alloc] initWithNibName:@"IdiomAndThemeViewController" bundle:nil];
    [self.navigationController pushViewController:idiomAndThemeViewController animated:YES];    
}

- (IBAction) onBtnSendMail:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"SELECTED_OPTION"];
   [Flurry logEvent:Flurry_MENU_SendMailVolunteers];

    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller != NULL) {
        controller.mailComposeDelegate = self;
        NSArray* toRecipients = [NSArray arrayWithObjects:@"dalnimsoft@gmail.com", nil];
        [controller setToRecipients:toRecipients];      
#ifdef ENGLISH
    #ifdef LITE
            [controller setSubject:@"[MyEnglishLite] Need volunteers"];
    #else
            [controller setSubject:@"[MyEnglish] Need volunteers!!!"];
    #endif 
            
            NSMutableString *strMsg = [NSMutableString stringWithFormat:@""];
            DLog(@"strMsg : %@", strMsg);
            [strMsg setString:[NSString stringWithFormat:@"%@<br>", NSLocalizedString(@"I need 3 volunteers per languages to help me with my app to translate English menus and messages to your native language.", @"")]];
            [strMsg setString:[NSString stringWithFormat:@"%@<br>%@", strMsg, NSLocalizedString(@"If you are interested in translating menus and messages, please reply email and tell me what is your mother language. I will give you one redeem code(MyEnglish : paid app) if you are selected and finished translating.", @"")]];
            [strMsg setString:[NSString stringWithFormat:@"%@<p>%@", strMsg, NSLocalizedString(@"Thank you very much.", @"")]];
#else
    #ifdef LITE
            [controller setSubject:@"[MyChineseLite] Need volunteers"];
    #else
            [controller setSubject:@"[MyChinese] Need volunteers!!!"];
    #endif
            
            NSMutableString *strMsg = [NSMutableString stringWithFormat:@""];
            DLog(@"strMsg : %@", strMsg);
            [strMsg setString:[NSString stringWithFormat:@"%@<br>", NSLocalizedString(@"I need 3 volunteers per languages to help me with my app to translate English menus and messages to your native language.", @"")]];
            [strMsg setString:[NSString stringWithFormat:@"%@<br>%@", strMsg, NSLocalizedString(@"If you are interested in translating menus and messages, please reply email and tell me what is your mother language. I will give you one redeem code(MyChinesePro : paid app) if you are selected and finished translating.", @"")]];
            [strMsg setString:[NSString stringWithFormat:@"%@<p>%@", strMsg, NSLocalizedString(@"Thank you very much.", @"")]];
        
#endif
        DLog(@"strMsg : %@", strMsg);
        NSString *body = [NSString stringWithFormat:@"%@", strMsg];
        [controller setMessageBody:body isHTML:YES];
        [self presentModalViewController:controller animated:YES];
    }
}

-(void)showFacebook{

    NSLog(@"showFacebook");
    FacebookViewController *fbVC = [[FacebookViewController alloc] initWithNibName:@"FacebookViewController" bundle:nil];
    
//    fbVC.user = self.user;
    [self.navigationController pushViewController:fbVC animated:YES];
}

- (IBAction)callOpenFacebook:(id)sender
{
    [self showFacebook];
}

- (IBAction) callOpenTwitter:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:7 forKey:@"SELECTED_OPTION"];
//    return;
    
//    [myCommon copyIdiomTemp2];
    [SVProgressHUD showProgress:-1 status:@""];
    [self performSelector:@selector(onBtnTwitter) withObject:nil afterDelay:0.1];
}

- (void) onBtnTwitter
{
    [SVProgressHUD dismiss];
    TwitterViewController *twitterView = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
	[self.navigationController pushViewController:twitterView animated:YES];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
	switch (result) {
		case MFMailComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Mail Sent Successfully",@"")];
			break;
		case MFMailComposeResultSaved:
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Mail Saved Successfully",@"")];
			break;
		case MFMailComposeResultCancelled:
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Mail Cancelled",@"")];
			break;
		case MFMailComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error Occured on Send Mail",@"")];
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark ios 5 rotation code
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark ios6 rotation code

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
