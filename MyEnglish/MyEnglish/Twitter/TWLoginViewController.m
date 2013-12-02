//
//  TWLoginViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 11/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "TWLoginViewController.h"
#import "TwitterViewController.h"
#import "STTwitter.h"
#import "SVProgressHUD.h"

static NSString *const twitterConsumerKey = @"c4x3s1beFj7c8cmT3FHeqw";
static NSString *const twitterConsumerSecret = @"TNcvd28PMafwcLloCGqsGIXYQSfHpICSQd3PcP5U8";

@interface TWLoginViewController ()

@end

@implementation TWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginWithiOSAction:(id)sender {
    
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {

        [(TwitterViewController*)self.parrentVC setTwitter:self.twitter];
        [self goBack];
        [SVProgressHUD showSuccessWithStatus:@"Loged in successfully"];
        
    } errorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Can't login, please try again later"];
    }];
}

- (IBAction)loginInSafariAction:(id)sender {
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twitterConsumerKey
                                                 consumerSecret:twitterConsumerSecret];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {

        [[UIApplication sharedApplication] openURL:url];
        
    } oauthCallback:@"krykoapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        [SVProgressHUD showErrorWithStatus:@"Can't login, please try again later"];
                    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        
        self.twitter.userName = screenName;
        [(TwitterViewController*)self.parrentVC setTwitter:self.twitter];
        [self goBack];
        [SVProgressHUD showSuccessWithStatus:@"Loged in successfully"];
        
    } errorBlock:^(NSError *error) {
        
    }];
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
