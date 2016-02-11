//
//  OwnerEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "OwnerEntity.h"
#import "Global.h"

@implementation OwnerEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_photo = [[PhotoEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"photo"]];
            self.m_country = [[CountryEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"country"]];
            self.m_strUsername = [dictInfo valueForKey:@"username"];
            self.m_strActive = [dictInfo valueForKey:@"active"];
            self.m_strFirstName = [dictInfo valueForKey:@"firstName"];
            self.m_strLastName = [dictInfo valueForKey:@"lastName"];
            self.m_strAvatarUrl = [dictInfo valueForKey:@"avatarUrl"];
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
