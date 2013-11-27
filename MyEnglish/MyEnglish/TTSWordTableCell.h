//
//  TTSWordTableCell.h
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 9. 21..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSWordTableCell : UITableViewCell
{
    IBOutlet UILabel        *lblTitle;
    IBOutlet UILabel        *lblRepeatTimes;
    IBOutlet UISwitch       *switchShow;
    IBOutlet UIStepper      *stepperOne;
}
@property (nonatomic, strong)     IBOutlet UILabel        *lblTitle;
@property (nonatomic, strong)     IBOutlet UILabel        *lblRepeatTimes;
@property (nonatomic, strong)     IBOutlet UISwitch       *switchShow;
@property (nonatomic, strong)     IBOutlet UIStepper      *stepperOne;

- (IBAction)valueChanged:(UIStepper *)sender;

@end
