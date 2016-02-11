//
//  FeedService.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface FeedService : NSObject

+ (void) userIdByEmail:(NSString *) strEmail withDelegate:(id) pObj;
+ (void) userIdByFacebookId:(NSString *) strFacebookId withDelegate:(id) pObj;
+ (void) listAllBreedsWithDelegate:(id) pObj;
+ (void) getBadge:(long) lBadgeId WithDelegate:(id) pObj;
+ (void) getBadgesPerType:(BadgeTriggerType) nBadgeType WithDelegate:(id) pObj;
+ (void) countriesWithDelegate:(id) pObj;

+ (void) signUpWithEmail:(NSMutableDictionary *) dictRequest editing:(NSString *) strEditing withDelegate:(id) pObj;
+ (void) signUpWithFB:(NSMutableDictionary *) dictRequest editing:(NSString *)strEditing withDelegate:(id) pObj;
+ (void) logInWithUsername:(NSString *) strUsername withPass:(NSString *) strPass withPushID:(NSString *) strPushId withModel:(NSString *) strModel withDelegate:(id) pObj;
+ (void) changePasswordWithEmail:(NSString *) strEmail withOldPass:(NSString *) strOldPass withNewPass:(NSString *) strNewPass withDelegate:(id) pObj;

+ (void) addProfile:(NSMutableDictionary *) dictRequest editing:(NSString *) strEditing profileId:(long) lProfileId withDelegate:(id) pObj;
+ (void) getProfile:(long) lProfileId withUsername:(NSString *) strUsername withDelegate:(id) pObj;

+ (void) getUserProfile:(long) lProfileId withUsername:(NSString *) strUsername withDelegate:(id) pObj;

+ (void) getNotificationsWithSiceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) postWithDescription:(NSString *) strDescription withCategories:(NSString *) strCategories withImage:(UIImage *) postImage withProfileId:(long) lProfileId withDelegate:(id) pObj;
+ (void) getFeedWithPhotoId:(long) lPhotoId withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) getCommentsWithPhotoId:(long) lPhotoId withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) comment:(long) lPhotoId withComment:(NSString *) strComment withDelegate:(id) pObj;
+ (void) likePhoto:(long) lPhotoId withDelegate:(id) pObj;
+ (void) followCat:(long) lprofileIdBeingFollowed withDelegate:(id) pObj;

+ (void) latestProfiles:(long) lBadgeId withDelegate:(id) pObj;
+ (void) latestUsers:(long) lBadgeId withDelegate:(id) pObj;

+ (void) following:(long) lUserIdFollowing withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) followers:(long) lProfileIdFollowers withSinceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;

+ (void) suggestionsWithDelegate:(id) pObj;
+ (void) followAllWithDelegate:(id) pObj;

+ (void) suggestionsBasedOnFriendsLikes:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) suggestionsBasedOnFriendsFollows:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;

+ (void) getLikes:(long) lPhotoId siceId:(long) lSinceId beforeId:(long) lBeforeId withDelegate:(id) pObj;

+ (void) autoLoginWithEmail:(NSString *) strEmail withFBId:(NSString *) strFBId withPushId:(NSString *) strPushId withModel:(NSString *) strModel withIMEI:(NSString *) strIMEI withDelegate:(id) pObj;

+ (void) removePhoto:(long) lPhotoId withPassword:(NSString *) strPassword withDelegate:(id) pObj;

+ (void) removeProfile:(long) lProfileId withPassword:(NSString *) strPassword withDelegate:(id) pObj;

+ (void) connectFacebook:(NSString *) strEmail withFacebookId:(NSString *) strFBId withAccessToken:(NSString *) strAccessToken withPassword:(NSString *) strPassword withReconnecting:(NSString *) strReconnecting withDelegate:(id) pObj;

@end
