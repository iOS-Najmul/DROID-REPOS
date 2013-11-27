//
//  MakeABook.h
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 3. 4..
//  Copyright (c) 2012 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeABook : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITextView         *txtViewOne;
    UITextField                 *txtFldBookName;
    CGRect                  oriFrameOfTextView;
}
@property (nonatomic, strong) IBOutlet UITextView       *txtViewOne;
@property (nonatomic, strong) UITextField                 *txtFldBookName;
@property (nonatomic)     CGRect                  oriFrameOfTextView;

- (void) openMoviePlayerController:(NSString*)arrSender;

@end
