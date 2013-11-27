//
//  WordSearchCell.h
//  Ready2Read
//
//  Created by KIM HyungDal on 11. 12. 10..
//  Copyright (c) 2011 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordSearchCell : UITableViewCell {
	IBOutlet UILabel* lblWord;
	IBOutlet UILabel* lblPage;
	IBOutlet UILabel* lblSentence;
    IBOutlet UIWebView  *webOne;
}
@property (nonatomic, strong) IBOutlet UILabel* lblWord;
@property (nonatomic, strong) IBOutlet UILabel* lblPage;
@property (nonatomic, strong) IBOutlet UILabel* lblSentence;
@property (nonatomic, strong) IBOutlet UIWebView    *webOne;
@end
