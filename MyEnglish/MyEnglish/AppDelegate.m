//
//  AppDelegate.m
//  MyEnglish
//
//  Created by KIM HyungDal on 12. 5. 13..
//  Copyright (c) 2012년 dalnimSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "myCommon.h"
#import "ViewController.h"
#import "iRate.h"
#import "Flurry.h"
#import "FlurryAdDelegate.h"
#import "ExamViewController.h"
#import "OptionsViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController=_navigationController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil]; 
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        OptionsViewController* optionsVC = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:optionsVC];
        
        UISplitViewController* splitVC = [[UISplitViewController alloc] init];
        splitVC.viewControllers = [NSArray arrayWithObjects:nav, self.navigationController, nil];
        splitVC.delegate = self.viewController;
        
        optionsVC.delegate = self.viewController;
        
        self.window.rootViewController = splitVC;
        
    }else{
        
        self.window.rootViewController = self.navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
#ifdef ENGLISH
    #ifdef LITE
        [Flurry startSession:@"3J8WSBTPGGMJXMBPS4FY"];
    #else
        [Flurry startSession:@"G285R9X9QG2CJN8P2CS6"];
    #endif
#elif CHINESE
    #ifdef LITE
        [Flurry startSession:@"T95FMB73PXDM76KB34P5"];
    #else
        [Flurry startSession:@"QWH4TBT6SQFYSNGFDNRC"];
    #endif
#endif
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.absoluteString hasPrefix:@"fb236345139854268"]) {
        
        // Facebook SDK * login flow *
        // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
            // Facebook SDK * App Linking *
            // For simplicity, this sample will ignore the link if the session is already
            // open but a more advanced app could support features like user switching.
            if (call.accessTokenData) {
                if ([FBSession activeSession].isOpen) {
                    NSLog(@"INFO: Ignoring app link because current session is open.");
                }
                else {
                    [self handleAppLink:call.accessTokenData];
                }
            }
        }];
    }
    return YES;
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  NSLog(@"%@",error.localizedDescription);
                              }
                          }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application	{
    [FBAppEvents activateApp];
    
    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIScreen mainScreen] setBrightness:[myCommon getBrightness]];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [myCommon setBrightness:[[UIScreen mainScreen] brightness]];
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults]; 
    float BackLight = [defs floatForKey:@"BackLight"];
    if (BackLight < 0.1f) {
        BackLight = 0.1f;
    } else if (BackLight >= 1.0f) {
        BackLight = 1.0f;
    } else {
        BackLight = [[UIScreen mainScreen] brightness];
    }
    [[UIScreen mainScreen] setBrightness:BackLight];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (([[self.navigationController topViewController] isKindOfClass:[ViewController class]])||([[self.navigationController topViewController] isKindOfClass:[ExamViewController class]])) {
        return  UIInterfaceOrientationMaskPortrait;
    }
    return  UIInterfaceOrientationMaskAll;
}

+ (void)initialize
{
    
    //앱을 Rate하는것은 앱을 사용한지 한창을 지난후에야 하게 한다...
#ifdef ENGLISH
    #ifdef LITE
        //MyEnglishLite
        [iRate sharedInstance].appStoreID = 532923588; // Replace this
    #else
        //MyEnglish
        [iRate sharedInstance].appStoreID = 527050097; // Replace this
    #endif
#elif CHINESE
    #ifdef LITE
        //MyChineseLite
        [iRate sharedInstance].appStoreID = 572205306; // Replace this
    #else
        //MyChinesePro
        [iRate sharedInstance].appStoreID = 572205703; // Replace this
    #endif
#endif
}
@end
