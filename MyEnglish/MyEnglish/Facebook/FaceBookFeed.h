//
//  FaceBookFeed.h
//  MyEnglish
//
//  Created by Najmul Hasan on 11/7/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface FaceBookFeed : NSObject

@property(nonatomic, retain) NSString *feed_id;
@property(nonatomic, retain) NSString *object_id;
@property(nonatomic, retain) NSString *likeLink;
@property(nonatomic, retain) NSString *commentLink;

@property(nonatomic, retain) NSString *applicationID;
@property(nonatomic, retain) NSString *applicationName;
@property(nonatomic, retain) NSString *created_time;

@property(nonatomic, retain) NSString *updated_time;
@property(nonatomic, retain) NSString *fromID;
@property(nonatomic, retain) NSString *fromName;

@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *link;

@property(nonatomic, retain) NSDictionary *comments;
@property(nonatomic, retain) NSDictionary *likes;

- (id)initWithDictionaryForOwnPost:(NSDictionary*)myDict withUser:(User*)me;
- (id)initWithDictionary:(NSDictionary*)myDict;
- (void)print;

@end
