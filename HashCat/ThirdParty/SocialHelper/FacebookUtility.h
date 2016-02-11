//
//  FacebookUtility.h
//  NewFBapiDemo
//
//  Created by Jignesh on 15/05/13.
//  Copyright (c) 2013 Jignesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

#define FBID @"1430264720576632"

@interface FacebookUtility : NSObject
{
    
}

@property (nonatomic, strong) FBSDKLoginManager* m_fbLoginManager;

//init and shared object
-(id) init;
+ (FacebookUtility *)sharedObject;
//for login chek
-(BOOL)isLogin;
//get fb token
-(NSString *)getFBToken;
//logout from FB
- (void) logoutFromFacebook;

@end
