//
//  myCommon.h
//  MyListPro
//
//  Created by 김형달 on 10. 8. 15..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface myCommon : NSObject {
	// NSString* strDBPath;
	
}
//@property (nonatomic, strong) NSString*	strDBPath;

//#pragma mark -
//#pragma mark 기본 환경 설정 함수
+ (void) setEnv;
+ (void) setDBPathInBundle;
+ (void) setDBPath:(NSString*)DBPath;
+ (void) setDBBookPath:(NSString*)DBBookPath;
+ (void) setDocPath:(NSString*)DocPath;
+ (void) setCachePath:(NSString*)CachePath;
+ (void) setLatestBook:(NSString*)LatestBook;
+ (NSString *) getPlatformString;

+ (NSString*) getCachePath;
+ (NSString*) getDBPath;
+ (NSString*) getDocPath;
+ (NSString*) getLatestBook;
+ (NSInteger) getAppWidth;
+ (NSInteger) getAppHeight;
+ (NSString*)getCurrentDate;
+ (NSString*)getCurrentTime;
+ (NSString*)getCurrentDatAndTime;
+ (NSString*) getCurrentDatAndTimeForBackup;
+ (NSString*) restoreCurrentDatAndTimeForBackup:(NSString*) strDateAndTime;

+ (NSMutableString*) readTxtWithEncoding:(NSString*)strFileName;
+ (NSMutableString*)HTMLFromTextString:(NSMutableString *)originalText;
+ (NSMutableString*)HTMLFromHTMLString:(NSMutableString *)originalText;


+ (BOOL) chkTableExist:(NSString*)strTableName OpenMyDic:(BOOL)openMyDic;
+ (BOOL) chkWordExist:(NSString*)strWord  intDicWordOrIdiom:(NSInteger)intDicWordOrIdiom openMyDic:(NSInteger)openMyDic;
+ (BOOL) chkRecExist:(NSString*)strQeury openMyDic:(NSInteger)openMyDic;

+ (BOOL) changeRec:(NSString*)strQuery openMyDic:(BOOL)openMyDic;
+ (BOOL) closeDB:(BOOL)openMyDic;
+ (void) compressDB:(BOOL)openMyDic;

+ (NSString*) commasForNumber:(NSNumber*)num;

+ (BOOL) copyBookSQLiteFromDefault:(NSString*) strBookName;
//+ (BOOL) createBookTable:(NSString*)strTblName openMyDic:(NSInteger)openMyDic;
+ (void) createBookSettingInTableIfNotExist:(NSMutableDictionary*)dicOne fileName:(NSString*)strFileName;

+ (NSInteger) getAllProverbsArrayFromTable:(NSMutableArray*)arrFromTblBook useKnowButton:(BOOL)blnUseKnowButton sortType:(NSInteger)intSortType pageNumber:(NSInteger)pageNumber whereClauseFld:(NSString*)whereClauseFld orderByFld:(NSString*)orderByFld isAsc:(BOOL)blnAsc openMyDic:(NSInteger)openMyDic;

+ (NSInteger) getAllWordsArrayFromBookTable:(NSString*)strBookTblNo arrOne:(NSMutableArray*)arrFromTblBook useKnowButton:(BOOL)blnUseKnowButton sqlType:(NSInteger)sqlType sortType:(NSInteger)intSortType pageNumber:(NSInteger)pageNumber whereClauseFld:(NSString*)whereClauseFld orderByFld:(NSString*)orderByFld isAsc:(BOOL)blnAsc openMyDic:(NSInteger)openMyDic;

+ (void) getExportWordList:(NSMutableArray*)arrOne;

+ (void) getBookInfoFormTbl:(NSMutableDictionary*)dicOne fileName:(NSString*)strFileName;
+ (BOOL) getEnvFromTbl:(NSMutableDictionary*)dicEnv;

+ (NSString*) getCleanAndLowercase:(NSString*)strWord;
+ (NSString*) getCleanAndLowercaseAndSingleQuoteWordForSQL:(NSString*)strWord;
+ (NSString*) getCleanAndSingleQuoteWordForSQL:(NSString*)strWord;
+ (int) GetCountFromTbl:(NSString*)strQuery openMyDic:(NSInteger)openMyDic;

+ (BOOL) GetDataFromTbl:(NSString*)strWord Meaning:(NSMutableString*)strMeaning Know:(NSMutableString*)strKnow Level:(NSMutableString*)strLevel Count:(NSMutableString*)strCount WordOri:(NSMutableString*)strWordOri;
+ (int) getIntFldValueFromTbl:(NSString*)strQuery openMyDic:(BOOL)openMyDic;

+ (NSString*) getKnowFromTbl:(NSString*)strWord;
+ (NSString*) getMeaningFromTbl:(NSString*)strWord;
+ (NSString*) getMeaningOriFromTbl:(NSString*)strWordOri;

+ (NSInteger) getOrCreateBoookTblNoFromTblBookSetting:(NSString*)strBookName;
+ (NSString*) GetOriWordOnlyIfExistInTbl:(NSString*)strWord;
//+ (BOOL) GetOriWordIfExistInTbl:(NSString*)strOne OriWord:(NSMutableString*) strOneOri;
+ (NSMutableArray*)getChapterInfoIntable;
+ (NSMutableArray*)getPageInfoIntable:(NSInteger)fileLength intBookTblNo:(NSInteger)intBookTblNo;
+ (NSInteger) getPageNoWithIndex:(NSInteger)wordStartIndex;
+ (void) getIndexWithPageNo:(NSInteger)pageNo StartIndex:(NSMutableString*)startIndex EndIndex:(NSMutableString*)endIndex;
+ (NSString*) getStringFldValueFromTbl:(NSString*)strQuery openMyDic:(NSInteger)openMyDic;

+ (NSMutableArray*) GetWordsCountFromTbl:(NSString*)strWordOri;

+ (BOOL) getWordListInMyDic:(NSString*)strQuery sqliteDBPath:(NSString*)strDbMyDicPath  byArray:(NSMutableArray*)arrResult byDic:(NSMutableDictionary*)dicResult;
+ (BOOL) getWordList:(NSString*)strQuery  getOriMeaning:(NSInteger)getOriMeaning byArray:(NSMutableArray*)arrResult byDic:(NSMutableDictionary*)dicResult openMyDic:(NSInteger)openMyDic;

+ (void) insertWordIfNotExist:(NSString*)strWord wordOriForSQL:(NSString*)strWordOriForSQL know:(NSString*)strKnow;

+ (NSInteger)getIntBookFileSizeFromSQLFile:(NSInteger)intBookTblNo;
+ (BOOL)setIntBookFileSizeFromSQLFile:(NSInteger)intBookTblNo intFileSize:(NSInteger)fileSize;
+ (NSInteger)getIntPageNoFromSQLFile:(NSInteger)intBookTblNo;
+ (NSInteger)getPageNoFromSQLFile:(NSString*)strFullSQLFileName;
//+ (BOOL) createSavePageInfoTableIfNotExist;
+ (BOOL)savePageInfoIntable:(NSMutableArray*)arrPageInfo fontName:(NSString*)fontName fontSize:(NSInteger)fontSize jsFontSize:(NSInteger)jsFontSize;

+ (void) transactionBegin:(BOOL)openMyDic;
+ (void) transactionCommit:(BOOL)openMyDic;
+ (BOOL) updateBookSettingEachBookKnow:(NSInteger)intBookTblNo;
+ (BOOL) updateCountOfCheckedWord:(NSInteger)intBookTblNo word:(NSString*)strWord wordOri:(NSString*)strWordOri;
+ (void) updateDeleteKnow;


//CSS를 만든다.
+ (void) CreateCSS:(NSMutableDictionary*)dicCss option:(NSInteger)optCSS;
+ (NSMutableDictionary*) GetCSS;

//+ (BOOL) chkTableExist:(NSString*)strTableName;

+ (const CGFloat*) getColorComponents:(NSString*)strColorName;
+ (NSString*) getStrKnowFromIntKnow:(NSInteger)intKnow;
+ (NSString*) getStrKnowNumberFromStrKnow:(NSString*)strKnow;
+ (BOOL) blnProperStrKnow:(NSString*)strKnow;
+ (NSString*) getStrKnowPronounce123FromStrKnowPronounceX:(NSString*)strKnowPronounceX;
+ (NSString*) getStrKnowPronounceXFromStrKnowPronounce123:(NSString*)strKnowPronounce123;

+ (NSArray*) getKnowOfButtons:(NSInteger)intSortType;
+ (void) setKnowOfButtons:(NSInteger)intSortType intNotRated:(NSInteger)intKnowOftButtonNotRated intUnknown:(NSInteger)intKnowOftButtonUnknown intNotSure:(NSInteger)intKnowOftButtonNotSure intKnown:(NSInteger)intKnowOftButtonKnown intExclude:(NSInteger)intKnowOftButtonExclude;

//+ (NSMutableArray*) getWordListForExam:(NSInteger)maxNoOfExam;
+ (NSMutableArray*) getWordListForExam:(NSInteger)maxNoOfExam;
+ (NSMutableArray*) getWordListForExamBySQL:(NSString*)strQuery wordList:(NSMutableArray*)arrWordList maxNoOfExam:(NSInteger)maxNoOfExam;
+ (NSMutableArray*) getWrongWordListForExam:(NSString*)strWord;
+ (NSMutableArray*) getWrongWordListForExamBySQL:(NSString*)strQuery wordList:(NSMutableArray*)arrWordList WordExcept:(NSString*)strWordExcept maxNoOfExam:(NSInteger)maxNoOfExam;
+ (NSMutableArray*) getMeaningsForQA:(NSString*)strMeaningRightAnswer;
+ (NSMutableDictionary*) findFirstSentenceWithWordInText:(NSString*)strWord Text:(NSString*)strAllContentsInFile;


+ (NSMutableArray*) getRandomNumber:(NSInteger)minNumber MaxNumber:(NSInteger)maxNumber CountOfRandomNumber:(NSInteger)limitOfCount;

+(BOOL) executeSqlQuery:(NSString*)strQuery openMyDic:(BOOL)openMyDic;
+ (BOOL) chkFieldExist:(NSString*)strFieldName TableName:(NSString*)strTableName OpenMyDic:(BOOL)openMyDic;
+ (void) getWorsForQuiz:(NSMutableDictionary*)dicWordsForQuiz;

+ (BOOL) openDBMyDicInBundle;
+ (BOOL) closeDBMyDicInBundle;
+ (BOOL) openDB:(BOOL)openMyDic;
+ (NSMutableArray*) getArrCategory;

+ (BOOL) createIndexInMyEnglish:(NSString*)strFldName;
//+ (BOOL) createIndexInSQLite:(NSString*)strTblName  fldName:(NSString*)strFldName  openMyDic:(NSInteger)openMyDic;

#pragma mark -
#pragma mark 화면밝기 저장 및 가져오기
+ (void) setBrightness:(float)brightness;
+ (float) getBrightness;

#pragma mark -
#pragma mark Table관련 함수
+ (void) editTable:(UITableView*)tblOne viewController:(UIViewController*)viewController;


#pragma mark -
#pragma mark 아는정도를 바꾸는 함수
+ (BOOL) changeKnowWordOri:(NSString*)strWordOri know:(NSInteger)intKnow knowBefore:(NSInteger)intKnowBefore tblName:(NSString*)strTblName bookTblNo:(NSInteger)intBookTblNo openMyDic:(NSInteger)openMyDic;
+ (BOOL) changeKnow:(NSString*)strWord know:(NSInteger)intKnow knowBefore:(NSInteger)intKnowBefore tblName:(NSString*)strTblName bookTblNo:(NSInteger)intBookTblNo openMyDic:(NSInteger)openMyDic;


#pragma mark -
#pragma mark iCloud백업관련
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (float) getIOSVersion;

+ (NSString*) GetFormattedNumber:(NSInteger)intNumber;

#pragma mark -
#pragma mark Twitters
+ (void) PostTwitter:(NSString*)strMessage image:(UIImage*)imgOne strURL:(NSString*)strURL sender:(id)sender;

#pragma mark -
#pragma mark 단어로 부터 문장 가져오기
+ (NSString*) getSentenceWithWord:(NSString*)strWord  strFullContents:(NSString*)strFullContents;
+ (NSString*)HTMLFromTextStringPage:(NSMutableString *)originalText WordBlank:(NSString*)strWordBlank;

#pragma mark -
#pragma mark 단어나, 숙어를 선택하여 원형을 가져오기
+ (BOOL) getWordAndWordoriInSelected:(NSString*)strWordsInSelected dicWordWithOri:(NSMutableDictionary*)dicWordWithOri;

//이디엄을 ENG_DIC로 복사하는 기능... 개발중에만 사용하는 함수이다. (이전 사용자는 In-App Purchase를 활용하게 할까?)
+ (void) copyIdiomTemp;
//ENG_DIC에 있는 이디엄에 대해서 Reserv1_CHAR에 있는 단어를 원형으로만 구성하게 해주는 함수이다.
+ (void) copyIdiomTemp2;

//속담 리스트를 받아온다.
+ (NSMutableArray*) getProverbList;

//문장을 받아서 모르는 단어를 표시해준다.
+ (NSMutableAttributedString*) getSentenceWithKnownOrUnknown:(NSString *)strSentence;

//선택된 단어에서 알파벳과 기호들을 분리해서 순서대로 배열에 담아서 리턴해준다.
+ (NSMutableArray*) getWordsAndPunctuationInSelectedWord:(NSString*)strWord;

//단어로부터 원형을 가져온다. (숙어등은 원형,원혀, 등의 형식으로 가져온다.
+ (NSString*) getOriWithWordOrIdiom:(NSString*)strWord;

@end
