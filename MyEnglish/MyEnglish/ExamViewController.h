//
//  ExamViewController.h
//  Bookscape_epub
//
//  Created by KIM HyungDal on 12. 6. 6..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolBox/AudioServices.h>


@interface ExamViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UIView                         *viewQA;
    IBOutlet UIImageView                    *imgViewQA_Question;
    IBOutlet UIWebView                      *webViewQA_Question;
    IBOutlet UIButton                       *btnQA_Answer1;
    IBOutlet UIButton                       *btnQA_Answer2;
    IBOutlet UIButton                       *btnQA_Answer3;
    IBOutlet UIButton                       *btnQA_Answer4;
    
    IBOutlet UIView                         *viewNextBefore;
    IBOutlet UIButton                       *btnQA_Next;
    IBOutlet UIButton                       *btnQA_Before;
    IBOutlet UILabel                        *lblPage;
    
    IBOutlet UIView                         *viewAnswerCorrectOrNot;
    IBOutlet UILabel                        *lblAnswerCorrectOrNot;
    
    NSString                                *_strWord;
    NSString                                *_strFullFileContents;
//    NSInteger                               _offsetStart;
//    NSInteger                               _offsetEnd;
    NSMutableArray                          *_arrConfusedAnswers;
    NSMutableArray                          *_arrPastQuestions;
    
    NSInteger                               intAnswer;
    NSInteger                               intWrongAnswer;
    NSMutableArray                          *arrWordListForExam;
    NSMutableArray                          *arrWrongAnswers;
    BOOL                                    blnAnswerd;
    BOOL                                    blnBtnAnswer1Clicked;
    BOOL                                    blnBtnAnswer2Clicked;
    BOOL                                    blnBtnAnswer3Clicked;
    BOOL                                    blnBtnAnswer4Clicked;    
    BOOL                                    blnOnQA_Vibration;
    NSString                                *strQABeforeWord;
    NSInteger                               intMaxNoOfExam;
    NSInteger                               intCurrNoOfExam;
    BOOL                                    blnFinishExam;
    BOOL                                    blnRetryWithWrongAnswers;
    
    BOOL                                    blnQAEnterWordDetail;
    NSInteger                               intExamType;   
    
    
}

@property (nonatomic, strong) IBOutlet      UIView          *viewQA;
@property (nonatomic, strong) IBOutlet      UIImageView     *imgViewQA_Question;
@property (nonatomic, strong) IBOutlet      UIWebView       *webViewQA_Question;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Answer1;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Answer2;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Answer3;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Answer4;
@property (nonatomic, strong) IBOutlet      UIView          *viewNextBefore;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Next;
@property (nonatomic, strong) IBOutlet      UIButton        *btnQA_Before;
@property (nonatomic, strong) IBOutlet      UILabel         *lblPage;
@property (nonatomic, strong) IBOutlet UIView                         *viewAnswerCorrectOrNot;
@property (nonatomic, strong) IBOutlet UILabel                        *lblAnswerCorrectOrNot;

@property (nonatomic, strong)     NSString                                *_strWord;
@property (nonatomic, strong)     NSString                                *_strFullFileContents;
//@property (nonatomic) NSInteger                                             _offsetStart;
//@property (nonatomic) NSInteger                                             _offsetEnd;
@property (nonatomic, strong)     NSMutableArray                          *_arrConfusedAnswers;
@property (nonatomic, strong)     NSMutableArray                          *_arrPastQuestions;

@property (nonatomic) NSInteger intAnswer;
@property (nonatomic) NSInteger intWrongAnswer;
@property (nonatomic, strong) NSMutableArray                          *arrWordListForExam;
@property (nonatomic, strong) NSMutableArray                          *arrWrongAnswers;
@property (nonatomic) BOOL                                              blnAnswerd;
@property (nonatomic) BOOL                                    blnBtnAnswer1Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer2Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer3Clicked;
@property (nonatomic) BOOL                                    blnBtnAnswer4Clicked;   
@property (nonatomic) BOOL                                    blnOnQA_Vibration;   
@property (nonatomic, strong) NSString                      *strQABeforeWord;
@property (nonatomic) NSInteger                               intMaxNoOfExam;
@property (nonatomic) NSInteger                               intCurrNoOfExam;
@property (nonatomic) BOOL                                    blnFinishExam;
@property (nonatomic) BOOL                                    blnRetryWithWrongAnswers;


@property (nonatomic) BOOL                                    blnQAEnterWordDetail;
@property (nonatomic) NSInteger                               intExamType;

-(IBAction) showNextExam;
-(IBAction) showBeforeExam;
- (IBAction) openViewQA:(id)sender;
- (void) onBtnQA_Vibration;
- (IBAction) onBtnQA_Answer1;
- (IBAction) onBtnQA_Answer2;
- (IBAction) onBtnQA_Answer3;
- (IBAction) onBtnQA_Answer4;
- (void) btnQACommonBtnColor;
- (void) btnQACommon;

//- (NSString*) getSentenceWithWord:(NSString*)strWord;
- (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText WordBlank:(NSString*)strWordBlank;

- (void) answerCorrectOrNot:(BOOL)blnCorrect;
@end
