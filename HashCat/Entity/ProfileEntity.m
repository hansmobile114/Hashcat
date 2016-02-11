//
//  ProfileEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "ProfileEntity.h"
#import "Global.h"

@implementation ProfileEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            if ([dictInfo valueForKey:@"ageInMonths"])
            self.m_nAgeInMonths = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"ageInMonths"]] integerValue];
            self.m_nBirthDate = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"birth"]] longLongValue];
            self.m_breed = [[BreedEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"breed"]];
            self.m_strCaminhoThumbnailLink = [dictInfo valueForKey:@"caminhoThumbnail"];
            self.m_country = [[CountryEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"country"]];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.nFollowersCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"followersCount"]] integerValue];
            self.m_nId = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_strName = [dictInfo valueForKey:@"name"];
            self.m_strUsername = [dictInfo valueForKey:@"username"];
            self.m_nPhotosCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"photosCount"]] integerValue];
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
