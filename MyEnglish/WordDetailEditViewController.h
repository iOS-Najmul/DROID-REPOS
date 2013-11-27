//
//  WordDetailEditViewController.h
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 12. 8..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDetailEditViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UILabel            *lblWord;
    IBOutlet UILabel            *lblNameToEdit;
    IBOutlet UITextView         *txtToEdit;
    
    NSMutableArray              *_arrWords;
    NSString                    *_strWord;
    NSString                    *_strNameToEdit;
    NSString                    *_strToEdit;
}
@property (nonatomic, strong) IBOutlet  UILabel         *lblWord;
@property (nonatomic, strong) IBOutlet  UILabel         *lblNameToEdit;
@property (nonatomic, strong) IBOutlet  UITextView         *txtToEdit;


@property (nonatomic, strong)     NSMutableArray              *_arrWords;
@property (nonatomic, strong) NSString                    *_strWord;
@property (nonatomic, strong) NSString                    *_strNameToEdit;
@property (nonatomic, strong) NSString                    *_strToEdit;

@end
