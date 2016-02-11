//
//  UserEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "UserEntity.h"
#import "Global.h"

@implementation UserEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    self.m_arrFollowings = [[NSMutableArray alloc] init];
    self.m_arrProfiles = [[NSMutableArray alloc] init];
    self.m_arrBadgesAcquired = [[NSMutableArray alloc] init];
    
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_strAccessToken = [dictInfo valueForKey:@"accessToken"];
            self.m_strActive = [dictInfo valueForKey:@"active"];
            self.m_strAvatarUrl = [dictInfo valueForKey:@"avatarUrl"];
            self.m_nBirth = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"birth"]] longLongValue];
            self.m_country = [[CountryEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"country"]];
            self.m_strEmail = [dictInfo valueForKey:@"email"];
            self.m_strFacebookId = [dictInfo valueForKey:@"facebookId"];
            self.m_strFirstName = [dictInfo valueForKey:@"firstName"];
            
            NSArray* arrayTemp = [dictInfo valueForKey:@"following"];
            for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
            {
                NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
                FollowEntity* followEntity = [[FollowEntity alloc] initWithDictInfo:dictOne];
                
                [self.m_arrFollowings addObject:followEntity];
            }
            
            self.m_nFollowingCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"followingCount"]] integerValue];
            self.m_strGender = [dictInfo valueForKey:@"gender"];
            self.m_nID = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] longLongValue];
            self.m_strLastLogin = [dictInfo valueForKey:@"lastLogin"];
            self.m_strLastName = [dictInfo valueForKey:@"lastName"];
            self.m_strLatitude = [dictInfo valueForKey:@"latitude"];
            self.m_strLongitude = [dictInfo valueForKey:@"longitude"];
            self.m_userProfilePhotoEntity = [[PhotoEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"photo"]];
            
            arrayTemp = [dictInfo valueForKey:@"profiles"];
            for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
            {
                NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
                ProfileEntity* profileEntity = [[ProfileEntity alloc] initWithDictInfo:dictOne];
                
                [self.m_arrProfiles addObject:profileEntity];
            }
            
            arrayTemp = [dictInfo valueForKey:@"badgesAcquired"];
            for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
            {
                NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
                BadgesAcquiredEntity* badgeAcquiredEntity = [[BadgesAcquiredEntity alloc] initWithDictInfo:dictOne];
                
                [self.m_arrBadgesAcquired addObject:badgeAcquiredEntity];
            }

            self.m_nReportCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"reports"]] integerValue];
            self.m_strToken = [dictInfo valueForKey:@"token"];
            self.m_strUsername = [dictInfo valueForKey:@"username"];
        }
    }
    
    return self;
}

- (NSString *) checkAvaiablityForNumber:(id) pObj
{
    if ([pObj isKindOfClass:[NSNull class]])
        return @"0";
    else
        return pObj;
}

@end
