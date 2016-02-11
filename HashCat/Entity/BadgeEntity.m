//
//  BadgeEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "BadgeEntity.h"
#import "Global.h"

@implementation BadgeEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_nAge = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"age"]] integerValue];
            self.m_nRankingPosition = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"rankingPosition"]] integerValue];
            self.m_nLikes = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"likes"]] longLongValue];
            self.m_nCalculated = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"calculated"]] integerValue];
            self.m_nValue = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"value"]] integerValue];
            self.m_nWin = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"wins"]] integerValue];
            self.m_strName = [dictInfo valueForKey:@"name"];
            self.m_strCategory = [dictInfo valueForKey:@"category"];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.m_strTrigger = [dictInfo valueForKey:@"trigger"];
            self.m_strType = [dictInfo valueForKey:@"type"];
            self.m_strRankingType = [dictInfo valueForKey:@"rankingType"];
            self.m_breed = [dictInfo valueForKey:@"breed"];
            self.m_arrFollowings = [dictInfo valueForKey:@"following"];
            self.m_arrFollowers = [dictInfo valueForKey:@"followers"];
            self.m_country = [dictInfo valueForKey:@"country"];
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
