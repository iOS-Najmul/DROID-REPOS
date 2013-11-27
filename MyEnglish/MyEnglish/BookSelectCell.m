//
//  BookSelectCell.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 1. 27..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "BookSelectCell.h"


@implementation BookSelectCell
@synthesize imgBookCover, imgBookLevel, lblTitle, lblAuthor, lblGenre, lblBookSize,lblDifficult, lblAllWordNo, lblKnowWordNo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}





@end
