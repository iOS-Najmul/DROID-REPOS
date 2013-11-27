//
//  WordDetailEditViewController.m
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 12. 8..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "WordDetailEditViewController.h"

@interface WordDetailEditViewController ()

@end

@implementation WordDetailEditViewController
@synthesize lblWord, lblNameToEdit, txtToEdit;
@synthesize _arrWords, _strWord, _strNameToEdit, _strToEdit;

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
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//	self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(doneEditing:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.title = NSLocalizedString(_strNameToEdit, @"");
    lblWord.text = _strWord;
    lblNameToEdit.text = _strNameToEdit;
    txtToEdit.text = _strToEdit;
    
    [txtToEdit becomeFirstResponder];
    
    
}

-(void) back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{

}

- (void) doneEditing:(id)sender
{

    for(int i = 0; i < [_arrWords count]; i++) {
        NSMutableDictionary *dicOne = [_arrWords objectAtIndex:i];
        
        NSString *strWord = [dicOne objectForKey:@"Word"];
        if ([[_strWord lowercaseString] isEqualToString:[strWord lowercaseString]] == TRUE) {

            NSString *strResult = [txtToEdit.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([strResult isKindOfClass:[NSNull class]]) {
                strResult = @"";
            }
            if ([_strNameToEdit isEqualToString:KEY_DIC_MEANING]) {                
                [dicOne setValue:strResult forKey:KEY_DIC_MeaningChanged];
            } else if ([_strNameToEdit isEqualToString:KEY_DIC_Pronounce]) {
                [dicOne setValue:strResult forKey:KEY_DIC_PronounceChanged];
            } else if ([_strNameToEdit isEqualToString:KEY_DIC_Desc]) {
                [dicOne setValue:strResult forKey:KEY_DIC_DescChanged];
            }
            
            [_arrWords replaceObjectAtIndex:i withObject:dicOne];
        }
    }
    
    [self performSelector:@selector(back) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return true;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
