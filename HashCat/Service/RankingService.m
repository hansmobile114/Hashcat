//
//  RankingService.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "RankingService.h"
#import "Global.h"

@implementation RankingService


+ (void) filterWithCategoryId:(long) lCategoryId withBreedId:(long) lBreedId withCountryId:(long) lCountryId withMonthsMin:(int) nMonthsMin withMonthsMax:(int) nMonthsMax withOrderByLikes:(bool) bOrderByLikes withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [NSString stringWithFormat:@"/ranking/filter?token=%@&locale=%@&", strUserToken, [[Utils sharedObject] getCurrentLocale]];
    if (lCategoryId != -1)
        strRequestLink = [NSString stringWithFormat:@"%@categoryId=%@&", strRequestLink, [NSString stringWithFormat:@"%ld", lCategoryId]];

    if (lBreedId != -1)
        strRequestLink = [NSString stringWithFormat:@"%@breedId=%@&", strRequestLink, [NSString stringWithFormat:@"%ld", lBreedId]];

    if (lCountryId != -1)
        strRequestLink = [NSString stringWithFormat:@"%@countryId=%@&", strRequestLink, [NSString stringWithFormat:@"%ld", lCountryId]];

    if (nMonthsMin != -1)
        strRequestLink = [NSString stringWithFormat:@"%@monthsMin=%@&", strRequestLink, [NSString stringWithFormat:@"%d", nMonthsMin]];

    if (nMonthsMax != -1)
        strRequestLink = [NSString stringWithFormat:@"%@monthsMax=%@&", strRequestLink, [NSString stringWithFormat:@"%d", nMonthsMax]];
    
    if (bOrderByLikes)
        strRequestLink = [NSString stringWithFormat:@"%@orderByLikes=true", strRequestLink];
    else
        strRequestLink = [NSString stringWithFormat:@"%@orderByLikes=false", strRequestLink];
    
    
    strRequestLink = [[Utils sharedObject] makeAPIURLString:strRequestLink];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

@end
