//
//  FlashCardController.h
//  Ready2Read
//
//  Created by HyungDal KIM on 11. 8. 10..
//  Copyright 2011 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

enum  {
	directionKnow_Unknown = 1,
	directionKnow_NotSure = 2,
	directionKnow_Known = 3,    
    directionKnow_Exclude = 99,    
};

@interface FlashCardController : UIViewController<UIGestureRecognizerDelegate, UIActionSheetDelegate> {    
    
    IBOutlet UIView                         *viewFlashCard;
    IBOutlet UIImageView                    *imgViewCard;
    IBOutlet UITextView                     *txtViewCardFront;
    IBOutlet UISegmentedControl	*segConKnow;
    IBOutlet UILabel                        *lblPage;
    
    IBOutlet UIImageView                    *imgViewQA_Question;
    IBOutlet UIView                         *viewQA;
    IBOutlet UITextView                     *txtViewQA_Question;
    IBOutlet UIButton                       *btnQA_Answer1;
    IBOutlet UIButton                       *btnQA_Answer2;
    IBOutlet UIButton                       *btnQA_Answer3;
    IBOutlet UIButton                       *btnQA_Answer4;
    
    NSMutableArray                          *arrWordsList;
    NSMutableArray                          *arrWordsListChanged;    
    NSInteger                               curPage;
    NSInteger                               AllPages;
    BOOL                                    blnFrontPage;
    UIActionSheet					*actionSheetProgress;
	UIProgressView					*progressViewInActionSheet;
    UIAlertView                     *alertViewProgress;    
    NSInteger						intBookTblNo;
    NSInteger						intDicListType;
    NSInteger                       intDicWordOrIdiom;
    NSInteger                       intFlashCardType;
    
    IBOutlet UIView                         *viewTestLevel;
    IBOutlet UIImageView                    *imgViewTestLevel;
    IBOutlet UITextView                     *txtViewTestLevelCardFront;
    IBOutlet UILabel                        *lblTestLevelCntOfQuestions;
    IBOutlet UILabel                        *lblTestLevelCntOfKnown;
    IBOutlet UILabel                        *lblTestLevelCntOfUnknown;
    IBOutlet UILabel                        *lblTestLevelCntOfPercentage;    
    IBOutlet UIButton                       *btnTestLevel_Unknown;
    IBOutlet UIButton                       *btnTestLevel_Known;
    NSInteger                               intTestLevelKnownWords;
    NSInteger                               intTestLevelUnknownWords;
    NSInteger                               intTestLevelCntOfStraintUnknownWords;
    NSInteger                               intTestLevelUserLevel;

    IBOutlet UIView                         *clipboardContainer;
    IBOutlet UIView                         *clipboardContainerStudyWord;
}
@property (nonatomic, strong) IBOutlet UIView                         *viewFlashCard;
@property (nonatomic, strong) IBOutlet UIImageView                    *imgViewCard;
@property (nonatomic, strong) IBOutlet UITextView *txtViewCardFront;
@property (nonatomic, strong) IBOutlet	UILabel                        *lblPage;

@property (nonatomic, strong) IBOutlet UIView                         *viewQA;
@property (nonatomic, strong) IBOutlet UITextView                     *txtViewQA_Question;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer1;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer2;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer3;
@property (nonatomic, strong) IBOutlet UIButton                       *btnQA_Answer4;

@property (nonatomic, strong) NSMutableArray                          *arrWordsList;
@property (nonatomic, strong) NSMutableArray                          *arrWordsListChanged;    
@property (nonatomic) NSInteger                               curPage;
@property (nonatomic) NSInteger                               AllPages;
@property (nonatomic) NSInteger						intBookTblNo;
@property (nonatomic) NSInteger						intDicListType;
@property (nonatomic) NSInteger                     intDicWordOrIdiom;
@property (nonatomic) BOOL                                    blnFrontPage;
@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView					*progressViewInActionSheet;
@property (nonatomic, strong) UIAlertView                   *alertViewProgress;
@property (nonatomic)     NSInteger                       intFlashCardType;

@property (nonatomic, strong) IBOutlet UIView                         *viewTestLevel;
@property (nonatomic, strong) IBOutlet UIImageView                    *imgViewTestLevel;
@property (nonatomic, strong) IBOutlet UITextView                     *txtViewTestLevelCardFront;
@property (nonatomic, strong) IBOutlet UILabel                        *lblTestLevelCntOfQuestions;
@property (nonatomic, strong) IBOutlet UILabel                        *lblTestLevelCntOfKnown;
@property (nonatomic, strong) IBOutlet UILabel                        *lblTestLevelCntOfUnknown;
@property (nonatomic, strong) IBOutlet UILabel                        *lblTestLevelCntOfPercentage;
@property (nonatomic, strong) IBOutlet UIButton                       *btnTestLevel_Unknown;
@property (nonatomic, strong) IBOutlet UIButton                       *btnTestLevel_Known;
@property (nonatomic)    NSInteger                               intTestLevelKnownWords;
@property (nonatomic)    NSInteger                               intTestLevelUnknownWords;
@property (nonatomic)    NSInteger                               intTestLevelCntOfStraintUnknownWords;
@property (nonatomic)    NSInteger                               intTestLevelUserLevel;

- (void) back;
- (void) saveMark;
- (void) saveMarkOri:(NSObject*)obj;
- (IBAction) selSegConKnow;
- (void) nextPage:(NSInteger)intDirection;
- (void) onOpenWebDic:(id)sender;
- (void) writeContentOfPage:(NSInteger)page;

#pragma mark -
#pragma mark 단어 테스트 관련 함수
- (IBAction) ntBtnTestLevel_Unknown:(id)sender;
- (IBAction) ntBtnTestLevel_Known:(id)sender;
- (void) nextQuestionInTestLevel:(NSInteger)intDirection;
- (void) saveUserLevel:(NSTimer*)sender;
- (void) initWordTest;
@end
