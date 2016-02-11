//
//  GameCategoryEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "GameCategoryEntity.h"
#import "Global.h"

@implementation GameCategoryEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_bActive = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"active"]] boolValue];
            self.m_bSelectable = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"selectable"]] boolValue];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.m_strName = [dictInfo valueForKey:@"name"];
            self.m_strPhotoLink = [dictInfo valueForKey:@"photoLink"];
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
