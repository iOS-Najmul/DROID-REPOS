//
//  MovieSelectorController.h
//  MyListPro
//
//  Created by 김형달 on 10. 11. 8..
//  Copyright 2010 엠앤소프트. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLHandler.h"
#import "EpubContent.h"

@interface SelectorViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView	*tblView;
	NSMutableArray			*arrDocList;
    NSMutableArray          *arrBooksDefault;
	UISegmentedControl      *segControl;
    UISegmentedControl      *segAddAndEdit;
    UISegmentedControl      *segEditOnly;    
    BOOL                    blnSegEditOnly;
	UITextField				*txtUserName;
	UITextField				*txtPass;
    UIButton                *btnAddBook;
    BOOL                    blnAlphabet;
    BOOL                    blnDifficulty;
    BOOL                    blnVolumes;
    BOOL                    blnDefaultBooks;

    NSInteger               intBeforeSegSelectedIndex;
    UIAlertView             *alertViewProgress;
    BOOL                    blnBookHasPage;

    NSFileManager *fm;     

    NSInteger        intMovieSelectorSourceMode;
    
    //동영상모드
    NSMutableArray          *arrMovieList;
    NSMutableArray          *arrMovieScriptTxtList;
    NSString                *strMovieScriptFileName;
    
    NSString *ePubDirName;
    NSString *ePubDirPath;
    
	XMLHandler *_xmlHandler;
	EpubContent *_ePubContent;
	NSString *_pagesPath;
	NSString *_rootPath;
	NSString *_strFileName;
    NSMutableArray *_arrEPubChapter;
	NSInteger _pageNumber;
}
@property (nonatomic, strong) IBOutlet UITableView	*tblView;
@property (nonatomic, strong) NSMutableArray		*arrDocList;
@property (nonatomic, strong) NSMutableArray          *arrBooksDefault;

@property (nonatomic, strong) UITextField				*txtUserName;
@property (nonatomic, strong) UITextField				*txtPass;
@property (nonatomic, strong) UIButton                *btnAddBook;
@property (nonatomic, strong) UISegmentedControl      *segControl;
@property (nonatomic, strong) UISegmentedControl        *segAddAndEdit;
@property (nonatomic, strong) UISegmentedControl        *segEditOnly;    
@property (nonatomic) BOOL                    blnSegEditOnly;
@property (nonatomic)   BOOL                    blnAlphabet;
@property (nonatomic)   BOOL                    blnDifficulty;
@property (nonatomic)   BOOL                    blnVolumes;
@property (nonatomic)   BOOL                    blnDefaultBooks;
@property (nonatomic)   NSInteger               intBeforeSegSelectedIndex;
@property (nonatomic, strong)     UIAlertView                     *alertViewProgress;
@property (nonatomic)   BOOL                blnBookHasPage;
@property (nonatomic, strong) NSFileManager *fm; 

@property (nonatomic) NSInteger        intMovieSelectorSourceMode;

//동영상모드
@property (nonatomic, strong) NSMutableArray          *arrMovieList;
@property (nonatomic, strong) NSMutableArray          *arrMovieScriptTxtList;
@property (nonatomic, strong) NSString                *strMovieScriptFileName;

- (void) back;
- (void) editTable;
- (void) selSegControl:(id)sender;
- (NSMutableDictionary*) getBookInfo:(NSString*)strBookFileName;

//동영상모드
- (void) getMovieList:(NSTimer*)sender;

@property (nonatomic, strong)NSString *ePubDirName;
@property (nonatomic, strong)NSString *ePubDirPath; 
@property (nonatomic, strong)XMLHandler *_xmlHandler;
@property (nonatomic, strong)EpubContent *_ePubContent;
@property (nonatomic, strong)NSString *_pagesPath;
@property (nonatomic, strong)NSString *_rootPath;
@property (nonatomic, strong)NSString *_strFileName;
@property (nonatomic, strong) NSMutableArray *_arrEPubChapter;
@property (nonatomic) NSInteger _pageNumber;

- (NSString*)getRootFilePath;

@end
