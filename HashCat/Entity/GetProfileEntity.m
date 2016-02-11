//
//  GetProfileEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "GetProfileEntity.h"
#import "Global.h"

@implementation GetProfileEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    self.m_arrBadgesAcquired = [[NSMutableArray alloc] init];
    self.m_arrFollowers = [[NSMutableArray alloc] init];
    self.m_arrPhotos = [[NSMutableArray alloc] init];
    
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nId = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_nAgeInMonths = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"ageInMonths"]] integerValue];
            self.m_nPhotosCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"photosCount"]] integerValue];
            self.nFollowersCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"followersCount"]] integerValue];
            self.m_nBirthDate = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"birth"]] integerValue];
            self.m_breed = [[BreedEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"breed"]];
            self.m_strCaminhoThumbnailLink = [dictInfo valueForKey:@"caminhoThumbnail"];
            self.m_strUsername = [dictInfo valueForKey:@"username"];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.m_country = [[CountryEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"country"]];
            self.m_strName = [dictInfo valueForKey:@"name"];
            
            NSArray* tmpBadgesAcquired = [dictInfo valueForKey:@"badgesAcquired"];
            for (int nIdx = 0; nIdx < tmpBadgesAcquired.count; nIdx++)
            {
                NSDictionary* dictOne = [tmpBadgesAcquired objectAtIndex:nIdx];
                BadgesAcquiredEntity* badgeAcquiredEntity = [[BadgesAcquiredEntity alloc] initWithDictInfo:dictOne];
                
                [self.m_arrBadgesAcquired addObject:badgeAcquiredEntity];
            }

            NSArray* tmpPhotos = [dictInfo valueForKey:@"photos"];

            //sort photos
            NSString* strToSortBy = @"id";
            NSArray* arraySorted = [tmpPhotos sortedArrayUsingComparator:^(id obj1, id obj2) {
                NSString* s1 = [obj1 objectForKey:strToSortBy];
                NSString* s2 = [obj2 objectForKey:strToSortBy];
                
                long long lStr1 = [s1 longLongValue];
                long long lStr2 = [s2 longLongValue];
                
                NSComparisonResult result;
                
                if (lStr1 < lStr2) result = NSOrderedDescending;
                else if (lStr1 == lStr2) result = NSOrderedSame;
                else if (lStr1 > lStr2) result = NSOrderedAscending;
                //                {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
                
                return result;
                //        return [s1 caseInsensitiveCompare:s2];
            }];

            for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
            {
                NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
                PhotoEntity* photoEntity = [[PhotoEntity alloc] initWithDictInfo:dictOne];
                if (photoEntity.m_nProfilePhoto == 1) continue;
                
                [self.m_arrPhotos addObject:photoEntity];
            }

            NSArray* tmpFollowers = [dictInfo valueForKey:@"followers"];
            for (int nIdx = 0; nIdx < tmpFollowers.count; nIdx++)
            {
                NSDictionary* dictOne = [tmpFollowers objectAtIndex:nIdx];
                FollowerEntity* followerEntity = [[FollowerEntity alloc] initWithDictInfo:dictOne];
                
                [self.m_arrFollowers addObject:followerEntity];
            }

            self.m_owner = [[OwnerEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"owner"]];
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
