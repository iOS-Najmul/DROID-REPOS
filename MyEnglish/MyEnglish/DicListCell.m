//
//  DicListCell.m
//  MyListPro
//
//  Created by 김형달 on 10. 11. 23..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import "DicListCell.h"


@implementation DicListCell
@synthesize lblWord, lblKnow, lblCount, lblPronounce, txtMeaning;//, segKnow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
#ifdef ENGLISH
    lblPronounce.hidden = TRUE;
#endif
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL) textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(IBAction) textFieldDoneEditing:(id)sender
{
	[sender resignFirstResponder];
}


@end
