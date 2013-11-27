//
//  WebDicListController.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 3. 26..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "WebDicListController.h"
#import "AddNewDictViewController.h"
#import "myCommon.h"

//@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
//- (void) setOrientation:(UIInterfaceOrientation)orientation;
//@end

@implementation WebDicListController

@synthesize viewWebDicList, tblWebDicList, arrWebDicLists, strURL;
@synthesize strName, strFileNameWebDicListsPlist;

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
	
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
    
	UISegmentedControl* segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 100, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:0 animated:YES];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Add", @"") atIndex:1 animated:YES];
	segControl.momentary = TRUE;
	segControl.selectedSegmentIndex = -1;
	segControl.tag = 0;
	[segControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.rightBarButtonItem = toAdd;	

	selWebDicListIndex = -1;
}

-(IBAction) back {
	
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	[self createWebDicListPlistIfNeeded];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:strFileNameWebDicListsPlist];
	self.arrWebDicLists = tmpArray;
}

- (void)pickOne:(id)sender
{
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
		//네비게이션아이템으로부터 컨트롤을 받아온다.
		UIBarButtonItem *toAdd = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
		UISegmentedControl* segControl = (UISegmentedControl*)toAdd.customView;		
		
		if ([self.tblWebDicList isEditing] == TRUE ) {
			[self.tblWebDicList setEditing:NO animated:YES];	
			[segControl setTitle:NSLocalizedString(@"Edit", @"") forSegmentAtIndex:0];
		} else {
			[self.tblWebDicList setEditing:YES animated:YES];
			[segControl setTitle:NSLocalizedString(@"Done", @"") forSegmentAtIndex:0];
		}
        
	} else 	if( [sel selectedSegmentIndex] == 1 ){
        
        selWebDicListIndex = -1;
        AddNewDictViewController *controller = [[AddNewDictViewController alloc] initWithNibName:@"AddNewDictViewController" bundle:[NSBundle mainBundle]];
        controller.parentController = self;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController presentModalViewController:nav animated:YES];
	}
}

- (void) addBookmarkWithName:(NSString*)name andUrl:(NSString*)url
{	
	NSMutableDictionary *dicURLOne = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"Name", url, @"URL", [NSNumber numberWithInt:1], @"ON", nil];
	if (selWebDicListIndex == -1) {
		[arrWebDicLists addObject:dicURLOne];
	} else {
    
		[arrWebDicLists removeObjectAtIndex:selWebDicListIndex];
		[arrWebDicLists insertObject:dicURLOne atIndex:selWebDicListIndex];
	}
	
	[self	saveBookmarks];
    [self.tblWebDicList reloadData];
}

- (void) saveBookmarks
{
	if ([self.arrWebDicLists writeToFile:strFileNameWebDicListsPlist atomically:YES])
	{
		DLog(@"Did write : %@", strFileNameWebDicListsPlist);
	}
	else
	{
		DLog(@"Failed to write : %@", strFileNameWebDicListsPlist);
    }
}

//저장할 파일이 Documents 폴더에 있으면 그대로 쓰고 없으면 Main Bundle에서 복사한다.
-(void) createWebDicListPlistIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	DLog(@"doc : %@", [myCommon getDocPath]);
	self.strFileNameWebDicListsPlist = [[myCommon getDocPath] stringByAppendingPathComponent:@"webDicList.plist"];
	BOOL dbExists = [fileManager fileExistsAtPath:strFileNameWebDicListsPlist];
	DLog(@"strFileNameBookmarksPlist : %@", strFileNameWebDicListsPlist);
	if(!dbExists)
	{
		NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"webDicList.plist"];
		DLog(@"defaultDBPath : %@", defaultDBPath);
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:strFileNameWebDicListsPlist error:&error];
		if (!success) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:@"%@ : webDicList.plist",NSLocalizedString(@"Can't copy file to Document folder", @"")]   delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert show];
		}
	}
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView1 {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView1 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.arrWebDicLists count];
}

static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	NSDictionary *dicURLOne = [arrWebDicLists objectAtIndex:indexPath.row];

    //버전1.2_업데이트] 한방검색에 사용되는 사전을 사용할지 여부를 선택함
    UISwitch *switchOne = [[UISwitch alloc] initWithFrame:CGRectMake(200, 5, 120, 60)];
    NSInteger intOn = [[dicURLOne objectForKey:@"ON"] integerValue];  
    if (intOn == 0) {
        [switchOne setOn:NO animated:NO];
    } else {
        [switchOne setOn:YES animated:NO];				
    }
    
    [switchOne addTarget:self action:@selector(selSwitch:event:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchOne;
    
	cell.textLabel.text = [dicURLOne objectForKey:@"Name"];    
	cell.detailTextLabel.text = [dicURLOne objectForKey:@"URL"];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;	
}

//==============================================
//버전1.2_업데이트] 한방검색에 사용되는 사전을 사용할지 여부를 선택함. 최소 1개는 있어야함.
-(void) selSwitch:(id)sender event:(id)event
{
	UISwitch *switchOne = (UISwitch*)sender;
	//현재선택한 셀의 줄을 가져온다.
    
    UITableViewCell *cell = (UITableViewCell*)[sender superview];
    NSIndexPath *indexPath = [tblWebDicList indexPathForCell:cell];
    
    NSMutableDictionary *dicOne     = [self.arrWebDicLists objectAtIndex:indexPath.row];
 
    if (switchOne.on) {
        [dicOne setValue:[NSNumber numberWithInt:1] forKey:@"ON"];
    } else {			
        [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"ON"];            
    }
    
    NSInteger cntOfON = 0;
    for (NSDictionary *dicOne in arrWebDicLists) {
        NSInteger intOn = [[dicOne objectForKey:@"ON"] integerValue];  
        if (intOn == 1) {
            cntOfON++;
        }
    }
    
    if ((cntOfON < 1) && (switchOne.on == FALSE))  {        
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"You need to set on more than one web dictionary site.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert2 show];
        [dicOne setValue:[NSNumber numberWithInt:1] forKey:@"ON"];
        switchOne.on = TRUE;
    }
    
    [arrWebDicLists replaceObjectAtIndex:indexPath.row withObject:dicOne];
    [self	saveBookmarks];
}
//==============================================

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	
	NSDictionary *dicURLOne = [arrWebDicLists objectAtIndex:indexPath.row];
	[self.strURL setString:[dicURLOne objectForKey:@"URL"]];

    selWebDicListIndex = indexPath.row;
	
    AddNewDictViewController *controller = [[AddNewDictViewController alloc] initWithNibName:@"AddNewDictViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:nav animated:YES completion:^{
        controller.txtFldURL.text = [dicURLOne objectForKey:@"URL"];
        controller.txtFldName.text = [dicURLOne objectForKey:@"Name"];
        controller.parentController = self;
    }];
}
//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.arrWebDicLists count] == 1) {
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Can't delete selected web dictionary.\nYou need to have more than one Web Dictionary.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
			[alert2 show];
        } else {
            [self.arrWebDicLists removeObjectAtIndex:indexPath.row];
        }
	} 
	[self saveBookmarks];
	[self.tblWebDicList reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

#pragma mark -
#pragma mark 테이블 뷰 이동
-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath*) indexPath
{
	return YES;
}

-(void) tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
	id toMove = [self.arrWebDicLists objectAtIndex:fromIndexPath.row];
	[self.arrWebDicLists removeObjectAtIndex:fromIndexPath.row];
	[self.arrWebDicLists insertObject:toMove atIndex:toIndexPath.row];
	[self saveBookmarks];
}

#pragma mark -
#pragma mark End
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


@end
