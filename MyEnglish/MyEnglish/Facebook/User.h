//
//  User.h
//  InstaTable
//
//  Created by Najmul Hasan on 6/10/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, retain) NSString *user_id;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *email;

@property(nonatomic, retain) NSString *first_name;
@property(nonatomic, retain) NSString *last_name;
@property(nonatomic, retain) NSString *middle_name;
@property(nonatomic, retain) NSString *name;

@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *language;
@property(nonatomic, retain) NSString *created_date;
@property(nonatomic, retain) NSString *status;

- (id)initWithDictionary:(NSDictionary*)myDict;
- (NSDictionary*)getUserDictonary;
- (NSData*)getUserJSONData;
- (BOOL)saveUserData;
- (void)print;

@end
