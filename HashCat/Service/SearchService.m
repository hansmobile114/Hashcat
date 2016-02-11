//
//  SearchService.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "SearchService.h"
#import "Global.h"

@implementation SearchService

+ (void) searchProfiles:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;

    NSString* strRequestLink = @"";
    if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/profiles?name=%@&token=%@", strName, strUserToken]];
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/profiles?name=%@&beforeId=%@&token=%@", strName, [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) searchHashtags:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/hashtags?hashtag=%@&token=%@", strName, strUserToken]];
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/hashtags?hashtag=%@&beforeId=%@&token=%@", strName, [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }

    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
    
}

+ (void) searchCategory:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/category?category=%@&token=%@&locale=%@", strName, strUserToken, [[Utils sharedObject] getCurrentLocale]]];
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/search/category?category=%@&beforeId=%@&token=%@&locale=%@", strName, [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken, [[Utils sharedObject] getCurrentLocale]]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
    
}

@end
