//
//  MovieSelectorController.m
//  MyListPro
//
//  Created by 김형달 on 10. 11. 8..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import "SelectorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BookViewController.h"
#import "BookSelectCell.h"
#import "myCommon.h"
#import "MakeABook.h"
#import "ZipArchive.h"
#import "XMLHandler.h"
#import "SVProgressHUD.h"

//#import "BookIndexViewController.h"

#define cntOfBookLiteMode 25
@implementation SelectorViewController


@synthesize ePubDirName, ePubDirPath;
@synthesize _ePubContent;
@synthesize _rootPath;
@synthesize _strFileName;
@synthesize _xmlHandler;
@synthesize _pagesPath, _arrEPubChapter;
@synthesize _pageNumber;


@synthesize fm;
@synthesize arrDocList, tblView;
@synthesize txtUserName, txtPass, segControl;
@synthesize blnAlphabet, blnDifficulty, blnVolumes, intBeforeSegSelectedIndex, blnBookHasPage;
@synthesize arrBooksDefault, blnDefaultBooks;
@synthesize intMovieSelectorSourceMode;
@synthesize arrMovieList, arrMovieScriptTxtList, strMovieScriptFileName;
@synthesize btnAddBook, segAddAndEdit, segEditOnly, blnSegEditOnly;
@synthesize alertViewProgress;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [myCommon closeDB:true];
    [myCommon openDB:true];

	[[self navigationController] setNavigationBarHidden:NO animated:YES];
    
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	
    fm = [NSFileManager defaultManager];

	segAddAndEdit = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 80, 30)];
	[segAddAndEdit insertSegmentWithTitle:@"+" atIndex:0 animated:YES];
	[segAddAndEdit insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:1 animated:YES];
	segAddAndEdit.tag = 2;
	segAddAndEdit.selectedSegmentIndex = -1;
	segAddAndEdit.momentary = true;  
	[segAddAndEdit addTarget:self action:@selector(selSegAddAndEdit:) forControlEvents:UIControlEventValueChanged];
	segAddAndEdit.segmentedControlStyle = UISegmentedControlStyleBar;
    blnSegEditOnly = FALSE;
    
    segEditOnly = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 60, 30)];
	[segEditOnly insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:0 animated:YES];
	segEditOnly.tag = 3;
	segEditOnly.selectedSegmentIndex = -1;
	segEditOnly.momentary = true;  
	[segEditOnly addTarget:self action:@selector(selSegAddAndEdit:) forControlEvents:UIControlEventValueChanged];
	segEditOnly.segmentedControlStyle = UISegmentedControlStyleBar;
    blnSegEditOnly = TRUE;
    
	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segAddAndEdit];
	self.navigationItem.rightBarButtonItem = toAdd;
    
    arrDocList = [[NSMutableArray alloc] init];
	arrBooksDefault = [[NSMutableArray alloc] init];
    
    arrMovieList  = [[NSMutableArray alloc] init];
    arrMovieScriptTxtList  = [[NSMutableArray alloc] init];
    strMovieScriptFileName = [[NSString alloc] init];
    
    blnDefaultBooks = FALSE;
    blnAlphabet = TRUE;
    blnDifficulty = FALSE;
    blnVolumes = TRUE;
    intBeforeSegSelectedIndex = 0;
    
	segControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 210, 30)];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Title", @"") atIndex:0 animated:YES];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Difficulty", @"") atIndex:1 animated:YES];
	[segControl insertSegmentWithTitle:NSLocalizedString(@"Size", @"") atIndex:2 animated:NO];
	segControl.tag = 1;
	segControl.selectedSegmentIndex = -1;
	segControl.momentary = true;  
	[segControl addTarget:self action:@selector(selSegControl:) forControlEvents:UIControlEventValueChanged];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.navigationItem.titleView = segControl;		
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tblView setEditing:NO animated:YES];	
    
    segControl.selectedSegmentIndex = intBeforeSegSelectedIndex;
    DLog(@"blnBooksDefault : %d", blnDefaultBooks);
    DLog(@"intMovieSelectorSourceMode : %d", intMovieSelectorSourceMode);
    if (intMovieSelectorSourceMode == MovieSelectorSourceModeMovie) {
        [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                         target:self
                                       selector:@selector(getMovieList:)
                                       userInfo:nil
                                        repeats:NO];
    } else {

#ifdef ENGLISH
            if (blnDefaultBooks == TRUE) {
                [self getDefaultBookList];
            } else {
                [self getBookList];
            }
#else
        [self getBookList];
#endif
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void) back {
    if (blnDefaultBooks == TRUE) {

        segAddAndEdit = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 80, 30)];
        [segAddAndEdit insertSegmentWithTitle:@"+" atIndex:0 animated:YES];
        [segAddAndEdit insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:1 animated:YES];
        segAddAndEdit.tag = 2;
        segAddAndEdit.selectedSegmentIndex = -1;
        segAddAndEdit.momentary = true;  
        [segAddAndEdit addTarget:self action:@selector(selSegAddAndEdit:) forControlEvents:UIControlEventValueChanged];
        segAddAndEdit.segmentedControlStyle = UISegmentedControlStyleBar;
        blnSegEditOnly = FALSE;
        
        segEditOnly = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 60, 30)];
        [segEditOnly insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:0 animated:YES];
        segEditOnly.tag = 3;
        segEditOnly.selectedSegmentIndex = -1;
        segEditOnly.momentary = true;  
        [segEditOnly addTarget:self action:@selector(selSegAddAndEdit:) forControlEvents:UIControlEventValueChanged];
        segEditOnly.segmentedControlStyle = UISegmentedControlStyleBar;
        blnSegEditOnly = TRUE;
        
        UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segAddAndEdit];
        self.navigationItem.rightBarButtonItem = toAdd;		
 
        blnDefaultBooks = FALSE;
        [self getBookList];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tblView cache:YES];
        [UIView commitAnimations];	
        
        [self.tblView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) getDefaultBookList
{
    [self.arrDocList removeAllObjects];
	[self.arrBooksDefault removeAllObjects];    

    NSMutableDictionary *dicEnv  = [[NSMutableDictionary alloc] init];
    [myCommon getEnvFromTbl:dicEnv];    
    
    NSMutableArray *arrText = [[NSMutableArray alloc] init];
    
    [arrText addObject:@"Anna Eleanor Roosevelt_Adopting the Declaration of Human Rights"];
    [arrText addObject:@"Anna Eleanor Roosevelt_The Struggle for Human Rights"];
    [arrText addObject:@"Edward Moore Kennedy_1980 DNC Address"];
    [arrText addObject:@"Edward Moore Kennedy_Chappaquiddick"];
    [arrText addObject:@"Edward Moore Kennedy_Eulogy for Robert Francis Kennedy"];
    [arrText addObject:@"Edward Moore Kennedy_Truth and Tolerance in America"];
    [arrText addObject:@"Franklin Delano Roosevelt_Commonwealth Club Address"];
    [arrText addObject:@"George Catlett Marshall_The Marshall Plan"];
    [arrText addObject:@"Gerald Rudolph Ford_Address on Taking the Oath of Office"];
    [arrText addObject:@"Gerald Rudolph Ford_National Address Pardoning Richard M. Nixon"];
    [arrText addObject:@"Henry Louis Gehrig_Farewell to Baseball Address"];
    [arrText addObject:@"Abraham Lincoln - The Gettysburg Address"];  
    [arrText addObject:@"Barack Obama's Presidential Inaugural Address"];
    [arrText addObject:@"Barack Obama's Victory Speech"];          
    [arrText addObject:@"Franklin Delano Roosevelt_First Fireside Chat"];    
    [arrText addObject:@"Franklin Delano Roosevelt_First Inaugural Address "];    
    [arrText addObject:@"Franklin Delano Roosevelt_Pearl Harbor Address to the Nation"];    
    [arrText addObject:@"Franklin Delano Roosevelt_The Arsenal of Democracy"];
    [arrText addObject:@"Franklin Delano Roosevelt_The Four Freedoms"];    
    //    [arrText addObject:@"Harry S. Truman_The Truman Doctrine"];  
    [arrText addObject:@"Hillary Diane Rodham Clinton_Women's Rights are Human Rights"];
    [arrText addObject:@"Huey Pierce Long_Every Man a King"];
    
    [arrText addObject:@"Jesse Louis Jackson_1984 DNC Address"];      
    [arrText addObject:@"Jimmy Earl Carter_A Crisis of Confidence"];
    [arrText addObject:@"John Fitzgerald Kennedy_American University Commencement Address"];
    [arrText addObject:@"John Fitzgerald Kennedy_Civil Rights Address"];
    [arrText addObject:@"John Fitzgerald Kennedy_Cuban Missile Crisis Address"];
    [arrText addObject:@"John Fitzgerald Kennedy_Houston Ministerial Association Speech"];    
    [arrText addObject:@"John Fitzgerald Kennedy_Ich bin ein Berliner"];    
    [arrText addObject:@"John Fitzgerald Kennedy_Inaugural Address"];    
    //    [arrText addObject:@"John Llewellyn Lewis_The Rights of Labor"];
    //    [arrText addObject:@"Joseph N. Welch_Have You No Sense of Decency"];    
    [arrText addObject:@"Lyndon Baines Johnson_Let Us Continue"];
    [arrText addObject:@"Lyndon Baines Johnson_On Vietnam and Not Seeking Re-Election"];
    [arrText addObject:@"Lyndon Baines Johnson_The Great Society"];
    [arrText addObject:@"Lyndon Baines Johnson_We Shall Overcome"];        
    //    [arrText addObject:@"Mary Fisher_A Whisper of AIDS"];    
    [arrText addObject:@"Malcolm X_The Ballot or the Bullet"];        
    [arrText addObject:@"Malcolm X_Message to the Grassroots"];    
    [arrText addObject:@"Margaret Chase Smith_Declaration of Conscience"];
    [arrText addObject:@"Margaret Higgins Sanger_Children's Era"]; 
    [arrText addObject:@"Margaret Higgins Sanger_The Morality of Birth Control"];    
    //    [arrText addObject:@"Mario Matthew Cuomo_1984 DNC Keynote Address"];    
    //    [arrText addObject:@"Mario Matthew Cuomo_Religious Belief and Public Morality"];
    //    [arrText addObject:@"Mario Savio_Sproul Hall Sit-in Speech An End to History"];
    [arrText addObject:@"Martin Luther King, Jr_I Have a Dream"];    
    [arrText addObject:@"Martin Luther King, Jr._I've Been to the Mountaintop"]; 
    [arrText addObject:@"Martin Luther King, Jr._A Time to Break Silence"];
    [arrText addObject:@"Mary Church Terrell_What it Means to be Colored in the...U.S."];   
    //    [arrText addObject:@"Newton Norman Minow_Television and the Public Interest"];
    //    [arrText addObject:@"Richard Milhous Nixon_Cambodian Incursion Address"];
    //    [arrText addObject:@"Richard Milhous Nixon_Checkers"];    
    //    [arrText addObject:@"Richard Milhous Nixon_Resignation Speech"];
    //    [arrText addObject:@"Richard Milhous Nixon_The Great Silent Majority"];    
    //    [arrText addObject:@"Robert Francis Kennedy_Remarks on the Assassination of MLK"];    
    //    [arrText addObject:@"Robert Marion La Follette_Free Speech in Wartime"];
    [arrText addObject:@"Ronald Wilson Reagan_40th Anniversary of D-Day Address"];
    [arrText addObject:@"Ronald Wilson Reagan_A Time for Choosing"];
    [arrText addObject:@"Ronald Wilson Reagan_Brandenburg Gate Address"];    
    [arrText addObject:@"Ronald Wilson Reagan_First Inaugural Address"];
    [arrText addObject:@"Ronald Wilson Reagan_Shuttle Challenger Disaster Address "];        
    [arrText addObject:@"Ronald Wilson Reagan_The Evil Empire"];
    //    [arrText addObject:@"Russell H. Conwell_Acres of Diamonds"];
    //    [arrText addObject:@"Shirley Anita St. Hill Chisholm_For the Equal Rights Amendment"];    
    //    [arrText addObject:@"Spiro Theodore Agnew_Television News Coverage"];
    //    [arrText addObject:@"Stokely Carmichael_Black Power"];
    [arrText addObject:@"Theodore Roosevelt_The Man with the Muck-rake"];    
    [arrText addObject:@"Thomas Woodrow Wilson_First Inaugural Address"];
    [arrText addObject:@"Thomas Woodrow Wilson_For the League of Nations"];
    [arrText addObject:@"Thomas Woodrow Wilson_League of Nations Final Address"];
    [arrText addObject:@"Thomas Woodrow Wilson_National Address Pardoning Richard M. Nixon"];
    [arrText addObject:@"Thomas Woodrow Wilson_The Fourteen Points"];
    [arrText addObject:@"Thomas Woodrow Wilson_War Message"];    
    [arrText addObject:@"Ursula Kroeber Le Guin_A Left-Handed Commencement Address"];
    [arrText addObject:@"William Cuthbert Faulkner_Nobel Prize Acceptance Speech"]; 
    [arrText addObject:@"William Jefferson Clinton_Oklahoma Bombing Memorial Address"];    
    [arrText addObject:@"William Jennings Bryan_Against Imperialism"];    
    [arrText addObject:@"Winston Churchill - Blood, Toil, Tears and Sweat"];
    
    
    
    
    for (int i = 0; i < [arrText count]; ++i) {
        NSString *strFileNameWithouExt = [NSString stringWithFormat:@"%@", [arrText objectAtIndex:i]] ;
//        DLog(@"strFileNameWithouExt : %@", strFileNameWithouExt);        
        NSString *strFullFileName = [[NSBundle mainBundle] pathForResource:strFileNameWithouExt ofType:@"txt"];
//        DLog(@"strFileName : %@", strFullFileName);
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
        

        [myCommon getBookInfoFormTbl:dicOne fileName:[strFullFileName lastPathComponent]];
        DLog(@"dicOne : %@", dicOne);
        if ([[dicOne objectForKey:@"UniqueWords"] intValue] != 0) {
            float score = ((float)[[dicOne objectForKey:@"KnownWords"] intValue]/[[dicOne objectForKey:@"UniqueWords"] intValue]) * 100;
            //                DLog(@"score : %f", score);
            //                DLog(@"aaa : %f",  [[dicEnv objectForKey:@"Difficulty_VeryEasy"] floatValue]);
            if (score > [[dicEnv objectForKey:@"Difficulty_VeryEasy"] floatValue]) {
                [dicOne setValue:@"book_very_easy.png" forKey:@"imageName"];
                //                    [dicOne setValue:[NSNumber numberWithFloat:score] forKey:@"Difficulty"];
            } else if (score > [[dicEnv objectForKey:@"Difficulty_Easy"] floatValue]) {
                [dicOne setValue:@"book_easy.png" forKey:@"imageName"];
                //                    [dicOne setValue:@"2" forKey:@"Difficulty"];
            } else if (score > [[dicEnv objectForKey:@"Difficulty_Good"] floatValue]) {
                [dicOne setValue:@"book_good.png" forKey:@"imageName"];
                //                    [dicOne setValue:@"3" forKey:@"Difficulty"];
            } else if (score > [[dicEnv objectForKey:@"Difficulty_Hard"] floatValue]) {
                [dicOne setValue:@"book_hard.png" forKey:@"imageName"];
                //                    [dicOne setValue:@"4" forKey:@"Difficulty"];
            } else {
                [dicOne setValue:@"book_very_hard.png" forKey:@"imageName"];
                //                    [dicOne setValue:@"5" forKey:@"Difficulty"];
            } 
            [dicOne setValue:[NSNumber numberWithFloat:score] forKey:@"Difficulty"];
            //                DLog(@"file : %@", dicOne);
        } else  {
            [dicOne setValue:@"book_unknown.png" forKey:@"imageName"];
            //난이도순으로 정렬할때르 대비에서 -1로주고 화면표시시에는 0으로 해준다.
            [dicOne setValue:[NSNumber numberWithFloat:-1.0f] forKey:@"Difficulty"];
        }
        
        NSDictionary *attrs = [fm attributesOfItemAtPath:strFullFileName error: NULL];
        UInt32 txtFileSize = [attrs fileSize];
        [dicOne setValue:[NSNumber numberWithLongLong:txtFileSize] forKey:@"fileSize"];
        [dicOne setValue:strFullFileName forKey:@"FullFileName"];
        
        [self.arrBooksDefault addObject:dicOne];
    }
    
    [self selSegControl:segControl];
    [tblView reloadData];
}

- (void) getBookList
{
    [self.arrDocList removeAllObjects];
//    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dicEnv  = [[NSMutableDictionary alloc] init];
    [myCommon getEnvFromTbl:dicEnv];    

    NSMutableDictionary *dicOneDefaultFolder1 = [[NSMutableDictionary alloc] init];

    //FreeBooks는 영어버전에서만 해준다.
#ifdef ENGLISH
    [dicOneDefaultFolder1 setValue:@"freebooks.png" forKey:@"imageName"];
    [dicOneDefaultFolder1 setValue:NSLocalizedString(@"Free Books", @"") forKey:@"Title"];
    [self.arrDocList insertObject:dicOneDefaultFolder1 atIndex:0];
#endif
//    DLog(@"arrDocList : %@", arrDocList);
	NSError *error;
	NSArray *filelist = [fm contentsOfDirectoryAtPath:[myCommon getDocPath] error:&error];
	
    

    for (NSString *s in filelist){
		NSString *strFileNameExtension = [s pathExtension];
        
        //문서는 txt와 epub만을 선택한다.
        if ( ([[strFileNameExtension uppercaseString] isEqualToString:fileExtension_TXT] == YES) || ([[strFileNameExtension uppercaseString] isEqualToString:fileExtension_EPUB] == YES) )  {	

//            DLog(@"s : %@", s);
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [myCommon getBookInfoFormTbl:dicOne fileName:[s lastPathComponent]];
            
            if ([[dicOne objectForKey:@"UniqueWords"] intValue] != 0) {
                float score = ((float)[[dicOne objectForKey:@"KnownWords"] intValue]/[[dicOne objectForKey:@"UniqueWords"] intValue]) * 100;
                //                DLog(@"score : %f", score);
                //                DLog(@"aaa : %f",  [[dicEnv objectForKey:@"Difficulty_VeryEasy"] floatValue]);
                if (score > [[dicEnv objectForKey:@"Difficulty_VeryEasy"] floatValue]) {
                    [dicOne setValue:@"book_very_easy.png" forKey:@"imageName"];
                    [dicOne setValue:@"book_very_easy_level.png" forKey:@"imageNameBookLevel"];
                    //                    [dicOne setValue:[NSNumber numberWithFloat:score] forKey:@"Difficulty"];
                } else if (score > [[dicEnv objectForKey:@"Difficulty_Easy"] floatValue]) {
                    [dicOne setValue:@"book_easy.png" forKey:@"imageName"];
                    [dicOne setValue:@"book_easy_level.png" forKey:@"imageNameBookLevel"];                    
                    //                    [dicOne setValue:@"2" forKey:@"Difficulty"];
                } else if (score > [[dicEnv objectForKey:@"Difficulty_Good"] floatValue]) {
                    [dicOne setValue:@"book_good.png" forKey:@"imageName"];
                    [dicOne setValue:@"book_good_level.png" forKey:@"imageNameBookLevel"];                    
                    //                    [dicOne setValue:@"3" forKey:@"Difficulty"];
                } else if (score > [[dicEnv objectForKey:@"Difficulty_Hard"] floatValue]) {
                    [dicOne setValue:@"book_hard.png" forKey:@"imageName"];
                    [dicOne setValue:@"book_hard_level.png" forKey:@"imageNameBookLevel"];                    
                    //                    [dicOne setValue:@"4" forKey:@"Difficulty"];
                } else {
                    if (score == 0) {
                        NSInteger cntOfNotSureWords = [[dicOne objectForKey:@"HalfKnownWords"] integerValue];
                        NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"UnKnownWords"] integerValue];                
                        if ( (cntOfNotSureWords == 0) && (cntOfUnknownWords == 0) ) {
                            [dicOne setValue:@"book_unknown.png" forKey:@"imageName"];
                            [dicOne setValue:@"book_unknown_level.png" forKey:@"imageNameBookLevel"];                            
                        } else {
                            [dicOne setValue:@"book_very_hard.png" forKey:@"imageName"];
                            [dicOne setValue:@"book_very_hard_level.png" forKey:@"imageNameBookLevel"];                            
                        }
                    } else {
                        [dicOne setValue:@"book_very_hard.png" forKey:@"imageName"];
                        [dicOne setValue:@"book_very_hard_level.png" forKey:@"imageNameBookLevel"];                        
                    }                    
                } 
                [dicOne setValue:[NSNumber numberWithFloat:score] forKey:@"Difficulty"];
                //                DLog(@"file : %@", dicOne);
            } else  {
                [dicOne setValue:@"book_unknown.png" forKey:@"imageName"];
                [dicOne setValue:@"book_unknown_level.png" forKey:@"imageNameBookLevel"];                                        
                //난이도순으로 정렬할때르 대비에서 -1로주고 화면표시시에는 0으로 해준다.
                [dicOne setValue:[NSNumber numberWithFloat:-1.0f] forKey:@"Difficulty"];
            }

            //EPUB일때는 BookCover를 가져온다.
            if ([[strFileNameExtension uppercaseString] isEqualToString:fileExtension_EPUB] == YES)  {
                
                //epub를 풀어놓은 폴더가 없으면 만든다. (Cache폴더에...)
                self.ePubDirPath = [NSString stringWithFormat: @"%@/%@", 
                               [myCommon getCachePath], 
                               [s stringByDeletingPathExtension]];
                self.ePubDirName = [s stringByDeletingPathExtension];
                
                //EPub 파일 경로
                NSString* ePubFilePath = [NSString stringWithFormat: @"%@/%@", 
                                          [myCommon getDocPath],  
                                          s];
                
                if ([fm fileExistsAtPath:ePubDirPath] == FALSE) {
                    // Create a directory and then unzip it		
                    [fm createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
                    
                    ZipArchive* za = [ZipArchive new];
                    [za UnzipOpenFile: ePubFilePath];
                    [za UnzipFileTo:ePubDirPath overWrite: YES];
                }                 
                
                NSString *strEncryptionXML = [NSString stringWithFormat:@"%@/META-INF/%@", ePubDirPath, fileNameWithExt_EncryptionXML];
                

                _xmlHandler=[[XMLHandler alloc] init];
                _xmlHandler.delegate = (id)self;
                [_xmlHandler parseXMLFileAt:[self getRootFilePath]];
                
//                    DLog(@"strEncryptionXML : %@", strEncryptionXML);
//                    DLog(@"_ePubContent._manifest : %@", _ePubContent._manifest);
//                    DLog(@"_ePubContent._spine : %@", _ePubContent._spine);
                
                //책표지를 가져온다.
                NSString *strCoverImageID = [_ePubContent._manifest objectForKey:@"COVERIMAGE"];
                if (strCoverImageID != NULL) {
                    NSString *strCoverFileName = [_ePubContent._manifest objectForKey:strCoverImageID];
                    if (strCoverFileName != NULL) {
//                        [dicOne setValue:[NSString stringWithFormat:@"%@/%@",self._rootPath, strCoverFileName] forKey:@"CoverImageName"];
                        UIImage *imgBookCover = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",self._rootPath, strCoverFileName]];
                        [dicOne setValue:imgBookCover forKey:@"BookCoverImage"];
                        
//                            DLog(@"strCoverFileName : %@", strCoverFileName);
//                            DLog(@"strCoverFileName : %@/%@", self._rootPath, strCoverFileName);
                    }
                }
                
                //암호화된 EPUB이면... 표지의 책레벨을 못 읽는것으로 바꾸어준다.
                if ([fm fileExistsAtPath:strEncryptionXML] == TRUE) {
                    [dicOne setValue:@"book_X_level.png" forKey:@"imageNameBookLevel"];                                        
                } 
                
            }
            
            NSString *strFullPath = [[myCommon getDocPath] stringByAppendingPathComponent:s];
            NSDictionary *attrs = [fm attributesOfItemAtPath:strFullPath error: NULL];
            //            DLog(@"strFullPath : %@", strFullPath);
            UInt32 txtFileSize = [attrs fileSize];
            [dicOne setValue:[NSNumber numberWithLongLong:txtFileSize] forKey:@"fileSize"];
            [dicOne setValue:[NSString stringWithFormat:@"%@/%@", [myCommon getDocPath],s] forKey:@"FullFileName"];

            [self.arrDocList addObject:dicOne];    

        }
        
    }

#ifdef LITE
    if ([arrDocList count] > LimitCntOfBooks_in_Lite) {
        NSMutableArray *arrDocListLite = [[NSMutableArray alloc] init];
        NSMutableArray *arrRandomNumber = [myCommon getRandomNumber:1 MaxNumber:([arrDocList count] - 1) CountOfRandomNumber:LimitCntOfBooks_in_Lite - 1];       

        for (int i = 0; i < [arrRandomNumber count]; ++i) {            
            NSMutableDictionary *dicOne = [arrDocList objectAtIndex:[[arrRandomNumber objectAtIndex:i] integerValue]];
            [arrDocListLite addObject:dicOne];
        }
        
        [arrDocList removeAllObjects];
        self.arrDocList = [NSMutableArray arrayWithArray:arrDocListLite];
//        DLog(@"arrDocListLite : %@", arrDocListLite);
        [self.arrDocList insertObject:dicOneDefaultFolder1 atIndex:0];
//        DLog(@"arrDocList : %@", arrDocList);
    }
    
#endif

    [self selSegControl:segControl];
	[tblView reloadData];
}

- (void) getMovieList:(NSTimer*)sender
{
    [self.arrMovieList removeAllObjects];
//    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dicEnv  = [[NSMutableDictionary alloc] init];
    [myCommon getEnvFromTbl:dicEnv];    
    
	NSError *error;
	NSArray *filelist = [fm contentsOfDirectoryAtPath:[myCommon getDocPath] error:&error];
	
    NSMutableDictionary *dicTxtFiles = [[NSMutableDictionary alloc] init];
    for (NSString *s in filelist){
		NSString *strFileNameExtension = [s pathExtension];
        
        //"txt"로 끝나는 파일만을 선택해서 전부 대문자로 바꾼후 Dictionary에 넣는다.
        if ([[strFileNameExtension uppercaseString] isEqualToString:@"TXT"] == YES) {										
            [dicTxtFiles setObject:s forKey:[s uppercaseString]];
        }        
    }
    
    NSMutableDictionary *dicScriptFiles = [[NSMutableDictionary alloc] init];
    for (NSString *s in filelist){
		NSString *strFileNameExtension = [s pathExtension];
        
        //"smi"로 끝나는 파일만을 선택해서 전부 대문자로 바꾼후 Dictionary에 넣는다.
        if ([[strFileNameExtension uppercaseString] isEqualToString:@"SMI"] == YES) {										
            [dicScriptFiles setObject:s forKey:[s uppercaseString]];
        }        
    }
    
    for (NSString *s in filelist){
		NSString *strFileNameExtension = [s pathExtension];
        
        //동영상 파일은 "MP4"로 끝나는 파일만을 선택한다.
        if ([[strFileNameExtension uppercaseString] isEqualToString:@"MP4"] == YES) {										
            //같은 이름의 smi파일을 모은다.
            NSString *strBookName = [NSString stringWithFormat:@"%@.smi", [s stringByDeletingPathExtension]];
//            NSString *strFuleBookName = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath],strBookName];            
            NSString *strTxtFile = [dicScriptFiles objectForKey:[strBookName uppercaseString]];            
            if (strTxtFile != nil) {
                NSMutableDictionary *dicOne = [self getBookInfo:strTxtFile];          
                [dicOne setValue:s forKey:@"MovieFileName"];
                [dicOne setValue:strTxtFile forKey:@"TxtFileName"];                
                DLog(@"dicOne : %@", dicOne);
                //같은 이름의 smi파일을 모은다.
                NSString *strScriptName = [NSString stringWithFormat:@"%@.smi", [s stringByDeletingPathExtension]];
                NSString *strScriptFile = [dicScriptFiles objectForKey:[strScriptName uppercaseString]];            
                if (strTxtFile != nil) {
                    [dicOne setValue:s forKey:@"MovieFileName"];
                    [dicOne setValue:strScriptFile forKey:@"ScriptFileName"];
                    [self.arrMovieList addObject:dicOne];    
                    DLog(@"dicOne : %@", dicOne);
                } else {
                    [self.arrMovieList addObject:dicOne];    
                }
            }
        }        
    }

    DLog(@"arrMovieList : %@", arrMovieList);

    [self selSegControl:segControl];
	[tblView reloadData];
}

- (NSMutableDictionary*) getBookInfo:(NSString*)strBookFileName
{
//    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dicEnv  = [[NSMutableDictionary alloc] init];
    [myCommon getEnvFromTbl:dicEnv];  
    
    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [myCommon getBookInfoFormTbl:dicOne fileName:strBookFileName];
    DLog(@"dicOne : %@", dicOne);
    if ([[dicOne objectForKey:@"UniqueWords"] intValue] != 0) {
        float score = ((float)[[dicOne objectForKey:@"KnownWords"] intValue]/[[dicOne objectForKey:@"UniqueWords"] intValue]) * 100;
        if (score > [[dicEnv objectForKey:@"Difficulty_VeryEasy"] floatValue]) {
            [dicOne setValue:@"book_very_easy.png" forKey:@"imageName"];
        } else if (score > [[dicEnv objectForKey:@"Difficulty_Easy"] floatValue]) {
            [dicOne setValue:@"book_easy.png" forKey:@"imageName"];
        } else if (score > [[dicEnv objectForKey:@"Difficulty_Good"] floatValue]) {
            [dicOne setValue:@"book_good.png" forKey:@"imageName"];
        } else if (score > [[dicEnv objectForKey:@"Difficulty_Hard"] floatValue]) {
            [dicOne setValue:@"book_hard.png" forKey:@"imageName"];
        } else {
            if (score == 0) {
                NSInteger cntOfNotSureWords = [[dicOne objectForKey:@"HalfKnownWords"] integerValue];
                NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"UnKnownWords"] integerValue];                
                if ( (cntOfNotSureWords == 0) && (cntOfUnknownWords == 0) ) {
                    [dicOne setValue:@"book_unknown.png" forKey:@"imageName"];
                } else {
                    [dicOne setValue:@"book_very_hard.png" forKey:@"imageName"];
                }
            } else {
                [dicOne setValue:@"book_very_hard.png" forKey:@"imageName"];
            }
        } 
        [dicOne setValue:[NSNumber numberWithFloat:score] forKey:@"Difficulty"];
    } else  {
        [dicOne setValue:@"book_unknown.png" forKey:@"imageName"];
        //난이도순으로 정렬할때르 대비에서 -1로주고 화면표시시에는 0으로 해준다.
        [dicOne setValue:[NSNumber numberWithFloat:-1.0f] forKey:@"Difficulty"];
    }
    
    NSString *strFullPath = [[myCommon getDocPath] stringByAppendingPathComponent:strBookFileName];
    NSDictionary *attrs = [fm attributesOfItemAtPath:strFullPath error: NULL];
    //            DLog(@"strFullPath : %@", strFullPath);
    UInt32 txtFileSize = [attrs fileSize];
    [dicOne setValue:[NSNumber numberWithLongLong:txtFileSize] forKey:@"fileSize"];
    [dicOne setValue:[NSString stringWithFormat:@"%@/%@", [myCommon getDocPath],strBookFileName] forKey:@"FullFileName"];

    return dicOne;
}

- (void)selSegAddAndEdit:(id)sender
{
    
    UISegmentedControl *sel = (UISegmentedControl *)sender;

        if([sel selectedSegmentIndex] == 0) {   
            MakeABook *makeABook = [[MakeABook alloc] initWithNibName:@"MakeABook" bundle:nil];
            [self.navigationController pushViewController:makeABook animated:YES];
            DLog(@"add new book");
        } else {
            [self editTable];
        }
}
- (void)selSegControl:(id)sender
{
    if ((blnDefaultBooks == FALSE) &&  ([self.arrDocList count] == 0)) {
        return;
    }
    
    if ((blnDefaultBooks == TRUE) && ([self.arrBooksDefault count] == 0)) {
        return;
    }
    
    //영어버전에서는 Default책이 아닐때는 정렬을 할때 맨처음(FreeBooks)셀은 제외하고 정렬한다.
#ifdef ENGLISH
    if (blnDefaultBooks == FALSE) {
//        #ifndef LITE
            [self.arrDocList removeObjectAtIndex:0];
//        #endif
    }
#endif
//    DLog(@"blnAlphabet before:%d", blnAlphabet);

    NSSortDescriptor *publishedSorter = nil;
	UISegmentedControl *sel = (UISegmentedControl *)sender;
     
	if([sel selectedSegmentIndex] == segBookSort_Alphabet) {           
        publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:blnAlphabet selector:@selector(localizedCaseInsensitiveCompare:)];
        if (blnDefaultBooks == TRUE) {
            [self.arrBooksDefault sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];     
        } else {
            [self.arrDocList sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]]; 
        }
        blnAlphabet = !blnAlphabet;
	} else 	if( [sel selectedSegmentIndex] == 1 ){        
        publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"Difficulty" ascending:blnDifficulty];
        if (blnDefaultBooks == TRUE) {
            [self.arrBooksDefault sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];     
        } else {
            [self.arrDocList sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]]; 
        }
        blnDifficulty = !blnDifficulty;
	} else 	if( [sel selectedSegmentIndex] == 2 ){
        publishedSorter = [[NSSortDescriptor alloc] initWithKey:@"fileSize" ascending:blnVolumes];
        if (blnDefaultBooks == TRUE) {
            [self.arrBooksDefault sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]];     
        } else {
            [self.arrDocList sortUsingDescriptors:[NSArray arrayWithObject:publishedSorter]]; 
        }
        blnVolumes = !blnVolumes;        
	}

    intBeforeSegSelectedIndex = [sel selectedSegmentIndex];

    //영어버전에서 FreeBooks일 경우가 아니면 정렬후에 FreeBooks를 다시 맨처음에 넣어준다.
#ifdef ENGLISH
    if (blnDefaultBooks == FALSE) {
        NSMutableDictionary *dicOneDefaultFolder1 = [[NSMutableDictionary alloc] init];
        [dicOneDefaultFolder1 setValue:@"freebooks.png" forKey:@"imageName"];
        [dicOneDefaultFolder1 setValue:NSLocalizedString(@"Free Books", @"") forKey:@"Title"];
        [self.arrDocList insertObject:dicOneDefaultFolder1 atIndex:0];
    }
#endif
    [self.tblView reloadData];
    [SVProgressHUD dismiss];
}

- (void) editTable
{
    if ([self.tblView isEditing] == TRUE ) {     
        [segAddAndEdit setTitle:NSLocalizedString(@"Edit", @"") forSegmentAtIndex:1];        
        [self.tblView setEditing:NO animated:YES];	
    } else {
        [segAddAndEdit setTitle:NSLocalizedString(@"Done", @"") forSegmentAtIndex:1];        
        [self.tblView setEditing:YES animated:YES];
    }
}
#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	DLog(@"user : %@", txtUserName.text);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (intMovieSelectorSourceMode == MovieSelectorSourceModeMovie) {
        return [self.arrMovieList count] + ([self isEditing] ? 1 : 0);
    } else {
#ifdef ENGLISH
        if (blnDefaultBooks == TRUE) {
            return [self.arrBooksDefault    count];
        }
        return [self.arrDocList count] + ([self isEditing]? 1 : 0);
#elif CHINESE
        return [self.arrDocList count];
#endif
    }
}

- (NSString *)formattedFileSize:(unsigned long long)size
{
	NSString *formattedStr = nil;
    if (size == 0)
		formattedStr = @"Empty";
	else
		if (size > 0 && size < 1024)
			formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.2f KB", (size / 1024.)];
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2f GB", (size / pow(1024, 3))];
	
	return formattedStr;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    
    static NSString *CellIdentifier = @"Cell";
	BookSelectCell * cell = (BookSelectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"BookSelectCell" owner:nil options:nil];
		cell = [arr	objectAtIndex:0];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (intMovieSelectorSourceMode == MovieSelectorSourceModeMovie) {
        NSDictionary *dicOne = [self.arrMovieList objectAtIndex:indexPath.row];
        DLog(@"dicOne : %@", dicOne);
        NSString *strMovieFileName = [dicOne objectForKey:@"MovieFileName"];

        cell.lblTitle.text = strMovieFileName;	
        cell.imgBookCover.image = [UIImage imageNamed:[dicOne objectForKey:@"imageName"]];
        float score = [[dicOne objectForKey:@"Difficulty"] floatValue];
        if (score < 0) {
            score = 0;
        }
        cell.lblAllWordNo.text = [NSString stringWithFormat:@"%@ : %@ (%.0f%%)", NSLocalizedString(@"Known Words", @""), [dicOne objectForKey:@"KnownWords"], score];
        NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"UniqueWords"] integerValue] - [[dicOne objectForKey:@"KnownWords"] integerValue];
        
        cell.lblKnowWordNo.text = [NSString stringWithFormat:@"%@ : %d", NSLocalizedString(@"Unknown Words", @""), cntOfUnknownWords];
        long long fileSize = [[dicOne objectForKey:@"fileSize"] longLongValue];
        cell.lblBookSize.text = [self formattedFileSize:fileSize];
        
        NSInteger allPage = [[dicOne objectForKey:@"allPage"] integerValue];
        if (allPage > 0) {
            if (allPage == 1) {
                cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Page", @"")];
            } else {
                cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Pages", @"")];
            }
        } else {
            cell.lblAuthor.text = @"";
        }

    } else {
        if (blnDefaultBooks == FALSE) {
            DLog(@"arrDocList : %@", arrDocList);
            NSDictionary *dicOne = [self.arrDocList objectAtIndex:indexPath.row];
            DLog(@"dicOne : %@", dicOne);
            
            cell.lblTitle.text = [dicOne objectForKey:@"Title"];
            UIImage *imgBookCover = (UIImage*)[dicOne objectForKey:@"BookCoverImage"];
            cell.imgBookLevel.alpha = 0.7;
            if (imgBookCover == NULL) {
                cell.imgBookCover.image = [UIImage imageNamed:[dicOne objectForKey:@"imageName"]];     
                if ([[dicOne objectForKey:@"imageNameBookLevel"] isEqualToString:@"book_X_level.png"]) {
                    cell.imgBookLevel.image = [UIImage imageNamed:[dicOne objectForKey:@"imageNameBookLevel"]];                                     
                    cell.imgBookLevel.alpha = 1.0;
                }
            } else {
                cell.imgBookCover.image = imgBookCover;        
                
                cell.imgBookLevel.image = [UIImage imageNamed:[dicOne objectForKey:@"imageNameBookLevel"]];                 
            }


            float score = [[dicOne objectForKey:@"Difficulty"] floatValue];
            if (score < 0) {
                score = 0;
            }
            cell.lblAllWordNo.text = [NSString stringWithFormat:@"%@ : %@ (%.0f%%)", NSLocalizedString(@"Known Words", @""), [dicOne objectForKey:@"KnownWords"], score];
            NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"UniqueWords"] integerValue] - [[dicOne objectForKey:@"KnownWords"] integerValue];

            cell.lblKnowWordNo.text = [NSString stringWithFormat:@"%@ : %d", NSLocalizedString(@"Unknown Words", @""), cntOfUnknownWords];
            
            long long fileSize = [[dicOne objectForKey:@"fileSize"] longLongValue];
            cell.lblBookSize.text = [self formattedFileSize:fileSize];
            
            NSInteger allPage = [[dicOne objectForKey:@"allPage"] integerValue];
            if (allPage > 0) {
                if (allPage == 1) {
                    cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Page", @"")];
                } else {
                    cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Pages", @"")];
                }
            } else {
                cell.lblAuthor.text = @"";
            }
#ifdef ENGLISH
            if (indexPath.row == 0) {
                //첫번째 줄은 폴더로 한다.(Default Books를 넣는다.)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.lblAllWordNo.text = [NSString stringWithFormat:@"%@ : %d", NSLocalizedString(@"Number of Books", @""), 61];                        
                cell.lblKnowWordNo.text = @"";
                cell.lblBookSize.text = @"";
                cell.lblAuthor.text = @"";
                cell.imgBookCover.image = [UIImage imageNamed:[dicOne objectForKey:@"imageName"]];
            }
#endif

        } else {
            NSDictionary *dicOne = nil;
            dicOne =  [self.arrBooksDefault objectAtIndex:indexPath.row];

            cell.lblTitle.text = [dicOne objectForKey:@"Title"];
            cell.imgBookCover.image = [UIImage imageNamed:[dicOne objectForKey:@"imageName"]];
            float score = [[dicOne objectForKey:@"Difficulty"] floatValue];
            if (score < 0) {
                score = 0;
            }
            cell.lblAllWordNo.text = [NSString stringWithFormat:@"%@ : %@ (%.0f%%)", NSLocalizedString(@"Known Words", @""), [dicOne objectForKey:@"KnownWords"], score];
            NSInteger cntOfUnknownWords = [[dicOne objectForKey:@"UniqueWords"] integerValue] - [[dicOne objectForKey:@"KnownWords"] integerValue];
            
            cell.lblKnowWordNo.text = [NSString stringWithFormat:@"%@ : %d", NSLocalizedString(@"Unknown Words", @""), cntOfUnknownWords];
            
            long long fileSize = [[dicOne objectForKey:@"fileSize"] longLongValue];
            cell.lblBookSize.text = [self formattedFileSize:fileSize];
            
            NSInteger allPage = [[dicOne objectForKey:@"allPage"] integerValue];
            if (allPage > 0) {
                if (allPage == 1) {
                    cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Page", @"")];
                } else {
                    cell.lblAuthor.text = [NSString stringWithFormat:@"%d %@", allPage, NSLocalizedString(@"Pages", @"")];
                }
            } else {
                cell.lblAuthor.text = @"";
            }
        }
    }
    return cell;	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [SVProgressHUD showProgress:-1 status:@""];
    if (intMovieSelectorSourceMode == MovieSelectorSourceModeMovie) {
        [self openMovieOfIndex:indexPath.row];
    } else {
        
#ifdef ENGLISH
            if ((indexPath.row == 0) && (blnDefaultBooks == FALSE)) {
                self.navigationItem.rightBarButtonItem = nil;
                blnDefaultBooks = TRUE;
                blnAlphabet = TRUE;
                blnDifficulty = FALSE;
                blnVolumes = TRUE;
                
                [self getDefaultBookList];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.8f];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tblView cache:YES];
                [UIView commitAnimations];	
                [self.tblView reloadData];
                return;
            }
#endif
        [self openBookOfIndex:indexPath.row];
    }
}

- (void) openBookOfIndex:(int)row {

    NSDictionary     *dicOne = nil;
    if (blnDefaultBooks == TRUE) {
        dicOne = [self.arrBooksDefault objectAtIndex:row];
    } else {
        dicOne = [self.arrDocList objectAtIndex:row];
    }
    
    BOOL blnEncryptionEPub = FALSE;
    NSString *strBookFileName = [dicOne objectForKey:@"Title"];
    
    if ([[[strBookFileName pathExtension] uppercaseString]  isEqualToString:fileExtension_EPUB] == YES){
        //epub를 풀어놓은 폴더가 없으면 만든다.
        ePubDirPath = [NSString stringWithFormat: @"%@/%@", 
                             [myCommon getCachePath], 
                             [strBookFileName stringByDeletingPathExtension]];
        
        NSString* ePubFilePath = [NSString stringWithFormat: @"%@/%@", 
                                  [myCommon getDocPath],  
                                  strBookFileName];
                  
        if ([fm fileExistsAtPath:ePubDirPath] == FALSE) {
            // Create a directory and then unzip it		
            [fm createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
            
            ZipArchive* za = [ZipArchive new];
            [za UnzipOpenFile: ePubFilePath];
            [za UnzipFileTo:ePubDirPath overWrite: YES];
            
        } else {
            
            //이미 같은 이름의 폴더가 있으면 압축푼 폴더밑에 epub의 내용을 합쳐둔 txt가 있는지 살펴본다.
            NSString *strEPubTxtFullFileName = [NSString stringWithFormat:@"%@/%@.%@", ePubDirPath,[strBookFileName stringByDeletingPathExtension], fileExtension_TXT];
            DLog(@"strEPubTxtFullFileName : %@", strEPubTxtFullFileName);
            
            if ([fm fileExistsAtPath:strEPubTxtFullFileName] == FALSE) {
                //압축푼 폴더밑에 epub의 내용을 합쳐둔 txt가 없으면 다른 EPUB로 보고  압축해제한 폴더를 지우고 다시 만든다.
                [fm removeItemAtPath:ePubDirPath error:nil];
                // Create a directory and then unzip it		
                [fm createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
                
                ZipArchive* za = [ZipArchive new];
                [za UnzipOpenFile: ePubFilePath];
                [za UnzipFileTo:ePubDirPath overWrite: YES];
                
                DLog(@"UnzipFileTo: %@", ePubDirPath);
            }
        }          
        
        NSString *strEncryptionXML = [NSString stringWithFormat:@"%@/META-INF/%@", ePubDirPath, fileNameWithExt_EncryptionXML];

        DLog(@"strEncryptionXML : %@", strEncryptionXML);            
        if ([fm fileExistsAtPath:strEncryptionXML] == TRUE) {
            blnEncryptionEPub = TRUE;
        }
    }
    
    if (blnEncryptionEPub == FALSE) {        
        //암호화된것이 아니면 읽는다.
        BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
        bookVC.strBookFullFileName = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"FullFileName"]];		 
        bookVC.intViewType = viewTypeBook;
        [self.navigationController pushViewController:bookVC animated:YES];
        
        //    if ((intBeforeSegSelectedIndex == 0) || (intBeforeSegSelectedIndex == -1)){
        if (intBeforeSegSelectedIndex == 0){
            blnAlphabet = !blnAlphabet;
        } else if (intBeforeSegSelectedIndex == 1) {
            blnDifficulty = !blnDifficulty;
        } else if (intBeforeSegSelectedIndex == 2) {
            blnVolumes = !blnVolumes;
        }
    } else {
        //암호화된 epub파일이면 읽지 않는다. (압축을 풀어둔 폴더는 지운다.)
        [fm removeItemAtPath:ePubDirPath error:nil];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Does not support encryptied file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    }
    
    [SVProgressHUD dismiss];
}

- (void) openMovieOfIndex:(NSInteger)row {
    
    NSDictionary     *dicOne = [self.arrMovieList objectAtIndex:row];
    
	BookViewController *bookVC = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    bookVC.strBookFullFileName = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"FullFileName"]];		 
//    movePlayerController.strMovieFileName = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"MovieFileName"]];		     
    bookVC.strMovieFileName = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"MovieFileName"]];		         
    bookVC.strScriptFileName = [NSString stringWithFormat:@"%@", [dicOne objectForKey:@"ScriptFileName"]];		         
 
	bookVC.intViewType = viewTypeBook;
    bookVC.playType = PlayTypeMovie;

	[self.navigationController pushViewController:bookVC animated:YES];
    
    [SVProgressHUD dismiss];
}

//줄의 높이를 조절한다.
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 100;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //swipe했을때 에디팅 모드를 할지 안할지 결정한다.
    // Detemine if it's in editing mode
    if (blnDefaultBooks == TRUE) {
        return UITableViewCellEditingStyleNone;
    }
    
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;;    
}

//Book에 해당되는 TBL_EngDic_테이블과 BOOK_LIST의 내용도 같이 지운다.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dicOne = [self.arrDocList objectAtIndex:indexPath.row];
		NSString *strBookFileName = [dicOne objectForKey:@"Title"];
        DLog(@"strBookFileName : %@", strBookFileName);
		NSString *strBookFullFileName = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], strBookFileName];	
		DLog(@"delete : %@", strBookFullFileName);
		if ([fm fileExistsAtPath:strBookFullFileName] == TRUE) {
            NSError *error = nil;
            //파일을 삭제한다.
            BOOL success = [fm removeItemAtPath:strBookFullFileName error:&error];
            if (success) {              
                [self.arrDocList removeObjectAtIndex:indexPath.row];                
                [self.tblView reloadData];
            } else {
                NSString *strErr = [NSString stringWithFormat:@"%@!!!\n%@",NSLocalizedString(@"Fail to remove file", @""), [error description]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strErr  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }

            
            //EPUB파일이면 압축을 푼 경로도 같이 삭제한다.            
            ePubDirPath = [NSString stringWithFormat: @"%@/%@",
                                     [myCommon getDocPath], 
                                     [strBookFileName stringByDeletingPathExtension]];
            DLog(@"ePubDirPath : %@", ePubDirPath);
            [fm removeItemAtPath:ePubDirPath error:nil];
            
            //BOOK_LIST의 내용도 같이 삭제한다.
            strBookFileName = [strBookFileName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_BOOK_LIST_ID, TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strBookFileName];
            NSInteger bookTblNo = [myCommon getIntFldValueFromTbl:strQuery openMyDic:TRUE];
            if (bookTblNo > 0) {                
                NSString	*strFileNameInDoc = [NSString stringWithFormat:@"%@/%@.sqlite", [myCommon getDocPath], [strBookFileName stringByDeletingPathExtension]];
                if ([fm fileExistsAtPath:strFileNameInDoc]) {
                    [fm removeItemAtPath:strFileNameInDoc error:nil];
                }                

                strQuery = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = '%@'", TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strBookFileName];
                [myCommon changeRec:strQuery openMyDic:TRUE];
                //[myCommon compressDB];
            }
		}
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


//- (void) createBookFile:(NSString *)identifier
//{
//	//DLog(@"======222222222222222222=========");
//	
//	// Store the EPUB data to disk	
//	NSString* directoryPath = [NSString stringWithFormat: @"%@/%@", 
//							   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], 
//							   identifier];
//	DLog(@"directoryPath : %@", directoryPath);
//	//path already exists
//	if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
//		DLog(@"===directoryPath===path already exists : %@", directoryPath);
//		[self performSelector:@selector(btnEbookView:)];
//		return; 
//	}
//	
//	DLog(@"===directoryPath create : %@", directoryPath);
//	
//	NSString* filePath = [NSString stringWithFormat: @"%@/%@.epub", 
//						  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], 
//						  identifier];
//	DLog(@"===writeToFile : %@", filePath);
//	
//	
//	// Create a directory and then unzip it		
//	[[NSFileManager defaultManager] createDirectoryAtPath:@"" withIntermediateDirectories:YES attributes:nil error:nil];
//	
//	ZipArchive* za = [ZipArchive new];
//	[za UnzipOpenFile: filePath];
//	[za UnzipFileTo: directoryPath overWrite: YES];
//	
//	DLog(@"UnzipFileTo: %@", directoryPath);
//    
//	//removeBook .epub   file	
//	[[NSFileManager defaultManager] removeItemAtPath: [NSString stringWithFormat: @"%@.epub", directoryPath] error: NULL]; // del *.epub file
//	
//	[self performSelector:@selector(btnEbookView:)];
//}
//
//-(void)btnEbookView:(id)sender {
//	
//	DLog(@"===btnEbookView : %@", self.fileName);
//	BookIndexViewController* bookIndexViewController = [[BookIndexViewController alloc] initWithBook: self.fileName];
//	
//	UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController: bookIndexViewController];
//	if (navigationController != nil) {		
//		[self presentModalViewController: navigationController animated: YES];
//	}
//}

#pragma mark -
#pragma mark View

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [myCommon closeDB:TRUE];
    [myCommon openDB:TRUE];  
}

- (NSString*)getRootFilePath{
	
	//check whether root file path exists
	NSString *strFilePath=[NSString stringWithFormat:@"%@/%@/META-INF/container.xml",[myCommon getCachePath], self.ePubDirName];
    
	if ([fm fileExistsAtPath:strFilePath]) {

		return strFilePath;
	}
	else {
		
		//Invalid ePub file
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"Root File not Valid"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		alert=nil;
		
	}
    
	return @"";
}

#pragma mark XMLHandler Delegate Methods

- (void)foundRootPath:(NSString*)rootPath{
	
	//Found the path of *.opf file
	
	//get the full path of opf file
	NSString *strOpfFilePath=[NSString stringWithFormat:@"%@/%@/%@",[myCommon getCachePath], self.ePubDirName,rootPath];
//	DLog(@"strOpfFilePath : %@", strOpfFilePath);
//	DLog(@"[strOpfFilePath stringByDeletingLastPathComponent] : %@", [strOpfFilePath stringByDeletingLastPathComponent]);    
	self._rootPath=[strOpfFilePath stringByReplacingOccurrencesOfString:[strOpfFilePath lastPathComponent] withString:@""];
//	DLog(@"_rootPath : %@", _rootPath);	
	if ([fm fileExistsAtPath:strOpfFilePath]) {
		
		//Now start parse this file
//        DLog(@"strOpfFilePath : %@", strOpfFilePath);
		[_xmlHandler parseXMLFileAt:strOpfFilePath];
	}
	else {
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"OPF File not found"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		alert=nil;
	}
}


- (void)finishedParsing:(EpubContent*)ePubContents{
    
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[ePubContents._manifest valueForKey:[ePubContents._spine objectAtIndex:0]]];
//    DLog(@"_pagesPath : %@", _pagesPath);
	self._ePubContent=ePubContents;
	_pageNumber=0;
    
    //	[self loadPage];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
