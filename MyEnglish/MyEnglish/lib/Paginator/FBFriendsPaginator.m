//
//  FBFriendsPaginator.m
//  MyEnglish
//
//  Created by Najmul Hasan on 11/16/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "FBFriendsPaginator.h"
#import "SVProgressHUD.h"

@implementation FBFriendsPaginator

- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    // do request on async thread
    [SVProgressHUD showProgress:-1 status:@"Loading"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    dispatch_queue_t fetchQ = dispatch_queue_create("Data fetcher", NULL);
//    dispatch_async(fetchQ, ^{
    
//        NSString *pagingUrl = [NSString stringWithFormat:@"%@/0/%d/%ld",PROJECT_LIST_URL,page*pageSize,(long)pageSize];
//        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:pagingUrl]];
        
        
    NSString *query = [NSString stringWithFormat:@"{"
                       @"'friends':'SELECT uid,name,pic_square,profile_url FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() LIMIT %d OFFSET %d)',"
                       @"'total':'SELECT friend_count FROM user WHERE uid = me()',"
                       @"}",pageSize, page*pageSize];

    
        // Set up the query parameter
        NSDictionary *queryParam = @{ @"q": query };
        // Make the API request that uses FQL
        [FBRequestConnection startWithGraphPath:@"/fql"
                                     parameters:queryParam
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  if (error) {
                                      NSLog(@"Error: %@", [error localizedDescription]);
                                  } else {
                                      NSLog(@"Result: %@", result);
                                      // Get the friend data to display
                                      
                                      [self performSelectorOnMainThread:@selector(fetchedListOfData:) withObject:(NSDictionary*)result waitUntilDone:YES];
                                  }
                              }];
        
//    });
    //    dispatch_release(fetchQ);
}

- (void)fetchedListOfData:(NSDictionary *)responseDict {
    
    NSArray *friendInfo = (NSArray *) responseDict[@"data"][0][@"fql_result_set"];
    NSString *total = responseDict[@"data"][1][@"fql_result_set"][0][@"friend_count"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self receivedResults:[friendInfo copy] total:[total integerValue]];
    [SVProgressHUD dismiss];
}

@end
