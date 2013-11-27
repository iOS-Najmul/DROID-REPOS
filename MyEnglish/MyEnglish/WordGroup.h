//
//  WordGroup.h
//  Ready2Read
//
//  Created by KIM HyungDal on 12. 3. 7..
//  Copyright (c) 2012 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordGroup : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger						intDicListType;
    NSMutableArray          *arrWordGroup;
        
    IBOutlet    UITableView         *tblOne;
    BOOL                    blnLoadWordGroup;
    NSInteger						intBookTblNo;
    NSString                        *strAllContentsInFile;
}
@property (nonatomic) NSInteger								intDicListType; //1:TBL_EngDic, 2:TBL_EngDic_intBookNo, 3:TBL_EngDic_BookTemp
@property (nonatomic, strong) NSMutableArray        *arrWordGroup;
@property (nonatomic, strong) IBOutlet    UITableView         *tblOne;
@property (nonatomic)     BOOL                    blnLoadWordGroup;
@property (nonatomic)     NSInteger						intBookTblNo;
@property (nonatomic, strong) NSString                        *strAllContentsInFile;

- (void) getWordGroup:(NSTimer *)sender;
@end
