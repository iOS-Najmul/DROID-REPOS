//
//  WebDicController.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 6..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "WebDicController.h"
#import "WordDetail.h"
#import "WebDicListController.h"
#import "myCommon.h"


#define segConWidthEach 80
@implementation WebDicController

@synthesize strWord, slideBackLightValue, aiv, intBeforeSegConWebDicSelectedIndex;
@synthesize dicAllWordsAllAttribute, searchBarInWebDic, intBookTblNo;
@synthesize pickerWebDic, arrLang, intBeforeTabbarSelectedIndex, strOutputLang;
@synthesize arrWebDicLists, strFileNameWebDicListsPlist, viewPicker, barBtnItemSelectPicker, barBtnItemCacnelPicker, intSelItemPicker;
@synthesize blnCancelButtonClicked, arrWebView, arrAiv, beforeErrorCode;
@synthesize tabBarEditWebDic, tabBarChangeWebDic;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self createWebDicListPlistIfNeeded];
	
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	
	self.searchBarInWebDic.text = strWord;
	self.aiv.center = webViewDic.center;
	self.aiv.hidden = TRUE;
    aiv.hidesWhenStopped = true;
	webViewDic.scalesPageToFit = TRUE;
	
	UIColor *color =  [UIColor colorWithRed:slideBackLightValue/255.0 green:slideBackLightValue/255.0 blue:slideBackLightValue/255.0 alpha:1];
	webViewDic.backgroundColor = color;
	
    tabBarEditWebDic.title = NSLocalizedString(@"Edit WebDic", @"");
    tabBarChangeWebDic.title = NSLocalizedString(@"Change WebDic", @"");
    barBtnItemCacnelPicker.title = NSLocalizedString(@"Cancel", @"");
    barBtnItemSelectPicker.title = NSLocalizedString(@"Select", @"");    
	//다국어 버전을 만들기 위해서 디바이스의 언어를 가져온다.
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];	
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];	
//	DLog(@"lang : %@", languages);
    strOutputLang = [[NSString alloc] initWithFormat:@"%@", [languages objectAtIndex:0]];
//    DLog(@"strOutputLang : %@", strOutputLang);
	arrLang = [[NSMutableArray alloc] initWithArray:languages];
    self.viewPicker.hidden = TRUE;
    intSelItemPicker = 0;
    
    arrWebDicLists = [[NSMutableArray alloc] initWithContentsOfFile:strFileNameWebDicListsPlist];

    arrWebView = [[NSMutableArray alloc] initWithCapacity:[arrWebDicLists count]];
    arrAiv = [[NSMutableArray alloc] initWithCapacity:[arrWebDicLists count]];
    
    blnCancelButtonClicked = FALSE;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	intBeforeSegConWebDicSelectedIndex = -1;
	intBeforeTabbarSelectedIndex = -1;
    beforeErrorCode = 0;

    self.navigationItem.titleView = nil;
    searchBarInWebDic = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, self.navigationController.navigationBar.frame.size.height)];
    searchBarInWebDic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.searchBarInWebDic.delegate = self;
	self.navigationItem.titleView = searchBarInWebDic;
    
    self.arrWebDicLists = [NSMutableArray arrayWithContentsOfFile:strFileNameWebDicListsPlist];
    DLog(@"arrWebDicLists : %@", arrWebDicLists);
    
    //==============================================
    //버전1.2_업데이트] 사전이 하나도 없으면 파일이 있으면 지우고 번들에 있는 사전리스트를 복사한다.
    if( (arrWebDicLists == NULL) || ([arrWebDicLists count] == 0) ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        self.strFileNameWebDicListsPlist = [[myCommon getDocPath] stringByAppendingPathComponent:@"webDicList.plist"];
        if ([fileManager fileExistsAtPath:strFileNameWebDicListsPlist] == true) {
            [fileManager removeItemAtPath:[[myCommon getDocPath] stringByAppendingPathComponent:@"webDicList.plist"] error:nil];
        }        
        DLog(@"strFileNameBookmarksPlist : %@", strFileNameWebDicListsPlist);
        
        [self createWebDicListPlistIfNeeded];
    }
    //==============================================
          
          
    [arrWebView removeAllObjects];
    [arrAiv removeAllObjects];
    for (int i = 0; i < [arrWebDicLists count]; ++i) {
        //==============================================
        //버전1.2_업데이트] 한방검색에 사용되는 사전을 사용할지 여부를 선택함 1일때만 선택함.
        NSDictionary *dicOne = [arrWebDicLists objectAtIndex:i];
        NSInteger intOn = [[dicOne objectForKey:@"ON"] integerValue];
        //==============================================

        if (intOn == 1) {
            UIWebView *webViewOne = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, appWidth, webViewDic.frame.size.height)];
            
            webViewOne.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            webViewOne.delegate = self;
            webViewOne.scalesPageToFit = true;
            webViewOne.userInteractionEnabled = true;
            webViewOne.multipleTouchEnabled = true;
            [self.arrWebView addObject:webViewOne];        
            
            UIActivityIndicatorView *aivOne = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aivOne.center = self.view.center;
            [self.view addSubview: aivOne];
            [self.arrAiv addObject:aivOne];
            
        } else {
            [arrWebDicLists removeObjectAtIndex:i];
            i--;
        }
    }
    //하나도 없으면 뷰를 일단 하나를 만든다.
    if ([arrWebView count] == 0) {
        UIWebView *webViewOne = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, appWidth, webViewDic.frame.size.height)];

        webViewOne.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webViewOne.delegate = self;
        webViewOne.scalesPageToFit = true;
        webViewOne.userInteractionEnabled = true;
        webViewOne.multipleTouchEnabled = true;
        [self.arrWebView addObject:webViewOne];        
        
        UIActivityIndicatorView *aivOne = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aivOne.center = self.view.center;
        [self.view addSubview: aivOne];
     
        [self.arrAiv addObject:aivOne];
    }
    
    [self callWebViewList];
    [self.pickerWebDic reloadAllComponents];
    
    if (intSelItemPicker >= [arrWebDicLists count]) {
        intSelItemPicker = 0;
    }
    [self onBarBtnItemSelectPicker];
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSInteger BackLight = [defs integerForKey:@"BackLight"];
    if (BackLight == 0) {
        BackLight = 255;
    }
	UIColor *color =  [UIColor colorWithRed:BackLight/255.0 green:BackLight/255.0 blue:BackLight/255.0 alpha:1];
	webViewDic.backgroundColor = color;
}

-(void) callWebViewList
{
    NSString	*strInSearchBar = searchBarInWebDic.text;
    strInSearchBar = [strInSearchBar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!((strInSearchBar == NULL) || ([strInSearchBar isEqualToString:@""] == TRUE))) {
        self.strWord = [NSString stringWithFormat:@"%@", strInSearchBar];
    }
    for (int i = 0; i < [arrWebDicLists count]; ++i) {
        DLog(@"arrWebDicList %d : %@", i, [arrWebDicLists objectAtIndex:i]);
        NSString *strWebDicURL = [[arrWebDicLists objectAtIndex:i] objectForKey:@"URL"];
        NSArray	*arrWebDicURLSplit = [strWebDicURL componentsSeparatedByString:@"@@"];
        if ([arrWebDicURLSplit count] !=2) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"There is no @@ in URL. @@ means the word you want to look for.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
            continue;
        }
        self.strWord = [strWord stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        DLog(@"strWord : %@", strWord);
        NSString *strDic = [NSString stringWithFormat:@"%@%@%@",[arrWebDicURLSplit objectAtIndex:0], strWord, [arrWebDicURLSplit objectAtIndex:1]];
#ifdef CHINESE
        strDic = [NSString stringWithFormat:@"%@%@%@",[arrWebDicURLSplit objectAtIndex:0], [strWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [arrWebDicURLSplit objectAtIndex:1]];
#endif
        DLog(@"strDic : %@", strDic);

        UIWebView *webViewOne = [arrWebView objectAtIndex:i];
        [webViewOne loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strDic]]];
    }
}

//Back을 누르면 뒤로 돌아간다.
-(IBAction) back {
	[searchBarInWebDic resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}


//저장할 파일이 Documents 폴더에 있으면 그대로 쓰고 없으면 Main Bundle에서 복사한다. 
-(void) createWebDicListPlistIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	DLog(@"doc : %@", [myCommon getDocPath]);
	self.strFileNameWebDicListsPlist = [[myCommon getDocPath] stringByAppendingPathComponent:@"webDicList.plist"];
	BOOL dbExists = [fileManager fileExistsAtPath:strFileNameWebDicListsPlist];
	DLog(@"strFileNameWebDicListsPlist : %@", strFileNameWebDicListsPlist);
	if(!dbExists)
	{
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];	
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];	
        NSString *strOutputLang1 = [NSString stringWithFormat:@"%@", [languages objectAtIndex:0]];
        NSString *strDefaultWebDicList = @"webDicList.plist";
        
        if ([strOutputLang1 isEqualToString:@"ko"]) {
            //한국어
           strDefaultWebDicList = @"webDicList_ko.plist";
        }
#ifdef CHINESE
        strDefaultWebDicList = @"webDicListChinese.plist";
        if ([strOutputLang1 isEqualToString:@"ko"]) {
            //한국어
            strDefaultWebDicList = @"webDicListChinese_ko.plist";
        }
        
#endif
		NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", strDefaultWebDicList]];
		DLog(@"defaultDBPath : %@", defaultDBPath);
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:strFileNameWebDicListsPlist error:&error];
		if (!success) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@ : webDicList", NSLocalizedString(@"Can't copy file to Document folder", @"")] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert show];
		}
	}	
}

- (IBAction)onOpenWordDetail
{
	WordDetail *wordDetail = [[WordDetail alloc] initWithNibName:@"WordDetail" bundle:nil];
	wordDetail._strWord = searchBarInWebDic.text;
    wordDetail._strWordFirst = searchBarInWebDic.text;
	wordDetail.intBookTblNo = intBookTblNo;
	[self.navigationController pushViewController:wordDetail animated:YES];					 
}

#pragma mark -  
#pragma mark UISearchBarDelegate methods   

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = TRUE;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if ([searchBar isFirstResponder]) {

    } else {
        [searchBar becomeFirstResponder]; // not sure this will actually work but I'd try it
    }
    searchBar.showsCancelButton = FALSE;
    if (blnCancelButtonClicked == FALSE) {
        [self callWebViewList];
    }
    blnCancelButtonClicked = FALSE;
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	DLog(@"searchBarCancelButtonClicked:");
    blnCancelButtonClicked = true;
	[searchBarInWebDic resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
	DLog(@"searchBarBookmarkButtonClicked:");
	[searchBarInWebDic resignFirstResponder];	
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBarInWebDic resignFirstResponder];	
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods   

//피커뷰에 보이는 글자...
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dicOne = [self.arrWebDicLists objectAtIndex:row];
	return [dicOne objectForKey:@"Name"];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.arrWebDicLists count];
}

//피커뷰에서 선택한것을 적는다.
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.strOutputLang = [arrWebDicLists objectAtIndex:row];
    DLog(@"Dic : %@", [arrWebDicLists objectAtIndex:row]);
    intSelItemPicker = row;
}

- (IBAction) onBarBtnItemSelectPicker{
    
    self.viewPicker.hidden = true;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7f];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    
    UIWebView *webview = [self.arrWebView objectAtIndex:intSelItemPicker];
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webview.frame = webViewDic.frame;
    
	[self.view addSubview:webview];
	[self.view bringSubviewToFront:[self.arrWebView objectAtIndex:intSelItemPicker]];
	[UIView commitAnimations];
    
    [self.view bringSubviewToFront:[arrAiv objectAtIndex:intSelItemPicker]];
}

- (IBAction) onBarBtnItemCancelPicker {
    
    CATransition *ani = [CATransition animation];
    [ani setDelegate:self];
    [ani setDuration:0.4f];
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setType:kCATransitionPush];
    [ani setSubtype:kCATransitionFromBottom];
    self.viewPicker.hidden = TRUE;
    
    [[viewPicker layer] addAnimation:ani forKey:@"transitionViewAnimation"];
}


#pragma mark -  
#pragma mark UIWebViewDelegate methods   
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    for (int i = 0; i < [arrWebView count]; ++i) {
        UIWebView *webViewOne = [arrWebView objectAtIndex:i];
        if (webView == webViewOne) {
            [[arrAiv objectAtIndex:i] setHidden:FALSE];
            [self.view bringSubviewToFront:[arrAiv objectAtIndex:i]];
            [[arrAiv objectAtIndex:i] startAnimating];
        }
    }
}
// WebView is finished loading
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    for (int i = 0; i < [arrWebView count]; ++i) {
        UIWebView *webViewOne = [arrWebView objectAtIndex:i];
        if (webView == webViewOne) {
            DLog(@"webView : %@", webView);
            [[arrAiv objectAtIndex:i] stopAnimating];
        }
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	DLog(@"err code : %d", [error code]);
    DLog(@"err desc : %@", [error localizedDescription]);
    DLog(@"err reason : %@", [error localizedFailureReason]);
    
    //인터넷이 연결안되었을때는 모든 웹뷰가 다 에러가 있을때 경고를 뱉는다.
    if ([error code] == -1009) {
        beforeErrorCode++;
        //모든 webView에 다 에러가 있을때 경고를 벁는다...
        if ([arrWebView count] == beforeErrorCode) {
            beforeErrorCode = 0;
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[error localizedDescription]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
        }
    } else {
        if ([error code] == 101) {
            //해결질문] 긴문장을 선택해서 단어상세를 열면 이 에러가 난다. 그런데 그때 searchBox에서 다시 한번 실행하면 이에러가 안난다.
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[error localizedDescription]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
            DLog(@"err code : %d", [error code]);
            DLog(@"err desc : %@", [error localizedDescription]);
            DLog(@"err reason : %@", [error localizedFailureReason]);

        }else if ([error code] != -999){
            if  ([error code] != 204) {
                DLog (@"webView:didFailLoadWithError");
                //[webActivityIndicator stopAnimating];
                if (error != NULL) {
                    
        //            aiv.hidesWhenStopped = true;          
                    for (int i = 0; i < [arrWebView count]; ++i) {
                        UIWebView *webViewOne = [arrWebView objectAtIndex:i];
                        if (webView == webViewOne) {
                            NSString *strWebDicName = [[arrWebDicLists objectAtIndex:i] objectForKey:@"Name"];
                            UIAlertView *errorAlert = [[UIAlertView alloc]
                                                       initWithTitle: @"Info"
                                                       message: [NSString stringWithFormat:@"Web Dictionary's Name\n(%@)\n\n%@", strWebDicName,[error localizedDescription]]
                                                       delegate:nil
                                                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                       otherButtonTitles:nil];
                            [errorAlert show];
                            break;
                        }
                    }
                }
            }
        }
    }  
    
    [aiv stopAnimating];
    for (int i = 0; i < [arrWebView count]; ++i) {
        UIWebView *webViewOne = [arrWebView objectAtIndex:i];
        if (webView == webViewOne) {
            DLog(@"webView : %@", webView);
            [[arrAiv objectAtIndex:i] stopAnimating];
        }
    }
}

#pragma mark -
#pragma mark UITabBarDelegate methods   
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	DLog(@"tabBar.tag : %d", tabBar.tag);
	DLog(@"item.title : %@", item.title);
	DLog(@"item.tag : %d", item.tag);
	if (item.tag == 1) {
        
			WebDicListController *webDicListController = [[WebDicListController alloc] initWithNibName:@"WebDicListController" bundle:nil];
			[self.navigationController pushViewController:webDicListController animated:YES];	

	} else if (item.tag == 2) {

        [self.view bringSubviewToFront:viewPicker];
        
        CATransition *ani = [CATransition animation];
        [ani setDelegate:self];
        [ani setDuration:0.4f];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [ani setType:kCATransitionPush];
        [ani setSubtype:kCATransitionFromTop];
        self.viewPicker.hidden = FALSE;
        [[viewPicker layer] addAnimation:ani forKey:@"transitionViewAnimation"];
	
	}
	intBeforeTabbarSelectedIndex = item.tag;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark ios 5 rotation code
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark ios6 rotation code

-(BOOL) shouldAutorotate
{
    return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation  duration:(NSTimeInterval)duration
{

}

@end
