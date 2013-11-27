//
//  DicListCellMark.m
//  Ready2Read
//
//  Created by HyungDal KIM on 11. 5. 11..
//  Copyright 2011 dalnimSoft. All rights reserved.
//

#import "DicListCellMark.h"


@implementation DicListCellMark
@synthesize lblWord, lblSentence, lblKnow;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
//        if (self.accessoryType == UITableViewCellAccessoryCheckmark) {
//            self.lblKnow.textAlignment = NSTextAlignmentLeft;
//        }else{
//            self.lblKnow.textAlignment = NSTextAlignmentRight;
//        }
        
        self.lblKnow.textAlignment = NSTextAlignmentCenter;
    }else{
        if (self.accessoryType == UITableViewCellAccessoryCheckmark) {
            self.lblKnow.textAlignment = NSTextAlignmentRight;
        }else{
            self.lblKnow.textAlignment = NSTextAlignmentLeft;
        }
    }

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
            
    // Highlighted - 빨간색    
    // Normal - 투명    
    [self setBackgroundColor:highlighted ? [UIColor redColor] : [UIColor clearColor]];    
    [self.textLabel setTextColor:highlighted ? [UIColor whiteColor] : [UIColor blackColor]];
}


@end
