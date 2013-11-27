//
//  DicListCell.h
//  MyListPro
//
//  Created by 김형달 on 10. 11. 23..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DicListCell : UITableViewCell<UITextFieldDelegate> {
	IBOutlet UILabel* lblWord;
	IBOutlet UILabel* lblKnow;
	IBOutlet UILabel* lblCount;
	IBOutlet UILabel* lblPronounce;
	IBOutlet UITextField* txtMeaning;
//	IBOutlet UISegmentedControl* segKnow;
	
}
@property (nonatomic, strong) IBOutlet UILabel* lblWord;
@property (nonatomic, strong) IBOutlet UILabel* lblKnow;
@property (nonatomic, strong) IBOutlet UILabel* lblCount;
@property (nonatomic, strong) IBOutlet UILabel* lblPronounce;
@property (nonatomic, strong) IBOutlet UITextField* txtMeaning;
//@property (nonatomic, strong) IBOutlet UISegmentedControl* segKnow;
-(IBAction) textFieldDoneEditing:(id)sender;
@end
