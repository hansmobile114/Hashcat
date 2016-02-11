//
//  FacebookUtility.m
//  NewFBapiDemo
//
//  Created by Jignesh on 15/05/13.
//  Copyright (c) 2013 Jignesh. All rights reserved.
//

#import "FacebookUtility.h"

@implementation FacebookUtility

@synthesize m_fbLoginManager;


#pragma mark -
#pragma mark - Init And Shared Object

+ (FacebookUtility *)sharedObject
{
    static FacebookUtility *objFBUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objFBUtility = [[FacebookUtility alloc] init];
    });
    return objFBUtility;
}

-(id) init
{
    if((self = [super init]))
    {
        m_fbLoginManager = [[FBSDKLoginManager alloc] init];
    }
    
    return self;
}

-(BOOL)isLogin
{
    BOOL isLogin=FALSE;
    if ([FBSDKAccessToken currentAccessToken]) {
        isLogin=TRUE;
    }
    return isLogin;
}

-(NSString *)getFBToken
{
    return [FBSDKAccessToken currentAccessToken].tokenString;
}

- (void) logoutFromFacebook
{
    [m_fbLoginManager logOut];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_FB_TOKEN];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

@end
