//
//  GetProfileEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ProfileEntity;
@class OwnerEntity;
@class BadgesAcquiredEntity;
@class FollowerEntity;
@class BreedEntity;
@class CountryEntity;

@interface GetProfileEntity : NSObject

@property (nonatomic, assign) int m_nId;

@property (nonatomic, strong) NSString* m_strDescription;
@property (nonatomic, assign) int m_nAgeInMonths;
@property (nonatomic, assign) int m_nPhotosCnt;
@property (nonatomic, assign) int nFollowersCnt;
@property (nonatomic, strong) OwnerEntity* m_owner;
@property (nonatomic, assign) long long m_nBirthDate;
@property (nonatomic, strong) BreedEntity* m_breed;
@property (nonatomic, strong) NSString* m_strCaminhoThumbnailLink;
@property (nonatomic, strong) NSMutableArray* m_arrBadgesAcquired;
@property (nonatomic, strong) NSString* m_strUsername;
@property (nonatomic, strong) NSMutableArray* m_arrPhotos;
@property (nonatomic, strong) NSMutableArray* m_arrFollowers;
@property (nonatomic, strong) CountryEntity* m_country;
@property (nonatomic, strong) NSString* m_strName;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
