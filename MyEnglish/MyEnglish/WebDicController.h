//
//  WebDicController.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 6..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BookViewController.h"

@interface WebDicController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UIWebViewDelegate, UITabBarDelegate> {
    NSMutableArray              *arrWebView;
    NSMutableArray              *arrAiv;
	NSString					*strWord;
	NSInteger					slideBackLightValue;
	NSMutableDictionary			*dicAllWordsAllAttribute;
	IBOutlet	UIWebView		*webViewDic;

	IBOutlet	UISearchBar		*searchBarInWebDic;
	IBOutlet	UIActivityIndicatorView		*aiv;
	NSInteger						intBeforeSegConWebDicSelectedIndex;
	NSInteger						intBeforeTabbarSelectedIndex;
	NSInteger								intBookTblNo;
	IBOutlet	UIPickerView		*pickerWebDic;
    IBOutlet    UIView              *viewPicker;
    IBOutlet    UIBarButtonItem     *barBtnItemSelectPicker;
    IBOutlet    UIBarButtonItem     *barBtnItemCacnelPicker;
    
    IBOutlet    UITabBarItem        *tabBarEditWebDic;
    IBOutlet    UITabBarItem        *tabBarChangeWebDic;
    NSInteger                       intSelItemPicker;
	NSMutableArray					*arrLang;
	NSString						*strOutputLang;
	NSString						*strFileNameWebDicListsPlist;
	NSMutableArray					*arrWebDicLists;
    BOOL                            blnCancelButtonClicked;
    NSInteger                       beforeErrorCode;
}
@property (nonatomic, strong) NSMutableArray              *arrWebView;
@property (nonatomic, strong) NSMutableArray              *arrAiv;
@property (nonatomic, strong) NSString		*strWord;
@property (nonatomic) NSInteger					slideBackLightValue;
@property (nonatomic, strong) NSMutableDictionary		*dicAllWordsAllAttribute;

@property (nonatomic, strong) IBOutlet	UISearchBar		*searchBarInWebDic;
@property (nonatomic, strong) IBOutlet	UIActivityIndicatorView		*aiv;
@property (nonatomic, strong) IBOutlet	UIPickerView		*pickerWebDic;
@property (nonatomic, strong) IBOutlet	UIView				*viewPicker;
@property (nonatomic, strong) IBOutlet	UIBarButtonItem     *barBtnItemSelectPicker;
@property (nonatomic, strong) IBOutlet	UIBarButtonItem     *barBtnItemCacnelPicker;
@property (nonatomic, strong) IBOutlet    UITabBarItem        *tabBarEditWebDic;
@property (nonatomic, strong) IBOutlet    UITabBarItem        *tabBarChangeWebDic;

@property (nonatomic, strong) NSMutableArray					*arrLang;
@property (nonatomic) NSInteger						intSelItemPicker;
@property (nonatomic) NSInteger						intBeforeSegConWebDicSelectedIndex;
@property (nonatomic) NSInteger						intBeforeTabbarSelectedIndex;
@property (nonatomic) NSInteger								intBookTblNo;
@property (nonatomic, strong) NSString						*strOutputLang;
@property (nonatomic, strong) 	NSString					*strFileNameWebDicListsPlist;
@property (nonatomic, strong) NSMutableArray				*arrWebDicLists;
@property (nonatomic) BOOL blnCancelButtonClicked;
@property (nonatomic)  NSInteger                       beforeErrorCode;

- (void) callWebViewList;
- (void) createWebDicListPlistIfNeeded;

- (IBAction)back;
- (IBAction)onOpenWordDetail;
- (IBAction) onBarBtnItemSelectPicker;
- (IBAction) onBarBtnItemCancelPicker;

@end
