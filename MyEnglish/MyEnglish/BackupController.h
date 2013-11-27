//
//  BackupController.h
//  MyListPro
//
//  Created by Hyung Dal KIM on 11. 4. 9..
//  Copyright 2011 dalnim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BackupController : UIViewController<MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
	NSString		*strFileNameToMail;
	NSMutableArray		*arrBackupFiles;
    NSString                *strLastBackupFile;
	IBOutlet UITableView *tblBackup;
	IBOutlet UISegmentedControl *segConBackup;	
    UIActivityIndicatorView		*aiv;
    BOOL                        blnRestore;
    
    UIActionSheet					*actionSheetProgress;
	UIProgressView					*progressViewInActionSheet;
    BOOL                        blnCancelRestore;
}
@property (nonatomic, strong) NSString		*strFileNameToMail;
@property (nonatomic, strong) NSMutableArray		*arrBackupFiles;
@property (nonatomic, strong) NSString                *strLastBackupFile;
@property (nonatomic, strong) IBOutlet UITableView *tblBackup;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segConBackup;
@property (nonatomic, strong) UIActivityIndicatorView					*aiv;
@property (nonatomic) BOOL                      blnRestore;
@property (nonatomic)    BOOL                        blnCancelRestore;
@property (nonatomic, strong) UIActionSheet					*actionSheetProgress;
@property (nonatomic, strong) UIProgressView					*progressViewInActionSheet;

- (void)back;
- (IBAction) selSegConBackup;
- (BOOL) makeBackUp:(NSTimer*)sender;
- (void) restoreDic:(NSTimer*)sender;
@end
