//
//  MoviePlayerSettingController.h
//  MyListPro
//
//  Created by 김형달 on 10. 11. 27..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>


@interface MoviePlayerSettingController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
	NSMutableArray		*arrOptBackgroundColor;
    NSMutableArray		*arrOptFontColor;
    NSMutableArray      *arrOptFontSetting;    
//	NSMutableArray		*arrOptFontcolorKnow1;
	NSMutableArray		*arrOptFontcolorKnow2;	
    NSMutableArray      *arrDifficulty;	
	NSMutableArray      *arrDicSetting;
    NSMutableArray      *arrFontColor;

    NSMutableArray      *arrOptFontSettingValue; 
    
    NSMutableDictionary             *dicBookInfo;
    NSMutableDictionary             *dicEnv;
    NSMutableDictionary             *dicFontColor;
	NSString				*writableDBPath;
	NSString						*strScriptFileName;
	NSString						*_strOptBackgroundColor;
    NSString						*_strOptFontColor;
	NSString						*_strOptFontcolorKnow1;
	NSString						*_strOptFontcolorKnow2;
	
	IBOutlet UITableView			*tblViewMain;
	IBOutlet UITableView			*tblViewOption;	
    IBOutlet UITableView            *tblViewFontSetting;
    IBOutlet UIView                 *viewOptionSetting;
	IBOutlet	UIWebView			*webViewOne;
    IBOutlet UIPickerView           *pickerOne;
	NSInteger						_Option;
    NSInteger                       _indexOfArrFontColor;
    NSInteger                       _indexOfArrOptFontSetting;
    BOOL                            blnBookDayMode;
}

@property (nonatomic, strong) NSMutableArray		*arrOptBackgroundColor;
@property (nonatomic, strong) NSMutableArray		*arrOptFontColor;
@property (nonatomic, strong)     NSMutableArray      *arrOptFontSetting;
@property (nonatomic, strong) NSMutableArray		*arrOptFontcolorKnow1;
@property (nonatomic, strong) NSMutableArray		*arrOptFontcolorKnow2;
@property (nonatomic, strong) NSMutableArray        *arrDifficulty;
@property (nonatomic, strong) NSMutableArray		*arrDicSetting;
@property (nonatomic, strong) NSMutableArray		*arrFontColor;

@property (nonatomic, strong)     NSMutableArray      *arrOptFontSettingValue; 

@property (nonatomic, strong) NSMutableDictionary	*dicBookInfo;
@property (nonatomic, strong) NSMutableDictionary	*dicEnv;
@property (nonatomic, strong) NSMutableDictionary             *dicFontColor;
@property (nonatomic, strong) NSString		*writableDBPath;
@property (nonatomic, strong) NSString					*strScriptFileName;
@property (nonatomic, strong) NSString					*_strOptBackgroundColor;
@property (nonatomic, strong) NSString					*_strOptFontColor;
//@property (nonatomic, strong) NSString					*_strOptFontcolorKnow1;
@property (nonatomic, strong) NSString					*_strOptFontcolorKnow2;

@property (nonatomic, strong) IBOutlet	UITableView	*tblViewMain;
@property (nonatomic, strong) IBOutlet	UITableView	*tblViewOption;
@property (nonatomic, strong) IBOutlet UITableView            *tblViewFontSetting;
@property (nonatomic, strong) IBOutlet	UIWebView			*webViewOne;
@property (nonatomic, strong) IBOutlet UIView                 *viewOptionSetting;
@property (nonatomic, strong) IBOutlet UIPickerView           *pickerOne;

@property (nonatomic) NSInteger		_Option;
@property (nonatomic) NSInteger                       _indexOfArrFontColor;
@property (nonatomic)     NSInteger                       _indexOfArrOptFontSetting;
@property (nonatomic) BOOL                              blnBookDayMode;

-(IBAction) save;
-(IBAction) back;

//-(void) createEditableCopyOfDatabaseIfNeeded;
- (BOOL) saveBookSetting;
- (void) showMeaning:(NSInteger)intValue;
- (void) showMeaningOnePage;
- (NSMutableString*) showHTMLFontSetting:(NSInteger)intKnow strOne:(NSMutableString*)strHTML;
- (NSString*)HTMLFromString:(NSMutableString *)originalText backColor:(BOOL)backColor;

-(void) selSwitch:(id)sender event:(id)event;
-(void) selSwitchQuiz:(id)sender event:(id)event;
@end
