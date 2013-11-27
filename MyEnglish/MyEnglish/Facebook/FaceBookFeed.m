//
//  FaceBookFeed.m
//  MyEnglish
//
//  Created by Najmul Hasan on 11/7/13.
//  Copyright (c) 2013 dalnimSoft. All rights reserved.
//

#import "FaceBookFeed.h"
#import "User.h"

@implementation FaceBookFeed

-(id)initWithDictionary:(NSDictionary*)myDict
{
    self = [super init];
    if (self) {
        
        self.feed_id        = myDict [@"id"];
        self.object_id        = myDict [@"object_id"];
        
        if ([myDict [@"actions"] count]) {
            self.commentLink          = myDict [@"actions"] [0] [@"link"];
            self.likeLink       = ([myDict [@"actions"] count]>1)?myDict [@"actions"] [1] [@"link"]:nil;
        }
        
        self.applicationID     = myDict [@"application"] [@"id"];
        self.applicationName      = myDict [@"application"] [@"name"];
        self.created_time       = myDict [@"created_time"];
        
        self.updated_time   = myDict [@"updated_time"];
        self.fromID         = myDict [@"from"] [@"id"];
        self.fromName      = myDict [@"from"] [@"name"];
        
        self.message       = (myDict [@"message"])?myDict [@"message"]:myDict [@"name"];
        self.comments   = myDict [@"comments"];
        self.likes         = myDict [@"likes"];
        self.type          = myDict [@"type"];
        
        if ([self.type isEqualToString:@"link"]) {
            self.link = myDict [@"link"];
        }
	}
	
	return self;
}

-(id)initWithDictionaryForOwnPost:(NSDictionary*)myDict withUser:(User*)me
{
    self = [super init];
    if (self) {
        
        self.feed_id       = myDict [@"post_id"];
        self.created_time  = myDict [@"created_time"];
        
        self.fromID        = me.user_id;
        self.fromName      = me.name;
        
        self.message       = myDict [@"message"];
        self.comments      = myDict [@"comments"];
        self.likes         = myDict [@"likes"];
    }
	
	return self;
}

-(void)print{
    
    NSLog(@"feed_id :%@",self.feed_id);
    NSLog(@"likeLink :%@",self.likeLink);
    NSLog(@"commentLink :%@",self.commentLink);
   
    NSLog(@"applicationID :%@",self.applicationID);
    NSLog(@"applicationName :%@",self.applicationName);
    NSLog(@"created_time :%@",self.created_time);
    
    NSLog(@"updated_time :%@",self.updated_time);
    NSLog(@"fromID :%@",self.fromID);
    NSLog(@"fromName :%@",self.fromName);
    
    NSLog(@"message :%@",self.message);
    NSLog(@"comments :%@",self.comments);
    NSLog(@"likes :%@",self.likes);
    
    NSLog(@"type :%@",self.type);
    NSLog(@"link :%@",self.link);
}

@end
