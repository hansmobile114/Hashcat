//
//  NotificationEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "NotificationEntity.h"
#import "Global.h"

@implementation NotificationEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_nPhotoId = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"photoId"]] integerValue];
            self.m_nFromUserID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"fromUser"]] integerValue];
            self.m_nFirst = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"first"]] integerValue];
            self.m_nRead = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"read"]] integerValue];
            self.m_nDate = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"date"]] longLongValue];
            self.m_strDestinationName = [self checkAvaiablityForString:[dictInfo valueForKey:@"destinationName"]];
            self.m_strDeatilImageLink = [self checkAvaiablityForString:[dictInfo valueForKey:@"detailImageLink"]];
            self.m_strActionType = [self checkAvaiablityForString:[dictInfo valueForKey:@"actionType"]];
            self.m_strProfileImageLink = [self checkAvaiablityForString:[dictInfo valueForKey:@"profileImageLink"]];
            self.m_strText = [self checkAvaiablityForString:[dictInfo valueForKey:@"text"]];
            self.m_badge = [[BadgeEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"badge"]];
            self.m_owner = [[OwnerEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"destination"]];
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

- (NSString *) checkAvaiablityForString:(id) pObj
{
    if ([pObj isKindOfClass:[NSNull class]])
        return @"";
    else
        return pObj;
}

@end
