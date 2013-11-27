//
//  User.m
//  InstaTable
//
//  Created by Najmul Hasan on 6/10/13.
//  Copyright (c) 2013 Najmul Hasan. All rights reserved.
//

#import "User.h"

#define   USER_PLIST        @"user.plist"

@implementation User

-(id)initWithDictionary:(NSDictionary*)myDict
{
    self = [super init];
    if (self) {
        
        self.user_id        = [myDict objectForKey:@"id"];
        self.username       = [myDict objectForKey:@"username"];
        self.email          = [myDict objectForKey:@"email"];
        
        self.first_name     = [myDict objectForKey:@"first_name"];
        self.last_name      = [myDict objectForKey:@"last_name"];
        self.middle_name    = [myDict objectForKey:@"middle_name"];
        self.name           = [myDict objectForKey:@"name"];
        
        self.location       = [[myDict objectForKey:@"location"] objectForKey:@"name"];
        self.language       = [myDict objectForKey:@"locale"];
        self.created_date   = [myDict objectForKey:@"created_date"];
        self.status         = [myDict objectForKey:@"status"];
	}
	
	return self;
}

-(NSDictionary*)getUserDictonary{
    
    NSArray *objects = [NSArray arrayWithObjects:self.user_id,self.username,self.email,self.first_name,self.last_name,self.location,self.created_date,self.status, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"id",@"username", @"email",@"first_name",@"last_name",@"location",@"created_date",@"status", nil];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return userDict;
}

-(NSData*)getUserJSONData{
    
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:[self getUserDictonary] forKey:@"new_user"];
    
    NSLog(@"User jsonDict:%@",jsonDict);
    NSError *error;
    NSData* requestData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&error];
    return requestData;
}

-(BOOL)saveUserData{
    
    NSString *filePath = [DOC_FOLDER_PATH stringByAppendingPathComponent:USER_PLIST];
	NSMutableDictionary *data = [[self getUserDictonary] mutableCopy];
    
	return [data writeToFile:filePath atomically:YES];
}

-(void)print{
    
    NSLog(@"user_id :%@",self.user_id);
    NSLog(@"username :%@",self.username);
    NSLog(@"email :%@",self.email);
    
    NSLog(@"first_name :%@",self.first_name);
    NSLog(@"last_name :%@",self.last_name);
    NSLog(@"last_name :%@",self.middle_name);
    NSLog(@"last_name :%@",self.name);
    
    NSLog(@"location :%@",self.location);
    NSLog(@"created_date :%@",self.created_date);
    NSLog(@"status :%@",self.status);
}

@end
