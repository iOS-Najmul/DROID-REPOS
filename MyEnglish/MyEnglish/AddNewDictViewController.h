//
//  AddNewDictViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 8/24/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewDictViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic, retain) IBOutlet UIView       *viewAdd;
@property (nonatomic, retain) IBOutlet UITextField	*txtFldName;
@property (nonatomic, retain) IBOutlet UITextField	*txtFldURL;

@property (nonatomic, retain) IBOutlet UILabel      *lblExample;
@property (nonatomic, retain) IBOutlet UILabel      *lblExplain;
@property (nonatomic, retain) UIViewController      *parentController;

@end
