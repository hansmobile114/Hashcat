//
//  FollowerEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ProfileEntity;
@class UserEntity;

@interface FollowerEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, assign) int m_nApproved;
@property (nonatomic, assign) long long m_nDate;
@property (nonatomic, strong) ProfileEntity* m_profile;
@property (nonatomic, strong) UserEntity* m_user;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
