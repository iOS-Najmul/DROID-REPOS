//
//  BookSelectCell.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 1. 27..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookSelectCell : UITableViewCell {
	IBOutlet UIImageView	*imgBookCover;
    IBOutlet UIImageView    *imgBookLevel;
	IBOutlet UILabel* lblTitle;
	IBOutlet UILabel* lblAuthor;
	IBOutlet UILabel* lblGenre;
	IBOutlet UILabel* lblBookSize;
	IBOutlet UILabel* lblDifficult;
	IBOutlet UILabel* lblAllWordNo;
	IBOutlet UILabel* lblKnowWordNo;	
}
@property (nonatomic, strong) IBOutlet UIImageView* imgBookCover;
@property (nonatomic, strong) IBOutlet UIImageView    *imgBookLevel;
@property (nonatomic, strong) IBOutlet UILabel* lblTitle;
@property (nonatomic, strong) IBOutlet UILabel* lblAuthor;
@property (nonatomic, strong) IBOutlet UILabel* lblGenre;
@property (nonatomic, strong) IBOutlet UILabel* lblBookSize;
@property (nonatomic, strong) IBOutlet UILabel* lblDifficult;
@property (nonatomic, strong) IBOutlet UILabel* lblAllWordNo;
@property (nonatomic, strong) IBOutlet UILabel* lblKnowWordNo;

@end
