//
//  BadgeEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BreedEntity;
@class CountryEntity;

@interface BadgeEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, strong) NSString* m_strCategory;
@property (nonatomic, strong) NSString* m_strName;
@property (nonatomic, strong) NSString* m_strDescription;
@property (nonatomic, assign) int m_nAge;
@property (nonatomic, assign) int m_nRankingPosition;
@property (nonatomic, assign) long m_nLikes;
@property (nonatomic, strong) NSString* m_strTrigger;
@property (nonatomic, strong) NSString* m_strType;
@property (nonatomic, strong) BreedEntity* m_breed;
@property (nonatomic, assign) int m_nCalculated;
@property (nonatomic, assign) int m_nValue;
@property (nonatomic, assign) int m_nWin;
@property (nonatomic, strong) NSString* m_strRankingType;
@property (nonatomic, strong) NSArray* m_arrFollowings;
@property (nonatomic, strong) NSArray* m_arrFollowers;
@property (nonatomic, strong) CountryEntity* m_country;


-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
