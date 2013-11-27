//
//  BackupController.m
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 4. 9..
//  Copyright 2011 dalnim. All rights reserved.
//

#import "BackupController.h"
#import "myCommon.h"
#import "SVProgressHUD.h"

@implementation BackupController

@synthesize arrBackupFiles, strLastBackupFile, tblBackup, segConBackup, strFileNameToMail, aiv, blnRestore;
@synthesize actionSheetProgress, progressViewInActionSheet, blnCancelRestore;


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

    
//	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
//	self.navigationItem.leftBarButtonItem = backButton;
//	[backButton release];
	
	segConBackup = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0,0, 240, 30)];
	[segConBackup insertSegmentWithTitle:NSLocalizedString(@"Edit", @"") atIndex:0 animated:YES];
	[segConBackup insertSegmentWithTitle:NSLocalizedString(@"Mail", @"") atIndex:1 animated:YES];
	[segConBackup insertSegmentWithTitle:NSLocalizedString(@"Backup", @"") atIndex:2 animated:YES];
	[segConBackup insertSegmentWithTitle:NSLocalizedString(@"Restore", @"") atIndex:3 animated:YES];
	segConBackup.momentary = TRUE;
//	segControl.selectedSegmentIndex = -1;
	segConBackup.tag = 0;
	[segConBackup addTarget:self action:@selector(selSegConBackup) forControlEvents:UIControlEventValueChanged];
	segConBackup.segmentedControlStyle = UISegmentedControlStyleBar;
//	UIBarButtonItem *toAdd = [[UIBarButtonItem alloc] initWithCustomView:segConBackup];
//	self.navigationItem.rightBarButtonItem = toAdd;	
    self.navigationItem.titleView = segConBackup;
    
    aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	//activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	self.aiv.center = self.view.center;
	[self.view addSubview: aiv];

    blnRestore = FALSE;
    blnCancelRestore = FALSE;
    
//	[toAdd release];
    strFileNameToMail = [[NSString alloc] init];
	self.strFileNameToMail = @"";
	arrBackupFiles = [[NSMutableArray alloc] init];
}



- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.arrBackupFiles removeAllObjects];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *filelist = [fm contentsOfDirectoryAtPath:[myCommon getDocPath] error:nil];

    for (NSString *s in filelist){
		DLog(@"s : %@", s);
		NSString *strFileNameExtension = [s pathExtension];
		if ([[strFileNameExtension lowercaseString] isEqualToString:@"sqlite"] == TRUE) {
			//연속되는 공백을 찾는 표현식
			NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:@"MyEnglish_*\\d{14}" options:NSRegularExpressionCaseInsensitive error:nil];
#ifdef CHINESE
            regEx= [NSRegularExpression regularExpressionWithPattern:@"MyChinese_*\\d{14}" options:NSRegularExpressionCaseInsensitive error:nil];
#endif
			NSUInteger numberOfMatches = [regEx numberOfMatchesInString:s
																options:0
																  range:NSMakeRange(0, [s length])];
			NSMutableString *strTemp = [NSMutableString stringWithString:s];
			[regEx replaceMatchesInString:strTemp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strTemp length]) withTemplate:@" "];
			DLog(@"strTemp : %@", strTemp);
			if (numberOfMatches > 0) {
//				DLog(@"sql : %@", s);
				[self.arrBackupFiles addObject:s];
			}
            
            regEx= [NSRegularExpression regularExpressionWithPattern:@"myDic_*\\d{14}" options:NSRegularExpressionCaseInsensitive error:nil];
			numberOfMatches = [regEx numberOfMatchesInString:s
																options:0
																  range:NSMakeRange(0, [s length])];
			strTemp = [NSMutableString stringWithString:s];
			[regEx replaceMatchesInString:strTemp options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strTemp length]) withTemplate:@" "];
            //			DLog(@"strTemp : %@", strTemp);
			if (numberOfMatches > 0) {
                //				DLog(@"sql : %@", s);
				[self.arrBackupFiles addObject:s];
			}

            if ([s isEqualToString:fileNameWithExt_myDic] == TRUE) {
                [self.arrBackupFiles addObject:s];
            }
            
		}
    }
    
    DLog(@"arrBackupFiles : %@", arrBackupFiles);

	[self.arrBackupFiles sortUsingSelector:@selector(compare:)];

	[tblBackup reloadData];
}

- (void)back
{
    [self.view bringSubviewToFront:aiv];
    [aiv startAnimating];

    
	
    [NSTimer scheduledTimerWithTimeInterval: 0.0f
                                     target:self
                                   selector:@selector(closeAiv:)
                                   userInfo:nil
                                    repeats:NO];
}

- (IBAction)closeAiv:(NSTimer *)sender
{
    [aiv stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction) selSegConBackup
{
	UIBarButtonItem *toAdd = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
	UISegmentedControl* segControl = (UISegmentedControl*)toAdd.customView;	
	
	if (segConBackup.selectedSegmentIndex == 0) {
		if ([self.tblBackup isEditing] == TRUE ) {
			[self.tblBackup setEditing:NO animated:YES];	
			[segControl setTitle:NSLocalizedString(@"Edit", @"") forSegmentAtIndex:0];
		} else {
			[self.tblBackup setEditing:YES animated:YES];
			[segControl setTitle:NSLocalizedString(@"Done", @"") forSegmentAtIndex:0];
		}
	} else if (segConBackup.selectedSegmentIndex == 1) {
		//첨부할 파일을 가져온다.
		if ([self.strFileNameToMail isEqualToString:@""] == TRUE) {
			
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You need to select a file to mail with.", @"")];

		} else {
			NSString *strFile = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], self.strFileNameToMail];
			NSData *myData = [NSData dataWithContentsOfFile:strFile];
			
			MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            if (controller != NULL) {
                controller.mailComposeDelegate = self;
                //	NSArray* toRecipients = [NSArray arrayWithObjects:strMailAddress, @"dalnim@mnsoft.co.kr", nil];
                //	[controller setToRecipients:toRecipients];
                [controller setSubject:[NSString stringWithFormat: NSLocalizedString(@"Backup WordList", @"")]];
                NSString *body = [NSString stringWithFormat:@"%@<br><br>%@", NSLocalizedString(@"Backup WordList", @""), NSLocalizedString(@"Ready2Read?!", @"")];
                [controller setMessageBody:body isHTML:YES];
                
                [controller addAttachmentData:myData mimeType:@"application/x-sqlite3" fileName:strFileNameToMail];
                [self presentModalViewController:controller animated:YES];
            }

		}
	} else if (segConBackup.selectedSegmentIndex == 2) {
		//백업을 받는다.
        [aiv startAnimating];
        [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                         target:self
                                       selector:@selector(makeBackUp:)
                                       userInfo:nil
                                        repeats:NO];
//        [self makeBackUp];

	} else if (segConBackup.selectedSegmentIndex == 3) {
		//복원할 파일을 가져온다.
		if ([self.strFileNameToMail isEqualToString:@""] == TRUE) {
			
            [SVProgressHUD showErrorWithStatus:@"You need to select a file to restore."];

		} else {

            if ([[strFileNameToMail lowercaseString] hasPrefix:@"mydic"] == TRUE) {
                
                NSString *strMyDicDBPath = [NSMutableString stringWithFormat:@"%@/%@", [myCommon getDocPath], strFileNameToMail];
                DLog(@"strMyDicDBPath : %@", strMyDicDBPath);
                sqlite3 *dbMyDic = nil;
                if (sqlite3_open([strMyDicDBPath UTF8String], &dbMyDic) != SQLITE_OK)
                {
                    sqlite3_close(dbMyDic);
                    DLog(@"Can't open DB : %@", strMyDicDBPath);
                    return;
                }
                
                NSString *strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE (%@ > %d and %@ <= %d) or %@ < %d or %@ != '' or %@ != ''", TBL_tblEngDic, FldName_Know, KnowWord_NotRated, FldName_Know, KnowWord_Known, FldName_KnowPronounce, KnowWord_Known, FldName_Pronounce, FldName_Meaning];
                
                
                int cntOfWords = 0;
                
                DLog(@"strQuery GetCountFromTbl : %@", strQuery);
                const char *sqlQuery1 = [strQuery UTF8String];
                sqlite3_stmt *stmt1 = nil;
                
                int rett = sqlite3_prepare_v2(dbMyDic, sqlQuery1, -1, &stmt1, NULL);
                if (rett == SQLITE_OK) {
                    int ret = sqlite3_step(stmt1);
                    if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
                        cntOfWords = sqlite3_column_int(stmt1, 0);
                    } else {
                        //			DLog(@" Step error GetCountFromTbl : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
                    }
                } else {
                    //		DLog(@" error GetCountFromTbl : %@ %s ", strQuery, sqlite3_errmsg(db));
                }
                DLog(@"cntOfWords : %d", cntOfWords);
                sqlite3_reset(stmt1);
                sqlite3_finalize(stmt1);
                
                NSInteger minutesToRestore = ((float)cntOfWords/1000) * 2;
                DLog(@"minutesToRestore : %d", minutesToRestore);
                
                
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:[NSString stringWithFormat:NSLocalizedString(@"Hi!\nIt will take %d minutes to restore your dictionary file.\nSorry for the inconvenience.", @""), minutesToRestore]  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""), nil];
                [alert2 setTag:1];
                [alert2 show];

            } else {
                //MyEnglish.sqlite일때는
                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Are you sure to restore the file?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"NO", @"") otherButtonTitles:NSLocalizedString(@"YES", @""), nil];
                [alert2 setTag:1];
                [alert2 show];
            }
            
		}
		

	}
}

- (BOOL) makeBackUp:(NSTimer*)sender
{
    NSString *strFileName = [[[myCommon getDBPath] lastPathComponent] stringByDeletingPathExtension];		
    self.strLastBackupFile = [NSString stringWithFormat:@"%@_%@.sqlite", strFileName, [myCommon getCurrentDatAndTimeForBackup]];
    
    
    NSString *strFileOri = [myCommon getDBPath];
    NSString *strFileTarget = [NSString	stringWithFormat:@"%@/%@", [myCommon getDocPath], strLastBackupFile];
    DLog(@"strFileName : %@", strFileName);
    DLog(@"strLastBackupFile : %@", strLastBackupFile);    
    DLog(@"strFileOri : %@", strFileOri);
    DLog(@"strFileTarget : %@", strFileTarget);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [self.arrBackupFiles removeObject:strLastBackupFile];
    [self.arrBackupFiles addObject:strLastBackupFile];
    
    
    NSError *error = nil;
    [fm removeItemAtPath:strFileTarget error:&error];
    BOOL success = [fm copyItemAtPath:strFileOri toPath:strFileTarget error:&error];
    if (!success) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:NSLocalizedString(@"Fail to make a backup file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
            DLog(@"strFileTarget : %@", strFileTarget);
            NSURL *pathURL= [NSURL fileURLWithPath:strFileTarget];                
            if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                DLog(@"Success : addSkipBackupAttributeToItemAtURL");
            } else {
                DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
            }
        }            
#endif
    }
    [self.tblBackup reloadData];
    
    //리스토어시에는 aiv를 정지시키지 않는다.
    if (blnRestore != TRUE) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Made a backup file", @"")];
        [aiv stopAnimating];
    }
    return success;
}
#pragma mark -
#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {
        //복원을 눌렀을때...        
        if (buttonIndex == 1) {
            blnRestore = TRUE;
            [aiv startAnimating];
            [NSTimer scheduledTimerWithTimeInterval: 0.4f
                                             target:self
                                           selector:@selector(restoreDic:)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

- (void) restoreDic:(NSTimer*)sender
{
    //백업을 먼저 하나 받아둔다..
    [self makeBackUp:nil];
    
    NSString *strFileOri = [myCommon getDBPath];
    NSString *strFileTarget = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], self.strFileNameToMail];
    DLog(@"strFileOri : %@", strFileOri);
    DLog(@"strFileTarget : %@", strFileTarget);
    
    [myCommon closeDB:true];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    BOOL success = [fm removeItemAtPath:strFileOri error:&error];
    if (!success) {
        DLog(@"error removeItem : %@", error);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:NSLocalizedString(@"Fail to delete a current dictionary file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];

    }
    
    if ([[strFileNameToMail lowercaseString] hasPrefix:@"mydic"] == TRUE) {
        
        //myDic일때(ready2read)
        //원본 MyEnglish.sqlite를 번들로부터 복사해온다.
        NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileNameWithExt_MyEnglish];
        DLog(@"defaultDBPath : %@", defaultDBPath);
        NSError *error;
        [fm copyItemAtPath:defaultDBPath toPath:strFileOri error:&error];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
            NSString *strMyEnglishFullPath = [myCommon getDBPath];
            DLog(@"strMyDicFullPath : %@", strMyEnglishFullPath);
            NSURL *pathURL= [NSURL fileURLWithPath:strMyEnglishFullPath];
            if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                DLog(@"Success : addSkipBackupAttributeToItemAtURL");
            } else {
                DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
            }
        }
#endif
        
        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        
        //미해결질문)여기서 초기화하고 나중에 nil을 한다. 맞나? release를 하니까 죽더라...
        actionSheetProgress = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\n%@...\n\n\n", NSLocalizedString(@"Preparing to restore", @"")] delegate:self cancelButtonTitle:nil destructiveButtonTitle: nil otherButtonTitles: nil];
        
        [actionSheetProgress showInView:self.view];
        
        float width = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )?270:self.view.frame.size.width;
        progressViewInActionSheet = [[UIProgressView alloc] initWithFrame:CGRectMake(40.0f, 15.0f, width-80, 20.0f)];
        [progressViewInActionSheet setProgressViewStyle: UIProgressViewStyleDefault];
        [actionSheetProgress addSubview:progressViewInActionSheet];
        
        UIActivityIndicatorView *aiv1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiv1.center = CGPointMake(20.0f, actionSheetProgress.bounds.size.height - 55.0f);
        [aiv1 startAnimating];
        [actionSheetProgress addSubview:aiv1];
        
        blnCancelRestore = FALSE;
        [NSThread detachNewThreadSelector:@selector(restoreMyDic:) toTarget:self withObject:nil];
    } else {
        success = [fm copyItemAtPath:strFileTarget toPath:strFileOri error:&error];
        if (!success) {
            DLog(@"error copyItemAtPath : %@", error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:NSLocalizedString(@"Fail to restore a backup file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
            
        } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                DLog(@"strFileTarget : %@", strFileTarget);
                NSURL *pathURL= [NSURL fileURLWithPath:strFileTarget];
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }
            }
#endif
        }
        [myCommon closeDB:true];
        [myCommon openDB:true];
        [aiv stopAnimating];
        
        NSString *strMsg =[NSString stringWithFormat:NSLocalizedString(@"Restored a dictionary file!\n\nMade a backup file too.", @"")];
        [SVProgressHUD showSuccessWithStatus:strMsg];
        
    }
    
    blnRestore = FALSE;
}

- (void) addCancelButton:(NSNumber*) param  {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(110, 55, 90, 37);
    [btnCancel setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Cancel", @"")]  forState:UIControlStateNormal];
    
    //            btnCancel.backgroundColor = [UIColor blueColor];            
    [btnCancel addTarget:self action:@selector(dismissBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetProgress addSubview:btnCancel];
    //    [btnCancel release];
}

- (void) dismissBtnCancel
{
    blnCancelRestore= TRUE;
}

- (void) updateProgress:(NSNumber*) param  {
	progressViewInActionSheet.progress = [param floatValue]; 
}

- (void) updateProgressTitle:(NSString*) param  {
	actionSheetProgress.title = [NSString stringWithFormat:@"%@\n\n",  param];
}

- (void) restoreMyDic:(NSObject*)obj
{
    @autoreleasepool {
        
        NSDate		*startTime1 = [NSDate date];
        
        NSString *strMyDicDBPath = [NSMutableString stringWithFormat:@"%@/%@", [myCommon getDocPath], strFileNameToMail];
        DLog(@"strMyDicDBPath : %@", strMyDicDBPath);
        sqlite3 *dbMyDic = nil;
        if (sqlite3_open([strMyDicDBPath UTF8String], &dbMyDic) != SQLITE_OK)
        {
            sqlite3_close(dbMyDic);
            DLog(@"Can't open DB : %@", strMyDicDBPath);
            return;
        }

        
        NSString *strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE (%@ > %d and %@ <= %d) or %@ < %d or %@ != '' or %@ != ''", TBL_tblEngDic, FldName_Know, KnowWord_NotRated, FldName_Know, KnowWord_Known, FldName_KnowPronounce, KnowWord_Known, FldName_Pronounce, FldName_Meaning];
        int cntOfWords = 0;
        
        DLog(@"strQuery GetCountFromTbl : %@", strQuery);
        const char *sqlQuery1 = [strQuery UTF8String];
        sqlite3_stmt *stmt1 = nil;
        
        int rett = sqlite3_prepare_v2(dbMyDic, sqlQuery1, -1, &stmt1, NULL);
        if (rett == SQLITE_OK) {
            int ret = sqlite3_step(stmt1);
            if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
                cntOfWords = sqlite3_column_int(stmt1, 0);
            } else {
                //			DLog(@" Step error GetCountFromTbl : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
            }				
        } else {
            //		DLog(@" error GetCountFromTbl : %@ %s ", strQuery, sqlite3_errmsg(db));
        }
        DLog(@"cntOfWords : %d", cntOfWords);
        sqlite3_reset(stmt1);
        sqlite3_finalize(stmt1);
        
        
        [self performSelectorOnMainThread:@selector(addCancelButton:) withObject:nil waitUntilDone:YES];
        
//SELECT * FROM tblengdic where know > 0 or Knowpronounce < 3 or Pronounce <> '' or meaning <> ''
        
        strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (%@ > %d and %@ <= %d) or %@ < %d or %@ != '' or %@ != ''", TBL_tblEngDic, FldName_Know, KnowWord_NotRated, FldName_Know, KnowWord_Known, FldName_KnowPronounce, KnowWord_Known, FldName_Pronounce, FldName_Meaning];
//        [myCommon getWordListInMyDic:strQuery sqliteDBPath:strMyDicDBPath byArray:arrResult byDic:dicResult];
        
        
        DLog(@"strQuery : %@", strQuery);
        DLog(@"strMyDicDBPath : %@", strMyDicDBPath);
        
        const char *sqlQuery = [strQuery UTF8String];
        sqlite3_stmt *stmt = nil;

        NSInteger i = 0;
        if (sqlite3_prepare_v2(dbMyDic, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                if (blnCancelRestore == TRUE) {
                    //myDic~.sqlite를 하다가 멈추면 기존 MyEnglish.sqlite를 복원시켜준다.
                    NSString *strFileOri = [myCommon getDBPath];
                    NSString *strFileTarget = [NSString	stringWithFormat:@"%@/%@", [myCommon getDocPath], strLastBackupFile];
                    DLog(@"strFileOri : %@", strFileOri);
                    DLog(@"strFileTarget : %@", strFileTarget);
                    
                    NSFileManager *fm = [NSFileManager defaultManager];

                    NSError *error = nil;
                    [fm removeItemAtPath:strFileOri error:&error];
                    BOOL success = [fm copyItemAtPath:strFileTarget toPath:strFileOri error:&error];
                    if (!success) {
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:NSLocalizedString(@"Fail to restore MyEnglish.sqlite file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                        [alert show];
                    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                        if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                            NSURL *pathURL= [NSURL fileURLWithPath:strFileOri];                
                            if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                                DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                            } else {
                                DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                            }
                        }            
#endif
                    }
                    [self.tblBackup reloadData];                    
                    
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Cancelled restore file.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                    [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
                    actionSheetProgress = nil;
                    progressViewInActionSheet = nil;
                    
                    [myCommon closeDB:true];
                    [myCommon openDB:true];
                    
                    [aiv stopAnimating];
                    return;
                }
                
                float fVal = (float)i++ / cntOfWords;
                NSString *strMsg = [NSString stringWithFormat:@"%@... %@", NSLocalizedString(@"Updating words", @""), [NSString stringWithFormat:@"%.2f%%", (fVal*100)]];
                [self performSelectorOnMainThread:@selector(updateProgressTitle:) withObject:strMsg waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat: fVal] waitUntilDone:YES];
                
//                BOOL blnUpdateWord = FALSE;
                
                NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_WORD)];
                DLog(@"strWord : %@", strWord);
//                if (strWord == NULL) {
//                    continue;
//                }
                
                NSString *strWordOri = @"";
                char *charWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_WORDORI);			
                if (charWordOri == NULL)
                    strWordOri = @"";
                else
                    strWordOri = [NSString stringWithUTF8String:charWordOri];	
//                
                NSString *strMeaning = @"";
                char *localityChars = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_MEANING);			
                if (localityChars == NULL)
                    strMeaning = @"";
                else
                    strMeaning = [NSString stringWithUTF8String:localityChars];						
                
                
                NSString *strDesc = @"";
                char *charDesc = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_Desc);			
                if (charDesc == NULL)
                    strDesc = @"";
                else
                    strDesc = [NSString stringWithUTF8String:charDesc];	

                
                NSString *strPronounce = @"";
                char *charPronounce = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_Pronounce);			
                if (charPronounce == NULL)
                    strPronounce = @"";
                else
                    strPronounce = [NSString stringWithUTF8String:charPronounce];


                NSInteger know = sqlite3_column_int(stmt, FLD_NO_tblEngDic_KNOW);
                NSInteger knowPronounce = sqlite3_column_int(stmt, FLD_NO_tblEngDic_KnowPronounce);
              
                NSString *strWordForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strWord];
                NSString *strWordOriForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strWordOri];            
                NSString *strMeaningForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strMeaning];
                NSString *strDescForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strDesc];
                NSString *strPronounceForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strPronounce];
                

                strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES('%@', '%@', %d,'%@','%@', '%@', %d)", TBL_EngDic, FldName_Word, FldName_WORDORI, FldName_Know, FldName_Meaning,FldName_DESC, FldName_Pronounce, FldName_KnowPronounce,  strWordForSQL, strWordOriForSQL, know, strMeaningForSQL, strDescForSQL, strPronounceForSQL, knowPronounce];
                [myCommon changeRec:strQuery openMyDic:TRUE]; 
                
                
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d, %@ = '%@', %@ = '%@',  %@ = '%@', %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_Know, know, FldName_Meaning, strMeaningForSQL, FldName_DESC, strDescForSQL, FldName_Pronounce, strPronounceForSQL, FldName_KnowPronounce, knowPronounce, FldName_Word, strWordForSQL];
                [myCommon changeRec:strQuery openMyDic:TRUE];		
            }
        }
  
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(dbMyDic);
        
        NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
        NSInteger minutes = elapsedTime/60;
        NSInteger seconds = round(elapsedTime - minutes * 60);
        NSString	*strElapsedTime  = nil;
        if (elapsedTime >= 60) {
            strElapsedTime = [NSString stringWithFormat:@"%d Minutes", minutes];
        } else {
            strElapsedTime = [NSString stringWithFormat:@"%d Seconds", seconds];
        }
        DLog(@"Elapsed time: %.0f, %@", elapsedTime, strElapsedTime);  
    
        NSString *strMsg = [NSString stringWithFormat:@"Time : %@\nCount of words : %d", strElapsedTime, cntOfWords];             
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:strMsg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];

        
        [actionSheetProgress dismissWithClickedButtonIndex:0 animated:YES];
        actionSheetProgress = nil;
        progressViewInActionSheet = nil;

        [myCommon closeDB:true];
        [myCommon openDB:true];
        
        [aiv stopAnimating];
	}
    
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
		UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Mail", @"")	message:NSLocalizedString(@"Success", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert2 show];
    } else if (result == MFMailComposeResultFailed) {
		UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send Mail", @"")	message:NSLocalizedString(@"Fail", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert2 show];
    }
	
    [self dismissModalViewControllerAnimated:YES];
	//	[txtMailAddress resignFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	if (tableView == self.searchDisplayController.searchResultsTableView) {			
		return 1;
	}
	return 1;		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [self.arrBackupFiles count];
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	NSString *strFileName = [NSString stringWithString:[self.arrBackupFiles objectAtIndex:indexPath.row]];
	NSMutableString *strFileNameWithDateAndTime = [NSMutableString stringWithString:strFileName];
	DLog(@"strFilename : %@", strFileName);
	NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:@"(.*)(\\d{14})(.*)" options:NSRegularExpressionCaseInsensitive error:nil];
	[regEx replaceMatchesInString:strFileNameWithDateAndTime options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strFileNameWithDateAndTime length]) withTemplate:@"$2"];
//	DLog(@"strFilename1 : %@", strFileName);


    
        if ([[strFileName uppercaseString] hasPrefix:@"MYDIC"] == TRUE) {
            cell.textLabel.text = [NSString stringWithFormat:@"myDic %@",  [myCommon restoreCurrentDatAndTimeForBackup:strFileNameWithDateAndTime]];
        } else {
            cell.textLabel.text = [myCommon restoreCurrentDatAndTimeForBackup:strFileNameWithDateAndTime];
        }
    
////    if ([[strFileName uppercaseString] hasPrefix:@"MYENGLISH"] == TRUE) {
//        //MyEnligsh로 시작하는 sqlite이면
//        cell.textLabel.text = [myCommon restoreCurrentDatAndTimeForBackup:strFileNameWithDateAndTime];
////    } else {
//        //myDic로 시작하는 sqlite이면..
//        if ([strFileName isEqualToString:fileNameWithExt_myDic] == TRUE) {
//            cell.textLabel.text = strFileName;
//        } else {
//            cell.textLabel.text = [NSString stringWithFormat:@"myDic %@",  [myCommon restoreCurrentDatAndTimeForBackup:strFileNameWithDateAndTime]];            
//
//        }
//    }

	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	for (int i = 0; i < [self.arrBackupFiles count]; i++) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
	cell1.accessoryType = UITableViewCellAccessoryCheckmark;
	self.strFileNameToMail = [self.arrBackupFiles objectAtIndex:indexPath.row];
    DLog(@"strFileNameToMail : %@", strFileNameToMail);
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return NSLocalizedString(@"Backup Files", @"");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *strBackupFile = [self.arrBackupFiles objectAtIndex:indexPath.row];
		NSString *filepath = [NSString stringWithFormat:@"%@/%@", [myCommon getDocPath], strBackupFile];	
		DLog(@"delete : %@", filepath);
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:filepath] == TRUE) {
			[fm removeItemAtPath:filepath error:nil];
		}
		[self.arrBackupFiles removeObjectAtIndex:indexPath.row];
		
		UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
		if (cell1.accessoryType == UITableViewCellAccessoryCheckmark) {
			self.strFileNameToMail = @"";
		}
		[self.tblBackup reloadData];
	}
}

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
