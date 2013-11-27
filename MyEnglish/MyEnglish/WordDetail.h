//
//  WordDetail.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 1. 27..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>

@interface WordDetail : UIViewController<UIActionSheetDelegate, UITabBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
//	NSMutableString					*strWordOri;
    UILabel                     *_lblWordInCell;
    UILabel                     *_lblMeaningInCell;
    UILabel                     *_lblPronounceInCell;
    UILabel                     *_lblTraditionalChineseInCell;
    UILabel                     *_lblDescInCell;
//    NSString                    *_strMeaning;
//    NSString                    *_strMeaningOri;
    NSString					*_strProverb;
//    NSString                    *_strPronounce;
//    NSString                    *_strTraditionalChinese;
//    NSString                    *_strDesc;
	NSMutableArray				*_arrWordsInProverb;
    
    NSInteger                   txtWordIndexInArrWords;
    NSInteger                   txtWordOriIndexInArrWords;    
	NSString					*_strWord;
//    NSString                    *_strWordOri;
	NSString					*_strWordFirst;
	NSString					*_strWordFirstSampleText;
	NSArray                     *arrKnow;
	NSArray                     *arrLevel;
    NSMutableDictionary         *_dicWord;
	NSMutableArray				*_arrWords;
    NSMutableArray              *arrSampleSentences;
    
    NSInteger                   intChangeKnownOrUnKnownWhat;
    UIButton                    *_btnChangeKnowing;
    UIButton                    *_btnChangeKnowingPronounce;
    UILabel                     *_lblKnowing;
    UITextField                 *_txtFldWord;
    
    IBOutlet UISegmentedControl         *segConKnow;
    IBOutlet UISegmentedControl          *segConKnownStatus;
    
    //단어 발음의 아는정도를 바꾸는것
    IBOutlet    UIView          *viewSelectKnowPronounce;
    IBOutlet    UIBarButtonItem        *btnCancelKnowPronounce;
    IBOutlet    UIBarButtonItem        *btnSelectKnowPronounce;
	IBOutlet    UIPickerView                *pickerKnowPronounce;
    NSString                    *strKnowPronounceInPickerView;
    NSString                      *strKnowPronounceChangedTemp;

    NSString                    *strKnowWordInPickerView;
    NSString                      *strKnowWordChangedTemp;

	IBOutlet	UITableView		*tblViewGroup;
    IBOutlet	UITableView		*tblViewDetail;
//	IBOutlet	UIScrollView			*scrollViewOne;
	IBOutlet	UITextView		*txtView;
	IBOutlet	UITabBar			*tabBarOne;
	IBOutlet	UILabel			*lblAlarmSaved;
	IBOutlet	UILabel			*lblKnowWord;
//	IBOutlet	UILabel			*lblKnowWordOri;
    IBOutlet    UILabel         *lblWordLevel;
    IBOutlet    UILabel         *lblKnowPronounce;
    IBOutlet    UIView          *viewNewHeadword;
    IBOutlet    UITextField     *txtNewHeadword;
    IBOutlet    UILabel         *lblNewHeadword;
    IBOutlet    UIView          *viewSampleSentenceMain;
    IBOutlet    UIView          *viewSampleSnetneceSegCon;
    IBOutlet    UISegmentedControl  *segConSampleSentence;
    IBOutlet    UITextView      *txtViewSampleSentenceEng;
    IBOutlet    UITextView      *txtViewSampleSentenceKor;
    IBOutlet    UITableView     *tblViewSampleSentence;
    IBOutlet    UIView          *viewSegControl;
    
	BOOL						keyboardVisible;	
	NSInteger					intBeforeSegSelectedTag;
	NSInteger					intBookTblNo;
    NSInteger                   intDicWordOrIdiom;
//	NSInteger					_intKnow;
//	NSInteger					_intKnowOri;
//    NSInteger                   _intKnowPronounce;
	NSString					*strBookTblName;
	BOOL						blnFirstWordOpen;
    BOOL                        blnChangeHeadword;
//	IBOutlet	UILabel			*lblKnow;
//	IBOutlet	UILabel			*lblCount;
//    NSMutableDictionary          *dicWordsForQuiz;
    
    NSIndexPath *indexPathTblViewDetailsNeedReload;
}
//@property (nonatomic, strong) NSMutableString		*strWordOri;
@property (nonatomic) NSInteger     txtWordIndexInArrWords;
@property (nonatomic) NSInteger     txtWordOriIndexInArrWords;
@property (nonatomic, strong) NSString		*_strWord;
@property (nonatomic, strong) NSString                    *_strWordOri;
@property (nonatomic, strong) NSString		*_strWordFirst;
@property (nonatomic, strong) NSString		*_strWordFirstSampleText;
@property (nonatomic, strong) NSArray		*arrKnow;
@property (nonatomic, strong) NSArray		*arrLevel;

@property (nonatomic, strong) UILabel                     *_lblWordInCell;
@property (nonatomic, strong) UILabel                     *_lblMeaningInCell;
@property (nonatomic, strong) UILabel                     *_lblPronounceInCell;
@property (nonatomic, strong) UILabel                     *_lblTraditionalChineseInCell;
@property (nonatomic, strong) UILabel                     *_lblDescInCell;
@property (nonatomic, strong) NSMutableArray				*_arrWordsInProverb;
@property (nonatomic, strong)     NSString                    *_strMeaning;
//@property (nonatomic, strong)     NSString                  *_strMeaningOri;
@property (nonatomic, strong) NSString					*_strProverb;
@property (nonatomic, strong)     NSString                    *_strPronounce;
@property (nonatomic, strong) NSString                    *_strTraditionalChinese;
@property (nonatomic, strong) NSString                    *_strDesc;
@property (nonatomic, strong) NSMutableDictionary         *_dicWord;
@property (nonatomic, strong) NSMutableArray		*_arrWords;
@property (nonatomic, strong) NSMutableArray		*arrSampleSentences;


@property (nonatomic, strong)     UIButton                    *_btnChangeKnowing;
@property (nonatomic, strong)     UIButton                    *_btnChangeKnowingPronounce;
@property (nonatomic, strong)         UITextField                 *_txtFldWord;
@property (nonatomic, strong) IBOutlet    UIView          *viewSelectKnowPronounce;
@property (nonatomic, strong) IBOutlet    UIBarButtonItem        *btnCancelKnowPronounce;
@property (nonatomic, strong) IBOutlet    UIBarButtonItem        *btnSelectKnowPronounce;
@property (nonatomic, strong) IBOutlet    UIPickerView                  *pickerKnowPronounce;
@property (nonatomic, strong) NSString                      *strKnowPronounceInPickerView;
@property (nonatomic, strong) NSString                      *strKnowPronounceChangedTemp;

@property (nonatomic, strong) NSString                      *strKnowWordInPickerView;
@property (nonatomic, strong) NSString                      *strKnowWordChangedTemp;

@property (nonatomic, strong) IBOutlet UITableView		*tblViewGroup;
@property (nonatomic, strong) IBOutlet	UITableView		*tblViewDetail;
//@property (nonatomic, strong) IBOutlet UIScrollView			*scrollViewOne;
@property (nonatomic, strong) IBOutlet	UITextView		*txtView;
@property (nonatomic, strong) IBOutlet UITabBar			*tabBarOne;
@property (nonatomic, strong) IBOutlet UILabel			*lblAlarmSaved;
@property (nonatomic, strong) IBOutlet UILabel			*lblKnowWord;
//@property (nonatomic, strong) IBOutlet UILabel			*lblKnowWordOri;
@property (nonatomic, strong) IBOutlet UILabel			*lblWordLevel;
@property (nonatomic, strong) IBOutlet    UILabel         *lblKnowPronounce;
@property (nonatomic, strong) IBOutlet IBOutlet    UIView          *viewNewHeadword;
@property (nonatomic, strong) IBOutlet IBOutlet    UILabel         *lblNewHeadword;  
@property (nonatomic, strong) IBOutlet IBOutlet    UITextField     *txtNewHeadword;

@property (nonatomic, strong) IBOutlet    UIView          *viewSampleSentenceMain;
@property (nonatomic, strong) IBOutlet    UIView          *viewSampleSnetneceSegCon;
@property (nonatomic, strong) IBOutlet    UISegmentedControl  *segConSampleSentence;
@property (nonatomic, strong) IBOutlet    UITextView      *txtViewSampleSentenceEng;
@property (nonatomic, strong) IBOutlet    UITextView      *txtViewSampleSentenceKor;
@property (nonatomic, strong) IBOutlet    UITableView     *tblViewSampleSentence;
@property (nonatomic, strong) IBOutlet    UIView          *viewSegControl;
@property (nonatomic) BOOL keyboardVisible;
@property (nonatomic) NSInteger								intBeforeSegSelectedTag;
@property (nonatomic) NSInteger								intBookTblNo;
@property (nonatomic) NSInteger                             intDicWordOrIdiom;
//@property (nonatomic) NSInteger								_intKnow;
//@property (nonatomic) NSInteger								_intKnowOri;
//@property (nonatomic)     NSInteger                   _intKnowPronounce;
@property (nonatomic)     NSInteger                   intChangeKnownOrUnKnownWhat;
@property (nonatomic) BOOL									blnFirstWordOpen;
@property (nonatomic, strong) NSString						*strBookTblName;
//@property (nonatomic, strong)        NSMutableDictionary          *dicWordsForQuiz;
//@property (nonatomic, strong) IBOutlet UILabel			*lblKnow;
//@property (nonatomic, strong) IBOutlet UILabel			*lblCount;
- (IBAction) back;
- (void) callSaveChangeHeadword;
- (void) callSaveChangeKnowing;
- (void) changeHeadword;
- (void) changeKnowing;
- (void) keyboardDidShow : (NSNotification*) notif;
- (void) keyboardDidHide : (NSNotification*) notif;

- (IBAction) onOpenWebDic;
//- (IBAction) onTxtFldChanged;
//- (IBAction) onTxtFldOriChanged;
//- (IBAction) onTxtFldPronounceChanged;
//- (IBAction) onTxtFldMeaningChanged;
//- (IBAction) onTxtFldMeaningOriChanged;
- (IBAction) OnSaveWord;
- (IBAction) selSegConSmapleSentence;
- (void) getWordsFromTbl;
- (void) saveChangeHeadword:(NSTimer*)sender;
- (void) saveChangeKnowing:(NSTimer*)sender;
- (void) cancelChangeHeadword;
- (void) cancelChangeSampleSentence;
- (void) doneEditing:(id)sender;
- (void) doneEditingSampleSentence:(id)sender;
- (void) callStartAiv:(NSTimer*)sender;

- (void) onBtnKnowWordChange:(id)sender;
- (void) onBtnKnowPronounceChange:(id)sender;
- (void) onBtnKnowWordOrPronounceChange;

- (IBAction) btnCancelKnowPronounce:(id)sender;
- (IBAction) btnSelectKnowPronounce:(id)sender;
- (IBAction) onKnowPronounceChanged;

- (void) getEachWordFromTbl;

@end
