//
//  AddNewDictViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 8/24/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "AddNewDictViewController.h"
#import "WebDicListController.h"
#import "SVProgressHUD.h"

@interface AddNewDictViewController ()

@end

@implementation AddNewDictViewController
@synthesize parentController;

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMe:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneMe:)];
    
    self.txtFldName.placeholder = NSLocalizedString(@"Type the name", @"");
    self.txtFldURL.placeholder = NSLocalizedString(@"Web Dictionary URL", @"");
    self.lblExample.text = NSLocalizedString(@"Example) http://dictionary.reference.com/browse/@@", @"");
    self.lblExplain.text = NSLocalizedString(@"Put @@ instead of WORD...", @"");
    
    [self.txtFldName becomeFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

-(BOOL) textFieldShouldReturn:(UITextField*)textField
{
	//	[textField resignFirstResponder];
    if (textField.tag == 1) {
        [self onTxtFldURLChanged];
    }
	return YES;
}

- (void) onTxtFldURLChanged
{
    //    if ([[txtFldURL.text lowercaseString] hasPrefix:@"http://"] == FALSE) {
    //        self.txtFldURL.text = [NSString stringWithFormat:@"http://%@", txtFldURL.text];
    //    }
}

-(void)closeMe:(id)sender{

    [self dismissModalViewControllerAnimated:YES];
}

-(void)doneMe:(id)sender{
    
    if ([[self.txtFldURL.text lowercaseString] hasPrefix:@"http://"] == FALSE) {
        self.txtFldURL.text = [NSString stringWithFormat:@"http://%@", self.txtFldURL.text];
    }
	NSString *strNameTemp = [self.txtFldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *strURLTemp = [self.txtFldURL.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (([strNameTemp isEqualToString:@""] == TRUE) || ([strURLTemp isEqualToString:@""] == TRUE)) {
		
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"Need title and URL(web address).", @"")];
		return;
	}
	DLog(@"strURLTemp : %@", strURLTemp);
	NSRange rngOne = [strURLTemp rangeOfString:@"@@" options:NSCaseInsensitiveSearch];
	if( rngOne.location == NSNotFound) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"There is no @@ in URL. @@ means the word you want to look for.", @"")];
		return;
	}
    [(WebDicListController*)parentController addBookmarkWithName:strNameTemp andUrl:strURLTemp];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
