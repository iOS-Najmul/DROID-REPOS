//
//  ShowAndSetLevel.h
//  Ready2Read
//
//  Created by KIM HyungDal on 11. 11. 1..
//  Copyright (c) 2011 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAndSetLevel : UIViewController<UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIActionSheetDelegate, UITextViewDelegate>
{
    IBOutlet UITableView    *tblLevel;
    IBOutlet UIView         *viewLevel;
    NSMutableArray          *arrSetDefaultUpdateDic;
    NSMutableArray          *arrWordGroup;
    NSMutableArray          *arrUserLevel;    
    NSMutableArray          *arrDocList;
    NSMutableArray          *arrUserDic;
    NSInteger               intBeforeTabBarItemTag;
    
    NSInteger               intMode;
    BOOL                    blnLoadUserLevel;
    BOOL                    blnLoadWordGroup;
    IBOutlet UITabBar       *tabBarOne;
    IBOutlet UITabBarItem   *tabBarItemMyLevel;
    IBOutlet UITabBarItem   *tabBarItemWordLevel;
    IBOutlet UITabBarItem   *tabBarItemDefaultUpdate;
    IBOutlet UITabBarItem   *tabBarItemAddMeaning;
    BOOL                    blnShowKeyboard;
    BOOL                    blnCancelSaveSetWordsAndMeaning;
    CGRect                  oriFrameOfTextView;
    
    UIActionSheet					*actionSheetProgress;
	UIProgressView					*progressViewInActionSheet;

    NSInteger               intDoWordGroupOrLevelTest;
    //아는단어 설정하기
    IBOutlet UITextView     *txtViewSetWords;
    NSMutableArray          *arrSetWordsAndMeaning;
    NSInteger               intTypeSetWordsAndMeaning;
//    NSMutableArray          *arrWordsByCategory;
    IBOutlet UITableView    *tblOne;
    UITextField					*txtNewCategory;
    NSString					*strFieldNameOfNewCategory;
}

@property (nonatomic, strong) IBOutlet UITableView  *tblLevel;
@property (nonatomic, strong) IBOutlet UITableView    *tblSetDefaultUpdateDic;
@property (nonatomic, strong) IBOutlet UIView       *viewLevel;
@property (nonatomic, strong) NSMutableArray          *arrSetDefaultUpdateDic;
@property (nonatomic, strong) NSMutableArray        *arrWordGroup;
@property (nonatomic, strong) NSMutableArray        *arrUserLevel;
@property (nonatomic, strong) NSMutableArray          *arrDocList;
@property (nonatomic, strong)     NSMutableArray          *arrUserDic;
@property (nonatomic)     NSInteger               intBeforeTabBarItemTag;
@property (nonatomic, strong)     IBOutlet UITabBar       *tabBarOne;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemMyLevel;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemWordLevel;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemDefaultUpdate;
@property (nonatomic, strong)     IBOutlet UITabBarItem   *tabBarItemAddMeaning;
@property (nonatomic)     NSInteger               intDoWordGroupOrLevelTest;
@property (nonatomic)     NSInteger                             intMode;
@property (nonatomic)     BOOL                    blnLoadUserLevel;
@property (nonatomic)     BOOL                    blnLoadWordGroup;
@property (nonatomic)     BOOL                    blnShowKeyboard;
@property (nonatomic)     BOOL                    blnCancelSaveSetWordsAndMeaning;
@property (nonatomic, strong) IBOutlet UITextView     *txtViewSetWords;
@property (nonatomic, strong) NSMutableArray          *arrSetWordsAndMeaning;
@property (nonatomic) NSInteger               intTypeSetWordsAndMeaning;
@property (nonatomic)     CGRect                  oriFrameOfTextView;
//@property (nonatomic, strong) NSMutableArray          *arrWordsByCategory;
@property (nonatomic, strong) IBOutlet UITableView    *tblOne;

@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView	*progressViewInActionSheet;

@property (nonatomic, strong) UITextField					*txtNewCategory;
@property (nonatomic, strong) NSString					*strFieldNameOfNewCategory;
- (void) getUserLevel:(NSTimer *)sender;
- (void) getWordGroup:(NSTimer *)sender;
- (void) openDicList:(NSTimer *)sender;
- (void) selSegConKnownOrUnknownInSetLevel:(id)sender;
//- (BOOL) makeBackUp:(NSTimer*)sender;
- (void) showSaveBtnAtTextView;
- (void) CallSave;
- (void) save;
- (BOOL) makeBackUp;

- (void) getBookList:(NSTimer*)sender;

- (void) keyboardWillShow : (NSNotification*) notif;
- (void) keyboardWillHide : (NSNotification*) notif;

- (void) callSaveWordsAndMeaning;
- (void) saveSetWordsAndMeaning:(NSObject*)obj;
- (void) dismissBtnCancel;

- (void) updateDicByCategoryIfNotExists;

- (void) callWriteCategoryFromTxtView;
- (void) writeCategoryFromTxtView:(NSObject*)obj;

- (void) testUserLevel;

@end
