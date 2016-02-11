//
//  UserEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PhotoEntity;
@class CountryEntity;

@interface UserEntity : NSObject

@property (nonatomic, strong) NSString* m_strAccessToken;
@property (nonatomic, strong) NSString* m_strActive;

@property (nonatomic, strong) NSString* m_strAvatarUrl;
@property (nonatomic, assign) long long m_nBirth;
@property (nonatomic, strong) CountryEntity* m_country;
@property (nonatomic, strong) NSString* m_strEmail;

@property (nonatomic, strong) NSString* m_strFacebookId;
@property (nonatomic, strong) NSString* m_strFirstName;
@property (nonatomic, strong) NSString* m_strLastName;

@property (nonatomic, strong) NSMutableArray* m_arrFollowings;

@property (nonatomic, assign) int m_nFollowingCnt;
@property (nonatomic, strong) NSString* m_strGender;

@property (nonatomic, strong) NSString* m_strLastLogin;
@property (nonatomic, assign) long long m_nID;
@property (nonatomic, strong) NSString* m_strLatitude;
@property (nonatomic, strong) NSString* m_strLongitude;

@property (nonatomic, strong) PhotoEntity* m_userProfilePhotoEntity;

@property (nonatomic, strong) NSMutableArray* m_arrProfiles;
@property (nonatomic, strong) NSMutableArray* m_arrBadgesAcquired;

@property (nonatomic, assign) int m_nReportCnt;
@property (nonatomic, strong) NSString* m_strToken;
@property (nonatomic, strong) NSString* m_strUsername;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
