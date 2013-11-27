//
//  OptionsViewController.m
//  MyEnglish
//
//  Created by Najmul Hasan on 10/6/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController (){

    IBOutlet UITableView *myTableView;
    NSArray *options;
}
@end

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    options = @[@"Book",
                @"WebBrowser",
                @"Dictionary",
                @"My Level",
                @"Movie",
                @"Send Mail",
                @"Facebook",
                @"Twitter"];
    
    self.title = @"My English";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [options count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplicationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
	
//    [cell setSelected:[[NSUserDefaults standardUserDefaults] integerForKey:@"SELECTED_OPTION"]];
    cell.textLabel.text = options[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedOption = indexPath.row;

    int rowNo = [[NSUserDefaults standardUserDefaults] integerForKey:@"SELECTED_OPTION"];
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNo inSection:0]];
    [cell setSelected:NO];
    
    [self.delegate didSelectedOption:self];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    int rowNo = [[NSUserDefaults standardUserDefaults] integerForKey:@"SELECTED_OPTION"];
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNo inSection:0]];
    [cell setSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
