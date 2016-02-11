//
//  FollowEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FollowEntity.h"
#import "Global.h"

@implementation FollowEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nApproved = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"approved"]] integerValue];
            self.m_nDate = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"date"]] longLongValue];
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_profile = [[ProfileEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"profile"]];
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
