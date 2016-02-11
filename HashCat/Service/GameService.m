//
//  GameService.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "GameService.h"
#import "Global.h"

@implementation GameService

+ (void) categoriesWithDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/game/categories?token=%@&locale=%@", strUserToken, [[Utils sharedObject] getCurrentLocale]]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) mashCategory:(long) lCategoryId withCache:(bool) bCache withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/game/mash?categoryId=%@&token=%@&locale=%@",  [NSString stringWithFormat:@"%ld", lCategoryId], strUserToken, [[Utils sharedObject] getCurrentLocale]]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) reportPhoto:(long) lPhotoId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/game/report?photoId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) voteWinner:(long) lWinnerId withLooser:(long) lLooserId withCategory:(long) lCategoryId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    if (lLooserId == -1)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/game/vote?winnerId=%@&categoryId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lWinnerId], [NSString stringWithFormat:@"%ld", lCategoryId], strUserToken]];
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/game/vote?winnerId=%@&looserId=%@&categoryId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lWinnerId], [NSString stringWithFormat:@"%ld", lLooserId], [NSString stringWithFormat:@"%ld", lCategoryId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

@end
