//
//  WebURL.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 2. 21..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "WebURL.h"
#import "myCommon.h"
#import "AddNewWebUrlViewController.h"

//@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
//- (void) setOrientation:(UIInterfaceOrientation)orientation;
//@end

@implementation WebURL

@synthesize viewBookmark, tblBookmark, arrBookmarks, strURL, selBookmarkIndex;
@synthesize strName, strFileNameBookmarksPlist;

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
	
	[self createBookmarksPlistIfNeeded];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:strFileNameBookmarksPlist];
	self.arrBookmarks = tmpArray;
	
	selBookmarkIndex = -1;
}


- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
}

-(void) back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)pickOne:(id)sender
{
	UISegmentedControl *sel = (UISegmentedControl *)sender;
	if( [sel selectedSegmentIndex] == 0 ){
		//네비게이션아이템으로부터 컨트롤을 받아온다.
		UIBarButtonItem *toAdd = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
		UISegmentedControl* segControl = (UISegmentedControl*)toAdd.customView;		
		
		if ([self.tblBookmark isEditing] == TRUE ) {
			[self.tblBookmark setEditing:NO animated:YES];	
			[segControl setTitle:@"Edit" forSegmentAtIndex:0];
		} else {
			[self.tblBookmark setEditing:YES animated:YES];
			[segControl setTitle:@"Done" forSegmentAtIndex:0];
		}
		
	} else 	if( [sel selectedSegmentIndex] == 1 ){
        
        selBookmarkIndex = -1;
        AddNewWebUrlViewController *controller = [[AddNewWebUrlViewController alloc] initWithNibName:@"AddNewWebUrlViewController" bundle:[NSBundle mainBundle]];
        controller.parentController = self;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController presentModalViewController:nav animated:YES];
	}
}

- (void) addBookmarkWithName:(NSString*)name andUrl:(NSString*)url
{
	NSDictionary *dicURLOne = [NSDictionary dictionaryWithObjectsAndKeys:name, @"Name", url, @"URL", nil];
	if (selBookmarkIndex == -1) {
		[arrBookmarks addObject:dicURLOne];
	} else {
		[arrBookmarks removeObjectAtIndex:selBookmarkIndex];
		[arrBookmarks insertObject:dicURLOne atIndex:selBookmarkIndex];
	}

	[self	saveBookmarks];
	[self.tblBookmark reloadData];
}

- (void) saveBookmarks
{
	if ([self.arrBookmarks writeToFile:strFileNameBookmarksPlist atomically:YES])
	{
		DLog(@"Did write : %@", strFileNameBookmarksPlist);
	}
	else
	{
		DLog(@"Failed to write : %@", strFileNameBookmarksPlist);
	}
	
}

//저장할 파일이 Documents 폴더에 있으면 그대로 쓰고 없으면 Main Bundle에서 복사한다. 
-(void) createBookmarksPlistIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	DLog(@"doc : %@", [myCommon getDocPath]);
	self.strFileNameBookmarksPlist = [[myCommon getDocPath] stringByAppendingPathComponent:@"bookmarks.plist"];
	BOOL dbExists = [fileManager fileExistsAtPath:strFileNameBookmarksPlist];
	DLog(@"strFileNameBookmarksPlist : %@", strFileNameBookmarksPlist);
	if(!dbExists)
	{
        NSString *strBookmarksList = @"bookmarks.plist";
#ifdef CHINESE
        strBookmarksList = @"bookmarksChinese.plist";
#endif
        
		NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:strBookmarksList];
		DLog(@"defaultDBPath : %@", defaultDBPath);
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:strFileNameBookmarksPlist error:&error];
		if (!success) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"	message:[NSString stringWithFormat:@"%@ : bookmarks.plist", NSLocalizedString(@"Can't copy file to Document folder", @"")]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
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
	return [self.arrBookmarks count];
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	NSDictionary *dicURLOne = [arrBookmarks objectAtIndex:indexPath.row];
	cell.textLabel.text = [dicURLOne objectForKey:@"Name"];
	cell.detailTextLabel.text = [dicURLOne objectForKey:@"URL"];
	cell.detailTextLabel.numberOfLines = 2;
    return cell;	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	DLog(@"indexPath.row : %d", indexPath.row);
	DLog(@"arrBookmarks : %@", arrBookmarks);
	DLog(@"strURL : %@", strURL);
	NSDictionary *dicURLOne = [arrBookmarks objectAtIndex:indexPath.row];
	DLog(@"dicURLOne : %@", [dicURLOne objectForKey:@"URL"]);
//	NSString *strURLTemp = [NSString stringWithFormat:@"%@", [dicURLOne objectForKey:@"URL"]];
//	DLog(@"strURLTemp : %@", strURLTemp);
//	[strURL setString:strURLTemp];
	//해결질문) web에서 바로 북마크로 오지 않고 본문내용으로 같다가 북마크로와서 선택하면 아래가 죽는다... 이유) nsmutablestring에 setstring이 아니고 그냥 string을 대입하면 mutablestring의 성질을 버리고 string으로 되기 때문에 setString에서 죽는다...
	[strURL setString:[dicURLOne objectForKey:@"URL"]];
	[self.navigationController popViewControllerAnimated:YES];

	
}
//테이블 셀의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.arrBookmarks count] == 1) {
            UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Can't delete selected bookmark.\nYou need to have more than one Boookmark.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert2 show];
        } else {
            [self.arrBookmarks removeObjectAtIndex:indexPath.row];
        }
	} 
	[self saveBookmarks];
	[self.tblBookmark reloadData];
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
	id toMove = [self.arrBookmarks objectAtIndex:fromIndexPath.row];
	[self.arrBookmarks removeObjectAtIndex:fromIndexPath.row];
	[self.arrBookmarks insertObject:toMove atIndex:toIndexPath.row];
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