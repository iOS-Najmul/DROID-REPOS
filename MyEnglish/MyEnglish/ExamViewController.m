//
//  ExamViewController.m
//  Bookscape_epub
//
//  Created by KIM HyungDal on 12. 6. 6..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "ExamViewController.h"
#import "myCommon.h"
#import "WordDetail.h"
#import "SVProgressHUD.h"

@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end

@interface ExamViewController ()

@end

@implementation ExamViewController

@synthesize  viewQA, imgViewQA_Question, webViewQA_Question, btnQA_Answer1, btnQA_Answer2, btnQA_Answer3, btnQA_Answer4, btnQA_Next, btnQA_Before, lblPage, intAnswer, intWrongAnswer, arrWordListForExam, arrWrongAnswers, blnAnswerd, blnBtnAnswer1Clicked, blnBtnAnswer2Clicked, blnBtnAnswer3Clicked, blnBtnAnswer4Clicked, blnOnQA_Vibration,strQABeforeWord;
@synthesize blnFinishExam;
@synthesize intMaxNoOfExam, intCurrNoOfExam;
@synthesize blnQAEnterWordDetail;
@synthesize _strWord, _strFullFileContents, _arrConfusedAnswers, _arrPastQuestions;
@synthesize intExamType;
@synthesize blnRetryWithWrongAnswers;
@synthesize viewAnswerCorrectOrNot, lblAnswerCorrectOrNot;
@synthesize viewNextBefore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    viewAnswerCorrectOrNot.layer.cornerRadius = 20.0;
    
    [viewAnswerCorrectOrNot setAlpha:0.0f];		
	[lblAnswerCorrectOrNot setAlpha:0.0f];
    
    blnFinishExam = FALSE;
    blnRetryWithWrongAnswers = FALSE;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"FlashCard_Back_5.jpg"]];
    
    intExamType = intExamType_WordAndMeaning;
    blnQAEnterWordDetail = FALSE;
    intCurrNoOfExam = -1;
    intMaxNoOfExam = intMaxNoOfExam_ALL;
    self.arrWordListForExam = [myCommon getWordListForExam:intMaxNoOfExam];
    self._arrPastQuestions = [[NSMutableArray alloc] initWithCapacity:intMaxNoOfExam];
    intMaxNoOfExam = ([arrWordListForExam count] > intMaxNoOfExam_ALL) ? intMaxNoOfExam_ALL : [arrWordListForExam count];
    DLog(@"arrWordListForExam : %@", arrWordListForExam);
    DLog(@"intMaxNoOfExam : %d", intMaxNoOfExam);
    intExamType = intExamType_BlankInSentence;
    [self showNextExam];
//    self._strWord = @"dad";
//    [self openViewQA:nil];
//    NSMutableString *strMutWord = [NSMutableString stringWithString:_strWord];
//    [webViewQA_Question loadHTMLString:[self HTMLFromTextStringPage:strMutWord] baseURL:nil];
    //웹뷰를 세로로 움직이지 않게 고정시킨다.
    
//    viewNextBefore.frame = CGRectMake(0, appHeight - naviBarHeight - viewNextBefore.frame.size.height, appWidth, viewNextBefore.frame.size.height);
    
    [webViewQA_Question scrollView].bounces = FALSE;
//    webViewQA_Question.userInteractionEnabled = FALSE;
    [webViewQA_Question scrollView].showsHorizontalScrollIndicator  = FALSE;
    [webViewQA_Question scrollView].showsVerticalScrollIndicator = FALSE;
//    for (id subview in webViewQA_Question.subviews) {
//        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
//            ((UIScrollView *)subview).bounces = NO;
//            ((UIScrollView *)subview).showsVerticalScrollIndicator = NO;                
//            ((UIScrollView *)subview).showsHorizontalScrollIndicator = NO;                                
//        }
//    } 
//    [webViewQA_Question setScalesPageToFit:TRUE];
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 100];

    [webViewQA_Question stringByEvaluatingJavaScriptFromString:jsString];    
    
    
}

- (void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
    
    if (blnQAEnterWordDetail == TRUE) {
        if (intExamType == intExamType_WordAndMeaning) {
            for (NSInteger i = 0; i < [arrWrongAnswers count]; i++) {
                NSString *strWord = [[arrWrongAnswers objectAtIndex:i] objectForKey:@"Word"];            
                NSString    *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
                NSString    *strMeaning = [myCommon getMeaningFromTbl:strWordForSQL];
                
                NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
                [dicOne setValue:strWord forKey:@"Word"];
                [dicOne setValue:strMeaning forKey:@"Meaning"];            
                [arrWrongAnswers replaceObjectAtIndex:i withObject:dicOne];
            }
        }        
        [self openViewQA:nil];
        
//        [self btnQACommon];
        blnBtnAnswer1Clicked = FALSE;
        blnBtnAnswer2Clicked = FALSE;
        blnBtnAnswer3Clicked = FALSE;
        blnBtnAnswer4Clicked = FALSE;

        blnQAEnterWordDetail = FALSE;
    }
    
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText WordBlank:(NSString*)strWordBlank
{
    //    DLog(@"time : %@",[myCommon getCurrentDatAndTimeForBackup]);
	NSString *header;
    //	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath]];
    
	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css?time=%@\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], [myCommon getCurrentDatAndTimeForBackup]];
    //	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css?version=%d\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], intCSSVersion];
    
    //    DLog(@"originalText : %@", originalText);
    
    //    [htmlString stringByReplacingOccurrencesOfString:@"style.css" withString:[NSString stringWithFormat:@"style.css?time=%@", [[NSDate date] description]]
    
    
	//header = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<style type=\"text/css\">body {font-size:12pt;font-weight:normal} font.GREEN { display:inline; background:red;font-size : 12pt; font-weight : normal; color : green;vertical-align:sup }	font.BLUE {display:inline; background:yellow ;font-size : 12pt;font-weight : normal;color : blue; vertical-align:sup} font.RED { font-size : 12pt; font-weight : normal; color : red; vertical-align:sup}  </style>\n<title></title>\n</head>\n\n<body>\n<p>\n";			
	
	NSRange fullRange = NSMakeRange(0, [originalText length]);
    //    DLog(@"[originalText ] : %@", originalText);
    //	DLog(@"fullRange : %@", fullRange);
    
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
    i = [originalText replaceOccurrencesOfString:@"\r\n\r\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    
    // Argh, bloody MS line breaks!  Change them to UNIX, then...
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d carriage return/newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);    
    //Change newlines to </p><p>.
    i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    //Change double-newlines to </p><p>.
    i = [originalText replaceOccurrencesOfString:@"\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);    
    // And just in case someone has a Classic MacOS textfile...
    i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-carriage-returns\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);        
    // Lots of text files start new paragraphs with newline-space-space or newline-tab
    i = [originalText replaceOccurrencesOfString:@"\n  " withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-spaces\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-spaces\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    //\r일경우...
    i = [originalText replaceOccurrencesOfString:@"\r" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    
//    i = [originalText replaceOccurrencesOfString:@"\r\n\r\n" withString:@"<br>"
//                                         options:NSLiteralSearch range:fullRange];
//    
//    // Argh, bloody MS line breaks!  Change them to UNIX, then...
//    i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@"<br>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d carriage return/newlines\n", i);
//    j += i;
//    fullRange = NSMakeRange(0, [originalText length]);
//    
//    //Change newlines to </p><p>.
//    i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@"</p>\n<p>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d double-newlines\n", i);
//    j += i;
//    fullRange = NSMakeRange(0, [originalText length]);
//    
//    //Change double-newlines to </p><p>.
//    i = [originalText replaceOccurrencesOfString:@"\n" withString:@"</p>\n<p>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d double-newlines\n", i);
//    j += i;
//    fullRange = NSMakeRange(0, [originalText length]);
//    
//    // And just in case someone has a Classic MacOS textfile...
//    i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@"</p>\n<p>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d double-carriage-returns\n", i);
//    j += i;
//    
//    // Lots of text files start new paragraphs with newline-space-space or newline-tab
//    i = [originalText replaceOccurrencesOfString:@"\n  " withString:@"</p>\n<p>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d double-spaces\n", i);
//    j += i;
//    fullRange = NSMakeRange(0, [originalText length]);
//    
//    i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@"</p>\n<p>"
//                                         options:NSLiteralSearch range:fullRange];
//    //DLog(@"replaced %d double-spaces\n", i);
//    j += i;
//    fullRange = NSMakeRange(0, [originalText length]);
//    
//    //\r일경우...
//    i = [originalText replaceOccurrencesOfString:@"\r" withString:@"<br>"
//                                         options:NSLiteralSearch range:fullRange];
    j += i;
    
    if ([strWordBlank isEqualToString:@""] == FALSE) {
        NSString *strValueToChange1 = [NSString stringWithFormat:@"<span style=\"BORDER-BOTTOM:black 2px solid;BORDER-TOP:black 2px solid;BORDER-RIGHT:black 2px solid;BORDER-LEFT:black 2px solid\"> <span style=\"opacity:.0; color:blue\">"];
        NSString *strValueToChange2 = [NSString stringWithFormat:@"</span></span>"];
        
        NSError *err;
        NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordBlank] options:NSRegularExpressionCaseInsensitive error:&err];

            [regEx2 replaceMatchesInString:originalText options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [originalText length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]]; 
    } else {
        originalText = [NSMutableString stringWithFormat:@"<div style='text-align:center'>%@</div>", originalText];
    }
    NSMutableString *outputHTMLImsi = [NSMutableString stringWithFormat:@"%@%@\n</body>\n</html>\n", header, originalText];
//    NSRange fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
//	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br><br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
//    fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
//	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
    
    NSString *outputHTML = [NSString stringWithFormat:@"%@", outputHTMLImsi];
    
  
    DLog(@"outputHTML : %@", outputHTML);
	return outputHTML;  
}
//==============================================

//- (NSString*) getSentenceWithWord:(NSString*)strWord  //:(NSTimer*)sender
//{
//    //    NSString *strSearchWordTemp = [myCommon getCleanAndLowercase:searchBarSearchWord.text];
//    
//    DLog(@"strWord : %@", strWord);
//    DLog(@"_strFullFileContents : %@", _strFullFileContents);
//   NSRegularExpressionOptions nsOpt = NSRegularExpressionCaseInsensitive; 
//
//    NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWord] options:nsOpt error:nil];
//    NSArray *matches = [regEx matchesInString:_strFullFileContents
//                                      options:0
//                                        range:NSMakeRange(0, [_strFullFileContents length])];            
//    
//    NSInteger intRandom = 0;
//    NSTextCheckingResult *matchOne = [matches objectAtIndex:intRandom];
//    NSRange matchRange = [matchOne range];
//    NSInteger startSentence = matchRange.location - 60; 
//    while (startSentence--) {
//        if (startSentence < 0) {
//            startSentence = 0;
//            break;
//        }
//        NSString *strChar = [_strFullFileContents substringWithRange:NSMakeRange(startSentence, 1)];
//        //                    DLog(@"strChar : %@", strChar);
//        if ( ([strChar isEqualToString:@" "]) || ([strChar isEqualToString:@"\r"]) || ([strChar isEqualToString:@"\n"]) || ([strChar isEqualToString:@"\r\n"]) ) {
//            break;
//        }                    
//        
//    }
//    NSInteger lengthSentence = 120;                
//    if ((startSentence + lengthSentence) > [_strFullFileContents length]) {
//        lengthSentence = [_strFullFileContents length] - startSentence;
//        //                    DLog(@"lengthSentence : %d", lengthSentence);
//    }
//    
//    NSString *strSentence = [_strFullFileContents substringWithRange:NSMakeRange(startSentence, lengthSentence)];
//    return strSentence;
//}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //시험문제를 다 풀었을때
	if (alertView.tag == 1) {
        //새로운 문제를 눌렀을때...        
        if (buttonIndex == 1) {
            intExamType = intExamType_WordAndMeaning;
            blnQAEnterWordDetail = FALSE;
            intCurrNoOfExam = -1;
            self.arrWordListForExam = [myCommon getWordListForExam:intMaxNoOfExam];
            self._arrPastQuestions = [[NSMutableArray alloc] initWithCapacity:intMaxNoOfExam];            
            intExamType = intExamType_BlankInSentence;
            [self showNextExam];
        } else if (buttonIndex == 2) {
            //기존문제를 전부 다 다시 풀때
            intCurrNoOfExam = -1;
            [self showNextExam];
        } else if (buttonIndex == 3) {
            //기존문제에서 틀린것만 풀때
            blnRetryWithWrongAnswers = TRUE;
            intCurrNoOfExam = -1;
            [self showNextExam];            
        }
    }
}


#pragma mark -
#pragma mark 단어 퀴즈모드
-(IBAction) showNextExam
{
    DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);
    DLog(@"[arrWordListForExam count] : %d", [arrWordListForExam count]);
    DLog(@"intMaxNoOfExam : %d", intMaxNoOfExam);
    if ((intCurrNoOfExam >= -1)) {
        DLog(@"1");
    }
    if (intCurrNoOfExam < [arrWordListForExam count]) {
        DLog(@"2");
    }

    if (intCurrNoOfExam < intMaxNoOfExam) {
        DLog(@"3");
    }

        
    
    if ( (intCurrNoOfExam >= -1) && (intCurrNoOfExam < (intMaxNoOfExam - 1)) ) {
        intCurrNoOfExam++;
        //틀린문제만 다시 풀때
        if (blnRetryWithWrongAnswers == TRUE) {
            DLog(@"_arrPastQuestions : %@", _arrPastQuestions);
            DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);
            for (NSInteger i = intCurrNoOfExam; i < intMaxNoOfExam; i++) {
                DLog(@"i : %d", i);
                DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam); 
                DLog(@"[_arrPastQuestions count] : %d", [_arrPastQuestions count]);
                NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:i];
                DLog(@"dicPastQuestion : %@", dicPastQuestion);
                
                NSInteger intCorrect = [[dicPastQuestion objectForKey:@"intCorrect"] integerValue];
                if (intCorrect == 0) {
                    intCurrNoOfExam = i;
                    break;
                }
                
            }
        }

        
        NSDictionary *dicOne = [arrWordListForExam objectAtIndex:intCurrNoOfExam];
        self._strWord = [dicOne objectForKey:@"Word"];
        DLog(@"dicOne : %@", dicOne);
//        DLog(@"_arrPastQuestions : %@", _arrPastQuestions);
//        DLog(@"_strFullFileContents : %@", _strFullFileContents);        
//        NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
//        self.arrWrongAnswers = [dicPastQuestion objectForKey:@"arrWrongAnswers"];
        if ([_arrPastQuestions count] <= intCurrNoOfExam) {            
            NSMutableDictionary *dicPastQuestion = [[NSMutableDictionary alloc] init];
            [dicPastQuestion setObject:_strWord forKey:@"Word"];
            NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
            if ((strMeaning == NULL) || ([strMeaning isEqualToString:@""] == TRUE) ) {
                intExamType = intExamType_BlankInSentence;
            } else {
                intExamType = (random() % (2-1+1)) + 1;    
            }
            
            DLog(@"intExamType : %d", intExamType);
            DLog(@"_strWord : %@", _strWord);
            [dicPastQuestion setObject:[NSNumber numberWithInt:intExamType] forKey:@"intExamType"];
            
            if (intExamType == intExamType_WordAndMeaning) {
                NSMutableString *strMutWord = [NSMutableString stringWithString:_strWord];   
                NSString *strSentenceResult = [self HTMLFromTextStringPage:strMutWord WordBlank:@""];
                [dicPastQuestion setObject:strSentenceResult forKey:@"Question"];
                [webViewQA_Question loadHTMLString:strSentenceResult baseURL:nil];
    //            if ([strQABeforeWord isEqualToString:_strWord] == FALSE)  {
    //                self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];            
    //                self.arrWrongAnswers = [myCommon getWrongWordListForExam:_strWord];            
    //            }
            } else if (intExamType == intExamType_BlankInSentence) {
                NSMutableString *strSentence = [NSMutableString stringWithString:[myCommon getSentenceWithWord:_strWord strFullContents:_strFullFileContents]];
                NSString *strSentenceResult = [self HTMLFromTextStringPage:strSentence WordBlank:_strWord];
                [dicPastQuestion setObject:strSentenceResult forKey:@"Question"];
                [webViewQA_Question loadHTMLString:strSentenceResult baseURL:nil];
    //            if ([strQABeforeWord isEqualToString:_strWord] == FALSE)  {
    //                self.arrWrongAnswers = [myCommon getWrongWordListForExam:_strWord];            
    //            }

            }
            [_arrPastQuestions addObject:dicPastQuestion];
        } else {
            NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
            DLog(@"dicPastQuestion : %@", dicPastQuestion);
            self._strWord = [dicPastQuestion objectForKey:@"Word"];
            NSString *strSentenceResult = [dicPastQuestion objectForKey:@"Question"];
            [webViewQA_Question loadHTMLString:strSentenceResult baseURL:nil];
            intExamType = [[dicPastQuestion objectForKey:@"intExamType"] integerValue];
        }
        
        //플래쉬카드가 옆으로 옮겨진다.
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.5f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];        
        [ani setType:kCATransitionPush];
        
        [ani setSubtype:kCATransitionFromRight];
        
        [[viewQA layer] addAnimation:ani forKey:@"transitionViewAnimation"]; 
        
        [self openViewQA:nil];
        DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);
        self.lblPage.text = [NSString stringWithFormat:@"%d/%d", intCurrNoOfExam+1, intMaxNoOfExam];
//        intCurrNoOfExam++;
    } else {
        blnFinishExam = TRUE;
        blnRetryWithWrongAnswers = FALSE;
        DLog(@"_arrPastQuestions : %@", _arrPastQuestions);

        NSInteger cntOfWrongAnswers = 0;
        for (NSInteger i = 0; i < [_arrPastQuestions count]; i++) {
            NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:i];
            DLog(@"dicPastQuestion : %@", dicPastQuestion);
            
            NSInteger intCorrect = [[dicPastQuestion objectForKey:@"intCorrect"] integerValue];
            if (intCorrect == 0) {
                cntOfWrongAnswers++;
            }
        }
        DLog(@"intMaxNoOfExam : %d", intMaxNoOfExam);
        DLog(@"cntOfWrongAnswers : %d", cntOfWrongAnswers);
        
        NSInteger scoreOfAnswers = ((float)(intMaxNoOfExam - cntOfWrongAnswers)/intMaxNoOfExam)*100;
        DLog(@"scoreOfAnswers : %d", scoreOfAnswers);
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: NSLocalizedString(@"SCORE : %d", @""), scoreOfAnswers] message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Close", @"") otherButtonTitles:NSLocalizedString(@"New Questions", @""), NSLocalizedString(@"Retry All", @""), NSLocalizedString(@"Retry wrong answers only", @""), nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: NSLocalizedString(@"SCORE : %d", @""), scoreOfAnswers] message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Close", @"") otherButtonTitles:NSLocalizedString(@"New Questions", @""), nil];
        alertView.tag = 1;
        [alertView show];
    }
}

-(IBAction) showBeforeExam
{
    DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);
    DLog(@"[arrWordListForExam count] : %d", [arrWordListForExam count]);
    DLog(@"intMaxNoOfExam : %d", intMaxNoOfExam);

    
    if ( ((intCurrNoOfExam - 1) >= 0)  && (intCurrNoOfExam < intMaxNoOfExam) ) {
        intCurrNoOfExam--;
        
        //틀린문제만 다시 풀때
        if (blnRetryWithWrongAnswers == TRUE) {
            for (NSInteger i = intCurrNoOfExam; i >= 0; i--) {
                NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:i];
                DLog(@"dicPastQuestion : %@", dicPastQuestion);
                
                NSInteger intCorrect = [[dicPastQuestion objectForKey:@"intCorrect"] integerValue];
                if (intCorrect == 1) {
                    intCurrNoOfExam = i;
                    break;
                }
                
            }
        }
        
        DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);
        DLog(@"_arrPastQuestions : %@", _arrPastQuestions);
        NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
        DLog(@"dicPastQuestion : %@", dicPastQuestion);
        self._strWord = [dicPastQuestion objectForKey:@"Word"];
        NSString *strSentenceResult = [dicPastQuestion objectForKey:@"Question"];
        [webViewQA_Question loadHTMLString:strSentenceResult baseURL:nil];
        intExamType = [[dicPastQuestion objectForKey:@"intExamType"] integerValue];
                                    
//                                       
//                                       
//        
//        NSDictionary *dicOne = [arrWordListForExam objectAtIndex:intCurrNoOfExam-1];
//        self._strWord = [dicOne objectForKey:@"Word"];
//
//        
//        
//        intExamType = (random() % (2-1+1)) + 1;
//        DLog(@"intExamType : %d", intExamType);
//
//        
//        if (intExamType == intExamType_WordAndMeaning) {
//            NSMutableString *strMutWord = [NSMutableString stringWithString:_strWord];
//            [webViewQA_Question loadHTMLString:[self HTMLFromTextStringPage:strMutWord WordBlank:@""] baseURL:nil];
//        } else if (intExamType == intExamType_BlankInSentence) {
//            NSMutableString *strSentence = [NSMutableString stringWithString:[self getSentenceWithWord:_strWord]];
//            NSString *strSentenceResult = [self HTMLFromTextStringPage:strSentence WordBlank:_strWord];
//            [webViewQA_Question loadHTMLString:strSentenceResult baseURL:nil];
//        }

        //플래쉬카드가 옆으로 옮겨진다.
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.5f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [ani setType:kCATransitionPush];
        
        [ani setSubtype:kCATransitionFromLeft];
        
        [[viewQA layer] addAnimation:ani forKey:@"transitionViewAnimation"]; 
        
        [self openViewQA:nil];
        
        DLog(@"intCurrNoOfExam : %d", intCurrNoOfExam);        
        self.lblPage.text = [NSString stringWithFormat:@"%d/%d", intCurrNoOfExam+1, intMaxNoOfExam];
//        intCurrNoOfExam--;            
    }

}


- (IBAction) openViewQA:(id)sender
{
    blnAnswerd = FALSE;
    intWrongAnswer = -1;
    NSString *strMeaning = [myCommon getMeaningFromTbl:_strWord];
    NSString *strCopyWordOri = [myCommon GetOriWordOnlyIfExistInTbl:_strWord];
    
    DLog(@"strMeaning : %@", strMeaning);
    DLog(@"_strWord : %@", _strWord);
    DLog(@"strQABeforeWord : %@", strQABeforeWord);

    //뜻이 없고 지금 단어가 원형이 아니면... 원형으로 부터 뜻을 가져온다.
    if (([strMeaning isEqualToString:@""] == TRUE) && ([[strCopyWordOri lowercaseString] isEqualToString:[_strWord lowercaseString]] == FALSE)) {		
        strMeaning = [myCommon getMeaningFromTbl:strCopyWordOri];
    }
    
//    if ([strMeaning isEqualToString:@""]) {
//        return;
//    }
    
    NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
    self.arrWrongAnswers = [dicPastQuestion objectForKey:@"arrWrongAnswers"];
    if (arrWrongAnswers == NULL) {
        //1~4사이의 난수 생성
        srandom(time(NULL));
        intAnswer = (random() % (4-1+1)) + 1;
        DLog(@"intAnswer : %d", intAnswer);
        btnQA_Answer1.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer2.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer3.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnQA_Answer4.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (intExamType == intExamType_WordAndMeaning) {
            self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];            
        } else if (intExamType == intExamType_BlankInSentence) {
            self.arrWrongAnswers = [myCommon getWrongWordListForExam:_strWord];            
        } else {
            self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];
        }
        DLog(@"arrWrongAnswers : %@", arrWrongAnswers);
        [dicPastQuestion setObject:[NSNumber numberWithInt:intAnswer] forKey:@"intAnswer"];
        [dicPastQuestion setObject:arrWrongAnswers forKey:@"arrWrongAnswers"];        
        [dicPastQuestion setObject:[NSNumber numberWithInt:0] forKey:@"intCorrect"];    //첨에는 틀린걸로 하고 맞출때 맞는걸로 한다.(스킵시는 툴린걸로 할려구)
        [_arrPastQuestions replaceObjectAtIndex:intCurrNoOfExam withObject:dicPastQuestion];
        DLog(@"_arrPastQuestions : %@", _arrPastQuestions);
    } else {
//        NSMutableDictionary *dicPastQuestion = [_arrPastQuestions objectAtIndex:(intCurrNoOfExam - 1)];
        intAnswer = [[dicPastQuestion objectForKey:@"intAnswer"] integerValue];
//        self.arrWrongAnswers = [dicPastQuestion objectForKey:@"arrWrongAnswers"];
    }
    
//    if ([strQABeforeWord isEqualToString:_strWord] == FALSE)  {
////        self.txtViewQA_Question.text = [NSString stringWithFormat:@"\n%@", _strWord];    
//        //1~4사이의 난수 생성
//        srandom(time(NULL));
//        intAnswer = (random() % (4-1+1)) + 1;
//        btnQA_Answer1.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btnQA_Answer2.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btnQA_Answer3.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btnQA_Answer4.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        if (intExamType == intExamType_WordAndMeaning) {
//            self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];            
//        } else if (intExamType == intExamType_BlankInSentence) {
//            self.arrWrongAnswers = [myCommon getWrongWordListForExam:_strWord];            
//        } else {
//            self.arrWrongAnswers = [myCommon getMeaningsForQA:strMeaning];
//        }
//
//    }
    
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

    DLog(@"arrWrongAnswers : %@", arrWrongAnswers);
    if (intExamType == intExamType_WordAndMeaning) {        
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
    } else if (intExamType == intExamType_BlankInSentence) {
        if (intAnswer == 1) {
            [btnQA_Answer1 setTitle:_strWord forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:[arrWrongAnswers objectAtIndex:0] forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:[arrWrongAnswers objectAtIndex:1] forState:UIControlStateNormal];
            [btnQA_Answer4 setTitle:[arrWrongAnswers objectAtIndex:2] forState:UIControlStateNormal];
        } else if (intAnswer == 2) {
            [btnQA_Answer1 setTitle:[arrWrongAnswers objectAtIndex:0] forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:_strWord forState:UIControlStateNormal];            
            [btnQA_Answer3 setTitle:[arrWrongAnswers objectAtIndex:1] forState:UIControlStateNormal];
            [btnQA_Answer4 setTitle:[arrWrongAnswers objectAtIndex:2] forState:UIControlStateNormal];
        } else if (intAnswer == 3) {
            [btnQA_Answer1 setTitle:[arrWrongAnswers objectAtIndex:0] forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:[arrWrongAnswers objectAtIndex:1] forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:_strWord forState:UIControlStateNormal];            
            [btnQA_Answer4 setTitle:[arrWrongAnswers objectAtIndex:2] forState:UIControlStateNormal];
        } else if (intAnswer == 4) {     
            [btnQA_Answer1 setTitle:[arrWrongAnswers objectAtIndex:0] forState:UIControlStateNormal];
            [btnQA_Answer2 setTitle:[arrWrongAnswers objectAtIndex:1] forState:UIControlStateNormal];
            [btnQA_Answer3 setTitle:[arrWrongAnswers objectAtIndex:2] forState:UIControlStateNormal];            
            [btnQA_Answer4 setTitle:_strWord forState:UIControlStateNormal];            
        }
    }

       
    self.strQABeforeWord = [NSString stringWithFormat:@"%@", _strWord];
}

- (void) onBtnQA_Vibration
{
    if (blnOnQA_Vibration == TRUE) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
    
}
- (IBAction) onBtnQA_Answer1
{
    //    [btnQA_Answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];
        
        NSMutableDictionary *dicPastQuestion;
        if ([_arrPastQuestions count]) {
            dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam]; 
        }else{
            [SVProgressHUD showErrorWithStatus:@"No past question available"];
            return;
        }
         
        NSInteger intCorrect = 0;
        if (intAnswer != 1) {
            [btnQA_Answer1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
            [self answerCorrectOrNot:FALSE];
        } else {
            intCorrect = 1;
            [self answerCorrectOrNot:TRUE];
        }
        [dicPastQuestion setObject:[NSNumber numberWithInt:intCorrect] forKey:@"intCorrect"];
        [_arrPastQuestions replaceObjectAtIndex:intCurrNoOfExam withObject:dicPastQuestion];
        
        blnAnswerd = TRUE;
    } else {
//        intWrongAnswer = 1;
//        if (intAnswer == intWrongAnswer) {
//            intWrongAnswer = -1;
//        }
        
        
        NSString *strWordTemp = _strWord;
        
        DLog(@"strWordTemp : %@", strWordTemp);
        DLog(@"[arrWrongAnswers objectAtIndex:0] : %@", [arrWrongAnswers objectAtIndex:0]);
        DLog(@"intAnswer : %d", intAnswer);
        
//        if (intExamType == intExamType_WordAndMeaning) {
//            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
//            if (intAnswer == 1) {
//                blnBtnAnswer1Clicked = TRUE;
//                strWordTemp = [NSString stringWithString:_strWord];
//            } else {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:0]  objectForKey:KEY_DIC_WORD];                              
//            }
//        } else if (intExamType == intExamType_BlankInSentence) {
//
//            
//            if (intAnswer == 1) {
//                strWordTemp = [NSString stringWithString:_strWord];
//            } else {
//                strWordTemp = [arrWrongAnswers objectAtIndex:0];                
//            }            
//        }
        if (intAnswer == 1) {
            blnBtnAnswer1Clicked = TRUE;
            strWordTemp = [NSString stringWithString:_strWord];
            
        } else if (intAnswer == 2) {
             if (intExamType == intExamType_WordAndMeaning) {
                NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
                 strWordTemp = [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_WORD];
    //            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
             } else if (intExamType == intExamType_BlankInSentence) {
                 strWordTemp = [arrWrongAnswers objectAtIndex:0];
             }
            
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 3) {
            if (intExamType == intExamType_WordAndMeaning) {
                NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
                strWordTemp = [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_WORD]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:0];
            }
                       
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 4) {
             if (intExamType == intExamType_WordAndMeaning) {            
                 NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
                 strWordTemp = [[arrWrongAnswers objectAtIndex:0]  objectForKey:KEY_DIC_WORD];
             } else if (intExamType == intExamType_BlankInSentence) {
                 strWordTemp = [arrWrongAnswers objectAtIndex:0];
             }
                        
//            [self answerCorrectOrNot:FALSE];
        }
        

        
        DLog(@"blnBtnAnswer1Clicked : %d", blnBtnAnswer1Clicked);
         DLog(@"strWordTemp : %@", strWordTemp);
        if (intExamType == intExamType_WordAndMeaning) {
            //intExamType_WordAndMeaning일때는 뜻을 먼저 한번 보여주고 그다음에 또 눌렀을때 wordDetal로 간다.
            if (blnBtnAnswer1Clicked == TRUE) {
               
                WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
                wordDetail._strWord = strWordTemp;
                wordDetail._strWordFirst = strWordTemp;
                //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
                [self.navigationController pushViewController:wordDetail animated:YES];
                blnBtnAnswer1Clicked = FALSE;
                blnQAEnterWordDetail = TRUE;            
            } else {
                blnBtnAnswer1Clicked = TRUE;
            }
        }else if (intExamType == intExamType_BlankInSentence) {
            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
        }
    }     
}

- (IBAction) onBtnQA_Answer2
{
    //    [btnQA_Answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (blnAnswerd == FALSE) {
        [self   btnQACommonBtnColor];
        [self btnQACommon];
        
        NSMutableDictionary *dicPastQuestion;
        if ([_arrPastQuestions count]) {
            dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
        }else{
            [SVProgressHUD showErrorWithStatus:@"No past question available"];
            return;
        }

        NSInteger intCorrect = 0;
        
        if (intAnswer != 2) {
            [btnQA_Answer2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
            [self answerCorrectOrNot:FALSE];
        } else {
            intCorrect = 1;
            [self answerCorrectOrNot:TRUE];
        }
        [dicPastQuestion setObject:[NSNumber numberWithInt:intCorrect] forKey:@"intCorrect"];
        [_arrPastQuestions replaceObjectAtIndex:intCurrNoOfExam withObject:dicPastQuestion];

        blnAnswerd = TRUE;
    } else {
//        intWrongAnswer = 2;
//        if (intAnswer == intWrongAnswer) {
//            intWrongAnswer = -1;
//        }
        
                
        NSString *strWordTemp = _strWord;
        
//        if (intExamType == intExamType_WordAndMeaning) {
//            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
//            if (intAnswer == 1) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:0]  objectForKey:KEY_DIC_WORD];                                
//            } else if (intAnswer == 2) {
//                blnBtnAnswer1Clicked = TRUE;
//                strWordTemp = [NSString stringWithString:_strWord];
//            } else if (intAnswer == 3) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:1]  objectForKey:KEY_DIC_WORD];                
//            } else if (intAnswer == 4) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:1]  objectForKey:KEY_DIC_WORD];                
//            }
//        } else if (intExamType == intExamType_BlankInSentence) {
//            
//            if (intAnswer == 1) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:0];                
//            } else if (intAnswer == 2) {
//                strWordTemp = [NSString stringWithString:_strWord];                
//            } else if (intAnswer == 3) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:1];                
//            } else if (intAnswer == 4) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:1];                
//            }            
//        }
        
        if (intAnswer == 1) {
            if (intExamType == intExamType_WordAndMeaning) {
                strWordTemp = [[arrWrongAnswers objectAtIndex:0] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
                [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateNormal];
                [btnQA_Answer2 setTitle:strMeaning1 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:0];        
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 2) {
            blnBtnAnswer2Clicked = TRUE;
            strWordTemp = [NSString stringWithString:_strWord];
//            [self answerCorrectOrNot:TRUE];            
        } else if (intAnswer == 3) {
            if (intExamType == intExamType_WordAndMeaning) {
                strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
                [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:1];                
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 4) {
            if (intExamType == intExamType_WordAndMeaning) {
                strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateNormal];
                [btnQA_Answer2 setTitle:strMeaning2 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:1];            
            }
//            [self answerCorrectOrNot:FALSE];
        }

        
        if (intExamType == intExamType_WordAndMeaning) {
            //intExamType_WordAndMeaning일때는 뜻을 먼저 한번 보여주고 그다음에 또 눌렀을때 wordDetal로 간다.
            if (blnBtnAnswer2Clicked == TRUE) {
                WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
                wordDetail._strWord = strWordTemp;
                wordDetail._strWordFirst = strWordTemp;
                //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;            
                [self.navigationController pushViewController:wordDetail animated:YES];
                blnBtnAnswer2Clicked = FALSE;
                blnQAEnterWordDetail = TRUE;            
            } else {
                blnBtnAnswer2Clicked = TRUE;
            }   
        }else if (intExamType == intExamType_BlankInSentence) {
            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
        }
    }          
}

- (IBAction) onBtnQA_Answer3
{
    //    [btnQA_Answer1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [btnQA_Answer4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];    
        NSMutableDictionary *dicPastQuestion;
        if ([_arrPastQuestions count]) {
            dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
        }else{
            [SVProgressHUD showErrorWithStatus:@"No past question available"];
            return;
        }
        NSInteger intCorrect = 0;
        
        if (intAnswer != 3) {
            [btnQA_Answer3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
            [self answerCorrectOrNot:FALSE];
        } else {
            intCorrect = 1;
            [self answerCorrectOrNot:TRUE];
        }
        [dicPastQuestion setObject:[NSNumber numberWithInt:intCorrect] forKey:@"intCorrect"];
        [_arrPastQuestions replaceObjectAtIndex:intCurrNoOfExam withObject:dicPastQuestion];

        blnAnswerd = TRUE;
    } else {
//        intWrongAnswer = 3;
//        if (intAnswer == intWrongAnswer) {
//            intWrongAnswer = -1;
//        }

        
        NSString *strWordTemp = _strWord;
//        if (intExamType == intExamType_WordAndMeaning) {
//            if (intAnswer == 1) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:1]  objectForKey:KEY_DIC_WORD];                
//                NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"],     [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];                
//                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
//                [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected];                 
//            } else if (intAnswer == 2) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:1]  objectForKey:KEY_DIC_WORD];                
//                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
//                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected];
//            } else if (intAnswer == 3) {
//                blnBtnAnswer1Clicked = TRUE;
//                strWordTemp = [NSString stringWithString:_strWord];
//            } else if (intAnswer == 4) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:2]  objectForKey:KEY_DIC_WORD];                
//            }
//        } else if (intExamType == intExamType_BlankInSentence) {
//            
// 
//            
//            if (intAnswer == 1) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:1];   
//            } else if (intAnswer == 2) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:1];                
//            } else if (intAnswer == 3) {
//                strWordTemp = [NSString stringWithString:_strWord];                             
//            } else if (intAnswer == 4) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:2];                
//            }            
//        }
       
        if (intAnswer == 1) {
            if (intExamType == intExamType_WordAndMeaning) {            
                strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:1];        
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 2) {
            if (intExamType == intExamType_WordAndMeaning) {            
                strWordTemp = [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateNormal];
                [btnQA_Answer3 setTitle:strMeaning2 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:1];            
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 3) {
            blnBtnAnswer3Clicked = TRUE;
            strWordTemp = [NSString stringWithString:_strWord];
//            [self answerCorrectOrNot:TRUE];
        } else if (intAnswer == 4) {
            if (intExamType == intExamType_WordAndMeaning) {
                strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateNormal];
                [btnQA_Answer3 setTitle:strMeaning3 forState:UIControlStateSelected]; 
            } else if (intExamType == intExamType_BlankInSentence) {                
                strWordTemp = [arrWrongAnswers objectAtIndex:2];        
            }    
//            [self answerCorrectOrNot:FALSE];
        }
        
        if (intExamType == intExamType_WordAndMeaning) {
            //intExamType_WordAndMeaning일때는 뜻을 먼저 한번 보여주고 그다음에 또 눌렀을때 wordDetal로 간다.
            if (blnBtnAnswer3Clicked == TRUE) {
                WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
                wordDetail._strWord = strWordTemp;
                wordDetail._strWordFirst = strWordTemp;
                //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;            
                [self.navigationController pushViewController:wordDetail animated:YES];
                blnBtnAnswer3Clicked = FALSE;
                blnQAEnterWordDetail = TRUE;            
            } else {
                blnBtnAnswer3Clicked = TRUE;
            }
        }else if (intExamType == intExamType_BlankInSentence) {
            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
        }
    }          
}

- (IBAction) onBtnQA_Answer4
{
    if (blnAnswerd == FALSE) {
        [self btnQACommonBtnColor];
        [self btnQACommon];
        
        NSMutableDictionary *dicPastQuestion;
        if ([_arrPastQuestions count]) {
            dicPastQuestion = [_arrPastQuestions objectAtIndex:intCurrNoOfExam];
        }else{
            [SVProgressHUD showErrorWithStatus:@"No past question available"];
            return;
        }
        
        NSInteger intCorrect = 0;
        
        if (intAnswer != 4) {
            [btnQA_Answer4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self onBtnQA_Vibration];
            [self answerCorrectOrNot:FALSE];
        } else {
            intCorrect = 1;
            [self answerCorrectOrNot:TRUE];
        }
        [dicPastQuestion setObject:[NSNumber numberWithInt:intCorrect] forKey:@"intCorrect"];
        [_arrPastQuestions replaceObjectAtIndex:intCurrNoOfExam withObject:dicPastQuestion];

        blnAnswerd = TRUE;
    } else {
//        intWrongAnswer = 4;
//        if (intAnswer == intWrongAnswer) {
//            intWrongAnswer = -1;
//        }

        
        NSString *strWordTemp = _strWord;
//        if (intExamType == intExamType_WordAndMeaning) {
//            NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateNormal];
//            [btnQA_Answer1 setTitle:strMeaning1 forState:UIControlStateSelected]; 
//            if (intAnswer == 1) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:2]  objectForKey:KEY_DIC_WORD];                
//            } else if (intAnswer == 2) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:2]  objectForKey:KEY_DIC_WORD];                
//            } else if (intAnswer == 3) {
//                strWordTemp = [[arrWrongAnswers objectAtIndex:2]  objectForKey:KEY_DIC_WORD];                
//            } else if (intAnswer == 4) {
//                blnBtnAnswer1Clicked = TRUE;
//                strWordTemp = [NSString stringWithString:_strWord];
//
//            }
//        } else if (intExamType == intExamType_BlankInSentence) {
//
//            
//            if (intAnswer == 1) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:2]; 
//            } else if (intAnswer == 2) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:2];                
//            } else if (intAnswer == 3) {
//                strWordTemp = [arrWrongAnswers objectAtIndex:2];                
//            } else if (intAnswer == 4) {
//                strWordTemp = [NSString stringWithString:_strWord];                               
//            }            
//        }

        if (intAnswer == 1) {
            if (intExamType == intExamType_WordAndMeaning) {  
                strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:2];            
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 2) {
            if (intExamType == intExamType_WordAndMeaning) {
                strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:2];            
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 3) {
            if (intExamType == intExamType_WordAndMeaning) { 
                strWordTemp = [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_WORD];
                NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:KEY_DIC_MEANING]];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateNormal];
                [btnQA_Answer4 setTitle:strMeaning3 forState:UIControlStateSelected];
            } else if (intExamType == intExamType_BlankInSentence) {
                strWordTemp = [arrWrongAnswers objectAtIndex:2];            
            }
//            [self answerCorrectOrNot:FALSE];
        } else if (intAnswer == 4) {
            blnBtnAnswer4Clicked = TRUE;
            strWordTemp = [NSString stringWithString:_strWord];
//            [self answerCorrectOrNot:TRUE];
        }
        
        if (intExamType == intExamType_WordAndMeaning) {
            //intExamType_WordAndMeaning일때는 뜻을 먼저 한번 보여주고 그다음에 또 눌렀을때 wordDetal로 간다.
            if (blnBtnAnswer4Clicked == TRUE) {
                WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
                wordDetail._strWord = strWordTemp;
                wordDetail._strWordFirst = strWordTemp;
                //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
                [self.navigationController pushViewController:wordDetail animated:YES];
                blnBtnAnswer4Clicked = FALSE; 
                blnQAEnterWordDetail = TRUE;
            } else {
                blnBtnAnswer4Clicked = TRUE;    
            }
        }else if (intExamType == intExamType_BlankInSentence) {
            WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
            wordDetail._strWord = strWordTemp;
            wordDetail._strWordFirst = strWordTemp;
            //            wordDetail.dicWordsForQuiz = self.dicWordsForQuiz;
            [self.navigationController pushViewController:wordDetail animated:YES];
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
    
    NSString *strMeaning = [myCommon getMeaningFromTbl:_strWord];
    //    DLog(@"strMeaning : %@", strMeaning);
    //    DLog(@"strCopy : %@", strCopy);
    //    DLog(@"strCopyWordOri : %@", strCopyWordOri);
    //    //뜻이 없고 지금 단어가 원형이 아니면... 원형으로 부터 뜻을 가져온다.
    //	if (([strMeaning isEqualToString:@""] == TRUE) && ([strCopyWordOri isEqualToString:[strCopy lowercaseString]] == FALSE)) {		
    //		strMeaning = [myCommon getMeaningFromTbl:strCopyWordOri];
    //	}
    strMeaning = [NSString stringWithFormat:@"(O) %@", strMeaning];
    //    NSString *strMeaning1 = [NSString stringWithFormat:@"(X) %@ → %@",[[arrWrongAnswers objectAtIndex:0] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:0] objectForKey:@"Meaning"]];
    //    NSString *strMeaning2 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:1] objectForKey:@"Meaning"]];
    //    NSString *strMeaning3 = [NSString stringWithFormat:@"(X) %@ → %@", [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Word"], [[arrWrongAnswers objectAtIndex:2] objectForKey:@"Meaning"]];
    if (intExamType == intExamType_WordAndMeaning) {
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
        //        [self closeViewQA];
    }
}

- (void) answerCorrectOrNot:(BOOL)blnCorrect
{
    //저장했다는 뷰가 나타나고 자동으로 사라진다.
    [self.view bringSubviewToFront:viewAnswerCorrectOrNot];
    if (blnCorrect == TRUE) {
        lblAnswerCorrectOrNot.text = NSLocalizedString(@"Correct", @"");
        viewAnswerCorrectOrNot.backgroundColor = [UIColor greenColor];
        lblAnswerCorrectOrNot.textColor = [UIColor blackColor];
        
    } else {
        lblAnswerCorrectOrNot.text = NSLocalizedString(@"Wrong", @"");
        viewAnswerCorrectOrNot.backgroundColor = [UIColor redColor];
        lblAnswerCorrectOrNot.textColor = [UIColor whiteColor];
    }
    
    [self.view bringSubviewToFront:viewAnswerCorrectOrNot];
	[viewAnswerCorrectOrNot setAlpha:1.0f];
	[lblAnswerCorrectOrNot setAlpha:1.0f];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];	
	[viewAnswerCorrectOrNot setAlpha:0.99f];		
	[lblAnswerCorrectOrNot setAlpha:0.99f];
	[UIView commitAnimations];
    [viewAnswerCorrectOrNot setAlpha:0.0f];		
	[lblAnswerCorrectOrNot setAlpha:0.0f];
    //    [self.view sendSubviewToBack:viewAnswerCorrectOrNot];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
