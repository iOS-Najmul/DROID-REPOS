//
//  myCommon.m
//  MyListPro
//
//  Created by 김형달 on 10. 8. 15..
//  Copyright 2010 엠앤소프트. All rights reserved.
//
//#import "/usr/include/sys/sysctl.h"
//#import "sysctl.h"
#import "myCommon.h"
#import "sqlite3.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
//#define cntWordToUpLevel 200
//
//#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


NSString	*strDBPath;
NSString    *strDBPathInBundle;
NSString    *strDBBookPath;
NSString	*strDocPath;
NSString    *strCachePath;
NSString    *strLatestBook;
//NSInteger appWidth;
//NSInteger appHeight;
NSInteger appWidthTemp;
NSInteger appHeightTemp;

float fBrightness;
sqlite3		*db;
sqlite3     *dbBook;
sqlite3     *dbOne;
sqlite3     *dbMyDinInBunlde;

@implementation myCommon
//@synthesize strDBPath;

+ (void) setEnv
{
    CGRect appFrame =[[ UIScreen mainScreen ] applicationFrame ];
    appWidthTemp = appFrame.size.width;
    appHeightTemp = appFrame.size.height;
    DLog(@"appHeightTemp : %d", appHeightTemp);
    
//	//iPad이면...
//	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//		appWidth = widthiPad;
//		appHeight = heightiPad;
//	} else {
//		appWidth = widthiPhone;
//		appHeight = heightiPhone;
////#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
////        if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
////            appHeight = heightiPhone5;
////        }
////#endif
//	}
}


+ (void) setDBPathInBundle
{
    strDBPathInBundle = [[NSBundle mainBundle] pathForResource:@"MyEnglish" ofType:@"sqlite"];
    DLog(@"strDBPathInBundle : %@", strDBPathInBundle);
}
+ (void) setDBPath:(NSString*)DBPath
{
    DLog(@"DBPath : %@", DBPath);
	strDBPath = DBPath;
    DLog(@"strDBPath : %@", strDBPath);
}
+ (void) setDBBookPath:(NSString*)DBBookPath
{
    DLog(@"DBBookPath : %@", DBBookPath);
	strDBBookPath = DBBookPath;
}
+ (void) setDocPath:(NSString*)DocPath
{
	strDocPath = DocPath;
}
+ (void) setCachePath:(NSString*)CachePath
{
	strCachePath = CachePath;
}
+ (void) setLatestBook:(NSString*)LatestBook
{
	strLatestBook = LatestBook;
}
+ (NSString*) getDBPath
{
	if (strDBPath == nil) {
		return @"";
	}
    DLog(@"strDBPath : %@", strDBPath);
	return strDBPath;
}
+ (NSString*) getDBBookPath
{
	if (strDBBookPath == nil) {
		return @"";
	}
    
	return strDBBookPath;
}
+ (NSString*) getDocPath
{
	if (strDocPath == nil) {
		return @"";
	}
	return strDocPath;
}
+ (NSString*) getCachePath
{
	if (strCachePath == nil) {
		return @"";
	}
	return strCachePath;
}
+ (NSString*) getLatestBook
{
	if (strLatestBook == nil) {
		return @"";
	}
	return strLatestBook;
}
//+ (NSInteger) getWidthDevice
//{
//	return appWidth;
//}
//+ (NSInteger) getHeightDevice
//{
//	return appHeight;
//}
+ (NSInteger) getAppWidth
{
	return appWidthTemp;
}
+ (NSInteger) getAppHeight
{
	return appHeightTemp;
}
+ (void) setBrightness:(float)brightness
{
    fBrightness = brightness;
}

+ (float) getBrightness
{
    return fBrightness;
}
+ (NSString*) commasForNumber:(NSNumber*)num
{
    if ([num intValue]<100) return [NSString stringWithFormat:@"%@", num];
    return [[self commasForNumber:[NSNumber numberWithInt:[num intValue]/1000]] stringByAppendingFormat:@",%03d",([num intValue] % 1000)];
}


+ (NSString*) getCurrentDate
{
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en=US"];
	[dateFormatter setLocale:locale];
	//연도를 가져온다.
	[dateFormatter setDateFormat:@"yyyy"];
	NSInteger year = [[dateFormatter stringFromDate:today] intValue];
	//월을 가져온다.
	[dateFormatter setDateFormat:@"MM"];
	NSInteger month = [[dateFormatter stringFromDate:today] intValue];
	//일을 가져온다.
	[dateFormatter	setDateFormat:@"dd"];
	NSInteger day = [[dateFormatter stringFromDate:today] intValue];
	//%02d는 2자리숫자로 표현
    return [NSString stringWithFormat:@"%d년 %02d월 %02d일", year, month, day];
}
+ (NSString*) getCurrentTime
{
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en=US"];
	[dateFormatter setLocale:locale];

	//시간을 가져온다.
	[dateFormatter	setDateFormat:@"hh"];
	NSInteger hour = [[dateFormatter stringFromDate:today] intValue];
	
	//분을 가져온다.
	[dateFormatter	setDateFormat:@"mm"];
	NSInteger minute = [[dateFormatter stringFromDate:today] intValue];
	
	//%02d는 2자리숫자로 표현
    return [NSString stringWithFormat:@"%02d시 %02d분", hour, minute];
	
}

+ (NSString*) getCurrentDatAndTime
{
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en=US"];
	[dateFormatter setLocale:locale];

	//연도를 가져온다.
	[dateFormatter setDateFormat:@"yyyy"];
	NSInteger year = [[dateFormatter stringFromDate:today] intValue];
	//월을 가져온다.
	[dateFormatter setDateFormat:@"MM"];
	NSInteger month = [[dateFormatter stringFromDate:today] intValue];
	//일을 가져온다.
	[dateFormatter	setDateFormat:@"dd"];
	NSInteger day = [[dateFormatter stringFromDate:today] intValue];
	
	//시간을 가져온다.
	[dateFormatter	setDateFormat:@"hh"];
	NSInteger hour = [[dateFormatter stringFromDate:today] intValue];

	//분을 가져온다.
	[dateFormatter	setDateFormat:@"mm"];
	NSInteger minute = [[dateFormatter stringFromDate:today] intValue];
	
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strDateTime = [dateFormatter stringFromDate:today];
//    DLog(@"strDateTime : %@", strDateTime);

	//%02d는 2자리숫자로 표현
    return [NSString stringWithFormat:@"%d년 %02d월 %02d일 %02d시 %02d분", year, month, day, hour, minute];
	
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
//    NSDate *date = [formatter dateFromString:score.datetime];

}

+ (NSString*) getCurrentDatAndTimeForBackup
{
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[dateFormatter setLocale:locale];

	
//	DLog(@"locale : %@", locale);
//	DLog(@"locale : %@", [NSLocale currentLocale]);
	
//	DLog(@"today : %@", today);
	//연도를 가져온다.
	[dateFormatter setDateFormat:@"yyyy"];
	NSInteger year = [[dateFormatter stringFromDate:today] intValue];
	//월을 가져온다.
	[dateFormatter setDateFormat:@"MM"];
	NSInteger month = [[dateFormatter stringFromDate:today] intValue];
	//일을 가져온다.
	[dateFormatter	setDateFormat:@"dd"];
	NSInteger day = [[dateFormatter stringFromDate:today] intValue];
	
	//시간을 가져온다.
	[dateFormatter	setDateFormat:@"HH"];
	NSInteger hour = [[dateFormatter stringFromDate:today] intValue];
	
	//분을 가져온다.
	[dateFormatter	setDateFormat:@"mm"];
	NSInteger minute = [[dateFormatter stringFromDate:today] intValue];

    //초를 가져온다.
	[dateFormatter	setDateFormat:@"ss"];
	NSInteger second = [[dateFormatter stringFromDate:today] intValue];

	//%02d는 2자리숫자로 표현
    return [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d", year, month, day, hour, minute, second];	
}

+ (NSString*) restoreCurrentDatAndTimeForBackup:(NSString*)strDateAndTime
{
	NSString *strYear =  [strDateAndTime substringWithRange:NSMakeRange (2, 2)];
	NSString *strMonth =  [strDateAndTime substringWithRange:NSMakeRange (4, 2)];
	NSString *strDay =  [strDateAndTime substringWithRange:NSMakeRange (6, 2)];
	NSString *strTime =  [strDateAndTime substringWithRange:NSMakeRange (8, 2)];
	NSString *strMinute =  [strDateAndTime substringWithRange:NSMakeRange (10, 2)];
    NSString *strSecond =  [strDateAndTime substringWithRange:NSMakeRange (12, 2)];
																		 
	NSString *strResult = [NSString stringWithFormat:@"%@.%@.%@ %@:%@:%@",strYear, strMonth, strDay, strTime, strMinute, strSecond];

    return strResult;	
}

//소문자로 바꾸고, 공백제거한다.
+ (NSString*) getCleanAndLowercase:(NSString*)strWord
{
	strWord = [strWord lowercaseString];
	strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	DLog(@"strWord Before : %@", strWord);
//	strWord = [strWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//	DLog(@"strWord After : %@", strWord);
//	DLog(@"strWord After \' : %@", [strWord stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]);
//	DLog(@"strWord After \' : %@", [strWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"]);
	return strWord;
}

//소문자로 바꾸고 공백제거하고, '를 넣을수 있게 해준다.
+ (NSString*) getCleanAndLowercaseAndSingleQuoteWordForSQL:(NSString*)strWord
{
    if ( (strWord == nil) || ([strWord isEqualToString:@""]) ) {
        return @"";
    }
    NSString *strResult = [NSString stringWithString:strWord];
	strResult = [strResult lowercaseString];
	strResult = [strResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//	DLog(@"strWord Before : %@", strWord);
	strResult = [strResult stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	//	DLog(@"strWord After : %@", strWord);
	//	DLog(@"strWord After \' : %@", [strWord stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]);
	//	DLog(@"strWord After \' : %@", [strWord stringByReplacingOccurrencesOfString:@"'" withString:@"''"]);
	return strResult;
}

//공백제거하고, '를 넣을수 있게 해준다.
+ (NSString*) getCleanAndSingleQuoteWordForSQL:(NSString*)strWord
{
     NSString *strResult = [NSString stringWithString:strWord];
	strResult = [strResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	strResult = [strResult stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	return strResult;
}

// 모델 정보 보기 - 상세히
+ (NSString *) getPlatformString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    /*
        10.Possible values:
        11."i386" = iPhone Simulator
        12."iPhone1,1" = iPhone 1G
        13."iPhone1,2" = iPhone 3G
        14."iPhone2,1" = iPhone 3GS
        15."iPhone3,1" = iPhone 4
        16."iPod1,1"   = iPod touch 1G
        17."iPod2,1"   = iPod touch 2G
        18."iPod3,1"   = iPod touch 3G
        19.*/
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}



+ (NSMutableString*) readTxtWithEncoding:(NSString*)strFileName
{
    NSError *error;
    NSStringEncoding encoding;
    NSMutableString *strResultString = [NSMutableString stringWithContentsOfFile:strFileName usedEncoding:&encoding error:&error];

    if (nil == strResultString)
    {
        //DLog(@"Checking kCFStringEncodingDOSKorean encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:(0x80000000+kCFStringEncodingMacKorean) error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking kCFStringEncodingDOSKorean encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:(0x80000000+kCFStringEncodingEUC_KR) error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking UTF-8 encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:NSUTF8StringEncoding error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking ISO Latin-1 encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:NSISOLatin1StringEncoding error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking Windows Latin-1 encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:NSWindowsCP1252StringEncoding error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking Mac OS Roman encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:NSMacOSRomanStringEncoding error:NULL];
    }

    if (nil == strResultString)
    {
        //DLog(@"Checking ASCII encoding...");
        strResultString = [NSMutableString stringWithContentsOfFile:strFileName encoding:NSASCIIStringEncoding error:NULL];
    }

    if (strResultString == nil) {
        DLog(@"error : %@", [error localizedDescription]);
        DLog(@"error : %@", [error localizedRecoverySuggestion]);
//        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Can't read. \n\n-Message-\n", @""), [error localizedDescription]]  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//        [alert2 show];
        [strResultString setString:@""];
    }
    
//    DLog(@"strResultString: %@", strResultString);
    return strResultString;

}
#pragma mark -
#pragma mark EBookView관련 함수

+ (NSMutableString*)HTMLFromTextString:(NSMutableString *)originalText 
{	
	NSString *header = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<style type=\"text/css\">body {font-size:12pt;font-weight:normal} font.GREEN { font-size : 12pt; font-weight : normal; color : green;vertical-align:sup }	font.BLUE {font-size : 12pt;font-weight : normal;color : blue; vertical-align:sup} font.RED { font-size : 12pt; font-weight : normal; color : red; vertical-align:sup}  </style>\n<title></title>\n</head>\n\n<body>\n<p>\n";
	//NSString *header = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<style type=\"text/css\">body {font-size:12pt;font-weight:normal}</style>\n<title></title>\n</head>\n\n<body>\n<p>\n";
	NSMutableString *outputHTML;
	NSRange fullRange = NSMakeRange(0, [originalText length]);
	DLog(@"[originalText length] : %d", [originalText length]);
	
	
	unsigned int i,j;
	j=0;
	i = [originalText replaceOccurrencesOfString:@"&" withString:@"&amp;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d &s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	i = [originalText replaceOccurrencesOfString:@"<" withString:@"&lt;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d <s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	i = [originalText replaceOccurrencesOfString:@">" withString:@"&gt;"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d >s\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	// Argh, bloody MS line breaks!  Change them to UNIX, then...
	i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@"\n"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d carriage return/newlines\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	
	//Change double-newlines to </p><p>.
	i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-newlines\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	// And just in case someone has a Classic MacOS textfile...
	i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-carriage-returns\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	// Lots of text files start new paragraphs with newline-space-space or newline-tab
	i = [originalText replaceOccurrencesOfString:@"\n  " withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-spaces\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@"</p>\n<p>"
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-spaces\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	i = [originalText replaceOccurrencesOfString:@"  " withString:@"&nbsp; "
										 options:NSLiteralSearch range:fullRange];
	//DLog(@"replaced %d double-spaces\n", i);
	j += i;
	fullRange = NSMakeRange(0, [originalText length]);
	
	
	outputHTML = [NSMutableString stringWithFormat:@"%@%@\n</p><br /><br />\n</body>\n</html>\n", header, originalText];
	
	return outputHTML;  
}

+ (NSMutableString*)HTMLFromHTMLString:(NSMutableString *)originalText 
{
	//아래는 css파일을 외부로 뺄때의 소스이다... bundle밑에 있을때는 어떻게 경로를 가져올까?
	//<link rel="stylesheet" media="screen" type="text/css" href="파일명.css" />
	
	NSMutableString *outputHTML;
	
	//NSString *strCSS = @"<style type=\"text/css\">body {font-size:12pt;font-weight:normal;text-transform:capitalize; text-align:right; line-height:50px; letter-spacing:5px ;word-spacing:10px; text-decoration:line-through; margin:2px;} font.GREEN { font-size : 12pt; font-weight : normal; color : green; }	font.BLUE {font-size : 12pt;font-weight : normal;color : blue; } font.RED { font-size : 12pt; font-weight : normal; color : red; }  </style>\n";
	NSString *strCSS = @"<style type=\"text/css\">body {font-size:12pt;font-weight:normal; } font.GREEN { font-size : 12pt; font-weight : normal; color : green; }	font.BLUE {font-size : 12pt;font-weight : normal;color : blue; } font.RED { font-size : 12pt; font-weight : normal; color : red; }  </style>\n";
	NSString *strHEADTag = @"<head>";
	NSString *strHTMLTag = @"<html>";
	NSRange rng = [originalText rangeOfString:strHEADTag];
//	NSRange fullRange = NSMakeRange(0, [originalText length]);
	DLog(@"[originalText length] : %d", [originalText length]);
//	DLog(@"fullRange : %@", fullRange);
	if (rng.location != NSNotFound) {
		NSMutableString *strStringToReplace = [[NSMutableString alloc] initWithFormat:@"%@\n%@", strHEADTag, strCSS];
		[originalText replaceCharactersInRange:rng withString:strStringToReplace];

	} else {
		rng = [originalText rangeOfString:strHTMLTag];
	
		if (rng.location != NSNotFound) {
			NSMutableString *strStringToReplace = [[NSMutableString alloc] initWithFormat:@"%@\n%@", strHTMLTag, strCSS];
			[originalText replaceCharactersInRange:rng withString:strStringToReplace];
		} 	 
	}
	
	outputHTML = [NSMutableString stringWithFormat:@"%@",originalText];
	DLog(@"outputHTML : %@", outputHTML);
	return outputHTML;  
}


#pragma mark -  
#pragma mark sqlite3 관련 함수   

+ (BOOL) chkTableExist:(NSString*)strTableName OpenMyDic:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
    
	BOOL blnExist = FALSE;
	NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@", strTableName];
	//DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int ret1 = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (ret1 == SQLITE_OK) 
	{
		blnExist = TRUE;
	} else {
		blnExist = FALSE;
	}

	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnExist;	
}

+ (BOOL) chkFieldExist:(NSString*)strFieldName TableName:(NSString*)strTableName OpenMyDic:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }

	BOOL blnExist = FALSE;
	NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@",strFieldName, strTableName];
	DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int ret1 = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (ret1 == SQLITE_OK) 
	{
		blnExist = TRUE;
	} else {
		blnExist = FALSE;
	}
    
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnExist;	
}

+ (BOOL) openDBMyDicInBundle
{
    dbMyDinInBunlde = nil;
    DLog(@"strDBPathInBundle : %@", strDBPathInBundle);
    if (sqlite3_open([strDBPathInBundle UTF8String], &dbMyDinInBunlde) != SQLITE_OK)
    {
        sqlite3_close(dbMyDinInBunlde);
        DLog(@"Can't open DB : %@", strDBPathInBundle);
        return FALSE;
    }
    return TRUE;
}
+ (BOOL) openDB:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        db = nil;
        if (sqlite3_open([strDBPath UTF8String], &db) != SQLITE_OK)
        {
            sqlite3_close(db);
            DLog(@"Can't open DB : %@", strDBPath);
            return FALSE;
        }
        dbOne = db;
    } else {
        dbBook = nil;
        DLog(@"DB : %@", strDBBookPath);
        if (sqlite3_open([strDBBookPath UTF8String], &dbBook) != SQLITE_OK)
        {
            sqlite3_close(dbBook);
            DLog(@"Can't open DB : %@", strDBBookPath);
            return FALSE;
        } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                DLog(@"strDBBookPath : %@", strDBBookPath);
                NSURL *pathURL= [NSURL fileURLWithPath:strDBBookPath];                
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }                
            }            
#endif
        }
        dbOne = dbBook;
    }
    
//    sqlite3_exec( db, "VACUUM", NULL, NULL, NULL );
	return TRUE;
	
}

+ (void) transactionBegin:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
    if (openMyDic == TRUE) {
       sqlite3_exec( dbOne, "BEGIN", NULL, NULL, NULL );
    }
}

+ (void) transactionCommit:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
	sqlite3_exec( dbOne, "COMMIT", NULL, NULL, NULL );
}

+ (void) compressDB:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
    sqlite3_exec( dbOne, "VACUUM", NULL, NULL, NULL );
}

+ (BOOL) closeDBMyDicInBundle
{
    if (strDBPathInBundle != NULL) {
        sqlite3_close(dbMyDinInBunlde);
    }
    return TRUE;
}
+ (BOOL) closeDB:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
	if (dbOne != NULL) {
		sqlite3_close(dbOne);
	}
	return TRUE;
}

//단어또는 문장이 존재하는지 여부를 알려준다.
+ (BOOL) chkWordExist:(NSString*)strWord  intDicWordOrIdiom:(NSInteger)intDicWordOrIdiom openMyDic:(NSInteger)openMyDic
{
    
    NSString *strTblName = TBL_EngDic;
    //DicWordOrIdiom_Proverb일때는 테이블이 다르다. (Pharasal Verb등은 Eng_Dic에서 찾아야 한다.)
    if (intDicWordOrIdiom == DicWordOrIdiom_Proverb) {
        strTblName = TBL_Idiom;
    }
    NSString *strWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@';", strTblName, FldName_Word, strWordForSQL];
    return [self chkRecExist:strQuery openMyDic:openMyDic];
}
+ (BOOL) chkRecExist:(NSString*)strQuery  openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }

//    DLog(@"strQuery : %@", strQuery);
	BOOL blnExist = FALSE;
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	if (sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			blnExist = TRUE;
		} else {
			blnExist = FALSE;
		}
	}	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnExist;
}



+ (BOOL) changeRec:(NSString*)strQuery openMyDic:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
	DLog(@"strQuery : %@", strQuery);
	BOOL blnChanged = FALSE;	
	
	sqlite3_stmt *stmt = nil;
	const char *sqlQuery = [strQuery UTF8String];
	int ret1 = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (ret1 == SQLITE_OK) 
	{
		int ret = sqlite3_step(stmt);
		if (SQLITE_DONE != ret) {
			//Tip)sqlite3_errmsg(db)를 %@로 뿌리면 죽는다. %s로 뿌려야 한다.
			DLog(@"Fail sqlite3_step : %@\n ErrMsg : %s", strQuery, sqlite3_errmsg(dbOne));
		}
		blnChanged = TRUE;
	} else {
			DLog(@"Fail sqlite3_prepare_v2 : %@\n ErrMsg : %s", strQuery, sqlite3_errmsg(dbOne));
	}

	
//	if (sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
//		int ret = sqlite3_step(stmt);
//		if (SQLITE_DONE != ret) {
//			DLog(@"Fail : %@, error code %d", sqlQuery, ret);
//		}
//		blnChanged = TRUE;
//	}
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	
	return blnChanged;
}

//SQL문을 실행한다.
+(BOOL) executeSqlQuery:(NSString*)strQuery openMyDic:(BOOL)openMyDic
{
    BOOL blnResult = FALSE;
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
    
//	//일단 기존에 존재하는 테이블은 삭제후 다시만들고 거기에 적는다.
//    [self closeDB:openMyDic];
//    [self openDB:openMyDic];
//	sqlite3_stmt *statement = nil;
	DLog(@"strQuery : %@", strQuery);		
	const char *sqlQuery = [strQuery UTF8String];
    
    int ret = sqlite3_exec(dbOne, sqlQuery, nil, nil, nil);
	if (ret == SQLITE_OK)
	{
        DLog(@"Success SQL : %@", strQuery);
        blnResult = TRUE;
    } else {
        DLog(@"ERROR SQL : %@", strQuery);
    }
    return blnResult;
//    sqlite3_reset(statement);
//	sqlite3_finalize(statement);
}


//책에 사용될 SQLite를 Default로부터 복사한다.
+ (BOOL) copyBookSQLiteFromDefault:(NSString*)strFullPathBookName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dbExists = [fileManager fileExistsAtPath:strFullPathBookName];
    DLog(@"strFullPathBookName : %@", strFullPathBookName);
DLog(@"dbExists : %d", dbExists);
   

    if(!dbExists)
    {
        NSString	*defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileNameWithExt_MyEnglish_BOOK];
        DLog(@"defaultDBPath : %@", defaultDBPath);
//        BOOL dbExists1 = [fileManager fileExistsAtPath:defaultDBPath];
//        DLog(@"dbExists1 : %d", dbExists1);
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:strFullPathBookName error:&error];
        if (!success) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Name of warning")	message:NSLocalizedString(@"Can't copy MyEnglish.sqlite(Dictionary file) to Document folder.", @"Name of CannotCopyMyDic")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        } else {
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                //                    NSString *strMyEnglishFullPath = [myCommon getDBPath];
                //                    DLog(@"strMyDicFullPath : %@", strMyEnglishFullPath);
                NSURL *pathURL= [NSURL fileURLWithPath:strFullPathBookName];                
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }                
            }            
#endif            
        }
    }
    return TRUE;
}
////TBL_EngDic_ 북 테이블을 만든다.
//+ (BOOL) createBookTable:(NSString*)strTblName openMyDic:(NSInteger)openMyDic
//{
//    BOOL blnResult = TRUE;
//    
//    if (openMyDic == OPEN_DIC_DB) {
//        dbOne = db;
//    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
//        dbOne = dbBook;
//    }
//
//
//	//일단 기존에 존재하는 테이블은 삭제후 다시만들고 거기에 적는다.
//    //engDic를 지우고 다시 만든다.
//    [self closeDB:openMyDic];
//    [self openDB:openMyDic];
//	sqlite3_stmt *statTBL_EngDicDropQuery = nil;
//	NSString	*strTBL_EngDicDropQuery = [NSString	stringWithFormat:@"DROP TABLE  IF EXISTS %@", strTblName];
//	
//	DLog(@"strTBL_EngDicDropQuery createTable : %s", [strTBL_EngDicDropQuery UTF8String]);		
//	const char *sqlTBL_EngDicDropQuery = [strTBL_EngDicDropQuery UTF8String];
//	int retDrop = sqlite3_prepare_v2(dbOne, sqlTBL_EngDicDropQuery, -1, &statTBL_EngDicDropQuery, NULL);
//	if (retDrop == SQLITE_OK) {
//		int ret = sqlite3_step(statTBL_EngDicDropQuery);
//		if(SQLITE_DONE != ret)			
//		{			
//			DLog(@"Drop Table Error step createTable while %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//		}
//	} else {
//		DLog(@"Drop Table Error createTable while prepare %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//	}		
//	sqlite3_reset(statTBL_EngDicDropQuery);
//	sqlite3_finalize(statTBL_EngDicDropQuery);
//	
//	
//	NSString *strSqlCreatTable1 = [NSString stringWithFormat:@"CREATE TABLE %@", strTblName];
//	NSString *strSqlCreatTable2 = @" (\"Word\" CHAR PRIMARY KEY NOT NULL UNIQUE , \"WordOri\" CHAR default \"\", \"Meaning\" CHAR DEFAULT \"\", \"Desc\" CHAR default \"\", \"Count\" INTEGER DEFAULT 0 , \"Know\" INTEGER DEFAULT 0 , \"ToMemorize\" INTEGER DEFAULT 0 , \"Favorite\" INTEGER DEFAULT 0, \"WordLevel1\" INTEGER DEFAULT 999, \"WordLevel2\" INTEGER DEFAULT 999, \"WordLevel3\" INTEGER DEFAULT 999, \"Synonym\" CHAR DEFAULT \"\", \"Antonym\" CHAR default \"\", \"Derived\" INTEGER DEFAULT 999, \"WordType\" CHAR  DEFAULT \"\", \"Irreg\" INTEGER DEFAULT 0, \"Tag\" CHAR default \"\", \"InstalledWord\" INTEGER DEFAULT 0, \"Know_Standard\" INTEGER DEFAULT 0, \"Know_Friend1\" INTEGER DEFAULT 0, \"Know_Friend2\" INTEGER DEFAULT 0, \"Knowe_Friend3\" INTEGER DEFAULT 0, \"FirstAdd\" DATETIME DEFAULT  CURRENT_TIMESTAMP, \"FirstSee\" DATETIME, \"LastSee\" DATETIME, \"Pronounce\" CHAR default \"\", \"Pronounce1\" CHAR default \"\", \"KnowPronounce\" INTEGER DEFAULT 0, \"CATEGORY1\" INTEGER DEFAULT 0, \"CATEGORY2\" INTEGER DEFAULT 0, \"CATEGORY3\" INTEGER DEFAULT 0, \"CATEGORY4\" INTEGER DEFAULT 0, \"CATEGORY5\" INTEGER DEFAULT 0, \"CATEGORY6\" INTEGER DEFAULT 0, \"CATEGORY7\" INTEGER DEFAULT 0, \"CATEGORY8\" INTEGER DEFAULT 0, \"CATEGORY9\" INTEGER DEFAULT 0,  \"RESERV1_INT\" INTEGER DEFAULT 0, \"RESERV2_INT\" INTEGER DEFAULT 0, \"RESERV3_INT\" INTEGER DEFAULT 0, \"RESERV1_CHAR\" CHAR DEFAULT \"\", RESERV2_CHAR CHAR DEFAULT '', \"RESERV3_CHAR\" CHAR DEFAULT \"\", \"RESERV1_BLOB\" BLOB, \"RESERV2_BLOB\" BLOB, \"RESERV3_BLOB\" BLOB, \"WORDORDER\" INTEGER DEFAULT 0)";
//    
//	NSString *strCreateTable = [NSString stringWithFormat:@"%@ %@", strSqlCreatTable1, strSqlCreatTable2];
//    DLog(@"strCreateTable : %@", strCreateTable);
//    
//    const char *sqlCreateTable = [strCreateTable UTF8String];
//	int retCreate = sqlite3_exec(dbOne, sqlCreateTable, nil, nil, nil);
//	if ( retCreate != SQLITE_OK)
//	{
//		DLog(@"%@",[NSString stringWithFormat:@"Create Table Error createTable while %@ : '%s'", strCreateTable, sqlite3_errmsg(dbBook)]);		
//#ifdef DEBUG
//		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:@"Fail to create table" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//		[alert show];
//#endif
//		blnResult = FALSE;
//	} 
//    
//    //개별 책에서는 WordHistory를 지우고 다시 만든다.
//    if (openMyDic == OPEN_DIC_DB_BOOK) {    
//        strTblName = TBL_WordHistory;
//        
//        strTBL_EngDicDropQuery = [NSString	stringWithFormat:@"DROP TABLE  IF EXISTS %@", strTblName];
//        
//        DLog(@"strTBL_EngDicDropQuery createTable : %s", [strTBL_EngDicDropQuery UTF8String]);		
//        const char *sqlTBL_EngDicDropQuery = [strTBL_EngDicDropQuery UTF8String];
//        int retDrop = sqlite3_prepare_v2(dbOne, sqlTBL_EngDicDropQuery, -1, &statTBL_EngDicDropQuery, NULL);
//        if (retDrop == SQLITE_OK) {
//            int ret = sqlite3_step(statTBL_EngDicDropQuery);
//            if(SQLITE_DONE != ret)			
//            {			
//                DLog(@"Drop Table Error step createTable while %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//            }
//        } else {
//            DLog(@"Drop Table Error createTable while prepare %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//        }		
//        sqlite3_reset(statTBL_EngDicDropQuery);
//        sqlite3_finalize(statTBL_EngDicDropQuery);
//        
//        
//        strSqlCreatTable1 = [NSString stringWithFormat:@"CREATE TABLE %@", strTblName];
//        strSqlCreatTable2 = @" (\"Word\" CHAR NOT NULL, \"UpdateTime\" DATETIME DEFAULT (CURRENT_TIMESTAMP), \"Know_old\" INTEGER, \"Know_new\" INTEGER)";
//        
//        NSString *strCreateTable = [NSString stringWithFormat:@"%@ %@", strSqlCreatTable1, strSqlCreatTable2];
//        DLog(@"strCreateTable : %@", strCreateTable);
//        
//        const char *sqlCreateTable = [strCreateTable UTF8String];
//        int retCreate = sqlite3_exec(dbOne, sqlCreateTable, nil, nil, nil);
//        if ( retCreate != SQLITE_OK)
//        {
//            DLog(@"%@",[NSString stringWithFormat:@"Create Table Error createTable while %@ : '%s'", strCreateTable, sqlite3_errmsg(dbBook)]);		
//    #ifdef DEBUG
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:@"Fail to create table" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//            [alert show];
//    #endif
//            blnResult = FALSE;
//        } 
//        
//        
//        //모든 단어를 순서대로 적은 테이블을 생성한다.(최소 단어위주)
//        strTblName = TBL_WordOrder;
//        
//        strTBL_EngDicDropQuery = [NSString	stringWithFormat:@"DROP TABLE  IF EXISTS %@", strTblName];
//        
//        DLog(@"strTBL_EngDicDropQuery createTable : %s", [strTBL_EngDicDropQuery UTF8String]);		
//        const char *sqlTBL_EngDicDropQuery1 = [strTBL_EngDicDropQuery UTF8String];
//        retDrop = sqlite3_prepare_v2(dbOne, sqlTBL_EngDicDropQuery1, -1, &statTBL_EngDicDropQuery, NULL);
//        if (retDrop == SQLITE_OK) {
//            int ret = sqlite3_step(statTBL_EngDicDropQuery);
//            if(SQLITE_DONE != ret)			
//            {			
//                DLog(@"Drop Table Error step createTable while %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//            }
//        } else {
//            DLog(@"Drop Table Error createTable while prepare %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//        }		            
//        sqlite3_reset(statTBL_EngDicDropQuery);
//        sqlite3_finalize(statTBL_EngDicDropQuery);
//
//        
//        
//        strSqlCreatTable1 = [NSString stringWithFormat:@"CREATE TABLE %@", strTblName];
//        strSqlCreatTable2 = @" (\"Word\" CHAR NOT NULL, \"Offset\" INTEGER)";
//        
//        strCreateTable = [NSString stringWithFormat:@"%@ %@", strSqlCreatTable1, strSqlCreatTable2];
//        DLog(@"strCreateTable : %@", strCreateTable);
//        
//        const char *sqlCreateTable1 = [strCreateTable UTF8String];
//        retCreate = sqlite3_exec(dbOne, sqlCreateTable1, nil, nil, nil);
//        if ( retCreate != SQLITE_OK)
//        {
//            DLog(@"%@",[NSString stringWithFormat:@"Create Table Error createTable while %@ : '%s'", strCreateTable, sqlite3_errmsg(dbBook)]);		
//#ifdef DEBUG
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:@"Fail to create table" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//            [alert show];
//#endif
//            blnResult = FALSE;
//        } 
////        [myCommon createIndexInSQLite:strTblName fldName:FldName_OFFSET openMyDic:OPEN_DIC_DB_BOOK];
//        
//        //모든 단어를 순서대로 적은 테이블을 생성한다. (Full 단어 위주)
//        strTblName = TBL_FullWordOrder;
//        
//        strTBL_EngDicDropQuery = [NSString	stringWithFormat:@"DROP TABLE  IF EXISTS %@", strTblName];
//        
//        DLog(@"strTBL_EngDicDropQuery createTable : %s", [strTBL_EngDicDropQuery UTF8String]);		
//        const char *sqlTBL_EngDicDropQuery2 = [strTBL_EngDicDropQuery UTF8String];
//        retDrop = sqlite3_prepare_v2(dbOne, sqlTBL_EngDicDropQuery2, -1, &statTBL_EngDicDropQuery, NULL);
//        if (retDrop == SQLITE_OK) {
//            int ret = sqlite3_step(statTBL_EngDicDropQuery);
//            if(SQLITE_DONE != ret)			
//            {			
//                DLog(@"Drop Table Error step createTable while %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//            }
//        } else {
//            DLog(@"Drop Table Error createTable while prepare %@ : '%s'", strTBL_EngDicDropQuery, sqlite3_errmsg(dbBook));
//        }		
//        sqlite3_reset(statTBL_EngDicDropQuery);
//        sqlite3_finalize(statTBL_EngDicDropQuery);
//        
//        
//        strSqlCreatTable1 = [NSString stringWithFormat:@"CREATE TABLE %@", strTblName];
//        strSqlCreatTable2 = @" (\"Word\" CHAR NOT NULL, \"Offset\" INTEGER)";
//        
//        strCreateTable = [NSString stringWithFormat:@"%@ %@", strSqlCreatTable1, strSqlCreatTable2];
//        DLog(@"strCreateTable : %@", strCreateTable);
//        
//        const char *sqlCreateTable2 = [strCreateTable UTF8String];
//        retCreate = sqlite3_exec(dbOne, sqlCreateTable2, nil, nil, nil);
//        if ( retCreate != SQLITE_OK)
//        {
//            DLog(@"%@",[NSString stringWithFormat:@"Create Table Error createTable while %@ : '%s'", strCreateTable, sqlite3_errmsg(dbBook)]);		
//#ifdef DEBUG
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")	message:@"Fail to create table" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//            [alert show];
//#endif
//            blnResult = FALSE;
//        }
////        [myCommon createIndexInSQLite:strTblName fldName:FldName_OFFSET openMyDic:OPEN_DIC_DB_BOOK];
//        
//    }
//    
//    return blnResult;
//}


+ (void) createBookSettingInTableIfNotExist:(NSMutableDictionary*)dicOne fileName:(NSString*)strFileName
{ 
	[dicOne removeAllObjects];
    
	sqlite3_stmt *statement = nil;
	NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ Where %@ = \"%@\"", TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strFileName];
    DLog(@"strQuery : %s", [strQuery UTF8String]);		
	const char *sqlQuery = [strQuery UTF8String];
	if (sqlite3_prepare_v2(db, sqlQuery, -1, &statement, NULL) == SQLITE_OK) {
        int ret = sqlite3_step(statement);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)){			
			float lastPage = sqlite3_column_double(statement, FLD_NO_BOOK_LIST_LastPage);
            DLog(@"LastPage : %f", lastPage);
			[dicOne setValue:[NSNumber numberWithFloat:lastPage] forKey:@"LastPage"];
			
//			NSInteger fontSizeTemp = sqlite3_column_int(statement, 7);
//			if (fontSizeTemp == 0) {
//				fontSizeTemp = 120;
//			}
//			if (fontSizeTemp < 100) {
//				fontSizeTemp = 80;
//			}					
//			if (fontSizeTemp > 200) {
//				fontSizeTemp = 200;
//			}
//            //			DLog(@"Font : %d", Font);
//			[dicOne setValue:[NSNumber numberWithInt:fontSizeTemp] forKey:@"Font"];
            
//			NSInteger BackLight = sqlite3_column_int(statement, 8);
//            //			DLog(@"BackLight : %d", BackLight);
//			[dicOne setValue:[NSNumber numberWithInt:BackLight] forKey:@"BackLight"];
			
//			NSInteger ShowKnow = sqlite3_column_int(statement, 9);
//			if (ShowKnow == 0) {
//				[dicOne setValue:[NSNumber numberWithInt:0] forKey:@"ShowKnow"];
//			} else {
//				[dicOne setValue:[NSNumber numberWithInt:1] forKey:@"ShowKnow"];
//			}
//			
//			NSInteger ShowCount = sqlite3_column_int(statement, 17);
//			if (ShowCount == 0) {
//				[dicOne setValue:[NSNumber numberWithInt:0] forKey:@"ShowCount"];
//			} else {
//				[dicOne setValue:[NSNumber numberWithInt:1] forKey:@"ShowCount"];
//			}
		}
	}
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    
    
    sqlite3_stmt *statENV = nil;
	NSString *strQueryENV = [NSString	stringWithFormat:@"SELECT * FROM %@", TBL_APP_INFO];
    //	DLog(@"strQuery : %s", [strQuery UTF8String]);		
	const char *sqlQueryENV = [strQueryENV UTF8String];
	if (sqlite3_prepare_v2(db, sqlQueryENV, -1, &statENV, NULL) == SQLITE_OK) {
		if (sqlite3_step(statENV) == SQLITE_ROW) {
            NSInteger ShowMeaning = sqlite3_column_int(statENV, FLD_NO_APP_INFO_FldName_SHOWMEANING);
			if (ShowMeaning == 0) {
				[dicOne setValue:[NSNumber numberWithInt:0] forKey:@"Show Meaning"];
			} else {
				[dicOne setValue:[NSNumber numberWithInt:1] forKey:@"Show Meaning"];
			}

            NSInteger BackLight = sqlite3_column_int(statENV, FLD_NO_APP_INFO_BackLight);
            //			DLog(@"BackLight : %d", BackLight);
			[dicOne setValue:[NSNumber numberWithInt:BackLight] forKey:@"BackLight"];
			
            NSInteger Difficulty_VeryEasy = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_VeryEasy);
            //			DLog(@"BackLight : %d", BackLight);
			[dicOne setValue:[NSNumber numberWithInt:Difficulty_VeryEasy] forKey:@"Difficulty_VeryEasy"];
            NSInteger Difficulty_Easy = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Easy);
            //			DLog(@"BackLight : %d", BackLight);
			[dicOne setValue:[NSNumber numberWithInt:Difficulty_Easy] forKey:@"Difficulty_Easy"];
            NSInteger Difficulty_Good = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Good);
            //			DLog(@"BackLight : %d", BackLight);
			[dicOne setValue:[NSNumber numberWithInt:Difficulty_Good] forKey:@"Difficulty_Good"];
            NSInteger Difficulty_Hard = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Hard);
            //			DLog(@"BackLight : %d", BackLight);
			[dicOne setValue:[NSNumber numberWithInt:Difficulty_Hard] forKey:@"Difficulty_Hard"];
//            DLog(@"dicOne : %@", dicOne);
		}
	}
    
//    DLog(@"dicOne : %@", dicOne);
    sqlite3_reset(statENV);
    sqlite3_finalize(statENV);
    
}

+ (const CGFloat*) getColorComponents:(NSString*)strColorName
{
    UIColor *color = [UIColor blackColor];
    if ([[strColorName uppercaseString] isEqualToString:@"BLACK"]) {
        color = [UIColor blackColor]; 
    } else if ([[strColorName uppercaseString] isEqualToString:@"BLUE"]) {
        color = [UIColor blueColor]; 
    } else if ([[strColorName uppercaseString] isEqualToString:@"BROWN"]) {
        color = [UIColor brownColor]; 
    } else if ([[strColorName uppercaseString] isEqualToString:@"GREEN"]) {
        color = [UIColor greenColor]; 
    } else if ([[strColorName uppercaseString] isEqualToString:@"RED"]) {
        color = [UIColor redColor]; 
    } else if ([[strColorName uppercaseString] isEqualToString:@"WHITE"]) {
        color = [UIColor whiteColor]; 
    }
    return CGColorGetComponents( [color CGColor] );
}

+ (void) CreateCSS:(NSMutableDictionary*)dicCss option:(NSInteger)optCSS
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
//    DLog(@"dicCSS : %@", dicCss);
    //주만모드이면...
    if (optCSS <= 2) {
        NSDictionary *dicBody = [dicCss objectForKey:KEY_CSS_BODY];
        NSMutableDictionary *dicWORDNotRated = [dicCss objectForKey:KEY_CSS_WORDNotRated];
        NSMutableDictionary *dicWORDUnknown = [dicCss objectForKey:KEY_CSS_WORDUnknown];
        NSMutableDictionary *dicWORDNotSure = [dicCss objectForKey:KEY_CSS_WORDNotSure];
        NSMutableDictionary *dicWORDNotRatedIdiom = [dicCss objectForKey:KEY_CSS_WORDNotRatedIdiom];
        NSMutableDictionary *dicWORDUnknownIdiom = [dicCss objectForKey:KEY_CSS_WORDUnknownIdiom];
        NSMutableDictionary *dicWORDNotSureIdiom = [dicCss objectForKey:KEY_CSS_WORDNotSureIdiom];
        
    //    NSDictionary *dicWORDKnown = [dicCss objectForKey:@"WORDKnown"];
    //    NSDictionary *dicWORDExclude = [dicCss objectForKey:@"WORDExclude"];
        
        NSMutableString *strCSS = [NSMutableString stringWithFormat:@""];
        
        //지우지말것)CSS를 이용한 Column활용법
    //    [strCSS appendString:[NSString stringWithFormat:@"body{-webkit-column-count: 2;-webkit-column-width: 130px;-webkit-column-gap: 10px;; background-color : rgb(192,192,192)}\n"]];
    //        [strCSS appendString:[NSString stringWithFormat:@"body{-webkit-column-width: 50px;height: 300px;; background-color : rgb(192,192,192)}\n"]];
        
//        if ( (dicBody != nil) && ([dicBody count] > 0) ) {
//            NSInteger fontSize = [[dicBody objectForKey:@"FontSize"] integerValue];
//            if (fontSize == 0) {
//                fontSize = 12;
//            }
//            NSInteger lineHeight = [[dicBody objectForKey:@"LineHeight"] integerValue];        
//            if (lineHeight == 0) {
//    //            [strCSS appendString:[NSString stringWithFormat:@"body{background-color : rgb(255,255,255); font-size:%dpt}\n", fontSize]];
//
//    //            [strCSS appendString:[NSString stringWithFormat:@"body{padding:0; background-color : rgb(255,255,255); font-size:%dpt}\n", fontSize]];
//                NSInteger redFont = [[dicBody objectForKey:@"FontColor_Red"] integerValue];
//                NSInteger greenFont = [[dicBody objectForKey:@"FontColor_Green"] integerValue];
//                NSInteger blueFont = [[dicBody objectForKey:@"FontColor_Blue"] integerValue];
//                NSInteger alphaFont = [[dicBody objectForKey:@"FontColor_Alpha"] integerValue];
//                NSInteger redBack = [[dicBody objectForKey:@"BackColor_Red"] integerValue];
//                NSInteger greenBack = [[dicBody objectForKey:@"BackColor_Green"] integerValue];
//                NSInteger blueBack = [[dicBody objectForKey:@"BackColor_Blue"] integerValue];
//                NSInteger alphaBack = [[dicBody objectForKey:@"BackColor_Alpha"] integerValue];
//                
//    //            UIColor *backColor = [dicBody objectForKey:@"BackColor"];            
//    //            if ((fontColor == nil) || (backColor == nil)) {
//    //                [strCSS appendString:[NSString stringWithFormat:@"body{padding:0; color : rgb(255,255,255); background-color : rgb(10,10,10); font-size:%dpt}\n", fontSize]];
//    //            } else {
//                
//                [strCSS appendString:[NSString stringWithFormat:@"body{padding:0; color : rgb(%d,%d,%d); background-color : rgb(%d,%d,%d); font-size:%dpt}\n", redFont, greenFont, blueFont,redBack, greenBack, blueBack, fontSize]];
//    //            }
//
//            } else {
//                [strCSS appendString:[NSString stringWithFormat:@"body{background-color : rgb(255,255,255); font-size:%dpt;line-height:%d}\n", fontSize, lineHeight]];
//            }
//    //        [strCSS appendString:[NSString stringWithFormat:@"body{columns: 1em; background-color : rgb(192,192,192)}\n"]];   
//        }
        
        if ( (dicWORDNotRated != NULL) && ([dicWORDNotRated count] > 0) ){
    //        NSString *strColor = [dicWORDNotRated objectForKey:@"Color"];
//            DLog(@"dicWORDNotRated : %@", dicWORDNotRated);
            NSInteger red = [[dicWORDNotRated objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDNotRated objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDNotRated objectForKey:@"Color_Blue"] integerValue];
            NSString *strBlnUnderline = [dicWORDNotRated objectForKey:@"Underline"];
            NSString *strBlnBold = [dicWORDNotRated objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicWORDNotRated objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }

            [strCSS appendString:[NSString stringWithFormat:@"font.%@{color : rgb(%d,%d,%d); %@ %@ %@ }\n", KEY_CSS_WORDNotRated,  red, green, blue, strUnderline, strBold, strItalic]];
            //        [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotRated{border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0); color : rgb(250,250,250) }\n"]];
    //                [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotRated{color : %@ }\n", strColor]];
    //                [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotRated{font-weight : bold; color : black }\n", strColor]];        
    //        [strCSS appendString:@"font.WORDNotRated{ text-decoration:underline; color : rgb(0,255,0) }\n"];        
        }
        
        if ( (dicWORDUnknown != NULL) && ([dicWORDUnknown count] > 0) ){
    //        NSString *strColor = [dicWORDUnknown objectForKey:@"Color"];
//            DLog(@"dicWORDUnknown : %@", dicWORDUnknown);        
            NSInteger red = [[dicWORDUnknown objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDUnknown objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDUnknown objectForKey:@"Color_Blue"] integerValue];        
            NSString *strBlnUnderline = [dicWORDUnknown objectForKey:@"Underline"];
            NSString *strBlnBold = [dicWORDUnknown objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicWORDUnknown objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }
            
            [strCSS appendString:[NSString stringWithFormat:@"font.%@{color : rgb(%d,%d,%d); %@ %@ %@ }\n", KEY_CSS_WORDUnknown, red, green, blue, strUnderline, strBold, strItalic]];

        }

        if ( (dicWORDNotSure != NULL) && ([dicWORDNotSure count] > 0) ) {
    //        NSString *strColor = [dicWORDNotSure objectForKey:@"Color"];
//            DLog(@"dicWORDNotSure : %@", dicWORDNotSure);                
            NSInteger red = [[dicWORDNotSure objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDNotSure objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDNotSure objectForKey:@"Color_Blue"] integerValue];         
            NSString *strBlnUnderline = [dicWORDNotSure objectForKey:@"Underline"];
            NSString *strBlnBold = [dicWORDNotSure objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicWORDNotSure objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }
            
            [strCSS appendString:[NSString stringWithFormat:@"font.%@{color : rgb(%d,%d,%d); %@ %@ %@ }\n", KEY_CSS_WORDNotSure, red, green, blue, strUnderline, strBold, strItalic]];

            
    //        [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotSure{border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0); color : rgb(169,169,169) }\n"]];        
    //        [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotSure{quotes : \"[\" \"]\"; color : %@ }\n", strColor]];
        }
        
        if ( (dicWORDNotRatedIdiom != NULL) && ([dicWORDNotRatedIdiom count] > 0) ){
//            DLog(@"dicWORDNotRatedIdiom : %@", dicWORDNotRatedIdiom);
            NSInteger red = [[dicWORDNotRatedIdiom objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDNotRatedIdiom objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDNotRatedIdiom objectForKey:@"Color_Blue"] integerValue];
            NSString *strBorderWidth = [dicWORDNotRatedIdiom objectForKey:@"border-width"];
            NSString *strBorderStyle = [dicWORDNotRatedIdiom objectForKey:@"border-style"];

            [strCSS appendString:[NSString stringWithFormat:@"font.%@{border-width: %@; border-style : %@; background-color:rgb(%d,%d,%d); border-color : rgb(%d,%d,%d);}\n", KEY_CSS_WORDNotRatedIdiom, strBorderWidth, strBorderStyle,  235,235,235, red, green, blue]];
        }
        
        if ( (dicWORDUnknownIdiom != NULL) && ([dicWORDUnknownIdiom count] > 0) ){
//            DLog(@"dicWORDUnknownIdiom : %@", dicWORDUnknownIdiom);
            NSInteger red = [[dicWORDUnknownIdiom objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDUnknownIdiom objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDUnknownIdiom objectForKey:@"Color_Blue"] integerValue];
            NSString *strBorderWidth = [dicWORDUnknownIdiom objectForKey:@"border-width"];
            NSString *strBorderStyle = [dicWORDUnknownIdiom objectForKey:@"border-style"];
            
            [strCSS appendString:[NSString stringWithFormat:@"font.%@{border-width: %@; border-style : %@; background-color:rgb(%d,%d,%d); border-color : rgb(%d,%d,%d);}\n", KEY_CSS_WORDUnknownIdiom, strBorderWidth, strBorderStyle, 190,190,190, red, green, blue]];
        }
        
        if ( (dicWORDNotSureIdiom != NULL) && ([dicWORDNotSureIdiom count] > 0) ) {
//            DLog(@"dicWORDNotSureIdiom : %@", dicWORDNotSureIdiom);
            NSInteger red = [[dicWORDNotSureIdiom objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicWORDNotSureIdiom objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicWORDNotSureIdiom objectForKey:@"Color_Blue"] integerValue];
            NSString *strBorderWidth = [dicWORDNotSureIdiom objectForKey:@"border-width"];
            NSString *strBorderStyle = [dicWORDNotSureIdiom objectForKey:@"border-style"];
            
            [strCSS appendString:[NSString stringWithFormat:@"font.%@{border-width: %@; border-style : %@; background-color:rgb(%d,%d,%d); border-color : rgb(%d,%d,%d);}\n", KEY_CSS_WORDNotSureIdiom, strBorderWidth, strBorderStyle,  135,206,250, red, green, blue]];
        }

        //주간 CSS일때 저장한다.
        if (optCSS == CSS_Option_Day) {
            NSString *strStyleDayCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"styleDay.css"];        
            BOOL dbExists = [fileManager fileExistsAtPath:strStyleDayCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleDayCSSFilePath error:&error];
            }
            
//            DLog(@"strCSS : %@", strCSS);
            //CSS파일을 새로 만든다.
            BOOL success=[strCSS writeToFile:strStyleDayCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!success) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")	message:NSLocalizedString(@"Can't make style.css to Document folder.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                DLog(@"can't make style.css : %@", error);
            } else {
                if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                    DLog(@"strStyleDayCSSFilePath : %@", strStyleDayCSSFilePath);
                    NSURL *pathURL= [NSURL fileURLWithPath:strStyleDayCSSFilePath];                
                    if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                        DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                    } else {
                        DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                    }                
                }            

                //현재 styleCSS를 NSUserDefaults에도 저장한다. 
                NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//                DLog(@"dicBody : %@", dicBody);
                NSDictionary *dic0 = [NSDictionary dictionaryWithDictionary:dicBody];
                NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:dicWORDNotRated];
                NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:dicWORDUnknown];
                NSDictionary *dic3 = [NSDictionary dictionaryWithDictionary:dicWORDNotSure];
                NSDictionary *dic4 = [NSDictionary dictionaryWithDictionary:dicWORDNotRatedIdiom];
                NSDictionary *dic5 = [NSDictionary dictionaryWithDictionary:dicWORDUnknownIdiom];
                NSDictionary *dic6 = [NSDictionary dictionaryWithDictionary:dicWORDNotSureIdiom];
                [defs setValue:dic0 forKey:KEY_CSS_BODY];            
                [defs setValue:dic1 forKey:KEY_CSS_WORDNotRated];
                [defs setValue:dic2 forKey:KEY_CSS_WORDUnknown];
                [defs setValue:dic3 forKey:KEY_CSS_WORDNotSure];
                [defs setValue:dic4 forKey:KEY_CSS_WORDNotRatedIdiom];
                [defs setValue:dic5 forKey:KEY_CSS_WORDUnknownIdiom];
                [defs setValue:dic6 forKey:KEY_CSS_WORDNotSureIdiom];
            }
            NSString *strStyleCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"style.css"];        
            dbExists = [fileManager fileExistsAtPath:strStyleCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleCSSFilePath error:&error];
            }
            [strCSS writeToFile:strStyleCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
//                DLog(@"strStyleCSSFilePath : %@", strStyleCSSFilePath);
                NSURL *pathURL= [NSURL fileURLWithPath:strStyleCSSFilePath];
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }                
            }            

        } else if (optCSS == CSS_Option_Day_Imsi) {
            NSString *strStyleCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"styleImsi.css"];        
            BOOL dbExists = [fileManager fileExistsAtPath:strStyleCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleCSSFilePath error:&error];
            }
            
//            DLog(@"strCSS : %@", strCSS);
            //CSS파일을 새로 만든다.
            BOOL success=[strCSS writeToFile:strStyleCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!success) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")	message:NSLocalizedString(@"Can't make styleImsi.css to Document folder.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                DLog(@"can't make style.css : %@", error);
            } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                    DLog(@"strStyleCSSFilePath : %@", strStyleCSSFilePath);
                    NSURL *pathURL= [NSURL fileURLWithPath:strStyleCSSFilePath];                
                    if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                        DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                    } else {
                        DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                    }                
                }            
#endif 
            }
        }
    } else {
        NSDictionary *dicNightBody = [dicCss objectForKey:@"NightBODY"];
        NSDictionary *dicNightWORDNotRated = [dicCss objectForKey:@"NightWORDNotRated"];
        NSDictionary *dicNightWORDUnknown = [dicCss objectForKey:@"NightWORDUnknown"];
        NSDictionary *dicNightWORDNotSure = [dicCss objectForKey:@"NightWORDNotSure"];
        NSMutableString *strNightCSS = [NSMutableString stringWithFormat:@""];
//        if ( (dicNightBody != nil) && ([dicNightBody count] > 0) ) {
//            NSInteger fontSize = [[dicNightBody objectForKey:@"FontSize"] integerValue];
//            if (fontSize == 0) {
//                fontSize = 12;
//            }
//            NSInteger lineHeight = [[dicNightBody objectForKey:@"LineHeight"] integerValue];        
//            if (lineHeight == 0) {
//                NSInteger redFont = [[dicNightBody objectForKey:@"FontColor_Red"] integerValue];
//                NSInteger greenFont = [[dicNightBody objectForKey:@"FontColor_Green"] integerValue];
//                NSInteger blueFont = [[dicNightBody objectForKey:@"FontColor_Blue"] integerValue];
//                NSInteger alphaFont = [[dicNightBody objectForKey:@"FontColor_Alpha"] integerValue];
//                NSInteger redBack = [[dicNightBody objectForKey:@"BackColor_Red"] integerValue];
//                NSInteger greenBack = [[dicNightBody objectForKey:@"BackColor_Green"] integerValue];
//                NSInteger blueBack = [[dicNightBody objectForKey:@"BackColor_Blue"] integerValue];
//                NSInteger alphaBack = [[dicNightBody objectForKey:@"BackColor_Alpha"] integerValue];
//                
//                [strNightCSS appendString:[NSString stringWithFormat:@"body{padding:0; color : rgb(%d,%d,%d); background-color : rgb(%d,%d,%d); font-size:%dpt}\n", redFont, greenFont, blueFont,redBack, greenBack, blueBack, fontSize]];
//
//                
//            } else {
//                [strNightCSS appendString:[NSString stringWithFormat:@"body{background-color : rgb(255,255,255); font-size:%dpt;line-height:%d}\n", fontSize, lineHeight]];
//            }  
//        }
        
        if ( (dicNightWORDNotRated != NULL) && ([dicNightWORDNotRated count] > 0) ){
            NSInteger red = [[dicNightWORDNotRated objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicNightWORDNotRated objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicNightWORDNotRated objectForKey:@"Color_Blue"] integerValue];
            NSString *strBlnUnderline = [dicNightWORDNotRated objectForKey:@"Underline"];
            NSString *strBlnBold = [dicNightWORDNotRated objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicNightWORDNotRated objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }
            
            [strNightCSS appendString:[NSString stringWithFormat:@"font.WORDNotRated{color : rgb(%d,%d,%d); %@ %@ %@ }\n", red, green, blue, strUnderline, strBold, strItalic]];       
        }
        
        if ( (dicNightWORDUnknown != NULL) && ([dicNightWORDUnknown count] > 0) ){       
            NSInteger red = [[dicNightWORDUnknown objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicNightWORDUnknown objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicNightWORDUnknown objectForKey:@"Color_Blue"] integerValue];        
            NSString *strBlnUnderline = [dicNightWORDUnknown objectForKey:@"Underline"];
            NSString *strBlnBold = [dicNightWORDUnknown objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicNightWORDUnknown objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }
            
            [strNightCSS appendString:[NSString stringWithFormat:@"font.WORDUnknown{color : rgb(%d,%d,%d); %@ %@ %@ }\n", red, green, blue, strUnderline, strBold, strItalic]];
            
        }
        
        if ( (dicNightWORDNotSure != NULL) && ([dicNightWORDNotSure count] > 0) ) {                
            NSInteger red = [[dicNightWORDNotSure objectForKey:@"Color_Red"] integerValue];
            NSInteger green = [[dicNightWORDNotSure objectForKey:@"Color_Green"] integerValue];
            NSInteger blue = [[dicNightWORDNotSure objectForKey:@"Color_Blue"] integerValue];         
            NSString *strBlnUnderline = [dicNightWORDNotSure objectForKey:@"Underline"];
            NSString *strBlnBold = [dicNightWORDNotSure objectForKey:@"Bold"];
            NSString *strBlnItalic = [dicNightWORDNotSure objectForKey:@"Italic"];
            NSString *strUnderline = @"";
            NSString *strBold = @"";
            NSString *strItalic = @"";
            if ([strBlnUnderline isEqualToString:@"ON"]) {
                strUnderline = @"border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0);";
            }
            if ([strBlnBold isEqualToString:@"ON"]) {
                strBold = @"font-weight : bold;";
            }
            if ([strBlnItalic isEqualToString:@"ON"]) {
                strItalic = @"font-style : italic;";
            }
            
            [strNightCSS appendString:[NSString stringWithFormat:@"font.WORDNotSure{color : rgb(%d,%d,%d); %@ %@ %@ }\n", red, green, blue, strUnderline, strBold, strItalic]];
            
            
            //        [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotSure{border-width: thin; border-bottom-style : solid; border-color : rgb(0,0,0); color : rgb(169,169,169) }\n"]];        
            //        [strCSS appendString:[NSString stringWithFormat:@"font.WORDNotSure{quotes : \"[\" \"]\"; color : %@ }\n", strColor]];
        }
        
        if (optCSS == CSS_Option_Night) {
            NSString *strStyleNightCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"styleNight.css"];        
            BOOL dbExists = [fileManager fileExistsAtPath:strStyleNightCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleNightCSSFilePath error:&error];
            }
            
            DLog(@"strNightCSS : %@", strNightCSS);
            //CSS파일을 새로 만든다.
            BOOL success=[strNightCSS writeToFile:strStyleNightCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!success) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")	message:NSLocalizedString(@"Can't make styleNight.css to Document folder.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];

                DLog(@"can't make style.css : %@", error);
            } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                    DLog(@"strStyleNightCSSFilePath : %@", strStyleNightCSSFilePath);
                    NSURL *pathURL= [NSURL fileURLWithPath:strStyleNightCSSFilePath];                
                    if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                        DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                    } else {
                        DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                    }                
                }            
#endif                 
                //현재 styleNightCSS를 NSUserDefaults에도 저장한다. 
                NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                DLog(@"dicNightBody : %@", dicNightBody);
                NSDictionary *dic0 = [NSDictionary dictionaryWithDictionary:dicNightBody];            
                NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:dicNightWORDNotRated];
                NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:dicNightWORDUnknown];
                NSDictionary *dic3 = [NSDictionary dictionaryWithDictionary:dicNightWORDNotSure];        
                [defs setValue:dic0 forKey:@"CSS_NightBODY"];            
                [defs setValue:dic1 forKey:@"CSS_NightWORDNotRated"];
                [defs setValue:dic2 forKey:@"CSS_NightWORDUnknown"];
                [defs setValue:dic3 forKey:@"CSS_NightWORDNotSure"];
                
//                NSDictionary *dic0Temp = [defs dictionaryForKey:@"CSS_NightBODY"];
//                DLog(@"dic0Temp : %@", dic0Temp);
//                NSDictionary *dic1Temp = [defs dictionaryForKey:@"CSS_NightWORDNotRated"];
//                DLog(@"dic1Temp : %@", dic1Temp);
//                NSDictionary *dic2Temp = [defs dictionaryForKey:@"CSS_NightWORDUnknown"];
//                DLog(@"dic2Temp : %@", dic2Temp);
//                NSDictionary *dic3Temp = [defs dictionaryForKey:@"CSS_NightWORDNotSure"];
//                DLog(@"dic3Temp : %@", dic3Temp);
            }
            NSString *strStyleCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"style.css"];        
            dbExists = [fileManager fileExistsAtPath:strStyleCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleCSSFilePath error:&error];
            }
            [strNightCSS writeToFile:strStyleCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
            if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                DLog(@"strStyleCSSFilePath : %@", strStyleCSSFilePath);
                NSURL *pathURL= [NSURL fileURLWithPath:strStyleCSSFilePath];                
                if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                    DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                } else {
                    DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                }                
            }            
#endif              
        } else if (optCSS == CSS_Option_Night_Imsi) {
            NSString *strStyleCSSFilePath = [[myCommon getDocPath] stringByAppendingPathComponent:@"styleImsi.css"];        
            BOOL dbExists = [fileManager fileExistsAtPath:strStyleCSSFilePath];
            if(dbExists)
            {
                //CSS파일을 이미 있으면 지운다.
                [fileManager removeItemAtPath:strStyleCSSFilePath error:&error];
            }
            
            DLog(@"strNightCSS : %@", strNightCSS);
            //CSS파일을 새로 만든다.
            BOOL success=[strNightCSS writeToFile:strStyleCSSFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!success) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"	message:NSLocalizedString(@"Can't make styleImsi.css to Document folder.", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                DLog(@"can't make style.css : %@", error);
            } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
                if ([myCommon getIOSVersion] >= IOSVersion_5_1) {
                    DLog(@"strStyleCSSFilePath : %@", strStyleCSSFilePath);
                    NSURL *pathURL= [NSURL fileURLWithPath:strStyleCSSFilePath];                
                    if ([myCommon addSkipBackupAttributeToItemAtURL:pathURL] == TRUE){
                        DLog(@"Success : addSkipBackupAttributeToItemAtURL");
                    } else {
                        DLog(@"Fail : addSkipBackupAttributeToItemAtURL");
                    }                
                }            
#endif                 
            }
        }

    }
}

+ (NSMutableDictionary*) GetCSS
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    DLog(@"defs : %@", defs);
    NSMutableDictionary *dicCSS = (NSMutableDictionary*)[defs objectForKey:@"syleCSS"];
    DLog(@"dicCSS : %@", dicCSS);
    
    return dicCSS;
}

+ (NSArray*) getKnowOfButtons:(NSInteger)intSortType
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSInteger intKnowOftButtonNotRated = 0;
    NSInteger intKnowOftButtonUnknown = 0;
    NSInteger intKnowOftButtonNotSure = 0;
    NSInteger intKnowOftButtonKnown = 0;
    NSInteger intKnowOftButtonExclude = 0;

    NSString *strTemp = [defs stringForKey:@"KnowOfButton"];
    if ( (strTemp == nil) || ([strTemp isEqualToString:@"ON"] == FALSE) ) {
        NSArray *arrReturn = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];
        return arrReturn;
    } else {
        if (intSortType == intSortType_Alphabet) {
            intKnowOftButtonNotRated = [defs  integerForKey:@"KnowOftButton_Alphabet_NotRated"];
            intKnowOftButtonUnknown = [defs integerForKey:@"KnowOftButton_Alphabet_Unknown"];
            intKnowOftButtonNotSure = [defs integerForKey:@"KnowOftButton_Alphabet_NotSure"];
            intKnowOftButtonKnown = [defs integerForKey:@"KnowOftButton_Alphabet_Known"];
            intKnowOftButtonExclude = [defs integerForKey:@"KnowOftButton_Alphabet_Exclude"];            
        } else if (intSortType == intSortType_Frequency) {
            intKnowOftButtonNotRated = [defs integerForKey:@"KnowOftButton_Frequency_NotRated"];
            intKnowOftButtonUnknown = [defs integerForKey:@"KnowOftButton_Frequency_Unknown"];
            intKnowOftButtonNotSure = [defs integerForKey:@"KnowOftButton_Frequency_NotSure"];
            intKnowOftButtonKnown = [defs integerForKey:@"KnowOftButton_Frequency_Known"];
            intKnowOftButtonExclude = [defs integerForKey:@"KnowOftButton_Frequency_Exclude"];        
        } else if (intSortType == intSortType_Searched) {
            intKnowOftButtonNotRated = [defs integerForKey:@"KnowOftButton_Searched_NotRated"];
            intKnowOftButtonUnknown = [defs integerForKey:@"KnowOftButton_Searched_Unknown"];
            intKnowOftButtonNotSure = [defs integerForKey:@"KnowOftButton_Searched_NotSure"];
            intKnowOftButtonKnown = [defs integerForKey:@"KnowOftButton_Searched_Known"];
            intKnowOftButtonExclude = [defs integerForKey:@"KnowOftButton_Searched_Exclude"];        
        } else if (intSortType == intSortType_MeaningNeeded) {        
            intKnowOftButtonNotRated = [defs integerForKey:@"KnowOftButton_MeaningNeeded_NotRated"];
            intKnowOftButtonUnknown = [defs integerForKey:@"KnowOftButton_MeaningNeeded_Unknown"];
            intKnowOftButtonNotSure = [defs integerForKey:@"KnowOftButton_MeaningNeeded_NotSure"];
            intKnowOftButtonKnown = [defs integerForKey:@"KnowOftButton_MeaningNeeded_Known"];
            intKnowOftButtonExclude = [defs integerForKey:@"KnowOftButton_MeaningNeeded_Exclude"];
        } else if (intSortType == intSortType_AppearanceOrder) {
            intKnowOftButtonNotRated = [defs integerForKey:@"KnowOftButton_AppearanceOrder_NotRated"];
            intKnowOftButtonUnknown = [defs integerForKey:@"KnowOftButton_AppearanceOrder_Unknown"];
            intKnowOftButtonNotSure = [defs integerForKey:@"KnowOftButton_AppearanceOrder_NotSure"];
            intKnowOftButtonKnown = [defs integerForKey:@"KnowOftButton_AppearanceOrder_Known"];
            intKnowOftButtonExclude = [defs integerForKey:@"KnowOftButton_AppearanceOrder_Exclude"];        
        }
    }
    NSArray *arrReturn = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:intKnowOftButtonNotRated],[NSNumber numberWithInt:intKnowOftButtonUnknown],[NSNumber numberWithInt:intKnowOftButtonNotSure],[NSNumber numberWithInt:intKnowOftButtonKnown],[NSNumber numberWithInt:intKnowOftButtonExclude], nil];
    return arrReturn;
}

+ (void) setKnowOfButtons:(NSInteger)intSortType intNotRated:(NSInteger)intKnowOftButtonNotRated intUnknown:(NSInteger)intKnowOftButtonUnknown intNotSure:(NSInteger)intKnowOftButtonNotSure intKnown:(NSInteger)intKnowOftButtonKnown intExclude:(NSInteger)intKnowOftButtonExclude
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];    
    [defs setValue:@"ON" forKey:@"KnowOfButton"];
    
    if (intSortType == intSortType_Alphabet) {
        [defs setInteger:intKnowOftButtonNotRated forKey:@"KnowOftButton_Alphabet_NotRated"];
        [defs setInteger:intKnowOftButtonUnknown forKey:@"KnowOftButton_Alphabet_Unknown"];
        [defs setInteger:intKnowOftButtonNotSure forKey:@"KnowOftButton_Alphabet_NotSure"];
        [defs setInteger:intKnowOftButtonKnown forKey:@"KnowOftButton_Alphabet_Known"];
        [defs setInteger:intKnowOftButtonExclude forKey:@"KnowOftButton_Alphabet_Exclude"];            
    } else if (intSortType == intSortType_Frequency) {
        [defs setInteger:intKnowOftButtonNotRated forKey:@"KnowOftButton_Frequency_NotRated"];
        [defs setInteger:intKnowOftButtonUnknown forKey:@"KnowOftButton_Frequency_Unknown"];
        [defs setInteger:intKnowOftButtonNotSure forKey:@"KnowOftButton_Frequency_NotSure"];
        [defs setInteger:intKnowOftButtonKnown forKey:@"KnowOftButton_Frequency_Known"];
        [defs setInteger:intKnowOftButtonExclude forKey:@"KnowOftButton_Frequency_Exclude"];            
    } else if (intSortType == intSortType_Searched) {
        [defs setInteger:intKnowOftButtonNotRated forKey:@"KnowOftButton_Searched_NotRated"];
        [defs setInteger:intKnowOftButtonUnknown forKey:@"KnowOftButton_Searched_Unknown"];
        [defs setInteger:intKnowOftButtonNotSure forKey:@"KnowOftButton_Searched_NotSure"];
        [defs setInteger:intKnowOftButtonKnown forKey:@"KnowOftButton_Searched_Known"];
        [defs setInteger:intKnowOftButtonExclude forKey:@"KnowOftButton_Searched_Exclude"];            
    } else if (intSortType == intSortType_MeaningNeeded) {        
        [defs setInteger:intKnowOftButtonNotRated forKey:@"KnowOftButton_MeaningNeeded_NotRated"];
        [defs setInteger:intKnowOftButtonUnknown forKey:@"KnowOftButton_MeaningNeeded_Unknown"];
        [defs setInteger:intKnowOftButtonNotSure forKey:@"KnowOftButton_MeaningNeeded_NotSure"];
        [defs setInteger:intKnowOftButtonKnown forKey:@"KnowOftButton_MeaningNeeded_Known"];
        [defs setInteger:intKnowOftButtonExclude forKey:@"KnowOftButton_MeaningNeeded_Exclude"];            
    } else if (intSortType == intSortType_AppearanceOrder) {
        [defs setInteger:intKnowOftButtonNotRated forKey:@"KnowOftButton_AppearanceOrder_NotRated"];
        [defs setInteger:intKnowOftButtonUnknown forKey:@"KnowOftButton_AppearanceOrder_Unknown"];
        [defs setInteger:intKnowOftButtonNotSure forKey:@"KnowOftButton_AppearanceOrder_NotSure"];
        [defs setInteger:intKnowOftButtonKnown forKey:@"KnowOftButton_AppearanceOrder_Known"];
        [defs setInteger:intKnowOftButtonExclude forKey:@"KnowOftButton_AppearanceOrder_Exclude"];            
    }
}




//현재 EPUB책의 챕터 정보를 가져온다.
+ (NSMutableArray*)getChapterInfoIntable
{
	NSMutableArray	*arrOne = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TBL_ChapterInfo];
    DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
    
    NSInteger start = 0;
    NSInteger end = 0;
	if (sqlite3_prepare_v2(dbBook, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			NSInteger chapterNo = sqlite3_column_int(stmt, FLD_NO_ChapterInfoTbl_CHAPTER);
            NSString	*strChapterName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ChapterInfoTbl_CHAPTER_NAME)];
            if (strChapterName == NULL) {
                strChapterName = @"";;
            }

            start = sqlite3_column_int(stmt, FLD_NO_ChapterInfoTbl_START);
			end = sqlite3_column_int(stmt, FLD_NO_ChapterInfoTbl_END);
            
            NSMutableDictionary *dicOneChapterInfo = [[NSMutableDictionary alloc] init];
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:chapterNo] forKey:@"CHAPTER"];
            [dicOneChapterInfo setValue:strChapterName forKey:@"CHAPTER_NAME"];
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:start] forKey:@"START"];
            [dicOneChapterInfo setValue:[NSNumber numberWithInt:end] forKey:@"END"];
            [arrOne addObject:dicOneChapterInfo];
		}
	}
    DLog(@"arrOne : %@", arrOne);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return arrOne;
}

//현재 책의 페이지 정보를 가져온다.
+ (NSMutableArray*)getPageInfoIntable:(NSInteger)fileLength intBookTblNo:(NSInteger)intBookTblNo
{
	NSMutableArray	*arrOne = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TBL_PageInfoTbl];
    DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;

	BOOL blnSameFile = FALSE;
    NSInteger start = 0;
    NSInteger end = 0;
	if (sqlite3_prepare_v2(dbBook, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			NSInteger currPageNo = sqlite3_column_int(stmt, FLD_NO_PageInfoTbl_PAGE);
            start = sqlite3_column_int(stmt, FLD_NO_PageInfoTbl_START);
			end = sqlite3_column_int(stmt, FLD_NO_PageInfoTbl_END);
			NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
			[dicOne setValue:[NSNumber numberWithInt:currPageNo] forKey:@"currPageNo"];
            [dicOne setValue:[NSNumber numberWithInt:start] forKey:@"OffsetStart"];
			[dicOne setValue:[NSNumber numberWithInt:end] forKey:@"OffsetEnd"];
			[arrOne addObject:dicOne];
		}
	}
//    DLog(@"arrOne : %@", arrOne);  
    strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %d", FldName_BOOK_LIST_BookLength, TBL_BOOK_LIST, FldName_BOOK_LIST_ID, intBookTblNo];
    if (fileLength == [myCommon getIntFldValueFromTbl:strQuery openMyDic:TRUE]) {
        blnSameFile = TRUE;
    }
    

    //이거는 더이상 안쓴다. Epub일때는 이것으로는 안된다.
//    if (fileLength == end) {
//        blnSameFile = TRUE;
//    }

    //같은 파일이 아니면(파일길이와 SQL에 저장되어 있는 마지막 라인이 틀리면 다른 파일이다.) 페이지정보를 없앤다. (다시 읽을려구...)
    if (blnSameFile == FALSE) {        
        [arrOne removeAllObjects];
    }
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return arrOne;
}


//현재 책의 페이지 정보를 가져온다.
+ (NSInteger)getIntPageNoFromSQLFile:(NSInteger)intBookTblNo
{
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %d", FldName_AllPage, TBL_BOOK_LIST, FldName_BOOK_LIST_ID, intBookTblNo];
    
    NSInteger lastPage = [self getIntFldValueFromTbl:strQuery openMyDic:TRUE];
    DLog(@"lastPage : %d", lastPage);
    return lastPage;
}

//SQL에서 현재 책파일의 용량 정보를 가져온다.
+ (NSInteger)getIntBookFileSizeFromSQLFile:(NSInteger)intBookTblNo
{
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %d", FldName_BOOK_LIST_BookLength, TBL_BOOK_LIST, FldName_BOOK_LIST_ID, intBookTblNo];
    
    NSInteger fileSize = [self getIntFldValueFromTbl:strQuery openMyDic:TRUE];
    DLog(@"lastPage : %d", fileSize);
    return fileSize;
}

//SQL에 현재 책파일의 용량 정보를 적는다.
+ (BOOL)setIntBookFileSizeFromSQLFile:(NSInteger)intBookTblNo intFileSize:(NSInteger)fileSize
{
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = %d;", TBL_BOOK_LIST, FldName_BOOK_LIST_BookLength, fileSize, FldName_BOOK_LIST_ID, intBookTblNo];
    return [self changeRec:strQuery openMyDic:TRUE];
}


//현재 책의 페이지 정보를 가져온다.
+ (NSInteger)getPageNoFromSQLFile:(NSString*)strFullSQLFileName
{

//    NSString *strFullSQLFileNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strFullSQLFileName];
    NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_AllPage, TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strFullSQLFileName];

    NSInteger lastPage = [self getIntFldValueFromTbl:strQuery openMyDic:TRUE];
    DLog(@"lastPage : %d", lastPage);
    return lastPage;
    
//    sqlite3 *dbPage = nil;
//    if (sqlite3_open([strFullSQLFileName UTF8String], &dbPage) != SQLITE_OK)
//    {
//        sqlite3_close(dbPage);
//        DLog(@"Can't open DB : %@", strFullSQLFileName);
//        return 0;
//    }
//
//
//    NSString *strQuery = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@", FldName_PageInfoTbl_PAGE, TBL_PageInfoTbl];
//    DLog(@"strQuery : %@", strQuery);
//	const char *sqlQuery = [strQuery UTF8String];
//	sqlite3_stmt *stmt = nil;
//    
//
//    NSInteger lastPage = 0;
//
//    
//    
//	if (sqlite3_prepare_v2(dbPage, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
//        int ret = sqlite3_step(stmt);
//        DLog(@"ret : %d", ret);
//		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
//			lastPage = sqlite3_column_int(stmt, 0) + 1;  //Page(0베이스)가 Max인 레코드에서 1을 더해준다.
//        }
//	}
//    DLog(@"lastPage : %d", lastPage);
//	sqlite3_reset(stmt);
//	sqlite3_finalize(stmt);
//    sqlite3_close(dbPage);
//	return lastPage;
}


////현재 책의 페이지 정보를 저장하는 테이블을 만든다.
//+ (BOOL) createSavePageInfoTableIfNotExist{
//    BOOL blnResult = TRUE;
//    //일단 기존에 존재하는 테이블은 삭제후 다시만들고 거기에 적는다.
//	NSString *strSqlCreatTable1 = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@; CREATE TABLE %@", TBL_PageInfoTbl, TBL_PageInfoTbl];
//	NSString *strSqlCreatTable2 = @" (\"FontName\" CHAR, \"FontSize\" INTEGER, \"jsFontSize\" INTEGER, \"Page\" INTEGER, \"Start\" INTEGER, \"End\" INTEGER)";
//	NSString *strCreateTable = [NSString stringWithFormat:@"%@ %@", strSqlCreatTable1, strSqlCreatTable2];
//    DLog(@"strCreateTable : %@", strCreateTable);
//    
//    const char *sqlCreateTable = [strCreateTable UTF8String];
//	int retCreate = sqlite3_exec(dbBook, sqlCreateTable, nil, nil, nil);
//	if ( retCreate != SQLITE_OK)
//	{
//		DLog(@"%@",[NSString stringWithFormat:@"Create Table Error createTable while %@ : '%s'", strCreateTable, sqlite3_errmsg(dbBook)]);		
//		blnResult = FALSE;
//	}     
//    
//    return blnResult;
//}



//현재 책의 페이지 정보를 저장한다.
+ (BOOL)savePageInfoIntable:(NSMutableArray*)arrPageInfo fontName:(NSString*)fontName fontSize:(NSInteger)fontSize jsFontSize:(NSInteger)jsFontSize
{
    //테이블이 있으면 페이지 정보를 넣는다.
    
    for (int currPageNo = 0;currPageNo < [arrPageInfo count]; ++currPageNo) {
        NSDictionary *dicOne = [arrPageInfo objectAtIndex:currPageNo];
        NSInteger pageNo = [[dicOne objectForKey:@"PageNo"] integerValue];
        NSInteger offsetStart = [[dicOne objectForKey:@"OffsetStart"] integerValue];
        NSInteger offsetEnd = [[dicOne objectForKey:@"OffsetEnd"] integerValue];
        
        NSString *strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@) VALUES(%d, %d,%d)", TBL_PageInfoTbl, FldName_PageInfoTbl_PAGE, FldName_PageInfoTbl_START, FldName_PageInfoTbl_END, pageNo, offsetStart, offsetEnd];
        [myCommon changeRec:strQuery openMyDic:FALSE];
    }
    return TRUE;
}

//WordOri로 부터 각 단어에 해당되는 카운터를 가져온다.
+ (NSMutableArray*) GetWordsCountFromTbl:(NSString*)strWordOri
{
    NSMutableArray	*arrOne = [[NSMutableArray alloc] init];
    
    NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriForSQL];	
    
//    NSInteger intFldNo_Word = FLD_NO_ENG_DIC_WORD;
//	NSInteger intFldNo_Count = FLD_NO_ENG_DIC_COUNT;
//	NSInteger intFldNo_Know = FLD_NO_ENG_DIC_KNOW;
//	
//    
//        intFldNo_Word = FLD_NO_TBL_EngDicEachBook_WORD;
//        intFldNo_Count = FLD_NO_TBL_EngDicEachBook_COUNT;
//        intFldNo_Know = FLD_NO_TBL_EngDicEachBook_KNOW;

        dbOne = dbBook;


    const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
    
	DLog(@"strQuery GetCountFromTbl : %@", strQuery);

	
	int rett = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
            if (strWord == NULL) {
                strWord = @"";;
            }
            NSInteger cntOfWord = sqlite3_column_int(stmt, FLD_NO_ENG_DIC_COUNT);            
            
            NSString *strKnow = @"";
            char *charKnow = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_KNOW);
            if (charKnow == NULL)
                strKnow = @"0";
            else
                strKnow = [NSString stringWithUTF8String:charKnow];						            
            
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strWord forKey:@"Word"];
            [dicOne setValue:[NSNumber numberWithInt:cntOfWord] forKey:@"Count"];
            [dicOne setValue:strKnow forKey:@"Know"];
            [arrOne addObject:dicOne];          
		}				
	}

        
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return arrOne;
}
+ (int) GetCountFromTbl:(NSString*)strQuery openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }
    
	int cntOfWords = 0;
	
	DLog(@"strQuery GetCountFromTbl : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			cntOfWords = sqlite3_column_int(stmt, 0);
		} else {
//			DLog(@" Step error GetCountFromTbl : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
//		DLog(@" error GetCountFromTbl : %@ %s ", strQuery, sqlite3_errmsg(db));
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return cntOfWords;
}

//Know가 2인것(Not Sure)에서 Meaning이 인자값이 아닌것의 단어를 모은다. (IOS5에서는 SQL이 너무느려서 한번에 약 ?개의 단어를 넣어서 사용한다.)
+ (void) getWorsForQuiz:(NSMutableDictionary*)dicWordsForQuiz
{
    [dicWordsForQuiz removeAllObjects];
    NSInteger cntOfWord = 0;
    
    sqlite3_stmt *stmt = nil;
    
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ is not null and %@ != '' and %@ = 2 ORDER BY RANDOM() LIMIT %d; ", TBL_EngDic, FldName_Meaning, FldName_Meaning, FldName_Know, intCountOfWordsForQuiz];	
    const char *sqlQuery = [strQuery UTF8String];
    
    
    int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    if (rett == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {                
            NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
            NSString *strMeaning = nil;
            char *localityChars = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_MEANING);                
            if (localityChars == NULL)
                strMeaning = @"";
            else
                strMeaning = [NSString stringWithUTF8String:localityChars];		
            
            //뜻이 없으면 TBL_EngDic의 원형을가져와서 strMeaningOri에 넣는다.
            if ([strMeaning isEqualToString:@""] == TRUE) {
                NSString *wordOri = @"";
                char *charWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDORI);			
                if (charWordOri == NULL)
                    wordOri = @"";
                else
                    wordOri = [NSString stringWithUTF8String:charWordOri];
                
                if ([strWord isEqualToString:wordOri] == FALSE) {              
                    NSString    *worOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:wordOri];
                    NSString *strQueryWordOri = [NSString stringWithFormat:@"SELECT %@ From %@ WHERE %@ = '%@'", FldName_TBL_EngDic_MEANING, TBL_EngDic, FldName_TBL_EngDic_WORD, worOriForSQL];
                    strMeaning = [self getStringFldValueFromTbl:strQueryWordOri openMyDic:TRUE];
                }
            }
            
//            NSString *strKnow = @"";
//            char *charKnow = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_KNOW);
//            if (charKnow == NULL)
//                strKnow = @"0";
//            else
//                strKnow = [NSString stringWithUTF8String:charKnow];
            
            DLog(@"strWord : %@", strWord);
            DLog(@"strMeaning : %@", strMeaning);
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strWord forKey:@"Word"];
            [dicOne setValue:strMeaning forKey:@"Meaning"];
//            [dicOne setValue:strKnow forKey:@"Know"];        
            [dicWordsForQuiz setObject:dicOne forKey:[strWord lowercaseString]];
            
            if (cntOfWord >= intCountOfWordsForQuiz) {
                break;
            }
            cntOfWord++;
        }				
    } else {
        DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(db));
    }  
    
    DLog(@"dicWordsForQuiz : %@", dicWordsForQuiz);

    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return;
}


//속담 리스트를 받아온다.
+ (NSMutableArray*) getProverbList
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];

    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@", TBL_Idiom];
    
    const char *sqlQuery = [strQuery UTF8String];
    DLog(@"strQuery : %@", strQuery);
    sqlite3_stmt *stmt;
    int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    DLog(@"rett : %d", rett);
    if (rett == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString	*strIdiom = @"";
            char *charIdiom = (char*)sqlite3_column_text(stmt, FLD_NO_IDIOM_Idiom);
            if (charIdiom != NULL)
                strIdiom = [NSString stringWithUTF8String:charIdiom];
            
            NSString *strMeaning = @"";
            char *charMeaning = (char*)sqlite3_column_text(stmt, FLD_NO_IDIOM_Meaning);
            if (charMeaning != NULL)
                strMeaning = [NSString stringWithUTF8String:charMeaning];

            NSString *strDesc = @"";
            char *charDesc = (char*)sqlite3_column_text(stmt, FLD_NO_IDIOM_Desc);
            if (charDesc != NULL)
                strDesc = [NSString stringWithUTF8String:charDesc];

            //            if ([strMeaning isEqualToString:@""] == TRUE) {
            //                continue;
            //            }
            if ([strMeaning isEqualToString:@""] == TRUE) {
                strMeaning = [NSString stringWithString:strDesc];
            }
            
            DLog(@"strIdiom : %@", strIdiom);

            NSInteger   intKnow = sqlite3_column_int(stmt, FLD_NO_IDIOM_Know);
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strIdiom forKey:KEY_DIC_Idiom];
            [dicOne setValue:strMeaning forKey:KEY_DIC_MEANING];
            [dicOne setValue:strDesc forKey:KEY_DIC_Desc];
            [dicOne setValue:[NSNumber numberWithInt:intKnow] forKey:KEY_DIC_KNOW];
            //중복된 단어를 체크하지 않고 넣어준다.(실제로는 체크해야하지만 그럴일이 거의 없을것이고... 귀찮다...)
            [arrResult addObject:dicOne];
        }
    } else {
        DLog(@"Select error : %@ %s ", strQuery, sqlite3_errmsg(db));
    }
    
    DLog(@"arrResult : %@", arrResult);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return arrResult;
}


//Exam에서 사용할 단어의 리스트를 구한다.
+ (NSMutableArray*) getWordListForExam:(NSInteger)maxNoOfExam
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSInteger maxNoOfExamTemp = maxNoOfExam;
    DLog(@"maxNoOfExam : %d", maxNoOfExam);
    //잘모르는 단어중 단어뜻이 있는것의 리스트를 구한다.
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and %@ = %d ORDER BY RANDOM() LIMIT %d;", TBL_EngDic_BookTemp, FldName_Meaning, FldName_Know, KnowWord_NotSure, maxNoOfExamTemp];
    [self getWordListForExamBySQL:strQuery wordList:arrResult maxNoOfExam:maxNoOfExamTemp];
    maxNoOfExamTemp = maxNoOfExam - [arrResult count];
    DLog(@"arrResult : %@", arrResult);
    
    if ([arrResult count] < maxNoOfExam) {
        //리스트가 모자라면 모르는 단어중 단어의 뜻이 있는것에서도 리스트를 구한다.
        strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and %@ = %d ORDER BY RANDOM() LIMIT %d;", TBL_EngDic_BookTemp, FldName_Meaning, FldName_Know, KnowWord_Unknown, maxNoOfExamTemp];
        [self getWordListForExamBySQL:strQuery wordList:arrResult maxNoOfExam:maxNoOfExamTemp];
        maxNoOfExamTemp = maxNoOfExam - [arrResult count];
        DLog(@"arrResult : %@", arrResult);
        
        if ([arrResult count] < maxNoOfExam) {      
            //리스트가 모자라면 단어뜻이 있는 KnowWord_Known 또는 KnowWord_NotRated에서 구한다.
            strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and ( %@ = %d or %@ = %d )  ORDER BY RANDOM() LIMIT %d;", TBL_EngDic_BookTemp, FldName_Meaning, FldName_Know, KnowWord_Known,  FldName_Know, KnowWord_NotRated, maxNoOfExamTemp];
            [self getWordListForExamBySQL:strQuery wordList:arrResult maxNoOfExam:maxNoOfExamTemp];
            maxNoOfExamTemp = maxNoOfExam - [arrResult count];
            DLog(@"arrResult : %@", arrResult);
           
            if ([arrResult count] < maxNoOfExam) {            
                //리스트가 모자라면 KnowWord_NotRated에서 넣어준다.
                strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %d ORDER BY RANDOM() LIMIT %d;", TBL_EngDic_BookTemp, FldName_Know, KnowWord_NotRated, maxNoOfExamTemp];
                [self getWordListForExamBySQL:strQuery wordList:arrResult maxNoOfExam:maxNoOfExamTemp];
                maxNoOfExamTemp = maxNoOfExam - [arrResult count];
                DLog(@"arrResult : %@", arrResult);
                if ([arrResult count] < maxNoOfExam) {            
                    //리스트가 모자라면 아무단어나 넣어준다.
                    strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ ORDER BY RANDOM() LIMIT %d;", TBL_EngDic_BookTemp, maxNoOfExamTemp];
                    [self getWordListForExamBySQL:strQuery wordList:arrResult maxNoOfExam:maxNoOfExamTemp];
                    maxNoOfExamTemp = maxNoOfExam - [arrResult count];
                    DLog(@"arrResult : %@", arrResult);
                }
            }
        }
    }
    
    
    DLog(@"arrResult : %@", arrResult);


    return arrResult;
}

+ (NSMutableArray*) getWordListForExamBySQL:(NSString*)strQuery wordList:(NSMutableArray*)arrWordList maxNoOfExam:(NSInteger)maxNoOfExam
{
    const char *sqlQuery = [strQuery UTF8String];
    DLog(@"strQuery : %@", strQuery);
    sqlite3_stmt *stmt;
    NSInteger cntOfWord = 0;
    int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    DLog(@"rett : %d", rett);
    if (rett == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {  
            DLog(@"5");
            NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_TBL_EngDicEachBook_WORD)];
            NSString *strMeaning;
            char *localityChars = (char*)sqlite3_column_text(stmt, FLD_NO_TBL_EngDicEachBook_MEANING);                
            if (localityChars == NULL)
                strMeaning = @"";
            else
                strMeaning = [NSString stringWithUTF8String:localityChars];		
            
//            if ([strMeaning isEqualToString:@""] == TRUE) {
//                continue;
//            }
            DLog(@"strWord : %@", strWord);
            DLog(@"strMeaning : %@", strWord);
            DLog(@"strMeaning : %@", strMeaning);  
            DLog(@"localityChars : %s", localityChars);
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strWord forKey:@"Word"];
            [dicOne setValue:strMeaning forKey:@"Meaning"];
            //중복된 단어를 체크하지 않고 넣어준다.(실제로는 체크해야하지만 그럴일이 거의 없을것이고... 귀찮다...)
            [arrWordList addObject:dicOne];             
            cntOfWord++;
            if (cntOfWord >= maxNoOfExam) {
                break;
            }
        }				
    } else {
        DLog(@"Select error : %@ %s ", strQuery, sqlite3_errmsg(db));
    }        
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return arrWordList;
}

//Exam에서 strWord에 해당되는 단어그룹의 리스트를 3개 가져온다.(strWord포함)
+ (NSMutableArray*) getWrongWordListForExam:(NSString*)strWord
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSString *strWordOri = [self GetOriWordOnlyIfExistInTbl:strWord];
    NSString *strWordOriForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strWordOri];
    
    NSInteger maxNoOfWrongWordList = 3;
    
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY RANDOM()", TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriForSQL];
    
    [self getWrongWordListForExamBySQL:strQuery wordList:arrResult WordExcept:[strWord lowercaseString] maxNoOfExam:maxNoOfWrongWordList];
    DLog(@"arrResult : %@", arrResult);
    if ([arrResult count] < maxNoOfWrongWordList) {
        //리스트가 모자라면 KnowWord_NotSure에서도 리스트를 구한다.
        strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %d ORDER BY RANDOM() LIMIT %d;", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_NotSure, maxNoOfWrongWordList];        
        [self getWrongWordListForExamBySQL:strQuery wordList:arrResult WordExcept:[strWord lowercaseString] maxNoOfExam:maxNoOfWrongWordList];
        
        if ([arrResult count] < maxNoOfWrongWordList) {      
            //리스트가 모자라면 KnowWord_Unknown에서 고른다.
            strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %d ORDER BY RANDOM() LIMIT %d; ", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_Unknown, maxNoOfWrongWordList];
            [self getWrongWordListForExamBySQL:strQuery wordList:arrResult WordExcept:[strWord lowercaseString] maxNoOfExam:maxNoOfWrongWordList];
            if ([arrResult count] < maxNoOfWrongWordList) {            
                //리스트가 모자라면 아무거나 리스트럴 넣어준다.
                strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ ORDER BY RANDOM() LIMIT %d; ", TBL_EngDic, maxNoOfWrongWordList];
                [self getWrongWordListForExamBySQL:strQuery wordList:arrResult WordExcept:[strWord lowercaseString] maxNoOfExam:maxNoOfWrongWordList];
            }
        }
    }
    DLog(@"arrResult : %@", arrResult);
    return arrResult;
}

+ (NSMutableArray*) getWrongWordListForExamBySQL:(NSString*)strQuery wordList:(NSMutableArray*)arrWordList WordExcept:(NSString*)strWordExcept maxNoOfExam:(NSInteger)maxNoOfExam
{
    const char *sqlQuery = [strQuery UTF8String];
    DLog(@"strQuery : %@", strQuery);
    sqlite3_stmt *stmt;
    NSInteger cntOfWord = 0;
    int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    if (rett == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {  
//            DLog(@"5");
            NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
//            DLog(@"strWord : %@", strWord);
            if ([strWord isEqualToString:strWordExcept] == TRUE) {
                continue;
            }


            //중복된 단어를 체크하지 않고 넣어준다.(실제로는 체크해야하지만 그럴일이 거의 없을것이고... 귀찮다...)
            [arrWordList addObject:strWord];             
            cntOfWord++;
            if (cntOfWord >= maxNoOfExam) {
                break;
            }
        }				
    } else {
        DLog(@"Select error : %@ %s ", strQuery, sqlite3_errmsg(db));
    }        
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return arrWordList;
}


//Know가 2인것(Not Sure)에서 Meaning이 인자값이 아닌것의 단어를 모은다.
+ (NSMutableArray*) getMeaningsForQA:(NSString*)strMeaningRightAnswer
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSInteger cntOfWord = 0;
//    NSInteger maxWords = 0;
    sqlite3_stmt *stmt;
    
    NSInteger cntOfWordTemp = 0;
    
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ != '' and %@ = 2 ", TBL_EngDic, FldName_TBL_EngDic_MEANING, FldName_TBL_EngDic_KNOW];
    
    cntOfWordTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
    if (cntOfWordTemp < 10) {
        DLog(@"1");
        strQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ != '' and %@ = 1 ", TBL_EngDic, FldName_TBL_EngDic_MEANING, FldName_TBL_EngDic_KNOW];
        cntOfWordTemp = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        if (cntOfWordTemp < 10) {
            DLog(@"2");
            strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and %@ < 3 ORDER BY RANDOM() LIMIT 10; ", TBL_EngDic, FldName_TBL_EngDic_MEANING, FldName_TBL_EngDic_KNOW];	
        } else {
            DLog(@"3");
            strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and %@ = 1 ORDER BY RANDOM() LIMIT 10; ", TBL_EngDic, FldName_TBL_EngDic_MEANING, FldName_TBL_EngDic_KNOW];	
        }
    } else {
        strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ != '' and %@ = 2 ORDER BY RANDOM() LIMIT 10; ", TBL_EngDic, FldName_TBL_EngDic_MEANING, FldName_TBL_EngDic_KNOW];	
    }

    const char *sqlQuery = [strQuery UTF8String];
    DLog(@"strQuery : %@", strQuery);

    int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    if (rett == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {  
            DLog(@"5");
            NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
            NSString *strMeaning;
            char *localityChars = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_MEANING);                
            if (localityChars == NULL)
                strMeaning = @"";
            else
                strMeaning = [NSString stringWithUTF8String:localityChars];		
            
            if ([strMeaning isEqualToString:strMeaningRightAnswer] == TRUE) {
                continue;
            }
            DLog(@"strWord : %@", strWord);
            DLog(@"strMeaning : %@", strWord);
            DLog(@"strMeaning : %@", strMeaning);  
            DLog(@"localityChars : %s", localityChars);
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:strWord forKey:KEY_DIC_WORD];
            [dicOne setValue:strMeaning forKey:KEY_DIC_MEANING];
            if ([arrResult count] == 0) {
                [arrResult addObject:dicOne];
                cntOfWord++;                        
            } else {
                BOOL    blnExist = FALSE;
                for (NSMutableDictionary *dicTemp in arrResult)
                {
                    NSString *strOne = [dicTemp objectForKey:KEY_DIC_MEANING];
                    if ([strOne isEqualToString:strMeaning] == TRUE) {
                        blnExist = TRUE;
                    }
                }                    
                if (blnExist == FALSE) {
                    [arrResult addObject:dicOne];
                    cntOfWord++;                        
                }
            }
            if (cntOfWord == 3) {
                break;
            }
        }				
    } else {
        DLog(@"Select error : %@ %s ", strQuery, sqlite3_errmsg(db));
    }        
    if ([arrResult count] < 3) {
        for (NSInteger i = 0; i < 3 ; i++) {
            NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
            [dicOne setValue:@"english" forKey:KEY_DIC_WORD];
            [dicOne setValue:@"No Meaning..." forKey:KEY_DIC_MEANING];
            [arrResult addObject:dicOne];
            if ([arrResult count] == 3) {
                break;
            }
        }
    }

    DLog(@"arrResult : %@", arrResult);
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return arrResult;
}

+ (NSString*) getMeaningFromTbl:(NSString*)strWord
{    
	NSString *strMeaning = @"";
	
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, [strWord lowercaseString]];	
//	DLog(@"strQuery  : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			char *tempCharMeaning = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_MEANING);
			if (tempCharMeaning != NULL) {
				strMeaning = [NSString stringWithUTF8String:tempCharMeaning];
            } 
			if ([strMeaning isEqualToString:@""]) {
                //뜻이 없고 원형이 아니면 원형에가서 뜻을 가져온다.
                char *tempCharWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDORI);
                if (tempCharWordOri != NULL) {
                    NSString *strWordOri = [NSString stringWithUTF8String:tempCharWordOri];
                    if ([strWord isEqualToString:strWordOri] == FALSE) {
                        NSString *strQueryOri = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, [strWordOri lowercaseString]];	
//                        DLog(@"strQuery : %@", strQueryOri);
                        const char *sqlQueryOri = [strQueryOri UTF8String];
                        sqlite3_stmt *stmtOri = nil;
                        int rettOri = sqlite3_prepare_v2(db, sqlQueryOri, -1, &stmtOri, NULL);
                        if (rettOri == SQLITE_OK) {
                            int retOri = sqlite3_step(stmtOri);
                            if ((SQLITE_DONE == retOri) || (SQLITE_ROW == retOri)) {
                                char *tempCharMeaningOri = (char*)sqlite3_column_text(stmtOri, FLD_NO_ENG_DIC_MEANING);
                                if (tempCharMeaningOri != NULL) {
                                    strMeaning = [NSString stringWithUTF8String:tempCharMeaningOri];
                                }
                            }
                        }                    
                        sqlite3_reset(stmtOri);
                        sqlite3_finalize(stmtOri);
                    }
                }
            }
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(db));
	}
	DLog(@"strMeaning : %@", strMeaning);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);

	return strMeaning;
}
+ (NSString*) getMeaningOriFromTbl:(NSString*)strWordOri
{
	NSString *strMeaning = @"";
	NSString *strWordOriForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",FldName_TBL_EngDic_MEANING,  TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriForSQL];	
	//	DLog(@"strQuery  : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			char *tempCharMeaning = (char*)sqlite3_column_text(stmt, 0);
			if (tempCharMeaning != NULL) {
				strMeaning = [NSString stringWithUTF8String:tempCharMeaning];
			}
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(db));
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	
	return strMeaning;
}

+ (NSString*) getKnowFromTbl:(NSString*)strWord
{
	NSString *strKnow = @"0";
	
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_TBL_EngDic_KNOW, TBL_EngDic, FldName_TBL_EngDic_WORD, strWord];	
//	DLog(@"strQuery getKnowFromTbl : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			char *tempCharKnow = (char*)sqlite3_column_text(stmt, 0);
			if (tempCharKnow != NULL) {
				strKnow = [NSString stringWithUTF8String:tempCharKnow];
			}
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(db));
	}
	DLog(@"strKnow : %@", strKnow);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	
	return strKnow;
}

+ (NSInteger) getPageNoWithIndex:(NSInteger)wordStartIndex
{

    
	int valueOfFld = -1;
	NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ from %@ where %@ <= %d and %@ > %d", FldName_PageInfoTbl_PAGE, TBL_PageInfoTbl, FldName_PageInfoTbl_START,  wordStartIndex, FldName_PageInfoTbl_END, wordStartIndex];    
    DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(dbBook, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if (SQLITE_ROW == ret) {
			valueOfFld = sqlite3_column_int(stmt, 0);			
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(dbOne));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(dbOne));
	}
	DLog(@"PageNo : %d", valueOfFld);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return valueOfFld;
}

+ (void) getIndexWithPageNo:(NSInteger)pageNo StartIndex:(NSMutableString*)startIndex EndIndex:(NSMutableString*)endIndex
{
    
    [startIndex setString:@"0"];			
    [endIndex setString:@"0"];
//	int valueOfFld = -1;
	NSString *strQuery = [NSString stringWithFormat:@"SELECT %@, %@ from %@ where %@ = %d", FldName_PageInfoTbl_START, FldName_PageInfoTbl_END, TBL_PageInfoTbl, FldName_PageInfoTbl_PAGE, pageNo];    
    DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(dbBook, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if (SQLITE_ROW == ret) {
			[startIndex setString:[NSString stringWithFormat:@"%d", sqlite3_column_int(stmt, 0)]];			
			[endIndex setString:[NSString stringWithFormat:@"%d", sqlite3_column_int(stmt, 1)]];			            
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(dbOne));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(dbOne));
	}
//	DLog(@"PageNo : %d", valueOfFld);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return;
}

//string형 필드값을 받아온다.
+ (NSString*) getStringFldValueFromTbl:(NSString*)strQuery openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }

	NSString *valueOfFld = @"";
	
	DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			char *charWord = (char*)sqlite3_column_text(stmt, 0);		
			if (charWord != NULL){
				valueOfFld = [NSString stringWithUTF8String:charWord];						
			}
			else {
				valueOfFld = @"";
			}
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(dbOne));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(dbOne));
	}
//	DLog(@"string : %@", valueOfFld);
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return valueOfFld;
}



//int형 필드값을 받아온다.
+ (int) getIntFldValueFromTbl:(NSString*)strQuery openMyDic:(BOOL)openMyDic
{
    if (openMyDic == TRUE) {
        dbOne = db;
    } else {
        dbOne = dbBook;
    }
    
	int valueOfFld = -1;
	
	DLog(@"strQuery : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if (SQLITE_ROW == ret) {
			valueOfFld = sqlite3_column_int(stmt, 0);			
		} else {
			DLog(@" Step error : %d %@ %s", ret, strQuery, sqlite3_errmsg(dbOne));
		}				
	} else {
		DLog(@" error : %@ %s ", strQuery, sqlite3_errmsg(dbOne));
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return valueOfFld;
}

+ (NSInteger) getOrCreateBoookTblNoFromTblBookSetting:(NSString*)strBookName
{
	NSInteger bookTblNo = -1;
//	DLog(@"strBookName : %@", strBookName);
    //	strBookName = [strBookName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//	DLog(@"strBookName : %@", strBookName);
    NSString *strBookNameForSQL = [myCommon getCleanAndSingleQuoteWordForSQL:strBookName];
    
    //	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT id FROM BookSetting WHERE FileName = '%@'", strBookName];
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_BOOK_LIST_ID, TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strBookNameForSQL];    
//    DLog(@"strQuery  : %@", strQuery);
	bookTblNo = [self getIntFldValueFromTbl:strQuery openMyDic:TRUE];
	
	if (bookTblNo == -1) {
		strQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES('%@')", TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strBookNameForSQL];
		DLog(@"strQuery  : %@", strQuery);
		[self changeRec:strQuery openMyDic:TRUE];
		
		strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_BOOK_LIST_ID, TBL_BOOK_LIST, FldName_BOOK_LIST_FILENAME, strBookNameForSQL];
        DLog(@"strQuery  : %@", strQuery);
		bookTblNo = [self getIntFldValueFromTbl:strQuery openMyDic:TRUE];
	}
//	DLog(@" bookTblNo : %d", bookTblNo);
	return bookTblNo;
    
}
 
+ (BOOL) getEnvFromTbl:(NSMutableDictionary*)dicEnv
{
	[dicEnv removeAllObjects];
       
    sqlite3_stmt *statENV = nil;
	NSString *strQueryENV = [NSString	stringWithFormat:@"SELECT * FROM %@", TBL_APP_INFO];
    DLog(@"strQueryENV : %s", [strQueryENV UTF8String]);		
	const char *sqlQueryENV = [strQueryENV UTF8String];
	if (sqlite3_prepare_v2(db, sqlQueryENV, -1, &statENV, NULL) == SQLITE_OK) {
		if (sqlite3_step(statENV) == SQLITE_ROW) {
//            char *charTitle = (char*)sqlite3_column_text(statENV, 0);		
//			if (charTitle != NULL)
//				DLog(@"%@", [NSString stringWithUTF8String:charTitle]);	
            
            NSInteger ShowMeaning = sqlite3_column_int(statENV, FLD_NO_APP_INFO_FldName_SHOWMEANING);
			if (ShowMeaning == 0) {
				[dicEnv setValue:[NSNumber numberWithInt:0] forKey:@"Show Meaning"];
			} else {
				[dicEnv setValue:[NSNumber numberWithInt:1] forKey:@"Show Meaning"];
			}
            
            NSInteger BackLight = sqlite3_column_int(statENV, FLD_NO_APP_INFO_BackLight);
            //			DLog(@"BackLight : %d", BackLight);
			[dicEnv setValue:[NSNumber numberWithInt:BackLight] forKey:@"BackLight"];
			
            NSInteger Difficulty_VeryEasy = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_VeryEasy);
            //			DLog(@"BackLight : %d", BackLight);
			[dicEnv setValue:[NSNumber numberWithInt:Difficulty_VeryEasy] forKey:@"Difficulty_VeryEasy"];
            NSInteger Difficulty_Easy = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Easy);
            //			DLog(@"BackLight : %d", BackLight);
			[dicEnv setValue:[NSNumber numberWithInt:Difficulty_Easy] forKey:@"Difficulty_Easy"];
            NSInteger Difficulty_Good = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Good);
            //			DLog(@"BackLight : %d", BackLight);
			[dicEnv setValue:[NSNumber numberWithInt:Difficulty_Good] forKey:@"Difficulty_Good"];
            NSInteger Difficulty_Hard = sqlite3_column_int(statENV, FLD_NO_APP_INFO_Difficulty_Hard);
            //			DLog(@"BackLight : %d", BackLight);
			[dicEnv setValue:[NSNumber numberWithInt:Difficulty_Hard] forKey:@"Difficulty_Hard"];
//            DLog(@"dicEnv : %@", dicEnv);
		}
	}
    sqlite3_reset(statENV);
    sqlite3_finalize(statENV);    
    return  TRUE;
}

+ (void) getBookInfoFormTbl:(NSMutableDictionary*)dicOne fileName:(NSString*)strFileName
{
	[dicOne removeAllObjects];
    [dicOne setValue:strFileName forKey:@"Title"];
    [dicOne setValue:@"" forKey:@"Author"];
    [dicOne setValue:[NSNumber numberWithFloat:0.0f] forKey:@"LastPage"];
    [dicOne setValue:[NSNumber numberWithInt:120] forKey:@"Font"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"UniqueWords"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"AllWords"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"UnKnownWords"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"HalfKnownWords"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"KnownWords"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"WordsNotInBook"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"allPage"];
    [dicOne setValue:[NSNumber numberWithInt:0] forKey:@"BookLength"];
    
	sqlite3_stmt *statement = nil;
	NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ Where %@ = \"%@\"", TBL_BOOK_LIST, FldName_FILENAME, strFileName];
//    DLog(@"strQuery : %s", [strQuery UTF8String]);		
	const char *sqlQuery = [strQuery UTF8String];
	if (sqlite3_prepare_v2(db, sqlQuery, -1, &statement, NULL) == SQLITE_OK) {
		if (sqlite3_step(statement) == SQLITE_ROW) {
//            char *charTitle = (char*)sqlite3_column_text(statement, FLD_NO_BookSetting_FileName);		
//			if (charTitle != NULL)
//                [dicOne setValue:[NSString stringWithUTF8String:charTitle] forKey:@"Title"];
            
            NSInteger intBookTblNo = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_ID);
            
            
			char *charAuthor = (char*)sqlite3_column_text(statement, FLD_NO_BOOK_LIST_Author);		
            if (charAuthor != NULL)
                [dicOne setValue:[NSString stringWithUTF8String:charAuthor] forKey:@"Author"];
			
			float lastPage = sqlite3_column_double(statement, FLD_NO_BOOK_LIST_LastPage);
            //			DLog(@"LastPage : %d", lastPage);
			[dicOne setValue:[NSNumber numberWithFloat:lastPage] forKey:@"LastPage"];
			
//			NSInteger fontSizeTemp = sqlite3_column_int(statement, FLD_NO_BookSetting_Font);
//			if (fontSizeTemp == 0) {
//				fontSizeTemp = 120;
//			}
//			if (fontSizeTemp < 100) {
//				fontSizeTemp = 80;
//			}					
//			if (fontSizeTemp > 200) {
//				fontSizeTemp = 200;
//			}
//            //			DLog(@"Font : %d", Font);
//			[dicOne setValue:[NSNumber numberWithInt:fontSizeTemp] forKey:@"Font"];

            NSInteger intUniqueWords = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_UNIQUE);
			[dicOne setValue:[NSNumber numberWithInt:intUniqueWords] forKey:@"UniqueWords"];

			NSInteger intAllWords = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_ALL);
			[dicOne setValue:[NSNumber numberWithInt:intAllWords] forKey:@"AllWords"];
            
            NSInteger intUnKnownWords = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_UNKNOWN);
			[dicOne setValue:[NSNumber numberWithInt:intUnKnownWords] forKey:@"UnKnownWords"];
            
            NSInteger intHalfKnownWords = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_NOTSURE);
			[dicOne setValue:[NSNumber numberWithInt:intHalfKnownWords] forKey:@"HalfKnownWords"];
            
			NSInteger intKnownWords = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_KNOWN);
			[dicOne setValue:[NSNumber numberWithInt:intKnownWords] forKey:@"KnownWords"];

            NSInteger intWordsNotInBook = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_WORD_COUNT_EXCLUDE);
			[dicOne setValue:[NSNumber numberWithInt:intWordsNotInBook] forKey:@"WordsNotInBook"];

            NSInteger intBookLength = sqlite3_column_int(statement, FLD_NO_BOOK_LIST_BookLength);
            [dicOne setValue:[NSNumber numberWithInt:intBookLength] forKey:@"BookLength"];

            NSInteger allPage = [self getIntPageNoFromSQLFile:intBookTblNo];
            [dicOne setValue:[NSNumber numberWithInt:allPage] forKey:@"allPage"];
		}
	}
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);    

}

+ (BOOL) GetDataFromTbl:(NSString*)strWord Meaning:(NSMutableString*)strMeaning Know:(NSMutableString*)strKnow Level:(NSMutableString*)strLevel Count:(NSMutableString*)strCount WordOri:(NSMutableString*)strWordOri
{
	BOOL blnExist = FALSE;	
	strWord = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
	
	[strMeaning setString:@""];
	[strKnow setString:@""];
	[strLevel setString:@""];
	[strCount setString:@""];
	[strWordOri setString:@""];
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWord];
	DLog(@"strQuery GetDataFromTbl : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
//			DLog(@"strWord TBL_EngDic : %@", strWord);
			
            
//#define FLD_NO_ENG_DIC_WORD 0
//#define FLD_NO_ENG_DIC_WORDORI 1
//#define FLD_NO_ENG_DIC_MEANING 2
//#define FLD_NO_ENG_DIC_Desc 3
//#define FLD_NO_ENG_DIC_COUNT 4
//#define FLD_NO_ENG_DIC_KNOW 5
//#define FLD_NO_ENG_DIC_TOMEMORIZE 6
//#define FLD_NO_ENG_DIC_FAVORITE 7
//#define FLD_NO_ENG_DIC_WORDLEVEL1 8
//#define FLD_NO_ENG_DIC_INSTALLEDWORD 17
//            
//#define FLD_NO_ENG_DIC_Pronounce 25
//#define FLD_NO_ENG_DIC_KnowPronounce 27
//#define FLD_NO_ENG_DIC_CATEGORY_1 28
//#define FLD_NO_ENG_DIC_CATEGORY_2 29
//#define FLD_NO_ENG_DIC_CATEGORY_3 30
//#define FLD_NO_ENG_DIC_CATEGORY_4 31
//#define FLD_NO_ENG_DIC_CATEGORY_5 32
//#define FLD_NO_ENG_DIC_CATEGORY_6 33
//#define FLD_NO_ENG_DIC_CATEGORY_7 34
//#define FLD_NO_ENG_DIC_CATEGORY_8 35
//#define FLD_NO_ENG_DIC_CATEGORY_9 36
//            
//#define FLD_NO_ENG_DIC_RESERV1_INT 37           //CHINESE 모드에서는 단어의 문자수르 나타낸다.
//#define FLD_NO_ENG_DIC_RESERV1_CHAR 40          //CHINESE 모드에서는 단어의 첫번째 단어를 표시한다.(빨리 찾을려구...)
//#define FLD_NO_ENG_DIC_RESERV2_CHAR 41          //CHINESE 모드에서는 한자 단어에 대한 한글발음이 들어있다.
//#define FLD_NO_ENG_DIC_WORDORDER 68
            
            
			NSInteger intCount = sqlite3_column_int(stmt, FLD_NO_ENG_DIC_COUNT);
			[strCount setString:[NSString stringWithFormat:@"%d", intCount]];
//			DLog(@"strCount TBL_EngDic : %@", strCount);
			
			char *charKnow = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_KNOW);		
			if (charKnow != NULL)
				[strKnow setString:[NSString stringWithUTF8String:charKnow]];									
//			DLog(@"strKnow TBL_EngDic : %@", strKnow);

			char *charMeaning = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_MEANING);		
			if (charMeaning != NULL)
				[strMeaning setString:[NSString stringWithUTF8String:charMeaning]];									
//			DLog(@"strMeaning TBL_EngDic : %@", strMeaning);

			char *charLevel = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDLEVEL1);		
			if (charLevel != NULL)
				[strLevel setString:[NSString stringWithUTF8String:charLevel]];	
			
			char *charWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDORI);		
			if (charWordOri != NULL)
				[strWordOri setString:[NSString stringWithUTF8String:charWordOri]];		
			
//			DLog(@"strLevel TBL_EngDic : %@", strLevel);
			
			blnExist = TRUE;
		} else {
			DLog(@" Step error GetDataFromTbl : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
		DLog(@" error GetDataFromTbl : %@ %s", strQuery, sqlite3_errmsg(db));
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnExist;
}


//속담을 가져온다.
+ (NSInteger) getAllProverbsArrayFromTable:(NSMutableArray*)arrFromTblBook useKnowButton:(BOOL)blnUseKnowButton sortType:(NSInteger)intSortType pageNumber:(NSInteger)pageNumber whereClauseFld:(NSString*)whereClauseFld orderByFld:(NSString*)orderByFld isAsc:(BOOL)blnAsc openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }
    
    NSString *strTblName  = TBL_Idiom;
    
    NSInteger recCount = 0;
	NSDate		*startTime1;
	startTime1 = [NSDate date];
	
	[arrFromTblBook removeAllObjects];;
	
	sqlite3_stmt *statement = nil;
	NSString	*sqlQuery = @"";
    //	NSInteger	intTblType = TBL_TYPE_TBL_EngDic;
	
	
	NSString *strLimit = @"";
	if (pageNumber > 0) {
		strLimit = [NSString stringWithFormat:@"Limit %d, %d", (pageNumber-1)*kPageDivide, kPageDivide];
	}
	
	NSString *strOrderBy = @"";
	if ([orderByFld isEqualToString:@""] == FALSE) {
		NSString	*strAscOrDesc = @"ASC";
		if (blnAsc == FALSE) {
			strAscOrDesc = @"DESC";
		}
		strOrderBy = [NSString stringWithFormat:@"Order by %@ %@",orderByFld, strAscOrDesc];
	}
	NSString *strWhere = @"WHERE ";
    NSString *strWhereKnow = @"";
    //Known Unknown버튼을 쓸때만 아래 Where문을 만든다.
    if (blnUseKnowButton == TRUE) {
        NSArray *arrKnow = [self getKnowOfButtons:intSortType];
        if ([[arrKnow objectAtIndex:0] integerValue] == 1) {
            
            strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_NotRated];
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 0 ", strWhere];
            }
        }
        
        if ([[arrKnow objectAtIndex:1] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_Unknown];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_Unknown];
            }
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 1 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 1 ", strWhere];
            }
        }
        
        if ([[arrKnow objectAtIndex:2] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_NotSure];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_NotSure];
            }
            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 2 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 2 ", strWhere];
            }
        }
        
        if ([[arrKnow objectAtIndex:3] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_Known];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_Known];
            }
            
            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 3 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 3 ", strWhere];
            }
        }
        
        if ([[arrKnow objectAtIndex:4] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know > %d ", KnowWord_Known];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know > %d ", strWhereKnow, KnowWord_Known];
            }
            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know > 3 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know > 3 ", strWhere];
            }
        }
        DLog(@"strWhereKnow : %@", strWhereKnow);
        strWhereKnow = [NSString stringWithFormat:@"%@ )", strWhereKnow];//, KnowWord_Known];
        DLog(@"strWhereKnow : %@", strWhereKnow);
        if ([strWhereKnow isEqualToString:@" )"]) {
            strWhereKnow = @"";
        }
        DLog(@"strWhereKnow : %@", strWhereKnow);
        strWhere = [NSString stringWithFormat:@"%@ )", strWhere];
    } else {
        
    }
    
    DLog(@"whereClauseFld : %@", whereClauseFld);
    
    NSString *strWhereFldOver0 = @"";
    if (intSortType == intSortType_Frequency) {
        
    } else if (intSortType == intSortType_Searched) {
        
        strWhereFldOver0 = [NSString stringWithFormat:@"(%@ > 0)", FldName_ToMemorize];
        
        
        if ([strWhere isEqualToString:@"WHERE "]) {
            //            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and %@ > 0", strWhere, whereClauseFld];
        }
    } else if (intSortType == intSortType_MeaningNeeded) {
        strWhereFldOver0 = [NSString stringWithFormat:@"(%@ = '')", FldName_Meaning];
        
        if ([strWhere isEqualToString:@"WHERE "]) {
            //            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and (meaning = '')", strWhere];
            if (openMyDic == FALSE) {
                dbOne = dbBook;
            }
        }
    } else if (intSortType == intSortType_AppearanceOrder) {
        //        if ([strWhere isEqualToString:@"WHERE "]) {
        //            strWhere = [NSString stringWithFormat:@""];
        //        } else {
        //            strWhere = [NSString stringWithFormat:@"%@ )", strWhere];
        //        }
    }
    
    DLog(@"strWhereFldOver0 : %@", strWhereFldOver0);
    
    DLog(@"-%@-", strWhere);
    NSRegularExpression *regE1 = [NSRegularExpression regularExpressionWithPattern:@"WHERE +" options:NSRegularExpressionCaseInsensitive error:nil];
    strWhere = [regE1 stringByReplacingMatchesInString:strWhere options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strWhere length]) withTemplate:@"WHERE "];
    DLog(@"+%@+", strWhere);
    
    //Where절에 아무 내용이 없으면 지운다.
    if ([strWhere isEqualToString:@"WHERE "]) {
        strWhere = [NSString stringWithFormat:@""];
    }
    DLog(@"+%@+", strWhere);
    
    strWhere = @"";
    //Where절에 내용이 있으면 Where를 만든다.
    if ( ([strWhereKnow isEqualToString:@""] == FALSE) || ([strWhereFldOver0 isEqualToString:@""] == FALSE) || ([whereClauseFld isEqualToString:@""] == FALSE) ) {
        
        if (([strWhereKnow isEqualToString:@""] == FALSE)) {
            strWhere = [NSString stringWithFormat:@"%@", strWhereKnow];
        }
        
        if ([strWhere isEqualToString:@""]) {
            if ([strWhereFldOver0 isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@", strWhereFldOver0];
            }
        } else {
            if ([strWhereFldOver0 isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@ and %@", strWhere, strWhereFldOver0];
            }
        }
        
        if ([strWhere isEqualToString:@""]) {
            if ([whereClauseFld isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@", whereClauseFld];
            }
        } else {
            if ([whereClauseFld isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@ and %@", strWhere, whereClauseFld];
            }
        }
        
        DLog(@"strWhere : %@", strWhere);
        
        if ([strWhere isEqualToString:@""] == FALSE) {
            strWhere = [NSString stringWithFormat:@"WHERE %@", strWhere];
        }
        DLog(@"strWhere : %@", strWhere);
    }
    
    
    NSString *strQueryAllCnt = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ %@", strTblName, strWhere];
    recCount = [self GetCountFromTbl:strQueryAllCnt openMyDic:openMyDic];

    DLog(@"recCount : %d", recCount);
    DLog(@"strWhere : %@", strWhere);
    DLog(@"strOrderBy : %@", strOrderBy);
    DLog(@"strLimit : %@", strLimit);
    
    sqlQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ %@ %@ %@", strTblName, strWhere, strOrderBy, strLimit];
    NSInteger cntOfSQLResult = [self GetCountFromTbl:strQueryAllCnt openMyDic:openMyDic];
    DLog(@"cntOfSQLResult : %d", cntOfSQLResult);
    
	sqlQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ %@ %@ %@", strTblName, strWhere, strOrderBy, strLimit];
    
	DLog(@"sqlQuery : %s", [sqlQuery UTF8String]);
	const char *sql = [sqlQuery UTF8String];
    DLog("1");
	if (sqlite3_prepare_v2(dbOne, sql, -1, &statement, NULL) != SQLITE_OK) {
		DLog(@"Open Error : %s", sqlite3_errmsg(dbOne));
	}
    DLog("2");
    //    NSInteger i = 0;
	while (sqlite3_step(statement) == SQLITE_ROW) {
        //        DLog("i : %d", i++);
		NSString	*strIdiom = @"";
        char *charIdiom = (char*)sqlite3_column_text(statement, FLD_NO_IDIOM_Idiom);
        if (charIdiom != NULL) {
            strIdiom = [NSString stringWithUTF8String:charIdiom];
        }
        
		if (strIdiom == NULL) {
			continue;
		}
        
        
		NSString *strMeaning = @"";
		char *charMeaning = (char*)sqlite3_column_text(statement, FLD_NO_IDIOM_Meaning);
		
		if (charMeaning != NULL)
			strMeaning = [NSString stringWithUTF8String:charMeaning];
        
		NSString *strDesc = @"";
		char *charDesc = (char*)sqlite3_column_text(statement, FLD_NO_IDIOM_Desc);
		
		if (charDesc != NULL)
			strDesc = [NSString stringWithUTF8String:charDesc];
        

		NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
		[dicOne setValue:strIdiom forKey:KEY_DIC_Idiom];
		[dicOne setValue:strMeaning forKey:KEY_DIC_MEANING];
		[dicOne setValue:strDesc forKey:KEY_DIC_Desc];
        DLog(@"dicOne : %@", dicOne);
        
		[arrFromTblBook addObject:dicOne];
        
	}
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
	
    //	DLog(@"arrFromTblBook : %@", arrFromTblBook);
	NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
	NSInteger minutes = elapsedTime/60;
	NSInteger seconds = round(elapsedTime - minutes * 60);
	NSString	*strElapsedTime  = nil;
	if (elapsedTime >= 60) {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d분 %d초 소요", minutes, seconds];
	} else {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d초 소요", seconds];
	}
    
	return recCount;
}

//책에 해당되는 테이블의 내용을 가져온다...
+ (NSInteger) getAllWordsArrayFromBookTable:(NSString*)strBookTblNo arrOne:(NSMutableArray*)arrFromTblBook useKnowButton:(BOOL)blnUseKnowButton sqlType:(NSInteger)sqlType sortType:(NSInteger)intSortType pageNumber:(NSInteger)pageNumber whereClauseFld:(NSString*)whereClauseFld orderByFld:(NSString*)orderByFld isAsc:(BOOL)blnAsc openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }
        
    NSInteger recCount = 0;
	NSDate		*startTime1;
	startTime1 = [NSDate date];
	
	[arrFromTblBook removeAllObjects];;
	
	sqlite3_stmt *statement = nil;
	NSString	*sqlQuery = @"";
//	NSInteger	intTblType = TBL_TYPE_TBL_EngDic;
	
	NSInteger intFldNo_Word = FLD_NO_ENG_DIC_WORD;
	NSInteger intFldNo_Meaning = FLD_NO_ENG_DIC_MEANING;
	NSInteger intFldNo_Count = FLD_NO_ENG_DIC_COUNT;
	NSInteger intFldNo_Know = FLD_NO_ENG_DIC_KNOW;
	NSInteger intFldNo_WordLevel1 = FLD_NO_ENG_DIC_WORDLEVEL1;
	NSInteger intFldNo_WordOri = FLD_NO_ENG_DIC_WORDORI;    
    NSInteger intFldNo_ToMemorize = FLD_NO_ENG_DIC_TOMEMORIZE;    
	
	NSString *strTblName  = TBL_EngDic;
////	DLog(@"strBookTblNo : %@", strBookTblNo);
//	if (([strBookTblNo isEqualToString:TBL_EngDic_BookTemp] == TRUE) || ([strBookTblNo isEqualToString:@"WebTemp"] == TRUE) || ([strBookTblNo intValue] > 0)){
//		strTblName = [NSString	stringWithFormat:@"%@_%@", TBL_EngDic, strBookTblNo];
//		intTblType = TBL_TYPE_TBL_EngDicEachBook;
//		intFldNo_Word = FLD_NO_TBL_EngDicEachBook_WORD;
//		intFldNo_Meaning = FLD_NO_TBL_EngDicEachBook_MEANING;
//		intFldNo_Count = FLD_NO_TBL_EngDicEachBook_COUNT;
//		intFldNo_Know = FLD_NO_TBL_EngDicEachBook_KNOW;
//		intFldNo_Level = FLD_NO_TBL_EngDicEachBook_LEVEL;
//        intFldNo_WordOri = FLD_NO_TBL_EngDicEachBook_WORDORI;
//	}
	
    if (openMyDic == OPEN_DIC_DB_BOOK) {
        //FLD_NO_TBL_EngDicEachBook_WORD
        //		strTblName = [NSString	stringWithFormat:@"%@_%@", TBL_EngDic, strBookTblNo];
//        intTblType = TBL_TYPE_TBL_EngDicEachBook;
        intFldNo_Word = FLD_NO_TBL_EngDicEachBook_WORD;
        intFldNo_Meaning = FLD_NO_TBL_EngDicEachBook_MEANING;
        intFldNo_Count = FLD_NO_TBL_EngDicEachBook_COUNT;
        intFldNo_Know = FLD_NO_TBL_EngDicEachBook_KNOW;
        intFldNo_WordLevel1 = FLD_NO_TBL_EngDicEachBook_WORDLEVEL1;
        intFldNo_WordOri = FLD_NO_TBL_EngDicEachBook_WORDORI;
        intFldNo_ToMemorize = FLD_NO_TBL_EngDicEachBook_TOMEMORIZE;            
    } else if ([strBookTblNo isEqualToString:TBL_EngDic_BookTemp] == TRUE) {
        //BookTemp는 각책의 engDic와 같은 테이블을 사용한다.
        strTblName = TBL_EngDic_BookTemp;
        intFldNo_Word = FLD_NO_TBL_EngDicEachBook_WORD;
        intFldNo_Meaning = FLD_NO_TBL_EngDicEachBook_MEANING;
        intFldNo_Count = FLD_NO_TBL_EngDicEachBook_COUNT;
        intFldNo_Know = FLD_NO_TBL_EngDicEachBook_KNOW;
        intFldNo_WordLevel1 = FLD_NO_TBL_EngDicEachBook_WORDLEVEL1;
        intFldNo_WordOri = FLD_NO_TBL_EngDicEachBook_WORDORI;  
        intFldNo_ToMemorize = FLD_NO_TBL_EngDicEachBook_TOMEMORIZE;
    }
	
	NSString *strLimit = @"";
	if (pageNumber > 0) {
		strLimit = [NSString stringWithFormat:@"Limit %d, %d", (pageNumber-1)*kPageDivide, kPageDivide];
	}
	
	NSString *strOrderBy = @"";
	if ([orderByFld isEqualToString:@""] == FALSE) {
		NSString	*strAscOrDesc = @"ASC";
		if (blnAsc == FALSE) {
			strAscOrDesc = @"DESC";
		}
		strOrderBy = [NSString stringWithFormat:@"Order by %@ %@, Word ASC",orderByFld, strAscOrDesc]; 
	}
	NSString *strWhere = @"WHERE ";
    NSString *strWhereKnow = @"";
    //Known Unknown버튼을 쓸때만 아래 Where문을 만든다.
    if (blnUseKnowButton == TRUE) {
        NSArray *arrKnow = [self getKnowOfButtons:intSortType];    
        if ([[arrKnow objectAtIndex:0] integerValue] == 1) {

            strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_NotRated];
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 0 ", strWhere];
            }
        }
        
        if ([[arrKnow objectAtIndex:1] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_Unknown];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_Unknown];
            }
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 1 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 1 ", strWhere];
            }
        }

        if ([[arrKnow objectAtIndex:2] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_NotSure];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_NotSure];
            }
            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 2 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 2 ", strWhere];
            }
        }

        if ([[arrKnow objectAtIndex:3] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know = %d ", KnowWord_Known];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know = %d ", strWhereKnow, KnowWord_Known];
            }

            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know = 3 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know = 3 ", strWhere];
            }
        }

        if ([[arrKnow objectAtIndex:4] integerValue] == 1) {
            if ([strWhereKnow isEqualToString:@""]) {
                strWhereKnow = [NSString stringWithFormat:@"( Know > %d ", KnowWord_Known];
            } else {
                strWhereKnow = [NSString stringWithFormat:@"%@ or Know > %d ", strWhereKnow, KnowWord_Known];
            }
            
            if ([strWhere isEqualToString:@"WHERE "]) {
                strWhere = [NSString stringWithFormat:@"%@ ( Know > 3 ", strWhere];
            } else {
                strWhere = [NSString stringWithFormat:@"%@ or Know > 3 ", strWhere];
            }
        }
        DLog(@"strWhereKnow : %@", strWhereKnow);        
        strWhereKnow = [NSString stringWithFormat:@"%@ )", strWhereKnow];//, KnowWord_Known];
        DLog(@"strWhereKnow : %@", strWhereKnow);        
        if ([strWhereKnow isEqualToString:@" )"]) {
            strWhereKnow = @"";
        }
        DLog(@"strWhereKnow : %@", strWhereKnow);
        strWhere = [NSString stringWithFormat:@"%@ )", strWhere];
    } else {
        
    }

    DLog(@"whereClauseFld : %@", whereClauseFld);
    
    NSString *strWhereFldOver0 = @"";
    if (intSortType == intSortType_Frequency) {

    } else if (intSortType == intSortType_Searched) {

        strWhereFldOver0 = [NSString stringWithFormat:@"(%@ > 0)", FldName_ToMemorize];

        
        if ([strWhere isEqualToString:@"WHERE "]) {
//            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and %@ > 0", strWhere, whereClauseFld];
        }        
    } else if (intSortType == intSortType_MeaningNeeded) {
        strWhereFldOver0 = [NSString stringWithFormat:@"(%@ = '')", FldName_Meaning];
        
        if ([strWhere isEqualToString:@"WHERE "]) {
//            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and (meaning = '')", strWhere];            
            if (openMyDic == FALSE) {
                dbOne = dbBook;
            }
        }
    } else if (intSortType == intSortType_AppearanceOrder) {
//        if ([strWhere isEqualToString:@"WHERE "]) {
//            strWhere = [NSString stringWithFormat:@""];
//        } else {
//            strWhere = [NSString stringWithFormat:@"%@ )", strWhere];
//        }
    }
    
    DLog(@"strWhereFldOver0 : %@", strWhereFldOver0);
    
    
    
    if (sqlType == getAllWordsSQLTypeUserLevel) {

        if ([whereClauseFld isEqualToString:@""]) {
            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ %@", strWhere, whereClauseFld];
        }
            


    } else if (sqlType == getAllWordsSQLTypeWordGroup) {
        if ([whereClauseFld isEqualToString:@""]) {
            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and (%@)", strWhere, whereClauseFld];
        }
        
            

    } else if (sqlType == getAllWordsSQLTypeUserDic) {
        if ([whereClauseFld isEqualToString:@""]) {
            strWhere = [NSString stringWithFormat:@""];
        } else {
            strWhere = [NSString stringWithFormat:@"%@ and (%@)", strWhere, whereClauseFld];
        }        
            
    }

    DLog(@"-%@-", strWhere);
    NSRegularExpression *regE1 = [NSRegularExpression regularExpressionWithPattern:@"WHERE +" options:NSRegularExpressionCaseInsensitive error:nil];
    strWhere = [regE1 stringByReplacingMatchesInString:strWhere options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [strWhere length]) withTemplate:@"WHERE "];
    DLog(@"+%@+", strWhere);
    
    //Where절에 아무 내용이 없으면 지운다.
    if ([strWhere isEqualToString:@"WHERE "]) {
        strWhere = [NSString stringWithFormat:@""];
    } 
    DLog(@"+%@+", strWhere);

    strWhere = @"";
    //Where절에 내용이 있으면 Where를 만든다.
    if ( ([strWhereKnow isEqualToString:@""] == FALSE) || ([strWhereFldOver0 isEqualToString:@""] == FALSE) || ([whereClauseFld isEqualToString:@""] == FALSE) ) {
        
        if (([strWhereKnow isEqualToString:@""] == FALSE)) {
            strWhere = [NSString stringWithFormat:@"%@", strWhereKnow];
        }
        
        if ([strWhere isEqualToString:@""]) {
            if ([strWhereFldOver0 isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@", strWhereFldOver0];
            }
        } else {
            if ([strWhereFldOver0 isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@ and %@", strWhere, strWhereFldOver0];
            }
        }

        if ([strWhere isEqualToString:@""]) {
            if ([whereClauseFld isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@", whereClauseFld];
            }
        } else {
            if ([whereClauseFld isEqualToString:@""] == FALSE) {
                strWhere = [NSString stringWithFormat:@"%@ and %@", strWhere, whereClauseFld];
            }
        }

        DLog(@"strWhere : %@", strWhere);
        
        if ([strWhere isEqualToString:@""] == FALSE) {
            strWhere = [NSString stringWithFormat:@"WHERE %@", strWhere];
        }
        DLog(@"strWhere : %@", strWhere);
    }
    
    
    NSString *strQueryAllCnt = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ %@", strTblName, strWhere];
    recCount = [self GetCountFromTbl:strQueryAllCnt openMyDic:openMyDic];
    
    DLog(@"strWhere : %@", strWhere);
    DLog(@"strOrderBy : %@", strOrderBy);
    DLog(@"strLimit : %@", strLimit);
    
    sqlQuery = [NSString	stringWithFormat:@"SELECT count(*) FROM %@ %@ %@ %@", strTblName, strWhere, strOrderBy, strLimit];
    NSInteger cntOfSQLResult = [self GetCountFromTbl:strQueryAllCnt openMyDic:openMyDic];
    DLog(@"cntOfSQLResult : %d", cntOfSQLResult);
    
	sqlQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ %@ %@ %@", strTblName, strWhere, strOrderBy, strLimit];

	DLog(@"sqlQuery : %s", [sqlQuery UTF8String]);		
	const char *sql = [sqlQuery UTF8String];
        DLog("1");
	if (sqlite3_prepare_v2(dbOne, sql, -1, &statement, NULL) != SQLITE_OK) {
		DLog(@"Open Error : %s", sqlite3_errmsg(dbOne));		
	}
    DLog("2");
//    NSInteger i = 0;
	while (sqlite3_step(statement) == SQLITE_ROW) {
//        DLog("i : %d", i++);
		NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, intFldNo_Word)];
		if (strWord == NULL) {
			continue;
		}
		NSString *strMeaning = nil;
		char *localityChars = (char*)sqlite3_column_text(statement, intFldNo_Meaning);
		
		if (localityChars == NULL)
			strMeaning = @"";
		else
			strMeaning = [NSString stringWithUTF8String:localityChars];			
		
        NSString *wordOri = [myCommon GetOriWordOnlyIfExistInTbl:strWord];
//		NSMutableString		*wordOri = [NSMutableString stringWithFormat:@""];
//		[myCommon GetOriWordIfExistInTbl:strWord OriWord:wordOri];
		NSString *worOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:wordOri];
		

		//뜻이 없으면 TBL_EngDic의 원형을가져와서 strMeaningOri에 넣는다.
		if ([strMeaning isEqualToString:@""] == TRUE) {
            if ([strWord isEqualToString:wordOri] == FALSE) {
                    NSString *strQueryWordOri = [NSString stringWithFormat:@"SELECT %@ From %@ WHERE %@ = '%@'", FldName_TBL_EngDic_MEANING, TBL_EngDic, FldName_TBL_EngDic_WORD, worOriForSQL];
                    strMeaning = [self getStringFldValueFromTbl:strQueryWordOri openMyDic:TRUE];
            }
		}
		if ([[whereClauseFld lowercaseString] isEqualToString:@"meaning"] == TRUE) {
			if ([strMeaning isEqualToString:@""] == FALSE) {
				//뜻작성순에서 뜻이 있으면 넘어간다.
				continue;
			}
		}

		NSString *strKnow = @"";
		char *charKnow = (char*)sqlite3_column_text(statement, intFldNo_Know);
		if (charKnow == NULL)
			strKnow = @"0";
		else
			strKnow = [NSString stringWithUTF8String:charKnow];						
			
        NSString *strWordOri = @"";
        char *charWordOri = (char*)sqlite3_column_text(statement, intFldNo_WordOri);			
        if (charWordOri == NULL)
            strWordOri = @"";
        else
            strWordOri = [NSString stringWithUTF8String:charWordOri];	

        NSString *strPronounce = @"";
        char *charPronounce = (char*)sqlite3_column_text(statement, FLD_NO_ENG_DIC_Pronounce);
        if (charPronounce == NULL)
            strPronounce = @"";
        else
            strPronounce = [NSString stringWithUTF8String:charPronounce];

        if ( (openMyDic == OPEN_DIC_DB_BOOK) || ([strBookTblNo isEqualToString:TBL_EngDic_BookTemp] == TRUE) ) {
            //ENG_DIC에 있는 발음을 가져온다.
            NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
            NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_Pronounce, TBL_EngDic, FldName_Word, strWordForSQL];
            strPronounce = [myCommon getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
        }
        
		NSInteger count = sqlite3_column_int(statement, intFldNo_Count);
		NSInteger level = sqlite3_column_int(statement, intFldNo_WordLevel1);		
        NSInteger ToMemorize = sqlite3_column_int(statement, intFldNo_ToMemorize);
        
		//DLog(@"word : %@, meaning : %@, know : %@, count:%d", strWord, strMeaning, strKnow, count);
		NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
		[dicOne setValue:strWord forKey:@"Word"];
		[dicOne setValue:strMeaning forKey:@"Meaning"];
		[dicOne setValue:strKnow forKey:KEY_DIC_KNOW];
		[dicOne setValue:[NSNumber numberWithInt:count] forKey:@"Count"];
		[dicOne setValue:[NSNumber numberWithInt:level] forKey:@"Level"];
        [dicOne setValue:strWordOri forKey:@"WordOri"];
        [dicOne setValue:[NSNumber numberWithInt:ToMemorize] forKey:@"ToMemorize"];    
        [dicOne setValue:strPronounce forKey:KEY_DIC_Pronounce];
        
        
//        if (([strBookTblNo isEqualToString:@"BookTemp"] == TRUE) || ([strBookTblNo isEqualToString:@"WebTemp"] == TRUE) || ([strBookTblNo intValue] > 0)){

        if ( (openMyDic == OPEN_DIC_DB_BOOK) || ([strBookTblNo isEqualToString:TBL_EngDic_BookTemp] == TRUE) ) {
            NSInteger wordOrder = sqlite3_column_int(statement, FLD_NO_ENG_DIC_WORDORDER);

            [dicOne setValue:[NSNumber numberWithInt:wordOrder] forKey:@"WordOrder"];
//                    
//        } else {
//            NSInteger ToMemorize = sqlite3_column_int(statement, FLD_NO_ENG_DIC_ToMemorize);            
//            [dicOne setValue:[NSNumber numberWithInt:ToMemorize] forKey:@"ToMemorize"]; 
        }
        DLog(@"dicOne : %@", dicOne);
        
		[arrFromTblBook addObject:dicOne];

	}
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
	
//	DLog(@"arrFromTblBook : %@", arrFromTblBook);
	NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
	NSInteger minutes = elapsedTime/60;
	NSInteger seconds = round(elapsedTime - minutes * 60);
	NSString	*strElapsedTime  = nil;
	if (elapsedTime >= 60) {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d분 %d초 소요", minutes, seconds];
	} else {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d초 소요", seconds];
	}

	return recCount;
}

//MyEnglish에서 백업할 단어만 추출한다.
+ (void) getExportWordList:(NSMutableArray*)arrOne 
{
	NSDate		*startTime1;
	startTime1 = [NSDate date];
	
	[arrOne removeAllObjects];;
	
	sqlite3_stmt *statement = nil;

	NSInteger intFldNo_Word = FLD_NO_ENG_DIC_WORD;
	NSInteger intFldNo_Meaning = FLD_NO_ENG_DIC_MEANING;
	NSInteger intFldNo_Count = FLD_NO_ENG_DIC_COUNT;
	NSInteger intFldNo_Know = FLD_NO_ENG_DIC_KNOW;
//	NSInteger intFldNo_WordOri = FLD_NO_ENG_DIC_WORDORI;    
	
	NSString	*sqlQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE  %@ > 0 ORDER BY %@ ASC", TBL_EngDic, FldName_Know, FldName_Word];

	DLog(@"sqlQuery : %s", [sqlQuery UTF8String]);		
	const char *sql = [sqlQuery UTF8String];
    DLog("1");
	if (sqlite3_prepare_v2(dbOne, sql, -1, &statement, NULL) != SQLITE_OK) {
		DLog(@"Open Error : %s", sqlite3_errmsg(dbOne));		
	}
    DLog("2");
//    NSInteger i = 0;
	while (sqlite3_step(statement) == SQLITE_ROW) {
//        DLog("i : %d", i++);
		NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, intFldNo_Word)];
		if (strWord == NULL) {
			continue;
		}
		NSString *strMeaning = nil;
		char *localityChars = (char*)sqlite3_column_text(statement, intFldNo_Meaning);
		
		if (localityChars == NULL)
			strMeaning = @"";
		else
			strMeaning = [NSString stringWithUTF8String:localityChars];			
        
		NSString *strKnow = @"";
		char *charKnow = (char*)sqlite3_column_text(statement, intFldNo_Know);
		if (charKnow == NULL)
			strKnow = @"0";
		else
			strKnow = [NSString stringWithUTF8String:charKnow];						
        
//        NSString *strWordOri = @"";
//        char *charWordOri = (char*)sqlite3_column_text(statement, intFldNo_WordOri);			
//        if (charWordOri == NULL)
//            strWordOri = @"";
//        else
//            strWordOri = [NSString stringWithUTF8String:charWordOri];	
        
        
        NSString *strDesc = @"";
        char *charDesc = (char*)sqlite3_column_text(statement, FLD_NO_ENG_DIC_Desc);			
        if (charDesc == NULL)
            strDesc = @"";
        else
            strDesc = [NSString stringWithUTF8String:charDesc];	
        
        NSString *strPronounce = @"";
        char *charPronounce = (char*)sqlite3_column_text(statement, FLD_NO_ENG_DIC_Pronounce);			
        if (charPronounce == NULL)
            strPronounce = @"";
        else
            strPronounce = [NSString stringWithUTF8String:charPronounce];	
        
        NSString *strKnowPronounce = @"";
        char *charKnowPronounce = (char*)sqlite3_column_text(statement, FLD_NO_ENG_DIC_KnowPronounce);			
        if (charKnowPronounce == NULL)
            strKnowPronounce = @"";
        else
            strKnowPronounce = [NSString stringWithUTF8String:charKnowPronounce];	

        
        
		NSInteger count = sqlite3_column_int(statement, intFldNo_Count);
		
        NSInteger ToMemorize = sqlite3_column_int(statement, FLD_NO_ENG_DIC_TOMEMORIZE);            
        
		//DLog(@"word : %@, meaning : %@, know : %@, count:%d", strWord, strMeaning, strKnow, count);
		NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
		[dicOne setValue:strWord forKey:@"Word"];
		[dicOne setValue:strMeaning forKey:@"Meaning"];
		[dicOne setValue:strKnow forKey:@"Know"];
		[dicOne setValue:[NSNumber numberWithInt:count] forKey:@"Count"];
        [dicOne setValue:strDesc forKey:@"Desc"];  
        [dicOne setValue:strPronounce forKey:@"Pronounce"];
        [dicOne setValue:strKnowPronounce forKey:@"KnowPronounce"]; 
        
        [dicOne setValue:[NSNumber numberWithInt:ToMemorize] forKey:@"ToMemorize"]; 

        
		[arrOne addObject:dicOne];
        //        DLog(@"dicOne : %@", dicOne);
	}
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
	
    //	DLog(@"arrFromTblBook : %@", arrFromTblBook);
	NSTimeInterval elapsedTime = [startTime1 timeIntervalSinceNow] * (-1);
	NSInteger minutes = elapsedTime/60;
	NSInteger seconds = round(elapsedTime - minutes * 60);
	NSString	*strElapsedTime  = nil;
	if (elapsedTime >= 60) {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d분 %d초 소요", minutes, seconds];
	} else {
		strElapsedTime = [NSString stringWithFormat:@"ReadDicTable : %d초 소요", seconds];
	}
    
	return;
}


//단어로부터 원형을 찾아서 리턴한다..
+ (NSString*) GetOriWordOnlyIfExistInTbl:(NSString*)strWord
{
	NSString *strWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
	NSString *strWordOri = [self getCleanAndLowercase:strWord];

	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWordForSQL];
    //	DLog(@"strQuery GetDataFromTbl : %@", strQuery);
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		int ret = sqlite3_step(stmt);
		if ((SQLITE_DONE == ret) || (SQLITE_ROW == ret)) {
			char *charWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDORI);		
			if (charWordOri != NULL)
                strWordOri = [NSString stringWithUTF8String:charWordOri];	
		} else {
			DLog(@" Step error GetDataFromTbl : %d %@ %s", ret, strQuery, sqlite3_errmsg(db));
		}				
	} else {
		DLog(@" error GetDataFromTbl : %@ %s", strQuery, sqlite3_errmsg(db));
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return strWordOri;
}

//단어에 대한 정보를 가져온다 (myDic.sqlite에 있는것 가져온다. restore를 위해)
+ (BOOL) getWordListInMyDic:(NSString*)strQuery sqliteDBPath:(NSString*)strDbMyDicPath  byArray:(NSMutableArray*)arrResult byDic:(NSMutableDictionary*)dicResult
{
    sqlite3 *dbMyDic = nil;
    if (sqlite3_open([strDbMyDicPath UTF8String], &dbMyDic) != SQLITE_OK)
    {
        sqlite3_close(dbMyDic);
        DLog(@"Can't open DB : %@", strDbMyDicPath);
        return FALSE;
    }
    
    DLog(@"strQuery : %@", strQuery);
    DLog(@"strDbMyDicPath : %@", strDbMyDicPath);
    
    BOOL blnResult =TRUE;
    
    [arrResult removeAllObjects];
    [dicResult removeAllObjects];
    
	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
    
	if (sqlite3_prepare_v2(dbMyDic, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_WORD)];
			if (strWord == NULL) {
				continue;
			}
            
            NSString *strWordOri = @"";
			char *charWordOri = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_WORDORI);			
			if (charWordOri == NULL)
				strWordOri = @"";
			else
				strWordOri = [NSString stringWithUTF8String:charWordOri];	
            
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
            
            NSString *strKnowPronounce = @"";
            char *charKnowPronounce = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_KnowPronounce);			
            if (charKnowPronounce == NULL)
                strKnowPronounce = @"";
            else
                strKnowPronounce = [NSString stringWithUTF8String:charKnowPronounce];		
            
			NSString *strKnow = @"";
			char *charKnow = (char*)sqlite3_column_text(stmt, FLD_NO_tblEngDic_KNOW);			
			if (charKnow == NULL)
				strKnow = @"0";
			else
				strKnow = [NSString stringWithUTF8String:charKnow];		
            
            
            NSInteger count = sqlite3_column_int(stmt, FLD_NO_tblEngDic_COUNT);
            NSInteger ToMemorize = sqlite3_column_int(stmt, FLD_NO_tblEngDic_RANK);
            
			NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
			[dicOne setValue:strWord forKey:@"Word"];
			[dicOne setValue:strMeaning forKey:@"Meaning"];
			[dicOne setValue:strKnow forKey:@"Know"];
			[dicOne setValue:[NSNumber numberWithInt:count] forKey:@"Count"];
            [dicOne setValue:[NSNumber numberWithInt:ToMemorize] forKey:@"ToMemorize"];
			[dicOne setValue:strWordOri forKey:@"WordOri"];
            [dicOne setValue:strDesc forKey:@"Desc"];  
            [dicOne setValue:strPronounce forKey:@"Pronounce"];
            [dicOne setValue:strKnowPronounce forKey:@"KnowPronounce"];                  
            
            [arrResult  addObject:dicOne];
            [dicResult  setObject:dicOne forKey:strWord];
		}
	}
	
    //    DLog(@"arrResult : %@", arrResult);
    //    DLog(@"dicResult : %@", dicResult);    
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnResult;
}

//단어에 대한 정보를 가져온다... (뜻이 없으면 옵션에 따라 원형의 뜻을 가져올지 말지를 결정한다.)
+ (BOOL) getWordList:(NSString*)strQuery  getOriMeaning:(NSInteger)getOriMeaning byArray:(NSMutableArray*)arrResult byDic:(NSMutableDictionary*)dicResult openMyDic:(NSInteger)openMyDic
{
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }
//    DLog(@"strQuery : %@ ", strQuery);
    
    BOOL blnResult =TRUE;
    
    [arrResult removeAllObjects];
    [dicResult removeAllObjects];

	const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
	
	NSInteger intFldNo_Word = FLD_NO_ENG_DIC_WORD;
	NSInteger intFldNo_Meaning = FLD_NO_ENG_DIC_MEANING;
	NSInteger intFldNo_Count = FLD_NO_ENG_DIC_COUNT;
	NSInteger intFldNo_Know = FLD_NO_ENG_DIC_KNOW;
	NSInteger intFldNo_Level = FLD_NO_ENG_DIC_WORDLEVEL1;
	NSInteger intFldNo_Rank = FLD_NO_ENG_DIC_TOMEMORIZE;    
	NSInteger intFldNo_WordOri = FLD_NO_ENG_DIC_WORDORI;   
	NSInteger intFldNo_InstalledWord = FLD_NO_ENG_DIC_INSTALLEDWORD;
    if (openMyDic == OPEN_DIC_DB_BOOK) {
		intFldNo_Word = FLD_NO_TBL_EngDicEachBook_WORD;
		intFldNo_Meaning = FLD_NO_TBL_EngDicEachBook_MEANING;
		intFldNo_Count = FLD_NO_TBL_EngDicEachBook_COUNT;
		intFldNo_Know = FLD_NO_TBL_EngDicEachBook_KNOW;
		intFldNo_Level = FLD_NO_TBL_EngDicEachBook_WORDLEVEL1;
        intFldNo_Rank = FLD_NO_TBL_EngDicEachBook_TOMEMORIZE; 
        intFldNo_WordOri = FLD_NO_TBL_EngDicEachBook_WORDORI;
        intFldNo_InstalledWord = FLD_NO_TBL_EngDicEachBook_INSTALLEDWORD;
	}

    
	if (sqlite3_prepare_v2(dbOne, sqlQuery, -1, &stmt, NULL) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			NSString	*strWord = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, intFldNo_Word)];
			if (strWord == NULL) {
				continue;
			}
            
            NSString *strWordOri = @"";
			char *charWordOri = (char*)sqlite3_column_text(stmt, intFldNo_WordOri);			
			if (charWordOri == NULL)
				strWordOri = @"";
			else
				strWordOri = [NSString stringWithUTF8String:charWordOri];	
                        
			NSString *strMeaning = @"";
			char *localityChars = (char*)sqlite3_column_text(stmt, intFldNo_Meaning);			
			if (localityChars == NULL)
				strMeaning = @"";
			else
				strMeaning = [NSString stringWithUTF8String:localityChars];						
			//		DLog(@"strMeaning readDicTable : %@ %@", strWord, strMeaning);
            
            if (getOriMeaning == When_WordHasNoMeaning_GetOriMeaning) {
                //뜻이 없으면 TBL_EngDic의 원형을가져와서 strMeaningOri에 넣는다.
                //            NSMutableString		*wordOri = [NSMutableString stringWithFormat:@""];
                //            [myCommon GetOriWordIfExistInTbl:strWord OriWord:wordOri];
                //            NSString *wordOri = [self GetOriWordIfExistInTbl:strWord];
                NSString *wordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@", strWordOri]];
                //            NSString *strMeaningOri = @"";
                if ([strMeaning isEqualToString:@""] == TRUE) {
                    if ([strWord isEqualToString:strWordOri] == FALSE) {                    
                        NSString *strQueryWordOri = [NSString stringWithFormat:@"SELECT %@ From %@ WHERE %@ = '%@'", FldName_TBL_EngDic_MEANING, TBL_EngDic, FldName_TBL_EngDic_WORDORI, wordOriForSQL];
                        strMeaning = [self getStringFldValueFromTbl:strQueryWordOri openMyDic:TRUE];
                    }
                }
            }
            
			NSString *strKnow = @"";
			char *charKnow = (char*)sqlite3_column_text(stmt, intFldNo_Know);			
			if (charKnow == NULL)
				strKnow = @"0";
			else
				strKnow = [NSString stringWithUTF8String:charKnow];		
            
			NSString *strFirstWord = @"";
			char *charFirstWord = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_RESERV1_CHAR);
			if (charFirstWord == NULL)
				strFirstWord = @"0";
			else
				strFirstWord = [NSString stringWithUTF8String:charFirstWord];
	
			NSString *strHanjaKoreanMeaning = @"";
			char *charHanjaKoreanMeaning = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_RESERV2_CHAR);
			if (charHanjaKoreanMeaning == NULL)
				strHanjaKoreanMeaning = @"0";
			else
				strHanjaKoreanMeaning = [NSString stringWithUTF8String:charHanjaKoreanMeaning];
            
//            DLog(@"strHanjaKoreanMeaning : %@", strHanjaKoreanMeaning);
			
            
            NSInteger count = sqlite3_column_int(stmt, intFldNo_Count);
            NSInteger rank = sqlite3_column_int(stmt, intFldNo_Rank);
            NSInteger level = sqlite3_column_int(stmt, intFldNo_Level); 
            NSInteger installedWord = sqlite3_column_int(stmt, intFldNo_InstalledWord);
            NSInteger intWordLength = sqlite3_column_int(stmt, FLD_NO_ENG_DIC_RESERV1_INT);
            
			//DLog(@"word : %@, meaning : %@, know : %@, count:%d", strWord, strMeaning, strKnow, count);
			NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
			[dicOne setValue:strWord forKey:KEY_DIC_WORD];
			[dicOne setValue:strMeaning forKey:KEY_DIC_MEANING];
            [dicOne setValue:strMeaning forKey:KEY_DIC_MeaningChanged];
			[dicOne setValue:strKnow forKey:KEY_DIC_KNOW];
			[dicOne setValue:strKnow forKey:KEY_DIC_KnowChanged];
			[dicOne setValue:[NSNumber numberWithInt:count] forKey:@"Count"];
            [dicOne setValue:[NSNumber numberWithInt:rank] forKey:@"Rank"];
            [dicOne setValue:[NSNumber numberWithInt:level] forKey:@"Level"];
			[dicOne setValue:strWordOri forKey:KEY_DIC_WORDORI];
            [dicOne setValue:[NSNumber numberWithInt:installedWord] forKey:KEY_DIC_InstalledWord];
            [dicOne setValue:[NSNumber numberWithInt:intWordLength] forKey:KEY_DIC_WordLength];
			[dicOne setValue:strFirstWord forKey:FldName_FirstWord];            
            [dicOne setValue:strHanjaKoreanMeaning forKey:KEY_DIC_HanjaKoreanMeaning];
            
//			[dicOne setValue:[NSNumber numberWithInt:ToMemorize] forKey:@"ToMemorize"];

            
            if (openMyDic == OPEN_DIC_DB) {
                NSString *strDesc = @"";
                char *charDesc = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_Desc);			
                if (charDesc == NULL)
                    strDesc = @"";
                else
                    strDesc = [NSString stringWithUTF8String:charDesc];	

                NSString *strPronounce = @"";
                char *charPronounce = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_Pronounce);			
                if (charPronounce == NULL)
                    strPronounce = @"";
                else
                    strPronounce = [NSString stringWithUTF8String:charPronounce];	
                
                NSString *strKnowPronounce = @"";
                char *charKnowPronounce = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_KnowPronounce);			
                if (charKnowPronounce == NULL)
                    strKnowPronounce = @"";
                else
                    strKnowPronounce = [NSString stringWithUTF8String:charKnowPronounce];	


                [dicOne setValue:strDesc forKey:KEY_DIC_Desc];
                [dicOne setValue:strDesc forKey:KEY_DIC_DescChanged];
                [dicOne setValue:strPronounce forKey:KEY_DIC_Pronounce];
                [dicOne setValue:strPronounce forKey:KEY_DIC_PronounceChanged];
                [dicOne setValue:strKnowPronounce forKey:KEY_DIC_KnowPronounce];
                [dicOne setValue:strKnowPronounce forKey:KEY_DIC_KnowPronounceChanged];
            }
            
            [arrResult  addObject:dicOne];
            [dicResult setObject:dicOne forKey:strWord];
//            DLog(@"dicOne : %@", dicOne);             
//            DLog(@"dicResult : %@", dicResult); 
		}
	}
	
//    DLog(@"dicResult : %@", dicResult);    
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	return blnResult;
}

//단어로부터 원형을 가져온다. (숙어등은 원형,원혀, 등의 형식으로 가져온다.
+ (NSString*) getOriWithWordOrIdiom:(NSString*)strWord
{
    DLog(@"strWord : %@", strWord);
    NSString *strWordOri = [NSString stringWithString:strWord];
    
    NSArray *arrOne = [strWord componentsSeparatedByString:@" "];
    if ([arrOne count] > 1) {
        NSMutableString *strWordOriTemp = [NSMutableString stringWithFormat:@""];
        for (NSInteger i = 0; i < [arrOne count]; ++i) {            
            NSString *strWordTemp = [arrOne objectAtIndex:i];
            DLog(@"strWordTemp : %@", strWordTemp);
            NSString *strWordTempForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordTemp];
            
            NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_WORDORI, TBL_EngDic, FldName_Word, strWordTempForSQL];
            NSString *strWordOriTemp1 = [self getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
            DLog(@"strWordOriTemp1 : %@", strWordOriTemp1);
            if ( (strWordOriTemp1 == NULL) || ([strWordOriTemp1 isEqualToString:@""]) ) {
                strWordOriTemp1 = strWord;
            }
            DLog(@"strWordOriTemp1 : %@", strWordOriTemp1);
            [strWordOriTemp appendFormat:@"%@,", strWordOriTemp1];
            DLog(@"strWordOriTemp : %@", strWordOriTemp);            
        }
        strWordOri = [NSString stringWithFormat:@"%@",strWordOriTemp];

    } else {
        //한개의 단어이면...
        strWordOri = [myCommon GetOriWordOnlyIfExistInTbl:strWord];
//        
//        NSString *strWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
//        NSString *strQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_WORDORI, TBL_EngDic, FldName_Word, strWordForSQL];
//        strWordOri = [self getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
//        if ( (strWordOri == NULL) || ([strWordOri isEqualToString:@""]) ) {
//            strWordOri = strWord;
//        }
    }
    DLog(@"strWordOri : %@", strWordOri);    
    return [NSString stringWithFormat:@"%@", strWordOri];
}
//
////숙어이상으로부터 원형을 가져온다.(원형,원형,원형,  의 형식)
//+ (NSMutableArray*) getWordOriInWords:(NSString*)strWords
//{
//    NSMutableArray *arrResult = [strWordOri componentsSeparatedByString:@" "];
//    if ([arrOne count] > 0) {
//        for (NSInteger i = 0; i < [arrOne count]; ++i) {
//            strWordOri = [NSString stringWithFormat:@"%@,", [arrOne objectAtIndex:i]];
//        }
//    }
//    
//}

//단어가 없으면 TBL_EngDic에 추가한다. 이함수를 부르기전에 미리 단어를 sql문에 맞게 정리해야한다.
+ (void) insertWordIfNotExist:(NSString*)strWord wordOriForSQL:(NSString*)strWordOri know:(NSString*)strKnow
{
	//	DLog(@"strWord : %@", strWord);
	//	DLog(@"strWordOri : %@", strWordOri);
//    NSArray *arrOne = [strWord componentsSeparatedByString:@" "];
//    if ([arrOne count] > 0) {
//        NSString *strWordOriTemp = @"";
//        for (NSInteger i = 0; i < [arrOne count]; ++i) {
//            strWordOriTemp = [NSString stringWithFormat:@"%@,", [arrOne objectAtIndex:i]];
//        }
//        strWordOri = [NSString stringWithString:strWordOriTemp];
//        DLog(@"strWordOri : %@", strWordOri);
//    }
    //단어가 없으면 저장하지 않는다.
    if ( (strWord == NULL) || ([strWord isEqualToString:@""]) ) {
        return;
    }
    
    strWord = [strWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strWordOri = [strWordOri stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
    NSString *strWordOriForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
    
    //strWordOriForSQL를 따로 지정하지 않으면... 원형을 사전에서 찾아온다.
    if ([strWordOri isEqualToString:@""]) {
        strWordOri = [self getOriWithWordOrIdiom:strWord];
        strWordOriForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
    }
    NSArray *arrWord = [strWord componentsSeparatedByString:@" "];
    NSInteger intWordLength = 0; [arrWord count];
    NSString *strFirstTwoWordForSQL = @"";
    if ([arrWord count] > 1) {
        intWordLength = [arrWord count];
        NSString *strFirstWordOri = [self GetOriWordOnlyIfExistInTbl:[arrWord objectAtIndex:0]];
        NSString *strSecondWordOri = [self GetOriWordOnlyIfExistInTbl:[arrWord objectAtIndex:1]];
        strFirstWordOri = [strFirstWordOri stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        strSecondWordOri = [strSecondWordOri stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        strFirstTwoWordForSQL = [self getCleanAndSingleQuoteWordForSQL:[NSString stringWithFormat:@"%@ %@", strFirstWordOri, strSecondWordOri]];
    }
    

        
	//단어가 없으면 추가한다. (TBL_EngDic)
	NSString	*strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@) VALUES('%@','%@', '', 0, 99, '%@', '', %d, '%@')", TBL_EngDic, FldName_TBL_EngDic_WORD, FldName_TBL_EngDic_KNOW, FldName_TBL_EngDic_MEANING, FldName_ToMemorize, FldName_TBL_EngDic_LEVEL, FldName_TBL_EngDic_WORDORI, FldName_TBL_EngDic_DESC,FldName_WordLength, FldName_FirstWord, strWordForSQL, strKnow, strWordOriForSQL, intWordLength, strFirstTwoWordForSQL];
	[myCommon changeRec:strQuery openMyDic:TRUE];
}

//TBL_EngDic_*의 아는정도를 BookSetting추가한다.
+ (BOOL) updateBookSettingEachBookKnow:(NSInteger)intBookTblNo
{
	BOOL blnUpdated = FALSE;
    //아는단어일때 (99 Exclude도 아는단어로 취급한다.)
	NSString	*strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ >= %d", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_Known];	
	int intKnow = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];
    //잘모르는 단어일때
	strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = %d", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_NotSure];	
	int intHalfKnow = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];
    //모르는 단어 (사전에 있는 단어중 아는정도를 선택안했을때와 모르는 단어)
	strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE (%@ = %d or %@ = %d)", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_NotRated,  FldName_TBL_EngDic_KNOW, KnowWord_Unknown];	
	int intUnKnown = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];

    //사전에 없는 단어 (적당한 필드가 없어서 임시로 EXCLUDE 필드에 값을 넣는다.) 
    strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@ = %d", TBL_EngDic, FldName_TBL_EngDic_KNOW, KnowWord_NotInDic];	
	int intNotInBook = [myCommon GetCountFromTbl:strQuery openMyDic:OPEN_DIC_DB_BOOK];

    
	strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %d , %@ = %d WHERE %@ = %d",TBL_BOOK_LIST,  FldName_BOOK_LIST_WORD_COUNT_UNKNOWN, intUnKnown, FldName_BOOK_LIST_WORD_COUNT_NOTSURE, intHalfKnow, FldName_BOOK_LIST_WORD_COUNT_KNOWN, intKnow, FldName_BOOK_LIST_WORD_COUNT_EXCLUDE, intNotInBook, FldName_BOOK_LIST_ID, intBookTblNo];
	DLog(@"strQuery updateBookSettingEachBookKnow : %@", strQuery);
	if ([myCommon changeRec:strQuery openMyDic:TRUE]) {
		blnUpdated = TRUE;
	}
	return blnUpdated;
}

//단어를 선택할때마다 중요도 수를 1씩 올린다.(현재는 rank를 빌려쓴다..) 왜 wordOri가 있지? -> 파생어를 선택해도 원형도 같이 선택된것처럼 검색수를 1을 올릴려구있는데 WordOri는 카운터를 올리면 안된다.
+ (BOOL) updateCountOfCheckedWord:(NSInteger)intBookTblNo word:(NSString*)strWord wordOri:(NSString*)strWordOri
{
	BOOL blnUpdated = FALSE;
	DLog(@"strWord : %@", strWord);
    DLog(@"strWordOri : %@", strWordOri);
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ where %@ = '%@'", FldName_ToMemorize, TBL_EngDic, FldName_Word, strWord];
	int vlaueOfIntFldInEachBook = [myCommon getIntFldValueFromTbl:strQuery openMyDic:FALSE];

	strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ where %@ = '%@'", FldName_ToMemorize, TBL_EngDic, FldName_Word, strWord];
	int vlaueOfIntFldInTBL_EngDic = [myCommon getIntFldValueFromTbl:strQuery openMyDic:TRUE];

	strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",TBL_EngDic, FldName_ToMemorize, ++vlaueOfIntFldInEachBook , FldName_Word, strWord];
	[myCommon changeRec:strQuery openMyDic:FALSE];
	
	strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'", TBL_EngDic, FldName_ToMemorize, ++vlaueOfIntFldInTBL_EngDic , FldName_Word, strWord];
	[myCommon changeRec:strQuery openMyDic:TRUE];
	
	blnUpdated = TRUE;		
	
	return blnUpdated;
}

//단어의 아는 정도를 초기화 한다.
+ (void) updateDeleteKnow
{	
	NSString	*strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '0'", TBL_EngDic, FldName_Know];
	[myCommon changeRec:strQuery openMyDic:true];
}

//단어의 아는정도를 반환한다.
+ (NSString*) getStrKnowFromIntKnow:(NSInteger)intKnow
{
    NSString *strKnow = @"";
    if (intKnow == 1) {
        strKnow = @"X";
    } else if (intKnow == 2) {
        strKnow = @"?";
    } else if (intKnow == 3) {
        strKnow = @"!";
    } else if (intKnow > 3) {
        strKnow = @"-";
    }
    return strKnow;
}

+ (NSString*) getStrKnowNumberFromStrKnow:(NSString*)strKnow
{
    NSString *strKnowResult = @"";
    if ([strKnow isEqualToString:@""]) {
        strKnowResult = @"0";
    } else if ([strKnow isEqualToString:@"X"]) {
        strKnowResult = @"1";
    } else if ([strKnow isEqualToString:@"?"]) {
        strKnowResult = @"2";
    } else if ([strKnow isEqualToString:@"!"]) {
        strKnowResult = @"3";
    } else if ([strKnow isEqualToString:@"-"]) {
        strKnowResult = @"99";
    } else {
        strKnowResult = @"0";
    }
    
    return strKnowResult;
}

+ (BOOL) blnProperStrKnow:(NSString*)strKnow
{
    BOOL blnResult = FALSE;
    if ([[strKnow uppercaseString] isEqualToString:@"X"]) {
        blnResult = TRUE;
    } else if ([strKnow isEqualToString:@"?"]) {
        blnResult = TRUE;
    } else if ([strKnow isEqualToString:@"!"]) {        
        blnResult = TRUE;
    } else if ([strKnow isEqualToString:@"-"]) {
        blnResult = TRUE;
    }
    return blnResult;
}

//발음의 아는정도를 반환한다.
+ (NSString*) getStrKnowPronounce123FromStrKnowPronounceX:(NSString*)strKnowPronounceX
{
    NSString *strKnowResult = @"0";
    if ([strKnowPronounceX isEqualToString:@"X"]) {
        strKnowResult = @"1";
    } else if ([strKnowPronounceX isEqualToString:@"?"]) {
        strKnowResult = @"2";
    } else if ([strKnowPronounceX isEqualToString:@"!"]) {
        strKnowResult = @"3";
    }
    return strKnowResult;
}
+ (NSString*) getStrKnowPronounceXFromStrKnowPronounce123:(NSString*)strKnowPronounce123
{
    NSString *strKnowResult = @"";
    if ([strKnowPronounce123 isEqualToString:@"1"]) {
        strKnowResult = @"X";
    } else if ([strKnowPronounce123 isEqualToString:@"2"]) {
        strKnowResult = @"?";
    } else if ([strKnowPronounce123 isEqualToString:@"3"]) {
        strKnowResult = @"!";
    }else if ([strKnowPronounce123 isEqualToString:@"99"]) {
        strKnowResult = @"-";
    }
    return strKnowResult;
}

//선택된 단어에서 알파벳과 기호들을 분리해서 순서대로 배열에 담아서 리턴해준다.
+ (NSMutableArray*) getWordsAndPunctuationInSelectedWord:(NSString*)strWord
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSArray *arrSeparatedByPunctuationCharacterSet = [strWord componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];

    NSString *strWordTemp = [NSString stringWithString:strWord];
    NSInteger intOffsetStartOneWordInOneWord = 0;
    NSInteger intOffsetEndOneWordInOneWord = 0;
    NSInteger intOffsetEndOneWordInOneWordSum = 0;
    for (NSString *strOneWordInArrSeparatedByPunctuationCharacterSet in arrSeparatedByPunctuationCharacterSet) {
        if ([strOneWordInArrSeparatedByPunctuationCharacterSet isEqualToString:@""] == FALSE) {
            if ([strOneWordInArrSeparatedByPunctuationCharacterSet isEqualToString:@"\n"] == TRUE) {
                //개행문자는 하지 않는다.
                continue;
            }
            //단어가 있으면...
            NSRange rngOneWordInOneWord = [strWordTemp rangeOfString:strOneWordInArrSeparatedByPunctuationCharacterSet];
//            DLog(@"\n\nstrWordTemp : [%@]", strWordTemp);
//            DLog(@"strOneWordInArrSeparatedByPunctuationCharacterSet : [%@]", strOneWordInArrSeparatedByPunctuationCharacterSet);
//            DLog(@"intOffsetStartOneWordInOneWord : %d", intOffsetStartOneWordInOneWord);
//            DLog(@"intOffsetEndOneWordInOneWord : %d", intOffsetEndOneWordInOneWord);
//            DLog(@"rngOneWordInOneWord : %@", [NSValue valueWithRange:rngOneWordInOneWord]);
            
            if (rngOneWordInOneWord.location > 0) {
                NSString *strWordTemp1 = [strWordTemp substringWithRange:NSMakeRange(0, rngOneWordInOneWord.location)];
//                DLog(@"strWordTEmp : %@", strWordTemp);
//                DLog(@"strWordTemp1 : %@", strWordTemp1);                
                [arrResult addObject:strWordTemp1];
                strWordTemp = [strWordTemp substringWithRange:NSMakeRange(strWordTemp1.length, [strWordTemp length] - strWordTemp1.length)];
            }
            intOffsetStartOneWordInOneWord = rngOneWordInOneWord.location;
            intOffsetEndOneWordInOneWord = intOffsetStartOneWordInOneWord + rngOneWordInOneWord.length;
            intOffsetEndOneWordInOneWordSum += intOffsetEndOneWordInOneWord;
//            DLog(@"intOffsetStartOneWordInOneWord : %d", intOffsetStartOneWordInOneWord);
//            DLog(@"intOffsetEndOneWordInOneWord : %d", intOffsetEndOneWordInOneWord);
//            DLog(@"intOffsetEndOneWordInOneWordSum : %d", intOffsetEndOneWordInOneWordSum);            
//            DLog(@"rngOneWordInOneWord.length : %d", rngOneWordInOneWord.length);
//            DLog(@"strWord.length : %d", strWord.length);

            strWordTemp = [strWordTemp substringWithRange:NSMakeRange(rngOneWordInOneWord.length, [strWordTemp length] - rngOneWordInOneWord.length)];
            [arrResult addObject:strOneWordInArrSeparatedByPunctuationCharacterSet];
            
//            DLog(@"arrResult : %@", arrResult);
        }
    }
    
    if (intOffsetEndOneWordInOneWordSum < [strWord length]) {
//        NSString *strTemp = [strWord substringWithRange:NSMakeRange(intOffsetEndOneWordInOneWord, [strWord length] - intOffsetEndOneWordInOneWord)];
        NSString *strTemp = [strWord substringWithRange:NSMakeRange(intOffsetEndOneWordInOneWordSum, [strWord length] - intOffsetEndOneWordInOneWordSum)];
        [arrResult addObject:strTemp];
    }
    
//    DLog(@"arrResult : %@", arrResult);
    return arrResult;
}
//Text에서 단어가 존재하는 첫번째 문장을 가져온다.
+ (NSMutableDictionary*) findFirstSentenceWithWordInText:(NSString*)strWord Text:(NSString*)strAllContentsInFile
{
    NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWord] options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSMutableDictionary *dicOne = [[NSMutableDictionary alloc] init];
    [dicOne setValue:@"" forKey:@"Sentence"];
    NSTextCheckingResult* firstMatch = [regEx firstMatchInString:strAllContentsInFile options:0 range:NSMakeRange(0, [strAllContentsInFile length])];
    if(firstMatch != nil)
    {
        //The ranges of firstMatch will provide groups, 
        //rangeAtIndex 1 = first grouping
//        DLog(@"found sentence : %@", [strAllContentsInFile substringWithRange:[firstMatch rangeAtIndex:0]]);

        NSRange matchRange = [firstMatch range];
//        DLog(@"matchRange location: %d", matchRange.location);
//        DLog(@"matchRange length: %d", matchRange.length);    
        //        NSInteger pageNo = [myCommon getPageNoWithIndex:matchRange.location];
        
        NSInteger startSentence = matchRange.location - 20;
#ifdef CHINESE
        startSentence = matchRange.location - 10;
#endif
        if (startSentence < 0) {
            startSentence = 0;
        }
        NSInteger lengthSentence = 40;
        if ((startSentence + lengthSentence) > [strAllContentsInFile length]) {
            lengthSentence = [strAllContentsInFile length] - startSentence;
//            DLog(@"lengthSentence : %d", lengthSentence);
        }
        
        NSString *strSentence = [strAllContentsInFile substringWithRange:NSMakeRange(startSentence, lengthSentence)];
//        DLog(@"strWord : %@", strWord);
//        DLog(@"strSentence : %@", strSentence);
        

        
        
        [dicOne setValue:strSentence forKey:@"Sentence"];
        //        [dicOne setValue:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [dicOne setValue:[NSNumber numberWithInt:matchRange.location] forKey:@"WordStartIndex"];   
    }

    
    return dicOne;
}



//minNumber와 maxNumber사이의 난수를 count개를 구한다.(중복되지 않게...)
+ (NSMutableArray*) getRandomNumber:(NSInteger)minNumber MaxNumber:(NSInteger)maxNumber CountOfRandomNumber:(NSInteger)limitOfCount
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];

    //0~[arrWrongAnswers_IOS5 count]까지의 난수생성            
    do {
        NSInteger intRandom = (random() % (maxNumber - minNumber + 1)) + minNumber;
        DLog(@"intRandom : %d", intRandom);

        BOOL hasNoInArrResult = FALSE;
        for (NSInteger i = 0; i < [arrResult count]; i++) {
            NSInteger ranNo = [[arrResult objectAtIndex:i] integerValue];
            if (ranNo == intRandom) {
                hasNoInArrResult = TRUE;
                break;
            }
        }
        
        //새로운 난수이면...
        if (hasNoInArrResult == FALSE) {
            [arrResult addObject:[NSNumber numberWithInt:intRandom]];
        }
        
        if ([arrResult count] >= limitOfCount) {
            break;
        }
    } while (TRUE);    
    
//    if (intRandom < 2) {
//        [arrResult addObject:[NSNumber numberWithInt:0]];
//        [arrResult addObject:[NSNumber numberWithInt:1]];
//        [arrResult addObject:[NSNumber numberWithInt:2]];
//    } else if (intRandom + 2 > maxNumber) {
//        [arrResult addObject:[NSNumber numberWithInt:(maxNumber - 2)]];
//        [arrResult addObject:[NSNumber numberWithInt:(maxNumber - 1)]];
//        [arrResult addObject:[NSNumber numberWithInt:(maxNumber)]];
//    } else {
//        [arrResult addObject:[NSNumber numberWithInt:(intRandom - 1)]];
//        [arrResult addObject:[NSNumber numberWithInt:intRandom]];
//        [arrResult addObject:[NSNumber numberWithInt:(intRandom + 1)]];        
//    }
    
    return arrResult;
}


#pragma mark -
#pragma mark 아는정도를 바꾸는 함수
+ (BOOL) changeKnowWordOri:(NSString*)strWordOri know:(NSInteger)intKnow knowBefore:(NSInteger)intKnowBefore tblName:(NSString*)strTblName bookTblNo:(NSInteger)intBookTblNo openMyDic:(NSInteger)openMyDic
{
//    if (openMyDic == OPEN_DIC_DB) {
//        dbOne = db;
//    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
//        dbOne = dbBook;
//    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
//        dbOne = dbMyDinInBunlde;
//    }
    
    //WordOri는 myDic의 TBL_EngDic에 있는 단어를 대상으로 추출한다.
    NSString *strWordOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWordOri];
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' and %@ = 0", strTblName, FldName_TBL_EngDic_WORDORI, FldName_Know, strWordOriForSQL];
    DLog(@"strQuery : %@", strQuery);
    const char *sqlQuery = [strQuery UTF8String];
    sqlite3_stmt *stmt = nil;    
    int ret = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *strWord = @"";
            char *charWord = (char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD);			
            if (charWord == NULL)
                strWord = @"";
            else
                strWord = [NSString stringWithUTF8String:charWord];
            
            DLog(@"strWord : %@", strWord);
            if ([strWord isEqualToString:@""] == FALSE) {
                [self changeKnow:strWord know:intKnow knowBefore:intKnowBefore tblName:[NSString stringWithFormat:@"%@", strTblName] bookTblNo:intBookTblNo openMyDic:openMyDic];
            }
        }
    } else {
        return FALSE;
    }
    return TRUE;
}

+ (BOOL) changeKnow:(NSString*)strWord know:(NSInteger)intKnow knowBefore:(NSInteger)intKnowBefore tblName:(NSString*)strTblName bookTblNo:(NSInteger)intBookTblNo  openMyDic:(NSInteger)openMyDic
{
    DLog(@"tblName : %@", strTblName);
    NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
    
    if (openMyDic == OPEN_DIC_DB) {
        dbOne = db;
        //현재단어의 아는정도를 업데이트 한다.
        NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_Know, intKnow, FldName_Word, strWordForSQL];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        
        if (intKnowBefore < KnowWord_Exclude) {
            //단어의 아는정도가 Exclude가 아니면 단어의 발음도 같이 바꾸어준다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_KnowPronounce, intKnow, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:TRUE];
        }
//        if (intKnowBefore == KnowWord_NotRated) {
//            //NotRated단어의 아는정도를 바꾸면 발음도 같이 바꾸어준다.
//            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_KnowPronounce, intKnow, FldName_Word, strWordForSQL];
//            [myCommon changeRec:strQuery openMyDic:TRUE];
//        }
        
        //TBL_WordHistory에 아는정도가 바뀐 이력을 추가한다.
        strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@) VALUES('%@', %d, %d);",TBL_WordHistory, FldName_Word, FldName_KnowNew, FldName_KnowOld, strWordForSQL, intKnow, intKnowBefore];
        [myCommon changeRec:strQuery openMyDic:TRUE];
        
    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
        dbOne = dbBook;
        //현재단어의 아는정도를 업데이트 한다.
        NSString *strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_Know, intKnow, FldName_Word, strWordForSQL];
        [myCommon changeRec:strQuery openMyDic:FALSE];
        
        if (intKnowBefore < KnowWord_Exclude) {
            //단어의 아는정도가 Exclude가 아니면 단어의 발음도 같이 바꾸어준다.
            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_KnowPronounce, intKnow, FldName_Word, strWordForSQL];
            [myCommon changeRec:strQuery openMyDic:FALSE];
        }

        
//        if (intKnowBefore == KnowWord_NotRated) {
//            //NotRated단어의 아는정도를 바꾸면 발음도 같이 바꾸어준다.
//            strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = %d WHERE %@ = '%@'",strTblName, FldName_KnowPronounce, intKnow, FldName_Word, strWordForSQL];
//            [myCommon changeRec:strQuery openMyDic:FALSE];
//        }
        
        //TBL_WordHistory에 아는정도가 바뀐 이력을 추가한다.
        strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@) VALUES('%@', %d, %d);",TBL_WordHistory, FldName_Word, FldName_KnowNew, FldName_KnowOld, strWordForSQL, intKnow, intKnowBefore];
        [myCommon changeRec:strQuery openMyDic:FALSE];
    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
        dbOne = dbMyDinInBunlde;
    }
    return TRUE;
}
#pragma mark -
#pragma mark dicByCategory관련
+ (NSMutableArray*) getArrCategory
{
    NSMutableArray *arrUserDic = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ = 1", TBL_dicByCategory, FldName_USE];			
    DLog(@"strQuery : %@", strQuery);
    const char *sqlQuery = [strQuery UTF8String];
    sqlite3_stmt *stmt = nil;    
    int ret = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *strCategoryName = @"";
            char *charCategoryName = (char*)sqlite3_column_text(stmt, FLD_NO_dicByCategory_CategoryName);			
            if (charCategoryName == NULL)
                strCategoryName = @"";
            else
                strCategoryName = [NSString stringWithUTF8String:charCategoryName];
            
            
            if ([strCategoryName isEqualToString:@""] == FALSE) {
                [arrUserDic addObject:strCategoryName];
            }
        }
    }
    
    DLog(@"arrUserDic : %@", arrUserDic);
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return arrUserDic;
    
}

+ (BOOL) createIndexInMyEnglish:(NSString*)strFldName
{
    BOOL blnResult = TRUE;
    //TBL_INDEX_Count 인덱스가 없으면 만든다.
    NSString *strSqlCreatIndex1 = [NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS %@%@", TBL_INDEX_WithoutFldName, strFldName];
    NSString *strSqlCreatIndex2 = [NSString stringWithFormat:@" ON \"%@\" (\"%@\" ASC);", TBL_EngDic, strFldName];
    NSString *strCreateIndex = [NSString stringWithFormat:@"%@ %@", strSqlCreatIndex1, strSqlCreatIndex2];
    DLog(@"strCreateIndex : %@", strCreateIndex);

    const char *sqlCreateIndex = [strCreateIndex UTF8String];
    int retCreate = sqlite3_exec(db, sqlCreateIndex, nil, nil, nil);
    if ( retCreate != SQLITE_OK)
    {
        DLog(@"%@",[NSString stringWithFormat:@"Create Index Error createTable while %@ : '%s'", strCreateIndex, sqlite3_errmsg(db)]);		
        blnResult = FALSE;        
    } 
    DLog(@"strCreateIndex Finish : %@", strCreateIndex);
    return blnResult;
}

//+ (BOOL) createIndexInSQLite:(NSString*)strTblName  fldName:(NSString*)strFldName  openMyDic:(NSInteger)openMyDic
//{
//    if (openMyDic == OPEN_DIC_DB) {
//        dbOne = db;
//    } else if (openMyDic == OPEN_DIC_DB_BOOK) {
//        dbOne = dbBook;
//    } else if (openMyDic == OPEN_DIC_DB_BUNDLE) {
//        dbOne = dbMyDinInBunlde;
//    }
//
//    BOOL blnResult = TRUE;
//    //TBL_INDEX_Count 인덱스가 없으면 만든다.
//    NSString *strSqlCreatIndex1 = [NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS @\"IDX_\"%@\"_%@\"", strTblName, strFldName];
//    NSString *strSqlCreatIndex2 = [NSString stringWithFormat:@" ON \"%@\" (\"%@\" DESC);", strTblName, strFldName];
//    NSString *strCreateIndex = [NSString stringWithFormat:@"%@ %@", strSqlCreatIndex1, strSqlCreatIndex2];
//    DLog(@"strCreateIndex : %@", strCreateIndex);
//    
//    const char *sqlCreateIndex = [strCreateIndex UTF8String];
//    int retCreate = sqlite3_exec(dbOne, sqlCreateIndex, nil, nil, nil);
//    if ( retCreate != SQLITE_OK)
//    {
//        DLog(@"%@",[NSString stringWithFormat:@"Create Index Error createTable while %@ : '%s'", strCreateIndex, sqlite3_errmsg(db)]);		
//        blnResult = FALSE;        
//    } 
//    DLog(@"strCreateIndex Finish : %@", strCreateIndex);
//    return blnResult;
//}

#pragma mark -
#pragma mark Table관련 함수
+ (void) editTable:(UITableView*)tblOne viewController:(UIViewController*)viewController
{
    if ([tblOne isEditing] == TRUE ) {
        [tblOne setEditing:NO animated:YES];	
        viewController.navigationItem.rightBarButtonItem.title = @"Edit";
    } else {
        [tblOne setEditing:YES animated:YES];
        viewController.navigationItem.rightBarButtonItem.title = @"Done";
    }
}


#pragma mark -
#pragma mark iCloud백업관련
//iCloud에 의해서 백업이 되지 않게 바꾼다.
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (float) getIOSVersion
{
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    DLog(@"iOSVersion : %f", iOSVersion);
    return iOSVersion;
}

+ (NSString*) GetFormattedNumber:(NSInteger)intNumber
{
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];	
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setLocale:locale];
    
    NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", intNumber]];
    NSString *strCount = [currencyFormatter stringFromNumber:someAmount];	
    return strCount;
}



#pragma mark -
#pragma mark Twitters
+ (void) PostTwitter:(NSString*)strMessage image:(UIImage*)imgOne strURL:(NSString*)strURL sender:(id)sender
{
    Class iOSTwitter = NSClassFromString(@"TWTweetComposeViewController");
    if (iOSTwitter != nil) {        
        if ([iOSTwitter canSendTweet]) {
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            
            
            if (imgOne != NULL) {
                [twitter addImage:imgOne];
            }
            DLog(@"strMessage : %@", strMessage);
            [twitter setInitialText:strMessage];
            if (strURL != NULL) {
                NSString *webUrl = [[NSString alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [twitter addURL:[NSURL URLWithString:webUrl]];
            }

            
            [sender presentModalViewController:twitter animated:YES];
            //            
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result)
            {
                if (result == TWTweetComposeViewControllerResultCancelled) {
                    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"")	message:NSLocalizedString(@"Cancel", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert2 show];
                }
                [sender dismissModalViewControllerAnimated:YES];
            };
        }
        
    }
}


#pragma mark -
#pragma mark 단어로 부터 문장 가져오기
+ (NSString*) getSentenceWithWord:(NSString*)strWord  strFullContents:(NSString*)strFullContents //:(NSTimer*)sender
{
    //    NSString *strSearchWordTemp = [myCommon getCleanAndLowercase:searchBarSearchWord.text];
    
    if ( (strFullContents == NULL) || ([strFullContents isEqualToString:@""]) ) {
        return @"";
    }
//    DLog(@"strWord : %@", strWord);
//    DLog(@"strFullContents : %@", strFullContents);
    NSRegularExpressionOptions nsOpt = NSRegularExpressionCaseInsensitive;
    
    NSRegularExpression *regEx= [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWord] options:nsOpt error:nil];
    
#ifdef CHINESE
    NSString *regStrExceptChinese = @"[^\u4e00-\u4eff\u4f00-\u4fff\u5000-\u50ff\u5100-\u51ff\u5200-\u52ff\u5300-\u53ff\u5400-\u54ff\u5500-\u55ff\u5600-\u56ff\u5700-\u57ff\u5800-\u58ff\u5900-\u59ff\u5a00-\u5aff\u5b00-\u5bff\u5c00-\u5cff\u5d00-\u5dff\u5e00-\u5eff\u5f00-\u5fff\u6000-\u60ff\u6100-\u61ff\u6200-\u62ff\u6300-\u63ff\u6400-\u64ff\u6500-\u65ff\u6600-\u66ff\u6700-\u67ff\u6800-\u68ff\u6900-\u69ff\u6a00-\u6aff\u6b00-\u6bff\u6c00-\u6cff\u6d00-\u6dff\u6e00-\u6eff\u6f00-\u6fff\u7000-\u70ff\u7100-\u71ff\u7200-\u72ff\u7300-\u73ff\u7400-\u74ff\u7500-\u75ff\u7600-\u76ff\u7700-\u77ff\u7800-\u78ff\u7900-\u79ff\u7a00-\u7aff\u7b00-\u7bff\u7c00-\u7cff\u7d00-\u7dff\u7e00-\u7eff\u7f00-\u7fff\u8000-\u80ff\u8100-\u81ff\u8200-\u82ff\u8300-\u83ff\u8400-\u84ff\u8500-\u85ff\u8600-\u86ff\u8700-\u87ff\u8800-\u88ff\u8900-\u89ff\u8a00-\u8aff\u8b00-\u8bff\u8c00-\u8cff\u8d00-\u8dff\u8e00-\u8eff\u8f00-\u8fff\u9000-\u90ff\u9100-\u91ff\u9200-\u92ff\u9300-\u93ff\u9400-\u94ff\u9500-\u95ff\u9600-\u96ff\u9700-\u97ff\u9800-\u98ff\u9900-\u99ff\u9a00-\u9aff\u9b00-\u9bff\u9c00-\u9cff\u9d00-\u9dff\u9e00-\u9eff\u9f00-\u9fff]";
    
    
    //정규표현식으로 중국어의 경우에는 한자를 제외하고 다 지운다.
    NSError *err = nil;
    regEx = [NSRegularExpression regularExpressionWithPattern:regStrExceptChinese options:nsOpt error:nil];
    
    regEx = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@", strWord] options:nsOpt error:nil];
    
#endif
    
    
    NSArray *matches = [regEx matchesInString:strFullContents
                                      options:0
                                        range:NSMakeRange(0, [strFullContents length])];
    if ([matches count] == 0) {
        return @"";
    }
    
    NSInteger intRandom = 0;
    NSTextCheckingResult *matchOne = [matches objectAtIndex:intRandom];
    NSRange matchRange = [matchOne range];
    DLog(@"matchRange : %@", [NSValue valueWithRange:matchRange]);
    
    NSInteger startSentence = matchRange.location;
    NSInteger intMaxCharCountToSearch = 60;
#ifdef CHINESE
//    startSentence = matchRange.location;
    intMaxCharCountToSearch = 15;
//    DLog(@"matchRange.location : %d", matchRange.location);
//    DLog(@"startSentence : %d", startSentence);
#endif
    NSInteger intCount = 0;
    while (startSentence--) {
//        DLog(@"startSentence : %d", startSentence);
        if (startSentence < 0) {
            startSentence = 0;
            break;
        }
        if (intCount > intMaxCharCountToSearch) {
            break;
        }
        intCount++;
        NSString *strChar = [strFullContents substringWithRange:NSMakeRange(startSentence, 1)];
//        DLog(@"strChar : %@", strChar);
        if ( ([strChar isEqualToString:@" "]) || ([strChar isEqualToString:@"\r"]) || ([strChar isEqualToString:@"\n"]) || ([strChar isEqualToString:@"\r\n"]) || ([strChar isEqualToString:@""""])  || ([strChar isEqualToString:@","]) || ([strChar isEqualToString:@"?"])  || ([strChar isEqualToString:@"。"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])  || ([strChar isEqualToString:@"\r"])   ) {
            break;
        }
        
    }
    NSInteger lengthSentence = 120;
#ifdef CHINESE
    lengthSentence = intCount +  intMaxCharCountToSearch;
#endif
    
    if ((startSentence + lengthSentence) > [strFullContents length]) {
        lengthSentence = [strFullContents length] - startSentence;
//        DLog(@"lengthSentence : %d", lengthSentence);
    }
    
    NSString *strSentence = [strFullContents substringWithRange:NSMakeRange(startSentence, lengthSentence)];
//    DLog(@"strSentence : %@", strSentence);
    return strSentence;
}

+ (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText WordBlank:(NSString*)strWordBlank
{
    //    DLog(@"time : %@",[myCommon getCurrentDatAndTimeForBackup]);
	NSString *header;
    //	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath]];
    
	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css?time=%@\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], [myCommon getCurrentDatAndTimeForBackup]];
    //	header = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<link rel=\"stylesheet\" href=\"%@/style.css?version=%d\" type=\"text/css\" />\n<title></title>\n</head>\n\n<body>\n<p>\n", [myCommon getDocPath], intCSSVersion];
    
    //    DLog(@"originalText : %@", originalText);
    
    //    [htmlString stringByReplacingOccurrencesOfString:@"style.css" withString:[NSString stringWithFormat:@"style.css?time=%@", [[NSDate date] description]]
    
    
	//header = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n<html>\n\n<head>\n<style type=\"text/css\">body {font-size:12pt;font-weight:normal} font.GREEN { display:inline; background:red;font-size : 12pt; font-weight : normal; color : green;vertical-align:sup }	font.BLUE {display:inline; background:yellow ;font-size : 12pt;font-weight : normal;color : blue; vertical-align:sup} font.RED { font-size : 12pt; font-weight : normal; color : red; vertical-align:sup}  </style>\n<title></title>\n</head>\n\n<body>\n<p>\n";
	
	NSRange fullRange = NSMakeRange(0, [originalText length]);
    //    DLog(@"[originalText ] : %@", originalText);
    //	DLog(@"fullRange : %@", fullRange);
    
	unsigned int i,j;
	j=0;
    
    i = [originalText replaceOccurrencesOfString:@"&" withString:@"&amp;"
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d &s\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    i = [originalText replaceOccurrencesOfString:@"<" withString:@"&lt;"
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d <s\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    i = [originalText replaceOccurrencesOfString:@">" withString:@"&gt;"
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d >s\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    i = [originalText replaceOccurrencesOfString:@"\r\n\r\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    
    // Argh, bloody MS line breaks!  Change them to UNIX, then...
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d carriage return/newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    //Change newlines to </p><p>.
    i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    //Change double-newlines to </p><p>.
    i = [originalText replaceOccurrencesOfString:@"\n" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-newlines\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    // And just in case someone has a Classic MacOS textfile...
    i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-carriage-returns\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    // Lots of text files start new paragraphs with newline-space-space or newline-tab
    i = [originalText replaceOccurrencesOfString:@"\n  " withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-spaces\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    //DLog(@"replaced %d double-spaces\n", i);
    j += i;
    fullRange = NSMakeRange(0, [originalText length]);
    
    //\r일경우...
    i = [originalText replaceOccurrencesOfString:@"\r" withString:@" "
                                         options:NSLiteralSearch range:fullRange];
    
    //    i = [originalText replaceOccurrencesOfString:@"\r\n\r\n" withString:@"<br>"
    //                                         options:NSLiteralSearch range:fullRange];
    //
    //    // Argh, bloody MS line breaks!  Change them to UNIX, then...
    //    i = [originalText replaceOccurrencesOfString:@"\r\n" withString:@"<br>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d carriage return/newlines\n", i);
    //    j += i;
    //    fullRange = NSMakeRange(0, [originalText length]);
    //
    //    //Change newlines to </p><p>.
    //    i = [originalText replaceOccurrencesOfString:@"\n\n" withString:@"</p>\n<p>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d double-newlines\n", i);
    //    j += i;
    //    fullRange = NSMakeRange(0, [originalText length]);
    //
    //    //Change double-newlines to </p><p>.
    //    i = [originalText replaceOccurrencesOfString:@"\n" withString:@"</p>\n<p>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d double-newlines\n", i);
    //    j += i;
    //    fullRange = NSMakeRange(0, [originalText length]);
    //
    //    // And just in case someone has a Classic MacOS textfile...
    //    i = [originalText replaceOccurrencesOfString:@"\r\r" withString:@"</p>\n<p>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d double-carriage-returns\n", i);
    //    j += i;
    //
    //    // Lots of text files start new paragraphs with newline-space-space or newline-tab
    //    i = [originalText replaceOccurrencesOfString:@"\n  " withString:@"</p>\n<p>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d double-spaces\n", i);
    //    j += i;
    //    fullRange = NSMakeRange(0, [originalText length]);
    //
    //    i = [originalText replaceOccurrencesOfString:@"\n\t" withString:@"</p>\n<p>"
    //                                         options:NSLiteralSearch range:fullRange];
    //    //DLog(@"replaced %d double-spaces\n", i);
    //    j += i;
    //    fullRange = NSMakeRange(0, [originalText length]);
    //
    //    //\r일경우...
    //    i = [originalText replaceOccurrencesOfString:@"\r" withString:@"<br>"
    //                                         options:NSLiteralSearch range:fullRange];
    j += i;
    
    if ([strWordBlank isEqualToString:@""] == FALSE) {
        NSString *strValueToChange1 = [NSString stringWithFormat:@"<span style=\"BORDER-BOTTOM:black 2px solid;BORDER-TOP:black 2px solid;BORDER-RIGHT:black 2px solid;BORDER-LEFT:black 2px solid\"> <span style=\"opacity:.0; color:blue\">"];
        NSString *strValueToChange2 = [NSString stringWithFormat:@"</span></span>"];
        
        NSError *err;
        NSRegularExpression *regEx2 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([^a-z]|^)(%@)([^a-z]|$)", strWordBlank] options:NSRegularExpressionCaseInsensitive error:&err];
        
        [regEx2 replaceMatchesInString:originalText options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [originalText length]) withTemplate:[NSString stringWithFormat:@"$1%@$2%@$3", strValueToChange1, strValueToChange2]];
    } else {
        originalText = [NSMutableString stringWithFormat:@"<div style='text-align:center'>%@</div>", originalText];
    }
    NSMutableString *outputHTMLImsi = [NSMutableString stringWithFormat:@"%@%@\n</body>\n</html>\n", header, originalText];
    //    NSRange fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
    //	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br><br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
    //    fullRangeHTML = NSMakeRange(0, [outputHTMLImsi length]);
    //	i = [outputHTMLImsi replaceOccurrencesOfString:@"<br>\n</body>" withString:@"</body>" options:NSLiteralSearch range:fullRangeHTML];
    
    NSString *outputHTML = [NSString stringWithFormat:@"%@", outputHTMLImsi];
    
    
    DLog(@"outputHTML : %@", outputHTML);
	return outputHTML;  
}


+ (BOOL) getWordAndWordoriInSelected:(NSString*)strWordsInSelected dicWordWithOri:(NSMutableDictionary*)dicWordWithOri
{
    BOOL blnHasWordInDic = FALSE;
    
    strWordsInSelected = [strWordsInSelected stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *arrWordsInSelected = [[strWordsInSelected lowercaseString] componentsSeparatedByString:@" "];
    [dicWordWithOri removeAllObjects];
    
    if ([arrWordsInSelected count] > 1) {
        //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
        
        NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
        NSString *strOneWord = [arrWordsInSelected objectAtIndex:0];
        NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
        NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
        NSString *strOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneOri];
        
        
        
        NSString *strNextOne = [arrWordsInSelected objectAtIndex:1];
        NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
        NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
        
        
        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@ %@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, strNextOneOriForSQL, FldName_WordLength];
        
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
        
        NSMutableString *strOverOneWord = [NSMutableString stringWithString:strOneForSQL];
        NSMutableString *strOverOneWordInText = [NSMutableString stringWithString:@""];
        
        
        
        if ([arrAllOne count] > 0) {
            //숙어나 문장의 경우... (두단어 이상으로 이루어진다.)
            
            //아래는 숙어등이 많을때(100개)를 생각해서 3번째 단어로도 숙어등을 확ㅣㅇ해본다.
            if ( ([arrAllOne count] > 100) && ([arrWordsInSelected count] > 2 ) ){
                
                NSString *strNextOne2 = [arrWordsInSelected objectAtIndex:2];
                
                NSString *strNextOne2Trimmed = [strNextOne2 stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                
                //                NSString *strNextOne2ForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne2Trimmed];
                NSString *strNextOne2Ori = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne2Trimmed];
                NSString *strNextOne2OriTrimmed = [strNextOne2Ori stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                NSString *strNextOne2OriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne2OriTrimmed];
                
                strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@,%@,%@,%%' COLLATE NOCASE ORDER BY %@ ASC", TBL_EngDic, FldName_WORDORI, strOneOriForSQL, strNextOneOriForSQL, strNextOne2OriForSQL, FldName_WordLength];
                NSMutableArray *arrAllOne2 = [[NSMutableArray alloc] init];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne2 byDic:nil openMyDic:OPEN_DIC_DB];
                
                if ([arrAllOne2 count] > 0) {
                    DLog(@"arrAllOne : %@", arrAllOne);
                    DLog(@"arrAllOne2 : %@", arrAllOne2);
                    [arrAllOne setArray:arrAllOne2];
                    DLog(@"arrAllOne : %@", arrAllOne);
                    
                }
            }
            
            NSMutableString *strOverOneWordOriWhenHasIdiom = [NSMutableString stringWithString:@""];
            NSMutableString *strOverOneWordInTextWhenHasIdiom = [NSMutableString stringWithString:strOneWord];
            
            NSMutableString *strOverOneWordOri = [NSMutableString stringWithString:@""];
            NSInteger indexWordLength = 1;
            
            DLog(@"arrAllOne : %@", arrAllOne);
            
            //arrWordsInSelected의 원형을 가져온다.
            NSMutableString *strOverOneWordOriInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@,", strOneOri]];
            [strOverOneWordOriInForState appendFormat:@"%@,", strNextOneOri];
            for (int j = 2; j < [arrWordsInSelected count]; ++j) {
                // 문장내의 다음단어까지 다시 한번 읽는다.
                //                            DLog(@"i : %d", i);
                DLog(@"indexWordLength : %d", indexWordLength);
                NSString *strNextOne = [arrWordsInSelected objectAtIndex:j];
                strNextOne = [strNextOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
                [strOverOneWordOriInForState appendFormat:@"%@,",strNextOneOri];
            }
            
            
            for (NSDictionary *dicOne in arrAllOne) {
                DLog(@"dicOne : %@", dicOne);
                

                NSMutableString *strOverOneWordInTextInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", strOneWord]];
                [strOverOneWordOri setString:[NSString stringWithFormat:@"%@,", strOneOriForSQL]];
                [strOverOneWordInText setString:strOneWord];
                
                NSString *strWordOriInDicOne = [dicOne objectForKey:KEY_DIC_WORDORI];
                DLog(@"strWordOriInDicOne : %@", strWordOriInDicOne);
                NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
                DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                if ((intWordLengthInDicOne) > [arrWordsInSelected count] ) {
                    break;
                }

                if ([strWordOriInDicOne isEqualToString:strOverOneWordOriInForState] == TRUE) {
                    blnHasWordInDic = TRUE;
                    DLog(@"dicOne : %@", dicOne);
                    strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
                    [strOverOneWordOri setString:[NSString stringWithFormat:@"%@", strOverOneWordOriInForState]];
                    [strOverOneWordOriWhenHasIdiom setString:strOverOneWordOriInForState];
                    [strOverOneWordInText setString:[NSString stringWithFormat:@"%@", strOverOneWordInTextInForState]];
                    [strOverOneWordInTextWhenHasIdiom setString:strOverOneWordInTextInForState];
                }
            }
            
            DLog(@"strOverOneWordInText After: %@", strOverOneWordInText);
            DLog(@"strOverOneWordOri After: %@", strOverOneWordOri);
            DLog(@"strOverOneWordOriInForState After: %@", strOverOneWordOriInForState);            
            DLog(@"strOverOneWord After: %@", strOverOneWord);
            
            if (blnHasWordInDic == TRUE) {
                //숙어가 존재하면..
                
                [dicWordWithOri setValue:strOverOneWordOri forKey:KEY_DIC_StrOverOneWordOri];
                [dicWordWithOri setValue:strOverOneWordInText forKey:KEY_DIC_StrOverOneWordInText];
                [dicWordWithOri setValue:strOverOneWord forKey:KEY_DIC_StrOverOneWord];
            } else {
                //숙어가 없으면... 그냥 원형을 찾아서 리턴해준다.
                blnHasWordInDic = FALSE;
                NSMutableString *strWordOri = [[NSMutableString alloc] init];
                for (NSString *strOne in arrWordsInSelected) {
                    //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
                    NSString *strOneTrimmed = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                    DLog(@"strOneTrimmed : %@", strOneTrimmed);
                    [strWordOri appendFormat:@"%@,", [myCommon GetOriWordOnlyIfExistInTbl:strOneTrimmed]];
                }
                [dicWordWithOri setValue:strWordOri forKey:KEY_DIC_StrOverOneWordOri];
                [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWordInText];
                [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWord];
                
            }
            
        } else {
            //사전에 숙어나 문장이 없으면... 그냥 원형을 찾아서 리턴해준다.
            blnHasWordInDic = FALSE;
            NSMutableString *strWordOri = [[NSMutableString alloc] init];
            for (NSString *strOne in arrWordsInSelected) {
                //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
                NSString *strOneTrimmed = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                DLog(@"strOneTrimmed : %@", strOneTrimmed);
                [strWordOri appendFormat:@"%@,", [myCommon GetOriWordOnlyIfExistInTbl:strOneTrimmed]];
            }
            [dicWordWithOri setValue:strWordOri forKey:KEY_DIC_StrOverOneWordOri];
            [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWordInText];
            [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWord];
        }
    } else {
        //한개의 단어이면...
        blnHasWordInDic =  [self chkWordExist:strWordsInSelected intDicWordOrIdiom:DicWordOrIdiom_Word openMyDic:OPEN_DIC_DB];
        
        NSString *strWord = strWordsInSelected;
        NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strWord];
        
        [dicWordWithOri setValue:strOneOri forKey:KEY_DIC_StrOverOneWordOri];
        [dicWordWithOri setValue:strWord forKey:KEY_DIC_StrOverOneWordInText];
        [dicWordWithOri setValue:strWord forKey:KEY_DIC_StrOverOneWord];
    }
    DLog(@"dicWordWithOri : %@", dicWordWithOri);
    return blnHasWordInDic;
}

//+ (BOOL) getWordAndWordoriInSelected:(NSString*)strWordsInSelected dicWordWithOri:(NSMutableDictionary*)dicWordWithOri
//{
//    BOOL blnHasWordInDic = FALSE;
//    
//    strWordsInSelected = [strWordsInSelected stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSArray *arrWordsInSelected = [[strWordsInSelected lowercaseString] componentsSeparatedByString:@" "];
//    [dicWordWithOri removeAllObjects];
//    
//    if ([arrWordsInSelected count] > 1) {
//        //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
//        
//        NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
//        NSString *strOneWord = [arrWordsInSelected objectAtIndex:0];
//        NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
//        NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
//        NSString *strOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneOri];
//        
//        
//
//        NSString *strNextOne = [arrWordsInSelected objectAtIndex:1];
//        NSString *strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
//        NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
//        NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
//        
//
//        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@ %@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, strNextOneOriForSQL, FldName_WordLength];
//
//        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//        
//        NSMutableString *strOverOneWord = [NSMutableString stringWithString:strOneForSQL];
//        NSMutableString *strOverOneWordInText = [NSMutableString stringWithString:@""];
//        
//        
//        
//        if ([arrAllOne count] > 0) {
//            //숙어나 문장의 경우... (두단어 이상으로 이루어진다.)
//            
//            //아래는 숙어등이 많을때(20개)를 생각해서 3번째 단어로도 숙어등을 확ㅣㅇ해본다.
//            if ( ([arrAllOne count] > 20) && ([arrWordsInSelected count] > 2 ) ){
//                
//                NSString *strNextOne2 = [arrWordsInSelected objectAtIndex:2];
//                
//                NSString *strNextOne2Trimmed = [strNextOne2 stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                
////                NSString *strNextOne2ForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne2Trimmed];
//                NSString *strNextOne2Ori = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne2Trimmed];
//                NSString *strNextOne2OriTrimmed = [strNextOne2Ori stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                NSString *strNextOne2OriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne2OriTrimmed];
//                
//                strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@,%@,%@,%%' COLLATE NOCASE ORDER BY %@ ASC", TBL_EngDic, FldName_WORDORI, strOneOriForSQL, strNextOneOriForSQL, strNextOne2OriForSQL, FldName_WordLength];
//                NSMutableArray *arrAllOne2 = [[NSMutableArray alloc] init];
//                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne2 byDic:nil openMyDic:OPEN_DIC_DB];
//                
//                if ([arrAllOne2 count] > 0) {
//                    DLog(@"arrAllOne : %@", arrAllOne);
//                    DLog(@"arrAllOne2 : %@", arrAllOne2);
//                    [arrAllOne setArray:arrAllOne2];
//                    DLog(@"arrAllOne : %@", arrAllOne);
//                    
//                }
//            }
//            
//            NSMutableString *strOverOneWordOriWhenHasIdiom = [NSMutableString stringWithString:@""];
//            NSMutableString *strOverOneWordInTextWhenHasIdiom = [NSMutableString stringWithString:strOneWord];
//            
//            NSMutableString *strOverOneWordOri = [NSMutableString stringWithString:@""];
//            NSInteger indexWordLength = 1;
//            
//            DLog(@"arrAllOne : %@", arrAllOne);
//            for (NSDictionary *dicOne in arrAllOne) {
//                DLog(@"dicOne : %@", dicOne);
//                
//                NSMutableString *strOverOneWordOriInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@,", strOneOriForSQL]];
//                NSMutableString *strOverOneWordInTextInForState = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", strOneWord]];
//                [strOverOneWordOri setString:[NSString stringWithFormat:@"%@,", strOneOriForSQL]];
//                [strOverOneWordInText setString:strOneWord];
//                
//                NSString *strWordOriInDicOne = [dicOne objectForKey:KEY_DIC_WORDORI];
//                DLog(@"strWordOriInDicOne : %@", strWordOriInDicOne);
//                NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
//                DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
//                if ((intWordLengthInDicOne) > [arrWordsInSelected count] ) {
//                    break;
//                }
//                
////                if (indexWordLength != intWordLengthInDicOne) {
////                    for (int j = 1; j < intWordLengthInDicOne; ++j) {
//                    for (int j = 1; j < [arrWordsInSelected count]; ++j) {                    
//                        // 문장내의 다음단어까지 다시 한번 읽는다.
//                        //                            DLog(@"i : %d", i);
//                        DLog(@"indexWordLength : %d", indexWordLength);
//                        //                            DLog(@"indexWordLength + i : %d", indexWordLength + i);
//                        //                            DLog(@"[arrMutableTemp11 count] : %d", [arrMutableTemp11 count]);
//                        
////                        NSMutableArray *arrAlphabetAndPunctuationInOneWordNext_1 = [myCommon getWordsAndPunctuationInSelectedWord:[arrWordsInSelected objectAtIndex:j]];
////                        if ([arrAlphabetAndPunctuationInOneWordNext_1 count] == 0) {
////                            break;
////                        }
////                        strNextOne = [arrAlphabetAndPunctuationInOneWordNext_1 objectAtIndex:0];
//
//                        NSString *strNextOne = [arrWordsInSelected objectAtIndex:j];
//                        strNextOne = [strNextOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                        NSString *strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
//                        NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
//                        NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
//                        
//                        DLog(@"strNextOne : %@", strNextOne);
////                        [strOverOneWordOri appendFormat:@"%@,",strNextOneOriForSQL];
////                        [strOverOneWordInText appendFormat:@" %@",strNextOneForSQL];
//                        [strOverOneWordOriInForState appendFormat:@"%@,",strNextOneOri];
//                        [strOverOneWordInTextInForState appendFormat:@" %@",strNextOne];
//                        
//                        DLog(@"strOverOneWordInText After: %@", strOverOneWordInText);
//                        DLog(@"strOverOneWordOri After: %@", strOverOneWordOri);
//                        DLog(@"strWordOriInDicOne After: %@", strWordOriInDicOne);
////                        if ( (j ==[arrWordsInSelected count]) && ([strWordOriInDicOne isEqualToString:strOverOneWordOriInForState] == TRUE) ) {
//                        if ([strWordOriInDicOne isEqualToString:strOverOneWordOriInForState] == TRUE) {
//                            blnHasWordInDic = TRUE;
//                            DLog(@"dicOne : %@", dicOne);
//                            strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
//                            [strOverOneWordOri setString:[NSString stringWithFormat:@"%@", strOverOneWordOriInForState]];
//                            [strOverOneWordOriWhenHasIdiom setString:strOverOneWordOriInForState];
//                            [strOverOneWordInText setString:[NSString stringWithFormat:@"%@", strOverOneWordInTextInForState]];
//                            [strOverOneWordInTextWhenHasIdiom setString:strOverOneWordInTextInForState];
//                        }
//                    }
////                    indexWordLength = intWordLengthInDicOne;
////                }
////                if ([strWordOriInDicOne isEqualToString:strOverOneWordOri] == TRUE) {
////                    blnHasWordInDic = TRUE;
////                    DLog(@"dicOne : %@", dicOne);
////                    strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
////                }
//            }
//
//            DLog(@"strOverOneWordInText After: %@", strOverOneWordInText);
//            DLog(@"strOverOneWordOri After: %@", strOverOneWordOri);
//            DLog(@"strOverOneWord After: %@", strOverOneWord);
//            
//            NSArray *arrBlankInstrOverOneWordInText = [[strOverOneWordInTextWhenHasIdiom lowercaseString] componentsSeparatedByString:@" "];
//            NSArray *arrBlankInstrOverOneWord = [[strOverOneWord lowercaseString] componentsSeparatedByString:@" "];
//            
//            if  ( (blnHasWordInDic == TRUE) && ([arrBlankInstrOverOneWord count] == [arrBlankInstrOverOneWordInText count]) ) {
//                //숙어가 존재하면...
//                strOneWord = strOverOneWordInTextWhenHasIdiom;// strOverOneWordInText;
//                [strOverOneWordOri setString:strOverOneWordOriWhenHasIdiom];
//                
////                strOneWord = strOverOneWordInText;
//                [dicWordWithOri setValue:strOverOneWordOri forKey:KEY_DIC_StrOverOneWordOri];
//                [dicWordWithOri setValue:strOverOneWordInText forKey:KEY_DIC_StrOverOneWordInText];
//                [dicWordWithOri setValue:strOverOneWord forKey:KEY_DIC_StrOverOneWord];
//            } else {
//                //숙어가 없으면... 그냥 원형을 찾아서 리턴해준다.
//                blnHasWordInDic = FALSE;
//                NSMutableString *strWordOri = [[NSMutableString alloc] init];
//                for (NSString *strOne in arrWordsInSelected) {
//                    //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
//                    NSArray *arrSeparatedByPunctuationCharacterSet = [strOne componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                    NSString *strOneTrimmed = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                    DLog(@"strOneTrimmed : %@", strOneTrimmed);
//                    [strWordOri appendFormat:@"%@,", [myCommon GetOriWordOnlyIfExistInTbl:strOneTrimmed]];
//                }
//                [dicWordWithOri setValue:strWordOri forKey:KEY_DIC_StrOverOneWordOri];
//                [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWordInText];
//                [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWord];
//                
//            }
//            
//        } else {
//            //사전에 숙어나 문장이 없으면... 그냥 원형을 찾아서 리턴해준다.
//            blnHasWordInDic = FALSE;
//            NSMutableString *strWordOri = [[NSMutableString alloc] init];
//            for (NSString *strOne in arrWordsInSelected) {
//                //선택한 단어가 하나의 단어가 아니면(공백이 있으면 숙어등으로 간주한다.)
//                NSArray *arrSeparatedByPunctuationCharacterSet = [strOne componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                NSString *strOneTrimmed = [strOne stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
//                DLog(@"strOneTrimmed : %@", strOneTrimmed);
//                [strWordOri appendFormat:@"%@,", [myCommon GetOriWordOnlyIfExistInTbl:strOneTrimmed]];
//            }
//            [dicWordWithOri setValue:strWordOri forKey:KEY_DIC_StrOverOneWordOri];
//            [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWordInText];
//            [dicWordWithOri setValue:strWordsInSelected forKey:KEY_DIC_StrOverOneWord];
//        }
//    } else {
//        //한개의 단어이면...
//        blnHasWordInDic =  [self chkWordExist:strWordsInSelected intDicWordOrIdiom:DicWordOrIdiom_Word openMyDic:OPEN_DIC_DB];
//
//        NSString *strWord = strWordsInSelected;
//        NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strWord];
//        
//        [dicWordWithOri setValue:strOneOri forKey:KEY_DIC_StrOverOneWordOri];
//        [dicWordWithOri setValue:strWord forKey:KEY_DIC_StrOverOneWordInText];
//        [dicWordWithOri setValue:strWord forKey:KEY_DIC_StrOverOneWord];
//    }
//    DLog(@"dicWordWithOri : %@", dicWordWithOri);
//    return blnHasWordInDic;
//}


//이디엄을 ENG_DIC로 복사하는 기능... 개발중에만 사용하는 함수이다. (이전 사용자는 In-App Purchase를 활용하게 할까?)
+ (void) copyIdiomTemp
{
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@", TBL_Idiom];
    const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
    
	DLog(@"strQuery GetCountFromTbl : %@", strQuery);
    
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString	*strIdiom = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_TBL_Idiom_Idiom)];
            strIdiom = [strIdiom stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (strIdiom == NULL) {
                continue;
            }
            
            
            NSArray *arrOne = [strIdiom componentsSeparatedByString:@" "];
            if ([arrOne count] > 1) {
                NSInteger intWordsCount = [arrOne count];
                NSMutableString *strIdiomOri = [[NSMutableString alloc] init];
                DLog(@"strIdiom : '%@'", strIdiom);
                for (NSInteger i = 0; i < intWordsCount; ++i) {
                    NSString *strOneWord = [arrOne objectAtIndex:i];
//                    NSString *strOneWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
                    NSString *strOneWordOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
                    [strIdiomOri appendFormat:@"%@,", strOneWordOri];
                }
                DLog(@"strIdiomOri : '%@'", strIdiomOri);
                NSString *strFirstWord = [arrOne objectAtIndex:0];
                NSString *strFirstWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstWord];
                
                NSString *strSecondWord = [arrOne objectAtIndex:1];
                NSString *strSecondWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strSecondWord];

                
                NSString *strIdiomOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strIdiomOri];
                NSString *strIdiomForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strIdiom];
                
                strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@) VALUES('%@', '%@', '%@ %@', %d, %d)", TBL_EngDic, FldName_Word, FldName_WORDORI, FldName_FirstWord, FldName_WordLength, FldName_InstalledWord, strIdiomForSQL, strIdiomOriForSQL, strFirstWordForSQL, strSecondWordForSQL, intWordsCount, 1];
                [myCommon changeRec:strQuery openMyDic:TRUE];
                
            }
		}
	}
    
    
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
}

//ENG_DIC에 있는 이디엄에 대해서 Reserv1_CHAR에 있는 단어를 원형으로만(처음 2글자만) 구성하게 해주는 함수이다.
+ (void) copyIdiomTemp2
{
	NSString	*strQuery = [NSString	stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%% %%'", TBL_EngDic, FldName_Word];
    const char *sqlQuery = [strQuery UTF8String];
	sqlite3_stmt *stmt = nil;
    
	DLog(@"strQuery GetCountFromTbl : %@", strQuery);
    
	
	int rett = sqlite3_prepare_v2(db, sqlQuery, -1, &stmt, NULL);
	if (rett == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString	*strIdiom = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORD)];
        
            DLog(@"strIdiom : %@", strIdiom);
            
            NSArray *arrOne = [strIdiom componentsSeparatedByString:@" "];
            if ([arrOne count] > 1) {
                NSInteger intWordsCount = [arrOne count];
                NSMutableString *strIdiomOri = [[NSMutableString alloc] init];
                DLog(@"strIdiom : '%@'", strIdiom);
                for (NSInteger i = 0; i < intWordsCount; ++i) {
                    NSString *strOneWord = [arrOne objectAtIndex:i];
                    //                    NSString *strOneWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
                    NSString *strOneWordOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
                    [strIdiomOri appendFormat:@"%@,", strOneWordOri];
                }
                DLog(@"strIdiomOri : '%@'", strIdiomOri);
                NSString *strFirstWord = [arrOne objectAtIndex:0];
                NSString *strFirstWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstWord];
                
                NSString *strSecondWord = [arrOne objectAtIndex:1];
                NSString *strSecondWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strSecondWord];
                
                
                NSString *strIdiomOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strIdiomOri];
                NSString *strIdiomForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strIdiom];
                
                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@ %@', %@ = '%@', %@ = %d WHERE %@ = '%@'",TBL_EngDic, FldName_FirstWord, strFirstWordForSQL, strSecondWordForSQL, FldName_WORDORI, strIdiomOriForSQL, FldName_WordLength, intWordsCount, FldName_Word, strIdiomForSQL];
                
//                strQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %@ (%@, %@, %@, %@, %@) VALUES('%@', '%@', '%@ %@', %d, %d)", TBL_EngDic, FldName_Word, FldName_WORDORI, FldName_FirstWord, FldName_WordLength, FldName_InstalledWord, strIdiomForSQL, strIdiomOriForSQL, strFirstWordForSQL, strSecondWordForSQL, intWordsCount, 1];
                [myCommon changeRec:strQuery openMyDic:TRUE];
                
            }
            
            
            
            
            
//            NSString	*strIdiomFirstTwoChar = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_RESERV1_CHAR)];
//        
//            if ((strIdiomFirstTwoChar == NULL) || ([strIdiomFirstTwoChar isEqualToString:@""])) {
//                continue;
//            }
//        
//            
//            NSString	*strIdiomOri = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, FLD_NO_ENG_DIC_WORDORI)];
//            
//            NSArray *arrOne = [strIdiomOri componentsSeparatedByString:@","];
//            if ([arrOne count] > 2) {
//                NSString *strFirstWord = [arrOne objectAtIndex:0];
//                NSString *strSecondWord = [arrOne objectAtIndex:1];
//                
//                NSString *strWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strWord];
//                NSString *strFirstWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstWord];
//                NSString *strSecondWordForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strSecondWord];
//                
//                strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_WORDORI, TBL_EngDic, FldName_Word, strFirstWordForSQL];
//                NSString *strFirstWordOri = [self getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
//                if ([strFirstWordOri isEqualToString:@""]) {
//                    strFirstWordOri = strFirstWord;
//                }
//                NSString *strFirstWordOriForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strFirstWordOri];
//                
//                strQuery = [NSString	stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", FldName_WORDORI, TBL_EngDic, FldName_Word, strSecondWordForSQL];
//                
//                NSString *strSecondWordOri = [self getStringFldValueFromTbl:strQuery openMyDic:OPEN_DIC_DB];
//                if ([strSecondWordOri isEqualToString:@""]) {
//                    strSecondWordOri = strSecondWord;
//                }
//                NSString *strSecondWordOriForSQL = [self getCleanAndLowercaseAndSingleQuoteWordForSQL:strSecondWordOri];
//                
//                strQuery = [NSString stringWithFormat:@"UPDATE OR IGNORE %@ SET %@ = '%@' WHERE %@ = '%@'",TBL_EngDic, FldName_FirstWord, [NSString stringWithFormat:@"%@ %@", strFirstWordOriForSQL, strSecondWordOriForSQL], FldName_Word, strWordForSQL];
//                [self changeRec:strQuery openMyDic:TRUE];
//                                
//            }
		}
	}
    
    
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
}



//문장을 받아서 모르는 단어를 표시해준다.
+ (NSMutableAttributedString*) getSentenceWithKnownOrUnknown:(NSString *)strSentence
{
    NSMutableAttributedString * attStrResult = [[NSMutableAttributedString alloc] initWithString:strSentence];
    
    
    NSArray *arrWordsInSentence = [strSentence componentsSeparatedByString:@" "];
    //        DLog(@"arrTemp11 : %@", arrTemp11);
    
    NSMutableArray *arrMutableWordsInSentence = [[NSMutableArray alloc] initWithArray:arrWordsInSentence];
    
#ifdef CHINESE
    [arrMutableWordsInSentence removeAllObjects];
    for (NSInteger i = 0; i < [strSentence length]; ++i) {
        NSString *strOneInTemp11 = [strSentence substringWithRange:NSMakeRange(i, 1)];
        //            DLog(@"strOneInTemp11 : %@", strOneInTemp11);
        [arrMutableWordsInSentence addObject:strOneInTemp11];
    }
#endif


    NSInteger indexInSentence = 0;
    for (int i = 0; i < [arrMutableWordsInSentence count]; i++) {
        NSString *strOneWord = [arrMutableWordsInSentence objectAtIndex:i];// substringWithRange: NSMakeRange(i, 1)];
        DLog(@"indexInSentence : %d", indexInSentence);
        DLog(@"[strOneWord length] : %d", [strOneWord length]);
        indexInSentence += [strOneWord length];
        NSString *strOneWordTemp = [strSentence substringWithRange:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
        
        DLog(@"indexInSentence : %d", indexInSentence);
        DLog(@"strSentence : %@", strSentence);
        DLog(@"strOneWord : %@", strOneWord);
        DLog(@"strOneWordTemp : %@", strOneWordTemp);
        NSMutableString *strOverOneWordOri = [NSMutableString stringWithString:@""];
        //            DLog(@"strOneWord : %@", strOneWord);
        //            if ([strOneWord isEqualToString:@"模"] == TRUE) {
        ////                DLog(@"strOneWord : %@", strOneWord);
        //                strOneWord = strOneWord;
        //            }
        
#ifdef ENGLISH
        if (! ( ([strOneWord isEqualToString:@""]) || ([strOneWord isEqualToString:@"\r"]) || ([strOneWord isEqualToString:@"\n"]) || ([strOneWord isEqualToString:@"\r\n"]) ) ) {
            NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
            
            NSString *strOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
            NSString *strOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strOneWord];
            NSString *strOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneOri];
            
            NSString *strNextOne = @"";
            
            if ( (i + 1) < ([arrMutableWordsInSentence count]) ){
                strNextOne = [arrMutableWordsInSentence objectAtIndex:i+1];
                NSString *strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
                NSString *strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
                NSString *strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
                
                if ([strOneWord isEqualToString:@"as"]) {
                    NSInteger aaaa = 0;
                    aaaa = 1;
                    
                }
                NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@ %@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOneOriForSQL, strNextOneOriForSQL, FldName_WordLength];
                [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
                
                NSMutableString *strOverOneWord = [NSMutableString stringWithString:strOneForSQL];
                NSMutableString *strOverOneWordInText = [NSMutableString stringWithString:@""];
                
                
                
                if ([arrAllOne count] > 0) {
                    //숙어나 문장의 경우... (두단어 이상으로 이루어진다.)
                    NSInteger indexWordLength = 2;
                    BOOL blnHasWordInDic = FALSE;
                    //2단어 이상으로 이루어진것부터 찾는다.
                    if ((i + 2) < [arrMutableWordsInSentence count]) {
                        [strOverOneWordOri appendFormat:@"%@,", strOneOriForSQL];
                        [strOverOneWordInText appendFormat:@"%@", strOneForSQL];
                        
                        
                        DLog(@"arrAllOne : %@", arrAllOne);
                        for (NSDictionary *dicOne in arrAllOne) {
                            DLog(@"dicOne : %@", dicOne);
                            NSString *strWordOriInDicOne = [dicOne objectForKey:KEY_DIC_WORDORI];
                            DLog(@"strWordOriInDicOne : %@", strWordOriInDicOne);
                            NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KEY_DIC_WordLength] integerValue];
                            DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
                            if ((i + intWordLengthInDicOne) >= [arrMutableWordsInSentence count] ) {
                                break;
                            }
                            
                            if (indexWordLength != intWordLengthInDicOne) {
                                for (int j = 1; j < intWordLengthInDicOne; ++j) {
                                    // 문장내의 다음단어까지 다시 한번 읽는다.
                                    //                            DLog(@"i : %d", i);
                                    //                                DLog(@"indexWordLength : %d", indexWordLength);
                                    //                            DLog(@"indexWordLength + i : %d", indexWordLength + i);
                                    //                            DLog(@"[arrMutableTemp11 count] : %d", [arrMutableTemp11 count]);
                                    
                                    strNextOne = [arrMutableWordsInSentence objectAtIndex:i+j];
                                    strNextOneForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOne];
                                    strNextOneOri = [myCommon GetOriWordOnlyIfExistInTbl:strNextOne];
                                    strNextOneOriForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strNextOneOri];
                                    
                                    //                                DLog(@"strNextOne : %@", strNextOne);
                                    [strOverOneWordOri appendFormat:@"%@,",strNextOneOriForSQL];
                                    [strOverOneWordInText appendFormat:@" %@",strNextOneForSQL];
                                    //                                DLog(@"strOverOneWordInText After: %@", strOverOneWordInText);
                                    //                                DLog(@"strOverOneWordOri After: %@", strOverOneWordOri);
                                }
                                indexWordLength = intWordLengthInDicOne;
                            }
                            if ([strWordOriInDicOne isEqualToString:strOverOneWordOri] == TRUE) {
                                blnHasWordInDic = TRUE;
                                //                            DLog(@"dicOne : %@", dicOne);
                                strOverOneWord = [dicOne objectForKey:KEY_DIC_WORD];
                                i += indexWordLength - 1;
                            }
                        }
                    }
                    //
                    DLog(@"strOverOneWordInText After: %@", strOverOneWordInText);
                    DLog(@"strOverOneWordOri After: %@", strOverOneWordOri);
                    DLog(@"strOverOneWord After: %@", strOverOneWord);
                    
                    strOneWord = strOverOneWordInText;
                }
            }
        }
#elif CHINESE
//        //중국어는 문자만이 아니라 단어일수 있어서 해당되는 단어가 있는지 확인해서 단어가 있으면 단어를 넘긴다.
//        //일단 본문에서 4자 이상이 있는지 본다.
//        NSMutableString *strOverOneWord = [NSMutableString stringWithString:@""];
//        NSInteger indexWordLength = 1;
//        NSInteger indexWordLengthTRUE = 1;
//        BOOL blnHasWordInDic = FALSE;
//        
//        NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
//        //            DLog(@"i + 4 : %d", i + 4);
//        //            DLog(@"i + 3 : %d", i + 3);
//        //            DLog(@"i + 2 : %d", i + 2);
//        //            DLog(@"i + 1 : %d", i + 1);
//        //            DLog(@"[arrMutableTemp11 count] : %d", [arrMutableTemp11 count]);
//        
//        if ((i + 4) <= [arrMutableTemp11 count] ) {
//            strOverOneWord = [NSMutableString stringWithFormat:@""];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 2)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 3)]];
//            //                DLog(@"strOverOneWord : %@", strOverOneWord);
//            indexWordLength = 4;
//            indexWordLengthTRUE = 4;
//            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY %@ ASC", TBL_EngDic, FldName_FirstWord, strOverOneWord, FldName_WordLength];
//            
//            //            NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
//            
//            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//            //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
//            
//            //            NSInteger intMaxWordLength = [myCommon getIntFldValueFromTbl:strQuery openMyDic:TRUE];
//            
//            if ([arrAllOne count] >= 2) {
//                indexWordLength = 4;
//                NSString *stttt = @"";
//                //                        DLog(@"arrAllOne : %@", arrAllOne);
//            }
//            if ([arrAllOne count] >= 1) {
//                for (NSDictionary *dicOne in arrAllOne) {
//                    //                        //                    NSDictionary *dicOne = [dicAllOne objectForKey:strWordKey];
//                    //                        DLog(@"dicOne : %@", dicOne);
//                    //                    DLog(@"strWordKey : %@", strWordKey);
//                    NSString *strWordInDicOne = [dicOne objectForKey:FldName_Word];
//                    //                        DLog(@"strWordInDicOne : %@", strWordInDicOne);
//                    NSInteger intWordLengthInDicOne =  [[dicOne objectForKey:KYE_DIC_WordLength] integerValue];
//                    //                        DLog(@"intWordLengthInDicOne : %d", intWordLengthInDicOne);
//                    if ((i + indexWordLength) >= [arrMutableTemp11 count] ) {
//                        break;
//                    }
//                    
//                    if (indexWordLength != intWordLengthInDicOne) {
//                        //wordLength가 바뀌면 문장내의 다음단어까지 다시 한번 읽는다.
//                        //                            DLog(@"i : %d", i);
//                        //                            DLog(@"indexWordLength : %d", indexWordLength);
//                        //                            DLog(@"indexWordLength + i : %d", indexWordLength + i);
//                        //                            DLog(@"[arrMutableTemp11 count] : %d", [arrMutableTemp11 count]);
//                        [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + indexWordLength)]];
//                        //                            DLog(@"strOverOneWord : %@", strOverOneWord);
//                        indexWordLength++;
//                        //                            DLog(@"AFTER indexWordLength : %d", indexWordLength);
//                    }
//                    
//                    //                        DLog(@"strWordInDicOne : %@", strWordInDicOne);
//                    //                        DLog(@"strOverOneWord : %@", strOverOneWord);
//                    if ([strWordInDicOne isEqualToString:strOverOneWord] == TRUE) {
//                        strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
//                        blnHasWordInDic = TRUE;
//                        indexWordLengthTRUE = indexWordLength;
//                        //                            DLog(@"strOneWord : %@", strOneWord);
//                    }
//                    
//                }
//            }
//        }
//        
//        //본문의 3글자에 해당되는 단어가 사전에 있는지 본다.
//        if ( ( blnHasWordInDic == FALSE) && ((i + 3) <= [arrMutableTemp11 count] ) ){
//            strOverOneWord = [NSMutableString stringWithFormat:@""];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 2)]];
//            //                DLog(@"strOverOneWord : %@", strOverOneWord);
//            indexWordLength = 3;
//            indexWordLengthTRUE = 3;
//            
//            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
//            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//            //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
//            if ([arrAllOne count] >= 1) {
//                blnHasWordInDic = TRUE;
//                strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
//            }
//        }
//        
//        //본문의 2글자에 해당되는 단어가 사전에 있는지 본다.
//        if ( ( blnHasWordInDic == FALSE) && ((i + 2) <= [arrMutableTemp11 count] ) ){
//            strOverOneWord = [NSMutableString stringWithFormat:@""];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 1)]];
//            //                DLog(@"strOverOneWord : %@", strOverOneWord);
//            indexWordLength = 2;
//            indexWordLengthTRUE = 2;
//            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
//            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//            //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
//            if ([arrAllOne count] >= 1) {
//                blnHasWordInDic = TRUE;
//                strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
//            }
//            
//        }
//        
//        //본문의 1글자에 해당되는 단어가 사전에 있는지 본다.
//        if ( ( blnHasWordInDic == FALSE) && ((i + 1) <= [arrMutableTemp11 count] ) ){
//            strOverOneWord = [NSMutableString stringWithFormat:@""];
//            [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + 0)]];
//            //                DLog(@"strOverOneWord : %@", strOverOneWord);
//            indexWordLength = 1;
//            indexWordLengthTRUE = 1;
//            NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_Word, strOverOneWord];
//            [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_DoNotGetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
//            //                DLog(@"arrAllOne COUNT : %d", [arrAllOne count]);
//            if ([arrAllOne count] >= 1) {
//                blnHasWordInDic = TRUE;
//                strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
//            }
//            
//        }
//        
//        
//        //            DLog(@"strOneWord : %@", strOneWord);
//        //            DLog(@"BEFORE i : %d", i);
//        i = i + indexWordLengthTRUE - 1;
//        //            DLog(@"AFTER i : %d", i);
//        //                for (int indexWordLength = 2; indexWordLength < (intMaxWordLength + 1); ++indexWordLength) {
//        //                    if ((i + indexWordLength - 1) > [arrMutableTemp11 count] ) {
//        //                        continue;
//        //                    }
//        //                    indexWordLength1 = indexWordLength;
//        //                    [strOverOneWord appendString:[arrMutableTemp11 objectAtIndex:(i + indexWordLength - 1)]];
//        //                    DLog(@"strOverOneWord : %@", strOverOneWord);
//        //                }
//        //                strOneWord = [NSString stringWithFormat:@"%@", strOverOneWord];
//        //                DLog(@"BEFORE i : %d", i);
//        //                i = (i + indexWordLength1 - 1);
//        //                DLog(@"AFTER i : %d", i);
//        
#endif
//        //            DLog(@"strOneWord : %@", strOneWord);
//        //            DLog(@"strOverOneWordOri : %@", strOverOneWordOri);
//        NSString *strOneWordResult = [self HTMLFromWithKnowTag:strOneWord strWordOriToFind:strOverOneWordOri];
//        //            DLog(@"strOneWordResult : %@", strOneWordResult);
//        //            [outputHTML appendString:strOneWordResult];
//#ifdef ENGLISH
//        if  (i == 0) {
//            [outputHTML appendString:[NSString stringWithFormat:@"%@ ", strOneWordResult]];
//        } else {
//            [outputHTML appendString:[NSString stringWithFormat:@" %@", strOneWordResult]];
//        }
//        //            DLog(@"outputHTML : %@", outputHTML);
//#elif CHINESE
//        [outputHTML appendString:strOneWordResult];
//#endif
        

    NSDictionary *dicOne = [[NSDictionary alloc] init];
    
    if ([strOverOneWordOri isEqualToString:@""] == TRUE) {
        //하나의 단어일때...
        NSString *strWordForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOneWord];
        NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORD, strWordForSQL];
        
        NSMutableDictionary *dicAllOne = [[NSMutableDictionary alloc] init];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:nil byDic:dicAllOne openMyDic:OPEN_DIC_DB];
        
        NSString *strWordWithNoWhitespaceANdNewLine = [strOneWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        dicOne = [dicAllOne objectForKey:[strWordWithNoWhitespaceANdNewLine lowercaseString]];
        
//        if (dicOne == NULL) {
//            return strWord;
//        }
    } else {
        //영어에서의 숙어일때...
        NSString *strWordOriToFindForSQL = [myCommon getCleanAndLowercaseAndSingleQuoteWordForSQL:strOverOneWordOri];
        NSString *strQuery = strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", TBL_EngDic, FldName_TBL_EngDic_WORDORI, strWordOriToFindForSQL];
        
        NSMutableArray *arrAllOne = [[NSMutableArray alloc] init];
        [myCommon getWordList:strQuery getOriMeaning:When_WordHasNoMeaning_GetOriMeaning byArray:arrAllOne byDic:nil openMyDic:OPEN_DIC_DB];
    }
    
    NSString *strKnow = [dicOne objectForKey:@"Know"];
    NSString *strPronounce = [dicOne objectForKey:@"Pronounce"];
    NSInteger intKnowPronounce = [[dicOne objectForKey:@"KnowPronounce"] integerValue];
    
    NSInteger intKnow = [strKnow integerValue];
    
    NSString *strMeaning = [dicOne objectForKey:@"Meaning"];
    if (strMeaning == NULL){
        strMeaning = @"";
    }
    NSString *MeaningHtml = @"";
    
        
        
        if ( (intKnow >= KnowWord_Known) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
            //아는 단어에 모르는 발음이고 발음이 있으면 발음만 표시한다.
            MeaningHtml = [NSString stringWithFormat:@"<small>[</small><big>%@</big><small>]</small>", strPronounce];
        } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == TRUE) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
            //모르는 단어에 뜻이 없고 모르는 발음이고 발음이 있으면 발음만 표시한다.
            MeaningHtml = [NSString stringWithFormat:@"<small>[</small><big>%@</big><small>]</small>", strPronounce];
        } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == FALSE) && (intKnowPronounce < KnowWord_Known) && ([strPronounce isEqualToString:@""] == FALSE) ){
            //모르는 단어에 뜻이 있고 모르는 발음이고 발음이 있으면 뜻과 발음만 표시한다.
#ifdef ENGLISH
            MeaningHtml = [NSString stringWithFormat:@"<small>[%@, %@]</small>", strPronounce, strMeaning];
#else
            MeaningHtml = [NSString stringWithFormat:@"<small>[</small><big>%@</big>, <small>%@]</small>", strPronounce, strMeaning];
#endif
            ;
        } else if ( (intKnow < KnowWord_Known) && ([strMeaning isEqualToString:@""] == FALSE) ){
            //모르는 단어에 뜻이 있으면 뜻만 표시한다.
            MeaningHtml = [NSString stringWithFormat:@"<small>[%@]</small>", strMeaning];
        }        
    
    if (dicOne == NULL) {
        intKnow = -1;
    }

    if (intKnow == 0) {
        [attStrResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
    } else if (intKnow == 1) {
        [attStrResult addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
        [attStrResult addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
    } else if   (intKnow == 2) {
        [attStrResult addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
        [attStrResult addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(indexInSentence - [strOneWord length], [strOneWord length])];
    }
    
        //   [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,5)];
        //    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
        //    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(6,5)];
        //    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(11,2)];
    
    //    DLog(@"strMutableWordOri : %@", strMutableWordOri);
        indexInSentence++;
   
}
     return attStrResult;
}
@end



