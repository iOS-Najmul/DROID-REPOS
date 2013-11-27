//
//  FlashCardController.m
//  Ready2Read
//
//  Created by HyungDal KIM on 11. 8. 10..
//  Copyright 2011 dalnimSoft. All rights reserved.
//

#import "FlashCardController.h"
#import "myCommon.h"
#import "WordDetail.h"
#import "SVProgressHUD.h"

@implementation FlashCardController


@synthesize txtViewCardFront, lblPage;
@synthesize arrWordsList, curPage, AllPages, blnFrontPage;
@synthesize viewFlashCard, arrWordsListChanged;
@synthesize actionSheetProgress, progressViewInActionSheet, alertViewProgress;
@synthesize intBookTblNo, intDicListType, intDicWordOrIdiom, imgViewCard, intFlashCardType;
@synthesize viewQA, txtViewQA_Question, lblTestLevelCntOfQuestions, lblTestLevelCntOfKnown, lblTestLevelCntOfUnknown, lblTestLevelCntOfPercentage, btnQA_Answer1, btnQA_Answer2,btnQA_Answer3,btnQA_Answer4;

@synthesize viewTestLevel, imgViewTestLevel, txtViewTestLevelCardFront, btnTestLevel_Unknown, btnTestLevel_Known, intTestLevelKnownWords, intTestLevelUnknownWords, intTestLevelCntOfStraintUnknownWords, intTestLevelUserLevel;  

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setHidesBottomBarWhenPushed:TRUE];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    if (intFlashCardType == intFlashCardType_FlashCard) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveMark)];
        self.navigationItem.rightBarButtonItem = rightButton;

        blnFrontPage = TRUE;
        
        segConKnow.selectedSegmentIndex = -1;    
        for (NSMutableDictionary *dicOne in arrWordsList) {
            [dicOne setValue:[NSNumber numberWithInt:-1] forKey:KEY_DIC_KnowChanged]; 
        }
        
    //    DLog(@"arrWordsList : %@", arrWordsList);
        curPage = 0;
        AllPages = [arrWordsList count];
        [self writeContentOfPage:curPage];

        [segConKnow setTitle:NSLocalizedString(@"Dic", @"") forSegmentAtIndex:4];
        [self.view bringSubviewToFront:viewFlashCard];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        singleTap.delegate = self;
    //    [txtViewCardFront addGestureRecognizer:singleTap];
        [imgViewCard addGestureRecognizer:singleTap];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRight.delegate = self;
    //	[txtViewCardFront addGestureRecognizer:swipeRight];
        [imgViewCard addGestureRecognizer:swipeRight];
        
        
        self.viewFlashCard.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"FlashCard_Back_6.jpg"]];
        

        self.txtViewCardFront.backgroundColor = [UIColor clearColor];

        txtViewCardFront.frame = CGRectMake(imgViewCard.frame.size.width / 10, imgViewCard.frame.size.height / 6, txtViewCardFront.frame.size.width, txtViewCardFront.frame.size.height);
        [imgViewCard addSubview:txtViewCardFront];
        [imgViewCard sendSubviewToBack:txtViewCardFront];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeLeft.delegate = self;
    //	[txtViewCardFront addGestureRecognizer:swipeLeft];
        [imgViewCard    addGestureRecognizer:swipeLeft];

        UISwipeGestureRecognizer *swipeTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTopAction:)];
        swipeTop.direction = UISwipeGestureRecognizerDirectionUp;
        swipeTop.delegate = self;
    //	[txtViewCardFront addGestureRecognizer:swipeTop];
        [imgViewCard    addGestureRecognizer:swipeTop];
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownAction:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        swipeDown.delegate = self;
    //	[txtViewCardFront addGestureRecognizer:swipeDown];
        [imgViewCard addGestureRecognizer:swipeDown];
    } else if (intFlashCardType == intFlashCardType_TestLevel) {
        
//        blnFrontPage = TRUE;
        intTestLevelKnownWords = 0;
        intTestLevelUnknownWords = 0;
        intTestLevelCntOfStraintUnknownWords = 0;
        intTestLevelUserLevel = 1;
        
        for (NSMutableDictionary *dicOne in arrWordsList) {
            [dicOne setValue:[NSNumber numberWithInt:-1] forKey:KEY_DIC_KnowChanged]; 
        }
        
        curPage = 0;
        AllPages = [arrWordsList count];
    
        [self.view bringSubviewToFront:viewTestLevel];
//        viewTestLevel.hidden = NO;
        
        viewQA.hidden = TRUE;
        viewFlashCard.hidden = TRUE;
        
        self.viewTestLevel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"FlashCard_Back_6.jpg"]];
                
        self.txtViewTestLevelCardFront.backgroundColor = [UIColor clearColor];
        
        
    } else if (intFlashCardType == intFlashCardType_QA) {
        self.viewQA.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"FlashCard_Back_6.jpg"]];
        [self.view bringSubviewToFront:viewQA];
        txtViewQA_Question.text = [arrWordsList objectAtIndex:0];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableDictionary *dicPage = [arrWordsList objectAtIndex:curPage];
    
    NSString *strWord = @"";
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        strWord = [dicPage objectForKey:KEY_DIC_Idiom];
    } else {
        strWord = [dicPage objectForKey:@"Word"];
    }
    DLog(@"strWord : %@", strWord);
    DLog(@"dicPage : %@", dicPage);    
    if (intFlashCardType == intFlashCardType_FlashCard) {
         if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
         } else {
            NSMutableString		*strMeaning = [NSMutableString stringWithFormat:@""];
            NSMutableString		*strKnow = [NSMutableString stringWithFormat:@""];
            NSMutableString		*strLevel = [NSMutableString stringWithFormat:@""];
            NSMutableString		*strCount = [NSMutableString stringWithFormat:@""];
            NSMutableString		*wordOri = [NSMutableString stringWithFormat:@""];
            [myCommon GetDataFromTbl:strWord Meaning:strMeaning Know:strKnow Level:strLevel Count:strCount WordOri:wordOri];
            [dicPage setValue:strMeaning forKey:@"Meaning"];        
            NSInteger intKnow = [strKnow integerValue];
            [dicPage setObject:[NSNumber numberWithInt:intKnow] forKey:@"Know"];
         }
        [dicPage setObject:[NSNumber numberWithInt:-1] forKey:KEY_DIC_KnowChanged KEY_DIC_KnowChanged];
        DLog(@"dicPage : %@", dicPage);
             
        [self writeContentOfPage:curPage];
    } else if (intFlashCardType == intFlashCardType_TestLevel) {
   
        txtViewTestLevelCardFront.text = [NSString stringWithFormat:@"%@", strWord];
        
        lblTestLevelCntOfQuestions.text = [NSString stringWithFormat:@"%d/%d", curPage+1, AllPages];
        lblTestLevelCntOfKnown.text = @"0";
        lblTestLevelCntOfUnknown.text = @"0";        
        lblTestLevelCntOfPercentage.text = @"0 %";
    }
    clipboardContainer.center = self.view.center;
    clipboardContainerStudyWord.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) back 
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	//activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	aiv.center = self.view.center;
    [aiv startAnimating];
	[self.view addSubview:aiv];
    [self.view bringSubviewToFront:aiv];
    
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOpenWordDetail:(NSTimer *)sender
{
    
}

#pragma mark -
#pragma mark 단어 테스트 관련 함수

- (IBAction) ntBtnTestLevel_Unknown:(id)sender
{
    intTestLevelUnknownWords++;
    intTestLevelCntOfStraintUnknownWords++;
    
    lblTestLevelCntOfUnknown.text = [NSString stringWithFormat:@"%d", intTestLevelUnknownWords];
    
    [self nextQuestionInTestLevel:directionKnow_Unknown];    
}
- (IBAction) ntBtnTestLevel_Known:(id)sender
{
    intTestLevelCntOfStraintUnknownWords = 0;
    intTestLevelKnownWords++;    
    
    lblTestLevelCntOfKnown.text = [NSString stringWithFormat:@"%d", intTestLevelKnownWords];
    float fVal = ((float)intTestLevelKnownWords/AllPages)*100;
    DLog(@"fVal : %f", fVal);
    lblTestLevelCntOfPercentage.text = [NSString stringWithFormat:@"%.0f %%", fVal];
    [self nextQuestionInTestLevel:directionKnow_Known];
}


- (void) nextQuestionInTestLevel:(NSInteger)intDirection
{
    curPage++;
    
    if (curPage >= AllPages) {
        //마지막까지 했으면 수준을 알려주고 저장할지 물어본다.
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:NSLocalizedString(@"Test finish.\nDo you want to set your word level by the test?", @"")]  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];
        alert2.tag = 1;
        [alert2 show];
        return;
    } else {
        lblTestLevelCntOfQuestions.text = [NSString stringWithFormat:@"%d/%d", curPage, AllPages];
        NSMutableDictionary *dicPageCur = [arrWordsList objectAtIndex:curPage];
        NSString *strWordCur = [dicPageCur objectForKey:@"Word"];
        NSInteger intLevel = [[dicPageCur objectForKey:@"WordGroup"] integerValue]; 
        intTestLevelUserLevel = intLevel;        
        txtViewTestLevelCardFront.text = [NSString stringWithFormat:@"%@", strWordCur];
        if (intTestLevelCntOfStraintUnknownWords == 3) {
            //모르는 단어를 3개 연속으로 만나면 그만둘지 물어본다.
            
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:NSLocalizedString(@"You can't continue the test.\nDo you want to set your word level by the test?", @""), intLevel]  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""),nil];
            alert2.tag = 2;
            [alert2 show];
            return;
       }
        
        //단어의 아는정도가 나타나고 자동으로 사라진다.
        NSString *msg = NSLocalizedString(@"Next", @"");
        if (intDirection == directionKnow_Unknown) {
            msg = NSLocalizedString(@"X : Unknown", @"");
        } else if (intDirection == directionKnow_Known) {
            msg = NSLocalizedString(@"! : Known", @"");
        }
        
        [SVProgressHUD showImage:nil status:msg];
        
        //플래쉬카드가 옆으로 옮겨진다.
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.5f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [ani setType:kCATransitionPush];
        
        [ani setSubtype:kCATransitionFromRight];
        
        [[imgViewCard layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    }
}

- (void) saveUserLevel:(NSTimer*)sender
{
    //레벨에 해당되는 모든 단어와 발음을 KnowWord_Known 로 해준다.
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = %d WHERE (%@ >= 1) and (%@ <= %d)", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_Known, FldName_KnowPronounce, KnowWord_Known, FldName_TBL_EngDic_LEVEL, FldName_TBL_EngDic_LEVEL, intTestLevelUserLevel];
    [myCommon changeRec:strQuery openMyDic:TRUE];
    
    strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = %d",TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_Known];			
    NSInteger cntOfKnowWords = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
    
    [SVProgressHUD dismiss];
    
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:NSLocalizedString(@"Finishing setting your words.\nYou might know %@ words", @""), [myCommon GetFormattedNumber:cntOfKnowWords]]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert2 show];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:Did_UserLevelTest forKey:UserLevelTest];
    
    [self initWordTest];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {
        //단어 시험을 중단하였으면 현재 단어레벨을 저장한다.
        if (buttonIndex == 1) {
            
            [SVProgressHUD showProgress:-1 status:@""];
            [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                             target:self
                                           selector:@selector(saveUserLevel:)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            [self initWordTest];
        }
    } else if (alertView.tag == 2) {
        //단어 시험을 중단하였으면 현재 단어레벨을 저장한다.
        if (buttonIndex == 1) {
            
            [SVProgressHUD showProgress:-1 status:@""];
            [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                             target:self
                                           selector:@selector(saveUserLevel:)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            [self initWordTest];
        }
    }
}

- (void) initWordTest
{
    intTestLevelKnownWords = 0;
    intTestLevelUnknownWords = 0;
    intTestLevelCntOfStraintUnknownWords = 0;
    intTestLevelUserLevel = 1;
    
    for (NSMutableDictionary *dicOne in arrWordsList) {
        [dicOne setValue:[NSNumber numberWithInt:-1] forKey:KEY_DIC_KnowChanged]; 
    }
    
    curPage = 0;

    NSMutableDictionary *dicPage = [arrWordsList objectAtIndex:curPage];
    NSString *strWord = [dicPage objectForKey:@"Word"];   
    
    txtViewTestLevelCardFront.text = [NSString stringWithFormat:@"%@", strWord];
    lblTestLevelCntOfQuestions.text = [NSString stringWithFormat:@"%d/%d", curPage, AllPages];
    lblTestLevelCntOfKnown.text = @"0";
    lblTestLevelCntOfUnknown.text = @"0";        
    lblTestLevelCntOfPercentage.text = @"0 %";
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)swipeRightAction:(id)ignored
{
    if (curPage > 0) {
        blnFrontPage = TRUE;
        curPage--;
        [self writeContentOfPage:curPage];
        
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.5f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[ani setType:kCATransitionPush];
		[ani setSubtype:kCATransitionFromLeft];
		
		[[imgViewCard layer] addAnimation:ani forKey:@"transitionViewAnimation"];
    } else {
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"First Card.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
    }
}
- (void)swipeLeftAction:(id)ignored
{
    if (curPage < AllPages-1) {
        //다음플래쉬카드의 내용을 적는다.
        blnFrontPage = TRUE;        
        curPage++;
        [self writeContentOfPage:curPage];
        //플래쉬카드가 옆으로 옮겨진다.
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.5f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [ani setType:kCATransitionPush];
        
        [ani setSubtype:kCATransitionFromRight];
        
        [[imgViewCard layer] addAnimation:ani forKey:@"transitionViewAnimation"];   
    } else {
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Last Card.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
    }
}

- (void)swipeTopAction:(id)ignored
{
    [self nextPage:directionKnow_Unknown];    
}

- (void)swipeDownAction:(id)ignored
{
    [self nextPage:directionKnow_Known];    
}

- (void) nextPage:(NSInteger)intDirection
{
    if (curPage < AllPages) {
        //현재 플래쉬카드의 아는정도가 바뀌었으면 저장한다.
        NSMutableDictionary *dicPageCur = [arrWordsList objectAtIndex:curPage];
        NSString *strWordCur = [dicPageCur objectForKey:@"Word"];
//            NSInteger intKnow = [[myCommon getKnowFromTbl:strWord] integerValue];
        
        NSInteger intKnowFromDic = [[myCommon getKnowFromTbl:strWordCur] integerValue];
        NSInteger intKnowFromArray = [[dicPageCur objectForKey:@"Know"] integerValue];
        
        BOOL blnKnowChanged = FALSE;
        if (intKnowFromDic == intKnowFromArray) {
            if (intKnowFromDic < 1) {
                blnKnowChanged = TRUE;
            } else if ((intKnowFromDic == 1) && (intDirection != directionKnow_Unknown)) {
                blnKnowChanged = TRUE;            
            } else if ((intKnowFromDic == 2) && (intDirection != directionKnow_NotSure)) {
                blnKnowChanged = TRUE;            
            } else if ((intKnowFromDic == 3) && (intDirection != directionKnow_Known)) {
                blnKnowChanged = TRUE;            
            } else if ((intKnowFromDic > 3) && (intDirection != directionKnow_Exclude)) {
                    blnKnowChanged = TRUE;
            }
        } else {
            blnKnowChanged = TRUE;
        }
        DLog(@"intDirection : %d", intDirection);
        DLog(@"dicPageCur Before : %@", dicPageCur);
        if (blnKnowChanged == TRUE) {
            [dicPageCur setValue:[NSNumber numberWithInt:intDirection] forKey:KEY_DIC_KnowChanged];  
//            [dicPageCur setValue:[NSNumber numberWithInt:intDirection] forKey:@"Know"]; 
        }
        DLog(@"dicPageCur After : %@", dicPageCur);
        
        
        //단어의 아는정도가 나타나고 자동으로 사라진다.
        NSString *msg = NSLocalizedString(@"Next", @"");
        if (intDirection  < directionKnow_Unknown ) {
        } else if (intDirection == directionKnow_Unknown) {
            msg = NSLocalizedString(@"X : Unknown", @"");
        } else if (intDirection == directionKnow_NotSure) {
            msg = NSLocalizedString(@"? : Not Sure", @"");
        } else if (intDirection == directionKnow_Known) {
            msg = NSLocalizedString(@"! : Known", @"");
        } else if (intDirection > directionKnow_Known) {
            msg = NSLocalizedString(@"- : Exclude", @"");
        }
    
        [SVProgressHUD showImage:nil status:msg];
        
        if (curPage < (AllPages - 1)) {
            //마지막장이 아니면 다음플래쉬카드의 내용을 적는다.
            blnFrontPage = TRUE;        
            curPage++;
            [self writeContentOfPage:curPage];
            
            //플래쉬카드가 옆으로 옮겨진다.
            CATransition *ani = [CATransition animation];
            [ani setDelegate:self];
            [ani setDuration:0.5f];
            [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [ani setType:kCATransitionPush];
            [ani setSubtype:kCATransitionFromRight];
            
            [[imgViewCard layer] addAnimation:ani forKey:@"transitionViewAnimation"];
        } else {
            //마지막장은 현재장의 내용으로 적는다.
            blnFrontPage = TRUE;        
            [self writeContentOfPage:curPage];
        }
            
    }
}


- (void)tap:(UITapGestureRecognizer *)recognizer
{    
        CGPoint p = [recognizer locationInView:recognizer.view];
    DLog(@"Pnt : %@", [NSValue valueWithCGPoint:p]);
    NSDictionary *dicPage = [arrWordsList objectAtIndex:curPage];

    DLog(@"dicPage : %@", dicPage);
    blnFrontPage = !blnFrontPage;
    [self writeContentOfPage:curPage];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8f];
    if (blnFrontPage == TRUE) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imgViewCard cache:YES];
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.imgViewCard cache:YES];
    }
    [UIView commitAnimations];
}

- (IBAction) selSegConKnow
{
    NSInteger intKnow = segConKnow.selectedSegmentIndex + 1;
    DLog(@"intKnow : %d", intKnow);
    if (intKnow == 1) {
        [self nextPage:directionKnow_Unknown];
    } else if (intKnow == 2) {
        [self nextPage:directionKnow_NotSure];
    } else if (intKnow == 3) {
        [self nextPage:directionKnow_Known];
    } else if (intKnow == 4) {
        [self nextPage:directionKnow_Exclude];
    } else if (intKnow == 5) {
        [self onOpenWebDic:nil];
    }
}

- (void) onOpenWebDic:(id)sender
{
    NSDictionary *dicOne = [arrWordsList objectAtIndex:curPage];
    
    NSString *strWord = @"";
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        strWord = [dicOne objectForKey:KEY_DIC_Idiom];
    } else {
        strWord = [dicOne objectForKey:@"Word"];
    }
    if ([strWord length] > 0) {
        WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
        wordDetail.intDicWordOrIdiom = intDicWordOrIdiom;
        wordDetail._strWord = strWord;
        wordDetail._strWordFirst = strWord;
        wordDetail.strBookTblName = [NSString stringWithFormat:@"%@",  TBL_EngDic_BookTemp];
        wordDetail.intBookTblNo = intBookTblNo;
        [self.navigationController pushViewController:wordDetail animated:YES];				
    } else {
        
    }
}

#pragma mark -
#pragma mark 변경된 단어 저장
- (void) saveMark
{
    actionSheetProgress = [[UIActionSheet alloc] initWithTitle:@"Prepare to update Know...\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
	[actionSheetProgress showInView:self.view];
    float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
    progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, width-80, 20.0f)];
	[progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
	progressViewInActionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	[actionSheetProgress addSubview:progressViewInActionSheet];    
    UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 40.0f);
	[aiv1 startAnimating];
	[actionSheetProgress addSubview:aiv1];

    
    [NSThread detachNewThreadSelector:@selector(saveMarkOri:) toTarget:self withObject:nil];
}

- (void) saveMarkOri:(NSObject*)obj
{
    @autoreleasepool {

    NSInteger wordCnt = 0;
    [myCommon transactionBegin:TRUE];
    [myCommon transactionBegin:FALSE];
    for(NSDictionary *dicOne in arrWordsList) {
        NSString *strWord = [dicOne objectForKey:@"Word"];
        DLog(@"strWord : %@", strWord);
		float	fVal = wordCnt++ / ((float)[arrWordsList count]);
        NSString *strMsg = [NSString stringWithFormat:@"%@... %@", NSLocalizedString(@"Updating words", @""), [NSString stringWithFormat:@"%.1f%%", (fVal*100)]];
        [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:NO];
        
        NSInteger intKnowChanged = [[dicOne objectForKey:KEY_DIC_KnowChanged] integerValue];
        DLog(@"intKnowChanged : %d", intKnowChanged);
        if (intKnowChanged == -1) {
            DLog(@"continue");
            continue;
        }

        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
        NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[myCommon GetOriWordOnlyIfExistInTbl:strWord]];

        //해당 단어만 먼저 업데이트 한다.
        NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_Know, intKnowChanged, FldName_Word, strWordForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        if (intDicListType >= DicListType_TBL_EngDicEachBook) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_Know, intKnowChanged, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];
        }
        if (intDicListType >= DicListType_TBL_EngDicBookTemp) {
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic_BookTemp, FldName_Know, intKnowChanged, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
        
        if ([strWordOriForSQL isEqualToString:@""] == false ) {
            //원형이 있으면 원형을 가지고 업데이트한다. (이미 한것은 안한다. Know가 1보다 작은것을 한다.)
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0)", TBL_EngDic, FldName_Know, intKnowChanged, FldName_WORDORI, strWordOriForSQL, FldName_Know];
            [myCommon changeRec:strQuery openMyDic:TRUE];
            if (intDicListType >= DicListType_TBL_EngDicEachBook) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0)", TBL_EngDic, FldName_Know, intKnowChanged, FldName_WORDORI, strWordOriForSQL, FldName_Know];
                [myCommon changeRec:strQuery openMyDic:FALSE];
            }
            if (intDicListType >= DicListType_TBL_EngDicBookTemp) {
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@' and  (%@ = 0)", TBL_EngDic_BookTemp, FldName_Know, intKnowChanged, FldName_WORDORI, strWordOriForSQL, FldName_Know];
                [myCommon changeRec:strQuery openMyDic:TRUE];
            }
        }              
        
        //저장하면 Know를 KnowChanged로 바꾸어준다.
        [dicOne setValue:[NSNumber numberWithInt:intKnowChanged] forKey:@"Know"];
        //한번 저장하면 KnowChanged를 다시 -1로 해준다.
        [dicOne setValue:[NSNumber numberWithInt:-1] forKey:KEY_DIC_KnowChanged];
    }
    [myCommon transactionCommit:TRUE];
    [myCommon transactionCommit:FALSE];
    
    [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
    actionSheetProgress = nil;
	progressViewInActionSheet = nil;
    }
}

- (void) updateProgress:(NSNumber*) param  {
    progressViewInActionSheet.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	actionSheetProgress.title = [NSString stringWithFormat:@"%@\n\n",  param];
}


- (void) writeContentOfPage:(NSInteger)page
{
    NSMutableDictionary *dicPage = [arrWordsList objectAtIndex:curPage];
    DLog(@"arrWordsList : %@", arrWordsList);
    DLog(@"dicPage : %@", dicPage);
    NSInteger intKnow = [[dicPage objectForKey:@"Know"] integerValue];
    NSInteger intKnowChanged = [[dicPage objectForKey:KEY_DIC_KnowChanged] integerValue];  
    
    NSString *strKnow = [myCommon getStrKnowFromIntKnow:intKnow];
    if (intKnowChanged != -1) {
        strKnow = [myCommon getStrKnowFromIntKnow:intKnowChanged];
    }
    lblPage.text = [NSString stringWithFormat:@"%@ %d/%d", strKnow, curPage+1, AllPages];
    if (blnFrontPage == TRUE) {
        txtViewCardFront.font = [UIFont systemFontOfSize:24.0];
        if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
            txtViewCardFront.text = [NSString stringWithFormat:@"%@", [dicPage objectForKey:KEY_DIC_Idiom]];
        } else {
            txtViewCardFront.text = [NSString stringWithFormat:@"%@", [dicPage objectForKey:@"Word"]];
        }
    } else {
        NSString *strMeaning = [dicPage objectForKey:KEY_DIC_MEANING];
        NSString *strPronounce = [dicPage objectForKey:KEY_DIC_Pronounce];
        DLog(@"strMeaning : %@", strMeaning);

        DLog(@"strMeaning : %@", strMeaning);
        if ([strMeaning length] > 0) {
            txtViewCardFront.font = [UIFont systemFontOfSize:18.0];
            txtViewCardFront.text = [NSString stringWithFormat:@"%@", strMeaning];
        } else {
            txtViewCardFront.font = [UIFont italicSystemFontOfSize:18.0];
            txtViewCardFront.text = @"\n\nNo Meaning...";
        }
        
        //발음이 있으면 발음도 보여준다.
        if ( (strPronounce != NULL) && ([strPronounce isEqualToString:@""] == FALSE) ) {
            txtViewCardFront.text = [NSString stringWithFormat:@"%@\n%@", strPronounce, txtViewCardFront.text];
        }
    }    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end


