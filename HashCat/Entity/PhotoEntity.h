//
//  PhotoEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileEntity;
@class CategoriesEntity;

@interface PhotoEntity : NSObject

@property (nonatomic, assign) int m_nCommentsCount;
@property (nonatomic, assign) long long m_nDate;
@property (nonatomic, strong) NSString* m_strDescription;
@property (nonatomic, assign) long long m_nID;
@property (nonatomic, assign) int m_nLikeCnt;
@property (nonatomic, strong) NSString* m_strPhotoLink;
@property (nonatomic, assign) float m_fMashs;
@property (nonatomic, strong) ProfileEntity* m_profile;
@property (nonatomic, assign) int m_nProfilePhoto;
@property (nonatomic, assign) int m_nReportCnt;
@property (nonatomic, assign) bool m_bUserAlreadyLikes;
@property (nonatomic, assign) float m_fWins;
@property (nonatomic, strong) NSMutableArray* m_arrCategories;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
