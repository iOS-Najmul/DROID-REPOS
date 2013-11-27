//
//  IdiomAndThemeViewController.h
//  MyEnglish
//
//  Created by HyungDal KIM on 12. 11. 25..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdiomAndThemeViewController : UIViewController<UITableViewDataSource, UITableViewDataSource>
{
    UITableView         *tblMain;
    NSMutableArray      *arrIdiomAndTheme;
}
@property (nonatomic, strong)   IBOutlet UITableView    *tblMain;
@property (nonatomic, strong) NSMutableArray    *arrIdiomAndTheme;

@end
