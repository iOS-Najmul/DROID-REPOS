
//
//  MoviePlayerSettingController.m
//  MyListPro
//
//  Created by 김형달 on 10. 11. 27..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import "MoviePlayerSettingController.h"
#import "myCommon.h"
#import "SVProgressHUD.h"
#import "UnderLineLabel.h"

#define OPT_BACKGROUND_COLOR 1
#define OPT_FONTCOLOR_KNOW1 2
#define OPT_FONTCOLOR_KNOW2 3

@implementation MoviePlayerSettingController
@synthesize		arrOptBackgroundColor, arrOptFontColor, arrOptFontcolorKnow1, arrOptFontcolorKnow2, arrDicSetting, writableDBPath, strScriptFileName, tblViewMain, tblViewOption, webViewOne;
@synthesize _strOptBackgroundColor, _strOptFontColor, _strOptFontcolorKnow2, _Option;
@synthesize dicBookInfo, dicEnv, viewOptionSetting, pickerOne, arrDifficulty;
@synthesize dicFontColor, arrFontColor, _indexOfArrFontColor;
@synthesize tblViewFontSetting, arrOptFontSetting, _indexOfArrOptFontSetting, arrOptFontSettingValue;
@synthesize blnBookDayMode;

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

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;

    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    //옵션 값을 가져온다.
    //뜻을 보여주고 안보여주고는 사전sqlite의 App_Info테이블에서 가져온다.
	dicBookInfo = [[NSMutableDictionary alloc] init];
    dicEnv  = [[NSMutableDictionary alloc] init];
    [myCommon getBookInfoFormTbl:dicBookInfo fileName:[strScriptFileName lastPathComponent]];
    [myCommon getEnvFromTbl:dicEnv];
    
    
    //다른 옵션들은 defs에서 가져온다.

    NSString *strOpt_SHOW_PhrasalVerb = [defs stringForKey:Defs_SHOW_PhrasalVerb];
    if ([strOpt_SHOW_PhrasalVerb isEqualToString:@"OFF"]) {
        [dicEnv setValue:strOpt_SHOW_PhrasalVerb forKey:Defs_SHOW_PhrasalVerb];
    } else {
        [dicEnv setValue:@"ON" forKey:Defs_SHOW_PhrasalVerb];
    }

    NSString *strOpt_QUIZ_Enable = [defs stringForKey:Defs_QUIZ_ENABLE];
    if ([strOpt_QUIZ_Enable isEqualToString:@"OFF"]) {
        [dicEnv setValue:strOpt_QUIZ_Enable forKey:Defs_QUIZ_ENABLE];
    } else {
        [dicEnv setValue:@"ON" forKey:Defs_QUIZ_ENABLE];
    }

    NSString *strOpt_QUIZ_Vibration = [defs stringForKey:Defs_QUIZ_VIBRATION];    
    if ([strOpt_QUIZ_Vibration isEqualToString:@"OFF"]) {
        [dicEnv setValue:strOpt_QUIZ_Vibration forKey:Defs_QUIZ_VIBRATION];
    } else {
        [dicEnv setValue:@"ON" forKey:Defs_QUIZ_VIBRATION];
    }

    
    

    dicFontColor = [[NSMutableDictionary alloc] init];
    [dicFontColor setValue:@"red" forKey:@"Not Rated"];
    [dicFontColor setValue:@"red" forKey:@"Unknown"];
    [dicFontColor setValue:@"blue" forKey:@"Not Sure"];
//    [dicFontColor setValue:@"black" forKey:@"Known"];
//    [dicFontColor setValue:@"black" forKey:@"Exclude"];
    
    arrFontColor = [[NSMutableArray alloc] init];
    [arrFontColor addObject:@"red"];
    [arrFontColor addObject:@"red"];    
    [arrFontColor addObject:@"blue"];
    
    
    //옵션을 셋팅한다.
	arrDicSetting = [[NSMutableArray alloc] init];

    //첫번째 Study Option
    NSMutableArray *arrSetting1 = [[NSMutableArray alloc] init];
    NSArray *arrSetting1_1 = [NSArray arrayWithObjects:NSLocalizedString(@"Show Meaning", @""), [dicEnv objectForKey:@"Show Meaning"],nil];  
    NSArray *arrSetting1_2 = [NSArray arrayWithObjects:NSLocalizedString(@"Show Phrasal Verb", @""), [dicEnv objectForKey:Defs_SHOW_PhrasalVerb],nil];
    
//	NSInteger	intShowMeaning = [myCommon getIntFldValueFromTbl:[NSString stringWithFormat:@"select %@ from %@", FldName_SHOWMEANING, TBL_APP_INFO] openMyDic:TRUE	];
//    
//    [self.dicEnv setValue:[NSNumber numberWithInt:intShowMeaning] forKey:@"Show Meaning"]; //Show Meaning은 여기서 가져올려고 한다...
    [arrSetting1 addObject:arrSetting1_1];
    [arrSetting1 addObject:@"dalnimsoft@gmail.com"];
#ifdef ENGLISH
    //영어버전에서만 숙어보기를 넣어준다.
    [arrSetting1 addObject:arrSetting1_2];
#endif
    [arrDicSetting addObject:arrSetting1];
    
    //두번째 Font Setting
    NSMutableArray *arrSetting2 = [[NSMutableArray alloc] init];
    [arrSetting2 addObject:NSLocalizedString(@"Not Rated", @"")];
    [arrSetting2 addObject:NSLocalizedString(@"X : Unknown", @"")];
    [arrSetting2 addObject:NSLocalizedString(@"? : Not Sure", @"")];
//    [arrSetting2 addObject:@"Known"];    
//    [arrSetting2 addObject:@"Exclude"];
    [arrDicSetting addObject:arrSetting2];    
    
    //세번째 Quiz Mode
    NSMutableArray *arrSetting3 = [[NSMutableArray alloc] init];
    [arrSetting3 addObject:NSLocalizedString(@"Enable", @"")];
    NSString *strPlatform = [myCommon getPlatformString];    
    if ([[strPlatform lowercaseString] hasPrefix:@"ipod"] == FALSE) {
        [arrSetting3 addObject:NSLocalizedString(@"Vibration when wrong", @"")];
    }
    [arrDicSetting addObject:arrSetting3];        
//    [arrSetting1 addObject:@"dalnimsoft@gmail.com"];
    
    DLog(@"arrDicSetting count : %d", [arrDicSetting count]);
    //난이도 설정을 하는건데 나중에 하자
//    NSMutableArray *arrSetting2 = [[NSMutableArray alloc] init];
//    DLog(@"value : %d" , [[dicEnv objectForKey:@"Difficulty_VeryEasy"] intValue]);
//    NSArray *arrSetting2_1 = [NSArray arrayWithObjects:@"Difficulty_VeryEasy", [dicEnv objectForKey:@"Difficulty_VeryEasy"],nil];
//    [arrSetting2 addObject:arrSetting2_1];
//    NSArray *arrSetting2_2 = [NSArray arrayWithObjects:@"Difficulty_Easy", [dicEnv objectForKey:@"Difficulty_Easy"],nil];
//    [arrSetting2 addObject:arrSetting2_2];
//    NSArray *arrSetting2_3 = [NSArray arrayWithObjects:@"Difficulty_Good", [dicEnv objectForKey:@"Difficulty_Good"],nil];
//    [arrSetting2 addObject:arrSetting2_3];
//    NSArray *arrSetting2_4 = [NSArray arrayWithObjects:@"Difficulty_Hard", [dicEnv objectForKey:@"Difficulty_Hard"],nil];
//    [arrSetting2 addObject:arrSetting2_4];
//    NSArray *arrSetting2_5 = [NSArray arrayWithObjects:@"Difficulty_VeryHard", [dicEnv objectForKey:@"Difficulty_Hard"],nil];
//    [arrSetting2 addObject:arrSetting2_5];
//    [arrDicSetting addObject:arrSetting2];
//    [arrSetting2 release];

    DLog(@"arrdicsetting : %@", arrDicSetting);
    
    arrDifficulty = [[NSMutableArray alloc] init];
    for(int i = 95; i > 10; i = i - 5)
    {
        [arrDifficulty addObject:[NSNumber numberWithInt:i]];
    }
//    DLog(@"arrDifficulty : %@", arrDifficulty);

    
    arrOptFontSetting = [[NSMutableArray alloc] init];
    [self.arrOptFontSetting addObject:NSLocalizedString(@"Font Color", @"")];
    [self.arrOptFontSetting addObject:NSLocalizedString(@"Underline", @"")];
    [self.arrOptFontSetting addObject:NSLocalizedString(@"Bold", @"")];
    [self.arrOptFontSetting addObject:NSLocalizedString(@"Italic", @"")];
   
    //저장되어있는 CSS의 값을 가져온다.
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic0 = nil;    
    NSDictionary *dic1 = nil;
    NSDictionary *dic2 = nil;
    NSDictionary *dic3 = nil;
    NSDictionary *dic4 = nil;
    NSDictionary *dic5 = nil;
    NSDictionary *dic6 = nil;
    if (blnBookDayMode == TRUE) {
        dic0 = [defs dictionaryForKey:KEY_CSS_BODY];
        dic1 = [defs dictionaryForKey:KEY_CSS_WORDNotRated];
        dic2 = [defs dictionaryForKey:KEY_CSS_WORDUnknown];
        dic3 = [defs dictionaryForKey:KEY_CSS_WORDNotSure];
        dic4 = [defs dictionaryForKey:KEY_CSS_WORDNotRatedIdiom];
        dic5 = [defs dictionaryForKey:KEY_CSS_WORDUnknownIdiom];
        dic6 = [defs dictionaryForKey:KEY_CSS_WORDNotSureIdiom];

        NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init]; 
        [dicCSS setValue:dic0 forKey:KEY_CSS_BODY];
        [dicCSS setValue:dic1 forKey:KEY_CSS_WORDNotRated];
        [dicCSS setValue:dic2 forKey:KEY_CSS_WORDUnknown];
        [dicCSS setValue:dic3 forKey:KEY_CSS_WORDNotSure];
        [dicCSS setValue:dic4 forKey:KEY_CSS_WORDNotRatedIdiom];
        [dicCSS setValue:dic5 forKey:KEY_CSS_WORDUnknownIdiom];
        [dicCSS setValue:dic6 forKey:KEY_CSS_WORDNotSureIdiom];
        [myCommon CreateCSS:dicCSS option:CSS_Option_Day_Imsi];
    } else {
        dic0 = [defs dictionaryForKey:@"CSS_NightBODY"];    
        dic1 = [defs dictionaryForKey:@"CSS_NightWORDNotRated"];
        dic2 = [defs dictionaryForKey:@"CSS_NightWORDUnknown"];
        dic3 = [defs dictionaryForKey:@"CSS_NightWORDNotSure"];
        
        NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init]; 
        [dicCSS setValue:dic0 forKey:@"NightBODY"];
        [dicCSS setValue:dic1 forKey:@"NightWORDNotRated"];
        [dicCSS setValue:dic2 forKey:@"NightWORDUnknown"];
        [dicCSS setValue:dic3 forKey:@"NightWORDNotSure"];        
        [myCommon CreateCSS:dicCSS option:CSS_Option_Night_Imsi];
    }
    

    arrOptFontSettingValue = [[NSMutableArray alloc] init];

    //BODY는 나중에 설정할수 있게 하자...
//    NSMutableArray *arrFontSettingValueBODY = [[NSMutableArray alloc] init];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"FontSize"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"FontColor_Red"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"FontColor_Green"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"FontColor_Blue"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"FontColor_Alpha"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"BackColor_Red"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"BackColor_Green"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"BackColor_Blue"]];
//    [arrFontSettingValueBODY addObject:[dic0 objectForKey:@"BackColor_Alpha"]];
//    [arrOptFontSettingValue addObject:arrFontSettingValueBODY];
//    [arrFontSettingValueBODY release];
    
    
    NSMutableArray *arrFontSettingValueNotRated = [[NSMutableArray alloc] init];
    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Color"]];
//    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Color_Red"]];         //옵션설정시 리스트에는 안보여줄려구...
//    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Color_Green"]];
//    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Color_Blue"]];
    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Underline"]];
    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Bold"]];
    [arrFontSettingValueNotRated addObject:[dic1 objectForKey:@"Italic"]];    
    [arrOptFontSettingValue addObject:arrFontSettingValueNotRated];
    
    NSMutableArray *arrFontSettingValueUnknown = [[NSMutableArray alloc] init];
    [arrFontSettingValueUnknown addObject:[dic2 objectForKey:@"Color"]];
//    [arrFontSettingValueUnknown addObject:[dic1 objectForKey:@"Color_Red"]];
//    [arrFontSettingValueUnknown addObject:[dic1 objectForKey:@"Color_Green"]];
//    [arrFontSettingValueUnknown addObject:[dic1 objectForKey:@"Color_Blue"]]; 
    [arrFontSettingValueUnknown addObject:[dic2 objectForKey:@"Underline"]];
    [arrFontSettingValueUnknown addObject:[dic2 objectForKey:@"Bold"]];
    [arrFontSettingValueUnknown addObject:[dic2 objectForKey:@"Italic"]];        
    [arrOptFontSettingValue addObject:arrFontSettingValueUnknown];
    
    NSMutableArray *arrFontSettingValueNotSure = [[NSMutableArray alloc] init];
    [arrFontSettingValueNotSure addObject:[dic3 objectForKey:@"Color"]];
//    [arrFontSettingValueNotSure addObject:[dic1 objectForKey:@"Color_Red"]];
//    [arrFontSettingValueNotSure addObject:[dic1 objectForKey:@"Color_Green"]];
//    [arrFontSettingValueNotSure addObject:[dic1 objectForKey:@"Color_Blue"]];     
    [arrFontSettingValueNotSure addObject:[dic3 objectForKey:@"Underline"]];
    [arrFontSettingValueNotSure addObject:[dic3 objectForKey:@"Bold"]];
    [arrFontSettingValueNotSure addObject:[dic3 objectForKey:@"Italic"]];        
    [arrOptFontSettingValue addObject:arrFontSettingValueNotSure];
    
//    NSMutableArray *arrFontSettingValueKnown = [[NSMutableArray alloc] init];
//    [arrOptFontSettingValue addObject:arrFontSettingValueKnown];
//    NSMutableArray *arrFontSettingValueExclude = [[NSMutableArray alloc] init];
//    [arrOptFontSettingValue addObject:arrFontSettingValueExclude];
    
//	[arrDicSetting addObject:@"횟수표시"];	
//	[arrDicSetting addObject:@"배경색"];
//	[arrDicSetting addObject:@""];
//	[arrDicSetting addObject:@"글자색 X"];
//	[arrDicSetting addObject:@"글자색 ?"];
//	[arrDicSetting addObject:@"글꼴"];
//	[arrDicSetting addObject:@"글자 크기"];
	
	_Option = 1;
    DLog(@"text : %@", NSLocalizedString(@"white", @""));
	self._strOptBackgroundColor = NSLocalizedString(@"white", @"");
	arrOptBackgroundColor = [[NSMutableArray alloc] init];
	[arrOptBackgroundColor addObject:NSLocalizedString(@"black", @"")];
	[arrOptBackgroundColor addObject:NSLocalizedString(@"blue", @"")];
	[arrOptBackgroundColor addObject:NSLocalizedString(@"green", @"")];
//	[arrOptBackgroundColor addObject:@"lime"];	
//	[arrOptBackgroundColor addObject:@"white"];

    self._strOptFontColor = NSLocalizedString(@"black", @"");
	arrOptFontColor = [[NSMutableArray alloc] init];
	[arrOptFontColor addObject:NSLocalizedString(@"black", @"")];
	[arrOptFontColor addObject:NSLocalizedString(@"blue", @"")];
	[arrOptFontColor addObject:NSLocalizedString(@"green", @"")];
	[arrOptFontColor addObject:NSLocalizedString(@"lime", @"")];	
	[arrOptFontColor addObject:NSLocalizedString(@"white", @"")];
    
	
	arrOptFontcolorKnow1 = [[NSMutableArray alloc] init];
    NSArray *arrFontColorBlack = [NSArray arrayWithObjects:@"black", [NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],nil];  
    NSArray *arrFontColorBlue = [NSArray arrayWithObjects:@"blue", [NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1.0f],nil];  
    NSArray *arrFontColorBrown = [NSArray arrayWithObjects:@"brown", [NSNumber numberWithFloat:0.6f],[NSNumber numberWithFloat:0.4f],[NSNumber numberWithFloat:0.2f],nil];      
    NSArray *arrFontColorGreen = [NSArray arrayWithObjects:@"green", [NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0],nil];  
    NSArray *arrFontColorRed = [NSArray arrayWithObjects:@"red", [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],nil];  
    NSArray *arrFontColorWhite = [NSArray arrayWithObjects:@"white", [NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],nil]; 
    
//    NSArray *arrFontColorClear = [NSArray arrayWithObjects:@"black", 0,0,0,nil];      
//    NSArray *arrFontColorGray = [NSArray arrayWithObjects:@"black", 0,0,0,nil];  
//    NSArray *arrFontColorCyan = [NSArray arrayWithObjects:@"black", 0,0,0,nil];  
//    NSArray *arrFontColorWhite = [NSArray arrayWithObjects:@"black", 0,0,0,nil];  
//    NSArray *arrFontColorMagenta = [NSArray arrayWithObjects:@"black", 0,0,0,nil];  
//    NSArray *arrFontColorOrange = [NSArray arrayWithObjects:@"black", 0,0,0,nil];  
//    NSArray *arrFontColorPurple = [NSArray arrayWithObjects:@"black", 0,0,0,nil];      

	[arrOptFontcolorKnow1 addObject:arrFontColorBlack];
	[arrOptFontcolorKnow1 addObject:arrFontColorBlue];
	[arrOptFontcolorKnow1 addObject:arrFontColorBrown];
	[arrOptFontcolorKnow1 addObject:arrFontColorGreen];	
	[arrOptFontcolorKnow1 addObject:arrFontColorRed];
	[arrOptFontcolorKnow1 addObject:arrFontColorWhite];    
	
	self._strOptFontcolorKnow2 = @"green";
	arrOptFontcolorKnow2 = [[NSMutableArray alloc] init];
	[arrOptFontcolorKnow2 addObject:@"black"];
	[arrOptFontcolorKnow2 addObject:@"blue"];
	[arrOptFontcolorKnow2 addObject:@"green"];
	[arrOptFontcolorKnow2 addObject:@"lime"];	
	[arrOptFontcolorKnow2 addObject:@"yellow"];
    
    [self showMeaningOnePage];			

    self.tblViewOption.hidden = YES;
//	CGRect tblViewOptionFrame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, 200);
//	self.tblViewOption.frame = tblViewOptionFrame;
	_Option = -1;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void) closeTblViewFontSetting
{
    self.tblViewOption.hidden = YES;
    
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	
    self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
    
    [tblViewMain reloadData];
    
    NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init];        
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    if (blnBookDayMode == TRUE) {
        NSDictionary *dicBODY = [defs dictionaryForKey:@"CSS_BODY"]; 
        
        NSMutableDictionary *dicWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSure = [[NSMutableDictionary alloc] init];
        //IMSI에는 IDIOM은 저장할 필요 없다.
//        NSMutableDictionary *dicWORDNotRatedIdiom = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary *dicWORDUnknownIdiom = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary *dicWORDNotSureIdiom = [[NSMutableDictionary alloc] init];
        
        NSArray *arrNotRated = [arrOptFontSettingValue objectAtIndex:0];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:0]] forKey:@"Color"];    
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:3]] forKey:@"Italic"];
        const CGFloat *component = [myCommon getColorComponents:[arrNotRated objectAtIndex:0]];
        NSInteger red = component[0] * 255;
        NSInteger green = component[1] * 255;
        NSInteger blue = component[2] * 255;
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }

        
        [dicWORDNotRated setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];    

        NSArray *arrUnknown = [arrOptFontSettingValue objectAtIndex:1];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:0]] forKey:@"Color"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrUnknown objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDUnknown setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        NSArray *arrNotSure = [arrOptFontSettingValue objectAtIndex:2];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:0]] forKey:@"Color"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrNotSure objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDNotSure setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];
        
        [dicCSS setValue:dicBODY forKey:KEY_CSS_BODY];
        [dicCSS setValue:dicWORDNotRated forKey:KEY_CSS_WORDNotRated];
        [dicCSS setValue:dicWORDUnknown forKey:KEY_CSS_WORDUnknown];
        [dicCSS setValue:dicWORDNotSure forKey:KEY_CSS_WORDNotSure];
        [myCommon CreateCSS:dicCSS option:CSS_Option_Day_Imsi];

    } else {
        NSDictionary *dicBODY = [defs dictionaryForKey:@"CSS_NightBODY"]; 
        
        NSMutableDictionary *dicWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSure = [[NSMutableDictionary alloc] init];        
        
        NSArray *arrNotRated = [arrOptFontSettingValue objectAtIndex:0];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:0]] forKey:@"Color"];    
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:3]] forKey:@"Italic"];
        const CGFloat *component = [myCommon getColorComponents:[arrNotRated objectAtIndex:0]];
        NSInteger red = component[0] * 255;
        NSInteger green = component[1] * 255;
        NSInteger blue = component[2] * 255;
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDNotRated setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];    
        
        NSArray *arrUnknown = [arrOptFontSettingValue objectAtIndex:1];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:0]] forKey:@"Color"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrUnknown objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDUnknown setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        NSArray *arrNotSure = [arrOptFontSettingValue objectAtIndex:2];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:0]] forKey:@"Color"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrNotSure objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDNotSure setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        [dicCSS setValue:dicBODY forKey:@"NightBODY"];
        [dicCSS setValue:dicWORDNotRated forKey:@"NightWORDNotRated"];
        [dicCSS setValue:dicWORDUnknown forKey:@"NightWORDUnknown"];
        [dicCSS setValue:dicWORDNotSure forKey:@"NightWORDNotSure"];        
        [myCommon CreateCSS:dicCSS option:CSS_Option_Night_Imsi];
      
    }
    
    [self showMeaningOnePage];
//    NSMutableString *strHelp = [NSMutableString stringWithString:@"You can improve your English by this app!\nReady2read? Yes, you can."];    
//	[webViewOne loadHTMLString:[self HTMLFromString:strHelp] baseURL:nil];			

    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.3f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromLeft];
//    [self.tblViewFontSetting  removeFromSuperview];
    [self.view sendSubviewToBack:tblViewFontSetting];
//    [self.view addSubview:tblView];
//    [self.view addSubview:webViewOne];
    [[tblViewMain layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    [[webViewOne layer] addAnimation:ani forKey:@"transitionViewAnimation"];
}


- (void) closeViewOptionSetting
{
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	
    self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
    

    
    [self.viewOptionSetting removeFromSuperview];
    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.3f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromLeft];
    [self.viewOptionSetting  removeFromSuperview];
    [self.view addSubview:tblViewMain];
    [self.view addSubview:webViewOne];
    [[tblViewMain layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    [[webViewOne layer] addAnimation:ani forKey:@"transitionViewAnimation"];
}

- (NSString*)HTMLFromString:(NSMutableString *)originalText backColor:(BOOL)backColor
{
	NSString *header;

    header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/styleImsi.css?time=%@\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], [myCommon getCurrentDatAndTimeForBackup]];		
	
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
	
    //미해결질문) 왜 공백을 "&nbsp; "로 치환하나? 그냥 "&nbsp;"가 아니고?
	NSString *outputHTML = [NSString stringWithFormat:@"%@%@\n</p><br/><br/>\n</body>\n</html>\n", header, originalText];
	DLog(@"outputHTML : %@", outputHTML);
 
	return outputHTML;  
}

- (void) showMeaningOnePage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    //    DLog(@"lang : %@", languages);
    NSString *strOutputLang = [NSString stringWithFormat:@"%@", [languages objectAtIndex:0]];
    DLog(@"strOutputLang : %@", strOutputLang);
    
	DLog(@"locale : %@", [NSLocale currentLocale]);
    DLog(@"locale : %@", [[NSLocale currentLocale] localeIdentifier]);
    
    //    NSString *strWord1 = @"YOU";
    NSString *translatedWord = @"YOU";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord = @"당신";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord = @"vous";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        translatedWord = @"Sie";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord = @"あなた";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        translatedWord = @"u";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        translatedWord = @"si";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        translatedWord = @"você";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        translatedWord = @"você";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        translatedWord = @"du";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        translatedWord = @"te";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        translatedWord = @"du";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord = @"你";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord = @"你";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        translatedWord = @"Вы";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        translatedWord = @"Państwo";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        translatedWord = @"Eğer";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        translatedWord = @"لك";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        translatedWord = @"ti";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        translatedWord = @"Vás";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        translatedWord = @"Σας";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        translatedWord = @"tu";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        translatedWord = @"Vás";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        translatedWord = @"คุณ";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        translatedWord = @"Ön";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        translatedWord = @"YOU";
    }
    
    //    NSString *strWord2 = @"ENGLISH";
    NSString *translatedWord1 = @"ENGLISH";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord1 = @"영어";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord1 = @"En anglais";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        translatedWord1 = @"Englisch";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord1 = @"えい-ご";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        translatedWord1 = @"Engels";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        translatedWord1 = @"Inglese";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        translatedWord1 = @"Inglês";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        translatedWord1 = @"Inglês";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        translatedWord1 = @"Engelsk";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        translatedWord1 = @"Englanti";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        translatedWord1 = @"Engelska";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord1 = @"英语";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord1 = @"英語";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        translatedWord1 = @"Английский";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        translatedWord1 = @"Angielski";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        translatedWord1 = @"İngilizce";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        translatedWord1 = @"اللغة الإنجليزية";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        translatedWord1 = @"Engleski";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        translatedWord1 = @"Angličtina";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        translatedWord1 = @"Αγγλικά";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        translatedWord1 = @"Engleză";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        translatedWord1 = @"Angličtina";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        translatedWord1 = @"ภาษาอังกฤษ";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        translatedWord1 = @"Angol";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        translatedWord1 = @"ENGLISH";
    }
    
    
//    NSMutableString  *outputHTML = [[NSMutableString alloc] initWithFormat:@""];
    
    NSMutableString *strTemp = [NSMutableString stringWithString:@"You can improve your English by this app!\nReady2read? Yes, you can."];
#ifdef CHINESE
    
    strTemp = [NSMutableString stringWithFormat:@"我学习汉语"];
    translatedWord = @"I";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord = @"나";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"es"]) {
        //Spanish [스페인어] : Español
        translatedWord = @"yo";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord = @"je";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        //독일어 Deutsch
        translatedWord = @"ich";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord = @"私";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        //Dutch [네덜란드어] : Nederlands
        translatedWord = @"ik";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        //이탈리아어 italiano
        translatedWord = @"io";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        //포르투칼어 português
        translatedWord = @"Eu";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        //포르투칼어 português (Portugal)
        translatedWord = @"Eu";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        //덴마크어 dansk
        translatedWord = @"jeg";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        //Swedish [스웨덴어] : Svenska
        translatedWord = @"jag";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord = @"我";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord = @"我";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        //Russian [러시아어] : Русский язык
        translatedWord = @"я";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        //[폴란드어] : Język polski
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        //[터키어] : Türkçe
        translatedWord = @"ben";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        //Arabic [아랍어] : ﺔﻴﺑﺮﻌﻟﺍ
        translatedWord = @"أنا";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        //크로아이타어 hrvatski
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        //체코 čeština
        translatedWord = @"já";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        //그리스어 Ελληνικά
        translatedWord = @"εγώ";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        //히브루? עברית
        translatedWord = @"אני";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        //루마니아? română
        translatedWord = @"eu";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        //슬로바키아? slovenčina
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        //타이어 ไทย
        translatedWord = @"ผม";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        //인도네시아어] : Bahasa Indonesia
        translatedWord = @"saya";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        //영국식 영어 English (United Kingdom)
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        //까딸누냐 català
        translatedWord = @"jo";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        //[헝가리어] : Magyar
        translatedWord = @"én";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        //핀란드 suomi
        translatedWord = @"minä";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        //노르웨이어 norsk bokmål
        translatedWord = @"jeg";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        //[베트남어] : Tiếng Viẹt
        translatedWord = @"tôi";
    }
    
    
    
    translatedWord1 = @"Chinese language";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord1 = @"중국어";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"es"]) {
        //Spanish [스페인어] : Español
        translatedWord1 = @"idioma chino";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord1 = @"langue chinoise";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        //독일어 Deutsch
        translatedWord1 = @"chinesische Sprache";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord1 = @"中国語";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        //Dutch [네덜란드어] : Nederlands
        translatedWord1 = @"Chinese taal";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        //이탈리아어 italiano
        translatedWord1 = @"lingua cinese";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        //포르투칼어 português
        translatedWord1 = @"língua chinesa";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        //포르투칼어 português (Portugal)
        translatedWord1 = @"língua chinesa";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        //덴마크어 dansk
        translatedWord1 = @"Kinesisk sprog";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        //Swedish [스웨덴어] : Svenska
        translatedWord1 = @"kinesiska språket";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord1 = @"汉语";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord1 = @"汉语";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        //Russian [러시아어] : Русский язык
        translatedWord1 = @"Китайский язык";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        //[폴란드어] : Język polski
        translatedWord1 = @"język chiński";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        //[터키어] : Türkçe
        translatedWord1 = @"Çince dil";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        //Arabic [아랍어] : ﺔﻴﺑﺮﻌﻟﺍ
        translatedWord1 = @"اللغة الصينية";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        //크로아이타어 hrvatski
        translatedWord1 = @"kineski jezik";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        //체코 čeština
        translatedWord1 = @"Čínský jazyk";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        //그리스어 Ελληνικά
        translatedWord1 = @"κινεζική γλώσσα";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        //히브루? עברית
        translatedWord1 = @"שפה סינית";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        //루마니아? română
        translatedWord1 = @"Chineză limba";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        //슬로바키아? slovenčina
        translatedWord1 = @"čínsky jazyk";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        //타이어 ไทย
        translatedWord1 = @"ภาษาจีน";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        //인도네시아어] : Bahasa Indonesia
        translatedWord1 = @"Cina bahasa";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        //영국식 영어 English (United Kingdom)
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        //까딸누냐 català
        translatedWord1 = @"idioma xinès";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        //[헝가리어] : Magyar
        translatedWord1 = @"kínai nyelv";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        //핀란드 suomi
        translatedWord1 = @"Kiinan kielen";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        //노르웨이어 norsk bokmål
        translatedWord1 = @"Kinesisk språk";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        //[베트남어] : Tiếng Viẹt
        translatedWord1 = @"tiếng Trung hoa";
    }
#endif

	NSMutableString *strFileContents = [NSMutableString stringWithString:[self HTMLFromString:strTemp backColor:TRUE]];
    DLog(@"strFileContents : %@", strFileContents);
    BOOL ShowMeaning = [[dicEnv objectForKey:@"Show Meaning"] boolValue];
    
    if (ShowMeaning == TRUE) {
        NSString *MeaningHtml = @"";
            
        NSString *showColorOccur = @"";

        NSString  *strValueToChange1 = @"";
        NSString  *strValueToChange2 = @"";

        
    #ifdef ENGLISH
        showColorOccur = KEY_CSS_WORDNotSure;
        MeaningHtml = @"";
        if (ShowMeaning == TRUE) {
            if ([translatedWord isEqualToString: @""] == FALSE) {
                MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", translatedWord];
            }
        }
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"you" withString:[NSString stringWithFormat:@"%@you%@", strValueToChange1,strValueToChange2]                                          options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
        
        showColorOccur = KEY_CSS_WORDUnknown;
        MeaningHtml = @"";
    
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"improve" withString:[NSString stringWithFormat:@"%@improve%@", strValueToChange1,strValueToChange2] options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
        showColorOccur = KEY_CSS_WORDNotRated;
        MeaningHtml = @"";
        if (ShowMeaning == TRUE) {
            if ([translatedWord isEqualToString: @""] == FALSE) {
                MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", translatedWord1];
            }
        }
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"English" withString:[NSString stringWithFormat:@"%@English%@", strValueToChange1,strValueToChange2] options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
    #elif CHINESE
        showColorOccur = KEY_CSS_WORDNotSure;
        MeaningHtml = @"";
        if (ShowMeaning == TRUE) {
            if ([translatedWord isEqualToString: @""] == FALSE) {
                MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", translatedWord];
            }
        }
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"我" withString:[NSString stringWithFormat:@"%@我%@", strValueToChange1,strValueToChange2]                                          options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
        
        showColorOccur = KEY_CSS_WORDUnknown;
        MeaningHtml = @"";
    //    if (ShowMeaning == TRUE) {
    //        if ([translatedWord isEqualToString: @""] == FALSE) {
    //            MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", translatedWord];
    //        }
    //    }
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"学习" withString:[NSString stringWithFormat:@"%@学习%@", strValueToChange1,strValueToChange2] options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
        showColorOccur = KEY_CSS_WORDNotRated;
        MeaningHtml = @"";
        if (ShowMeaning == TRUE) {
            if ([translatedWord isEqualToString: @""] == FALSE) {
                MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", translatedWord1];
            }
        }
        strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
        strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
        [strFileContents replaceOccurrencesOfString:@"汉语" withString:[NSString stringWithFormat:@"%@汉语%@", strValueToChange1,strValueToChange2] options:NSLiteralSearch range:NSMakeRange(0, [strFileContents length])];
        
        DLog(@"strFileContents : %@", strFileContents);
        
    #endif
    }

    NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
    [webViewOne loadHTMLString:strFileContents baseURL:myBaseURL];
}

- (void) showMeaningOnePage11
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];	
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];	
//    DLog(@"lang : %@", languages);
    NSString *strOutputLang = [NSString stringWithFormat:@"%@", [languages objectAtIndex:0]];
    DLog(@"strOutputLang : %@", strOutputLang);
    
	DLog(@"locale : %@", [NSLocale currentLocale]);
    DLog(@"locale : %@", [[NSLocale currentLocale] localeIdentifier]);
    
//    NSString *strWord1 = @"YOU";
    NSString *translatedWord = @"YOU";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord = @"당신";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord = @"vous";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        translatedWord = @"Sie";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord = @"あなた";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        translatedWord = @"u";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        translatedWord = @"si";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        translatedWord = @"você";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        translatedWord = @"você";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        translatedWord = @"du";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        translatedWord = @"te";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        translatedWord = @"du";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord = @"你";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord = @"你";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        translatedWord = @"Вы";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        translatedWord = @"Państwo";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        translatedWord = @"Eğer";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        translatedWord = @"لك";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        translatedWord = @"ti";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        translatedWord = @"Vás";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        translatedWord = @"Σας";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        translatedWord = @"tu";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        translatedWord = @"Vás";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        translatedWord = @"คุณ";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        translatedWord = @"YOU";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        translatedWord = @"Ön";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        translatedWord = @"YOU";
    }
    
//    NSString *strWord2 = @"ENGLISH";
    NSString *translatedWord1 = @"ENGLISH";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord1 = @"영어";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord1 = @"En anglais";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        translatedWord1 = @"Englisch";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord1 = @"えい-ご";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        translatedWord1 = @"Engels";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        translatedWord1 = @"Inglese";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        translatedWord1 = @"Inglês";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        translatedWord1 = @"Inglês";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        translatedWord1 = @"Engelsk";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        translatedWord1 = @"Englanti";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        translatedWord1 = @"Engelska";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord1 = @"英语";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord1 = @"英語";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        translatedWord1 = @"Английский";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        translatedWord1 = @"Angielski";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        translatedWord1 = @"İngilizce";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        translatedWord1 = @"اللغة الإنجليزية";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        translatedWord1 = @"Engleski";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        translatedWord1 = @"Angličtina";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        translatedWord1 = @"Αγγλικά";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        translatedWord1 = @"Engleză";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        translatedWord1 = @"Angličtina";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        translatedWord1 = @"ภาษาอังกฤษ";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        translatedWord1 = @"ENGLISH";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        translatedWord1 = @"Angol";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        translatedWord1 = @"ENGLISH";
    }
    
    
    NSMutableString  *outputHTML = [[NSMutableString alloc] initWithFormat:@""];
    
    NSMutableString *strTemp = [NSMutableString stringWithString:@"You can improve your English by this app!\nReady2read? Yes, you can."];
#ifdef CHINESE
    
    strTemp = [NSMutableString stringWithFormat:@"我学习汉语"];
    translatedWord = @"I";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord = @"나";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"es"]) {
        //Spanish [스페인어] : Español
        translatedWord = @"yo";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord = @"je";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        //독일어 Deutsch
        translatedWord = @"ich";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord = @"私";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        //Dutch [네덜란드어] : Nederlands
        translatedWord = @"ik";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        //이탈리아어 italiano
        translatedWord = @"io";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        //포르투칼어 português
        translatedWord = @"Eu";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        //포르투칼어 português (Portugal)
        translatedWord = @"Eu";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        //덴마크어 dansk
        translatedWord = @"jeg";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        //Swedish [스웨덴어] : Svenska
        translatedWord = @"jag";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord = @"我";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord = @"我";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        //Russian [러시아어] : Русский язык
        translatedWord = @"я";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        //[폴란드어] : Język polski
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        //[터키어] : Türkçe
        translatedWord = @"ben";
    }else if ([strOutputLang isEqualToString:@"uk"]) {        
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        //Arabic [아랍어] : ﺔﻴﺑﺮﻌﻟﺍ
        translatedWord = @"أنا";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        //크로아이타어 hrvatski
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        //체코 čeština
        translatedWord = @"já";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        //그리스어 Ελληνικά
        translatedWord = @"εγώ";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        //히브루? עברית
        translatedWord = @"אני";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        //루마니아? română
        translatedWord = @"eu";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        //슬로바키아? slovenčina
        translatedWord = @"ja";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        //타이어 ไทย
        translatedWord = @"ผม";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        //인도네시아어] : Bahasa Indonesia
        translatedWord = @"saya";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        //영국식 영어 English (United Kingdom)
        translatedWord = @"I";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        //까딸누냐 català
        translatedWord = @"jo";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        //[헝가리어] : Magyar
        translatedWord = @"én";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        //핀란드 suomi
        translatedWord = @"minä";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        //노르웨이어 norsk bokmål
        translatedWord = @"jeg";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        //[베트남어] : Tiếng Viẹt
        translatedWord = @"tôi";
    }


    
    translatedWord1 = @"Chinese language";
    if ([strOutputLang isEqualToString:@"ko"]) {
        translatedWord1 = @"중국어";
    } else if ([strOutputLang isEqualToString:@"en"]) {
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"es"]) {
        //Spanish [스페인어] : Español
        translatedWord1 = @"idioma chino";
    }else if ([strOutputLang isEqualToString:@"fr"]) {
        translatedWord1 = @"langue chinoise";
    }else if ([strOutputLang isEqualToString:@"de"]) {
        //독일어 Deutsch
        translatedWord1 = @"chinesische Sprache";
    }else if ([strOutputLang isEqualToString:@"ja"]) {
        translatedWord1 = @"中国語";
    }else if ([strOutputLang isEqualToString:@"nl"]) {
        //Dutch [네덜란드어] : Nederlands
        translatedWord1 = @"Chinese taal";
    }else if ([strOutputLang isEqualToString:@"it"]) {
        //이탈리아어 italiano
        translatedWord1 = @"lingua cinese";
    }else if ([strOutputLang isEqualToString:@"pt"]) {
        //포르투칼어 português
        translatedWord1 = @"língua chinesa";
    }else if ([strOutputLang isEqualToString:@"pt-PT"]) {
        //포르투칼어 português (Portugal)
        translatedWord1 = @"língua chinesa";
    }else if ([strOutputLang isEqualToString:@"da"]) {
        //덴마크어 dansk
        translatedWord1 = @"Kinesisk sprog";
    }else if ([strOutputLang isEqualToString:@"sv"]) {
        //Swedish [스웨덴어] : Svenska
        translatedWord1 = @"kinesiska språket";
    }else if ([strOutputLang isEqualToString:@"zh-Hans"]) {
        translatedWord1 = @"汉语";
    }else if ([strOutputLang isEqualToString:@"zh-Hant"]) {
        translatedWord1 = @"汉语";
    }else if ([strOutputLang isEqualToString:@"ru"]) {
        //Russian [러시아어] : Русский язык
        translatedWord1 = @"Китайский язык";
    }else if ([strOutputLang isEqualToString:@"pl"]) {
        //[폴란드어] : Język polski
        translatedWord1 = @"język chiński";
    }else if ([strOutputLang isEqualToString:@"tr"]) {
        //[터키어] : Türkçe
        translatedWord1 = @"Çince dil";
    }else if ([strOutputLang isEqualToString:@"uk"]) {
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"ar"]) {
        //Arabic [아랍어] : ﺔﻴﺑﺮﻌﻟﺍ
        translatedWord1 = @"اللغة الصينية";
    }else if ([strOutputLang isEqualToString:@"hr"]) {
        //크로아이타어 hrvatski
        translatedWord1 = @"kineski jezik";
    }else if ([strOutputLang isEqualToString:@"cs"]) {
        //체코 čeština
        translatedWord1 = @"Čínský jazyk";
    }else if ([strOutputLang isEqualToString:@"el"]) {
        //그리스어 Ελληνικά
        translatedWord1 = @"κινεζική γλώσσα";
    }else if ([strOutputLang isEqualToString:@"he"]) {
        //히브루? עברית
        translatedWord1 = @"שפה סינית";
    }else if ([strOutputLang isEqualToString:@"ro"]) {
        //루마니아? română
        translatedWord1 = @"Chineză limba";
    }else if ([strOutputLang isEqualToString:@"sk"]) {
        //슬로바키아? slovenčina
        translatedWord1 = @"čínsky jazyk";
    }else if ([strOutputLang isEqualToString:@"th"]) {
        //타이어 ไทย
        translatedWord1 = @"ภาษาจีน";
    }else if ([strOutputLang isEqualToString:@"id"]) {
        //인도네시아어] : Bahasa Indonesia
        translatedWord1 = @"Cina bahasa";
    }else if ([strOutputLang isEqualToString:@"en-GB"]) {
        //영국식 영어 English (United Kingdom)
        translatedWord1 = @"Chinese language";
    }else if ([strOutputLang isEqualToString:@"ca"]) {
        //까딸누냐 català
        translatedWord1 = @"idioma xinès";
    }else if ([strOutputLang isEqualToString:@"hu"]) {
        //[헝가리어] : Magyar
        translatedWord1 = @"kínai nyelv";
    }else if ([strOutputLang isEqualToString:@"fi"]) {
        //핀란드 suomi
        translatedWord1 = @"Kiinan kielen";
    }else if ([strOutputLang isEqualToString:@"nb"]) {
        //노르웨이어 norsk bokmål
        translatedWord1 = @"Kinesisk språk";
    }else if ([strOutputLang isEqualToString:@"vi"]) {
        //[베트남어] : Tiếng Viẹt
        translatedWord1 = @"tiếng Trung hoa";
    }
    
#endif
	NSMutableString *strFileContents = [NSMutableString stringWithString:[self HTMLFromString:strTemp backColor:TRUE]];
    
    NSScanner *thescanner;
    NSString *temp = nil;
    NSString *text = nil;	
    thescanner = [NSScanner scannerWithString:strFileContents];
    //    NSMutableString *str = [[NSMutableString alloc] init];
    //    	DLog(@"html : %@", html);
    //    NSInteger no = 0;
    while ([thescanner isAtEnd] == NO) {
        
        // find start of tag
		[thescanner scanUpToString:@"<" intoString:&temp];
        //        DLog(@"Contents length : %d", [temp length]);
        //        DLog(@"Contents : '%@'", temp);
        if (temp != NULL) {
            temp = [temp stringByReplacingOccurrencesOfString:@">" withString:@""];
            //태그내의 내용 원형..
            NSMutableString *strOri = [NSMutableString stringWithString:temp];
            
            //연속되는 공백을 찾는 표현식
            
            //내용이 있으면 단어를 분리한한후 뜻을 단다.
            if ((temp != NULL) || ([temp length] > 0)) {
                //                DLog(@"2Contents length : %d", [temp length]);
                //                DLog(@"2Contents : '%@'", temp);
                
                //정규표현식으로 영어 대소문자를 제외하고 모두 지운후 arrTemp에 넣는다.
                NSError *err = nil;
                NSRegularExpression *regEx1 = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:&err];
                
                temp = [regEx1 stringByReplacingMatchesInString:temp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [temp length]) withTemplate:@" "];
                
                
                NSArray *arrTemp1 = [[temp lowercaseString] componentsSeparatedByString:@" "];

                
                //                DLog(@"arrTemp1 : %@", arrTemp1);
                //                NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                //단어들을 돌면서 유일한 단어를 뽑아낸다.
                NSMutableDictionary *dicWordsInTxtTemp = [[NSMutableDictionary alloc] init];
                for (NSString *strWord in arrTemp1){
                    //                    DLog(@"dicWordsInTxtTemp length : %d", [dicWordsInTxtTemp count]);
                    //                    DLog(@"dicWordsInTxtTemp : %@", dicWordsInTxtTemp);
                    if ((strWord == NULL) || ([strWord length] <= 1)) {
                        continue;
                    }	
                    //NSString *strInput = [strOne lowercaseString];
                    if ([strWord isEqualToString:@""] == TRUE) {
                        continue;
                    }
                    
                    //<,>,&,공백, quote등은 처리안한다.
                    if (([strWord isEqualToString:@"gt"]) || ([strWord isEqualToString:@"lt"]) || ([strWord isEqualToString:@"amp"]) || ([strWord isEqualToString:@"nbsp"]) || ([strWord isEqualToString:@"quot"])) {
                        continue;
                    }
                    //green, font, class도 처리 안한다.
                    if (([strWord isEqualToString:KEY_CSS_WORDNotRated]) || ([strWord isEqualToString:KEY_CSS_WORDUnknown]) || ([strWord isEqualToString:KEY_CSS_WORDNotSure]) || ([strWord isEqualToString:KEY_CSS_WORDNotRatedIdiom]) || ([strWord isEqualToString:KEY_CSS_WORDUnknownIdiom]) || ([strWord isEqualToString:KEY_CSS_WORDNotSureIdiom]) || ([strWord isEqualToString:@"body"]) || ([strWord isEqualToString:@"font"]) || ([strWord isEqualToString:@"class"]) ) {
                        continue;
                    }
                    
                    //font.WORDKnown { color : blue}
                    //font.WORDExclude { background:aqua; font-weight : bold; color : blue }
                    
                    //                    if ([[strOne lowercaseString] isEqualToString:@"thump"] == true) {
                    //                        NSString *strtestst = @"";
                    //                        strtestst = @"dalnim";
                    //                    }
                    //                    DLog(@"strWord : %@", strWord);
                    BOOL containsKey = ([dicWordsInTxtTemp objectForKey:strWord] != nil);
                    if (containsKey == FALSE) {		
                        NSInteger intKnow = 3;
                        NSString *strMeaning = @"";
#ifdef ENGLISH
                        if ([[strWord lowercaseString] isEqualToString:@"you"]) {
                            intKnow = 2;
                            strMeaning = translatedWord;
                        }
                        
                        if ([[strWord lowercaseString] isEqualToString:@"english"]) {
                            intKnow = 1;
                            strMeaning = translatedWord1;                            
                        }
                        if ([[strWord lowercaseString] isEqualToString:@"improve"]) {
                            intKnow = 0;
                        }
#elif CHINESE
                        DLog(@"strWord : %@", strWord);
                        if ([[strWord lowercaseString] isEqualToString:@"我"]) {
                            intKnow = 2;
                            strMeaning = translatedWord;
                        }
                        
                        if ([[strWord lowercaseString] isEqualToString:@"学习"]) {
                            intKnow = 1;
                            strMeaning = translatedWord1;
                        }
                        if ([[strWord lowercaseString] isEqualToString:@"汉语"]) {
                            intKnow = 0;
                        }
                        
#endif
                        if (intKnow >= 3) {
                            continue;
                        }
//                        DLog(@"strWord : %@", strWord);
                        BOOL ShowMeaning = [[dicEnv objectForKey:@"Show Meaning"] boolValue];
                        NSString *MeaningHtml = @"";
                        if (ShowMeaning == TRUE) {
                            if ([strMeaning isEqualToString: @""] == FALSE) {
                                MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", strMeaning];
                              }
                        }
                        
                        NSString *showColorOccur = KEY_CSS_WORDNotRated;
                        if (intKnow == 1) {
                            showColorOccur = KEY_CSS_WORDUnknown;
                        } else if   (intKnow == 2) {
                            showColorOccur = KEY_CSS_WORDNotSure;
                        }
                        NSString  *strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
                        NSString  *strValueToChange2 = [NSString stringWithFormat:@"</font>%@", MeaningHtml];
                        
                        NSError *err = nil;
                        NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWord] options:NSRegularExpressionCaseInsensitive error:&err];
                        //                                            DLog("strOri Before : %@", strOri);                    
                        [regEx2 replaceMatchesInString:strOri options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strOri length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
                        //                                                DLog(@"strOri : %@", strOri);
                        [dicWordsInTxtTemp setObject:strWord forKey:strWord];
                    } else {
                        //                        DLog(@"strWord duplicated : '%@'", strWord);
                        [dicWordsInTxtTemp setObject:strWord forKey:strWord];
                        
                    }
                }                
            }
            [outputHTML appendString:strOri];
        }
        
        // find end of tag
		[thescanner scanUpToString:@">" intoString:&text];
        [outputHTML appendString:[NSString stringWithFormat:@"%@>", text]];
//                DLog(@"text : %@", text);
//                DLog(@"outputHTML : %@", outputHTML);
    }    
    NSURL *myBaseURL = [NSURL fileURLWithPath:[myCommon getDocPath]];
    [webViewOne loadHTMLString:outputHTML baseURL:myBaseURL];
}

-(IBAction) back {
//    [aiv startAnimating];
    [SVProgressHUD showProgress:-1 status:@""];
    // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(callStartAiv:)
                                   userInfo:nil
                                    repeats:NO];    

}

- (void) callStartAiv:(NSTimer*)sender
{
    [SVProgressHUD showProgress:-1 status:@""];
	[self.navigationController popViewControllerAnimated:YES];    
}

-(IBAction) save
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strStyleImsiCSS = [[myCommon getDocPath] stringByAppendingPathComponent:@"styleImsi.css"];
    NSError *error;
    BOOL dbExists = [fileManager fileExistsAtPath:strStyleImsiCSS];
    if(dbExists)
    {
        //이미 있으면 지운다.
        [fileManager removeItemAtPath:strStyleImsiCSS error:&error];
    }
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Saved", @"")];
	[self saveBookSetting];
}

- (BOOL)saveBookSetting
{
    
    NSMutableDictionary *dicCSS = [[NSMutableDictionary alloc] init];        
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    if (blnBookDayMode == TRUE) {
        NSDictionary *dicBODY = [defs dictionaryForKey:@"CSS_BODY"]; 
        
        NSMutableDictionary *dicWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSure = [[NSMutableDictionary alloc] init];        
        NSMutableDictionary *dicWORDNotRatedIdiom = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknownIdiom = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSureIdiom = [[NSMutableDictionary alloc] init];
        
        NSArray *arrNotRated = [arrOptFontSettingValue objectAtIndex:0];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:0]] forKey:@"Color"];    
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:3]] forKey:@"Italic"];
        const CGFloat *component = [myCommon getColorComponents:[arrNotRated objectAtIndex:0]];
        NSInteger red = component[0] * 255;
        NSInteger green = component[1] * 255;
        NSInteger blue = component[2] * 255;
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDNotRated setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];    
        
        NSArray *arrUnknown = [arrOptFontSettingValue objectAtIndex:1];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:0]] forKey:@"Color"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrUnknown objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        //BLACK일때는 green이 255로 오기 때문에 일단 0으로 바꾼다...
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDUnknown setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        NSArray *arrNotSure = [arrOptFontSettingValue objectAtIndex:2];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:0]] forKey:@"Color"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrNotSure objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }
        [dicWORDNotSure setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        //Idiom은 사용자가 편집할수 없고 정해진걸 그대로 쓴다.
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
        
        [dicCSS setValue:dicBODY forKey:KEY_CSS_BODY];
        [dicCSS setValue:dicWORDNotRated forKey:KEY_CSS_WORDNotRated];
        [dicCSS setValue:dicWORDUnknown forKey:KEY_CSS_WORDUnknown];
        [dicCSS setValue:dicWORDNotSure forKey:KEY_CSS_WORDNotSure];
        [dicCSS setValue:dicWORDNotRatedIdiom forKey:KEY_CSS_WORDNotRatedIdiom];
        [dicCSS setValue:dicWORDUnknownIdiom forKey:KEY_CSS_WORDUnknownIdiom];
        [dicCSS setValue:dicWORDNotSureIdiom forKey:KEY_CSS_WORDNotSureIdiom];
        [myCommon CreateCSS:dicCSS option:CSS_Option_Day];
    } else {
        NSDictionary *dicBODY = [defs dictionaryForKey:@"CSS_NightBODY"]; 
        
        NSMutableDictionary *dicWORDNotRated = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDUnknown = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dicWORDNotSure = [[NSMutableDictionary alloc] init];        
        
        NSArray *arrNotRated = [arrOptFontSettingValue objectAtIndex:0];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:0]] forKey:@"Color"];    
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotRated setValue:[NSString stringWithFormat:@"%@", [arrNotRated objectAtIndex:3]] forKey:@"Italic"];
        const CGFloat *component = [myCommon getColorComponents:[arrNotRated objectAtIndex:0]];
        NSInteger red = component[0] * 255;
        NSInteger green = component[1] * 255;
        NSInteger blue = component[2] * 255;
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotRated objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }        
        [dicWORDNotRated setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotRated setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];    
        
        NSArray *arrUnknown = [arrOptFontSettingValue objectAtIndex:1];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:0]] forKey:@"Color"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDUnknown setValue:[NSString stringWithFormat:@"%@", [arrUnknown objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrUnknown objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        //BLACK일때는 green이 255로 오기 때문에 일단 0으로 바꾼다...
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrUnknown objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }        
        [dicWORDUnknown setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDUnknown setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        NSArray *arrNotSure = [arrOptFontSettingValue objectAtIndex:2];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:0]] forKey:@"Color"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:1]] forKey:@"Underline"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:2]] forKey:@"Bold"];
        [dicWORDNotSure setValue:[NSString stringWithFormat:@"%@", [arrNotSure objectAtIndex:3]] forKey:@"Italic"];
        component = [myCommon getColorComponents:[arrNotSure objectAtIndex:0]];
        red = component[0] * 255;
        green = component[1] * 255;
        blue = component[2] * 255;
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"BLACK"]) {
            green = 0;
        }
        if ([[[arrNotSure objectAtIndex:0] uppercaseString] isEqualToString:@"WHITE"]) {
            blue = 255;
        }        
        [dicWORDNotSure setValue:[NSNumber numberWithInt:red] forKey:@"Color_Red"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:green] forKey:@"Color_Green"];
        [dicWORDNotSure setValue:[NSNumber numberWithInt:blue] forKey:@"Color_Blue"];  
        
        
        [dicCSS setValue:dicBODY forKey:@"NightBODY"];
        [dicCSS setValue:dicWORDNotRated forKey:@"NightWORDNotRated"];
        [dicCSS setValue:dicWORDUnknown forKey:@"NightWORDUnknown"];
        [dicCSS setValue:dicWORDNotSure forKey:@"NightWORDNotSure"];        
        [myCommon CreateCSS:dicCSS option:CSS_Option_Night];
    }


    
    NSString *strOpt_SHOW_PhrasalVerb = [self.dicEnv objectForKey:Defs_SHOW_PhrasalVerb];
    if ([strOpt_SHOW_PhrasalVerb isEqualToString:@"OFF"]) {
        [defs setValue:@"OFF" forKey:Defs_SHOW_PhrasalVerb];
    } else {
        [defs setValue:@"ON" forKey:Defs_SHOW_PhrasalVerb];
    }

    NSString *strOpt_QUIZ_Enable = [self.dicEnv objectForKey:Defs_QUIZ_ENABLE];
    if ([strOpt_QUIZ_Enable isEqualToString:@"OFF"]) {
        [defs setValue:@"OFF" forKey:Defs_QUIZ_ENABLE];
    } else {
        [defs setValue:@"ON" forKey:Defs_QUIZ_ENABLE];
    }
    
    NSString *strOpt_QUIZ_Vibration = [self.dicEnv objectForKey:Defs_QUIZ_VIBRATION];
    if ([strOpt_QUIZ_Vibration isEqualToString:@"OFF"]) {
        [defs setValue:@"OFF" forKey:Defs_QUIZ_VIBRATION];
    } else {
        [defs setValue:@"ON" forKey:Defs_QUIZ_VIBRATION];
    }
    
    DLog("dicEnv : %@", dicEnv);
	NSInteger ShowMeaning = [[self.dicEnv objectForKey:@"Show Meaning"] integerValue];

	NSString	*strUpdateQuery = [NSString	stringWithFormat:@"UPDATE %@ SET %@ = %d", TBL_APP_INFO, FldName_SHOWMEANING,  ShowMeaning];
    return ([myCommon changeRec:strUpdateQuery openMyDic:TRUE]);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tableView == tblViewMain) {
        return [self.arrDicSetting count];
    } else if (tableView == tblViewOption) {
        return 1;
    } else if (tableView == tblViewFontSetting) {
        return 1;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.	
	if (  tableView  == tblViewMain) {
        return [[self.arrDicSetting objectAtIndex:section] count];
	} else if (tableView == tblViewOption) {
		if (_Option == 1) {
            DLog(@"arrOptBackgroundColor count : %d", [arrOptBackgroundColor count]);
			return [self.arrOptBackgroundColor count];
		} else if (_Option == 2) {
			return [self.arrOptFontcolorKnow1 count];
		} else if (_Option == 3) {
			return [self.arrOptFontcolorKnow2 count];
		} else if (_Option == 4) {
            return [self.arrOptFontColor count];
        }
	} else if (tableView == tblViewFontSetting) {
        return [arrOptFontSetting count];
    }
    return [[self.arrDicSetting objectAtIndex:section] count];
}

- (UIColor *)getColorFromString:(NSString*)strColor{
    
    UIColor *color = [UIColor blackColor];
    if ([[strColor uppercaseString] isEqualToString:@"BLACK"]) {
        color = [UIColor blackColor];
    } else if ([[strColor uppercaseString] isEqualToString:@"BLUE"]) {
        color = [UIColor blueColor];
    } else if ([[strColor uppercaseString] isEqualToString:@"BROWN"]) {
        color = [UIColor brownColor];
    } else if ([[strColor uppercaseString] isEqualToString:@"GREEN"]) {
        color = [UIColor greenColor];
    } else if ([[strColor uppercaseString] isEqualToString:@"RED"]) {
        color = [UIColor redColor];
    } else if ([[strColor uppercaseString] isEqualToString:@"WHITE"]) {
        color = [UIColor blackColor];
    }
    return color;
}

static NSString *CellIdentifier = @"Cell";
static NSString *CellIDSubtitle = @"CellIDSubstitle";
static NSString *CellIdentifierFontSetting = @"CellFontSetting";
static NSString *CellIdentifierOption = @"CellOption";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	

	if (tableView == tblViewMain) {
        DLog(@"indexPath.sectioin : %d", indexPath.section);
        DLog(@"indexPath.row : %d", indexPath.row);
		UITableViewCell *cell = nil;
		if (indexPath.section == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIDSubtitle];
		}
	//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			if (indexPath.section == 0) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
			} else {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIDSubtitle];
//                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                NSArray *arrOne = [[self.arrDicSetting objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; 
                DLog(@"arrOne : %@", arrOne);
                
                cell.textLabel.text = [arrOne objectAtIndex:0];
                UISwitch *switchOne = [[UISwitch alloc] initWithFrame:CGRectMake(200, 12, 94, 27)];
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    switchOne.frame = CGRectMake(tblViewMain.frame.size.width - switchOne.frame.size.width - 100, 12, switchOne.frame.size.width, switchOne.frame.size.height);
                }
                [switchOne addTarget:self action:@selector(selSwitch:event:) forControlEvents:UIControlEventValueChanged];
                switchOne.tag = 1;
                cell.accessoryView = switchOne;
                
                NSInteger Value = [[self.dicEnv objectForKey:@"Show Meaning"] integerValue];
                if (Value == 1) {
                    [switchOne setOn:YES animated:NO];
                } else {
                    [switchOne setOn:NO animated:NO];				
                }        
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"Mail to developer", @"");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 2) {
                //영어일때 숙어보기를 설정하는것
                NSArray *arrOne = [[self.arrDicSetting objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                DLog(@"arrOne : %@", arrOne);
                
                cell.textLabel.text = [arrOne objectAtIndex:0];
                UISwitch *switchOne = [[UISwitch alloc] initWithFrame:CGRectMake(200, 12, 94, 27)];
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                    switchOne.frame = CGRectMake(tblViewMain.frame.size.width - switchOne.frame.size.width - 100, 12, switchOne.frame.size.width, switchOne.frame.size.height);
                }
                [switchOne addTarget:self action:@selector(selSwitch:event:) forControlEvents:UIControlEventValueChanged];
                switchOne.tag = 2;
                cell.accessoryView = switchOne;
                
                if ([[self.dicEnv objectForKey:Defs_SHOW_PhrasalVerb] isEqualToString:@"ON"]) {
                    [switchOne setOn:YES animated:NO];
                } else {
                    [switchOne setOn:NO animated:NO];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else if (indexPath.section == 1) {
            
            NSString *wordColor = [[self.arrDicSetting objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSArray *arrOne = [arrOptFontSettingValue objectAtIndex:indexPath.row];
            cell.textLabel.text = wordColor;
            
            static const float fontSize = 16.0;
            NSString *strColor = [arrOne objectAtIndex:0];
            CGSize labelSize = [strColor sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]];
            UnderLineLabel *uLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
            uLabel.backgroundColor =[UIColor clearColor];
            uLabel.shouldUnderline = ([[arrOne objectAtIndex:1] isEqualToString:@"ON"]);
            uLabel.textColor = [self getColorFromString:strColor];
            uLabel.font = [UIFont systemFontOfSize:fontSize];
            
            if ([[arrOne objectAtIndex:2] isEqualToString:@"ON"]) {
                uLabel.font = [UIFont boldSystemFontOfSize:fontSize];
            }
            if ([[arrOne objectAtIndex:3] isEqualToString:@"ON"]) {
                uLabel.font = [UIFont italicSystemFontOfSize:fontSize];
            }
            if (([[arrOne objectAtIndex:2] isEqualToString:@"ON"]) && ([[arrOne objectAtIndex:3] isEqualToString:@"ON"])) {
                uLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
            }
            
            uLabel.text = strColor;
            cell.accessoryView = uLabel;

        } else if (indexPath.section == 2) {
            NSString *strOne = [[self.arrDicSetting objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; 

            
            cell.textLabel.text = strOne;
            UISwitch *switchOne = [[UISwitch alloc] initWithFrame:CGRectMake(200, 12, 94, 27)];
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                switchOne.frame = CGRectMake(tblViewMain.frame.size.width - switchOne.frame.size.width - 100, 12, switchOne.frame.size.width, switchOne.frame.size.height);
            }
            [switchOne addTarget:self action:@selector(selSwitchQuiz:event:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchOne;
                
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            if (indexPath.row == 0) {
                NSString *strOpt = [defs stringForKey:@"QUIZ_ENABLE"];  
                if ([strOpt isEqualToString:@"OFF"]) {
                    [switchOne setOn:NO animated:NO];				
                } else {
                    [switchOne setOn:YES animated:NO];                    
                }        
            } else if (indexPath.row == 1) {
                NSString *strOpt = [defs stringForKey:@"QUIZ_VIBRATION"];  
                if ([strOpt isEqualToString:@"OFF"]) {
                    [switchOne setOn:NO animated:NO];				
                } else {
                    [switchOne setOn:YES animated:NO];                    
                }                        
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }		

		return cell;
	} else if (tableView == tblViewOption) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
			cell.accessoryType = UITableViewCellAccessoryNone;		
			cell.selectionStyle = UITableViewCellSelectionStyleGray;

		}
		if (_Option == 1) {
            DLog(@"indexPath.row : %d", indexPath.row);
            DLog(@"arrOptBackgroundColor : %@", arrOptBackgroundColor);
			cell.textLabel.text = [arrOptBackgroundColor objectAtIndex:indexPath.row];
		} else if (_Option == 2) {
            
            NSString *strColor = [[arrOptFontcolorKnow1 objectAtIndex:indexPath.row] objectAtIndex:0];
            cell.textLabel.text = strColor;
            cell.textLabel.textColor = [self getColorFromString:strColor];
            
		} else if (_Option == 3) {
			cell.textLabel.text = [arrOptFontcolorKnow2 objectAtIndex:indexPath.row];
		} else if (_Option == 4) {
            cell.textLabel.text = [arrOptFontColor objectAtIndex:indexPath.row];
        }
		
		return cell;
	} else if (tableView == tblViewFontSetting) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFontSetting];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierFontSetting];
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		                    
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;		
            }
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
		}

        NSArray *arrOne = [arrOptFontSettingValue objectAtIndex:_indexOfArrOptFontSetting];
        cell.detailTextLabel.text = [arrOne objectAtIndex:indexPath.row]; 
        cell.textLabel.text = [arrOptFontSetting objectAtIndex:indexPath.row];
        
        NSString *strColor = [arrOne objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [self getColorFromString:strColor];

		return cell;
    }
    return nil;
}

-(void) selSwitch:(id)sender event:(id)event
{
	UISwitch *switchOne = (UISwitch*)sender;
	//현재선택한 셀의 줄을 가져온다.
	UITableViewCell *cell = (UITableViewCell*)[sender superview];
    NSIndexPath *indexPath = [tblViewMain indexPathForCell:cell];
    
   NSArray *arrTemp     = [[self.arrDicSetting	objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *strTemp = [arrTemp objectAtIndex:0];
    DLog(@"strTemp : %@", strTemp);
	
    if ([strTemp isEqualToString:NSLocalizedString(@"Show Meaning", @"")] == TRUE) {
        
		if (switchOne.on) {

            [self showMeaning:1];            
			[self.dicEnv setValue:[NSNumber numberWithInt:1] forKey:@"Show Meaning"];
		} else {
            
            [self showMeaning:0];
			[self.dicEnv setValue:[NSNumber numberWithInt:0] forKey:@"Show Meaning"];
		}		
        
	} else if ([strTemp isEqualToString:NSLocalizedString(@"Show Phrasal Verb", @"")] == TRUE) {
        if (switchOne.on) {
        
            [self showMeaning:1];
			[self.dicEnv setValue:@"ON" forKey:Defs_SHOW_PhrasalVerb];
		} else {
            
            [self showMeaning:0];
			[self.dicEnv setValue:@"OFF" forKey:Defs_SHOW_PhrasalVerb];
		}
    }
    DLog("dicEnv : %@", dicEnv);
    [self showMeaningOnePage];
}

-(void) selSwitchQuiz:(id)sender event:(id)event
{
	UISwitch *switchOne = (UISwitch*)sender;
	//현재선택한 셀의 줄을 가져온다.
    
    UITableViewCell *cell = (UITableViewCell*)[sender superview];

	NSIndexPath *indexPath = [tblViewMain indexPathForCell:cell];
    NSString *strTemp     = [[self.arrDicSetting	objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[strTemp uppercaseString] isEqualToString:@"ENABLE"]) {
        if (switchOne.on) {
            [self.dicEnv setValue:@"ON" forKey:@"QUIZ_ENABLE"];
        } else {
            [self.dicEnv setValue:@"OFF" forKey:@"QUIZ_ENABLE"];
        }
    } else if ([[strTemp uppercaseString] isEqualToString:@"VIBRATION"]) {
        if (switchOne.on) {
            [self.dicEnv setValue:@"ON" forKey:@"QUIZ_VIBRATION"];
        } else {
            [self.dicEnv setValue:@"OFF" forKey:@"QUIZ_VIBRATION"];
        }        
    }
}

- (NSMutableString*) showHTMLFontSetting:(NSInteger)intKnow strOne:(NSMutableString*)strHTML
{
    
    NSMutableString  *outputHTML = [[NSMutableString alloc] initWithFormat:@""];
	NSMutableString *strFileContents = [NSMutableString stringWithString:strHTML];

    NSScanner *thescanner;
    NSString *temp = nil;
    NSString *text = nil;	
    thescanner = [NSScanner scannerWithString:strFileContents];
    while ([thescanner isAtEnd] == NO) {
		[thescanner scanUpToString:@"<" intoString:&temp];
        if (temp != NULL) {
            temp = [temp stringByReplacingOccurrencesOfString:@">" withString:@""];
            //태그내의 내용 원형..
            NSMutableString *strOri = [NSMutableString stringWithString:temp];
            
            //내용이 있으면 단어를 분리한한후 뜻을 단다.
            if ((temp != NULL) || ([temp length] > 0)) {                
                //정규표현식으로 영어 대소문자를 제외하고 모두 지운후 arrTemp에 넣는다.
                NSError *err = nil;
                NSRegularExpression *regEx1 = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:&err];
                
                temp = [regEx1 stringByReplacingMatchesInString:temp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [temp length]) withTemplate:@" "];
                
                
                NSArray *arrTemp1 = [[temp lowercaseString] componentsSeparatedByString:@" "];
                //                DLog(@"arrTemp1 : %@", arrTemp1);
                //                NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                //단어들을 돌면서 유일한 단어를 뽑아낸다.
                NSMutableDictionary *dicWordsInTxtTemp = [[NSMutableDictionary alloc] init];
                for (NSString *strWord in arrTemp1){
                    //                    DLog(@"dicWordsInTxtTemp length : %d", [dicWordsInTxtTemp count]);
                    //                    DLog(@"dicWordsInTxtTemp : %@", dicWordsInTxtTemp);
                    if ((strWord == NULL) || ([strWord length] <= 1)) {
                        continue;
                    }	
                    //NSString *strInput = [strOne lowercaseString];
                    if ([strWord isEqualToString:@""] == TRUE) {
                        continue;
                    }
                    
                    //<,>,&,공백, quote등은 처리안한다.
                    if (([strWord isEqualToString:@"gt"]) || ([strWord isEqualToString:@"lt"]) || ([strWord isEqualToString:@"amp"]) || ([strWord isEqualToString:@"nbsp"]) || ([strWord isEqualToString:@"quot"])) {
                        continue;
                    }
                    //green, font, class도 처리 안한다.
                    if (([strWord isEqualToString:KEY_CSS_WORDNotRated]) || ([strWord isEqualToString:KEY_CSS_WORDUnknown]) || ([strWord isEqualToString:KEY_CSS_WORDNotSure]) || ([strWord isEqualToString:KEY_CSS_WORDNotRatedIdiom]) || ([strWord isEqualToString:KEY_CSS_WORDUnknownIdiom]) || ([strWord isEqualToString:KEY_CSS_WORDNotSureIdiom]) || ([strWord isEqualToString:@"body"]) || ([strWord isEqualToString:@"font"]) || ([strWord isEqualToString:@"class"]) ) {
                        continue;
                    }
                    
                    BOOL containsKey = ([dicWordsInTxtTemp objectForKey:strWord] != nil);
                    if (containsKey == FALSE) {		

                        NSString *showColorOccur = KEY_CSS_WORDNotRated;
                        if (intKnow == 1) {
                            showColorOccur = KEY_CSS_WORDUnknown;
                        } else if   (intKnow == 2) {
                            showColorOccur = KEY_CSS_WORDNotSure;
                        }
                        NSString  *strValueToChange1 = [NSString stringWithFormat:@"<font class=%@>", showColorOccur];
                        NSString  *strValueToChange2 = [NSString stringWithFormat:@"</font>"];
                        
                        NSError *err = nil;
                        NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWord] options:NSRegularExpressionCaseInsensitive error:&err];
                        //                                            DLog("strOri Before : %@", strOri);                    
                        [regEx2 replaceMatchesInString:strOri options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strOri length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
                        //                                                DLog(@"strOri : %@", strOri);
                        [dicWordsInTxtTemp setObject:strWord forKey:strWord];
                    } else {
                        //                        DLog(@"strWord duplicated : '%@'", strWord);
                        [dicWordsInTxtTemp setObject:strWord forKey:strWord];
                        
                    }
                }                
            }
            [outputHTML appendString:strOri];
        }
        
        // find end of tag
		[thescanner scanUpToString:@">" intoString:&text];
        [outputHTML appendString:[NSString stringWithFormat:@"%@>", text]];
        //        DLog(@"text : %@", text);
        DLog(@"outputHTML : %@", outputHTML);
    }   
    DLog(@"outputHTML : %@", outputHTML);
    return outputHTML;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (tableView == tblViewMain) {
        if ((indexPath.section == 0) && (indexPath.row == 1)) {
            //개발자에게 메일보내기...
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            if (controller != NULL) {
                controller.mailComposeDelegate = self;
                NSArray* toRecipients = [NSArray arrayWithObjects:@"dalnimsoft@gmail.com", nil];
                [controller setToRecipients:toRecipients];
#ifdef ENGLISH
    #ifdef LITE
                [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"[MyEnglishLite] Comments or Suggestions.", @"")]];
    #else
                [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"[MyEnglish] Comments or Suggestions.", @"")]];
    #endif
#elif CHINESE
    #ifdef LITE
                [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"[MyChineseLite] Comments or Suggestions.", @"")]];
    #else
                [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"[MyChinesePro] Comments or Suggestions.", @"")]];
    #endif
#endif
                NSString *body = [NSString stringWithFormat:NSLocalizedString(@"I love this app.<br>Even though it is great app, I have some comments or suggestions.<br><br>", @"")];
                [controller setMessageBody:body isHTML:YES];
                
                [self presentModalViewController:controller animated:YES];
            }
        }
        //WordColor설정
        if (indexPath.section == 1) {
//            DLog(@"indexPath.Row : %d", indexPath.row);
            self.navigationItem.leftBarButtonItem = nil;
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeTblViewFontSetting)];
            self.navigationItem.leftBarButtonItem = backButton;

            self.navigationItem.rightBarButtonItem = nil;

            
            _Option = 2;
            _indexOfArrOptFontSetting = indexPath.row;
            [self.tblViewFontSetting reloadData];
//            [self.view addSubview:tblViewFontSetting];
            self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            CATransition *ani = [CATransition animation];
            [ani setDelegate:self];
            [ani setDuration:0.3f];
            [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [ani setType:kCATransitionPush];
            [ani setSubtype:kCATransitionFromRight];
//            [self.tblView removeFromSuperview];
//            [self.webViewOne removeFromSuperview];
            [self.view  bringSubviewToFront:tblViewFontSetting];
            [[tblViewFontSetting layer] addAnimation:ani forKey:@"transitionViewAnimation"];
        }

	} else if (tableView == tblViewOption) {

    DLog(@"arrOptFontSettingValue : %@", arrOptFontSettingValue);
        NSMutableArray *arrOne = [arrOptFontSettingValue objectAtIndex:_indexOfArrOptFontSetting];
        [arrOne replaceObjectAtIndex:0 withObject:[[arrOptFontcolorKnow1 objectAtIndex:indexPath.row] objectAtIndex:0]];
        [self.tblViewFontSetting reloadData];
    DLog(@"arrOptFontSettingValue : %@", arrOptFontSettingValue);
        
        CATransition *animation1 = [CATransition animation];
        [animation1 setType:kCATransitionPush];
        [animation1 setSubtype:kCATransitionFromBottom];
        [animation1 setDuration:0.5];
        [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[tblViewOption layer] addAnimation:animation1 forKey:kCATransition];
        tblViewOption.hidden = YES;
        
	} else if (tableView == tblViewFontSetting) {
        if (indexPath.row == 0) {
            [self.tblViewOption reloadData];

            if (self.tblViewOption.hidden) {
                [self.view bringSubviewToFront:self.tblViewOption];
                CATransition *animation1 = [CATransition animation];
                [animation1 setType:kCATransitionPush];
                [animation1 setSubtype:kCATransitionFromTop];
                [animation1 setDuration:0.5];
                [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                [[tblViewOption layer] addAnimation:animation1 forKey:kCATransition];
                self.tblViewOption.hidden = NO;
            }
            
        } else {
            DLog(@"arrOptFontSettingValue Before : %@", arrOptFontSettingValue);
            NSMutableArray *arrOne = [arrOptFontSettingValue objectAtIndex:_indexOfArrOptFontSetting];
            NSString *strONorOFF = [arrOne objectAtIndex:indexPath.row];
            if ([strONorOFF isEqualToString:@"ON"]) {
                strONorOFF = @"OFF";
            } else {
                strONorOFF = @"ON";
            }       
                    DLog(@"arrOne : %@", arrOne);
            [arrOne replaceObjectAtIndex:indexPath.row withObject:strONorOFF];
            DLog(@"arrOptFontSettingValue After : %@", arrOptFontSettingValue);
            [self.tblViewFontSetting reloadData];
        }
    }
}
//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger cellHeight = 60;
    if (tableView == tblViewMain) {
        if (indexPath.section == 0) {
            cellHeight = 50;
        } else if (indexPath.section == 1) {
            cellHeight = 40;
        }
    }
    return cellHeight;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *strTitleHeader = @"";
    if (tableView == tblViewMain) {
        if (section == 0) {
            strTitleHeader = NSLocalizedString(@"Study Option", @"");
        } else if (section == 1) {
            strTitleHeader = NSLocalizedString(@"Font Setting", @"");
        } else if (section == 2) {
            strTitleHeader = NSLocalizedString(@"Quiz Option", @"");
        }
    } else if (tableView == tblViewOption) {
        if (_indexOfArrOptFontSetting == 0) {
            strTitleHeader = NSLocalizedString(@"Font Color Of Not Rated", @"");
        } else if (_indexOfArrOptFontSetting == 1) {
            strTitleHeader = NSLocalizedString(@"Font Color of Unknown", @"");
        } else if (_indexOfArrOptFontSetting == 2) {
            strTitleHeader = NSLocalizedString(@"Font Color of NotSure", @"");
        } else if (_indexOfArrOptFontSetting == 3) {
            strTitleHeader = NSLocalizedString(@"Font Color Of Known", @"");
        } else if (_indexOfArrOptFontSetting == 4) {
            strTitleHeader = NSLocalizedString(@"Font Color Of Exclude", @"");
        }
    }
	return strTitleHeader;
}

- (NSString*) tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *strTitleFooter= @"";
    return strTitleFooter;
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
#pragma mark UIPickerViewDelegate methods   

//피커뷰에 보이는 글자...
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [NSString stringWithFormat:@"%@", [self.arrDifficulty objectAtIndex:row]];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.arrDifficulty count];
}

//피커뷰에서 선택한것을 적는다.
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"Dic : %@", [NSString stringWithFormat:@"%@", [self.arrDifficulty objectAtIndex:row]]);
        DLog(@"dicEnv : %@", dicEnv);
    DLog(@"dicEnv : %@", dicEnv);

}


#pragma mark -
#pragma mark UIWebViewDelegate methods   
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
// WebView is finished loading
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSInteger Value = [[self.dicEnv objectForKey:@"Show Meaning"] integerValue];
    [self showMeaning:Value];
    
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"java" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [webView stringByEvaluatingJavaScriptFromString:jsCode];
    NSInteger intFontSize = 100;
    if (webView == webViewOne) {
        intFontSize = 160;
    }
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", intFontSize];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
}

- (void) showMeaning:(NSInteger)intValue
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"java" ofType:@"js"];
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];	
	[self.webViewOne stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
