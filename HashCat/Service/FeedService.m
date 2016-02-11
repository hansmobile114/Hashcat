//
//  FeedService.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedService.h"
#import "Global.h"

@implementation FeedService

+ (void) userIdByFacebookId:(NSString *) strFacebookId withDelegate:(id) pObj
{
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/userIdByFacebookId?facebookId=%@", strFacebookId]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) userIdByEmail:(NSString *) strEmail withDelegate:(id) pObj
{
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/userIdByEmail?email=%@", strEmail]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) listAllBreedsWithDelegate:(id) pObj
{
    NSString* strTokenForCountrues = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/breeds?token=%@", strTokenForCountrues]];
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) getBadge:(long) lBadgeId WithDelegate:(id) pObj
{
    NSString* strToken = g_Delegate.m_currentUser.m_strToken;

    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/badge?badgeId=%ld&token=%@", lBadgeId, strToken]];
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) getBadgesPerType:(BadgeTriggerType) nBadgeType WithDelegate:(id) pObj
{
    NSString* strToken = g_Delegate.m_currentUser.m_strToken;

    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/badges?badgeTypes=%@&token=%@", getBadgeTriggerType(nBadgeType), strToken]];
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) countriesWithDelegate:(id) pObj
{
    NSString* strTokenForCountrues = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/countries?token=%@", strTokenForCountrues]];
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) changePasswordWithEmail:(NSString *) strEmail withOldPass:(NSString *) strOldPass withNewPass:(NSString *) strNewPass withDelegate:(id) pObj
{
    NSString* strToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/changePassword?email=%@&oldPassword=%@&newPassword=%@&token=%@", strEmail, strOldPass, strNewPass, strToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) signUpWithEmail:(NSMutableDictionary *) dictRequest editing:(NSString *) strEditing withDelegate:(id) pObj
{
    NSString* strEmail = [dictRequest valueForKey:@"email"];
    NSString* strUsername = [dictRequest valueForKey:@"username"];
    NSString* strPassword = [dictRequest valueForKey:@"password"];
    UIImage* imageUser = [dictRequest valueForKey:@"thumbnailProfile"];
    NSString* strGender = [dictRequest valueForKey:@"gender"];
    NSString* strBirth = [dictRequest valueForKey:@"birth"];
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:@"/feed/signup"];
    strRequestLink = [NSString stringWithFormat:@"%@?locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];

    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strUsername forKey:@"username"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strGender forKey:@"gender"];
    [request setPostValue:strBirth forKey:@"birth"];
    [request setPostValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
    [request setPostValue:[[UIDevice currentDevice] name] forKey:@"model"];
    [request setPostValue:@"AD" forKey:@"countrycode"];
    [request setPostValue:strEditing forKey:@"editing"];
    
    if (imageUser)
    {
        NSData* imageData = UIImageJPEGRepresentation(imageUser, 0.7f);
        [request addData:imageData withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"thumbnailProfile"];
    }
    
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setDelegate:pObj];

    [request startAsynchronous];
}

+ (void) signUpWithFB:(NSMutableDictionary *) dictRequest editing:(NSString *) strEditing withDelegate:(id) pObj
{
    NSString* strFBId = [dictRequest valueForKey:@"facebookId"];
    NSString* strAccessToken = [dictRequest valueForKey:@"accessToken"];
    NSString* strFirstName = [dictRequest valueForKey:@"firstName"];
    NSString* strLastName = [dictRequest valueForKey:@"lastName"];
    NSString* strBirth = [dictRequest valueForKey:@"birth"];
    NSString* strGender = [dictRequest valueForKey:@"gender"];
    NSString* strEmail = [dictRequest valueForKey:@"email"];
    NSString* strUsername = [dictRequest valueForKey:@"username"];
    NSString* strPassword = [dictRequest valueForKey:@"password"];
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:@"/feed/signup"];
    strRequestLink = [NSString stringWithFormat:@"%@?locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    
    [request setPostValue:strEmail forKey:@"email"];
    [request setPostValue:strUsername forKey:@"username"];
    [request setPostValue:strPassword forKey:@"password"];
    [request setPostValue:strFBId forKey:@"facebookId"];
    [request setPostValue:strAccessToken forKey:@"accessToken"];
    [request setPostValue:strFirstName forKey:@"firstName"];
    [request setPostValue:strLastName forKey:@"lastName"];
    [request setPostValue:strGender forKey:@"gender"];
    [request setPostValue:strBirth forKey:@"birth"];
    [request setPostValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
    [request setPostValue:[[UIDevice currentDevice] name] forKey:@"model"];
    [request setPostValue:@"AD" forKey:@"countrycode"];
    [request setPostValue:strEditing forKey:@"editing"];

    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    [request startAsynchronous];
}

+ (void) logInWithUsername:(NSString *) strUsername withPass:(NSString *) strPass withPushID:(NSString *) strPushId withModel:(NSString *) strModel withDelegate:(id) pObj;
{
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/login?username=%@&password=%@&pushId=%@&model=%@", strUsername, strPass, strPushId, strModel]];
    
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];

    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) addProfile:(NSMutableDictionary *) dictRequest editing:(NSString *) strEditing profileId:(long) lProfileId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strUsername = [dictRequest valueForKey:@"username"];
    NSString* strName = [dictRequest valueForKey:@"name"];
    NSString* strDescription = [dictRequest valueForKey:@"description"];
    NSString* strBreedId = [dictRequest valueForKey:@"breedId"];
    NSString* strBirth = [dictRequest valueForKey:@"birth"];
    NSString* strCountryId = [dictRequest valueForKey:@"countryId"];
    UIImage* imageThumb = [dictRequest valueForKey:@"thumbnailProfile"];
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/addProfile?token=%@", strUserToken]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    
    [request setPostValue:strUsername forKey:@"username"];
    [request setPostValue:strName forKey:@"name"];
    [request setPostValue:strDescription forKey:@"description"];
    [request setPostValue:strBreedId forKey:@"breedId"];
    [request setPostValue:strBirth forKey:@"birth"];
    [request setPostValue:strCountryId forKey:@"countryId"];
    [request setPostValue:strEditing forKey:@"editing"];
    [request setPostValue:[NSString stringWithFormat:@"%lld", g_Delegate.m_currentUser.m_nID] forKey:@"userId"];
    if ([strEditing isEqualToString:@"false"])
        [request setPostValue:[NSString stringWithFormat:@"%lld", g_Delegate.m_currentUser.m_userProfilePhotoEntity.m_nID] forKey:@"profileId"];
    else
        [request setPostValue:[NSString stringWithFormat:@"%ld", lProfileId] forKey:@"profileId"];
    
    if (imageThumb)
    {
        NSData* imageData = UIImageJPEGRepresentation(imageThumb, 0.7f);
        [request addData:imageData withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"thumbnailProfile"];
    }
    
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    [request startAsynchronous];

}

+ (void) getProfile:(long) lProfileId withUsername:(NSString *) strUsername withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;

    NSString* strRequestLink = @"";
    if (lProfileId == -1)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/profile?username=%@&token=%@", strUsername, strUserToken]];
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/profile?profileId=%@&username=%@&token=%@", [NSString stringWithFormat:@"%ld", lProfileId], strUsername, strUserToken]];
    }
    
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];

    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) getUserProfile:(long) lProfileId withUsername:(NSString *) strUsername withDelegate:(id) pObj;
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/user?userProfileId=%@&edit=false&token=%@", [NSString stringWithFormat:@"%ld", lProfileId], strUserToken]];
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) getNotificationsWithSiceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/notifications?edit=false&token=%@", strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/notifications?beforeId=%@&edit=false&token=%@", [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/notifications?sinceId=%@&edit=false&token=%@", [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];

    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) getFeedWithPhotoId:(long) lPhotoId withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    if (lPhotoId == -1)
    {
        if (lSinceId == 0 && lBeforeId == 0)
        {
            strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/feed?token=%@", strUserToken]];
        }
        else if (lSinceId == 0)
        {
            strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/feed?beforeId=%@&token=%@", [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
        }
        else if (lBeforeId == 0)
        {
            strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/feed?sinceId=%@&token=%@", [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
        }
    }
    else
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/feed?photoId=%@&token=%@", [NSString stringWithFormat:@"%ld", lPhotoId], strUserToken]];
    }
    
    strRequestLink = [NSString stringWithFormat:@"%@&locale=%@", strRequestLink, [[Utils sharedObject] getCurrentLocale]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) getCommentsWithPhotoId:(long) lPhotoId withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/comments?photoId=%@&token=%@", [NSString stringWithFormat:@"%ld", lPhotoId], strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/comments?photoId=%@&beforeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/comments?photoId=%@&sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) following:(long) lUserIdFollowing withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/following?userIdFollowing=%@&token=%@", [NSString stringWithFormat:@"%ld", lUserIdFollowing], strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/following?userIdFollowing=%@&beforeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lUserIdFollowing], [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/following?userIdFollowing=%@&sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lUserIdFollowing], [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) followers:(long) lProfileIdFollowers withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/followers?profileIdFollowers=%@&token=%@", [NSString stringWithFormat:@"%ld", lProfileIdFollowers], strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/followers?profileIdFollowers=%@&beforeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lProfileIdFollowers], [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/followers?profileIdFollowers=%@&sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lProfileIdFollowers], [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) postWithDescription:(NSString *) strDescription withCategories:(NSString *) strCategories withImage:(UIImage *) postImage withProfileId:(long) lProfileId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/post?token=%@", strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];

    [request setPostValue:strDescription forKey:@"description"];
    [request setPostValue:strCategories forKey:@"categories"];
    [request setPostValue:[NSString stringWithFormat:@"%ld", lProfileId] forKey:@"profileId"];
    
    if (postImage)
    {
        NSData* imageData = UIImageJPEGRepresentation(postImage, 0.7f);
        [request addData:imageData withFileName:@"avatar.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
    }

    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    [request startAsynchronous];
}

+ (void) comment:(long) lPhotoId withComment:(NSString *) strComment withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/comment?photoId=%@&comment=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], strComment, strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) likePhoto:(long) lPhotoId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/like?photoId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) followCat:(long) lprofileIdBeingFollowed withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/follow?profileIdBeingFollowed=%@&token=%@",  [NSString stringWithFormat:@"%ld", lprofileIdBeingFollowed], strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) latestProfiles:(long) lBadgeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/latestProfiles?badgeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lBadgeId], strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) latestUsers:(long) lBadgeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/latestUsers?badgeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lBadgeId], strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) suggestionsWithDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestions?token=%@", strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) followAllWithDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/followAll?token=%@", strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) suggestionsBasedOnFriendsLikes:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsLikes?token=%@", strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsLikes?beforeId=%@&token=%@", [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsLikes?sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];
}

+ (void) suggestionsBasedOnFriendsFollows:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsFollows?token=%@", strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsFollows?beforeId=%@&token=%@", [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/suggestionsBasedOnFriendsFollows?sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) getLikes:(long) lPhotoId siceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    if (lSinceId == 0 && lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/likes?photoId=%@&token=%@", [NSString stringWithFormat:@"%ld", lPhotoId], strUserToken]];
    }
    else if (lSinceId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/likes?photoId=%@&beforeId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], [NSString stringWithFormat:@"%ld", lBeforeId], strUserToken]];
    }
    else if (lBeforeId == 0)
    {
        strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/likes?photoId=%@&sinceId=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], [NSString stringWithFormat:@"%ld", lSinceId], strUserToken]];
    }
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) autoLoginWithEmail:(NSString *) strEmail withFBId:(NSString *) strFBId withPushId:(NSString *) strPushId withModel:(NSString *) strModel withIMEI:(NSString *) strIMEI withDelegate:(id) pObj
{
    NSString* strRequestLink = [NSString stringWithFormat:@"/feed/autologin?pushId=%@&model=%@&imei=%@&locale=%@", strPushId, strModel, strIMEI, [[Utils sharedObject] getCurrentLocale]];

    if (strEmail)
        strRequestLink = [NSString stringWithFormat:@"%@&email=%@", strRequestLink, strEmail];
    else
        strRequestLink = [NSString stringWithFormat:@"%@&facebookId=%@", strRequestLink, strFBId];
    
    strRequestLink = [[Utils sharedObject] makeAPIURLString:strRequestLink];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) removePhoto:(long) lPhotoId withPassword:(NSString *) strPassword withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";

    strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/removePhoto?photoId=%@&password=%@&token=%@",  [NSString stringWithFormat:@"%ld", lPhotoId], strPassword, strUserToken]];

    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) removeProfile:(long) lProfileId withPassword:(NSString *) strPassword withDelegate:(id) pObj
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/removeProfile?profileId=%@&password=%@&token=%@",  [NSString stringWithFormat:@"%ld", lProfileId], strPassword, strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

+ (void) connectFacebook:(NSString *) strEmail withFacebookId:(NSString *) strFBId withAccessToken:(NSString *) strAccessToken withPassword:(NSString *) strPassword withReconnecting:(NSString *) strReconnecting withDelegate:(id) pObj;
{
    NSString* strUserToken = g_Delegate.m_currentUser.m_strToken;
    
    NSString* strRequestLink = @"";
    
    strRequestLink = [[Utils sharedObject] makeAPIURLString:[NSString stringWithFormat:@"/feed/connectFacebook?email=%@&facebookId=%@&accessToken=%@&reconnecting=%@&password=%@&token=%@",  strEmail, strFBId, strAccessToken, strReconnecting, strPassword, strUserToken]];
    
    NSURL *url = [NSURL URLWithString:[[Utils sharedObject] urlEncodeWithString:strRequestLink]];
    
    ASIFormDataRequest *request;
    request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:pObj];
    [request setPostFormat:ASIURLEncodedPostFormat];
    
    [request startAsynchronous];

}

@end
