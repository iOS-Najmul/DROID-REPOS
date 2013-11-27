//
//  AppDelegate.h
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 5. 13..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end
