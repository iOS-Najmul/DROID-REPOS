//
//  AddNewWebUrlViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 8/25/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewWebUrlViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) 	IBOutlet UIView         *viewAdd;
@property (nonatomic, strong)	IBOutlet UITextField	*txtFldName;
@property (nonatomic, strong)	IBOutlet UITextField	*txtFldURL;

@property (nonatomic, strong)	IBOutlet UILabel        *lblName;
@property (nonatomic, strong)	IBOutlet UILabel        *lblURL;
@property (nonatomic, retain) UIViewController          *parentController;

@end
