//
//  NotificationEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OwnerEntity;
@class BadgeEntity;

@interface NotificationEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, assign) int m_nPhotoId;
@property (nonatomic, strong) NSString * m_strDestinationName;
@property (nonatomic, strong) NSString * m_strDeatilImageLink;
@property (nonatomic, assign) long m_nFromUserID;
@property (nonatomic, assign) int m_nFirst;
@property (nonatomic, assign) int m_nRead;
@property (nonatomic, assign) long long m_nDate;
@property (nonatomic, strong) NSString * m_strActionType;
@property (nonatomic, strong) NSString * m_strProfileImageLink;
@property (nonatomic, strong) NSString * m_strText;
@property (nonatomic, strong) BadgeEntity* m_badge;
@property (nonatomic, strong) OwnerEntity* m_owner;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
