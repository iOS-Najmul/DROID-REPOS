//
//  DicListCellMark.h
//  Ready2Read
//
//  Created by HyungDal KIM on 11. 5. 11..
//  Copyright 2011 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DicListCellMark : UITableViewCell {
	IBOutlet UILabel* lblWord;
	IBOutlet UILabel* lblSentence;    
	IBOutlet UILabel* lblKnow;
}
@property (nonatomic, strong) IBOutlet UILabel* lblWord;
@property (nonatomic, strong) IBOutlet UILabel* lblSentence;
@property (nonatomic, strong) IBOutlet UILabel* lblKnow;
@end
