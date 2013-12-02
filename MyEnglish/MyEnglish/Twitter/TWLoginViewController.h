//
//  TWLoginViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 11/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitter.h"

@interface TWLoginViewController : UIViewController

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, retain) UIViewController *parrentVC;

- (IBAction)loginWithiOSAction:(id)sender;
- (IBAction)loginInSafariAction:(id)sender;
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;

@end
