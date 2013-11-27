//
//  IdiomAndThemeCell.m
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 11. 25..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "IdiomAndThemeCell.h"

@implementation IdiomAndThemeCell

@synthesize lblProverb, lblMeaning, lblKnown;
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

@end
