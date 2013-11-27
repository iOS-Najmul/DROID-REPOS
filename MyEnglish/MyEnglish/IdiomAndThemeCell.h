//
//  IdiomAndThemeCell.h
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 11. 25..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdiomAndThemeCell : UITableViewCell
{
    UILabel     *lblProverb;
    UILabel     *lblMeaning;
    UILabel     *lblKnown;
}

@property (nonatomic, strong) IBOutlet UILabel  *lblProverb;
@property (nonatomic, strong) IBOutlet UILabel  *lblMeaning;
@property (nonatomic, strong) IBOutlet UILabel  *lblKnown;

@end
