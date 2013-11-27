//
//  TTSWordTableCell.m
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 9. 21..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "TTSWordTableCell.h"

@implementation TTSWordTableCell
@synthesize lblTitle, lblRepeatTimes, switchShow, stepperOne;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    
}

@end
