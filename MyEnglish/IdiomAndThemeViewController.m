//
//  IdiomAndThemeViewController.m
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 11. 25..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "IdiomAndThemeViewController.h"
#import "IdiomAndThemeCell.h"
#import "myCommon.h"
#import "DicListController.h"



#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>


@interface IdiomAndThemeViewController ()

@end

@implementation IdiomAndThemeViewController

@synthesize tblMain, arrIdiomAndTheme;

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    
//    self.arrIdiomAndTheme = [myCommon getProverbList];
    arrIdiomAndTheme = [[NSMutableArray alloc] init];
    [arrIdiomAndTheme addObject:NSLocalizedString(@"Proverb", @"")];
    [arrIdiomAndTheme addObject:NSLocalizedString(@"Phrasal Verb", @"")];
    
    
    
//    if ([SKPaymentQueue canMakePayments]) {	// 스토어가 사용 가능하다면        
//        DLog(@"Start Shop!");
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];	// Observer를 등록한다.
//    }
//    else
//        DLog(@"Failed Shop!");
//
//    
//    
//    
//    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"testitem_01"]];
//    
//    productRequest.delegate = self;
//    
//    [productRequest start];
//
//    
//    
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
//    
//    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    DLog(@"SKProductRequest got response");
    
    if( [response.products count] > 0 ) {
        
        SKProduct *product = [response.products objectAtIndex:0];
        
        DLog(@"Title : %@", product.localizedTitle);
        
        DLog(@"Description : %@", product.localizedDescription);
        
        DLog(@"Price : %@", product.price);
        
    }
    
    if( [response.invalidProductIdentifiers count] > 0 ) {
        
        NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
        
        DLog(@"Invalid Identifiers : %@", invalidString);
        
    }
    
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions

{
    
    for (SKPaymentTransaction *transaction in transactions)
        
    {
        
        switch (transaction.transactionState)
        
        {
                
            case SKPaymentTransactionStatePurchased:
                
                [self completeTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];
                
            default:
                
                break;
                
        }
        
    }
    
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    
    DLog(@"SKPaymentTransactionStateRestored");
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction

{
    
    DLog(@"SKPaymentTransactionStateFailed");
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    
    DLog(@"SKPaymentTransactionStatePurchased");
    
    
    DLog(@"Trasaction Identifier : %@", transaction.transactionIdentifier);
    
    DLog(@"Trasaction Date : %@", transaction.transactionDate);
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView1 {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrIdiomAndTheme count];
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (tableView == tblMain) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString *strTitle = [arrIdiomAndTheme objectAtIndex:indexPath.row];;
    cell.textLabel.text = strTitle;
	return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
////    if (tableView == tblMain) {
//        IdiomAndThemeCell * cell = (IdiomAndThemeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IdiomAndThemeCell" owner:nil options:nil];
//            cell = [arr	objectAtIndex:0];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
////            CGRect cellFrame = CGRectMake(0.0, cell.frame.origin.y, cell.frame.size.width, 60);
////            cell.frame = cellFrame;
//            
//        }
//        NSDictionary *dicOne = [arrIdiomAndTheme objectAtIndex:indexPath.row];;
//        NSString *strProverb = [dicOne objectForKey:KEY_DIC_Idiom];
//        NSString *strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
//        NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
//    
//    if ([strMeaning isEqualToString:@""]) {
//        strMeaning = [NSString stringWithString:strDesc];
//    }
//    
//    DLog(@"cell.lblProverb.frame : %@", [NSValue valueWithCGRect:cell.lblProverb.frame]);
//    DLog(@"cell.lblMeaning.frame : %@", [NSValue valueWithCGRect:cell.lblMeaning.frame]);
//    
//    DLog(@"cell.frame : %@", [NSValue valueWithCGRect:cell.frame]);
//    
//        CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
//        //    NSString *dateString = @"The date today is January 1st, 1999";
//        //    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
//        CGSize cellProverbStringSize = [strProverb sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
//                                              constrainedToSize:maximumSize
//                                                  lineBreakMode:UILineBreakModeWordWrap];
//        cell.lblProverb.frame = CGRectMake(cell.lblProverb.frame.origin.x, CELL_CONTENT_MARGIN, cell.lblProverb.frame.size.width, cellProverbStringSize.height + CELL_CONTENT_MARGIN);
//    
//    CGSize cellMeaningStringSize = [strMeaning sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
//                                          constrainedToSize:maximumSize
//                                              lineBreakMode:UILineBreakModeWordWrap];
//    cell.lblMeaning.frame = CGRectMake(cell.lblMeaning.frame.origin.x, cell.lblProverb.frame.origin.y + cell.lblProverb.frame.size.height + CELL_CONTENT_MARGIN, cell.lblMeaning.frame.size.width, cellMeaningStringSize.height + CELL_CONTENT_MARGIN);
//    
//    
//    DLog(@"cellForRowAtIndexPath strProverb : %@", strProverb);
//    DLog(@"cellProverbStringSize.height : %f", cellProverbStringSize.height);
//    DLog(@"cell.lblProverb.frame : %@", [NSValue valueWithCGRect:cell.lblProverb.frame]);
//    
//    
//
//    
//    DLog(@"cellForRowAtIndexPath strMeaning : %@", strMeaning);
//    DLog(@"cellMeaningStringSize.height : %f", cellMeaningStringSize.height);
//    DLog(@"cell.lblMeaning.frame : %@", [NSValue valueWithCGRect:cell.lblMeaning.frame]);
//    
////    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellProverbStringSize.height + cellMeaningStringSize.height + 5 + 5 + 5 + 5 + 5);
//    
//    DLog(@"cell.frame : %@", [NSValue valueWithCGRect:cell.frame]);
//        cell.lblKnown.text = @"";
////    cell.lblProverb.attributedText = [myCommon getSentenceWithKnownOrUnknown:strProverb];
//        cell.lblProverb.text = strProverb;
//        cell.lblMeaning.text = strMeaning;
//        
////	}
//	return cell;
//}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        //Proverb일때...
        DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
        dicListController.intDicWordOrIdiom = DicWordOrIdiom_Proverb;
        dicListController.strWhereClauseFldSQL = @"";
        dicListController.blnUseKnowButton = TRUE;
        [self.navigationController pushViewController:dicListController animated:YES];
    } else if (indexPath.row == 1) {
        //Phrasal Verb 일때...
        DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
        dicListController.intDicWordOrIdiom = DicWordOrIdiom_PhrasalVerb;
        dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" (%@ > 1) ", FldName_WordLength];
        
        DLog(@"strWhereClauseFldSQL : %@", dicListController.strWhereClauseFldSQL);
        dicListController.strWhereClauseFldSQL = @"";
        dicListController.blnUseKnowButton = TRUE;
        [self.navigationController pushViewController:dicListController animated:YES];
    }
}
//테이블 셀의 높이를 조절한다.
//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
////    IdiomAndThemeCell *cell = (IdiomAndThemeCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSDictionary *dicOne = [arrIdiomAndTheme objectAtIndex:indexPath.row];;
//    NSString *strProverb = [dicOne objectForKey:KEY_DIC_Idiom];
//    NSString *strMeaning = [dicOne objectForKey:KEY_DIC_MEANING];
//    NSString *strDesc = [dicOne objectForKey:KEY_DIC_Desc];
//
//    if ([strMeaning isEqualToString:@""]) {
//        strMeaning = [NSString stringWithString:strDesc];
//    }
//    
//    DLog(@"heightForRowAtIndexPath strProverb : %@", strProverb);
//    DLog(@"heightForRowAtIndexPath strMeaning : %@", strMeaning);
//    CGSize maximumSize = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
////    NSString *dateString = @"The date today is January 1st, 1999";
////    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
//    CGSize cellProverbStringSize = [strProverb sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
//                                   constrainedToSize:maximumSize
//                                       lineBreakMode:UILineBreakModeWordWrap];
//    
////    CGRect cellProverbFrame = CGRectMake(cell.lblProverb.frame.origin.x, cell.lblProverb.frame.origin.y, cell.lblProverb.frame.size.width, cellProverbStringSize.height);
//
//    CGSize cellMeaningStringSize = [strMeaning sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
//                                          constrainedToSize:maximumSize
//                                              lineBreakMode:UILineBreakModeWordWrap];
//    
////    CGRect cellMeaningFrame = CGRectMake(cell.lblMeaning.frame.origin.x, cell.lblProverb.frame.origin.y + 10, cell.lblMeaning.frame.size.width, cellMeaningStringSize.height);
//    
//
//    CGFloat cellHeight = cellProverbStringSize.height + cellMeaningStringSize.height + (CELL_CONTENT_MARGIN * 5);
//    DLog(@"heightForRowAtIndexPath cellHeight : %f", cellHeight);
////    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellHeight);
//    
//    CGFloat height = MAX(cellHeight, 44.0f);
//    
//    return height;
//}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //swipe했을때 에디팅 모드를 할지 안할지 결정한다.
    return UITableViewCellEditingStyleNone;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
