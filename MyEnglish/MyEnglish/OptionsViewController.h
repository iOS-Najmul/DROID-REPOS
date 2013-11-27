//
//  OptionsViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 10/6/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsViewController;
@protocol OptionsViewControllerDelegate <NSObject>

@required
-(void)didSelectedOption:(OptionsViewController *)optionsVC;
@end

@interface OptionsViewController : UIViewController

@property (nonatomic) int selectedOption;
@property (nonatomic, assign) id<OptionsViewControllerDelegate> delegate;

@end
