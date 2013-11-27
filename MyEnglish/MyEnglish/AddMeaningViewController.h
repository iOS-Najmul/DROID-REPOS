//
//  AddMeaningViewController.h
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 7. 10..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMeaningViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray          *arrDocList;

    BOOL                    blnShowKeyboard;
    BOOL                    blnCancelSaveSetWordsAndMeaning;


    UIActionSheet					*actionSheetProgress;
    UIProgressView					*progressViewInActionSheet;

    NSInteger               intDoWordGroupOrLevelTest;
    //아는단어 설정하기
    IBOutlet UITextView     *txtViewSetWords;
    NSMutableArray          *arrSetWordsAndMeaning;
    NSInteger               intTypeSetWordsAndMeaning;
    //    NSMutableArray          *arrWordsByCategory;
    IBOutlet UITableView    *tblOne;
    
    CGRect                  oriFrameOfTextView;
    NSInteger               intMode;
}

@property (nonatomic, strong) NSMutableArray          *arrDocList;

@property (nonatomic)     BOOL                    blnShowKeyboard;
@property (nonatomic)     BOOL                    blnCancelSaveSetWordsAndMeaning;
@property (nonatomic, strong) IBOutlet UITextView     *txtViewSetWords;
@property (nonatomic, strong) NSMutableArray          *arrSetWordsAndMeaning;
@property (nonatomic) NSInteger               intTypeSetWordsAndMeaning;

@property (nonatomic, strong) IBOutlet UITableView    *tblOne;

@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView	*progressViewInActionSheet;
@property (nonatomic)     CGRect                  oriFrameOfTextView;
@property (nonatomic) NSInteger               intMode;

- (void) showSaveBtnAtTextView;

@end
