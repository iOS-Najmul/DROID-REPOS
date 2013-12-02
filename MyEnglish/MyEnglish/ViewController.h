//
//  ViewController.h
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 5. 13..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "GADBannerView.h"
#import "OptionsViewController.h"
#import <iAd/iAd.h>
#import <FacebookSDK/FacebookSDK.h>
#import "STTwitter.h"

@class User;
@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate, GADBannerViewDelegate, OptionsViewControllerDelegate, UISplitViewControllerDelegate,FBLoginViewDelegate>
{
    ADBannerView                *iADBanner; // iAD
//    GADInterstitial *interstitial_;
    GADBannerView               *bannerView_;
    NSMutableData               *dataiTunesRSS;

    UIAlertView                 *alertViewProgress;
    UIProgressView              *progUpdate;   
    UILabel                     *lblUpdateMsg;
}

@property (nonatomic, strong) IBOutlet UIImageView        *imageView;
@property (nonatomic, strong) IBOutlet UIButton           *btnIdiomAndTheme;
@property (nonatomic, strong) IBOutlet UIButton           *btnOpenLevel;
@property (nonatomic, strong) IBOutlet UIButton           *btnOpenBook;
@property (nonatomic, strong) IBOutlet UIButton           *btnOpenWeb;
@property (nonatomic, strong) IBOutlet UIButton           *btnOpenDic;

@property (nonatomic, strong) IBOutlet UIButton           *btnSendMail;
@property (nonatomic, strong) IBOutlet UIButton           *btnTwitter;
@property (nonatomic, strong) IBOutlet UIButton           *btnFacebook;
@property (nonatomic, strong) IBOutlet UIButton           *btnOpenMovie;

@property (nonatomic, strong) UIAlertView                 *alertViewProgress;
@property (nonatomic, strong) UIProgressView              *progUpdate;  
@property (nonatomic, strong) UILabel                     *lblUpdateMsg;
@property (nonatomic, strong) NSMutableData               *dataiTunesRSS;
@property (nonatomic, strong) IBOutlet UIButton           *btnExportWordList;

@property (nonatomic, strong) STTwitterAPI *twitter;

- (IBAction) callOpenFacebook:(id)sender;
- (IBAction) callOpenTwitter:(id)sender;
- (IBAction) callOpenMovie:(id)sender;
- (IBAction) onBtnIdiomAndTheme:(id)sender;

- (IBAction) callOpenLevel:(id)sender;
- (IBAction) onBtnSendMail:(id)sender;

- (IBAction) callOpenBook:(id)sender;
- (IBAction) callOpenWeb:(id)sender;
- (IBAction) callOpenDicList:(id)sender;

- (void)makeIndexOrNot;
- (void)createIndex:(NSObject*)obj;
- (void)copyMyEnglishIfNeeded;
- (void)copyHowToUseFileIfNeeded;
- (void)copyStyleCSSIfNeeded;
- (void)setPressedGradient:(id)sender;
- (void)setUnpressedGradient:(id)sender;
- (void)insertPronounceAndPhrasalVerb:(NSObject*)obj;

@end
