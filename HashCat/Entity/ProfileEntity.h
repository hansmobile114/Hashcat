//
//  ProfileEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BreedEntity;
@class CountryEntity;

@interface ProfileEntity : NSObject

@property (nonatomic, assign) int m_nAgeInMonths;
@property (nonatomic, assign) long long m_nBirthDate;
@property (nonatomic, strong) BreedEntity* m_breed;
@property (nonatomic, strong) NSString* m_strCaminhoThumbnailLink;
@property (nonatomic, strong) CountryEntity* m_country;
@property (nonatomic, strong) NSString* m_strDescription;
@property (nonatomic, assign) int nFollowersCnt;
@property (nonatomic, assign) int m_nId;
@property (nonatomic, strong) NSString* m_strName;
@property (nonatomic, assign) int m_nPhotosCnt;
@property (nonatomic, strong) NSString* m_strUsername;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
