//
//  WordSearchCell.m
//  Ready2Read
//
//  Created by KIM HyungDal on 11. 12. 10..
//  Copyright (c) 2011 dalnimSoft. All rights reserved.
//

#import "WordSearchCell.h"

@implementation WordSearchCell
@synthesize 	lblWord, lblPage, lblSentence, webOne;

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
