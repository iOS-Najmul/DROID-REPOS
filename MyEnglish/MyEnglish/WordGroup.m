//
//  WordGroup.m
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 3. 7..
//  Copyright (c) 2012 dalnimSoft. All rights reserved.
//

#import "WordGroup.h"
#import "myCommon.h"
#import "DicListController.h"
#import "SVProgressHUD.h"

@implementation WordGroup

@synthesize intDicListType, arrWordGroup;
@synthesize tblOne;
@synthesize blnLoadWordGroup, intBookTblNo, strAllContentsInFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
    arrWordGroup = [[NSMutableArray	alloc] init];
    
    NSMutableDictionary *dicLevelNotInDic = [[NSMutableDictionary alloc] init];
    [dicLevelNotInDic setObject:NSLocalizedString(@"Original", @"") forKey:@"SegConSelIndex"];    
    [dicLevelNotInDic setObject:[NSNumber numberWithInt:0] forKey:@"NotRated"];    
    [dicLevelNotInDic setObject:[NSNumber numberWithInt:0] forKey:@"Unknown"];    
    [dicLevelNotInDic setObject:[NSNumber numberWithInt:0] forKey:@"NotSure"];    
    [dicLevelNotInDic setObject:[NSNumber numberWithInt:0] forKey:@"Known"];    
    [dicLevelNotInDic setObject:[NSNumber numberWithInt:0] forKey:@"Exclude"];        
    [dicLevelNotInDic setObject:NSLocalizedString(@"Not in the Dictionary", @"") forKey:@"LEVEL"];    
    [arrWordGroup addObject:dicLevelNotInDic];

    
    for (NSInteger i = 1; i < 18; i++)
    {
        NSMutableDictionary *dicLevel1 = [[NSMutableDictionary alloc] init];
        [dicLevel1 setObject:NSLocalizedString(@"Original", @"") forKey:@"SegConSelIndex"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"NotRated"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Unknown"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"NotSure"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Known"];    
        [dicLevel1 setObject:[NSNumber numberWithInt:0] forKey:@"Exclude"];        
        [dicLevel1 setObject:[NSString stringWithFormat:@"%d", i] forKey:@"LEVEL"];    
        [arrWordGroup addObject:dicLevel1];
    }
    
    NSMutableDictionary *dicLevelNotInLevel = [[NSMutableDictionary alloc] init];
    [dicLevelNotInLevel setObject:NSLocalizedString(@"Original", @"") forKey:@"SegConSelIndex"];    
    [dicLevelNotInLevel setObject:[NSNumber numberWithInt:0] forKey:@"NotRated"];    
    [dicLevelNotInLevel setObject:[NSNumber numberWithInt:0] forKey:@"Unknown"];    
    [dicLevelNotInLevel setObject:[NSNumber numberWithInt:0] forKey:@"NotSure"];    
    [dicLevelNotInLevel setObject:[NSNumber numberWithInt:0] forKey:@"Known"];    
    [dicLevelNotInLevel setObject:[NSNumber numberWithInt:0] forKey:@"Exclude"];        
    [dicLevelNotInLevel setObject:NSLocalizedString(@"> Group", @"") forKey:@"LEVEL"];    
    [arrWordGroup addObject:dicLevelNotInLevel];
    
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self getWordGroup:nil];
    
    self.navigationItem.title = NSLocalizedString(@"By Word Group", @"");
}

-(IBAction) back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


- (void) getWordGroup:(NSTimer *)sender
{
    DLog(@"Before arrSetLevel : %@", arrWordGroup);

    NSString *strTblName = @"";
    NSInteger openMyEnglish = OPEN_DIC_DB;
    if (intBookTblNo > 0) {
        strTblName = [NSString stringWithFormat:@"%@", TBL_EngDic];
        openMyEnglish = OPEN_DIC_DB_BOOK;        
    } else {
        strTblName = [NSString stringWithFormat:@"%@", TBL_EngDic_BookTemp];
        openMyEnglish = OPEN_DIC_DB;                
    }
    NSString *strQuery1 = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d", strTblName, FldName_Know, KnowWord_NotInDic];			
    NSInteger cntOfWordsNotInDic = [myCommon GetCountFromTbl:strQuery1 openMyDic:openMyEnglish];
    NSMutableDictionary *dicLvlTemp1 = [arrWordGroup objectAtIndex:0];
    [dicLvlTemp1 setObject:[NSNumber numberWithInt:cntOfWordsNotInDic] forKey:@"NoOfWords"];
    
    NSInteger intAllLevel = [arrWordGroup count];
    for (NSInteger i = 1; i < intAllLevel; i++) {
        NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d", strTblName, FldName_WORDLEVEL1, i];			
        if (i == (intAllLevel -1)) {
            strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d", strTblName, FldName_WORDLEVEL1, intAllLevel];
        }
        NSInteger cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        NSMutableDictionary *dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NoOfWords"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, i, FldName_Know, KnowWord_NotRated];			
        if (i == (intAllLevel -1)) {
            strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, intAllLevel, FldName_Know, KnowWord_NotRated];
        }

        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NotRated"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, i, FldName_Know, KnowWord_Unknown];			
        if (i == (intAllLevel -1)) {
            strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, intAllLevel, FldName_Know, KnowWord_Unknown];
        }
        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Unknown"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, i, FldName_Know, KnowWord_NotSure];			
        if (i == (intAllLevel -1)) {
            strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, intAllLevel, FldName_Know, KnowWord_NotSure];
        }
        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"NotSure"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, i, FldName_Know, KnowWord_Known];			
        if (i == (intAllLevel -1)) {
            strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d and %@ = %d ", strTblName, FldName_WORDLEVEL1, intAllLevel, FldName_Know, KnowWord_Known];
        }
        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Known"];
        
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ where %@ = %d and %@ > %d ", strTblName, FldName_WORDLEVEL1, i, FldName_Know, KnowWord_Known];	
        if (i == (intAllLevel -1)) {
            strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ where %@ > %d and %@ > %d ", strTblName, FldName_WORDLEVEL1, intAllLevel, FldName_Know, KnowWord_Known];
        }        
        cntOfWordsLvlTemp = [myCommon GetCountFromTbl:strQuery openMyDic:openMyEnglish];
        dicLvlTemp = [arrWordGroup objectAtIndex:i];
        [dicLvlTemp setObject:[NSNumber numberWithInt:cntOfWordsLvlTemp] forKey:@"Exclude"];
    }

    DLog(@"After arrSetLevel : %@", arrWordGroup);
    [self.tblOne reloadData];
    
    [SVProgressHUD dismiss];
    
    blnLoadWordGroup = TRUE;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrWordGroup count];
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    
    NSDictionary *dicOne = [self.arrWordGroup objectAtIndex:indexPath.row];
    DLog(@"dicOne : %@", dicOne);
    NSString *strLevel = [dicOne objectForKey:@"LEVEL"];
    NSInteger noOfWords = [[dicOne objectForKey:@"NoOfWords"] integerValue];
    NSInteger intNotRated = [[dicOne objectForKey:@"NotRated"] integerValue];
    NSInteger intUnknown = [[dicOne objectForKey:@"Unknown"] integerValue];
    NSInteger intNotSure = [[dicOne objectForKey:@"NotSure"] integerValue];
    NSInteger intKnown = [[dicOne objectForKey:@"Known"] integerValue];
    NSInteger intExclude = [[dicOne objectForKey:@"Exclude"] integerValue];
    
    NSString *strCount = [myCommon  GetFormattedNumber:noOfWords];	
    NSInteger percentOfKnown = (float)(intKnown + intExclude) / noOfWords * 100;
    if (noOfWords == 0) {
        percentOfKnown = 0;
    }
    DLog(@"percentOfKnown : %d", percentOfKnown);
    if ([strLevel isEqualToString:NSLocalizedString(@"Not in the Dictionary", @"")] == TRUE) {
        cell.textLabel.text = NSLocalizedString(@"Not in the Dictionary", @"");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",strCount, NSLocalizedString(@"Words", @"")]; 
    } else {
        if ([strLevel isEqualToString:NSLocalizedString(@"> Group", @"")] == FALSE) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ : (%@ %@, %d%%)", NSLocalizedString(@"Group", @""), strLevel, strCount, NSLocalizedString(@"Words", @""), percentOfKnown];                          
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ : (%@ %@, %d%%)", strLevel, strCount, NSLocalizedString(@"Words", @""), percentOfKnown];  
        }
        NSString *strCountNotRated = [myCommon  GetFormattedNumber:intNotRated];	
        NSString *strCountUnknown = [myCommon  GetFormattedNumber:intUnknown];	
        NSString *strCountNotSure = [myCommon  GetFormattedNumber:intNotSure];	
        NSString *strCountKnown = [myCommon  GetFormattedNumber:intKnown];	
        NSString *strCountExlude = [myCommon  GetFormattedNumber:intExclude];	
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"NR(%@), X(%@) ?(%@), !(%@), -(%@)\n\n\n", strCountNotRated,strCountUnknown,strCountNotSure,strCountKnown,strCountExlude]; 
    }
//        cell.detailTextLabel.numberOfLines = 5;
       
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    
    DLog(@"indexPath : %d", indexPath.row);
    // 타이머를 이용한 함수호출 (aiv가 안떠서 이렇게 했다...)
    [SVProgressHUD showProgress:-1 status:@""];
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(openDicList:)
                                   userInfo:[NSNumber numberWithInt:indexPath.row]
                                    repeats:NO];
    
}
//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (void) openDicList:(NSTimer *)sender
{
    NSInteger row = [[sender userInfo] integerValue];
    DicListController *dicListController = [[DicListController alloc] initWithNibName:@"DicListController" bundle:nil];
    dicListController.intDicWordOrIdiom = DicWordOrIdiom_Word;    
    dicListController.intDicListType = intDicListType;
    dicListController.intBookTblNo = self.intBookTblNo;    

    if (row == 0) {
        dicListController.blnUseKnowButton = FALSE;
    } else {
        dicListController.blnUseKnowButton = TRUE;
    }
    
    if (row >= ([arrWordGroup count] - 1)) {
        dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" %@ > %d ", FldName_WORDLEVEL1, row - 1];        
    } else {
        dicListController.strWhereClauseFldSQL = [NSString stringWithFormat:@" %@ = %d ", FldName_WORDLEVEL1, row];
    }

    dicListController.strAllContentsInFile = strAllContentsInFile;
        //        }
        blnLoadWordGroup = FALSE;       
    
	[self.navigationController pushViewController:dicListController animated:YES];
    
    [SVProgressHUD dismiss];
    
}


@end
