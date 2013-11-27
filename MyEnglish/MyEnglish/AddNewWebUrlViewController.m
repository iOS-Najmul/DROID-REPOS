//
//  AddNewWebUrlViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 8/25/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "AddNewWebUrlViewController.h"
#import "WebURL.h"
#import "SVProgressHUD.h"

@interface AddNewWebUrlViewController ()

@end

@implementation AddNewWebUrlViewController
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
    
    self.lblName.text = NSLocalizedString(@"Name", @"");
    self.lblURL.text = NSLocalizedString(@"URL", @"");
    self.txtFldName.placeholder = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"Type the name", @"")];
    
    [self.txtFldName becomeFirstResponder];
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
        
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"Need name and URL(web address).", @"")];
		return;
	}
    
    [(WebURL*)parentController addBookmarkWithName:strNameTemp andUrl:strURLTemp];
    
    [self dismissModalViewControllerAnimated:YES];
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
    //        txtFldURL.text = [NSString stringWithFormat:@"http://%@", txtFldURL.text];
    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
