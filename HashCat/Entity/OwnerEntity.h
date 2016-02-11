//
//  OwnerEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PhotoEntity;
@class CountryEntity;

@interface OwnerEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, assign) int m_nFollowingCount;
@property (nonatomic, strong) NSString* m_strActive;
@property (nonatomic, strong) NSString* m_strUsername;
@property (nonatomic, strong) NSString* m_strFirstName;
@property (nonatomic, strong) NSString* m_strLastName;
@property (nonatomic, strong) NSArray* m_arrReports;
@property (nonatomic, strong) PhotoEntity* m_photo;
@property (nonatomic, strong) CountryEntity* m_country;
@property (nonatomic, strong) NSString* m_strAvatarUrl;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
