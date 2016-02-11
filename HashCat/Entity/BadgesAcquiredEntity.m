//
//  BadgesAcquiredEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "BadgesAcquiredEntity.h"
#import "Global.h"

@implementation BadgesAcquiredEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_nDate = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"date"]] integerValue];
            self.m_badge = [[BadgeEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"badge"]];
            self.m_user = [[UserEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"user"]];
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
