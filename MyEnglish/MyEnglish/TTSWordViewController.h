//
//  TTSWordViewController.h
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 9. 20..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSWordViewController : UIViewController< UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITextView         *txtViewOne;
    IBOutlet UITableView        *tblOption;
    CGRect                  oriFrameOfTextView;
    
    NSString                        *strFullContents;
    NSInteger                       cntOfRepeatWord;
    NSInteger                       cntOfRepeatAlphbet;
    NSInteger                       cntOfRepeatMeaning;
    NSMutableDictionary             *dicWords;
    NSMutableArray             *arrWords;

    BOOL                            blnShowOption;
       
}
@property (nonatomic, strong) IBOutlet UITextView       *txtViewOne;
@property (nonatomic, strong)     IBOutlet UITableView        *tblOption;
@property (nonatomic)     CGRect                  oriFrameOfTextView;

@property (nonatomic)     NSInteger                       cntOfRepeatWord;
@property (nonatomic)     NSInteger                       cntOfRepeatAlphbet;
@property (nonatomic)     NSInteger                       cntOfRepeatMeaning;

@property (nonatomic, strong)     NSString                        *strFullContents;
@property (nonatomic, strong)     NSMutableArray             *arrWords;
@property (nonatomic, strong) NSMutableDictionary             *dicWords;

@property (nonatomic)  BOOL                            blnShowOption;


- (void) changeOption;
- (void) makeTextToSpeech;
- (void) onStepperOne:(id)sender;
@end
