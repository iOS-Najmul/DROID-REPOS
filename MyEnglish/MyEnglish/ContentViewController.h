//
//  ContentViewController.h
//  MyEnglish
//
//  Created by Najmul Hasan on 8/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) NSString *labelContents;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) float lastScrollY;
@property (nonatomic) float lastContentHeight;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) UIViewController *parentVC;

@property (nonatomic) int displayingPage;

@end
