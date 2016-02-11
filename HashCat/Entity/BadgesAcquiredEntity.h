//
//  BadgesAcquiredEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UserEntity;
@class BadgeEntity;

@interface BadgesAcquiredEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, strong) UserEntity* m_user;
@property (nonatomic, assign) long long m_nDate;
@property (nonatomic, strong) BadgeEntity* m_badge;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
