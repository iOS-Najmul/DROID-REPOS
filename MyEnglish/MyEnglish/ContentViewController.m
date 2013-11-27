//
//  ContentViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 8/28/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "ContentViewController.h"
#import "BookViewController.h"
#import "UnpreventableUILongPressGestureRecognizer.h"
#import "UnpreventableTapGesture.h"

@implementation ContentViewController
@synthesize myLabel;
@synthesize labelContents;
@synthesize displayingPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)allowPageTurning{
    
    [(BookViewController*)self.parentVC setShouldDenyPageTurn:NO];
}

- (void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    [(BookViewController*)self.parentVC setShouldDenyPageTurn:YES];
    [self performSelector:@selector(allowPageTurning) withObject:nil afterDelay:1.5];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    [(BookViewController*)self.parentVC changeBookStudy];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myLabel.text = self.labelContents;
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 0.0, 0.0);
    self.webView.frame = pageViewRect;
    self.webView.delegate = self;
    
    UnpreventableUILongPressGestureRecognizer *longPressRecognizer = [[UnpreventableUILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    longPressRecognizer.allowableMovement = 20;
    longPressRecognizer.minimumPressDuration = 0.6f;
    [self.webView addGestureRecognizer:longPressRecognizer];
    
    UnpreventableTapGesture *doubleTap = [[UnpreventableTapGesture alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.webView addGestureRecognizer:doubleTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_webView loadHTMLString:_dataObject
                     baseURL:[NSURL URLWithString:@""]];
    self.view.backgroundColor = [UIColor whiteColor];
    //    _webView.scrollView.scrollEnabled = NO;
    //    _webView.scrollView.bounces = NO;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    int fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:KEY_DIC_FontSize];
    
    //    webView.scrollView.scrollEnabled = (fontSize >= Font_Size_NORMAL);
    //    webView.scrollView.bounces = (fontSize >= Font_Size_NORMAL);
    
    if (fontSize) {
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
        
        if (self.lastScrollY) {
            
            NSString *contentHeight = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
            NSLog(@"contentHeight:%@",contentHeight);
            
            self.lastScrollY = self.lastScrollY + ([contentHeight floatValue] - self.lastContentHeight);
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollTop = %f",self.lastScrollY]];
        }
    }
}

- (void)viewDidUnload
{
    [self setMyLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
