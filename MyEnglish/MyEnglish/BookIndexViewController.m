/*
 * (C) Copyright 2010, Stefan Arentz, Arentz Consulting.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "BookIndexViewController.h"
#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigesterSetNextRule.h"
#import "XMLDigesterCallMethodWithAttributeRule.h"
#import "OCFContainer.h"
#import "OCFRootFile.h"
#import "NCXNavigationDefinition.h"
#import "NCXNavigationPoint.h"
#import "BookContentViewController.h"

@implementation BookIndexViewController


@synthesize fileName = fileName_;

- (id) initWithBook: (NSString *) filenameEbook
{
    if ((self = [super initWithStyle: UITableViewStylePlain]) != nil) {		
		self.fileName = filenameEbook;
		navigationDefinition_ = [self parseNavigationDefinitionWithBook: filenameEbook];
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook: (NSString *) bookFileName
{
	//DLog(@"==========parseNavigationDefinitionWithBook====%@===", bookFileName);
			
	// Parse the navigation definition
	
	// TODO: We should really take the location of the toc from the OEPBSPackage - For a demo this works
	NSString* ncxPath = [NSString stringWithFormat: @"%@/%@/OEBPS/toc.ncx", 
						 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], 
						 bookFileName];
	//DLog(@"==ncxPath========%@===", ncxPath); //@"%@/%@/OPS/toc.ncx"
	DLog(@"==ncxPath========%@===", ncxPath); //@"%@/%@/OPS/toc.ncx"
	NSData* ncxData = [NSData dataWithContentsOfFile: ncxPath];
	
	XMLDigester *digester = [XMLDigester digesterWithData: ncxData];
	
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationDefinition class]] forPattern: @"ncx"];
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationPoint class]] forPattern: @"ncx/navMap/navPoint"];
	[digester addCallMethodWithElementBodyRuleWithSelector: @selector(setLabel:) forPattern: @"ncx/navMap/navPoint/navLabel/text"];
	[digester addRule: [XMLDigesterCallMethodWithAttributeRule callMethodWithAttributeRuleWithDigester: digester selector: @selector(setContent:) attribute: @"src"] forPattern: @"ncx/navMap/navPoint/content"];
	[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addNavigationPoint:)] forPattern: @"ncx/navMap/navPoint"];
	
	NCXNavigationDefinition* navigationDefinition = [digester digest];	
	
	return navigationDefinition;
}

- (NSString *) parseTitleWithBook: (NSString *) bookFileName
{	
	// Parse the navigation definition
	
	// TODO: We should really take the location of the toc from the OEPBSPackage - For a demo this works
	NSString* ncxPath = [NSString stringWithFormat: @"%@/%@/toc.ncx", 
						 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], 
						 bookFileName];
	//DLog(@"==ncxPath========%@===", ncxPath); //@"%@/%@/OPS/toc.ncx"
	
	NSData* ncxData = [NSData dataWithContentsOfFile: ncxPath];
	
	XMLDigester* digester = [XMLDigester digesterWithData: ncxData];	
	
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationDefinition class]] forPattern: @"ncx"];
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationPoint class]] forPattern: @"ncx/docTitle"];
	[digester addCallMethodWithElementBodyRuleWithSelector: @selector(setLabel:) forPattern: @"ncx/docTitle/text"];	
	[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addNavigationPoint:)] forPattern: @"ncx/docTitle"];
	
	NCXNavigationDefinition* navigationDefinition = [digester digest];
	NCXNavigationPoint* navigationPoint = [navigationDefinition.navigationPoints objectAtIndex:0];
	NSString* ncxTitle = [NSString stringWithFormat: @"%@", navigationPoint.label];
	
	return ncxTitle;
}

#pragma mark -

- (void) close
{
	[self dismissModalViewControllerAnimated: YES];
}

- (void) viewDidLoad
{	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.title = [self parseTitleWithBook: self.fileName];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"뒤로" style: UIBarButtonItemStylePlain target: self action: @selector(close)] autorelease];
	DLog(@"===title : %@", self.title);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return [navigationDefinition_.navigationPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
    static NSString *CellIdentifier = @"BookIndexViewControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];
	cell.textLabel.text = navigationPoint.label;
	
    return cell;
}

- (void)tableView: (UITableView*) tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
	NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];
	
	BookContentViewController* bookContentViewController = [[BookContentViewController alloc] initWithBook: self.fileName navigationPoint: navigationPoint];
	if (bookContentViewController != nil) {
		[self.navigationController pushViewController: bookContentViewController animated: YES];
		[bookContentViewController release];
	}
}

@end